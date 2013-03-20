package com.iteego.db.cim

class RemoveServerInstance extends Modification {
  String removedServerInstanceId

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Remove Server Instance: $removedServerInstanceId\n" )
  }
}
