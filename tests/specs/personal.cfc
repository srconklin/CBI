
/**
 * personal Test
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


        describe( "Personal Domain Object", function(){

            beforeEach(function( currentSpec ) {
                //create a default empty sesssion; guest
                oPersonal = request.beanFactory.getBean("personalbean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oPersonal" );
            });
           
            it( "component can be created", () => {
				expect( oPersonal ).toBeComponent();
			} );  

            describe( "when performing a validity test ", function(){
              
                it( "fields should NOT violate character count limitations", function(){
                                      
                    oPersonal.setfirstname('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pharetra, nibh quis varius imperdiet, odio lorem interdum purus, eget placerat magna lorem in velit. Curabitur sodales dui eu euismod cursus. Ut mollis tellus ac sem luctus, vel malesuada nunc tempor. ');
                    oPersonal.setlastname('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pharetra, nibh quis varius imperdiet, odio lorem interdum purus, eget placerat magna lorem in velit. Curabitur sodales dui eu euismod cursus. Ut mollis tellus ac sem luctus, vel malesuada nunc tempor. ');
                    oPersonal.setEmail('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pharetra, nibh quis varius imperdiet, odio lorem interdum purus, eget placerat magna lorem in velit. Curabitur sodales dui eu euismod cursus. Ut mollis tellus ac sem luctus, vel malesuada nunc tempor. ');
                    oPersonal.setConame('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pharetra, nibh quis varius imperdiet, odio lorem interdum purus, eget placerat magna lorem in velit. Curabitur sodales dui eu euismod cursus. Ut mollis tellus ac sem luctus, vel malesuada nunc tempor. ');
                    oPersonal.setPhone('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pharetra, nibh quis varius imperdiet, odio lorem interdum purus, eget placerat magna lorem in velit. Curabitur sodales dui eu euismod cursus. Ut mollis tellus ac sem luctus, vel malesuada nunc tempor. ');
                    expect( oPersonal.isValid() ).toBeFalse();
                    var errs = oPersonal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('firstname');
                    expect (errs).toHaveKey('lastname');
                    expect (errs).toHaveKey('email');
                    expect (errs).toHaveKey('coname');
                    expect (errs).toHaveKey('phone');
                    expect (oPersonal.getErrorContext()['status']['firstname']).tobe('FirstNametooLong');
                } );
                it( "fields should NOT contain any HTML ", function(){

                    oPersonal.setConame('<b>Hello</b');
                    oPersonal.setfirstName('<b>Hello</b');
                    oPersonal.setlastName('<b>Hello</b');
                    oPersonal.setEmail('<b>Hello</b');

                    expect( oPersonal.isValid() ).toBeFalse();
                    var errs = oPersonal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('coname');
                    expect (errs).toHaveKey('firstname');
                    expect (errs).toHaveKey('lastname');
                    expect (errs).toHaveKey('email');
                    expect (oPersonal.getErrorContext()['status']['firstname']).tobe('noHTML');
                } );

                it( "an invalid email should be rejected  ", function(){
                   
                    oPersonal.setEmail('4asdfgdfgh');
                    expect( oPersonal.isValid() ).toBeFalse();
                    var errs = oPersonal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('email');
                    expect (oPersonal.getErrorContext()['status']['email']).tobe('invalidEmail');
                } );
                it( "invalid phone numbers should be rejected  ", function(){
                   
                    oPersonal.setPhone('garbage');
                   
                    expect( oPersonal.isValid() ).toBeFalse();
                    var errs = oPersonal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('phone');

                    oPersonal.setPhone('ns');

                    expect( oPersonal.isValid() ).toBeFalse();
                    var errs = oPersonal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (oPersonal.getErrorContext()['status']['phone']).tobe('invalidPhone');
                } );


                it( "it should return true, when all fields are correctly set", function(){

                    oPersonal.setfirstname('Fake');
                    oPersonal.setlastname('User');
                    oPersonal.setEmail('fakeuser@company.com ');
                    oPersonal.setConame('copmany');
                    oPersonal.setPhone('713-972-2243');
                    
                    expect( oPersonal.isValid() ).tobeTrue();
                } );

            });
          
        });
    }
}
