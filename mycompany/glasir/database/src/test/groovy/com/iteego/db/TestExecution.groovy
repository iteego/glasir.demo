
/*
 * Copyright (c) 2011. Iteego.
 */

/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import org.junit.Test
import org.junit.Assert
import java.sql.Connection
import java.sql.DriverManager

public class TestExecution {
  AtgLogHelper logger = new com.iteego.db.TestAtgLogHelper()

  class TestDescription {
    public File directory
    public ProgressListener listener
    public boolean allowRollback
    public String dbName
    public String rollbackLimit

    TestDescription( File directory, ProgressListener listener, boolean allowRollback, String dbName, String rollbackLimit ) {
      this.directory = directory
      this.listener = listener
      this.allowRollback = allowRollback
      this.dbName = dbName
      this.rollbackLimit = rollbackLimit
    }
  }


  public TestDescription testWithAllParams(
    String dbName,
    boolean allowRollback,
    String rollbackLimit,
    List<String> ids,
    List<String> expectedRollbackKeys,
    List<String> expectedUpdateKeys,
    List<String> expectedKeys,
    File reuseDirectory = null )
  {
    File testDir = reuseDirectory ?: createFilesInNewFolder( ids )
    System.err.println "testDir: $testDir"

    ProgressListener progressListener = new ProgressListener()
    progressListener.expectedRollbackKeys.addAll( makeKeys(expectedRollbackKeys) )
    progressListener.expectedUpdateKeys.addAll( makeKeys(expectedUpdateKeys) )
    progressListener.expectedKeys.addAll( makeKeys(expectedKeys) )

    TestDescription test = new TestDescription(
        testDir, progressListener, allowRollback, dbName, rollbackLimit )

    testSingle( test )

    return test
  }


  public static String makeKey( String id ) {
    return "${id}:iteego:${id}.xml"
  }
  public static List<String> makeKeys( List<String> ids ) {
    return ids.collect{ makeKey(it) }
  }
  public static List<String> makeKeys(String[] ids ) {
    return makeKeys( ids.toList() )
  }

  @Test
  public void testTrivial() {
    System.err.println "---- Start testNoChange "
    String dbName = UUID.randomUUID().toString()
    boolean allowRollback = true
    String rollbackLimit = null

    // Run a against a clean database.
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A"],
        [], ["1_A"], ["1_A"] )

    // Run b (0 rollbacks, 1 update).
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B"],
        [], ["2_B"], ["1_A","2_B"] )

    // Run c (0 rollbacks, 1 update).
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], ["3_C"], ["1_A","2_B","3_C"] )
  }


  @Test
  public void testSequences() {
    System.err.println "---- Start testSequences "
    String dbName = UUID.randomUUID().toString()
    boolean allowRollback = true
    String rollbackLimit = null

    // Run a,b,c against a clean database.
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], ["1_A","2_B","3_C"], ["1_A","2_B","3_C"] )

    // Take out change set "2_B" and run again against the same database (roll back c,b then run c).
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","3_C"],
        ["2_B","3_C"], ["3_C"], ["1_A","3_C"] )

    // Put "2_B" back again (roll back c then run b,c) to bring it back to the state after test1.
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        ["3_C"], ["2_B","3_C"], ["1_A","2_B","3_C"] )
  }

  @Test
  public void testNoChange() {
    System.err.println "---- Start testNoChange "
    String dbName = UUID.randomUUID().toString()
    boolean allowRollback = true
    String rollbackLimit = null

    // Run a,b,c against a clean database.
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], ["1_A","2_B","3_C"], ["1_A","2_B","3_C"] )

    // Run same again (no rollbacks, no updates).
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], [], ["1_A","2_B","3_C"] )
  }

  @Test
  public void testAllGone() {
    System.err.println "---- Start testAllGone "
    String dbName = UUID.randomUUID().toString()
    boolean allowRollback = true
    String rollbackLimit = null

    // Run a,b,c against a clean database.
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], ["1_A","2_B","3_C"], ["1_A","2_B","3_C"] )

    // TEST FAILS: NO ROLLBACKS DONE

    // Remove all (3 rollbacks, no updates).
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        [],
        ["1_A","2_B","3_C"], [], [] )
  }

  @Test
  public void testAllGoneLimit() {
    System.err.println "---- Start testAllGoneLimit "
    String dbName = UUID.randomUUID().toString()
    boolean allowRollback = true
    String rollbackLimit = makeKey( "1_A" )

    // Run a,b,c against a clean database.
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], ["1_A","2_B","3_C"], ["1_A","2_B","3_C"] )

    // TEST FAILS: NO ROLLBACKS DONE

    // Remove all (2 rollbacks - limited, no updates).
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        [],
        ["2_B","3_C"], [], ["1_A"] )
  }

  @Test
  public void testAllGoneNoRollback() {
    System.err.println "---- Start testAllGoneNoRollback"
    String dbName = UUID.randomUUID().toString()
    boolean allowRollback = false
    String rollbackLimit = null

    // Run a,b,c against a clean database.
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], ["1_A","2_B","3_C"], ["1_A","2_B","3_C"] )

    // Remove all (3 rollbacks, no updates).
    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        [],
        [], [], ["1_A","2_B","3_C"] )
  }

  @Test
  public void testAlteredFile() {
    System.err.println "---- Start testAlteredFile"
    String dbName = UUID.randomUUID().toString()
    boolean allowRollback = true
    String rollbackLimit = null

    // Run a,b,c against a clean database.
    TestDescription test = testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], ["1_A","2_B","3_C"], ["1_A","2_B","3_C"] )


    // Alter change set "2_B" and run again against the same database (roll back c,b then run c).
    File f2b = new File( test.directory, "2_B.xml" )
    String xml2 = f2b.text.replaceAll( "table_2_B", "another_table_name" )
    f2b.write( xml2 )

    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"], // this id-array is not used because we use the same directory again
        ["2_B","3_C"], ["2_B","3_C"], ["1_A","2_B","3_C"],
        test.directory )
  }


  @Test( expected=liquibase.exception.ValidationFailedException.class )
  public void testAlteredFileNoRollback() {
    System.err.println "---- Start testAlteredFileNoRollback"
    String dbName = UUID.randomUUID().toString()
    boolean allowRollback = false
    String rollbackLimit = null

    // Run a,b,c against a clean database.
    TestDescription test = testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"],
        [], ["1_A","2_B","3_C"], ["1_A","2_B","3_C"] )


    // Alter change set "2_B" and run again against the same database
    // (expect exception when liquibase change set parser detects that 2_B has changed).
    File f2b = new File( test.directory, "2_B.xml" )
    String xml2 = f2b.text.replaceAll( "table_2_B", "another_table_name" )
    f2b.write( xml2 )

    testWithAllParams(
        dbName, allowRollback, rollbackLimit,
        ["1_A","2_B","3_C"], // this id-array is not used because we use the same directory again
        ["2_B","3_C"], ["2_B","3_C"], ["1_A","2_B","3_C"],
        test.directory )
  }



    @Test
    public void testAlteredFileHashSameLiquibaseHash() {
      System.err.println "---- Start testAlteredFileHashSameLiquibaseHash"
      String dbName = UUID.randomUUID().toString()
      boolean allowRollback = true
      String rollbackLimit = null

      // Run a,b,c against a clean database.
      TestDescription test = testWithAllParams(
          dbName, allowRollback, rollbackLimit,
          ["1_A","2_B","3_C"],
          [], ["1_A","2_B","3_C"], ["1_A","2_B","3_C"] )


      // Alter change set "2_B" in a non-essential way and run again against the same database (0 rollbacks, 0 updates).
      File f2b = new File( test.directory, "2_B.xml" )
      String xml2 = f2b.text.replace( "</changeSet>", "<!-- Should not affect the content hash, only the file hash -->\n  </changeSet>" )
      f2b.write( xml2 )

      testWithAllParams(
          dbName, allowRollback, rollbackLimit,
          ["1_A","2_B","3_C"], // this id-array is not used because we use the same directory again
          [], [], ["1_A","2_B","3_C"],
          test.directory )
    }



  public void testSingle( TestDescription test ) {
     // 1. Create files (with some simple change) for all change set names.
     File testDir = test.directory

     // 2. Get a clean new H2 database.
     String h2ConnectionString = "jdbc:h2:mem:${test.dbName};DB_CLOSE_ON_EXIT=FALSE"
     Connection conn = DriverManager.getConnection( h2ConnectionString )
     Connection testConn = DriverManager.getConnection( h2ConnectionString )

     // 3. Get a Liquibase object.
     LiquibaseService service = new LiquibaseService(
         allowRollback: test.allowRollback,
         progressListener: test.listener,
         migrationRootDir: testDir.parentFile )
     service.logger = logger
     LiquibaseService.atgLogHelper = logger
     service.rollbackLimits[testDir.name] = test.rollbackLimit

     // 4. Collect change sets from the files in testDir.
     List<File> files = XmlChangeSetTester.getChangeSetFiles( testDir )
     List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( files )

     // 5. Update
     service.doUpdate( conn, testDir.name, changeSets )

     // 6. Verify
     Assert.assertEquals( "Expected ${test.listener.expectedRollbackKeys.size()} rollbacks.", test.listener.expectedRollbackKeys.size(), test.listener.rollbackQueueSize() )
     Assert.assertEquals( "Expected ${test.listener.expectedUpdateKeys.size()} updates.", test.listener.expectedUpdateKeys.size(), test.listener.updateQueueSize() )

     List<String> expXml = new ArrayList<String>()
     test.listener.expectedKeys.size().times { expXml.add(null) } // todo: replace with real xml data from the files
     TestDatabase.testChangeLog( testConn, test.listener.expectedKeys.size(), test.listener.expectedKeys, expXml, null )

     test.listener.expectedRollbackKeys.eachWithIndex { String key, index ->
       ProgressListener.Data data = test.listener.rollbackData[index]
       Assert.assertEquals( "Rollback key error on index $index.", key, data.key )
     }

     test.listener.expectedUpdateKeys.eachWithIndex { String key, index ->
       ProgressListener.Data data = test.listener.updateData[index]
       Assert.assertEquals( "Update key error on index $index.", key, data.key )
     }
  }


  File createFilesInNewFolder( List<String> changeSetNames ) {
    File testDir = TestDatabase.createTempFolder()
    changeSetNames.each {
      TestDatabase.createTestXmlFile( it, testDir, "table_$it" )
    }
    return testDir
  }
}