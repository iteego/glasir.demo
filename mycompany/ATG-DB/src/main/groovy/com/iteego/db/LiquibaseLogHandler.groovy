/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db
import liquibase.logging.LogLevel

public class LiquibaseLogHandler implements liquibase.logging.Logger {
  LogLevel logLevel = LogLevel.DEBUG
  String name = "iteego";

  public LiquibaseLogHandler() {
  }

  public int getPriority() {
    // This is the priority used by Liquibase to determine which liquibase.logging.Logger will be used.
    return Integer.MAX_VALUE - 1000 // In case we want to push another logger.
  }

  void setName(String s) {
    name = s
  }


  public void setLogLevel( String logLevel, String logFile ) {
      setLogLevel( logLevel );
  }

  public void setLogLevel( String logLevel ) {
    String s = logLevel.toLowerCase()
    switch( s ) {
      case "debug":
          setLogLevel(LogLevel.DEBUG)
          break
      case "info":
          setLogLevel(LogLevel.INFO);
      break
      case "warning":
          setLogLevel(LogLevel.WARNING);
      break
      case "severe":
          setLogLevel(LogLevel.SEVERE);
      break
      case "off":
          setLogLevel(LogLevel.OFF);
      break
      default:
          throw new Exception("Unknown log level: \"$logLevel\".  Valid levels are: off, debug, info, warning, severe");
      }
  }

  public void setLogLevel(LogLevel level) {
      this.logLevel = level;
  }


  LogLevel getLogLevel() {
    return logLevel
  }



  void severe(String s) {
    if( logLevel != LogLevel.OFF && logLevel <= LogLevel.SEVERE )
      LiquibaseService.getAtgLogHelper( null )?.error( s )
  }

  void severe(String s, Throwable throwable) {
    if( logLevel != LogLevel.OFF && logLevel <= LogLevel.SEVERE )
      LiquibaseService.getAtgLogHelper( null )?.error( s, throwable )
  }

  void warning(String s) {
    if( logLevel != LogLevel.OFF && logLevel <= LogLevel.WARNING )
      LiquibaseService.getAtgLogHelper( null )?.warning( s )
  }

  void warning(String s, Throwable throwable) {
    if( logLevel != LogLevel.OFF && logLevel <= LogLevel.WARNING )
      LiquibaseService.getAtgLogHelper( null )?.warning( s, throwable )
  }

  void info(String s) {
    if( logLevel != LogLevel.OFF && logLevel <= LogLevel.INFO )
      LiquibaseService.getAtgLogHelper( null )?.info( s )
  }

  void info(String s, Throwable throwable) {
    if( logLevel != LogLevel.OFF && logLevel <= LogLevel.INFO )
      LiquibaseService.getAtgLogHelper( null )?.info( s, throwable )
  }

  void debug(String s) {
    if( logLevel != LogLevel.OFF && logLevel <= LogLevel.DEBUG )
      LiquibaseService.getAtgLogHelper( null )?.debug( s )
  }

  void debug(String s, Throwable throwable) {
    if( logLevel != LogLevel.OFF && logLevel <= LogLevel.DEBUG )
      LiquibaseService.getAtgLogHelper( null )?.debug( s, throwable )
  }

}