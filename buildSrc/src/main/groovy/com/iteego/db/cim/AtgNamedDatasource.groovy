package com.iteego.db.cim

class AtgNamedDatasource extends AtgXmlBase {
  String id
  String title
  String jndi

  @Override
  public AtgXmlInterface parse( Node node ) {
    this.id = node.@id
    this.title = node.title?.text()
    this.jndi = node.jndi?.text()
    return this
  }
}
