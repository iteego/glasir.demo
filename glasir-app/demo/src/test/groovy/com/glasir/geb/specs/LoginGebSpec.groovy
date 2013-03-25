package com.glasir.geb.specs

import spock.lang.*
import geb.*
import geb.spock.*
import com.glasir.geb.pages.LoginPage
import com.glasir.geb.pages.HomePage


//for a description of BDD, see http://en.wikipedia.org/wiki/Behavior_Driven_Development
class LoginGebSpec extends GebReportingSpec {

  def "should display error when logging in with a non existent user"() {
    when:
    to LoginPage
    
    and:
    username.value "bogus user"
    
    and: 
    password.value "bogus password"
    
    and:
    loginButton.click()
    
    then:
    //check for five seconds (default) with 0.5s (default) intervals and wait for us to end up
    //on the login page page after logging in
    waitFor { at LoginPage }

    and:
    formErrorMessage.toString().contains("that login is not valid")
  } 

  def "should log in user when entering correct credentials"() {
    when:
    to LoginPage
    
    and:
    username.value "stuart@example.com"
    
    and: 
    password.value "password"
    
    and:
    loginButton.click()
    
    then:
    //check for ten seconds with one second intervals and wait for us to end up
    //on the home page after logging in
    waitFor (10, 1) { at HomePage }

    and:
    welcomeMessage == "Welcome, Stuart not you?"  
  }  
}