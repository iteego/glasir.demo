/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import java.sql.Connection
import javax.sql.DataSource
import javax.naming.InitialContext

/**
 * A Nucleus preinitializer required for this module, the name of a class that implements
 * interface atg.applauncher.initializer.Initializer. This class must be in the CLASSPATH
 * specified by attributes ATGClassPath or ATGAssemblerClassPath. Before Nucleus starts in
 * the assembled application EAR file, the initialize() method for each of the named
 * classes is invoked.
 *
 * Read about ATG-Nucleus-Initializer and atg.applauncher.initializer.Initializer on
 * http://download.oracle.com/docs/cd/E23095_01/Platform.93/ATGProgGuide/html/s0403applicationmodulemanifestfile01.html
 */
class GlasirInitializer implements atg.applauncher.initializer.Initializer
{
  public void initialize()
  {
    DataSource dataSource = dataSourceFromInitialContext( "java:ATGCatalogDS" )
    Connection connection = dataSource?.connection
    println "Initializer: Connection = $connection"
  }


  protected DataSource dataSourceFromInitialContext( String jndiName )
  {
    Object dataSourceObject
    try {
      dataSourceObject = new InitialContext().lookup( jndiName )
    } catch( javax.naming.NameNotFoundException ex ) {
      println( "JNDI name \"$jndiName\" not found. The error is either in the JNDI configuration (add a binding), or in the \"directoryToJndiMap\" property (change or remove a mapping) for this service." )
      throw ex
    }


    if (dataSourceObject == null) {
      println "lookup"
      throw new Exception("InitialContext().lookup( '$jndiName' ) returned null." )
    }

    if (!(dataSourceObject instanceof DataSource)) {
      throw new Exception("Data Source returned by looking up $jndiName is not instance of javax.sql.DataSource: $dataSourceObject")
    }

    DataSource dataSource = dataSourceObject as DataSource
    return dataSource
  }
}
