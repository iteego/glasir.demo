package com.iteego.db.cim

class AtgProduct extends AtgXmlBase {
  String id
  String title
  String detail
  List<String> incompatibleAddons = new ArrayList<String>()
  List<String> requiredAddons = new ArrayList<String>()
  List<String> requiredProducts = new ArrayList<String>()
  List<String> incompatibleProducts = new ArrayList<String>()
  List<AddNamedDatasource> namedDatasources = new ArrayList<AddNamedDatasource>()
  List<AtgProductAddonGroup> productAddonGroups = new ArrayList<AtgProductAddonGroup>()
  List<AtgProductAddonCombo> productAddonCombos = new ArrayList<AtgProductAddonCombo>()
  List<AtgServerInstance> serverInstances = new ArrayList<AtgServerInstance>()
  List<AtgServerInstanceType> serverInstanceTypes = new ArrayList<AtgServerInstanceType>()

  @Override public void print( java.io.Writer writer, int indentationLevel ) {
    def i = " " * indentationLevel
    writer.write( "${i}PRODUCT: \"$id\"\n" )
    if( title )
      writer.write( "${i}  Title                : $title\n" )
    if( detail )
      writer.write( "${i}  Detail               : $detail\n" )
    if( requiredProducts )
      writer.write( "${i}  Required products    : $requiredProducts\n" )
    if( incompatibleProducts)
      writer.write( "${i}  Incompatible products: $incompatibleProducts\n" )
    if( requiredAddons )
      writer.write( "${i}  Required addons      : $requiredAddons\n" )
    if( incompatibleAddons )
      writer.write( "${i}  Incompatible addons  : $incompatibleAddons\n" )
    if( namedDatasources )
      writer.write( "${i}  Data Sources         : ${namedDatasources.collect {it.addedDatasourceId}.join(", ")}\n" )
    if( productAddonGroups ) {
      writer.write( "${i}  Addon Groups\n" )
      productAddonGroups.each { it.print( writer, indentationLevel+4 ) }
    }
    if( productAddonCombos ) {
      writer.write( "${i}  Addon Combos\n" )
      productAddonCombos.each { it.print( writer, indentationLevel+4 ) }
    }
  }


  @Override public AtgXmlInterface parse( Node product ) {
    this.id = product.@id
    product.children().each { Node child ->
      switch( child.name().toLowerCase() ) {
        case "detail":
          detail = child.text()
          break
        case "named-datasource":
          namedDatasources.add( new AddNamedDatasource( addedDatasourceId: child.@id ) )
          break
        case "product-addon-combo":
          productAddonCombos.add( new AtgProductAddonCombo().parse( child ) as AtgProductAddonCombo )
          break
        case "product-addon-group":
          productAddonGroups.add( new AtgProductAddonGroup().parse( child ) as AtgProductAddonGroup )
          break
        case "product-id-required":
          requiredProducts.add( child.@id )
          break
        case "incompatible-product-id":
          incompatibleProducts.add( child.@id )
          break
        case "incompatible-addon-id":
          incompatibleAddons.add( child.@id )
          break
        case "requires-addon-id":
          requiredAddons.add( child.@id )
          break
        case "server-instance":
          serverInstances.add( new AtgServerInstance().parse( child ) as AtgServerInstance )
          break
        case "server-instance-type":
          serverInstanceTypes.add( new AtgServerInstanceType().parse( child ) as AtgServerInstanceType )
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
