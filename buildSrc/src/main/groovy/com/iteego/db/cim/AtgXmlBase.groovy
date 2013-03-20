package com.iteego.db.cim

class AtgXmlBase implements AtgXmlInterface {
  public AtgXmlInterface parse( Node node ) {
    throw new Exception( "Please implement parse for class ${this.class.name}" )
  }

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    writer.write( " " * indentationLevel + this.class.simpleName + "\n" )
  }

  @Override public String toString() {
    StringWriter w = new StringWriter()
    print( w, 2 )
    return w.toString()
  }
}
