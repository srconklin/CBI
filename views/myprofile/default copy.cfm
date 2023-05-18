<div class="container">

	<div class="login-title">
		<h1>My Account</h1>
	</div>
	

</div>

<style>
	.pac-icon {
	  display: none;
	}

	.pac-item {
  padding: 10px;
  font-size: 16px;
  cursor: pointer;
}

.pac-item:hover {
  background-color: #ececec;
}

.pac-item-query {
  font-size: 16px;
}
</style>



<cfoutput>


	<div>
		<form action="/myprofile" method="get" id="myprofilefrm" autocomplete="off" >
			<div class="form-row">
				<label for="searchgeo" class="form-label">
					Choose your location <span>*</span>
				</label>
					<input
						id="searchgeo" 
						name="searchgeo" 
						type="text"
						class="form-control" 
						placeholder="your Location" 
						title="type to choose your location" 
						<!--- maxlength="75" --->
						required
						autocomplete="off">
						<!--- alpine --->
						<!--- :class="{'invalid':$store.forms.toggleError('location')}" 
						@blur="$store.forms.validate($event)"/> --->
						
					<!--- <p 
						class="helper error-message" 
						x-cloak 
						x-show="$store.forms.toggleError('location')" 
						x-text="$store.forms.location.errorMessage" >
					</p> --->
			</div>	

			<div class="form-row">
				<label for="address2" class="form-label">
					Address 2
				</label>
					<input
						id="address2" 
						name="address2" 
						type="text"
						class="form-control" 
						placeholder="Apartment, unit, suite, or floor ##" 
						title="Apartment, unit, suite, or floor ##" 
						maxlength="50"
						>
			</div>	
			<div class="form-row">
				<label for="location" class="form-label">
					City <span>*</span>
				</label>
					<input
						id="locality" 
						name="locality" 
						type="text"
						class="form-control" 
						placeholder="City" 
						title="City" 
						maxlength="50"
						required
					>
					
			</div>	
			<div class="form-row">
				<label for="stateprov" class="form-label">
					State/Province <span>*</span>
				</label>
					<input
						id="stateprov" 
						name="stateprov" 
						type="text"
						class="form-control" 
						placeholder="State/Province" 
						title="State/Province" 
						maxlength="50"
						required
					>
			</div>	

			<div class="form-row">
				<label for="postalcode" class="form-label">
					Country/Region <span>*</span>
				</label>
					<input
						id="country" 
						name="country" 
						type="text"
						class="form-control" 
						placeholder="Country/Region" 
						title="Country/Region" 
						maxlength="50"
						required
					>
			</div>	

			<div class="form-row">
				<label for="postalcode" class="form-label">
					Postal Code
				</label>
					<input
						id="postalcode" 
						name="postalcode" 
						type="text"
						class="form-control" 
						placeholder="Postal Code" 
						title="Postal Code" 
						maxlength="25"
					>
			</div>	


		</form>	
	</div>				

</cfoutput>

<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDkEDHzr6YLw-24a07THqMOFF5t0UGgDqk&libraries=places"></script>

<script>
	const input = document.getElementById("searchgeo");

	const options =  {
		// types: ['(cities)']
		//componentRestrictions: { country: ["us", "ca"] },
    	fields: ["address_components", "place_id", "formatted_address", "geometry", "types"],
    	//types: ["address"],
		types: ['(cities)']
	}
	autocomplete = new google.maps.places.Autocomplete(input, options);

	input.focus();


	const onPlaceChanged = () => {
		// Get the place details from the autocomplete object.
		const place = autocomplete.getPlace();
		let address1 = "";
		let postcode = "";

		console.log(place);
		// Get each component of the address from the place details,
		// and then fill-in the corresponding field on the form.
		// place.address_components are google.maps.GeocoderAddressComponent objects
		// which are documented at http://goo.gle/3l5i5Mr
		for (const component of place.address_components) {
			
			//const componentType = component.types[0];

			for (const componentType of component.types) {

				switch (componentType) {
				case "street_number": {
					address1 = `${component.long_name} ${address1}`;
					break;
				}

				case "route": {
					address1 += component.long_name;
					break;
				}

				case "postal_code": {
					postcode = `${component.long_name}${postcode}`;
					break;
				}

				case "postal_code_suffix": {
					postcode = `${postcode}-${component.long_name}`;
					break;
				}

				case "locality": {
					document.getElementById("locality").value = component.long_name;
					break;
				}
				case "sublocality_level_1": {
					document.getElementById("locality").value = component.long_name;
					break;
				}
					
				case "postal_town": {
					document.getElementById("locality").value = component.long_name;
					break;
				}
					
				case "administrative_area_level_1": {
					document.getElementById("stateprov").value = component.long_name;
					break;
				}

				case "country":
					document.getElementById("country").value =	component.long_name;
					break;
				}
			}
		}

		input.value = address1;
		document.getElementById("postalcode").value = postcode;

		// After filling the form with address components from the Autocomplete
		// prediction, set cursor focus on the second address line to encourage
		// entry of subpremise information such as apartment, unit, or floor number.
		document.getElementById("address2").focus();

	}

	autocomplete.addListener('place_changed', onPlaceChanged);

</script>