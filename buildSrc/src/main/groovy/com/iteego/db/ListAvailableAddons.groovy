package com.iteego.db

import com.iteego.db.cim.*
import org.gradle.api.tasks.TaskAction
import org.gradle.api.DefaultTask
import groovy.xml.MarkupBuilder
import org.gradle.api.logging.LogLevel
import com.iteego.glasir.build.api.AtgModule


public class ListAvailableAddons extends DefaultTask {
  def glasir = project.glasir

  @TaskAction
  public void run() {
    def files = CreateChangesets.findProductXmlFiles( glasir.project, glasir.modules )
    def nodes = CreateChangesets.loadXmlFromProductFiles( glasir.project, files )
    def products = CreateChangesets.scanProductValues( glasir.project, nodes )

    println "product, addon-groups, addons"
    println ""
    products.each { product ->
      println "Product: ${product.id}"
      product.productAddonGroups.each { addonGroup ->
        println "  Addon-group: ${addonGroup.id}"
        addonGroup.addons.each { addon ->
          println "    Addon: ${addon.id}"
        }
      }
      println ""
    }
  }
}

