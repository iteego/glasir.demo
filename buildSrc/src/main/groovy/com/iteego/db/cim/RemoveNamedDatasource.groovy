package com.iteego.db.cim

class RemoveNamedDatasource extends Modification {
  String removedDatasourceId

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Remove Named Data Source: $removedDatasourceId\n" )
  }
}
