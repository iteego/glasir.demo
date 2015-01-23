package com.glasir.geb.specs

import spock.lang.*
import geb.*
import geb.spock.*
import com.glasir.geb.pages.LoginPage
import com.glasir.geb.pages.HomePage


//for a description of BDD, see http://en.wikipedia.org/wiki/Behavior_Driven_Development
class CartGebSpec extends GebReportingSpec {

  def "should display item in cart when user hits the add-to-cart button"() {
    when: "we are on a product details page"
    and:  "we select a specific product size and color"
    and:  "we hit the add-to-cart button"
    
    then: "the correct product should be displayed in the cart widget"
  }  
  
}