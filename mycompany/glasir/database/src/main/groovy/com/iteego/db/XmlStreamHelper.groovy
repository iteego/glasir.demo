/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

/**
 * Helper methods for working with Liquibase XML files.
 */
public class XmlStreamHelper {

  protected static File changeLogHeaderOverride = null

  public static synchronized getChangeLogHeaderOverride() { return changeLogHeaderOverride }
  public static synchronized setChangeLogHeaderOverride( File newValue ) { changeLogHeaderOverride = newValue }


  public static StringBuilder appendChangeLogHeader( StringBuilder stringBuilder ) {
    // First check if there is an override file to load this text from.
    File override = XmlStreamHelper.getChangeLogHeaderOverride();
    try {
      if( override?.exists() ) {
        stringBuilder.append( override.text )
        return stringBuilder
      }
    } catch( IOException e ) {
      println( "Failed to load xml header text from override file \"${override?.name}\". Error: ${e.message}" )
    }

    // No override, or override failed. Use a value that worked for Liquibase version 2.0.
    stringBuilder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
    stringBuilder.append("<databaseChangeLog \n")
    stringBuilder.append(" xmlns=\"http://www.liquibase.org/xml/ns/dbchangelog\" \n")
    stringBuilder.append(" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n")
    stringBuilder.append(" xmlns:ext=\"http://www.liquibase.org/xml/ns/dbchangelog-ext\" \n")
    stringBuilder.append(" xsi:schemaLocation=\"http://www.liquibase.org/xml/ns/dbchangelog")
    stringBuilder.append(" http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-2.0.xsd")
    stringBuilder.append(" http://www.liquibase.org/xml/ns/dbchangelog-ext")
    stringBuilder.append(" http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd\"> \n")
    return stringBuilder
  }

  public static StringBuilder appendChangeLogFooter( StringBuilder stringBuilder ) {
    stringBuilder.append("</databaseChangeLog>")
    return stringBuilder
  }


  /**
   * Create xml for a Liquibase change log file,
   * containing the Liquibase change log header,
   * then the string in the parameter,
   * then the Liquibase change log footer.
   * @param xmlChangeSetText Change set XML to use in the change log.
   * @return Header + parameter + Footer.
   */
  public static String createFakeChangeLogXml( String xmlChangeSetText ) {
    StringBuilder result = new StringBuilder()
    appendChangeLogHeader( result )
    result.append( xmlChangeSetText )
    appendChangeLogFooter( result )
    return result.toString()
  }

  /**
   * Create valid xml for a Liquibase change log file,
   * containing all change sets in the parameter,
   * as Liquibase include tags,
   * in order.
   * @param changes Change sets to use in the change log.
   * @return Valid XML string.
   */
  public static String createFakeChangeLogXml( List<XmlChange> changes ) {
    StringBuilder result = new StringBuilder()
    appendChangeLogHeader( result )
    changes.each { FileNameAndXml fnax ->
//      System.err.println( " create change log, file name ${fnax.getFileName()}" )
      String name = fnax.getFileName()
      if( XmlChangeSetTester.fileNameEndsWithZip(name) ) {
        name = ((XmlChange)fnax).xmlFileName
      }
      result.append( "  <include file=\"${name}\"/>\n" )
    }
    appendChangeLogFooter( result )
    return result.toString()
  }

  public static String createFakeChangeSetXml( FileNameAndXml change ) {
    StringBuilder result = new StringBuilder()
    result.append( change.getXmlData() )
    return result.toString()
  }

}
