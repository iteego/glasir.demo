/*
* Copyright (c) 2011. Iteego.
*/

package com.iteego.db

import org.junit.Before
import org.junit.Test
import org.junit.After
import org.junit.Assert
import java.util.zip.ZipOutputStream
import java.util.zip.ZipEntry
import java.sql.Connection
import java.sql.DriverManager
import liquibase.database.DatabaseFactory
import liquibase.database.jvm.JdbcConnection
import liquibase.database.Database

public class TestZipHandling {
  File zipFile = null
  AtgLogHelper logger = new com.iteego.db.TestAtgLogHelper()
  String xmlFileContents = null
  String zipFileHash = null



  @Before
  public void setup() {
    // create a zip file
    File fileA = TestDatabase.createTestXmlFile("change-set-a", null, "table_a")
    xmlFileContents = fileA.text
    logger.debug( "File A: " + fileA.text )
    zipFile = zipFiles( fileA.parentFile, "myChanges.zip", true )
    zipFile.deleteOnExit()
    fileA.parentFile.deleteOnExit()
    logger.info( "Zip file A name: ${zipFile.name}" )

    zipFileHash = liquibase.util.MD5Util.computeMD5( zipFile.newInputStream() )

    int fileCount = 0
    fileA.parentFile.eachFile { fileCount++ }
    Assert.assertTrue( "Source file delete failed in zip utility method.", fileCount == 1 )
    Assert.assertTrue( "Zip file has no size.", zipFile.size() > 0 )
  }

  @After
  public void tearDown() {
  }


  @Test
  public void testChangeSetFinderInZipFile() {
    List<File> changeSetFiles = XmlChangeSetTester.getChangeSetFiles( zipFile.parentFile )
    List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( changeSetFiles, logger )

    Assert.assertEquals("Wrong number of change sets parsed from zip file.", 1, changeSets.size() )

    XmlChange xmlChange = changeSets.first()
    Assert.assertEquals("Wrong change set ID.", "change-set-a", xmlChange.id )
    Assert.assertEquals("Wrong change set author.", "iteego", xmlChange.author )
    logger.info "xmlChange fileName: ${xmlChange.fileName}"
    logger.info "xmlChange file.name: ${xmlChange.file.name}"
    logger.info "xmlChange file data: ${xmlChange.getXmlData()}"
  }


  @Test
  public void testRunLiquibaseServiceWithZipFiles() {
    logger.info( "------- Test: testRunLiquibaseServiceWithZipFiles" )
    Class.forName("org.h2.Driver")
    // Note that the database name is different than in other tests so as not to interfere with them.
    String h2ConnectionString = "jdbc:h2:mem:testdb2;DB_CLOSE_ON_EXIT=FALSE"//;LOCK_MODE=0"
    Connection conn = DriverManager.getConnection( h2ConnectionString )
    Connection testConn = DriverManager.getConnection( h2ConnectionString )

    Database database =
      DatabaseFactory.getInstance().findCorrectDatabaseImplementation(
        new JdbcConnection(conn))

    List<File> files = [zipFile] as List<File>
    List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( files )
    logger.info( "Files: ${files?.size()}. ChangeSets: ${changeSets?.size()}.")
    LiquibaseService service = new LiquibaseService()
    service.logger = logger
    LiquibaseService.atgLogHelper = logger
    service.migrationRootDir = zipFile.parentFile.parentFile
    service.doUpdate( conn, zipFile.parentFile.name, changeSets )

    // A zip file hash will differ between tests (because of  so there is no CONSTANT to validate against.
    TestDatabase.testChangeLog( testConn, 1, "change-set-a", "iteego", xmlFileContents, zipFileHash )
  }

  @Test
  public void testChangedZipFileForcesRollback() {
    // Verify that a change to the XML change set inside a .zip file forces rollback-and-reapply of the change set.
    logger.info( "------- Test: testChangedZipFileForcesRollback" )

    // Set up files. They will have different parent directories.
    File fileA = TestDatabase.createTestXmlFile("change-set-a", null, "table_a")
    File fileB = TestDatabase.createTestXmlFile("change-set-a", null, "table_b")
    String xmlA = fileA.text
    String xmlB = fileB.text
    File zipFileA = zipFiles( fileA.parentFile, "myChanges.zip", true )
    File zipFileB = zipFiles( fileB.parentFile, "myChanges.zip", true )
    String zipFileHashA = liquibase.util.MD5Util.computeMD5( zipFileA.newInputStream() )
    String zipFileHashB = liquibase.util.MD5Util.computeMD5( zipFileB.newInputStream() )


    Class.forName("org.h2.Driver")
    // Note that the database name is different than in other tests so as not to interfere with them.
    String h2ConnectionString = "jdbc:h2:mem:testdb3;DB_CLOSE_ON_EXIT=FALSE"//;LOCK_MODE=0"
    Connection connA = DriverManager.getConnection( h2ConnectionString )
    Connection connB = DriverManager.getConnection( h2ConnectionString )
    Connection testConnA = DriverManager.getConnection( h2ConnectionString )
    Connection testConnB = DriverManager.getConnection( h2ConnectionString )

    Database database =
      DatabaseFactory.getInstance().findCorrectDatabaseImplementation(
        new JdbcConnection(connA))

    List<File> files = [zipFileA] as List<File>
    List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( files )
    logger.info( "Files: ${files?.size()}. ChangeSets: ${changeSets?.size()}.")

    LiquibaseService service = new LiquibaseService()
    service.allowRollback = true
    service.logger = logger
    LiquibaseService.atgLogHelper = logger
    service.migrationRootDir = zipFileA.parentFile.parentFile

    service.doUpdate( connA, zipFileA.parentFile.name, changeSets )

    // A zip file hash will differ between tests (because of  so there is no CONSTANT to validate against.
    TestDatabase.testChangeLog( testConnA, 1, "change-set-a", "iteego", xmlA, zipFileHashA )


    // Now run the service again but use a .zip file with "altered" XML content.
    files = [zipFileB] as List<File>
    changeSets = XmlChangeSetTester.getChangeSets( files )
    service.migrationRootDir = zipFileB.parentFile.parentFile
    service.doUpdate( connB, zipFileB.parentFile.name, changeSets )
  }


  /**
   * Utility to zip all files in a directory into single file (placed in the same directory).
   * @param inputDir Where source files are, also where output file will be placed.
   * @param outputFileName Just the file name like "myzipfile.zip". Will be overwritten if it already exists.
   * @param deleteSourceFiles True to remove source files after they have been put in the zip file.
   * @return The zip file.
   */
  public static File zipFiles( File inputDir, String outputFileName, boolean deleteSourceFiles, boolean deleteZipOnExit = true ) {
    String zipFileName = outputFileName + (outputFileName.toLowerCase().endsWith(".zip") ? "" : ".zip")
    File outputFile = new File(inputDir, zipFileName)
    if( outputFile.exists() ) {
      outputFile.delete()
    }
    ZipOutputStream zipFile = new ZipOutputStream(new FileOutputStream(outputFile))

    inputDir.eachFile() { file ->
      if( file.name != outputFileName ) {
        zipFile.putNextEntry(new ZipEntry(file.getName()))
        //System.err.println "File size is ${file.size()}"
        def buffer = new byte[1024]
        file.withInputStream { i ->
          def l = i.read(buffer)
          while( l > 0 ) {
            zipFile.write(buffer, 0, l)
            //System.err.println( "Writing $l bytes to entry ${file.getName()}: ${buffer[0..l-1]}")
            l = i.read( buffer )
          }
        }
        zipFile.closeEntry()
        if( deleteSourceFiles ) {
          file.delete()
        }
      }
    }
    zipFile.close()

    if( deleteZipOnExit ) {
      outputFile.deleteOnExit()
    }

    return outputFile
  }

}