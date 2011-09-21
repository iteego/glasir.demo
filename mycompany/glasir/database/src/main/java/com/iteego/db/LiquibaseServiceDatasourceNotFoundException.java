/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db;

public class LiquibaseServiceDatasourceNotFoundException extends LiquibaseServiceException {
  private String jndiName;

  public LiquibaseServiceDatasourceNotFoundException(String message, String jndiName) {
    super(message);
    this.jndiName = jndiName;
  }

  public String toString() {
    return "JNDI lookup failed: JNDI name \""+ jndiName + "\" not found. " + getMessage();
  }
}
