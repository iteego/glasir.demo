package com.iteego.bootstrap

import atg.nucleus.GenericService

/**
 * Dummy service to demonstrate spock specification driven testing. See
 * SampleServiceSpec.groovy for the associated specification
 */
class SampleService extends GenericService {
  String firstName
  String lastName
  String zip

  boolean getIsValidCustomer() {
    //in a boolean context a (null, empty string, or zero) evaluates to false in groovy
    //the ?. operator in groovy is null safe. null?.property() will just return null
    firstName?.length() && lastName?.length() && (zip?.length() == 5 || zip?.length() == 10)
  }
}
