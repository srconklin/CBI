
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
            update peopleOrig set coname = 'DP'  where pno = :pno;
        ";
        
        var qry = queryExecute( sql, params);
       

    }

    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){


        describe( "Register Domain Object", function(){

            beforeEach(function( currentSpec ) {
                oCI = request.beanFactory.getBean("contactinfobean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oCI" );
            });
           
            it( "component can be created", () => {
				expect( oCI ).toBeComponent();
			} );  
           
            describe( "when performing a validity test ", function(){

                it( "and pno is missing then it should not validate", function(){
                    
                    oCI.setPno('0');
                    oCI.setfirstname('Fake');
                    oCI.setlastname('User');
                    oCI.setEmail('sconklin@dynaprice.com');
                    oCI.setConame('DP');
                    oCI.setPhone1('713-972-2243');
                    
                    expect( oCI.isValid() ).tobeFalse();
                    
                } );


                it( "it should return true, when all fields are correctly set", function(){
                    
                    oCI.setPno('123');
                    oCI.setfirstname('Fake');
                    oCI.setlastname('User');
                    oCI.setEmail('sconklin@dynaprice.com');
                    oCI.setConame('copmany');
                    oCI.setPhone1('713-972-2243');
                    
                    expect( oCI.isValid() ).tobeTrue();
                } );

            });
           
            describe( "when we try to update the user", function() {
              
                it( " & the user being updated could not be found, it should not allow the update", function(){
                    
                    oCI.setPno('80845');
                    oCI.setfirstname('Scott');
                    oCI.setlastname('Conklin');
                    oCI.setEmail('blablabla@dynaprice.com');
                    oCI.setConame('DP');
                    oCI.setPhone1('713-972-2243');

                    oCI.update();
                    
                    expect(oCI.hasErrors()).tobeTrue();
                    expect(oCI.getErrors()).notToBeEmpty(oCI.getErrors());
                    expect(oCI.getErrors().errorcode).tobe('accountnotfound');

                });
                it( " & the email exists in the system under another account, it should not allow the update", function(){
                    
                    oCI.setPno('80845');
                    oCI.setfirstname('Scott');
                    oCI.setlastname('Conklin');
                    oCI.setEmail('ed@capovani.com');
                    oCI.setConame('DP');
                    oCI.setPhone1('713-972-2243');

                    oCI.update();
                    
                    expect(oCI.hasErrors()).tobeTrue();
                    expect(oCI.getErrors()).notToBeEmpty(oCI.getErrors());
                    expect(oCI.getErrors().errorcode).tobe('emailinuse');

                });

                
                it( " & and there are no data validation errors, then it should update the contact information fields", function(){

                    oCI.setPno('80845');
                    oCI.setfirstname('Scott');
                    oCI.setlastname('Conklin');
                    oCI.setEmail('sconklin@dynaprice.com');
                    oCI.setConame('Facebook');
                    oCI.setPhone1('713-972-2243');

                    oCI.update();

                    saveContent  variable="sql" {writeOutput('
                        SELECT P.Pno,P.UserID,P.Password,P.Email,P.FirstName,P.LastName,P.Phone1,P.coName,P.RegStat,P.AddDt
                        FROM PeopleOrig P WHERE p.pno= :pno')
                    }
                    
                    var qry = queryExecute( sql, {pno: '80845'});
                    
                    expect( qry.recordCount ).toBe(1);
                    expect( qry.coname ).toBe('facebook');
                    
                } );

            });

          
        });
    }
}
