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
package com.iteego.glasir.build.core

import spock.lang.Shared
import spock.lang.Unroll
import spock.lang.Specification

class DurationFormatterSpecification  extends Specification {
  PrintStream out = new PrintStream(new FileOutputStream(FileDescriptor.out))

  @Shared DurationFormatter formatter

  def setup() {
  }

  def cleanup() {

  }

  def setupSpec() {
    formatter = new DurationFormatter()
  }

  def cleanupSpec() {
  }

  @Unroll({"Expect duration '#before' to parse into number '#expectedMillis' and back to '#after'"})
  def "Expect durationString to parse into milliseconds"() {
    setup:
      def parsedMillis = formatter.durationStringToMillis(before)

    expect:
      parsedMillis == expectedMillis
      formatter.millisToDurationString(parsedMillis) == after

    where:
      before                  | expectedMillis  | after
      "5 milliseconds"        | 5               | "5 milliseconds"
      "50 milliseconds"       | 50              | "50 milliseconds"
      "500 milliseconds"      | 500             | "500 milliseconds"
      "5000 milliseconds"     | 5000            | "5 seconds"
      "50000 milliseconds"    | 50000           | "50 seconds"
      "70000 milliseconds"    | 70000           | "1 minute, 10 seconds"
      "10 seconds"            | 10000           | "10 seconds"
      "70 seconds"            | 70000           | "1 minute, 10 seconds"
      "1 minute"              | 60000           | "1 minute"
      "2 minutes"             | 120000          | "2 minutes"
      "70 minutes"            | 4200000         | "1 hour, 10 minutes"
  }
}
