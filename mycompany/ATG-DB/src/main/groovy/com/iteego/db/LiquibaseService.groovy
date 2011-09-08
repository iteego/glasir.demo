/*
 * Copyright (c) 2011. Iteego.
 */


/*
 * -----------------------------------
 * What this service does.
 * -----------------------------------
 * This service for the ATG platform exists to update database
 * structure and data automatically as ATG starts before ATG
 * starts using any repositories.
 * This class performs the database updates by using Liquibase.
 *
 * -----------------------------------
 * Why we created this service.
 * -----------------------------------
 * Iteego works on several large ATG installations and we found that
 * keeping the database up-to date and in sync with your current code
 * branch could take a lot of valuable development time.
 *
 * -----------------------------------
 * How to use this service.
 * -----------------------------------
 * 1. Add the module to your code.
 * 2. Edit the properties file to point to the root folder for your Liquibase change set files.
 * 3. Look up the mapping between ATG databases and jndi names in, for example, jboss/server/atg/deploy/atg-ds.xml.
 * 4. Edit the properties file to map the root folder's subfolders to jndi names.
 * 5. Create some change set files in the subfolders. All change sets in a subfolder must use the same database.
 * 6. Start ATG. Right after the ENVIRONMENT has been logged you should see INFO level logging from the LiquibaseService, e.g. "[LiquibaseService] Begin Liquibase Patching Serv
 *
 * -----------------------------------
 * Guarantees.
 * -----------------------------------
 * Iteego will not accept responsibility for anything that goes wrong when you use this code.
 *
 */


package com.iteego.db

import atg.nucleus.GenericService
import atg.nucleus.Nucleus
import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.SQLException
import javax.naming.InitialContext
import javax.sql.DataSource
import liquibase.Liquibase
import liquibase.changelog.DatabaseChangeLog
import liquibase.changelog.RanChangeSet
import liquibase.database.Database
import liquibase.database.DatabaseFactory
import liquibase.database.jvm.JdbcConnection
import liquibase.database.structure.Table
import liquibase.executor.Executor
import liquibase.executor.ExecutorService
import liquibase.lockservice.LockService
import liquibase.resource.ClassLoaderResourceAccessor

import liquibase.resource.ResourceAccessor
import liquibase.snapshot.DatabaseSnapshotGeneratorFactory
import liquibase.statement.SqlStatement
import liquibase.statement.core.AddColumnStatement
import liquibase.statement.core.SelectFromDatabaseChangeLogStatement
import liquibase.servicelocator.ServiceLocator
import liquibase.changelog.visitor.UpdateVisitor
import liquibase.parser.ChangeLogParserFactory
import liquibase.change.CheckSum
import liquibase.exception.ChangeLogParseException

import atg.adapter.gsa.*
import atg.nucleus.ServiceMap


public class LiquibaseService extends GenericService {
  static public final String ROLLBACK_COLUMN_NAME = "ROLLBACKTAG"
  static public final String FILEHASH_COLUMN_NAME = "FILEHASH"
  private static AtgLogHelper log

  private final String ES_EXIT = "exit"
  private final String ES_CONTINUE = "continue"
  private final String ES_ROLLBACK = "rollbackAndExit"
  private final String[] ALLOWED_ROLLBACK_STRATEGIES = ["strict","cherry-pick"]
  private final String[] ALLOWED_ERROR_STRATEGIES = [ES_EXIT,ES_CONTINUE,ES_ROLLBACK]
  private Map<String, String> directoryToJndiMap = new TreeMap()

  // Comma-separated, corresponding to the "context" attribute in the "ChangeSet" tag in Liquibase xml files.
  String liquibaseContexts
  // Sub-folders (mapped to databases with directoryToJndiMap) will be scanned for xml change set files.
  File migrationRootDir
  File libDir
  File liquibaseJarFile

  protected boolean enabled = false
  public boolean allowRollback = false
  protected String rollbackStrategy = "strict" // "cherry-pick"
  protected String errorStrategy = ES_EXIT

  long lockRecheckTimeMilliseconds = 5000
  String replacementXmlHeaderFileName = null

  ProgressListener progressListener = null

  @Delegate
  LicenseHandler licenseHandler = new LicenseHandler( log )


  /**
   * Database id that we are not allowed to roll back past (including this id).
   * Rollbacks are made from the end of the table.
   * Per database.
   * This applies for rollback strategies "strict" and "cherry-pick" both.
   */
  public Map<String,String> rollbackLimits = new HashMap<String,String>()


  // Explicitly public
  public LiquibaseService() {
    LiquibaseService.getAtgLogHelper( this )
  }

  public synchronized static AtgLogHelper getAtgLogHelper( LiquibaseService service ) {
    // The reason for this static method is that even though we (this class)
    // creates Liquibase objects, the part of Liquibase that creates the logger
    // can not see the instance of this class that created it and will not use
    // it in the call to the logger constructor anyway. So our logger (instantiated
    // with a parameter-less constructor by Liquibase) must be given some way of
    // accessing the DefaultAtgLogHelper which is the bridge to the ATG log which we
    // would obviously like to use.
    if( !log && service ) {
      setAtgLogHelper( new DefaultAtgLogHelper( service ) )
    }
    return log
  }

  public synchronized static void setAtgLogHelper( AtgLogHelper atgLogHelper ) {
    // Needed this for testing (injecting test log class).
    log = atgLogHelper
  }

  void addH2DatabaseTableInfos() {
	DatabaseTableInfo dti = new DatabaseTableInfo()
/*varcharType=VARCHAR2
longVarcharType=CLOB
decimalType=DECIMAL
dateType=DATE
timestampType=TIMESTAMP
binaryType=BLOB
intType=INT
*/


dti.setVarcharType("VARCHAR2");
dti.setLongVarcharType("CLOB");
dti.setDecimalType("DECIMAL");
dti.setDateType("DATE");
dti.setTimestampType("TIMESTAMP");
dti.setBinaryType("BLOB");
dti.setIntType("INT");

ServiceMap serviceMap = new ServiceMap()
serviceMap.put( "H2", dti )
	
	GSARepository rep = new GSARepository()
	rep.setDatabaseTableInfos( serviceMap )

	rep.databaseTableInfos.each { k, v -> println "databasetableinfo: $k  ->   $v" }
  }


  @Override
  public void doStartService() {
    log?.info("Starting Iteego ATG_DB Database Migrations")
    if( !enabled ) {
      log?.info(" Property \"enabled\" is false, this service will do nothing." )
      return
    }

    addH2DatabaseTableInfos()

    log?.debug(" Property \"atg.dynamo.root\" has value: " + atg.nucleus.DynamoEnv.getProperty("atg.dynamo.root") )
    log?.debug( " Property \"migrationRootDir\" has value: $migrationRootDir" )
    log?.debug( " Property \"directoryToJndiMap\" has value: $directoryToJndiMap" )
    log?.debug( " Property \"directoryToJndiMap\" has keys: ${directoryToJndiMap.keySet()}" )

    if (!migrationRootDir?.canRead() || !migrationRootDir?.isDirectory()) {
      log.error(" Liquibase patch root \"${migrationRootDir}\" is invalid. CanRead=${migrationRootDir?.canRead()}, isDirectory=${migrationRootDir?.isDirectory()}")
      log.error(" Canonical path: ${migrationRootDir?.canonicalPath}")
      log.error(" Skipping liquibase migrations as migrations root dir is unreadable!")
      if( errorStrategy == ES_EXIT || errorStrategy == ES_ROLLBACK ) {
        stopMe()
      }
      return
    }

    if( rollbackLimits.keySet().any { !directoryToJndiMap.keySet().contains( it ) } ) {
      log?.error( " There is a folder name used as key in the rollbackLimits property (map) that is not also a key in the directoryToJndiMap." )
      log?.error( " This must be a mistake and it may cause a lot of problems. This service will not continue beyond this point." )
      log?.error( " directoryToJndiMap: $directoryToJndiMap" )
      log?.error( " rollbackLimits: $rollbackLimits" )
      stopMe()
      return
    }

    try {
      licenseHandler.log = LiquibaseService.getAtgLogHelper( this )
      validateLicense( "ATG_DB" )
    }
    catch( Throwable throwable ) {
      log.error( "License validation failed. LiquibaseService will not run. Error message: \"${throwable.message}\"." )
      return
    }


    log?.info("Migration Directory Summary:")
    directoryToJndiMap.each { k, v ->
      String l = rollbackLimits[k]
      log?.info("  directory $k - data source $v - rollback limit $l")
    }


    // For each directory, in alphabetical order
    directoryToJndiMap.each { String dir, String jndiName ->
      boolean thisUpdateOk = true
      try {
				//..get change sets.. (Map<File,(gpath)Object>)
				List<File> changeSetFiles = XmlChangeSetTester.getChangeSetFiles( new File( migrationRootDir, dir ), log )

				//..get the <changeSet> tags..
        List<XmlChange> changeSets = XmlChangeSetTester.getChangeSets( changeSetFiles )

				//..do the update.
        doUpdate(
          jndiName,
          dir,
          changeSets )
      } catch (Throwable error) {
        thisUpdateOk = false
        log.error("Failed to update database '$jndiName' with files in folder '$dir'. Message: '${error.message}'.", error)
        println "Error: " + error.message
      }

      if( !thisUpdateOk ) {
        if( errorStrategy == ES_EXIT ) {
          log.info( "Exiting due to update error and errorStrategy '$errorStrategy'." )
          stopMe()
        }
        else if( errorStrategy == ES_CONTINUE ) {
          log.info( "Ignore update error. ErrorStrategy is '$errorStrategy'." )
        }
        else {
          // ToDo: implement rollbackAndExit strategy
          log.warning( "ErrorStrategy '$errorStrategy' not implemented." )
          stopMe()
        }
      }
    }

    log?.info("Iteego ATG_DB Database Migrations Completed")
  }

  /**
   * Internal landing.
   * @param jndiName JNDI name as mapped in the directoryToJndiMap property.
   * @param xmlFileDir Name of the sub-directory where the xml change set files for the database are located.
   * @param changeSets Changes to run.
   */
  protected void doUpdate( String jndiName, String xmlFileDir, List<XmlChange> changeSets ) {
    log?.info("Updating database with JNDI name '$jndiName' with ${changeSets ? changeSets.size() : 0} change sets from directory $xmlFileDir.")

    // We must not return from this method at this point even if there are no changes because we may have to run rollbacks.

    Object dataSourceObject
    try {
      dataSourceObject = new InitialContext().lookup( jndiName )
    } catch( javax.naming.NameNotFoundException ex ) {
      log?.warning( "JNDI name \"$jndiName\" not found. The error is either in the JNDI configuration (add a binding), or in the \"directoryToJndiMap\" property (change or remove a mapping) for this service." )
      throw ex
    }


    if (dataSourceObject == null) {
      println "lookup"
      throw new LiquibaseServiceDatasourceNotFoundException("InitialContext().lookup( '$jndiName' ) returned null.", jndiName)
    }

    if (!(dataSourceObject instanceof DataSource)) {
      throw new LiquibaseServiceException("Data Source returned by looking up $jndiName is not instance of javax.sql.DataSource: $dataSourceObject")
    }

    DataSource dataSource = dataSourceObject as DataSource
    Connection connection = dataSource.connection
    doUpdate( connection, xmlFileDir, changeSets )
  }


  public void setLogger( AtgLogHelper logger ) {
    this.log = logger
  }


  /**
   * An entry point. If you enter here (i.e. you do not use ATG to create and initialize
   * this object) then you must still set the "migrationRootDir" or else recording changes
   * will not work.
   * @param connection A java.sql.Connection. Will be closed when this method exits.
   * @param dir Name of directory (below the migrationRootDir) where xml change set files are for this db.
   * @param changeSets XML change sets to run (taken from the dir).
   */
  @SuppressWarnings("GroovyUnusedAssignment")
  synchronized void doUpdate( Connection connection, String dir, List<XmlChange> changeSets ) {
    String l = rollbackLimits[dir]
    log?.debug("doUpdate: Directory \"$dir\", rollback limit \"$l\"")

    String action = ""
    StringBuilder generatedChangeLogFileName = new StringBuilder()
    try {
      if( !dir ) {
        throw new Exception( "The directory for xml files can not be empty." )
      }

      if( replacementXmlHeaderFileName ) {
        XmlStreamHelper.setChangeLogHeaderOverride( new File(migrationRootDir, replacementXmlHeaderFileName) )
      } else {
        XmlStreamHelper.setChangeLogHeaderOverride( null )
      }

      action = "inserting Iteego Liquibase-to-ATG log bridge"
      ServiceLocator.instance.addPackageToScan( "com.iteego.db" )

      action = "looking up database liquibase implementation"
      Database database =
      	DatabaseFactory.getInstance().findCorrectDatabaseImplementation( new JdbcConnection( connection ) )

      action = "creating liquibase manager object"
      Liquibase liquibase = createLiquibase( changeSets as List<FileNameAndXml>, database, true, generatedChangeLogFileName )

      action = "Verifying the DATABASECHANGELOG table so that we can insert our own field there"
      verifyLiquibaseTable( liquibase )

			action = "verifying the rollbacktag column in the liquibase table"
			verifyCustomColumns( database )

      log?.info("start getRanChangeSetList")
			action = "loading (before update) the ChangeSets that have been run against the current database."
      List<RanChangeSet> ranChangesBefore = new ArrayList<RanChangeSet>()
      List<RanChangeSetAndRollbackData> extendedRanChangeSetListBefore = new ArrayList<RanChangeSetAndRollbackData>()
      FasterChangeLog.getRanChangesAndExtensions( database, ranChangesBefore, extendedRanChangeSetListBefore )
			//List<liquibase.changelog.RanChangeSet> ranChangesBefore = database.getRanChangeSetList()

      log?.info("start doAutomaticRollbacks")
			action = "Comparing changes in database to changes in files."
			doAutomaticRollbacks( liquibase, ranChangesBefore, changeSets, dir )

      log?.info("start update")
      action = "executing liquibase migrations"
      doLiquibaseUpdate( liquibaseContexts, liquibase, generatedChangeLogFileName.toString() )

      log?.info("start getRanChangeSetList")
			action = "loading (after update) the ChangeSets that have been run against the current database."
      List<RanChangeSet> ranChangesAfter = new ArrayList<RanChangeSet>()
      List<RanChangeSetAndRollbackData> extendedRanChangeSetListAfter = new ArrayList<RanChangeSetAndRollbackData>()
      FasterChangeLog.getRanChangesAndExtensions( database, ranChangesAfter, extendedRanChangeSetListAfter )
			//List<RanChangeSet> ranChangesAfter = database.getRanChangeSetList()

      log?.info("start recordChanges at " + new Date().toString())
			action = "writing ChangeSets to the databasechangelog."
      String baseDir = new File( (File)migrationRootDir, dir.toString() ).absolutePath

			//recordChanges( changeSets, liquibase, ranChangesAfter - ranChangesBefore, baseDir, connection  )
      log?.debug( "Changes before:${extendedRanChangeSetListBefore.collect {it.key}} , after:${extendedRanChangeSetListAfter.collect {it.key}} " )
      recordChanges2( changeSets, liquibase, extendedRanChangeSetListBefore, extendedRanChangeSetListAfter, baseDir, connection  )
    }
    catch( liquibase.exception.ValidationFailedException vfe ) {
      log.error( "ValidationFailedException in doUpdate while $action, message: ${vfe.message}" )
      log.error( "This could mean that a change set file has incorrect syntax for this database." )
      throw vfe
    }
    catch (Throwable e) {
      log.error("Error in doUpdate while $action, message: ${e.message}")
      throw e
    } finally {
      XmlStreamHelper.setChangeLogHeaderOverride( null )
      try {
        connection?.close()
      } catch (SQLException e) {
        log.error( "SQLException when closing database connection after liquibase.", e)
        throw e
      }
    }
  }

  /**
   * Calculate and perform rollbacks as needed.
   * @param liquibase A Liquibase object for some database.
   * @param ranChanges Changes logged in database.
   * @param xmlChanges Changes on disk.
   * @param dir Name of the directory where the xml change set files for the database are located,
   *            as mapped in the directoryToJndiMap and rollbackLimits properties.
   */
	protected void doAutomaticRollbacks( Liquibase liquibase, List<RanChangeSet> ranChanges, List<XmlChange> xmlChanges, String dir) {
		// Make Liquibase roll back changes that are in the database (ranChanges) but not in the files (xmlChanges).
		//----------------------------------------------------------
		// For automatic rollbacks, this is where we must look for changeSets in
		// the changeLogFile and compare them to the values in the DATABASECHANGELOG
		// table. If there are unaccounted-for changeSets in the database then roll them back.
		// The only way to be able to do that is to save the rollback code in the database
		// because the changeSet is no longer available (due to source code rollback probably).
		//----------------------------------------------------------
		// Suppose it looks like this:
		//	x,y are list indexes,
		//	ran is the list of already executed changes,
		//	xml is the list of the changes as we parsed them from the xml files just now
		//
		// x | ran | xml | y
		// --+-----+-----+---
		// 1 |  A  |  B  | 1
		// 2 |  B  |  D  | 2
		// 3 |  C  |     |
		//
		// For strict mode we need to roll back changes A,B,C (in reverse) and then apply changes B,D.
		// For cherry-pick mode we need to roll back changes A,C (in reverse) and then apply change D.

		if( !allowRollback ) {
			log.warning( "Property \"allowRollback\" for this service has value \"false\". All rollback functionality is turned off." )
			return
		}

		//----------------------------------------------------------
		// Lose RanChangeSets that we have no way of rolling back.
		//----------------------------------------------------------
		List<RanChangeSetAndRollbackData> rollbackables = getRollbackableChanges( liquibase, ranChanges, dir )
		int numRollback = 0
		def toRollBack = null

		if( xmlChanges==null || xmlChanges.size()==0 ) {
			// No change set files. Rollback everything in ranChanges, that means to roll back x steps (everything!).
			if( ranChanges != null ) {
				numRollback = ranChanges.size()
				toRollBack = rollbackables
        if( progressListener ) {
          toRollBack.each { RanChangeSetAndRollbackData trb ->
            progressListener.addToRollbackQueue( trb.getKey(), trb.ranChangeSet.lastCheckSum.toString(), trb.fileHash )
          }
        }
				log.info( "No XML files found, Change log is not empty. Rolling back everything (${numRollback} changes)." )
			} else {
				log.info( "No XML files found. Change log is empty. Nothing will be rolled back." )
			}
		} else {
			final boolean strict = true //ToDo: Allow non-strict rollbacks?
			toRollBack = getChangesThatMustBeRolledBack( liquibase, strict, rollbackables, xmlChanges )

			if( toRollBack?.size() ) {
				log.info( "Rolling back these changes: ${toRollBack.collect{it.getKey()}.join(", ")}" )
        if( progressListener ) {
          toRollBack.each { RanChangeSetAndRollbackData trb ->
            progressListener.addToRollbackQueue( trb.getKey(), trb.ranChangeSet.lastCheckSum.toString(), trb.fileHash )
          }
        }
				// Since the only option is the STRICT strategy (at this time) we will not skip any changes that can
				// be rolled back. This means that we will roll back everything until the first item in the list.
				def firstRollbackKey = toRollBack[0].getKey()
				int index = 0
				while( !makeKey(ranChanges[index]).equals( firstRollbackKey ) ) index++;
				numRollback = ranChanges.size() - index
				log.info( "Number of changes to roll back: ${numRollback} changes." )
			} else {
				log.info( "Change log and XML files are already in sync. Nothing will be rolled back." )
			}
		}

		if( numRollback > 0 ) {
      log.info( "$numRollback changes to roll back." )
      Liquibase liquibaseRollback = createLiquibase( toRollBack, liquibase.database )

			// At long last, roll back!
			liquibaseRollback.rollback( numRollback, liquibaseContexts )
		}
	}

  /**
   * Collect the RanChangeSets that can be rolled back. Also return the actual rollback data.
   *
   * Note that there is no test as to whether the rollback actually does anything, so a no-op
   * rollback is accepted. What we are testing for is data in the ROLLBACK_COLUMN_NAME field.
   *
   * @param liquibase A Liquibase object for some database.
   * @param ranChanges Changes that have been ran against the database.
   * @param dir Name of the directory where the xml change set files for the database are located,
   *            as mapped in the directoryToJndiMap and rollbackLimits properties.
   * @return List of changes that can be rolled back (they have data in the ROLLBACK_COLUMN_NAME column).
   */
	protected List<RanChangeSetAndRollbackData> getRollbackableChanges( Liquibase liquibase, List<RanChangeSet> ranChanges, String dir ) {
    //--------------------------------------------------------------
    // First take out anything that is earlier than the rollback limit.
    //--------------------------------------------------------------
    if( rollbackLimits.containsKey( dir ) ) {
      String rollbackLimit = rollbackLimits[dir]
      for( int changeIndex=0; changeIndex < ranChanges.size(); changeIndex++ ) {
        String rcKey = makeKey( ranChanges[ changeIndex ] )
        if( rcKey.equalsIgnoreCase( rollbackLimit ) ) {
          // There is a limit, and we found it in the database.
          log.info( "Rollback limit '$rollbackLimit' for directory '$dir' was found at zero-based index $changeIndex in the change set log table." )
          (changeIndex + 1).times {
            ranChanges.remove( 0 )
          }
          break
        }
      }
    }


    // Then collect the RanChangeSets.
		List<RanChangeSetAndRollbackData> rollbackables = new ArrayList<RanChangeSetAndRollbackData>()
		List<RanChangeSet> nonRollbackables = new ArrayList<RanChangeSet>()
		ranChanges.each {
			RanChangeSetAndRollbackData rollbackData = getRollbackDataForRanChangeSet( liquibase, it )
			if( rollbackData!=null ) {
				rollbackables.add( rollbackData )
			} else {
				nonRollbackables.add( it )
			}
		}

		if( nonRollbackables.size() > 0 ) {
			println( "---------------------------------------------------------------------" )
			println( "Iteego ATG Liquibase: Warning" )
			println( "---------------------------------------------------------------------" )
			println( "Some changes previously made to the database by liquibase " )
			println( " have no rollback data attached to them. That is not how" )
			println( " this is supposed to work. They will be left alone but know" )
			println( " that this state could mean there are errors in the database." )
			nonRollbackables.each {
				println( "  No rollback data for RanChangeSet: \"${makeKey(it)}\"." )
			}
			println( "---------------------------------------------------------------------" )
		}

		return rollbackables
	}

  /**
   * Compare ran changes to changes defined in xml files currently on disk.
   * If some ran changes no longer has matching xml files then maybe they should be rolled back.
   * This could happen if you switch between source control branches
   * or if you just removed some unnecessary change set xml file.
   * @param strict True or False, only True is implemented.
   * @param ranChanges Actually ran changes as logged in the DATABASECHANGELOG.
   * @param xmlChanges Changes that you would like to run.
   * @return A list of changes that should be rolled back.
   */
	List<RanChangeSetAndRollbackData> getChangesThatMustBeRolledBack( Liquibase liquibase, boolean strict, List<RanChangeSetAndRollbackData> ranChanges, List<XmlChange> xmlChanges ) {
		// strict: find the first diff between the lists and roll back to that position.
		//         With ran:[a,b,c,d,e] and xml:[a,b,d,e] roll back to c.
		//
		// non-strict: return all ranChanges that are not in the xml list even if they are in non-seqential positions.
		//         With ran:[a,b,c,d,e] and xml:[a,b,d,e] roll back ONLY c.
		//
		//todo: consider  ran:[a,b,c] and xml:[b,a,c] THIS CAN HAPPEN BECAUSE WE SORT BY FILE.NAME AND NOT CHANGESET.NAME.

		if( !strict ) {
      throw new Exception( "Non-strict rollback strategy is not implemented yet." )
/*      List<RanChangeSetAndRollbackData> result = new ArrayList<RanChangeSetAndRollbackData>()
      ranChanges.each { RanChangeSetAndRollbackData ran ->
        XmlChange xmlChange = xmlChanges.find { XmlChange xc -> xc.key.equals( ran.key ) }
        if( xmlChange == null ) {
          result.add( ran )
        }
      }
      return result  */
		}

		int x=0, y=0
		int numRan = ranChanges.size()
		int numXml = xmlChanges.size()
		int numRollback

		//----------------------------------------------------------
		// Strict: Compare the lists until there is a difference, then break.
		//----------------------------------------------------------
		while(true) {
			if( x == numRan && y == numXml ) {
				// No more changes, no rollbacks.
				break
			}

			if( x < numRan && y < numXml ) {
				String ranKey = ranChanges[x].getKey()
				String xmlKey = xmlChanges[y].getKey()
        log.debug( " comparing $xmlKey to $ranKey" )

				if( xmlKey.equals(ranKey) && hashEqual( liquibase, xmlChanges[y], ranChanges[x]) ) {
					// These changes are the same change. Keep looking.
					//logInfo( " equal at x=$x" )
				} else {
					// Changes are not the same. Roll back ran changes to here (to this x).
					numRollback = numRan - x
					break
				}
				x++
				y++
			} else if( x >= numRan ) {
				// At end of ran changes with no difference, so no rollbacks.
				break
			} else { //if( y >= numXml )
				// At end of new changes with no differences, roll back ran changes to here (to this x).
				numRollback = numRan - x
				break
			}
		}

		log.debug( "Changes that must be rolled back: x=$x, y=$y, numRan=$numRan, numXml=$numXml, numRollback=$numRollback" )

		// Create the return value.
		List<RanChangeSetAndRollbackData> result = new ArrayList<RanChangeSetAndRollbackData>()
		for( int index=x; index < numRan; index++ ) {
			result.add( ranChanges[index] )
		}
		return result
	}

  /**
   * Compare the hash values of a change set from a file (xmlChange)
   * with a ran change set (ranChangeSetAndRollbackData).
   * The hash of the ran change set is known and has been fetched from the database.
   * Use Liquibase to calculate hash (CheckSum) for the ChangeSet; this requires parsing
   * of the change which requires a Liquibase object.
   * @param lb A liquibase object for getting database value.
   * @param xmlChange A change set from a file to compare to ranChangeSetAndRollbackData.
   * @param ranChangeSetAndRollbackData A change set from the database.
   * @param cache To be implemented.
   * @return True if the xml change set can be parsed and its hash is equal to that of the ranChangeSetAndRollbackData.
   */
  protected boolean hashEqual( Liquibase lb, XmlChange xmlChange, RanChangeSetAndRollbackData ranChangeSetAndRollbackData, Map cache = null ) {
    //------------------------------------
    // First do our own file hash check
    //------------------------------------
    log?.debug( "Testing hashes for file \"xmlChange.file?.name\"." )
    if( xmlChange.file != null ) {
      //String fileHash = liquibase.util.MD5Util.computeMD5( xmlChange.file.newInputStream() )
      String fileHash = xmlChange.fileHash
      log?.debug( "File hash = $fileHash, hash from db = ${ranChangeSetAndRollbackData.fileHash}" )
      if( fileHash.equals(ranChangeSetAndRollbackData.fileHash) ) {
        log?.debug( " hashEqual: current file hash is equal to file hash from databasechangelog." )
        return true
      }
    }


    //------------------------------------
    // Then do the ChangeSet hash check
    //------------------------------------
    log?.debug( " hashEqual: current file hash differs from file hash from databasechangelog." )

    // Set up a list of one xml file change for the liquibase object.
    List<FileNameAndXml> changes = new ArrayList<FileNameAndXml>()
    changes.add( xmlChange )

    // Create the liquibase object (and turn the file list into a virtual change log file).
    StringBuilder generatedChangeLogFileName = new StringBuilder()
    Liquibase tmpBase = createLiquibase( changes, lb.database, true, generatedChangeLogFileName )
    String changeLogFile = generatedChangeLogFileName.toString()

    // Parse the virtual change log file into a ChangeLog object.
    DatabaseChangeLog changeLog
    try {
      changeLog = ChangeLogParserFactory.getInstance().getParser(
        changeLogFile, tmpBase.fileOpener ).parse(
          changeLogFile, tmpBase.changeLogParameters, tmpBase.fileOpener );
    } catch( ChangeLogParseException parseException ) {
      log.error( "Parse error for xml change: " + xmlChange.xmlData, parseException )
      throw parseException
    }

    // Look up the xml change set in the parsed ChangeLog (there should only be one).
    liquibase.changelog.ChangeSet changeSet = changeLog.changeSets?.first() //changeSet = changeLog.getChangeSet( xmlChange.fileName, xmlChange.author, xmlChange.id ) // ( ranChangeSetAndRollbackData.ranChangeSet )

    if( changeSet == null ) {
      // The change sets are not equal if the xml change did not parse properly
      throw new Exception( "change set not found: parse problem?" )
    } else {
      CheckSum newCheckSum = changeSet.generateCheckSum()
      boolean test = newCheckSum.equals( ranChangeSetAndRollbackData.ranChangeSet.lastCheckSum )
      if( test ) {
        log?.debug( "File hash for ran change set \"${xmlChange.key}\" has changed but the Liquibase hash is the same. File hash and rollback data should be updated." )
        xmlChange.fileHashUpdateRequiredInDatabase = true
      } else {
        log?.info( "Ran change set \"${xmlChange.key}\" has changed (failed hash test), new hash: $newCheckSum, old hash: ${ranChangeSetAndRollbackData.ranChangeSet.lastCheckSum}" )
      }
      return test
    }
  }


  /**
   * Read data from DATABASECHANGELOG.ROLLBACK_COLUMN_NAME.
   * We know the row is there but the rollback data is unknown.
   * @param liquibase A Liquibase object.
   * @param ranChange A change set that has been ran against the database.
   * @return The full xml from the change set file, or null if there is no row matching the RanChangeSet.
   */
  protected RanChangeSetAndRollbackData getRollbackDataForRanChangeSet(Liquibase liquibase, RanChangeSet ranChange) {
    log.debug("Checking DATABASECHANGELOG for data on ${ranChange.id}/${ranChange.author}/${ranChange.changeLog}")

    Executor executor = ExecutorService.getInstance().getExecutor(liquibase.database)
    executor.comment("Checking for rollback data.")

    // The WhereClause interface is not implemented for key.. can that be right?
    // Yes, and there is special handling in Liquibase depending on the implementing class like this:
    //  "if statement.whereclause instanceof ByTag then sql+=" WHERE TAG="...,
    // which is certainly one way of not doing it right.
    SqlStatement select = new SelectFromDatabaseChangeLogStatement("FILENAME", "AUTHOR", "ID", "MD5SUM", "DATEEXECUTED", "ORDEREXECUTED", "TAG", "EXECTYPE", ROLLBACK_COLUMN_NAME, FILEHASH_COLUMN_NAME).setOrderBy("DATEEXECUTED ASC", "ORDEREXECUTED ASC")
    List<Map> results = executor.queryForList(select)
    for (Map rs: results) {
      String fileName = rs.get("FILENAME").toString();
      String author = rs.get("AUTHOR").toString();
      String id = rs.get("ID").toString();
      //String md5sum = rs.get("MD5SUM") == null ? null : rs.get("MD5SUM").toString();

      if (fileName.equals(ranChange.changeLog) && author.equals(ranChange.author) && id.equals(ranChange.id)) {
        // This is the record you are looking for.
        def data = rs.get(ROLLBACK_COLUMN_NAME)
        def fileHash = rs.get(FILEHASH_COLUMN_NAME)
        log?.debug( "Reading file hash '$fileHash' from db where key=$id:$author:$fileName")
        RanChangeSetAndRollbackData rollbackData = null
        if( data ) {
          //= data ? data.toString() : null;
          return new RanChangeSetAndRollbackData( ranChange, data.toString(), fileHash.toString() )
        }
        return rollbackData
      }
    }
    return null
  }

  /**
   * Helper to facilitate comparisons between the different kinds of changes we use in this program.
   * @param ranChange A liquibase.changelog.RanChangeSet object.
   * @return A key consisting of ID:AUTHOR:FILENAME (the same as the key in the DATABASECHANGELOG table).
   */
	String makeKey( RanChangeSet ranChange ) {
		return "${ranChange.id}:${ranChange.author}:${ranChange.changeLog}"
	}


  /**
   * Create a Liquibase object which will get a special FileSystemResourceAccessor that can transparently serve
   * liquibase change log files that do not exist on disk.
   * @param changeSets
   * @param database
   * @return
   */
  protected Liquibase createLiquibase( List<FileNameAndXml> changeSets, liquibase.database.Database database, boolean addLogger = false, StringBuilder outChangeLogFileName = null ) {
    String changeLogName = java.util.UUID.randomUUID().toString() + ".xml"
    if( outChangeLogFileName != null ) {
      outChangeLogFileName.append( changeLogName )
    }

    ResourceAccessor fileResources = new CustomFileSystemResourceAccessor( null, changeLogName, changeSets )
    ResourceAccessor classResources = new ClassLoaderResourceAccessor()

    List<ResourceAccessor> accessorList = new ArrayList<ResourceAccessor>()
    accessorList.add( classResources )
    accessorList.add( fileResources )

    if( addLogger ) {
//      liquibase.logging.LogFactory.getLogger().addHandler( new LiquibaseLogHandler(this) )
//      liquibase.logging.LogFactory.getLogger().setUseParentHandlers( false )
    }

    System.setProperty("liquibase.scan.packages", "com.iteego.db")

    // Create Liquibase object.
    Liquibase liquibaseObject = new Liquibase(
      changeLogName,
      new BetterCompositeResourceAccessor( accessorList ),
      database )

    return liquibaseObject
  }

  /**
   * Tests the DATABASECHANGELOG table for our custom fields.
   * @param database A liquibase database to update.
   */
  protected void verifyCustomColumns( Database database ) {
    LockService lockService = LockService.getInstance( database )
    lockService.setChangeLogLockRecheckTime( lockRecheckTimeMilliseconds )
    lockService.waitForLock()

    try {
      Table changeLogTable = DatabaseSnapshotGeneratorFactory.getInstance().getGenerator(database).getDatabaseChangeLogTable(database);

      boolean hasRollbackTagColumn = changeLogTable.getColumn(ROLLBACK_COLUMN_NAME) != null;
      if (!hasRollbackTagColumn) {
        createRollbackColumn( database )
      } else {
        log.debug( "Column databasechangelog.${ROLLBACK_COLUMN_NAME} already exists in ${changeLogTable.name}." )
      }

      boolean hasFilehashColumn = changeLogTable.getColumn(FILEHASH_COLUMN_NAME) != null;
      if (!hasFilehashColumn) {
        createFilehashColumn( database )
      } else {
        log.debug( "Column databasechangelog.${FILEHASH_COLUMN_NAME} already exists in ${changeLogTable.name}." )
      }

    } finally {
      lockService.releaseLock()
    }
  }

  /**
   * Liquibase functionality is used here to add column ROLLBACK_COLUMN_NAME to table DATABASECHANGELOG.
   * @param database A liquibase database to update.
   */
	protected void createRollbackColumn( Database database ) {
    createColumn( database, ROLLBACK_COLUMN_NAME, "CLOB" )
  }

  /**
   * Liquibase functionality is used here to add column FILEHASH_COLUMN_NAME to table DATABASECHANGELOG.
   * @param database A liquibase database to update.
   */
  protected void createFilehashColumn( Database database ) {
    createColumn( database, FILEHASH_COLUMN_NAME, "VARCHAR(50)" )
  }

  protected void createColumn( Database database, String columnName, String dataType ) {
    log.info( "Adding DATABASECHANGELOG.$columnName column to the database." )
    Executor executor = ExecutorService.getInstance().getExecutor( database );
    executor.comment("Adding DATABASECHANGELOG.$columnName column.");
    def addStatement = new AddColumnStatement(
      database.liquibaseSchemaName,
      database.databaseChangeLogTableName,
      columnName,
      dataType,
      null );
    executor.execute( addStatement );
    database.commit();
  }

  /**
   * The database must have a Liquibase DATABASECHANGELOG table before we run liquibase updates because we
   * want to add another column to it.
   * @param liquibase A liquibase object.
   */
  protected void verifyLiquibaseTable( Liquibase liquibase ) {
    LockService lockService = LockService.getInstance( liquibase.database )
    lockService.setChangeLogLockRecheckTime( lockRecheckTimeMilliseconds )
    lockService.waitForLock()
    try {
      final boolean updateExistingNullChecksums = false
      DatabaseChangeLog databaseChangeLog = new DatabaseChangeLog("")
      liquibase.database.checkDatabaseChangeLogTable( updateExistingNullChecksums, databaseChangeLog, null )
      if( !liquibase.database.hasDatabaseChangeLogTable() ) {
        throw new Exception( "Missing: Database Change Log Table." )
      }
    } finally {
      lockService.releaseLock()
    }
  }


  protected void doLiquibaseUpdate( String contexts, Liquibase lb, String changeLogFilePath )
  {

    // Explanation of this method:
    // Liquibase takes a long long long time to validate big change sets even if the change has already been run.
    // There is no inherent way around that in Liquibase version 2.0 but the time spent testing ran changes
    // had to be reduced. The way I did this was to use the same calls as Liquibase.update(String) does and
    // do the tests myself. Not perfect, but at least it does not take 3 minutes per database just to verify
    // that previously ran changes can be run against the current database provider. Unfortunately Liquibase
    // does not expose its changeLogFile member so there had to be additional functionality to keep that value
    // and send it here if validation was to be skipped for ran changes.

    // Explanation of the 2 code paths:
    // The Liquibase class keeps its changeLogFile member private and to be able to use the same calls as
    // in Liquibase.update(String) I had to send the change log file path here. We don't need to skip validation
    // during testing and rollbacks so it is allowed not to send a change log file path to this method if you
    // want to skip validation (the file path is always handed to the Liquibase object in the constructor, we just
    // can not read the value back from the Liquibase object).

    if( !changeLogFilePath ) {
      lb.update( contexts )
      return
    }


    changeLogFilePath = changeLogFilePath.replace('\\', '/') // Liquibase does this in its constructor to its private path member.
    log.info( "Using changeLogFilePath: \"$changeLogFilePath\".")

    LockService lockService = LockService.getInstance( lb.database )
    lockService.waitForLock();

    lb.changeLogParameters.setContexts( liquibase.util.StringUtils.splitAndTrim(contexts, ",") )

    try {
      DatabaseChangeLog changeLog = liquibase.parser.ChangeLogParserFactory.getInstance().getParser(
          changeLogFilePath, lb.fileOpener ).parse(
          changeLogFilePath, lb.changeLogParameters, lb.fileOpener )

      // Validate the DATABASECHANGELOG table.
      lb.checkDatabaseChangeLogTable( true, changeLog, contexts )

      // Validate change sets that have NOT been run (that is: if they are not in the databasechangelog table with the right md5 sum).
      // (replacing the call to changeLog.validate(database, contexts);)
      FasterChangeLog fcl = new FasterChangeLog( changeLog, lb.fileOpener );
      fcl.validate( lb.database, contexts );
      // Get list of not previously ran change sets.
      List<liquibase.changelog.ChangeSet> newChanges = new ArrayList<liquibase.changelog.ChangeSet>();
      liquibase.changelog.filter.ChangeSetFilter testRan = new liquibase.changelog.filter.ShouldRunChangeSetFilter( lb.database );
      log?.info( "ChangeLog with path '${changeLog?.filePath}' has ${changeLog?.changeSets?.size()} ChangeSets." )
      changeLog.changeSets.each {
        if( testRan.accepts( it ) ) {
          newChanges.add( it )
          if( progressListener ) {
            String key = "${it.id}:${it.author}:${it.filePath}"
            progressListener.addToUpdateQueue( key, null, null )
          }

        }
      }
      log?.info( "New changes: ${newChanges.size()}" )

      // Get updating visitor.
      liquibase.changelog.ChangeLogIterator changeLogIterator = getStandardChangelogIterator( contexts, changeLog, lb.database )

      // Run the (not previously ran) updates.
      changeLogIterator.run( new UpdateVisitor(lb.database), lb.database )
    }
    finally {
      try {
        lockService.releaseLock();
      }
      catch (Exception e) {
        log?.error("Could not release lock", e)
      }
    }
  }


  private liquibase.changelog.ChangeLogIterator getStandardChangelogIterator(String contexts, DatabaseChangeLog changeLog, liquibase.database.Database database) {
    return new liquibase.changelog.ChangeLogIterator(changeLog,
        new liquibase.changelog.filter.ShouldRunChangeSetFilter(database),
        new liquibase.changelog.filter.ContextChangeSetFilter(contexts),
        new liquibase.changelog.filter.DbmsChangeSetFilter(database));
  }

  /**
   * For each change that was executed on the database:
   *  Write the xml file contents of the change set file to a column in the
   *  change log table to allow rollbacks when the file goes missing (after you change git branch for example).
   * @param liquibase Use the database in this liquibase object for saving data.
   * @param ranChangesBefore The changes that were in the liquibase table before we started changing things.
   * @param ranChangesAfter The changes that we recently ran on the liquibase object.
   * @param xmlFileDir Directory where the recently ran xml change set files are.
   *                   Xml data will be pulled from those files and inserted into the ROLLBACK_COLUMN_NAME column
   *                   of the liquibase DATABASECHANGELOG table.
   */
  protected void recordChanges2(
      List<XmlChange> xmlChanges,
      Liquibase liquibase,
      List<RanChangeSetAndRollbackData> ranChangesBefore,
      List<RanChangeSetAndRollbackData> ranChangesAfter,
      String xmlFileDir,
      java.sql.Connection connection )
  {
    LockService lockService = LockService.getInstance( liquibase.database )
    lockService.setChangeLogLockRecheckTime( lockRecheckTimeMilliseconds )
    lockService.waitForLock()

    try {
      // Update rows in the database that differ between after and before (found by key).
      ranChangesAfter.each { RanChangeSetAndRollbackData ranChange ->
        log?.debug( "Recording changes for ${ranChange.key}")
        XmlChange xmlChange = xmlChanges.find { it.key.equals( ranChange.key ) }
        if( !xmlChange ) {
          // This CAN happen if a file has been removed (so the change should be rolled back)
          // but the rollback could not be done because of a rollback limit or missing rollback data.
          log?.info( "XML file not found when recording changes for ${ranChange.key}, not updating this record.")
        }
        else {
          RanChangeSetAndRollbackData originalData = ranChangesBefore.find { it.key.equals( ranChange.key ) }

          boolean update = false
          if( originalData == null ) {
            log?.debug( "New change set    -> must update for key ${ranChange.key}" )
            update = true
          }
          if( ranChange.xmlData == null ) {
            log?.debug( "Missing XML data  -> must update for key ${ranChange.key}" )
            update = true
          }
          if( ranChange.fileHash == null ) {
            log?.debug( "Missing file hash -> must update for key ${ranChange.key}" )
            update = true
          }
          if( originalData!=null && !ranChange.ranChangeSet.lastCheckSum.equals(originalData.ranChangeSet.lastCheckSum) ) {
            log?.debug( "Checksum changed  -> must update for key ${ranChange.key}" )
            update = true
          }

          if( update ) {
            String changeLogFilePath = ranChange.ranChangeSet.changeLog

            // Save all (XML) text from the file that this change set came from.
            String xmlData = xmlChange.xmlData

            if( xmlData != null ) {
              String fileHash = xmlChange.fileHash
              log?.debug("recordChanges: file hash: $fileHash")
              log?.info( "Recording ${xmlData?xmlData.size():0} bytes of XML change set data for change set with key (id/author/path): ${ranChange.ranChangeSet.id}/${ranChange.ranChangeSet.author}/${changeLogFilePath}, checksum: '${ranChange.ranChangeSet.lastCheckSum}', file hash '$fileHash'" )
              log?.debug(" Recording xml data: $xmlData")
              // Write the file content to the $ROLLBACK_COLUMN_NAME column in the database.
              insertRollbackData( liquibase, ranChange.ranChangeSet.id, ranChange.ranChangeSet.author, ranChange.ranChangeSet.changeLog, xmlData, fileHash, connection )
            } else {
              log?.warning( "XML data is NULL, not updating database change log with changes for \"${ranChange.key}\".")
            }
          }
        }
      }
    }
    finally {
      lockService.releaseLock()
    }
  }


  /**
   * Insert a single value in the DATABASECHANGELOG table. Called by recordChanges().
   * @param liquibase A liquibase object.
   * @param id ChangeSet id
   * @param author ChangeSet author
   * @param fileName ChangeSet file name
   * @param data ChangeSet xml
   */
	protected void insertRollbackData( Liquibase liquibase, String id, String author, String fileName, String data, String fileHash, java.sql.Connection connection  ) {
		log?.debug( " Inserting ${data?.size()} characters of data into DATABASECHANGELOG.${ROLLBACK_COLUMN_NAME}" )

    // The use of liquibase to insert rollback data was scrapped because Oracle would
    // not insert more than 4k into a CLOB if using SQL (or 32k with bound parameter).
    // The version used here should work on all JNDI connections.

    //noinspection GroovyUnusedAssignment
    PreparedStatement prepStmt = null
    try {
      prepStmt = connection.prepareStatement( "UPDATE DATABASECHANGELOG SET $ROLLBACK_COLUMN_NAME=?, $FILEHASH_COLUMN_NAME=? WHERE ID=? AND AUTHOR=? AND FILENAME=?" )
      StringReader reader = new StringReader( data )
      //prepStmt.setClob( 1, reader, data.size() ) //fail on oracle xe
      prepStmt.setCharacterStream( 1, reader, data.size() )
      prepStmt.setString( 2, fileHash )
      prepStmt.setString( 3, id )
      prepStmt.setString( 4, author )
      prepStmt.setString( 5, fileName )
      int affectedRowCount = prepStmt.executeUpdate()
      connection.commit()
      if( affectedRowCount == 1 ) {
        log?.debug( " The change set was successfully saved to the database. hash=$fileHash")
      } else {
        log?.warning( " Expected rows affected by update to be 1, actual value: $affectedRowCount." )
      }
    } catch( Throwable throwable ) {
      log?.error( "Failed to insert ${data?.size()} characters of data into DATABASECHANGELOG.${ROLLBACK_COLUMN_NAME}. Message: '${throwable.message}'." )
      throw throwable
    }


//		Executor executor = ExecutorService.getInstance().getExecutor( liquibase.database )
//		executor.comment("Adding rollback data to databasechangelog.${ROLLBACK_COLUMN_NAME}")
//
//		UpdateStatement stmt = new UpdateStatement( liquibase.database.getLiquibaseSchemaName(), liquibase.database.getDatabaseChangeLogTableName() )
//			.addNewColumnValue( ROLLBACK_COLUMN_NAME, data )
//			.setWhereClause("ID=? AND AUTHOR=? AND FILENAME=?")
//			.addWhereParameters( id, author, fileName )
//
//		executor.execute( stmt )
//		liquibase.database.commit()

	}




  protected void stopMe() {
    try {
      Nucleus.getGlobalNucleus().stopService()
    } catch( Throwable throwable ) {
      log?.error( "Exception (${throwable.class.name}) when stopping Nucleus. Message: '${throwable.message}'." )
      System.exit(1)
    }

    // In "BigEar" mode (atg.nucleus.DynamoEnv.isBigEar()) we are not _really_ supposed to do this:
    //if( !atg.nucleus.DynamoEnv.isBigEar() ) {
      System.exit(2)
    //}
  }


  public void setDirectoryToJndiMap(Map<String, String> map) {
    if (!map) {
      directoryToJndiMap = [:]
      return
    }

    directoryToJndiMap = new TreeMap<String, String>(map)
  }
  public Map<String, String> getDirectoryToJndiMap() {
    directoryToJndiMap
  }

  public void setRollbackLimits(Map<String, String> map) {
    if (!map) {
      rollbackLimits = [:]
      return
    }

    rollbackLimits = new TreeMap<String, String>(map)
  }
  public Map<String, String> getRollbackLimits() {
    rollbackLimits
  }

  public boolean getAllowRollback() { return allowRollback }
  public void setAllowRollback( boolean newValue ) { allowRollback = newValue }

  public String getRollbackStrategy() { return rollbackStrategy }
  public void setRollbackStrategy( String newValue ) {
    if( !newValue ) return
    newValue = newValue.toLowerCase().trim()
    if( ALLOWED_ROLLBACK_STRATEGIES.find { it.equals(newValue) } ) {
      rollbackStrategy = newValue
    } else {
      String message = "Allowed LiquibaseService.rollbackStrategy values are: $ALLOWED_ROLLBACK_STRATEGIES, not '$newValue'. Exiting."
      println message // log may not be available here.
      log?.error( message )
      System.exit(1)
      // Throwing here does not stop ATG.
      //throw new Exception( "Allowed rollbackStrategy values are: $ALLOWED_ROLLBACK_STRATEGIES" )
    }
  }

  public String getErrorStrategy() { return errorStrategy }
  public void setErrorStrategy( String newValue ) {
    if( !newValue ) return
    newValue = newValue.toLowerCase().trim()
    if( ALLOWED_ERROR_STRATEGIES.find { it.equals(newValue) } ) {
      errorStrategy = newValue
    } else {
      String message = "Allowed LiquibaseService.errorStrategy values are: $ALLOWED_ERROR_STRATEGIES, not '$newValue'. Exiting."
      println message // log may not be available here.
      log?.error( message )
      System.exit(1)
    }
  }

  public boolean getEnabled() { return enabled }
  public void setEnabled( boolean newValue ) { enabled = newValue }

}

