<div id="contact" class="general-page">

  <section class="contact-header mt-2 full-width">
    <div class="content">
      <h1 class="lead-title">Contact Us</h1>
        <!--- <h3 style="font-weight:normal">
          Got a question or need assistance? Drop your questions in the form below, and we'll get right on it
        </h3> --->
    </div>  
  </section>

  <div class="container">

      <section class="mt-6 mb-8 justify-center" style="gap:60px;">
        <div class="mb-8 " style="flex-basis:530px;">

            <div class="operation-title">
              <h1>Question or Comment</h1>
            </div>
            
            <p class="mb-8">
              Got a question or need assistance? Drop your questions in the form below, and we'll get right on it
            </p>

            <div 
											class="form-row" 
											x-cloak 
											x-show="$store.contact.generalError">
												<p 
													class="helper error-message-box error-message" 
													x-html="$store.contact.generalError">
												</p>
										</div>
            <div>
              <!--- <form action="/contact" method="post"> --->
              <form 
                id="contactfrm" 
                name="contactfrm"
                action="/contact" 
                method="post"
                x-data 
		        		@submit.prevent="$store.forms.submit('contact')" >

              <div class="form-row">

                <input 
                    id="name" 
                    name="name" 
                    type="text" 
                    class="form-control" 
                    placeholder="Your Name" 
                    maxlength="20"
                    title="enter your name"
                    <!--- optional --->
                    required
                    data-msg='["valueMissing:Please enter your name"]'
                    oninput="this.value=stripInvalidChars(this.value);"
                    
                    <!--- alpine --->
                    :class="{'invalid':$store.contact.toggleError('name')}"  
                    x-model="$store.contact.name.value" 
                    @blur="$store.contact.validate($event)" 
                    @focus="$store.contact.generalError=''"
                    />
                <p 
                    class="helper error-message" 
                    x-cloak 
                    x-show="$store.contact.toggleError('name')" 
                    x-text="$store.contact.name.errorMessage" >
                </p>
              </div>

              <div class="form-row">
                <div class="input-group">
                  <span class="input-group-icon">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                          <path fill-rule="evenodd" d="M14.243 5.757a6 6 0 10-.986 9.284 1 1 0 111.087 1.678A8 8 0 1118 10a3 3 0 01-4.8 2.401A4 4 0 1114 10a1 1 0 102 0c0-1.537-.586-3.07-1.757-4.243zM12 10a2 2 0 10-4 0 2 2 0 004 0z" clip-rule="evenodd" />
                      </svg>
                  </span>
                  <input 
                    id="email"
                    name="email" 
                    type="email" 
                    class="form-control input-group-ele-svg" 
                    maxlength="50"
                    placeholder="Your Email Address"  
                    title="enter your email address"
                    <!--- optional --->
                    required
                    data-msg='["valueMissing:Please enter your email"]'
                    <!--- alpine --->
                    
                    :class="{'invalid':$store.contact.toggleError('email')}" 
                    x-model="$store.contact.email.value"
                    @blur="$store.contact.validate($event)"
                    @focus="$store.contact.generalError=''"
                  />
                </div>	
              </div>	
              <p 
                class="helper error-message" 
                x-cloak 
                x-show="$store.contact.toggleError('email')" 
                x-text="$store.contact.email.errorMessage">
              </p>

              <div class="form-row">
                <textarea 
                  id="message"  
                  name="message"
                  class="form-control"
                  maxlength="250"
                  placeholder="Ask a question or send us a comment"
                  title="Ask a question or send us a comment"
                  <!--- optional --->
                  cols="50" 
                  rows="3" 
                  wrap="soft" 
                  <!--- alpine --->
                  
                  x-model="$store.contact.message.value"
                  @blur="$store.contact.validate($event)"
                ></textarea>

                <p class="count" x-cloak>
                  <span x-text="$store.contact.messageRemain"></span> characters remaining.
                </p>

              </div>	
              
              <div class="center-w-flex form-row mt-6">
           
                <button 
                id="submit"
                name="submit"
                type="submit" 
                class="btn btn-red" 
                title="submit"
                <!--- alpine --->
                :class="{'submitting' :$store.forms.submitting}" 
                :disabled="$store.forms.submitting">
                  <svg x-show="$store.forms.submitting" class="animate-spin processing"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle style="opacity: .25"  cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path style="opacity: .75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>Submit
              </button>
              </div>
 
              </form>
            </div>
            
        </div>
        <div style="font-weight:600">
          
            <p style="font-size:19px">704 Prestige Pkwy,
               <br>Scotia, NY 12302 USA
            </p>
            <p style="font-size:medium">email: <a href="mailto:info@capovani.com">info@capovani.com</a></p>
            <p>phone: (518) 602-5999</p>
            <div style="font-size:large;">
                <div class="open-schedule">
                  <div>Monday</div>
                  <div>9:00 am - 5:00 pm</div>
                </div>
                <div class="open-schedule">
                  <div >Tuesday</div>
                  <div >9:00 am - 5:00 pm</div>
                </div>
                <div class="open-schedule">
                   <div>Wednesday</div>
                   <div>9:00 am - 5:00 pm</div>
                 </div>
                 <div class="open-schedule">
                    <div>Thursday</div>
                    <div>9:00 am - 5:00 pm</div>
                  </div>
                  <div class="open-schedule">
                    <div>Friday</div>
                    <div>9:00 am - 5:00 pm</div>
                  </div>
                  <div class="open-schedule">
                    <div>Saturday</div>
                    <div>Closed</div>
                  </div>
                  <div class="open-schedule">
                    <div>Sunday</div>
                    <div>Closed</div>
                  </div>
                 </div>
          </div>
        </div>
      </section>
   </div>
</div>



    
    
