package com.iteego.db.cim

class AddNamedDatasource extends Modification {
  String addedDatasourceId

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Add Named Data Source: $addedDatasourceId\n" )
  }
}
