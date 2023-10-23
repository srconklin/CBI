
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
    }

    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){


        describe( "forgotPassword Domain Object", function(){

            beforeEach(function( currentSpec ) {
                //create a default empty sesssion; guest
                oFP = request.beanFactory.getBean("forgotpasswordbean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oFP" );
            });
           
            it( "component can be created", () => {
				expect( oFP ).toBeComponent();
			} );  

            it( "should have initialized data only; i.e. secret should be empty", function(){
                expect( oFP.getData().hashes.secret ).toBeEmpty()
            } );
        
             describe( "when performing a validity test ", function(){

                it( "it should fail with a missing email", function(){
                   
                    expect( oFP.isValid() ).toBeFalse();
                    expect (oFP.getErrorContext()['status']).tobe('missingEmail');
                } );
                it( "email should be a valid email;", function(){
                    // offer and not logged in
                    oFP.setEmail('asdfsfsdf');

                    expect( oFP.isValid() ).toBeFalse();
                    expect (oFP.getErrorContext()['status']).tobe('InvalidEmail');
                } );
               

                it( "it should return true, when a valid email provided", function(){
                    oFP.setEmail('fakeuser@company.com');
                    expect( oFP.isValid() ).tobeTrue();
                } );

            });
           
            describe( "when a reset link is being created", function (){
                
    
                it( " and the form email is not defined, it should throw an error", function(){
                    
                    oFP.generateLink();
                    
                    expect(oFP.getErrors()).NotToBeEmpty();
                    expect (oFP.getErrorContext()['Originalstatus']).tobe('missingfields');
                    expect (oFP.getErrorContext()['status']).tobe('application');
    
                } );
                it( " and the email can't be found in the system, it should throw an error", function(){
                    oFP.setEmail('thisuserdoesnotexist@nocompany.com');
                    
                    oFP.generateLink();
                    
                    expect(oFP.getErrors()).NotToBeEmpty();
                    expect (oFP.getErrorContext()['Originalstatus']).tobe('accountnotfound');
                    expect (oFP.getErrorContext()['status']).tobe('dperror');
    
                } );
                   
                it( "and the user is real, then it should have created a valid argon hash ", function(){
                    
                    oFP.setEmail('sconklin@dynaprice.com');
                    
                    oFP.generateLink();
                    
                    expect(oFP.getErrors()).toBeEmpty();
                    var ahash = oFP.getData().hashes.theArgonHash;
                    expect(ahash).NotToBeEmpty();
                    expect(Argon2CheckHash( oFP.getData().hashes.secret, ahash)).tobeTrue();
                });

                it( "and it should have updated the securityhashes table with the hash ", function(){
                   
                    oFP.setEmail('sconklin@dynaprice.com');
                   
                    oFP.generateLink();
                   
                    expect(oFP.getErrors()).toBeEmpty();
                    var ahash = oFP.getData().hashes.theArgonHash;
                    var qry = queryExecute( 'select pwdHash from securityHashes where email = :email', {email: 'sconklin@dynaprice.com'});
                    expect( qry.recordCount ).toBe(1);
                    expect( qry.pwdHash).toBe(ahash);
                    
                });
                it( "and it should have created a resetlink to place in an email ", function(){
                   
                    oFP.setEmail('sconklin@dynaprice.com');
                   
                    oFP.generateLink();
                   
                    expect(oFP.getErrors()).toBeEmpty();
                    expect( oFP.getData().resetlink).nottoBeEmpty();
                    expect( oFP.getData().resetlink).toInclude('resetpassword');
                    
                });

            });

            describe( "when an email verify token is being validated", function (){

                describe( "the routine should fail when", function (){

                    it( "a tampered or garbage token is provided for decryption", function(){
                       
                        oFP.setResetToken('jwrcrWNFdJBoyOeefR862uoPzbxsYaAcJzI_7wtB6B8XK8XCXdygi5OltkcFdyaR32Q6mrrvuwZK_RjpxLd');
                       
                        var result = oFP.verifyToken();
                       
                        expect(	result ).toBeFalse();
                        expect(oFP.getErrors()).NotToBeEmpty();
                        
                        expect (oFP.getErrorContext()['Originalstatus']).tobe('application');
                        expect (oFP.getErrorContext()['OriginalError']['message']).tobe('Input length must be multiple of 16 when decrypting with padded cipher');                      
                       
                        
                    });

                    it( "a decrypted token does not contain a secret string and email delimted by a pipe ", function(){
                        // create a token with no pipe or email
                        var encryptedHash = replace(encrypt("shh, this is a secret!", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oFP.setResetToken(encryptedHash);
                        var result =  oFP.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oFP.getErrors()).NotToBeEmpty();
                        expect (oFP.getErrorContext()['status']).tobe('passwordNotReset');
                        expect (oFP.getErrorContext()['Originalstatus']).tobe('badformat');
                      
                    });

                    it( "a decrypted token does not have an email ", function(){
                        // create a token with no email
                        var encryptedHash = replace(encrypt("shh, this is a secret!|", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oFP.setResetToken(encryptedHash);
                        var result =  oFP.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oFP.getErrors()).NotToBeEmpty();
                        expect (oFP.getErrorContext()['status']).tobe('passwordNotReset');
                        expect (oFP.getErrorContext()['Originalstatus']).tobe('missingemail');

                    });
                   
                     it( "a decrypted token has an invalid email ", function(){
                        // create a token with no pipe or email
                        var encryptedHash = replace(encrypt("shh, this is a secret!|bla bla bla", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oFP.setResetToken(encryptedHash);
                        var result =  oFP.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oFP.getErrors()).NotToBeEmpty();
                        expect (oFP.getErrorContext()['status']).tobe('passwordNotReset');
                        expect (oFP.getErrorContext()['Originalstatus']).tobe('bademail');

                    });
                    it( "the token email is not in the db ", function(){
                        // create a token an email not found
                        var encryptedHash = replace(encrypt("shh, this is a secret!|fakeuser@company.com", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oFP.setResetToken(encryptedHash);
                        var result =  oFP.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oFP.getErrors()).NotToBeEmpty();
                        expect (oFP.getErrorContext()['status']).tobe('passwordNotReset');
                        expect (oFP.getErrorContext()['Originalstatus']).tobe('toomanyornouser');
                      

                    });
                    it( "the token is older than 2 hours", function(){
                        // create a token with a hash that is older than 2
                        var encryptedHash = replace(encrypt("18E496C1-9A6A-42FA-A74F-FD1E69595EE7|ed@capovani.com", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oFP.setResetToken(encryptedHash);
                        var result =  oFP.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oFP.getErrors()).NotToBeEmpty();
                        expect (oFP.getErrorContext()['status']).tobe('passwordLinkExpired');
                        expect (oFP.getErrorContext()['Originalstatus']).tobe('linkExpired');
                      

                    });
                });    

                
                describe( "when resetting the password is complete and we mark it verified", function(){
                    
                    it( " it should have updated the security record as verified", function(){
                        oFP.setEmail('sconklin@dynaprice.com');
                        oFP.generateLink();
                        expect(oFP.getErrors()).toBeEmpty();
                        oFP.markPasswordVerified();
                        var qry = queryExecute( 'select pwdGuid, pwdHash, pwdDateTime, pwdVerified from securityHashes where email = :email', {email: 'sconklin@dynaprice.com'});
                        debug(qry);
                        expect( qry.pwdVerified).toBe(1);
                        expect( qry.pwdHash).toBeEmpty();
                        expect( qry.pwdGuid).toBeEmpty();
                        expect( qry.pwdDateTime).toBeEmpty();
                    });
                });
            });
           
        });
    }
}
