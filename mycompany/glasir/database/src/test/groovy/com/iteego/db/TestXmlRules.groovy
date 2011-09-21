/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import org.junit.Before
import org.junit.Test
import org.junit.After
import org.junit.Assert


public class TestXmlRules{
  @Before
  public void setup(){
    println "test setup"
	}

  @After
  public void tearDown() {
    println "after test"
  }


  @Test
  public void testReplacementXmlHeader() {
    File file = File.createTempFile( "AtgDbTestReplacementXmlHeader", ".xml" )
    file.deleteOnExit()
    String testText = "this is not xml"
    file.text = testText
    XmlStreamHelper.setChangeLogHeaderOverride( file )

    StringBuilder stringBuilder = new StringBuilder()
    String returnedHeaderValue = XmlStreamHelper.appendChangeLogHeader( stringBuilder ).toString()
    Assert.assertEquals( "This was not the text we were looking for.", testText, returnedHeaderValue )

    XmlStreamHelper.setChangeLogHeaderOverride( null )
    stringBuilder = new StringBuilder()
    returnedHeaderValue = XmlStreamHelper.appendChangeLogHeader( stringBuilder ).toString()
    Assert.assertTrue( "Header should start with xml tag.", returnedHeaderValue.startsWith("<?xml version") )
  }


  @Test
  public void testOkXml(){
    String testXml =
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
    """.toString()

    def result = doXmlTest( testXml )
    assert result
	}


	@Test( expected=MissingPreCondition.class )
  public void testBadXmlNoPrecondition(){
    String testXml = """
      <changeSet id="martin-test-002" author="iteego" context="prod">
        <sql>
          select * from csr_grant_appease where 2=3
        </sql>

        <rollback>
          <sql>
            select * from csr_grant_appease where 2=354
          </sql>
        </rollback>

      </changeSet>
      """

    //noinspection GroovyUnusedAssignment
    def result = doXmlTest( testXml )
	}


  @Test( expected=MissingRollback.class )
  public void testBadXmlNoRollback(){
    String testXml = """
      <changeSet id="martin-test-002" author="iteego" context="prod">
        <preConditions>
          <tableExists schemaName="dbo" tableName="csr_grant_appease"/>
        </preConditions>

        <sql>
          select * from csr_grant_appease where 2=3
        </sql>
      </changeSet>
      """

    //noinspection GroovyUnusedAssignment
    def result = doXmlTest( testXml )
  }


  @Test( expected=MissingRollback.class )
  public void testBadXmlNoPreconditionAndNoRollback(){
    String testXml = """
      <changeSet id="martin-test-002" author="iteego" context="prod">
        <sql>
          select * from csr_grant_appease where 2=3
        </sql>
      </changeSet>
      """

    //noinspection GroovyUnusedAssignment
    def result = doXmlTest( testXml )
  }


  private Object doXmlTest( String testXml ) {
    String changeLog = XmlStreamHelper.createFakeChangeLogXml( testXml )
    InputStream fakeFileStream = new ByteArrayInputStream( changeLog.getBytes("UTF-8") )
    def result = XmlChangeSetTester.testChangeSetFile( fakeFileStream )
    return result
  }
}