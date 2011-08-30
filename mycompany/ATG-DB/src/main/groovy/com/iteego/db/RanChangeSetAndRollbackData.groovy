/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import liquibase.changelog.RanChangeSet
import groovy.util.slurpersupport.GPathResult

/**
 * Created by IntelliJ IDEA.
 * User: mwangel
 * Date: 2011-03-03
 * Time: 09:49 
 */
class RanChangeSetAndRollbackData extends FileNameAndXml {
	public RanChangeSet ranChangeSet
	public String rollbackData
  public String fileHash

	public RanChangeSetAndRollbackData( RanChangeSet ranChangeSet, String rollbackData, String fileHash ) {
		this.ranChangeSet = ranChangeSet
		this.rollbackData = rollbackData
    this.fileHash = fileHash
	}

	public String getKey() {
		return RanChangeSetAndRollbackData.makeKey( ranChangeSet )
	}

  public static String makeKey( RanChangeSet ranChangeSet ) {
    return "${ranChangeSet.id}:${ranChangeSet.author}:${ranChangeSet.changeLog}"
  }


  String getFileName() {
    return ranChangeSet?.changeLog
  }

  String getXmlData() {
    return rollbackData
  }

  GPathResult getParsedXml() {
    throw new Exception( "getParsedXml is not available for class RanChangeSetAndRollbackData" )
    // ToDo: this is not right! Change the class hierarchy!
  }
}
