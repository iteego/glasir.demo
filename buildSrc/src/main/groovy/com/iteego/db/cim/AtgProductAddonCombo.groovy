package com.iteego.db.cim

class AtgProductAddonCombo extends AtgXmlBase {
  String id
  List<String> addonCombinations = new ArrayList<String>()
  List<ModificationList> instanceTypeModifications = new ArrayList<ModificationList>()

  @Override public AtgXmlInterface parse( Node node ) {
    this.id = node.@id
    node.children().each { Node child ->
      switch( child.name().toLowerCase() ) {
        case "modify-server-instance-type":
          instanceTypeModifications.add( new InstanceTypeModification().parse( child ) as ModificationList )
          break
        case "combo-product-addon":
          addonCombinations.add( child.@id )
          break
        default :
          throw new Exception( "Unknown node: ${child.name()}" )
      }
    }
    return this
  }

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}Product Addon Combo: \"$id\"\n" )
    if( addonCombinations )
      writer.write( "${i}  Combination : ${addonCombinations}\n" )
    if( instanceTypeModifications ) {
      writer.write( "${i}  Instance Type Modifications :\n" )
      instanceTypeModifications.each { it.print( writer, indentationLevel+4 ) }
    }
  }

}
