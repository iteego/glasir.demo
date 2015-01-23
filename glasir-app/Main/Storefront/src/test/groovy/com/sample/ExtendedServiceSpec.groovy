/*
 * Copyright (C) 2011 Iteego Inc and Matias Bjarland <mbjarland@gmail.com>
 *
 * This file is part of Glasir, a Gradle build framework for ATG E-Commerce
 * projects created by Iteego Inc and Matias Bjarland.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.sample

import spock.lang.Shared
import spock.lang.Unroll
import spock.lang.Specification

/*
  A spock specification for ExtendedService

  See http://code.google.com/p/spock/wiki/SpockBasics for details about the
  excellent spock Behavior Driver Development testing framework
*/
class ExtendedServiceSpec extends Specification {
  //if we need to _force_ some output to the build console while running
  //tests, we can use out.println "message"
  PrintStream out = new PrintStream(new FileOutputStream(FileDescriptor.out))

  /*
    Run before every feature method
   */
  def setup() {
  }

  /*
    Run after every feature method
   */
  def cleanup() {

  }

  /*
    Run before he first feature method
   */
  def setupSpec() {
  }

  /*
    Run after the last feature method
   */
  def cleanupSpec() {
  }

  def "check that a user with correct values passes validation"() {
    when:
      def shopper = new ExtendedService(firstName: 'Bob', lastName: 'Smith', zip: '02115', baseProperty: 'foobar')

    then:
      shopper.isValidCustomer
  }

  //Unroll makes it so that every row in the data grid below results in a separate junit test in the resulting
  //report
  @Unroll
  def "check that firstName=#firstName, lastName=#lastName, zip=#zip, and baseProperty=#baseProperty results in validCustomer=#expectedValidation"() {
    setup:
      def shopper = new ExtendedService(firstName: firstName, lastName: lastName, zip: zip, baseProperty: baseProperty)

    expect:
      shopper.isValidCustomer == expectedValidation

    where:
      firstName    | lastName  | zip     | baseProperty | expectedValidation
      "Bob"        | "Smith"   | "02115" | "test"       | true
      ""           | "Smith"   | "02115" | "test"       | false
      null         | "Smith"   | "02115" | "test"       | false
      "Bob"        | ""        | "02115" | "test"       | false
      "Bob"        | null      | "02115" | "test"       | false
      "Bob"        | "Smith"   | ""      | "test"       | false
      "Bob"        | "Smith"   | null    | "test"       | false
      "Bob"        | "Smith"   | "0211"  | "test"       | false

      "Bob"        | "Smith"   | "02115" | ""           | false
      "Bob"        | "Smith"   | "02115" | null         | false
  }
}
