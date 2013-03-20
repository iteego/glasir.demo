package com.iteego.db.cim

class ModificationList extends AtgXmlBase {
  /**
   * "Server Instance Id" or "Service Instance Type Id"
   */
  String modifiedId

  List< Modification > modifications = new ArrayList< Modification >()

  @Override public AtgXmlInterface parse( Node node ) {
    modifiedId = node.@id
    node.children().each { Node child ->
      switch( child.name().toLowerCase() ) {
        case "add-server-instance":
          modifications.add new AddServerInstance( addedServerInstanceId: child.@id )
          break
        case "remove-server-instance":
          modifications.add new RemoveServerInstance( removedServerInstanceId: child.@id )
          break
        case "add-named-datasource":
          modifications.add new AddNamedDatasource( addedDatasourceId: child.@id )
          break
        case "remove-named-datasource":
          modifications.add new RemoveNamedDatasource( removedDatasourceId: child.@id )
          break
        case "append-module":
          modifications.add new AppendModuleName( appendedModuleName: child.@name )
          break
        case "prepend-module":
          modifications.add new PrependModuleName( prependedModuleName: child.@name )
          break
        case "remove-module":
          modifications.add new RemoveModuleName( removedModuleName: child.@name )
          break
        case "add-appassembler-option":
          // ignore
          break
        default :
          throw new Exception( "Unknown node: '${child.name()}' parsing node '$node'" )
      }
    }
    return this
  }

}
