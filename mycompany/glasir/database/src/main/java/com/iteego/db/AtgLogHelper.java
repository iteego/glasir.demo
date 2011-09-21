/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db;

/**
 * Interface to facilitate logging in both test and production.
 */
public interface AtgLogHelper {
  public void increaseIndent();
  public void decreaseIndent();
  public void setIndent( int newLevel );
  public int getIndent();

  public boolean isLoggingDebug();

  public boolean isLoggingInfo();

  public boolean isLoggingWarning();

  public boolean isLoggingError();

  /**
   * Log a debug message into the ATG log stream
   *
   * @param message Message to log
   */
  public void debug(String message);

  /**
   * Log a debug message into the ATG log stream
   *
   * @param e Exception to log a trace for
   */
  public void debug(Throwable e);

  /**
   * Log a debug message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   */
  public void debug(String message, Throwable e);

  /**
   * Log a debug message into the ATG log stream
   *
   * @param message Message to log
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void debug(String message, boolean force);

  /**
   * Log a debug message into the ATG log stream
   *
   * @param e     Exception to log a trace for
   * @param force Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void debug(Throwable e, boolean force);

  /**
   * Log a debug message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void debug(String message, Throwable e, boolean force);

  /**
   * Log an info message into the ATG log stream
   *
   * @param message Message to log
   */
  public void info(String message);

  /**
   * Log an info message into the ATG log stream
   *
   * @param e Exception to log a trace for
   */
  public void info(Throwable e) ;

  /**
   * Log an info message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   */
  public void info(String message, Throwable e);

  /**
   * Log an info message into the ATG log stream
   *
   * @param message Message to log
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void info(String message, boolean force);

  /**
   * Log an info message into the ATG log stream
   *
   * @param e     Exception to log a trace for
   * @param force Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void info(Throwable e, boolean force);

  /**
   * Log an info message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void info(String message, Throwable e, boolean force);

  /**
   * Log a warning message into the ATG log stream
   *
   * @param message Message to log
   */
  public void warning(String message);

  /**
   * Log a warning message into the ATG log stream
   *
   * @param e Exception to log a trace for
   */
  public void warning(Throwable e) ;

  /**
   * Log a warning message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   */
  public void warning(String message, Throwable e);

  /**
   * Log a warning message into the ATG log stream
   *
   * @param message Message to log
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void warning(String message, boolean force);

  /**
   * Log a warning message into the ATG log stream
   *
   * @param e     Exception to log a trace for
   * @param force Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void warning(Throwable e, boolean force);

  /**
   * Log a warning message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void warning(String message, Throwable e, boolean force);

  /**
   * Log an error message into the ATG log stream
   *
   * @param message Message to log
   */
  public void error(String message);

  /**
   * Log an error message into the ATG log stream
   *
   * @param e Exception to log a trace for
   */
  public void error(Throwable e);

  /**
   * Log an error message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   */
  public void error(String message, Throwable e);

  /**
   * Log an error message into the ATG log stream
   *
   * @param message Message to log
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void error(String message, boolean force);

  /**
   * Log an error message into the ATG log stream
   *
   * @param e     Exception to log a trace for
   * @param force Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void error(Throwable e, boolean force);

  /**
   * Log an error message into the ATG log stream
   *
   * @param message Message to log
   * @param e       Exception to log a trace for
   * @param force   Boolean indicating if we should force logging independent of the log levels set to for the parent component
   */
  public void error(String message, Throwable e, boolean force);


}
