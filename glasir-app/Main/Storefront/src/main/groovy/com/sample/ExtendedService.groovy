package com.sample

import atg.nucleus.GenericService

/**
 * Dummy service to demonstrate spock specification driven testing. See
 * ExtendedServiceSpec.groovy for the associated specification. This service 
 * also demonstrates that code in one atg module can depend on code in another, as long
 * as the correct ATG-Requires attribute is set in the module manifest file. 
 */
class ExtendedService extends BaseService {
  String firstName
  String lastName
  String zip

  boolean getIsValidCustomer() {
    //in a boolean context a (null, empty string, or zero) evaluates to false in groovy
    //the ?. operator in groovy is null safe. null?.property() will just return null
    firstName?.length() && lastName?.length() && (zip?.length() == 5 || zip?.length() == 10) &&
    baseProperty
  }
}
