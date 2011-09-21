/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db;

import atg.nucleus.logging.ApplicationLogging;

/**
 * Log helper class to save you from having to type:
 * <p/>
 * <pre>
 *   if (isLoggingDebug()) {
 *     logDebug(message)
 *   }
 * </pre>
 * <p/>
 * Instead for any atg components which implement the ApplicationLogging interface (such as
 * any decendants of GenericService) you create an instance field:
 * <p/>
 * <pre>
 *   DefaultAtgLogHelper log = new DefaultAtgLogHelper(this);
 * </pre>
 * <p/>
 * and use it directly:
 * <p/>
 * <pre>
 *   log.debug(message);
 * </pre>
 * <p/>
 * <p/>
 * User: mbjarland
 * Date: Sep 7, 2010
 * Time: 3:29:10 PM
 * To change this template use File | Settings | File Templates.
 */
public class DefaultAtgLogHelper implements AtgLogHelper {
  protected ApplicationLogging logger;
  protected int indentLevel = 0;
  public String indentString = "\t";
  private String currentIndentString = "";

  synchronized
  public void increaseIndent() {
    ++indentLevel;
    if( indentLevel > 100 )
      indentLevel = 100;
    updateCurrentIndentString();
  }

  synchronized
  public void decreaseIndent() {
    --indentLevel;
    if( indentLevel < 0 )
      indentLevel = 0;
    updateCurrentIndentString();
  }

  synchronized
  public void setIndent( int newLevel ) {
    indentLevel = newLevel;
    if( indentLevel < 0 )
      indentLevel = 0;
    updateCurrentIndentString();
  }

  public int getIndent() {
    return indentLevel;
  }

  synchronized
  private void updateCurrentIndentString() {
    StringBuilder builder = new StringBuilder("");
    for( int i=0; i < indentLevel; i++ ) {
      builder.append( indentString );
    }
    currentIndentString = builder.toString();
  }


  public DefaultAtgLogHelper( ApplicationLogging logger ) {
    this.logger = logger;
  }

  public boolean isLoggingDebug() {
    return logger != null && logger.isLoggingDebug();
  }

  public boolean isLoggingInfo() {
    return logger != null && logger.isLoggingInfo();
  }

  public boolean isLoggingWarning() {
    return logger != null && logger.isLoggingWarning();
  }

  public boolean isLoggingError() {
    return logger != null && logger.isLoggingError();
  }

  /**
   * Log a debug message into the ATG log stream
   *
   * @param message Message to log
   */
  public void debug(String message) {
    debugInternal(message, false);
  }

  /**
   * Log a debug message into the ATG log stream
   *
   * @param e Exception to log a trace for
   */
  public void debug(Throwable e) {
    debugInternal(e, false);
  }

  /**
   * Log a debug message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   */
  public void debug(String message, Throwable e) {
    debugInternal(message, e, false);
  }

  /**
   * Log a debug message into the ATG log stream
   *
   * @param message Message to log
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void debug(String message, boolean force) {
    debugInternal(message, force);
  }

  /**
   * Log a debug message into the ATG log stream
   *
   * @param e     Exception to log a trace for
   * @param force Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void debug(Throwable e, boolean force) {
    debugInternal(e, force);
  }

  /**
   * Log a debug message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void debug(String message, Throwable e, boolean force) {
    debugInternal(message, e, force);
  }

  /**
   * Log an info message into the ATG log stream
   *
   * @param message Message to log
   */
  public void info(String message) {
    infoInternal(message, false);
  }

  /**
   * Log an info message into the ATG log stream
   *
   * @param e Exception to log a trace for
   */
  public void info(Throwable e) {
    infoInternal(e, false);
  }

  /**
   * Log an info message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   */
  public void info(String message, Throwable e) {
    infoInternal(message, e, false);
  }

  /**
   * Log an info message into the ATG log stream
   *
   * @param message Message to log
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void info(String message, boolean force) {
    infoInternal(message, force);
  }

  /**
   * Log an info message into the ATG log stream
   *
   * @param e     Exception to log a trace for
   * @param force Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void info(Throwable e, boolean force) {
    infoInternal(e, force);
  }

  /**
   * Log an info message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void info(String message, Throwable e, boolean force) {
    infoInternal(message, e, force);
  }

  /**
   * Log a warning message into the ATG log stream
   *
   * @param message Message to log
   */
  public void warning(String message) {
    warningInternal(message, false);
  }

  /**
   * Log a warning message into the ATG log stream
   *
   * @param e Exception to log a trace for
   */
  public void warning(Throwable e) {
    warningInternal(e, false);
  }

  /**
   * Log a warning message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   */
  public void warning(String message, Throwable e) {
    warningInternal(message, e, false);
  }

  /**
   * Log a warning message into the ATG log stream
   *
   * @param message Message to log
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void warning(String message, boolean force) {
    warningInternal(message, force);
  }

  /**
   * Log a warning message into the ATG log stream
   *
   * @param e     Exception to log a trace for
   * @param force Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void warning(Throwable e, boolean force) {
    warningInternal(e, force);
  }

  /**
   * Log a warning message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void warning(String message, Throwable e, boolean force) {
    warningInternal(message, e, force);
  }

  /**
   * Log an error message into the ATG log stream
   *
   * @param message Message to log
   */
  public void error(String message) {
    errorInternal(message, false);
  }

  /**
   * Log an error message into the ATG log stream
   *
   * @param e Exception to log a trace for
   */
  public void error(Throwable e) {
    errorInternal(e, false);
  }

  /**
   * Log an error message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   */
  public void error(String message, Throwable e) {
    errorInternal(message, e, false);
  }

  /**
   * Log an error message into the ATG log stream
   *
   * @param message Message to log
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void error(String message, boolean force) {
    errorInternal(message, force);
  }

  /**
   * Log an error message into the ATG log stream
   *
   * @param e     Exception to log a trace for
   * @param force Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void error(Throwable e, boolean force) {
    errorInternal(e, force);
  }

  /**
   * Log an error message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void error(String message, Throwable e, boolean force) {
    errorInternal(message, e, force);
  }

  ///////////////////////////////////////////////////////////////////
  //////////////////////// DEBUG INTERNAL

  synchronized
  protected void debugInternal(String message, boolean force) {
    if (logger.isLoggingDebug() || force) {
      logger.logDebug(currentIndentString+message);
    }
  }

  synchronized
  protected void debugInternal(String message, Throwable e, boolean force) {
    if (logger.isLoggingDebug() || force) {
      logger.logDebug(currentIndentString+message, e);
    }
  }

  synchronized
  protected void debugInternal(Throwable e, boolean force) {
    if (logger.isLoggingDebug() || force) {
      logger.logDebug(e);
    }
  }


  ///////////////////////////////////////////////////////////////////
  //////////////////////// INFO INTERNAL

  synchronized
  protected void infoInternal(String message, boolean force) {
    if (logger.isLoggingInfo() || force) {
      logger.logInfo(currentIndentString+message);
    }
  }

  synchronized
  protected void infoInternal(String message, Throwable e, boolean force) {
    if (logger.isLoggingInfo() || force) {
      logger.logInfo(currentIndentString+message, e);
    }
  }

  synchronized
  protected void infoInternal(Throwable e, boolean force) {
    if (logger.isLoggingInfo() || force) {
      logger.logInfo(e);
    }
  }

  ///////////////////////////////////////////////////////////////////
  //////////////////////// WARNING INTERNAL

  synchronized
  protected void warningInternal(String message, boolean force) {
    if (logger.isLoggingWarning() || force) {
      logger.logWarning(currentIndentString+message);
    }
  }

  synchronized
  protected void warningInternal(String message, Throwable e, boolean force) {
    if (logger.isLoggingWarning() || force) {
      logger.logWarning(currentIndentString+message, e);
    }
  }

  synchronized
  protected void warningInternal(Throwable e, boolean force) {
    if (logger.isLoggingWarning() || force) {
      logger.logWarning(e);
    }
  }

  ///////////////////////////////////////////////////////////////////
  //////////////////////// ERROR INTERNAL

  synchronized
  protected void errorInternal(String message, boolean force) {
    if (logger.isLoggingError() || force) {
      logger.logError(currentIndentString+message);
    }
  }

  synchronized
  protected void errorInternal(String message, Throwable e, boolean force) {
    if (logger.isLoggingError() || force) {
      logger.logError(currentIndentString+message, e);
    }
  }

  synchronized
  protected void errorInternal(Throwable e, boolean force) {
    if (logger.isLoggingError() || force) {
      logger.logError(e);
    }
  }
}


