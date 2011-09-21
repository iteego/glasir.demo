/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import groovy.util.slurpersupport.GPathResult

/**
 */
class XmlChange extends FileNameAndXml {
  public File container // if the file is actually located in a zip file then this is the zip file
	public File file
	public GPathResult xmlData
  public String fileData
  public String xmlFileName
  public String fileHash = null
  public boolean fileHashUpdateRequiredInDatabase = false

	public XmlChange( File file, GPathResult xmlData, String fileData ) {
		this.file = file
		this.xmlData = xmlData
    this.fileData = fileData
    //System.out.println "************** create xmlchange with data " + xmlData?.toString()
	}

	public String getKey() {
		return "${xmlData.changeSet.@id}:${xmlData.changeSet.@author}:${container ? xmlFileName : file?.name}"
	}

  public String getAuthor() {
    return "${xmlData.changeSet.@author}"
  }

  public String getId() {
    return "${xmlData.changeSet.@id}"
  }

  String getFileName() {
    return file?.name
  }

  GPathResult getParsedXml() {
    def s = this.@xmlData
    System.err.println "*** parsed xml: " + s
    return s
  }

  String getXmlData() {
    String xmlData = fileData //file.text
    return xmlData
  }

  public String getChangeSet() {
    return "${xmlData.changeSet }"
  }

}

