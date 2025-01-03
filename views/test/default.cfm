<cfscript>
    hashedValue = GenerateArgon2Hash("CFDocs.org");
    dump(hashedValue);
    check = Argon2CheckHash( "CFDocs.org", hashedValue);
    dump(check);
    </cfscript>
    