
/**
 * userService Test
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


        // all your suites go here.
        describe( "User Service", function(){

            beforeEach(function( currentSpec ) {
                //create a default empty sesssion; guest
                structClear(session);
                userService = request.beanFactory.getBean("UserService"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "userService" );
            });
           
           
            it( "component can be created", () => {
				expect( userService ).toBeComponent();
			} );  

            it( "setting a default session, should have a pno = 0", function(){
                userService.defaultUserSession();
                expect( session.pno ).toBe( 0 )
            } );

            it( "when providing a first and last name,we should get an avatar and fullname ", function(){
                userService.defaultUserSession();
                userService.setUserSession( {firstname: 'Scott', lastname: 'Conklin'});
                var udata = userService.getUserSession();
                
                expect(	udata.avatar ).toBe('SC');
                expect(	udata.name ).toBe('Scott Conklin');
                
            } );


        } );
    }

}
