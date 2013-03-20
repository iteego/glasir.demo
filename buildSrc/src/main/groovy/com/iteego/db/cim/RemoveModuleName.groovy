package com.iteego.db.cim

class RemoveModuleName extends Modification {
  String removedModuleName

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Remove Module Name: $removedModuleName\n" )
  }
}
