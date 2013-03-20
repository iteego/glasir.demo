package com.iteego.db.cim

class AtgProductAddon extends AtgXmlBase {
  String id
  String title
  String detail
  List<ModificationList> instanceTypeModifications = new ArrayList<ModificationList>()
  List<ModificationList> instanceModifications = new ArrayList<ModificationList>()

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Product Addon: $id\n" )
    if( title ) writer.write( "${i}  Title  : $title\n" )
    if( detail ) writer.write( "${i}  Detail : $detail\n" )
    if( instanceTypeModifications ) {
      writer.write( "${i}  Instance Type Modifications : \n" )
      instanceTypeModifications.each { it.print( writer, indentationLevel+4 ) }
    }
  }


  @Override public AtgXmlInterface parse( Node node ) {
    this.id = node.@id
    node.children().each { Node child ->
      switch( child.name().toLowerCase() ) {
        case "detail":
          detail = child.text()
          break
        case "modify-server-instance-type":
          instanceTypeModifications.add( new InstanceTypeModification().parse( child ) as ModificationList )
          break
        case "modify-server-instance":
          instanceModifications.add( new ServerInstanceModification().parse( child ) as ModificationList )
          break
        case "title":
          title = child.text()
          break
        default :
          throw new Exception( "Unknown node: ${child.name()}" )
      }
    }
    return this
  }
}
