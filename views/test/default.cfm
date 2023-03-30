
	<form 
	id="registerfrm" 
	name="registerfrm"
	action="/register" 
	method="post" 
	autocomplete="off"
	x-data 
	novalidate
	<!--- @submit.prevent="console.log('submitted'); " --->
	@submit.prevent="$store.forms.form='register';$store.forms.submit();"
	>

    <div class="form-row">
        <label for="firstName" class="form-label">
            First Name <span>*</span>
        </label>
      
        <input 
            name="firstName" 
            type="text" 
            class="form-control" 
            placeholder="John" 
            maxlength="20"
            title="enter your first name"
            <!--- optional --->
            required
            data-msg='["valueMissing:Please enter your first name"]'
            oninput="this.value=validInput(this.value);"
            <!--- alpine --->
            :class="{'invalid':$store.forms.toggleError('firstName')}"  
            x-model="$store.forms.firstName.value" 
            @blur="$store.forms.validate($event)" 
            />
        <p 
            class="helper error-message" 
            x-cloak 
            x-show="$store.forms.toggleError('firstName')" 
            x-text="$store.forms.firstName.errorMessage" >
        </p>
    </div>


    <div class="form-row">
		<button 
			id="register"
			name="register"
			<!--- type="submit"  --->
			class="btn btn-red login-submit" 
			title="create register profile"
			<!--- alpine --->
			<!--- :class="{'submitting' :$store.forms.submitting}" 
			:disabled="$store.forms.submitting"> --->
			>
			Register
		</button>
	</div>
</form> 	