
/**
 * fp Test
 */
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

    /**
     * executes before all suites+specs in the run() method
     */
    function beforeAll(){
        config = request.beanFactory.getBean("configService"); 

        var params = {
            email:'ed@capovani.com'
        };
            
        var sql = "SET NOCOUNT ON;
        insert into securityHashes 
            (email
                ,pwdGuid
                ,pwdHash
                ,pwdDateTime
                ,pwdVerified
                )
                values (
                    'ed@capovani.com',
                    '18E496C1-9A6A-42FA-A74F-FD1E69595EE7',
                    '$argon2i$v=19$m=8,t=1,p=1$nH+HcfVSxjLYFddkbDtoJg$H9lfCMZ0lf2WTP0K8q1axEPO35GH4J94xv+9hgLZiqs',
                    '2023-04-25 16:39:00',
                    0
                )
           
        ";
        var qry = queryExecute( sql, params);

    }

    /**
     * executes after all suites+specs in the run() method
     */
    function afterAll(){

        var params = {
            email:'ed@capovani.com'
        };
            
        var sql = "SET NOCOUNT ON;
            delete from securityHashes where email = :email;
        ";
        
        var qry = queryExecute( sql, params);

        var hashedpw = hash('kk;')
        var qry = queryExecute( "update peopleOrig set password = '#hashedpw#' where pno = :pno", {pno: 4});
    }

    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){


        describe( "passwordMgr Domain Object", function(){

            beforeEach(function( currentSpec ) {
                //create a default empty sesssion; guest
                oPM = request.beanFactory.getBean("passwordmgrbean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oPM" );
            });
           
            it( "component can be created", () => {
				expect( oPM ).toBeComponent();
			} );  

                
             describe( "when performing a validity test ", function(){

                it( "it should fail when the passwords are not provided", function(){
                   
                    oPM.setPwd2('foo');
                    expect( oPM.isValid() ).toBeFalse();
                    var errs = oPM.getErrors();
                    expect (errs.pwd1).toInclude('valid password');

                    oPM.setPwd1('foo');
                    oPM.setPwd2('');
                    expect( oPM.isValid() ).toBeFalse();
                    var errs = oPM.getErrors();
                    expect (errs.pwd2).toInclude('confirm your password');

                } );
                it( "it should fail when the passwords do not meet requirement standards", function(){
                   
                    // no lowercase
                    oPM.setPwd1('FOO');
                    oPM.setPwd2('FOO');
                    expect( oPM.isValid() ).toBeFalse();
                    var errs = oPM.getErrors();
                    expect (errs.pwd1).toInclude('lowercase character');

                     // no uppercase
                     oPM.setPwd1('foo');
                     oPM.setPwd2('foo');
                     expect( oPM.isValid() ).toBeFalse();
                     var errs = oPM.getErrors();
                     expect (errs.pwd1).toInclude('uppercase character');

                    // no number
                    oPM.setPwd1('Foo');
                    oPM.setPwd2('Foo');
                    expect( oPM.isValid() ).toBeFalse();
                    var errs = oPM.getErrors();
                    expect (errs.pwd1).toInclude('least one number');

                     // too short
                     oPM.setPwd1('Foo123');
                     oPM.setPwd2('Foo123');
                     expect( oPM.isValid() ).toBeFalse();
                     var errs = oPM.getErrors();
                     expect (errs.pwd1).toInclude('least 8 characters');

                     // passwords do not match
                     oPM.setPwd1('Foo_123$');
                     oPM.setPwd2('Foo_123*');
                     expect( oPM.isValid() ).toBeFalse();
                     var errs = oPM.getErrors();
                     expect (errs.pwd2).toInclude('Passwords must match');

                    
                } );

            });
           
            describe( "when the password is being reset from an email request", function (){
                
                it( " and the email can't be found in the system, it should throw an error", function(){
                    oPM.setEmail('thisuserdoesnotexist@nocompany.com');
                    oPM.resetPassword();
                    expect(oPM.getErrors()).NotToBeEmpty();
                    debug( oPM.getErrors() );
                    expect (oPM.getErrors()).toInclude('email address provided.');
    
                } );
                   
                it( "and if the user is real, then it should have updated the password correctly", function(){
                    oPM.setEmail('ed@capovani.com');
                    oPM.setpwd1('goodPassword_99');
                    oPM.setpwd2('goodPassword_99');
                    var hashedpw = hash(oPM.getpwd2())
                    oPM.resetPassword();
                    expect(oPM.getErrors()).toBeEmpty();
                    // we would expect the user's password to match the newly set one
                    var qry = queryExecute( 'select password from peopleOrig where email = :email', {email: 'ed@capovani.com'});
                    expect( qry.password).toBe(hashedpw);
                   
                    
                });

            });

            describe( "when the password is being updated by the user", function (){
                
                it( " and the pno can't be found in the system, it should throw an error", function(){
                    oPM.setpNo('0');
                    oPM.changePassword();
                    expect(oPM.getErrors()).NotToBeEmpty();
                    debug( oPM.getErrors() );
                    expect (oPM.getErrors()['pwdcurrent']).toInclude('user account');
                } );

                it( " and the pno is valid but the password is wrong, it should throw an error", function(){
                    oPM.setpNo('4');
                    oPM.setPwdCurrent('garbage!!');
                    oPM.changePassword();
                    expect(oPM.getErrors()).NotToBeEmpty();
                    debug( oPM.getErrors() );
                    expect (oPM.getErrors()['pwdcurrent']).toInclude('password is incorrect');
                } );

                it( " and the pno and password are valid, the password should have been updated", function(){
                    oPM.setpNo('4');
                    oPM.setPwdCurrent('kk;');
                    oPM.setpwd1('goodPassword_99');
                    oPM.setpwd2('goodPassword_99');
                    var hashedpw = hash(oPM.getpwd2())
                    oPM.changePassword();
                    expect(oPM.getErrors()).toBeEmpty();
                    debug( oPM.getErrors() );
                    // we would expect the user's password to match the newly set one
                    var qry = queryExecute( 'select password from peopleOrig where pno = :pno', {pno: 4});
                    expect( qry.password).toBe(hashedpw);
                
                } );

            });    
        });
    }
}
