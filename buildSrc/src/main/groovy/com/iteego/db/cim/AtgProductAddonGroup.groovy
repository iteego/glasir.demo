package com.iteego.db.cim

class AtgProductAddonGroup extends AtgXmlBase {
  String id
  String title
  List<String> requiredAddonIds = new ArrayList<String>()
  List<String> requiredProductIds = new ArrayList<String>()
  List<AtgProductAddon> addons = new ArrayList<AtgProductAddon>()

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Product Addon Group: \"$id\"\n" )
    if( title )
      writer.write( "${i}  Title             : $title\n" )
    if(requiredProductIds)
      writer.write( "${i}  Required products : $requiredProductIds\n" )
    if(requiredAddonIds)
      writer.write( "${i}  Required addons   : $requiredAddonIds\n" )
    if(addons) {
      writer.write( "${i}  Product Addons\n" )
      addons.each { it.print( writer, indentationLevel+4 ) }
    }
  }

  @Override public AtgXmlInterface parse( Node node ) {
    this.id = node.@id
    node.children().each { Node child ->
      switch( child.name().toLowerCase() ) {
        case "product-addon":
          addons.add( new AtgProductAddon().parse( child ) as AtgProductAddon )
          break
        case "product-id-required":
          requiredProductIds.add( child.@id )
          break
        case "requires-product-addon":
          requiredAddonIds.add( child.@id )
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
