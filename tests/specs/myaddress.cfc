
/**
 * register Test
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
         
        var params = {
            pno:'80845'
        };
            
        var sql = "SET NOCOUNT ON;
            update addresses set street1 = '4123 solway lane', street2 = '', postalcode='77025'
             where pno = :pno;
        ";
        
        var qry = queryExecute( sql, params);
       

    }

    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){


        describe( "Register Domain Object", function(){

            beforeEach(function( currentSpec ) {
                oUA = request.beanFactory.getBean("updateaddressbean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oUA" );
            });
           
            it( "component can be created", () => {
				expect( oUA ).toBeComponent();
			} );  
           
            describe( "when performing a validity test ", function(){

                it( "and pno is missing then it should not validate", function(){
                    
                   // oUA.setPno('');
                    oUA.setAddress1('123 main street');
                    oUA.setAddress2('suite 100');
                    oUA.setPostalCode('77025');
                    oUA.setPLocGID(4);
                    oUA.setPStPGID(3);
                    oUA.setPCyGID(2);
                    
                    expect( oUA.isValid() ).tobeFalse();
                    
                } );


                it( "it should return true, when all fields are correctly set", function(){
                    
                    oUA.setPno('4');
                    oUA.setAddress1('123 main street');
                    oUA.setAddress2('suite 100');
                    oUA.setPostalCode('77025');
                    oUA.setPLocGID(4);
                    oUA.setPStPGID(3);
                    oUA.setPCyGID(2);
                    
                    expect( oUA.isValid() ).tobeTrue();
                } );

            });
           
            describe( "when we try to update my address", function() {
              
                it( " & the user being updated could not be found, it should not allow the update", function(){
                    
                    oUA.setPno('999999');
                    oUA.setAddress1('123 main street');
                    oUA.setAddress2('suite 100');
                    oUA.setPostalCode('77025');
                    oUA.setPLocGID(4);
                    oUA.setPStPGID(3);
                    oUA.setPCyGID(2);

                    oUA.update();
                    
                    expect(oUA.hasErrors()).tobeTrue();
                    expect(oUA.getErrors()).notToBeEmpty(oUA.getErrors());
                    //expect(oUA.getErrors().errorcode).tobe('accountnotfound');
                    //expect (oUA.getErrors()['pno']).toInclude('PNO is missing');
                    expect (oUA.getErrorContext()['status']['pno']).tobe('pnonotfound');


                });
                
                
                it( " & and there are no data validation errors, then it should update the address fields", function(){

                    oUA.setPno('80845');
                    oUA.setAddress1('123 main street');
                    oUA.setAddress2('suite 100');
                    oUA.setPostalCode('77025');
                    oUA.setPLocGID(4);
                    oUA.setPStPGID(3);
                    oUA.setPCyGID(2);

                    oUA.update();

                    saveContent  variable="sql" {writeOutput('
                        SELECT a.street1 
                        FROM addresses a WHERE a.pno= :pno')
                    }
                    
                    var qry = queryExecute( sql, {pno: '80845'});
                    
                    expect( qry.recordCount ).toBe(1);
                    expect( qry.street1 ).toBe('123 main street');
                    
                } );

            });

            

          
        });
    }
}
