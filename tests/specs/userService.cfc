
/**
 * userService Test
 */
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

    /**
     * executes before all suites+specs in the run() method
     */
    function beforeAll(){
        userService = request.beanFactory.getBean("UserService"); 
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

           
            it( "component can be created", () => {
				expect( userService ).toBeComponent();
			} );  


        } );
    }

}
