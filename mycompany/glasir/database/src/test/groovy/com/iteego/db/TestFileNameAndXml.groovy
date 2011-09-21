
/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import org.junit.Test
import org.junit.Before
import groovy.util.slurpersupport.GPathResult



public class TestFileNameAndXml {
  String xmlString
  File file
  GPathResult changeLog

  @Before
  public void setup() {
    String change =
    """<changeSet id="martin-test-002" author="iteego" context="prod">
        <preConditions>
          <tableExists schemaName="dbo" tableName="csr_grant_appease"/>
        </preConditions>

        <sql>
          select * from csr_grant_appease where 2=3
        </sql>

        <rollback>
          <sql>
            select * from csr_grant_appease where 2=354
          </sql>
        </rollback>

      </changeSet>
      """.toString();

    file = File.createTempFile( "unit-testing-", ".xml" )
    file.deleteOnExit()
    StringBuilder stringBuilder = new StringBuilder()
    XmlStreamHelper.appendChangeLogHeader( stringBuilder )
    stringBuilder.append( change )
    XmlStreamHelper.appendChangeLogFooter( stringBuilder )
    xmlString = stringBuilder.toString()
    file.write( xmlString )

    groovy.util.XmlSlurper xmlSlurper = new groovy.util.XmlSlurper()
    changeLog = xmlSlurper.parse( file ) // GPathResult actually
  }

  @Test
  public void testXmlValuePreservation() {
    FileNameAndXml xmlChange = new XmlChange( file, changeLog, file.text )
    FileNameAndXml ranChange = new RanChangeSetAndRollbackData( null, xmlString, null )

    String readBack = xmlChange.getXmlData()
    org.junit.Assert.assertEquals( "Differing XML for file '${file.name}'.", readBack, ranChange.getXmlData() )
  }

  @Test
  public void testKeyCreation() {
    FileNameAndXml xmlChange = new XmlChange( file, changeLog, file.text )

    org.junit.Assert.assertEquals(
        "XmlChange key creation failed.",
        "martin-test-002:iteego:${file.name}".toString(),
        xmlChange.key )
  }
}