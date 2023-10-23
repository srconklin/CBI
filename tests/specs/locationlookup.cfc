
/**
 * fp Test
 */
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

    /**
     * executes before all suites+specs in the run() method
     */
    function beforeAll(){
        
    }

    /**
     * executes after all suites+specs in the run() method
     */
    function afterAll(){

    }

    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){


        describe( "locationlookup Domain Object", function(){

            beforeEach(function( currentSpec ) {
                //create a default empty sesssion; guest
                oLL = request.beanFactory.getBean("locationlookupbean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oLL" );
            });
           
            it( "component can be created", () => {
				expect( oLL ).toBeComponent();
			} );  

            it( "should have initialized data only; i.e. geochain should be empty", function(){
                expect( oLL.getData().geoChain).toBeEmpty()
            } );
        
                      
            describe( "when performing an Address Lookup", function (){
    
                it( " and the Google Places object was not set then it should throw an error", function(){
                    oLL.performLookup();
                    expect(oLL.getErrors()).NotToBeEmpty();
                  // debug( oLL .getErrors() );
                    expect( oLL.getErrorContext().originalStatus).tobe('invalid_geo_input');
    
                } );
                it( " and the Google Places object does not have the key address components in the JSON, it should throw an error", function(){
                    oLL.setplacesResponse('{"key": "value"}');
                    oLL.performLookup();
                    expect(oLL.getErrors()).NotToBeEmpty();
                    expect( oLL.getErrorContext().originalStatus).tobe('no_address_component');
    
                } );
               
                it( " and the Google Places object does not have both a city and state, it should throw an error", function(){
                    oLL.setplacesResponse('{"address_components":[{"long_name":"Zhub","short_name":"Zhub","types":["locality","political"]}],"formatted_address":"Zhub","geometry":{"location":{"lat":42.3427552,"lng":20.3934388},"viewport":{"south":42.33814975063112,"west":20.37972448750742,"north":42.35074231743481,"east":20.4036712287612}},"place_id":"ChIJcUPvvryzUxMRtRGX0Y9a3jE","html_attributions":[]}');
                    oLL.performLookup();
                    expect(oLL.getErrors()).NotToBeEmpty();
                    expect( oLL.getErrorContext().originalStatus).tobe('no_city_or_country');
                    //expect( oLL.getErrorContext().error.message).tobe('The entry chosen does not contain a valid city and/or country. Please make another selection');
    
                } );
               
                it( " and the Google Places object is valid it should return an array of Geodata with a GID, type and LNM on the city and Country", function(){
                    oLL.setPlacesResponse('{"address_components":[{"long_name":"Houston","short_name":"Houston","types":["locality","political"]},{"long_name":"Harris County","short_name":"Harris County","types":["administrative_area_level_2","political"]},{"long_name":"Texas","short_name":"TX","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]}],"formatted_address":"Houston, TX, USA","geometry":{"location":{"lat":29.7604267,"lng":-95.3698028},"viewport":{"south":29.52362395916238,"west":-95.78808688185201,"north":30.1107319164148,"east":-95.01449596831392}},"place_id":"ChIJAYWNSLS4QIYROwVl894CDco","html_attributions":[]}');
                    oLL.performLookup();
                    expect(oLL.getErrors()).toBeEmpty();
                    var geoChain = oLL.getGeoChain();
                    expect(geoChain).toBeTypeOf('array');
                    expect(geoChain[1]).tohaveKey('GID');
                    expect(geoChain[1]).tohaveKey('Type');
                    expect(geoChain[1]).tohaveKey('LNM');
                    expect(geoChain[1].Type).tobe('1');

                } );
              

            });

           
        });
    }
}
