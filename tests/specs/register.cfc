
/**
 * register Test
 */
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

    /**
     * executes before all suites+specs in the run() method
     */
    function beforeAll(){
        config = request.beanFactory.getBean("configService"); 
        fakeuser = 'fakeuser@mycompany.com'
        var params = {
            email:'ed@capovani.com'
        };
            
        var sql = "SET NOCOUNT ON;

        update peopleOrig set regstat = 0  where email = :email;

        insert into securityHashes 
            (   email
                ,verifyHash
                ,verifyDateTime
                ,verifyVerified)
            values (
                    'ed@capovani.com',
                    '18E496C1-9A6A-42FA-A74F-FD1E69595EE7',
                    '2023-04-25 16:39:00',
                    0
                    
            )";

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
            update peopleOrig set regstat = 1  where email = :email;
        ";
        
        var qry = queryExecute( sql, params);

        params = {
            email:fakeuser
        };
            
        var sql = 'SET NOCOUNT ON;
        declare @pno int
        select @pno =pno from PeopleOrig where email = :email;
       
        delete from permits where pno = @pno;
        delete from Addresses where  pno = @pno;
        delete from PeopleOrig where pno = @pno;
        delete from securityHashes where  email = :email; 
        '

        var qry = queryExecute( sql, params);

    }

    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){


        describe( "Register Domain Object", function(){

            beforeEach(function( currentSpec ) {
                //create a default empty sesssion; guest
                oRegister = request.beanFactory.getBean("registerbean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oRegister" );
            });
           
            it( "component can be created", () => {
				expect( oRegister ).toBeComponent();
			} );  

            it( "should have initialized data only; ", function(){
                expect( oRegister.getPm()).toBeEmpty()
            } );
         
           
            describe( "when performing a validity test ", function(){

                it( "agree to terms is required", function(){
                    
                    expect( oRegister.isValid() ).toBeFalse();

                    var errs = oRegister.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('agreetandc');
                    expect (oRegister.getErrorContext()['status']['agreetandc']).tobe('agreeTandC');
                    
                } );

                it( "it should return true, when all fields are correctly set", function(){
                    
                    oRegister.setAgreeTandC('1');
                    oRegister.setfirstname('Fake');
                    oRegister.setlastname('User');
                    oRegister.setEmail(fakeuser);
                    oRegister.setConame('copmany');
                    oRegister.setPhone('713-972-2243');
                    
                    expect( oRegister.isValid() ).tobeTrue();
                } );

            });
           
            describe( "when we try to register the user", function() {
              

                it( "& we do not have a valid password from a pm bean, then it shold fail and throw an error", function(){
                   
                    oRegister.signup();
                    expect(oRegister.getErrorContext()['status']).tobe('application');
                    expect(oRegister.getErrorContext()['originalStatus']).tobe('pmmissing');
                                        
                });

                it( "& we have a pm set, then it should be a valid bean where we can get the password", function(){
                   
                    var pm = request.beanFactory.getBean("passwordmgrbean"); 
                    pm.setPwd1('Dp_567_A!');
                    pm.setPwd2('Dp_567_A!');
                    oRegister.setPM(pm);
                    var regpm = oRegister.getPM();
                    expect(regpm.getPwd1()).toBe('Dp_567_A!');
                                        
                });


                it( " & the email exists in the system as a verified user, then it should throw an error", function(){
                    
                    var pm = request.beanFactory.getBean("passwordmgrbean"); 
                    pm.setPwd1('Dp_567_A!');
                    pm.setPwd2('Dp_567_A!');
                    oRegister.setPM(pm);
                    oRegister.setAgreeTandC('1');
                    oRegister.setfirstname('Scott');
                    oRegister.setlastname('Conklin');
                    oRegister.setEmail('sconklin@dynaprice.com');
                    oRegister.setConame('DP');
                    oRegister.setPhone('713-972-2243');

                    oRegister.signup();
                    
                    expect(oRegister.hasErrors()).tobeTrue();
                    expect(oRegister.getErrors()).notToBeEmpty();
                    expect(oRegister.getErrorContext()['status']).tobe('dperror');
                    expect(oRegister.getErrorContext()['originalStatus']).tobe('emailinuse');
                    

                });

                it( " & the email exists in the system but the email has not been verified, then it should provide a message saying that", function(){

                    var pm = request.beanFactory.getBean("passwordmgrbean"); 
                    pm.setPwd1('Dp_567_A!');
                    pm.setPwd2('Dp_567_A!');
                    oRegister.setPM(pm);
                    oRegister.setAgreeTandC('1');
                    oRegister.setfirstname('Ed');
                    oRegister.setlastname('Capovani');
                    oRegister.setEmail('ed@capovani.com');
                    oRegister.setConame('CBI');
                    oRegister.setPhone('800-123-9999');

                    oRegister.signup();

                    expect(oRegister.hasErrors()).tobeTrue();
                    expect(oRegister.getErrors()).notToBeEmpty();
                    expect(oRegister.getErrorContext()['originalStatus']).tobe('emailinuse_nv');
                    
                   
                      
                } );

                it( " & the email DOES not exist, then it should insert records into the db", function(){

                    var pm = request.beanFactory.getBean("passwordmgrbean"); 
                    pm.setPwd1('Dp_567_A!');
                    pm.setPwd2('Dp_567_A!');
                    oRegister.setPM(pm);

                    oRegister.setbcast('1');
                    oRegister.setAgreeTandC('1');
                    oRegister.setfirstname('fake');
                    oRegister.setlastname('user');
                    oRegister.setEmail(fakeuser);
                    oRegister.setConame('mycompany');
                    oRegister.setPhone('800-123-9999');

                    oRegister.signup();
                    // we would expect a new user

                    saveContent  variable="sql" {writeOutput('
                        SELECT P.Pno,P.UserID,P.Password,P.Email,P.FirstName,P.LastName,P.Phone1,P.coName,P.RegStat,P.AddDt,
                        S.verifyHash, isnull(S.verifyVerified, 0) as verifyVerified, S.verifyDateTime,
                        P.VTID AS PVTID, PM.PLNo, A.displayname, PM.bcast,
                        ISNULL(C.LNm,Co.CoLNm) as LNm,ISNULL(C.CoTID,Co.CoTID) as CoTID
                        FROM PeopleOrig P
                        LEFT JOIN CoVenues C ON C.VTID=P.VTID
                        LEFT JOIN Companies Co ON Co.CoTID=P.VTID
                        INNER JOIN Addresses A ON a.Pno=P.Pno
                        INNER JOIN Permits PM ON PM.PNo=P.PNo AND PM.VTID=63160
                        INNER JOIN securityHashes S ON S.Email=P.email
                        WHERE p.email= :email')
                    }
                    
                    var qry = queryExecute( sql, {email: fakeuser});
                    
                    expect( qry.recordCount ).toBe(1);
                    expect( qry.email ).toBe(fakeuser);
                    expect( qry.displayname ).toBe('registration');
                    expect( qry.bcast ).toBe('1');
                    expect( qry.verifyHash ).notToBeEmpty();
                    debug( qry.verifyDateTime )
                    
                } );

            });

            
            describe( "when an email is being verified", function (){

                describe( "the routine should fail when", function (){

                    it( "a tampered or garbage token is provided for decryption", function(){
                        oRegister.setVerifyToken('jwrcrWNFdJBoyOeefR862uoPzbxsYaAcJzI_7wtB6B8XK8XCXdygi5OltkcFdyaR32Q6mrrvuwZK_RjpxLd');

                        var result = oRegister.verifyToken();

                        expect(	result ).toBeFalse();
                        
                        expect (oRegister.getErrorContext()['Originalstatus']).tobe('application');
                        expect (oRegister.getErrorContext()['OriginalError']['message']).tobe('Input length must be multiple of 16 when decrypting with padded cipher');                      
                       
                        
                    });

                    it( "a decrypted token does not contain a secret string and email delimted by a pipe ", function() {
                        // create a token with no pipe or email
                        var encryptedHash = replace(encrypt("shh, this is a secret!", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oRegister.setVerifyToken(encryptedHash);
                        var result =  oRegister.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oRegister.getErrors()).NotToBeEmpty();
                       
                        expect (oRegister.getErrorContext()['status']).tobe('emaildidnotverify');
                        expect (oRegister.getErrorContext()['Originalstatus']).tobe('badformat');
                      

                    });

                    it( "a decrypted token does not have an email ", function(){
                        // create a token with no email
                        var encryptedHash = replace(encrypt("shh, this is a secret!|", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oRegister.setVerifyToken(encryptedHash);
                        var result =  oRegister.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oRegister.getErrors()).NotToBeEmpty();
                        expect (oRegister.getErrorContext()['status']).tobe('emaildidnotverify');
                        expect (oRegister.getErrorContext()['Originalstatus']).tobe('missingemail');

                    });
                   
                     it( "a decrypted token has an invalid email ", function(){
                        // create a token with no pipe or email
                        var encryptedHash = replace(encrypt("shh, this is a secret!|bla bla bla", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oRegister.setVerifyToken(encryptedHash);
                        var result =  oRegister.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oRegister.getErrors()).NotToBeEmpty();
                       // expect(oRegister.getErrors()).tobe('bademail');
                        expect (oRegister.getErrorContext()['status']).tobe('emaildidnotverify');
                        expect (oRegister.getErrorContext()['Originalstatus']).tobe('bademail');

                    });
                    it( "the token email is not in the db ", function(){
                        // create a token an email not found
                        var encryptedHash = replace(encrypt("shh, this is a secret!|notfound@indb.com", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oRegister.setVerifyToken(encryptedHash);
                      
                        var result =  oRegister.verifyToken();
                      
                        expect(	result ).toBeFalse();
                        expect(oRegister.getErrors()).NotToBeEmpty();
                        expect (oRegister.getErrorContext()['status']).tobe('emaildidnotverify');
                        expect (oRegister.getErrorContext()['Originalstatus']).tobe('toomanyornouser');
                        

                    });
                    it( "the token is older than 2 hours", function(){
                        // create a token with a hash that is older than 2
                        var encryptedHash = replace(encrypt("18E496C1-9A6A-42FA-A74F-FD1E69595EE7|ed@capovani.com", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        oRegister.setVerifyToken(encryptedHash);
                        var result =  oRegister.verifyToken();
                        expect(	result ).toBeFalse();
                        expect(oRegister.getErrors()).NotToBeEmpty();
                     
                        expect (oRegister.getErrorContext()['status']).tobe('verifyLinkExpired');
                        expect (oRegister.getErrorContext()['Originalstatus']).tobe('linkExpired');

                    });
                });    

                describe( "with a valid email token,", function (){

                    it( " it should contain a valid user array that is used to auto log the user in", function(){
                    
                        saveContent  variable="sql" {writeOutput('
                            SELECT s.verifyguid, S.verifyHash, isnull(S.verifyVerified, 0) as verifyVerified  
                            FROM securityHashes S WHERE s.email= :email')
                        }
                        
                        var qry = queryExecute( sql, {email: fakeuser});

                        encryptedHash = replace(encrypt("#qry.verifyguid#|#fakeuser#", variables.config.getSetting("AESKey"), "AES", "base64"), "/", "_", "all");
                        // token = encodeforURL(encryptedHash);
                        oRegister.setVerifyToken(encryptedHash);
                       
                        var result = oRegister.verifyToken();
                        debug(oRegister.getErrorContext());
                        expect(oRegister.getErrors()).toBeEmpty();
                        expect(oRegister.getData().user).NottoBeEmpty();
                        expect(oRegister.getData().user).toBeTypeOf('struct');
                        expect(oRegister.getData().email).tobe(fakeuser);

                        var qry = queryExecute( 'select verifyGuid, verifyHash, verifyDateTime, verifyVerified from securityHashes where email = :email', {email: fakeuser});
                       
                        expect( qry.verifyVerified).toBe(1);
                        expect( qry.verifyHash).toBeEmpty();
                        expect( qry.verifyGuid).toBeEmpty();
                        expect( qry.verifyDateTime).toBeEmpty();

                    });
                }); 
                
                
                describe( "When a request is made that the verify link be regenerated/sent", function(){
                    
                    it( "and the email is not found, it should fail and not send the link", function(){
                        oRegister.setEmail('blabla@dynaprice.com');
                        oRegister.resendLink();
                        expect(oRegister.getErrors()).NotToBeEmpty();
                        expect (oRegister.getErrorContext()['status']).tobe('verifylinknotcreated');
                        expect (oRegister.getErrorContext()['Originalstatus']).tobe('toomanyornouser')
                    });

                    it( "and the email is found, but the email has already been verified, it should fail and not send the link again", function(){
                        
                        var params = {
                            email:'ed@capovani.com'
                        };

                        var sql = "SET NOCOUNT ON;
                          update securityHashes set verifyVerified= 1 where email = :email";
                        var qry = queryExecute( sql, params);

                        oRegister.setEmail('ed@capovani.com');
                        oRegister.resendLink();
                        expect(oRegister.getErrors()).NotToBeEmpty();
                        expect (oRegister.getErrorContext()['status']).tobe('emailAlreadyVerified');

                        sql = "SET NOCOUNT ON;
                        update securityHashes set verifyVerified= 0 where email = :email";
                        qry = queryExecute( sql, params);

                    });

                    
                    it( "and the email is found with no errors, a new hash should have been created and updated", function(){
                        oRegister.setEmail('ed@capovani.com');
                        oRegister.resendLink();
                        expect(oRegister.getErrors()).toBeEmpty();

                        var qry = queryExecute( 'select verifyGuid, verifyHash, verifyDateTime, verifyVerified from securityHashes where email = :email', {email: 'ed@capovani.com'});
                       
                        expect( qry.verifyVerified).toBe(0);
                        expect( qry.verifyHash).notToBe('18E496C1-9A6A-42FA-A74F-FD1E69595EE7');
                        expect( qry.verifyDateTime).nottoBeEmpty('2023-04-25 16:39:00');
                        expect( dateConvert('utc2Local', qry.verifyDateTime)).toBeCloseTo(now(), 10, 's');
                        debug(  dateConvert('utc2Local', qry.verifyDateTime));

                    });
                
                });
                
            });

          
        });
    }
}
