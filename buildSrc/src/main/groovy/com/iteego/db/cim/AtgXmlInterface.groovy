package com.iteego.db.cim

interface AtgXmlInterface {
  AtgXmlInterface parse( groovy.util.Node node )
  void print( java.io.Writer writer, int indentationLevel )
}
