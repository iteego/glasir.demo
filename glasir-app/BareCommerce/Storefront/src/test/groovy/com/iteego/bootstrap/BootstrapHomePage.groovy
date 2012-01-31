import geb.*

class BootstrapHomePage extends Page {
	static url = "http://localhost:10080/app/"
	static at = { title == "Iteego Test Page" }

	static content = {
	  //the below formErrors item will return a list of strings containing the 
	  //error strings generated on an invalid login. We would expect a list of one
	  //["The supplied login was invalid."] when an invalid login is provided
	  formErrors { $("ul[name='formErrors'] li")*.text()*.trim() }
	  
	  username { $("input", name: "/atg/userprofiling/ProfileFormHandler.value.login") }
	  password { $("input", name: "/atg/userprofiling/ProfileFormHandler.value.password") }
		
		loginButton {  $("input", name: "/atg/userprofiling/ProfileFormHandler.login") }

		registerLink { $("a", href: "register.jsp") }
	}
}
