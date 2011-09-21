/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import liquibase.changelog.DatabaseChangeLog
import liquibase.exception.ValidationFailedException
import liquibase.logging.LogFactory
import liquibase.database.Database
import liquibase.exception.LiquibaseException
import liquibase.changelog.ChangeLogIterator
import liquibase.changelog.filter.DbmsChangeSetFilter
import liquibase.changelog.filter.ContextChangeSetFilter
import liquibase.changelog.visitor.ValidatingVisitor
import liquibase.changelog.visitor.ChangeSetVisitor
import liquibase.changelog.ChangeSet
import liquibase.change.CheckSum
import liquibase.changelog.RanChangeSet
import liquibase.executor.ExecutorService
import liquibase.statement.core.SelectFromDatabaseChangeLogStatement
import liquibase.statement.SqlStatement

/**
 * All this because liquibase does not use enough method calls,
 * such as for example one to get the validating visitor...
 * See also our class FasterValidatingVisitor.
 */
class FasterChangeLog extends DatabaseChangeLog {
  liquibase.resource.ResourceAccessor fileOpener = null

  /**
   * Copy constructor.
   * @param original Original.
   * @return A new FasterChangeLog.
   */
  public FasterChangeLog( DatabaseChangeLog original, liquibase.resource.ResourceAccessor fileOpener ) {
    this.fileOpener = fileOpener

    setPhysicalFilePath( original.getPhysicalFilePath() )
    setLogicalFilePath( original.getLogicalFilePath() )
    setPreconditions( original.getPreconditions() )

    original.getChangeSets().each {
      addChangeSet( it )
    }
  }

  /**
   * New method. Returns our fast visitor and also collects extended data from the DATABASECHANGELOG.
   * @param database Liquibase database.
   * @return A visitor that is of a subclass of the ValidatingVisitor.
   */
  protected ChangeSetVisitor getValidatingVisitor(Database database) {
    List<RanChangeSet> ranChangeSetList = new ArrayList<RanChangeSet>()
    List<RanChangeSetAndRollbackData> extendedRanChangeSetList = new ArrayList<RanChangeSetAndRollbackData>()

    FasterChangeLog.getRanChangesAndExtensions( database, ranChangeSetList, extendedRanChangeSetList )

//    LogFactory.getLogger().info("Reading from " + database.databaseChangeLogTableName);
//    SqlStatement select = new SelectFromDatabaseChangeLogStatement(
//        "FILENAME", "AUTHOR", "ID", "MD5SUM", "DATEEXECUTED", "ORDEREXECUTED", "TAG", "EXECTYPE", LiquibaseService.ROLLBACK_COLUMN_NAME, LiquibaseService.FILEHASH_COLUMN_NAME).setOrderBy("DATEEXECUTED ASC", "ORDEREXECUTED ASC");
//    List<Map> results = ExecutorService.getInstance().getExecutor(database).queryForList(select);
//    for( Map rs: results ) {
//      String fileName = rs.get("FILENAME").toString();
//      String author = rs.get("AUTHOR").toString();
//      String id = rs.get("ID").toString();
//      String md5sum = rs.get("MD5SUM") == null ? null : rs.get("MD5SUM").toString();
//      Date dateExecuted = (Date) rs.get("DATEEXECUTED");
//      String tag = rs.get("TAG") == null ? null : rs.get("TAG").toString();
//      String execType = rs.get("EXECTYPE") == null ? null : rs.get("EXECTYPE").toString();
//
//      String rollbackData = rs.get(LiquibaseService.ROLLBACK_COLUMN_NAME) == null ? null : rs.get(LiquibaseService.ROLLBACK_COLUMN_NAME).toString();
//      String fileHash = rs.get(LiquibaseService.FILEHASH_COLUMN_NAME) == null ? null : rs.get(LiquibaseService.FILEHASH_COLUMN_NAME).toString();
//
//      try {
//        RanChangeSet ranChangeSet = new RanChangeSet(fileName, id, author, CheckSum.parse(md5sum), dateExecuted, tag, ChangeSet.ExecType.valueOf(execType));
//        ranChangeSetList.add(ranChangeSet)
//
//        RanChangeSetAndRollbackData data = new RanChangeSetAndRollbackData(ranChangeSet, rollbackData, fileHash)
//        extendedRanChangeSetList.add(data);
//      } catch (IllegalArgumentException e) {
//        LogFactory.getLogger().severe("Unknown EXECTYPE from database: " + execType);
//        throw e;
//      }
//    }

    // Run the next line because the database object caches the list and may use it without our knowledge.
    database.getRanChangeSetList()

//    System.err.println "** ranChangeSetList size = ${ranChangeSetList.size()}"
//    System.err.println "** extendedRanChangeSetList size = ${extendedRanChangeSetList.size()}"

    return new FasterValidatingVisitor(ranChangeSetList, extendedRanChangeSetList, fileOpener)
  }


  public static void getRanChangesAndExtensions( Database database, List<RanChangeSet> ranChangeSetList, List<RanChangeSetAndRollbackData> extendedRanChangeSetList ) {
    LogFactory.getLogger().info("Reading from " + database.databaseChangeLogTableName);
    SqlStatement select = new SelectFromDatabaseChangeLogStatement(
        "FILENAME", "AUTHOR", "ID", "MD5SUM", "DATEEXECUTED", "ORDEREXECUTED", "TAG", "EXECTYPE", LiquibaseService.ROLLBACK_COLUMN_NAME, LiquibaseService.FILEHASH_COLUMN_NAME).setOrderBy("DATEEXECUTED ASC", "ORDEREXECUTED ASC");
    List<Map> results = ExecutorService.getInstance().getExecutor(database).queryForList(select);
    for( Map rs: results ) {
      String fileName = rs.get("FILENAME").toString();
      String author = rs.get("AUTHOR").toString();
      String id = rs.get("ID").toString();
      String md5sum = rs.get("MD5SUM") == null ? null : rs.get("MD5SUM").toString();
      Date dateExecuted = (Date) rs.get("DATEEXECUTED");
      String tag = rs.get("TAG") == null ? null : rs.get("TAG").toString();
      String execType = rs.get("EXECTYPE") == null ? null : rs.get("EXECTYPE").toString();

      String rollbackData = rs.get(LiquibaseService.ROLLBACK_COLUMN_NAME) == null ? null : rs.get(LiquibaseService.ROLLBACK_COLUMN_NAME).toString();
      String fileHash = rs.get(LiquibaseService.FILEHASH_COLUMN_NAME) == null ? null : rs.get(LiquibaseService.FILEHASH_COLUMN_NAME).toString();

      try {
        RanChangeSet ranChangeSet = new RanChangeSet(fileName, id, author, CheckSum.parse(md5sum), dateExecuted, tag, ChangeSet.ExecType.valueOf(execType));
        ranChangeSetList.add(ranChangeSet)

        RanChangeSetAndRollbackData data = new RanChangeSetAndRollbackData(ranChangeSet, rollbackData, fileHash)
        extendedRanChangeSetList.add(data);
      } catch (IllegalArgumentException e) {
        LogFactory.getLogger().severe("Unknown EXECTYPE from database: " + execType);
        throw e;
      }
    }
  }

  /**
   * Overridden and basically copied from the original except
   * the line that creates a ValidatingVisitor.
   * @param database Liquibase database.
   * @param contexts String with context names.
   * @throws LiquibaseException Like when validation fails.
   */
  @Override
  public void validate(Database database, String... contexts) throws LiquibaseException {
      ChangeLogIterator logIterator = new ChangeLogIterator( this, new DbmsChangeSetFilter(database), new ContextChangeSetFilter(contexts) );

      // THIS is a good place to use an overridable method call.
      ValidatingVisitor validatingVisitor = getValidatingVisitor( database )

      validatingVisitor.validate(database, this);
      logIterator.run(validatingVisitor, database);

      for (String message : validatingVisitor.getWarnings().getMessages()) {
          LogFactory.getLogger().warning(message);
      }

      if (!validatingVisitor.validationPassed()) {
          throw new ValidationFailedException(validatingVisitor);
      }
  }

}
