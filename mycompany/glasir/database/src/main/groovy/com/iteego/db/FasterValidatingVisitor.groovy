/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import liquibase.changelog.RanChangeSet
import liquibase.changelog.ChangeSet
import liquibase.changelog.DatabaseChangeLog
import liquibase.database.Database
import liquibase.change.Change
import liquibase.exception.SetupException
import liquibase.exception.ValidationErrors
import liquibase.logging.LogFactory

/**
 * A validating visitor that skips ran change sets.
 */
class FasterValidatingVisitor extends liquibase.changelog.visitor.ValidatingVisitor {
  protected List<RanChangeSet> notSoPrivateRanChangeSets
  protected java.util.Set<String> notSoPrivateSeenChanges
  protected List<RanChangeSetAndRollbackData> extendedRanChangeSetList
  liquibase.resource.ResourceAccessor fileOpener = null

  /**
   * Notice how this constructor copies the list of ran
   * changes into a member. The super constructor does
   * the same thing, it is just that its member is PRIVATE
   * so we cant use it from this class..
   * @param ranChangeSets Ran changes as reported by the Database.
   * @return A new FasterValidatingVisitor.
   */
  public FasterValidatingVisitor( List<RanChangeSet> ranChangeSets, List<RanChangeSetAndRollbackData> extendedRanChangeSetList = null, liquibase.resource.ResourceAccessor fileOpener = null ) {
    super( ranChangeSets )
    this.notSoPrivateRanChangeSets = ranChangeSets
    this.notSoPrivateSeenChanges = new HashSet<String>()

    if( extendedRanChangeSetList != null ) {
      this.extendedRanChangeSetList = new ArrayList<RanChangeSetAndRollbackData>( extendedRanChangeSetList )
    }
    this.fileOpener = fileOpener

//    System.err.println " # change sets: ${ranChangeSets.size()}"
//    ranChangeSets.each { RanChangeSet set ->
//      System.err.println "  + ${set.id}"
//    }
  }

  /**
   * Accessor for a protected member.
   * @return A reference to the list of ran changes (see constructor).
   */
  public List<RanChangeSet> getOverriddenRanChangeSets() {
    return notSoPrivateRanChangeSets
  }

  /**
   * Test the ChangeSet against the ran change sets.
   * @param changeSet A ChangeSet.
   * @return True if the ChangeSet properties match an entry in the
   * notSoPrivateRanChangeSets list (meaning, effectively, that the
   * properties match a record in the DATABASECHANGELOG table).
   */
  @SuppressWarnings("GroovyEmptyStatementBody")
  public boolean hasChangeSetBeenRun( ChangeSet changeSet ) {
    //System.err.println "* Testing hasChangeSetBeenRun for ${changeSet.id}."
    for( RanChangeSet ranChangeSet: getOverriddenRanChangeSets() )
    {
      // Test id, author and path.
      if( ranChangeSet.getId().equalsIgnoreCase(changeSet.getId() )
          && ranChangeSet.getAuthor().equalsIgnoreCase(changeSet.getAuthor())
          && ranChangeSet.getChangeLog().equalsIgnoreCase(changeSet.getFilePath()))
      {
//        System.err.println "* now testing hash values"
        // Test md5 too, first our own file checksum.
        if( fileOpener != null && extendedRanChangeSetList != null ) {
          RanChangeSetAndRollbackData tmp = extendedRanChangeSetList.find { it.key.equals( RanChangeSetAndRollbackData.makeKey(ranChangeSet) ) }

          //todo: add try/catch
          //InputStream fileStream = fileOpener.getResourceAsStream( ranChangeSet.changeLog )
          //String csFileHash = liquibase.util.MD5Util.computeMD5( fileStream )
          //fileStream.close()
          if( fileOpener ) {
            CustomFileSystemResourceAccessor loader = null
            if( fileOpener instanceof CustomFileSystemResourceAccessor) {
              // This path will not be taken
              loader = fileOpener as CustomFileSystemResourceAccessor
            } else if( fileOpener instanceof BetterCompositeResourceAccessor ) {
              BetterCompositeResourceAccessor better = fileOpener as BetterCompositeResourceAccessor
              loader = better.getCustomAccessor()
            }

            if( loader != null ) {
              String csFileHash = loader.getFileHash( ranChangeSet.changeLog )
//              System.err.println "* File hash for ${ranChangeSet.changeLog} is ${csFileHash}."

              if( tmp?.fileHash?.equals( csFileHash ) ) {
                return true
              }
            } else {
//              System.err.println " loader is null"
            }
          } else {
//            System.err.println " fileOpener is of class " + fileOpener.class.name
          }
        } else {
//          System.err.println fileOpener
//          System.err.println extendedRanChangeSetList
        }

        // Then Liquibase's checksum of the change set.
        if( changeSet.isCheckSumValid( ranChangeSet.getLastCheckSum() ) ) {
          return true
        }
      }
    }

    //System.err.println "..result is FALSE"
    return false
  }

  /**
   * Basically copied from the base class except the line that tests
   * whether the change set has already been run, thus saving a LOT of time.
   * @param changeSet Visit this change set.
   * @param databaseChangeLog The log that the set is in.
   * @param database The Liquibase database.
   */
  @Override
  public void visit( ChangeSet changeSet, DatabaseChangeLog databaseChangeLog, Database database ) {
    if( !hasChangeSetBeenRun( changeSet ) ) {
      //System.out.println "new change set: $changeSet"
      for (Change change: changeSet.getChanges()) {
        try {
          change.init();
        } catch (SetupException se) {
          setupExceptions.add(se);
        }

        // This call is slow for big SQL change sets.
        warnings.addAll( change.warn(database))

        try {
          //System.out.println "validate change $change"
          ValidationErrors foundErrors = change.validate( database )
          if( foundErrors != null && foundErrors.hasErrors() ) {
            if( changeSet.getOnValidationFail().equals( ChangeSet.ValidationFailOption.MARK_RAN ) ) {
              String errorMessages = foundErrors.getErrorMessages().join( ", " )
              String msg = "Skipping changeSet $changeSet due to validation error(s): $errorMessages"
              LogFactory.getLogger().severe( msg )
              //System.out.println "Validation error: $msg"
              changeSet.setValidationFailed( true )
            } else {
              validationErrors.addAll( foundErrors, changeSet )
            }
          }
        } catch (Throwable e) {
          changeValidationExceptions.add( e )
        }
      }
    }
    else {
      LogFactory.getLogger().debug( "Validator skipping visit to previously ran change set: $changeSet" )
    }


    for (RanChangeSet ranChangeSet: getOverriddenRanChangeSets() ) {
      if (ranChangeSet.getId().equalsIgnoreCase(changeSet.getId())
          && ranChangeSet.getAuthor().equalsIgnoreCase(changeSet.getAuthor())
          && ranChangeSet.getChangeLog().equalsIgnoreCase(changeSet.getFilePath())) {
        if (!changeSet.isCheckSumValid(ranChangeSet.getLastCheckSum())) {
          if (!changeSet.shouldRunOnChange()) {
            invalidMD5Sums.add(changeSet);
          }
        }
      }
    }


    String changeSetString = changeSet.toString(false);
    if (notSoPrivateSeenChanges.contains(changeSetString)) {
      duplicateChangeSets.add( changeSet );
    } else {
      notSoPrivateSeenChanges.add(changeSetString);
    }
  }

}
