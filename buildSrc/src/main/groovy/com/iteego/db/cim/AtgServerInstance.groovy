package com.iteego.db.cim

class AtgServerInstance extends AtgXmlBase {
  String id
  String type
  String title
  String detail
  String earFileName
  String serverInstanceName
  List<Modification> modifications = new ArrayList<Modification>()

  @Override public AtgXmlInterface parse( Node node ) {
    this.id = node.@id
    this.type = node.@type
    node.children().each { Node child ->
      switch( child.name().toLowerCase() ) {
        case "config-directory":
          // ignored
          break
        case "optional-config-directory":
          // ignored
          break
        case "detail":
          detail = child.text()
          break
        case "ear-file-name":
          earFileName = child.text()
          break
        case "server-instance-name":
          serverInstanceName = child.text()
          break
        case "title":
          title = child.text()
          break
        case "append-module":
          modifications.add( new AppendModuleName( appendedModuleName: child.@'name' as String ) )
          break
        case "add-named-datasource":
          modifications.add( new AddNamedDatasource( addedDatasourceId: child.@id ) )
          break
        case "post-deployment-option":
          //ignored
          break
        default :
          throw new Exception( "Unknown node: ${child.name()}" )
      }
    }
    return this
  }
}
