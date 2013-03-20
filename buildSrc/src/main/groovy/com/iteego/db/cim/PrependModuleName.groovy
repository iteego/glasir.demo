package com.iteego.db.cim

class PrependModuleName extends Modification {
  String prependedModuleName

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Prepend Module Name: $prependedModuleName\n" )
  }
}
