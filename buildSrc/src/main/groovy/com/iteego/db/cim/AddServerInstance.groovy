package com.iteego.db.cim

class AddServerInstance extends Modification {
  String addedServerInstanceId

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Add Server Instance: $addedServerInstanceId\n" )
  }
}