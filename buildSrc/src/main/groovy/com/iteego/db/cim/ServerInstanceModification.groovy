package com.iteego.db.cim

class ServerInstanceModification extends ModificationList {
  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Modifications (instance \"$modifiedId\"):\n" )
    modifications.each { mod ->
      mod.print( writer, indentationLevel + 4 )
    }
  }
}
