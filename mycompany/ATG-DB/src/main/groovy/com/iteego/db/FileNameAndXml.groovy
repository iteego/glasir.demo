/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import groovy.util.slurpersupport.GPathResult

/**
 * This was an interface but the obfuscator could not handle that,
 * so now it is an abstract class.
 */
public abstract class FileNameAndXml {
  abstract public String getFileName();
  abstract public String getXmlData();
  abstract public GPathResult getParsedXml();
}