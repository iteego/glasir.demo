package com.iteego.db

import com.iteego.db.cim.*
import org.gradle.api.tasks.TaskAction
import org.gradle.api.DefaultTask
import groovy.xml.MarkupBuilder
import org.gradle.api.logging.LogLevel
import com.iteego.glasir.build.api.AtgModule



public class ListAvailableProducts extends DefaultTask {
  def glasir = project.glasir
  boolean full = false

  @TaskAction
  public void run() {
    def files = CreateChangesets.findProductXmlFiles( glasir.project, glasir.modules )
    def nodes = CreateChangesets.loadXmlFromProductFiles( glasir.project, files )
    def products = CreateChangesets.scanProductValues( glasir.project, nodes )

    if( full ) {
      products.each { product ->
        StringWriter w = new StringWriter()
        product.print( w, 0 )
        println "************************************************"
        println w.toString()
        println ""
      }
    } else {
      println "Products:\n${products.collect { p -> "${p.id} (AddonGroups: [${p.productAddonGroups.collect {it.id}.join(', ')}])"}.join('\n') }"
    }
  }
}
