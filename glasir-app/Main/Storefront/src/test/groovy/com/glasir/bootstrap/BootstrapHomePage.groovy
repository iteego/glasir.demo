package com.glasir.bootstrap

import geb.*

class BootstrapHomePage extends Page {
	static url = "/crs/myaccount/login.jsp?loginFromHeader=yes"
	static at = { title == "ATG Store - Powered by ATG" }

	static content = {
	  //the below formErrors item will return a list of strings containing the 
	  //error strings generated on an invalid login. We would expect a list of one
	  //["The supplied login was invalid."] when an invalid login is provided
	  formErrorMessage { $("div[class='errorMessage']")*.text()*.trim() }
	  
	  username { $("input", name: "atg_store_registerLoginEmailAddress") }
	  password { $("input", name: "atg_store_registerLoginPassword") }
		
		loginButton {  $("input", name: "/atg/userprofiling/B2CProfileFormHandler.login") }

	}
}
