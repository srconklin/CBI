 <cfoutput>
  <h2 style="margin-top:1rem;"><u>Question or Comment from Contact Us</u></h2>
			  
    <ul>
        <li>Name: <b>#getname()#</b></li>
        <li>Email: <b>#getEmail()#</b></li>
        <li>time: <b>#dateFormat(now(), 'mm/dd/yyyy')# #timeFormat(now(), 'hh:mm TT')#</b></li>
        <li>Message: <b>#getMessage()#</b></li>
        
    </ul>

</div>
</cfoutput>