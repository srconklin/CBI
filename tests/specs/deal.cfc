
/**
 * deal Test
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

        var params = {
            email:'fakeuser@company.com'
        };
            
        var sql = 'SET NOCOUNT ON;
        declare @pno int
        select @pno =pno  from PeopleOrig where email = :email;
       
        delete from permits where pno = @pno;
        delete from Addresses where  pno = @pno;
        delete from PeopleOrig where pno = @pno;
        delete from securityHashes where  email = :email; 
        '

        var qry = queryExecute( sql, params);
    }

    /*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){


        describe( "Deal Domain Object", function(){

            beforeEach(function( currentSpec ) {
                //create a default empty sesssion; guest
                userService.defaultUserSession();
                oDeal = request.beanFactory.getBean("dealbean"); 
            });
        
            afterEach(function( currentSpec ) {
                structDelete( variables, "oDeal" );
            });
           
            it( "component can be created", () => {
				expect( oDeal ).toBeComponent();
			} );  

            it( "should have initialized data only; i.e. newperson is NOT defined", function(){
                expect( oDeal.getData().newperson ).toBeEmpty()
            } );
            // it( "intially the is user should be unknown", function(){
            //     expect(oDeal.getdata().isUserKnown ).tobeFalse();
            // } );
            it( "intially the order sucessfully sent flag should be off", function(){
                expect(oDeal.offerSentSuccesfully() ).tobeFalse();
            } );

            describe( "when performing a validity test ", function(){

                it( "and when a user is NOT logged in, then personal data fields are required", function(){
                    odeal.setPhone1('');
                    expect( oDeal.isValid() ).toBeFalse();
                    var errs = oDeal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('firstname');
                    expect (errs).toHaveKey('lastname');
                    expect (errs).toHaveKey('email');
                    expect (errs).toHaveKey('phone1');
                    
                } );
                
                it( "and when a user is logged in, personal data fields should not be validated", function(){
                    userService.setUserSession({fistname = 'fake', lastname ='user', validated : 1})
                    oDeal.isValid();
                    var errs = oDeal.getErrors();
                    expect (errs).nottoHaveKey('firstname');
                    expect (errs).nottoHaveKey('lastname');
                    expect (errs).nottoHaveKey('email');
                    expect (errs).nottoHaveKey('phone1');
                    
                } );
                it( "and an offer in in progress, it should fail with a missing qty and price", function(){
                    // offer and not logged in
                    oDeal.setTtypeNo(11);

                    expect( oDeal.isValid() ).toBeFalse();
                    var errs = oDeal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('qtystated');
                    expect (errs).toHaveKey('pricestated');
                } );
                it( "qty and price should be valid numbers", function(){
                    // offer and not logged in
                    oDeal.setTtypeNo(11);
                    oDeal.setqtyStated('sdf');
                    oDeal.setPriceStated('sdf');

                    expect( oDeal.isValid() ).toBeFalse();
                    var errs = oDeal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('qtystated');
                    expect (errs).toHaveKey('pricestated');
                } );
    
                it( "Message and Terms should NOT violate character count limitations", function(){
                    // offer and not logged in
                    oDeal.setTtypeNo(11);

                    oDeal.setMessage('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pharetra, nibh quis varius imperdiet, odio lorem interdum purus, eget placerat magna lorem in velit. Curabitur sodales dui eu euismod cursus. Ut mollis tellus ac sem luctus, vel malesuada nunc tempor. ');
                    oDeal.setTerms('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pharetra, nibh quis varius imperdiet, odio lorem interdum purus, eget placerat magna lorem in velit. Curabitur sodales dui eu euismod cursus. Ut mollis tellus ac sem luctus, vel malesuada nunc tempor. ');
                    expect( oDeal.isValid() ).toBeFalse();
                    var errs = oDeal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('message');
                    expect (errs).toHaveKey('terms');
                    
                } );
                it( "Message and Terms should NOT contain any HTML ", function(){
                    // offer and not logged in
                    oDeal.setTtypeNo(11);
                    oDeal.setMessage('<b>Hello</b> ');
                    oDeal.setTerms('<b>Hello</b> ');
                 
                    expect( oDeal.isValid() ).toBeFalse();
                    var errs = oDeal.getErrors();
                    expect( errs ).notToBeEmpty();
                    expect (errs).toHaveKey('message');
                    expect (errs).toHaveKey('terms');
                   
                } );


                it( "it should return true, when all fields are correctly set", function(){
                    oDeal.setTtypeNo(11);
                    oDeal.setItemNo(40028);
                    oDeal.setqtyStated('1');
                    oDeal.setPriceStated('45.00');

                    oDeal.setMessage('Hello');
                    oDeal.setfirstname('Fake');
                    oDeal.setlastname('User');
                    oDeal.setEmail('fakeuser@company.com ');
                    oDeal.setConame('copmany');
                    oDeal.setPhone1('713-972-2243');
                    
                    expect( oDeal.isValid() ).tobeTrue();
                } );

            });
           
            describe( "when an offer is made and the user is NOT known (guest)", function (){
                
                it( " AND the email does NOT exist in the system, then a new user should be created and recognized as such", function(){
                    oDeal.setTtypeNo(11);
                    oDeal.setItemNo(40028);
                    oDeal.setqtyStated('1');
                    oDeal.setPriceStated('45.00');

                    oDeal.setMessage('Hello');
                    oDeal.setfirstname('Fake');
                    oDeal.setlastname('User');
                    oDeal.setEmail('fakeuser@company.com');
                    oDeal.setConame('mycompany');
                    oDeal.setPhone1('713-972-2243');

                    oDeal.sendOffer();
                    expect(oDeal.getErrors()).toBeEmpty(oDeal.getErrors());
                    expect( oDeal.getData().offerSent ).tobeTrue;
                  
                    expect(oDeal.isNewPerson()).toBe(1);

                    // we would expect the user to be in the database
                    var qry = queryExecute( 'select pno from PeopleOrig where email = :email', {email: 'fakeuser@company.com'});
                    expect( qry.recordCount ).toBe(1);

                    // user partially logged in
                    var us = userService.getUserSession();
                    expect( us.validated ).toBe(1);
                    expect( qry.pno ).toBe(us.pno);
                    
    
                } );

                it( " and the email exists, then we should find it and partially log the user in", function(){
                    oDeal.setTtypeNo(11);
                    oDeal.setItemNo(40028);
                    oDeal.setqtyStated('1');
                    oDeal.setPriceStated('45.00');

                    oDeal.setMessage('Hello');
                    oDeal.setfirstname('Fake');
                    oDeal.setlastname('User');
                    oDeal.setEmail('fakeuser@company.com');
                    oDeal.setConame('mycompany');
                    oDeal.setPhone1('713-972-2243');

                    oDeal.sendOffer();
                    expect(oDeal.getErrors()).toBeEmpty(oDeal.getErrors());
                    expect( oDeal.getData().offerSent ).tobeTrue;

                    expect(oDeal.isNewPerson()).toBe(0);
                
                    // we would expect the user to still be in the database and their last visit was updated
                    var qry = queryExecute( 'select pno, LastTime from PeopleOrig where email = :email', {email: 'fakeuser@company.com'});
                    expect( qry.recordCount ).toBe(1);
                    expect( datediff('s', now(), qry.LastTime)).toBegt(0);

                    // user partially logged in
                    var us = userService.getUserSession();
                    expect( us.validated ).toBe(1);
                    expect( qry.pno ).toBe(us.pno);
                    
    
                } );

            });

            
            describe( "when an offer is made and the user is fully logged in", function(){
                
                it( "then validated settings should not have been changed ", function(){
                    userService.setUserSession({firstname = 'Scott', lastname='Conklin', validated : 2, pno=4, regstat=1})

                    oDeal.setTtypeNo(11);
                    oDeal.setItemNo(40028);
                    oDeal.setqtyStated('1');
                    oDeal.setPriceStated('45.00');

                    oDeal.setMessage('Hello');
                    oDeal.setfirstname('Scott');
                    oDeal.setlastname('Conklin');
                    oDeal.setEmail('sconklin@dynaprice.com');
                    oDeal.setConame('mycompany');
                    oDeal.setPhone1('713-972-2243');

                    oDeal.sendOffer();

                    var us = userService.getUserSession();
                    expect( us.validated ).toBe(2);
                    expect( us.pno ).toBe(4);
                });
            
            });
        });
    }
}
