/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import java.util.logging.Level
/**
 * Written for unit testing.
 */
public class TestAtgLogHelper implements AtgLogHelper {
  java.util.logging.Level level
  protected int indentLevel;
  protected String indentString = "\t"


  public void increaseIndent() {
    ++indentLevel;
    if( indentLevel > 100 ) indentLevel = 100;
  }

  public void decreaseIndent() {
    --indentLevel;
    if( indentLevel < 0 ) indentLevel = 0;
  }

  public void setIndent( int newLevel ) {
    indentLevel = newLevel;
    if( indentLevel < 0 ) indentLevel = 0;
  }

  public int getIndent() {
    return indentLevel;
  }


  public TestAtgLogHelper( Level logLevel = Level.INFO ) {
    this.level = logLevel
  }

  boolean isLoggingDebug() {
    return level.intValue() <= Level.CONFIG.intValue()
  }

  boolean isLoggingInfo() {
    return level.intValue() <= Level.INFO.intValue()
  }

  boolean isLoggingWarning() {
    return level.intValue() <= Level.WARNING.intValue()
  }

  boolean isLoggingError() {
    return level.intValue() <= Level.SEVERE .intValue()
  }


  protected doPrint( s ) {
    System.err.println( (indentString * indentLevel) + s )
  }

  
  protected doDebug( String s ) {
    if( isLoggingDebug() )
      doPrint( "Debug: $s" )
  }

  protected doInfo( String s ) {
    if( isLoggingInfo() )
      doPrint( "Info : $s" )
  }

  protected doWarning( String s ) {
    if( isLoggingWarning() )
      doPrint( "Warn : $s" )
  }

  protected doError( String s ) {
    if( isLoggingError() )
      doPrint( "Error: $s" )
  }

  
  
  void debug(String message) {
    doDebug message
  }

  void debug(Throwable e) {
    doDebug e.message
  }

  void debug(String message, Throwable e) {
    doDebug message
  }

  void debug(String message, boolean force) {
    doDebug message
  }

  void debug(Throwable e, boolean force) {
    doDebug e.message
  }

  void debug(String message, Throwable e, boolean force) {
    doDebug message
  }

  
  
  
  
  void info(String message) {
    doInfo message
  }

  void info(Throwable e) {
    doInfo e.message
  }

  void info(String message, Throwable e) {
    doInfo message
  }

  void info(String message, boolean force) {
    doInfo message
  }

  void info(Throwable e, boolean force) {
    doInfo e.message
  }

  void info(String message, Throwable e, boolean force) {
    doInfo message
  }


  
  
  
  
  void warning(String message) {
    doWarning message
  }

  void warning(Throwable e) {
    doWarning e.message
  }

  void warning(String message, Throwable e) {
    doWarning message
  }

  void warning(String message, boolean force) {
    doWarning message
  }

  void warning(Throwable e, boolean force) {
    doWarning e.message
  }

  void warning(String message, Throwable e, boolean force) {
    doWarning message
  }

    
  
  
  void error(String message) {
    doError message
  }

  void error(Throwable e) {
    doError e.message
  }

  void error(String message, Throwable e) {
    doError message
  }

  void error(String message, boolean force) {
    doError message
  }

  void error(Throwable e, boolean force) {
    doError e.message
  }

  void error(String message, Throwable e, boolean force) {
    doError message
  }

    
}