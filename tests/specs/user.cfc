
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


        describe( "User Domain Object", function(){

            beforeEach(function( currentSpec ) {
                oUser = request.beanFactory.getBean("userbean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oUser" );
            });
           
            it( "component can be created", () => {
				expect( oUser ).toBeComponent();
			} );  

            it( "should have no intialized data only; i.e pno=0", function(){
                expect( oUser.getUserData().pno ).toBe( 0 )
            } );
            it( "should have an intial status of ok", function(){
                expect(oUser.getStatus() ).ToBeEmpty('');
            } );

            describe( "when performing a validity test ", function(){
                
                it( " it should fail when password or username are missing", function(){
                    oUser.setUserName('user1');
                    expect( oUser.isValid() ).toBeFalse();
                    expect(oUser.getStatus() ).tobe('missing_login_fields');
                } );
    
                it( "and if it does fail, then an error message should be generated", function(){
                    oUser.setUserName('user1');
                    expect( oUser.isValid() ).toBeFalse();
                    expect( oUser.getErrors() ).notToBeEmpty();
                } );

                it( "it should return true, when we have a username and password", function(){
                    oUser.setUserName('user1');
                    oUser.setPassword('password1');
                    expect( oUser.isValid() ).tobeTrue();
                } );

            });
           

            it( "When checking if a user is valid and the user is not found then should return FALSE and set an error message ", function(){
                oUser.setUserName('garbage');
                oUser.setPassword('garbage');
                expect(oUser.isUserValid()).toBeFalse();
                expect(oUser.getStatus() ).tobe('user_not_found');

            } );

            it( "when a user is found, then should return true and set a valid user state", function(){
                oUser.setUserName('rkr');
                oUser.setPassword('kk;');
                expect(oUser.getStatus() ).ToBeEmpty('ok');
                expect( oUser.getErrors() ).ToBeEmpty();
                expect(oUser.isUserValid()).toBetrue();
                
                var userData = oUser.getUserData();
                expect(userData).toHaveKey( 'pno' );
                expect(userData.pno).tobe(4);
                expect(userData.validated).tobe(2);

            } );

        } );
    }

}
