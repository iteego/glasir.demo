/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import groovy.util.slurpersupport.GPathResult
import java.util.zip.ZipFile
import java.util.zip.ZipEntry

public class XmlChangeSetTester 
{ 
	static final int MAX_CHANGESETS_PER_FILE = 1
	static final boolean REQUIRE_ROLLBACK_TAG = true
	static final boolean REQUIRE_PRECONDITION_TAG = true


	public static boolean testXmlData( String directory ) { 
		println( "Collecting change set files from directory \"${directory}\"." ) 
		List<File> xmlFiles = getChangeSetFiles( new File( directory ) )
		
		xmlFiles.each { 
			println( "  Testing change set file \"${it.name}\"." ) 
			testChangeSetFile( it )
		}

    return true
	}
	
  /**
   * @return A list of all *.xml files in the given folder, not recursively.
   */
	public static List<File> getChangeSetFiles( File folder, AtgLogHelper log = null ) {
		List<File> result = null
		if( folder.exists() ) {
			result = new ArrayList<File>()
			folder.eachFileMatch( { String name -> name.toLowerCase().matches( ".*\\.xml|.*\\.zip" ) } ) {
				if( it.canRead() ) {
          result.add( it )
				} else {
					String message = "File \"${it.absolutePath}\" can not be read. Change permissions and restart."
					throw new IOException( message )
				}
			}
			result.sort { it.name }
		}

		log?.info( "Collected ${result?.size() ?: '0'} .zip and .xml files from folder \"${folder.path}\"." )
		return result
	}


  public static List<XmlChange> getChangeSets( List<File> changeSetFiles, AtgLogHelper log = null ) {
    // Map file name (not including path) to changeSet tag data.
    if( changeSetFiles == null ) {
      log?.debug( "No change set files in list to getChangeSets()." )
      return null
    }

    log?.debug( "Start getChangeSets()." )

    List<XmlChange> changeSets = new ArrayList<XmlChange>( changeSetFiles.size() )
    changeSetFiles.each { File file ->
      String fileData = null

      if( file.name.toLowerCase().endsWith(".zip") ) {
        fileData = xmlFileDataFromZipFile( file )
      } else {
        fileData = file.text
      }

      GPathResult gPath = testChangeSetFile( new ByteArrayInputStream( fileData.getBytes("UTF-8") ) )

      if( gPath != null ) {
        XmlChange thisChange = new XmlChange( file, gPath, fileData )
        thisChange.fileData = fileData
        thisChange.fileHash = liquibase.util.MD5Util.computeMD5( file.newInputStream() )

        String xmlFileName
        if( fileNameEndsWithZip(file.name) ) {
          xmlFileName = xmlFileNameFromZipFile( file )
          thisChange.container = file
        } else {
          xmlFileName = file.name
        }

        thisChange.xmlFileName = xmlFileName
        changeSets.add( thisChange )
      } else {
        log?.warning( "File \"${file.name}\" did not parse properly." )
      }
    }

    log?.debug( "End getChangeSets()." )
    return changeSets
  }

  /**
   * Simple test of a zip file.
   * @return True if the file can be read as a zip file and contains a single .xml file. Else false.
   */
  static boolean zipFileHasSingleXmlEntry( File file ) {
    def z = new ZipFile( file )
    int count = 0
    def entries = z.entries()
    while( entries.hasMoreElements() ) {
      count++
      ZipEntry entry = entries.nextElement()
      if( !entry.name.toLowerCase().endsWith(".xml") ) {
        return false
      }
    }
    return count == 1
  }

  static boolean fileNameEndsWithZip( String name ) {
    return name.toLowerCase().endsWith(".zip")
  }

  static String xmlFileNameFromZipFile( File zipFile ) {
    ZipEntry e = new ZipFile( zipFile ).entries().toList().first()
    return e.name
  }

  /**
   * Read the data from the first entry in the given zip file.
   * @param zipFile Assumed to be a usable file.
   * @return The file data as a String.
   */
  static String xmlFileDataFromZipFile( File zipFile ) {
    def z = new ZipFile( zipFile )
    def e = z.entries().toList().first() // Be sure that it contains exactly one file.
    InputStream inStream = z.getInputStream( e )
    InputStreamReader isr = new InputStreamReader( inStream, "UTF-8" )
    BufferedReader br = new BufferedReader( isr )
    return br.text
  }


  public static GPathResult testChangeSetFile( File changeSetFile, AtgLogHelper log = null ) {
    GPathResult result = null
    try {
      InputStream inStream = null
      if( changeSetFile.name.toLowerCase().endsWith(".zip") ) {
        // This could be a zip file, verify..
        if( zipFileHasSingleXmlEntry(changeSetFile) ) {
          //..looks legit..
          log?.info( "Zip found." )
          def z = new ZipFile( changeSetFile )
          def e = z.entries().toList().first() // Safe, because it has been tested to contain exactly one file. Unless someone changed it after the test..
          inStream = z.getInputStream( e )
        } else {
          //..not ok so we ignore this file
          log?.info( "Ignoring .zip file '${changeSetFile.name}' because it fails the zip file test (single .xml file expected)." )
        }
      } else {
        log?.info( "Assuming XML." )
        inStream = new FileInputStream( changeSetFile )
      }

      if( inStream != null ) {
        result = testChangeSetFile( inStream )
      } else {
        //..not ok so we ignore this file
        if( log != null ) {
          log.warning( "File '${changeSetFile.name}' could not be used (input stream is null)." )
        }
      }
    } catch( TooManyChangeSets e ) {
      // Add more data (file name) to this particular error type.
      throw new TooManyChangeSets( "In file \"${changeSetFile.name}\". ${e.message}" )
    }
    return result
  }

  /**
   * Method to test change sets. Will throw exceptions if the change set in the stream does not follow the rules.
   * @param changeSetFile File to test.
   * @param log For logging.
   * @return Parsed XML.
   */
	public static GPathResult testChangeSetFile( InputStream changeSetFile, AtgLogHelper log = null )
    throws TooManyChangeSets, MissingRollback, MissingPreCondition
  {
    // If you print it here the stream will have to be reset or you will see a " java.io.IOException: Read error"
    //println "Testing data '$changeSetFile'"

		groovy.util.XmlSlurper xmlSlurper = new groovy.util.XmlSlurper()
    GPathResult changeLog
    try {
		  changeLog = xmlSlurper.parse( changeSetFile ) // GPathResult actually
    } catch( Throwable throwable ) {
      log?.error( "ERROR: $throwable, ${throwable.message}, ${throwable.toString()}" )
      throw throwable
    }

		def changeSets = changeLog.changeSet

		// Test number of changeSet tags in this file.
		if( changeSets.size() > MAX_CHANGESETS_PER_FILE ) {
			throw new TooManyChangeSets( "Change Log has ${changeSets.size()} <changeSet> tags. More than 1 is not allowed." )
		}
		
		changeSets.each {
			// Look for <rollback> tag. This whole project is about automatic rollbacks so rollback is required.
			def rollbacks = it.rollback
			if( REQUIRE_ROLLBACK_TAG && ((rollbacks==null) || (rollbacks.size()==0)) ) {
				throw new MissingRollback( "Change Set \"${it.@id}\" has no <rollback> tags. At least 1 is required. Empty tags are allowed: <rollback/>" )
			}
			
			// Look for <preConditions> tag. It's for your own good. You should check that the [whatever] you use really exist.
			def preconditions = it.preConditions
			if( REQUIRE_PRECONDITION_TAG && ((preconditions==null) || (preconditions.size()==0)) ) {
				throw new MissingPreCondition( "Change Set \"${it.@id}\" has no <preConditions> tags. At least 1 is required. Empty <preCondition> tags are not allowed." )
			}
		}

		return changeLog
	}

}


  public static class MissingPreCondition extends Exception {
    public MissingPreCondition( String message ) {
      super( message )
    }
  }

  public static class MissingRollback extends Exception {
    public MissingRollback( String message )  {
      super( message )
    }
  }

  public static class TooManyChangeSets extends Exception {
    public TooManyChangeSets( String message )  {
      super( message )
    }
  }
