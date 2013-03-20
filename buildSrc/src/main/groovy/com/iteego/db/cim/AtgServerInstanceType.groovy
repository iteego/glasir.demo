package com.iteego.db.cim

class AtgServerInstanceType extends AtgXmlBase {
  String id
  String detail
  String title
  String extendsInstanceType
  List<Modification> modifications = new ArrayList<Modification>()
  List<String> serverInstances = new ArrayList<String>()

  @Override public AtgXmlInterface parse( Node node ) {
    this.id = node.@id
    node.children().each { Node child ->
      switch( child.name().toLowerCase() ) {
        case "detail":
          detail = child.text()
          break
        case "add-server-instance":
          serverInstances.add( child.@id )
          break
        case "append-module":
          modifications.add( new AppendModuleName( appendedModuleName: child.@'name' as String ) )
          break
        case "add-named-datasource":
          modifications.add( new AddNamedDatasource( addedDatasourceId: child.@id ) )
          break
        case "config-directory":
          // todo: handle this
          break
        case "optional-config-directory":
          // todo: handle or ignore
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
