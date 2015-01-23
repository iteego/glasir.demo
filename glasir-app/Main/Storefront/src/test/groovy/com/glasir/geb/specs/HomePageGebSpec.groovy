package com.glasir.geb.specs

import spock.lang.*
import geb.*
import geb.spock.*
import com.glasir.geb.pages.LoginPage
import com.glasir.geb.pages.HomePage

//for a description of BDD, see http://en.wikipedia.org/wiki/Behavior_Driven_Development
class HomePageGebSpec extends GebReportingSpec {

  def "should display 'Sign In' for the home page log in link instead of 'Login'"() {
    when:
    to HomePage
        
    then:
    loginLink?.text()?.trim() == "Sign In"
  } 

}