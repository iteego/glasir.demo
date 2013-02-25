package com.iteego.db


class ImportAndModule {
  /**
   * The XML node.
   */
  groovy.util.Node node

  /**
   * The module in where the dbinit.xml file is (the file that defines the imports). We need this to resolve paths.
   */
  com.iteego.glasir.build.api.AtgModule definingModule
}


