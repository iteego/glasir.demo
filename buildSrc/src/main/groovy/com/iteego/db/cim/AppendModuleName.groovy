package com.iteego.db.cim

class AppendModuleName extends Modification {
  String appendedModuleName

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Append Module Name: $appendedModuleName\n" )
  }
}
