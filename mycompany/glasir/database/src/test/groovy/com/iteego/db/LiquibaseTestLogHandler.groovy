/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

/**
 * Print to stdout.
 */
public class LiquibaseTestLogHandler extends LiquibaseLogHandler {

  public LiquibaseTestLogHandler() {
    name = "test-log"
  }

  public int getPriority() {
    // This is the priority used by Liquibase to determine which liquibase.logging.Logger will be used.
    return Integer.MAX_VALUE - 1 // In case we want to push another logger.
  }

}

