/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

//import com.h2database

// debug:
// 1. export JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,address=localhost:5005,suspend=y"
// 2. gradle test
// 3. attach idea debugger (configuration "remote" to localhost:5005)


import java.sql.Connection
import java.sql.DriverManager
import java.sql.ResultSet
import java.sql.Statement
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import liquibase.Liquibase
import liquibase.changelog.ChangeSet.ExecType
import liquibase.changelog.DatabaseChangeLog
import liquibase.changelog.RanChangeSet
import liquibase.database.Database
import liquibase.database.DatabaseFactory
import liquibase.database.jvm.JdbcConnection
import liquibase.database.structure.Table
import liquibase.executor.Executor
import liquibase.executor.ExecutorService
import liquibase.resource.ClassLoaderResourceAccessor
import liquibase.resource.CompositeResourceAccessor
import liquibase.resource.FileSystemResourceAccessor
import liquibase.resource.ResourceAccessor
import liquibase.servicelocator.ServiceLocator
import liquibase.snapshot.DatabaseSnapshotGeneratorFactory
import liquibase.statement.core.AddColumnStatement
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import liquibase.database.core.H2Database
import liquibase.change.core.RawSQLChange
import liquibase.changelog.ChangeSet

import liquibase.change.CheckSum
import liquibase.exception.ChangeLogParseException

/**
 * Integration-style tests using h2 in-memory database.
 */
public class TestDatabase {
  final String ROLLBACK_COLUMN_NAME = LiquibaseService.ROLLBACK_COLUMN_NAME
  String h2ConnectionString = "jdbc:h2:mem:testdb;DB_CLOSE_ON_EXIT=FALSE"//;LOCK_MODE=0"
  Connection conn = null
  Connection conn2 = null
  Connection conn3 = null
  Connection conn4 = null
  Connection conn5 = null
  Liquibase liquibase = null
  Database database = null

  @Before
  public void setup() {
    LiquibaseService.setAtgLogHelper( new TestAtgLogHelper() )

    Class.forName("org.h2.Driver")
    conn = DriverManager.getConnection(h2ConnectionString)
    conn2 = DriverManager.getConnection(h2ConnectionString)
    conn3 = DriverManager.getConnection(h2ConnectionString)
    conn4 = DriverManager.getConnection(h2ConnectionString)
    conn5 = DriverManager.getConnection(h2ConnectionString)

    database =
      DatabaseFactory.getInstance().findCorrectDatabaseImplementation(new JdbcConnection(conn));
    File file = new File(".")
    String baseDir = ""
    liquibase = createLiquibase( database, file, baseDir )

    boolean updateExistingNullChecksums = false
    DatabaseChangeLog databaseChangeLog = new DatabaseChangeLog("")
    liquibase.database.checkDatabaseChangeLogTable( updateExistingNullChecksums, databaseChangeLog, null )
  }

  public static Liquibase createLiquibase( Database database, File changeLogFile, String baseDir ) {
    ServiceLocator.instance.addPackageToScan( "com.iteego.db" )

    ResourceAccessor clra = new ClassLoaderResourceAccessor()
    ResourceAccessor fsra = new FileSystemResourceAccessor( baseDir )

    Liquibase result = new Liquibase(
            changeLogFile.absolutePath,
            new CompositeResourceAccessor( [clra, fsra] ),
            database)

    return result
  }


  protected boolean verifyRollbackColumn( Database database ) {
    Table changeLogTable = DatabaseSnapshotGeneratorFactory.getInstance().getGenerator(database).getDatabaseChangeLogTable(database)
    boolean hasRollbackTagColumn = changeLogTable.getColumn(ROLLBACK_COLUMN_NAME) != null;
    if (!hasRollbackTagColumn) {
      println( "Adding missing databasechangelog.${ROLLBACK_COLUMN_NAME} column" )
      Executor executor = ExecutorService.getInstance().getExecutor( database );
      executor.comment("Adding missing databasechangelog.${ROLLBACK_COLUMN_NAME} column");
      def addStatement = new AddColumnStatement(
        database.liquibaseSchemaName,
        database.databaseChangeLogTableName,
        ROLLBACK_COLUMN_NAME,
        "CLOB",
        null );
      executor.execute( addStatement )
      database.commit()
    } else {
      println( "Column databasechangelog.${ROLLBACK_COLUMN_NAME} already exists in ${changeLogTable.name}." )
    }
    return hasRollbackTagColumn
  }




  @After
  public void tearDown() {
    if( conn != null ) {
      conn.close()
    }
  }

  @Test
  public void testRanChanges() {
    def ranChanges = liquibase.database.getRanChangeSetList()
    Assert.assertTrue( "The number of Ran Changes should be zero.", ranChanges.size() == 0 )
  }

  @Test
  public void testCreateRollbackColumn() {
    def ranChanges = liquibase.database.getRanChangeSetList()
    Assert.assertTrue( "The number of Ran Changes should be zero.", ranChanges.size() == 0 )

    // Create the column.
    Assert.assertFalse( "Database should not have rollback column yet.", verifyRollbackColumn( liquibase.database ) )

    // Make sure it really got created.
    Assert.assertTrue( "Database should have rollback column by now.", verifyRollbackColumn( liquibase.database ) )
  }

  static File createTempFolder() {
    File parentFolderNameMaker = File.createTempFile( "folder-for-liquibase-test-", "")
    String parentFolderName = parentFolderNameMaker.absolutePath
    parentFolderNameMaker.delete()

    File parentFolder = new File( parentFolderName )
    parentFolder.mkdir()
    parentFolder.deleteOnExit()
    return parentFolder
  }

  /**
   * Create a liquibase xml file like users of the com.iteego.db.LiquibaseService would do.
   * ChangeSet.author is "iteego", ChangeSet.context="prod".
   * The file has deleteOnExit().
   * @param changeId Used in file name and change set id attribute.
   * @param parentFolder If null then use File.createTempFile.
   * @return Existing file.
   */
  static File createTestXmlFile( String changeId, File parentFolder, String tableName="unit_test_person" ) {
    String testXml =
"""
  <changeSet id="$changeId" author="iteego" context="prod">
      <preConditions>
        <not>
          <tableExists tableName="$tableName"/>
        </not>
      </preConditions>

      <createTable tableName="$tableName">
          <column name="id" type="int">
              <constraints primaryKey="true" nullable="false"/>
          </column>
          <column name="firstname" type="varchar(255)"/>
          <column name="lastname" type="varchar(255)"/>
          <column name="username" type="varchar(255)">
            <constraints unique="true" nullable="false"/>
          </column>
          <column name="testid" type="int" />
      </createTable>

      <rollback>
        <dropTable tableName="$tableName"/>
      </rollback>

  </changeSet>
"""

    if( parentFolder == null ) {
      // Need to create a temp sub folder.
      parentFolder = createTempFolder()
    }

    File tmpXmlFile = new File( parentFolder, "${changeId}.xml" )
    if( !tmpXmlFile.exists() ) {
      tmpXmlFile.createNewFile()
    }
    tmpXmlFile.deleteOnExit()

    // create test data
    StringBuilder sb = new StringBuilder()
    sb = XmlStreamHelper.appendChangeLogHeader( sb )
    sb.append( testXml )
    sb = XmlStreamHelper.appendChangeLogFooter( sb )

    tmpXmlFile.write( sb.toString(), "UTF-8" )
    /*System.err.println "Writing to test xml file: ${sb.toString()}"
    BufferedWriter writer = tmpXmlFile.newWriter("UTF-8")
    writer.write( sb.toString() )
    sleep( 100 )
    writer.flush()
    writer.close()  */

    return tmpXmlFile
  }


  public static testChangeLog( Connection connection, int expectedRowCount, String expectedId, String expectedAuthor, String expectedXml, String expectedFileHash = null ) {
    String s = "select id, author, filename, rollbacktag, filehash from DATABASECHANGELOG"
    Statement sst = connection.createStatement()
    ResultSet resultSet = sst.executeQuery(s)

    int rowCount = 0
    while( resultSet.next() ) {
      rowCount++
      Assert.assertTrue("ChangeSet.Id should be '$expectedId', was '${resultSet.getString("id")}'.", resultSet.getString("id").equals(expectedId) )
      Assert.assertTrue("Author should be '$expectedAuthor'.", resultSet.getString("author").equals(expectedAuthor) )
      Assert.assertEquals("Rollbacktag data should be the same as the xml in the change set we just tried to run.", expectedXml, resultSet.getString("rollbacktag") )

      if( expectedFileHash != null ) {
        Assert.assertEquals("FileHash data is not as expected.", expectedFileHash, resultSet.getString("filehash") )
      }
    }

    Assert.assertEquals( "There should be exactly $expectedRowCount row[s] in the DatabaseChangeLog table at this time.", expectedRowCount, rowCount )
  }


  public static testChangeLog( Connection connection, int expectedRowCount, List<String> expectedKeys, List<String> expectedXml, List<String> expectedFileHash = null ) {
    Assert.assertTrue( "List sizes must be equal", expectedKeys.size()==expectedRowCount && expectedXml.size()==expectedRowCount )

    String s = "select id, author, filename, rollbacktag, filehash from DATABASECHANGELOG"
    Statement sst = connection.createStatement()
    ResultSet resultSet = sst.executeQuery(s)

    int rowCount = 0
    while( resultSet.next() ) {
      String recordKey = "${resultSet.getString("id")}:${resultSet.getString("author")}:${resultSet.getString("filename")}"
      Assert.assertTrue("ChangeSet key should be '${expectedKeys[rowCount].toString()}', was '${recordKey}'.", recordKey.equals(expectedKeys[rowCount].toString()) )

      if( expectedXml && expectedXml[rowCount] ) {
        Assert.assertTrue("Rollbacktag data should be the same as the xml in the change set we just tried to run.", resultSet.getString("rollbacktag").equals(expectedXml[rowCount]) )
      }

      if( expectedFileHash && expectedFileHash[rowCount] ) {
        Assert.assertEquals("FileHash data is not as expected.", expectedFileHash[rowCount], resultSet.getString("filehash") )
      }

      rowCount++
    }

    Assert.assertEquals( "There should be exactly $expectedRowCount row[s] in the DatabaseChangeLog table at this time.", expectedRowCount, rowCount )
  }


  @Test
  public void testChangeSet() {
    // create a change set xml file and let the program run it.
    String changeId = "firstUnitTest"
    String testTableName = "unit_test_person"
    File testFile = createTestXmlFile( changeId, null, testTableName )
    List<File> files = [testFile] as List<File>
    List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( files )

    LiquibaseService service = new LiquibaseService()
    service.migrationRootDir = testFile.parentFile.parentFile
    service.doUpdate( conn, testFile.parentFile.name, changeSets )

    // Did it work?

    //--------------------------------------------------------------
    // Check the values in the change log table.
    //--------------------------------------------------------------
    testChangeLog( conn2, 1, changeId, "iteego", testFile.text )


    //--------------------------------------------------------------
    // Check whether the changes in the change set worked.
    //--------------------------------------------------------------
    String testPersonTableSql = "select * from $testTableName"
    Statement sst = conn2.createStatement()
    ResultSet resultSet2 = sst.executeQuery( testPersonTableSql )
    Assert.assertNotNull( "ResultSet should not be null after selecting from an existing table.", resultSet2 )


    //--------------------------------------------------------------
    // Try the rollback.
    //--------------------------------------------------------------
    testFile.delete()
    service.allowRollback = true
    List<XmlChange> noChangeSets = new ArrayList<XmlChange>()
    service.doUpdate( conn3, testFile.parentFile.name, noChangeSets )

    // Now we expect zero rows in the DATABASECHANGELOG table.
    testChangeLog( conn2, 0, (String)null, null, null )

    // We also expect the changes made before to be gone.
    try {
      conn2.createStatement().executeQuery( testPersonTableSql ) // This will throw an exception if the rollback worked.
      Assert.assertFalse( "The table created by the change set should be gone after the rollback.", true )
    } catch(org.h2.jdbc.JdbcSQLException exception) {
      // I expected this exception so now I am happy.
    }


    conn2.close()
  }

  @Test( expected = org.h2.jdbc.JdbcSQLException.class )
  public void testReadNonExistingTable() {
    Statement sst = conn2.createStatement()
    String testNoSuchTableTableSql = "select * from ThereIsNoTableWithThisName"
    ResultSet resultSet = sst.executeQuery( testNoSuchTableTableSql )
    Assert.assertFalse( "Just using the ResultSet, expected an Exception before this line of code was executed.", resultSet != resultSet )
  }


  @Test
  public void testRollbackLimit() {
    Connection localConn1 = DriverManager.getConnection( h2ConnectionString )
    Connection localConn2 = DriverManager.getConnection( h2ConnectionString )

    String changeId = "secondUnitTest"
    String testTableName = "unit_test_robot"
    File testFile = createTestXmlFile( changeId, null, testTableName )
    List<File> files = [testFile] as List<File>
    List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( files )

    LiquibaseService service = new LiquibaseService()
    service.migrationRootDir = testFile.parentFile.parentFile
    service.doUpdate( localConn1, testFile.parentFile.name, changeSets )

    // Did it work?

    //--------------------------------------------------------------
    // Check the values in the change log table.
    //--------------------------------------------------------------
    testChangeLog( conn2, 1, changeId, "iteego", testFile.text )


    //--------------------------------------------------------------
    // Try the rollback.
    //--------------------------------------------------------------
    String testFileText = testFile.text
    testFile.delete()
    service.allowRollback = true
    List<XmlChange> noChangeSets = new ArrayList<XmlChange>()
    Map<String,String> rblimits = new HashMap<String,String>()
    rblimits.put( testFile.parentFile.name, "$changeId:iteego:$testFile.name" )
    service.setRollbackLimits( rblimits )
    service.doUpdate( localConn2, testFile.parentFile.name, noChangeSets )

    // Now we still expect 1 row in the DATABASECHANGELOG table.
    testChangeLog( conn2, 1, changeId, "iteego", testFileText )

    // We also expect the changes made before to be still here (no exception and 0 records).
    String testTestTableSql = "select * from $testTableName"
    Statement sst = conn2.createStatement()
    ResultSet resultSet = sst.executeQuery( testTestTableSql )
    int rowCount = 0
    while( resultSet.next() ) {
      rowCount++
    }
    Assert.assertEquals("Wrong number of records in the test table.", 0, rowCount )
  }

  /**
   * According to H2 documentation on
   * http://www.h2database.com/html/advanced.html#transaction_isolation
   *
   * "The database allows multiple concurrent connections to the same database.
   * To make sure all connections only see consistent data, table level locking
   * is used by default.."
   * so this test should work on H2 but what about if we turn table level locking
   * off or some other database? Try with LOCK_MODE=0.. still works so Liquibase
   * is doing something right.
   */
  @Test
  public void testMultiThreadedAccess() {
    final int N = 2
    List<MultiTestHelper> liquibaseList = new ArrayList<MultiTestHelper>( N )
    File f = createTestXmlFile( "multi-change", new File("."), "multi_test_table" )
    List<File> files = [f] as List<File>
    List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( files )

    N.times {
      java.sql.Connection c = DriverManager.getConnection(h2ConnectionString)
      LiquibaseService service = new LiquibaseService()
      service.lockRecheckTimeMilliseconds = 10
      service.migrationRootDir = f.parentFile.parentFile
      liquibaseList.add( new MultiTestHelper(service, changeSets, f.parentFile.name, c) )
    }


    java.util.concurrent.ExecutorService pool = Executors.newFixedThreadPool( N )

    liquibaseList.each {
      pool.execute( it )
    }

    pool.shutdown()
    boolean terminationResult = pool.awaitTermination( 60, TimeUnit.SECONDS )
    Assert.assertTrue( "Executor.awaitTermination returned false, indicating timeout before all tasks completed.", terminationResult )
  }


	@Test
  public void testStrictLogic() {
    System.err.println "--- Begin testStrictLogic ---"
	  // Create locals.
    final boolean strict = true
    List<RanChangeSetAndRollbackData> ran = new ArrayList<RanChangeSetAndRollbackData>()
    List<XmlChange> xml = new ArrayList<XmlChange>()

	  // Set up. Ran ABC. Xml ADE. Expect we must roll back BC.
    //String xmlData = "select * from a;"
    def hash = "3:f727f0ce8184a7f85bc1468e398aa6c1" // <-- found by looking at logs
    //liquibase.change.CheckSum.compute( xmlData ) <-- this does not work, the xml must be parsed by Liquibase into a ChangeSet before we can get the hash value.
    CheckSum checkSum = CheckSum.parse( hash )
    //System.out.println "**** hash of '$xmlData' is: $hash"
    RanChangeSet rcs1 = new RanChangeSet( "file1.xml", "id1", "author", checkSum, new Date(), "tag", ExecType.EXECUTED )
    RanChangeSet rcs2 = new RanChangeSet( "file2.xml", "id2", "author", checkSum, new Date(), "tag", ExecType.EXECUTED )
    RanChangeSet rcs3 = new RanChangeSet( "file3.xml", "id3", "author", checkSum, new Date(), "tag", ExecType.EXECUTED )
	  ran.add( new RanChangeSetAndRollbackData( rcs1, "this value is not part of the test", null ) )
	  ran.add( new RanChangeSetAndRollbackData( rcs2, "this value is not part of the test", null ) )
	  ran.add( new RanChangeSetAndRollbackData( rcs3, "this value is not part of the test", null ) )

	  XmlChange xml1 = new FakeXmlChange( "file1.xml", "<changeSet id='id1' author='author'><sql>select * from a;</sql></changeSet>", "id1:author:file1.xml" )
    XmlChange xml2 = new FakeXmlChange( "file4.xml", "<changeSet id='id4' author='author'><sql>select * from a;</sql></changeSet>", "id4:author:file4.xml" )
    XmlChange xml3 = new FakeXmlChange( "file5.xml", "<changeSet id='id5' author='author'><sql>select * from a;</sql></changeSet>", "id5:author:file5.xml" )
	  xml.addAll( [xml1, xml2, xml3] )

	  // Get a result.
	  LiquibaseService service = new LiquibaseService()
	  List<RanChangeSetAndRollbackData> test = service.getChangesThatMustBeRolledBack( liquibase, strict, ran, xml )

	  // Verify correctness.
	  Assert.assertEquals( "Wrong number of changes that must be rolled back.", 2, test?.size() )
		Assert.assertEquals( "Ran change id2 should be first in the list of changes to be rolled back, test 1.", "id2:author:file2.xml", test[0]?.key )
		Assert.assertEquals( "Ran change id3 should be second in the list of changes to be rolled back, test 1.", "id3:author:file3.xml", test[1]?.key )


		// Add more data and test again. Ran ABCF. Xml ADEF. Expect we must roll back BCF.
		RanChangeSet rcs6 = new RanChangeSet( "file6.xml", "id6", "author", null, new Date(), "tag", ExecType.EXECUTED )
		ran.add( new RanChangeSetAndRollbackData( rcs6, "this value is not part of the test", null ) )
		XmlChange xml6 = new FakeXmlChange( "file6.xml", "ignored", "id6:author:file6.xml" )
		xml.add( xml6 )
		List<RanChangeSetAndRollbackData> test2 = service.getChangesThatMustBeRolledBack( liquibase, strict, ran, xml )
		Assert.assertEquals( "Wrong number of changes that must be rolled back.", 3, test2?.size() )
		Assert.assertEquals( "Ran change id2 should be first in the list of changes to be rolled back, test 2.", "id2:author:file2.xml", test2[0]?.key )
		Assert.assertEquals( "Ran change id3 should be second in the list of changes to be rolled back, test 2.", "id3:author:file3.xml", test2[1]?.key )
		Assert.assertEquals( "Ran change id6 should be third in the list of changes to be rolled back, test 2.", "id6:author:file6.xml", test2[2]?.key )
    System.err.println "--- End testStrictLogic ---"
  }

  //@Test
  public void testNonStrictLogic() {
    // Create locals.
    final boolean strict = false
    List<RanChangeSetAndRollbackData> ran = new ArrayList<RanChangeSetAndRollbackData>()
    List<XmlChange> xml = new ArrayList<XmlChange>()

    // Set up. Ran ABC. Xml ADE. Expect we must roll back BC.
    String xmlData = "ignored"
    def hash = liquibase.change.CheckSum.compute( xmlData )
    RanChangeSet rcs1 = new RanChangeSet( "file1.xml", "id1", "author", hash, new Date(), "tag", ExecType.EXECUTED )
    RanChangeSet rcs2 = new RanChangeSet( "file2.xml", "id2", "author", hash, new Date(), "tag", ExecType.EXECUTED )
    RanChangeSet rcs3 = new RanChangeSet( "file3.xml", "id3", "author", hash, new Date(), "tag", ExecType.EXECUTED )
    ran.add( new RanChangeSetAndRollbackData( rcs1, "this value is not part of the test" ) )
    ran.add( new RanChangeSetAndRollbackData( rcs2, "this value is not part of the test" ) )
    ran.add( new RanChangeSetAndRollbackData( rcs3, "this value is not part of the test" ) )

    XmlChange xml1 = new FakeXmlChange( "file1.xml", "ignored", "id1:author:file1.xml" )
    XmlChange xml2 = new FakeXmlChange( "file4.xml", "ignored", "id4:author:file4.xml" )
    XmlChange xml3 = new FakeXmlChange( "file5.xml", "ignored", "id5:author:file5.xml" )
    xml.addAll( [xml1, xml2, xml3] )

    // Get a result.
    LiquibaseService service = new LiquibaseService()
    List<RanChangeSetAndRollbackData> test = service.getChangesThatMustBeRolledBack( strict, ran, xml )

    // Verify correctness.
    Assert.assertEquals( "Wrong number of changes that must be rolled back.", 2, test?.size() )
    Assert.assertEquals( "Ran change id2 should be first in the list of changes to be rolled back, test 1.", "id2:author:file2.xml", test[0]?.key )
    Assert.assertEquals( "Ran change id3 should be second in the list of changes to be rolled back, test 1.", "id3:author:file3.xml", test[1]?.key )


    // Add more data and test again. Ran ABCF. Xml ADEF. Expect we must roll back BCF.
    RanChangeSet rcs6 = new RanChangeSet( "file6.xml", "id6", "author", null, new Date(), "tag", ExecType.EXECUTED )
    ran.add( new RanChangeSetAndRollbackData( rcs6, "this value is not part of the test" ) )
    XmlChange xml6 = new FakeXmlChange( "file6.xml", "ignored", "id6:author:file6.xml" )
    xml.add( xml6 )
    List<RanChangeSetAndRollbackData> test2 = service.getChangesThatMustBeRolledBack( strict, ran, xml )
    Assert.assertEquals( "Wrong number of changes that must be rolled back.", 3, test2?.size() )
    Assert.assertEquals( "Ran change id2 should be first in the list of changes to be rolled back, test 2.", "id2:author:file2.xml", test2[0]?.key )
    Assert.assertEquals( "Ran change id3 should be second in the list of changes to be rolled back, test 2.", "id3:author:file3.xml", test2[1]?.key )
    Assert.assertEquals( "Ran change id6 should be third in the list of changes to be rolled back, test 2.", "id6:author:file6.xml", test2[2]?.key )
  }

	@Test
	public void testMakeRanChangeKey() {
		RanChangeSet rcs1 = new RanChangeSet( "file1.xml", "id1", "author", null, new Date(), "tag", ExecType.EXECUTED )
		RanChangeSet rcs2 = new RanChangeSet( "file2.xml", "id2", "author", null, new Date(), "tag", ExecType.EXECUTED )
		LiquibaseService service = new LiquibaseService()

		String key1 = service.makeKey( rcs1 )
		String key2 = service.makeKey( rcs2 )

		Assert.assertEquals( "LiquibaseService.makeKey(RanChangeSet) failed.", "id1:author:file1.xml", key1 )
		Assert.assertEquals( "LiquibaseService.makeKey(RanChangeSet) failed.", "id2:author:file2.xml", key2 )
	}

	@Test( expected=NullPointerException.class )
	public void testNullConnection() {
		LiquibaseService service = new LiquibaseService()
		service.migrationRootDir = null
		Connection connection = null
		String fileName = "something"
		List changeSets = null

		// Should throw an NPE from inside Liquibase.
		service.doUpdate( connection, fileName, changeSets )
	}

	@Test( expected=Exception.class )
	public void testNullFileName() {
		LiquibaseService service = new LiquibaseService()
		service.migrationRootDir = null
		Connection connection = DriverManager.getConnection(h2ConnectionString)
		String fileName = null
		List changeSets = null

		// Should throw an Exception from inside LiquibaseService.
		service.doUpdate( connection, fileName, changeSets )
	}

	@Test
	public void testNullChangeSets() {
		LiquibaseService service = new LiquibaseService()
		service.migrationRootDir = null
		Connection connection = DriverManager.getConnection(h2ConnectionString)
		String fileName = "something"
		List changeSets = null

		// Should not throw an exception.
		service.doUpdate( connection, fileName, changeSets )
	}

  @Test
  public void testValidator() {
    List<RanChangeSet> ranChangeSets = new ArrayList<RanChangeSet>()

    liquibase.change.AbstractChange change = new RawSQLChange( "update users set password='reset';" )

    boolean alwaysRun = false
    boolean runOnChange = true
    ChangeSet changeSet = new ChangeSet( "id", "author", alwaysRun, runOnChange, "filePath", "", "" )
    changeSet.addChange( change )

    liquibase.database.AbstractDatabase db = new H2Database()

    FasterValidatingVisitor visitor = new FasterValidatingVisitor( ranChangeSets )

    // Should not throw.
    visitor.visit( changeSet, null, db )

    liquibase.change.AbstractChange change2 = new RawSQLChange( "this is not SQL" )
    changeSet.addChange( change2 )
    visitor.visit( changeSet, null, db )

    visitor.visit( changeSet, null, db )

  }




  @Test
  public void testAlteredXmlFileCausesRollback() {
    println "--- Begin testAlteredXmlFileCausesRollback ---"
    // 1. Create a change set xml file and let the program run it.
    // 2. Alter the file (changing its md5 hash but not its author,filename or id).
    // 3. Run update again - expect rollback.

    String changeId = "xUnitTest"
    String testTableName = "unit_test_clown"
    File testFile = createTestXmlFile( changeId, null, testTableName )
    List<File> files = [testFile] as List<File>
    List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( files )
    //System.err.println "* change set count: " + changeSets.size()
    //System.err.println "* change sets: " + changeSets.collect( {it.changeSet} ).join( ", " )

    //--------------------------------------------------------------
    // Run the file, expect rollbacks of change sets from earlier tests, and then an update.
    //--------------------------------------------------------------
    LiquibaseService service = new LiquibaseService()
    service.allowRollback = true
    service.migrationRootDir = testFile.parentFile.parentFile
    println "DO FIRST UPDATE"
    service.doUpdate( conn, testFile.parentFile.name, changeSets )


    //--------------------------------------------------------------
    // Check whether the changes in the change set worked.
    //--------------------------------------------------------------
    String testPersonTableSql = "select * from $testTableName"
    Statement sst = conn2.createStatement()
    ResultSet resultSet2 = sst.executeQuery( testPersonTableSql )
    Assert.assertNotNull( "ResultSet should not be null after selecting from an existing table.", resultSet2 )


    //--------------------------------------------------------------
    // Try the file again, expect no rollback and no update.
    //--------------------------------------------------------------
    println "DO SECOND UPDATE"
    service.doUpdate( conn3, testFile.parentFile.name, changeSets )



    //--------------------------------------------------------------
    // Try the altered xml file, expect a rollback.
    //--------------------------------------------------------------
    println "DO THIRD UPDATE"
    String fileContent = testFile.text
    fileContent = fileContent.replace( testTableName, "changed_" + testTableName )
    testFile.write( fileContent )
    //System.err.println "new file contents: " + testFile.text

    service.allowRollback = true
    List<XmlChange> noChangeSets = new ArrayList<XmlChange>()
    List<XmlChange> newChangeSets = XmlChangeSetTester.getChangeSets( files )
    service.doUpdate( conn4, testFile.parentFile.name, newChangeSets )

    //--------------------------------------------------------------
    // Check whether the changes in the altered change set worked.
    //--------------------------------------------------------------
    String testAlteredPersonTableSql = "select * from changed_$testTableName"
    Statement sst2 = conn2.createStatement()
    ResultSet resultSet3 = sst2.executeQuery( testAlteredPersonTableSql )
    Assert.assertNotNull( "ResultSet should not be null after selecting from an existing table.", resultSet3 )



    println "DO FOURTH UPDATE - with errors"
    fileContent = testFile.text
    fileContent = fileContent.replace( "changeSet", "not-a-tag" )
    testFile.write( fileContent )

    service.allowRollback = true
    List<XmlChange> newerChangeSets = XmlChangeSetTester.getChangeSets( files )
    service.log.setLevel( java.util.logging.Level.OFF )
    try {
      service.doUpdate( conn5, testFile.parentFile.name, newerChangeSets )
      Assert.fail( "This update should not have passed the parser. Expected ChangeLogParseException." )
    } catch( ChangeLogParseException ignored ) {
      // This was supposed to happen.
    }



    // Now we expect zero rows in the DATABASECHANGELOG table.
    //testChangeLog( conn2, 1, null, null, null )

    // We also expect the changes made before to be gone.
    try {
      System.err.println "TEST THE TABLE THAT WAS CREATED BY THE XML"
      conn2.createStatement().executeQuery( testPersonTableSql ) // This will throw an exception if the rollback worked.
      Assert.assertFalse( "The table created by the change set should be gone after the rollback.", true )
    } catch(org.h2.jdbc.JdbcSQLException exception) {
      // I expected this exception so now I am happy.
    }

    testFile.delete()

    conn2.close()
    System.err.println "--- End testAlteredXmlFileCausesRollback ---"
  }

}


class MultiTestHelper implements Runnable {
  public LiquibaseService service
  public List<XmlChange> changeSets
  public String rootDir
  Connection connection

  public MultiTestHelper(LiquibaseService service, List<XmlChange> changeSets, String rootDir, Connection c ) {
    this.service = service
    this.changeSets = new ArrayList<XmlChange>( changeSets )
    this.rootDir = rootDir
    this.connection = c
  }

  void run() {
    println "Thread ${Thread.currentThread().name} starts to run"
    service.doUpdate( connection, rootDir, changeSets )
    println "Thread ${Thread.currentThread().name} stops running"
  }
}


class FakeXmlChange extends XmlChange {
	// The purpose of this class is to help us test the logic
	// of rollbacks without having to create a lot of files on disk.
	String fakeFileName, xmlContents, key

	public FakeXmlChange( String fakeFileName, String xmlContents, String key ) {
		super( null, null, null )
		this.fakeFileName = fakeFileName
		this.xmlContents = xmlContents
		this.key = key

    String xml = com.iteego.db.XmlStreamHelper.createFakeChangeLogXml(xmlContents)
    //System.err.println "create fake xml change with xml " + xml
    this.xmlContents = xml
    groovy.util.XmlSlurper xmlSlurper = new groovy.util.XmlSlurper()
    try {
      InputStream fakeFileStream = new ByteArrayInputStream( xml.getBytes("utf-8") )
      this.xmlData = xmlSlurper.parse( fakeFileStream )
    } catch( Throwable throwable ) {
      Assert.fail "ERROR: $throwable, ${throwable.message}, ${throwable.toString()}"
      //throw throwable
    }
    //System.err.println "create fake xml change with data " + this.@xmlData.toString()
    //System.err.println "create fake xml change with text " + this.@xmlData.text()
	}

	@Override
	public String getKey() {
		return key
	}

	@Override
	public String getFileName() {
		return fakeFileName
	}

	@Override
	String getXmlData() {
    //String x = this.@xmlData.toString()
    //System.err.println "* Returning xmlData: " + x
    //System.err.println "* Returning xmlData: " + xmlContents
	  return xmlContents
	}


}


