/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

class ProgressListener {
  class Data {
    public String key, changeHash, fileHash
  }

  List<Data> rollbackData
  List<Data> updateData

  int expectedRowCount // Number of rows in the DATABASECHANGELOG table after the test.
  //int expectedRollbackCount
  //int expectedUpdateCount
  List<String> expectedKeys // Keys in database after test.
  List<String> expectedUpdateKeys
  List<String> expectedRollbackKeys



  public ProgressListener() {
    resetLists()
  }

  public void addToRollbackQueue( String key, String changeHash, String fileHash ) {
    Data data = new Data()
    data.key=key
    data.changeHash=changeHash
    data.fileHash=fileHash
    rollbackData.add( data )
  }

  public void addToUpdateQueue( String key, String changeHash, String fileHash ) {
    Data data = new Data()
    data.key=key
    data.changeHash=changeHash
    data.fileHash=fileHash
    updateData.add( data )
  }


  public int rollbackQueueSize() {
    return rollbackData.size()
  }

  public int updateQueueSize() {
    return updateData.size()
  }


  public List<String> getUpdateKeys() {
    return updateData.collect { it.key }
  }



  public void resetLists() {
    rollbackData = new ArrayList<Data>()
    updateData = new ArrayList<Data>()

    expectedKeys = new ArrayList<String>()
    expectedUpdateKeys = new ArrayList<String>()
    expectedRollbackKeys = new ArrayList<String>()
  }
}
