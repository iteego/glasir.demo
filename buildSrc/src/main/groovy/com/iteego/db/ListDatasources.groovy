package com.iteego.db

import com.iteego.db.cim.*
import org.gradle.api.tasks.TaskAction
import org.gradle.api.DefaultTask
import groovy.xml.MarkupBuilder
import org.gradle.api.logging.LogLevel
import com.iteego.glasir.build.api.AtgModule


public class ListDatasources extends DefaultTask {
  def mainModuleName = "env.Main.store.dev.oracle"

  def selectedProducts = [
      //"commerce"
      //"endeca",
      "platform",
      //"siteadmin",
      "store"
  ]

  def selectedAddons = [
      "dcs-csr",
      "international",
      "merch",
      "previewOnManagement",
      "prodLock",
      "queryConsoleOnManagement",
      "storefront-full-setup",
      //"storefront_no_publishing",
      "switchingdatasource"
    ]

  def glasir = project.glasir
  def fullModuleList = glasir.moduleMap[mainModuleName].fullBuildOrder

  /**
   * Use empty 'selectedProducts' list to include all products.
   * Use empty 'selectedAddons' list to include all addons.
   */
  @TaskAction
  public void run() {
    logger.info "List Data Sources."
    logger.info "  main module:     $mainModuleName"
    logger.info "  selected addons: $selectedAddons"
    def files = CreateChangesets.findProductXmlFiles( glasir.project, glasir.modules )
    def nodes = CreateChangesets.loadXmlFromProductFiles( glasir.project, files )
    def products = CreateChangesets.scanProductValues( glasir.project, nodes )

    Map<String,List<ServerInstanceModification>> instanceModifications = [:]
    Map<String,List<InstanceTypeModification>> instanceTypeModifications = [:]


    products.each { product ->      
      if( !selectedProducts || selectedProducts.contains( product.id ) ) {
        println "Include product: ${product.id}"

        // check addons
        product.productAddonGroups.each { addonGroup ->
          addonGroup.addons.each { addon ->
            addon.each {
              logger.info( "product ${product.id}, addonGroup: ${addonGroup.id}, addon: ${addon.id}" )
              if( !selectedAddons || selectedAddons.contains( addon.id ) ) {
                addon.instanceModifications.each { im ->
                  def key = im.modifiedId
                  if( !instanceModifications.containsKey(key) ) instanceModifications[key] = new ArrayList<ServerInstanceModification>()
                  instanceModifications[key].add( im )
                }

                addon.instanceTypeModifications.each { itm ->
                  def key = itm.modifiedId
                  if( !instanceTypeModifications.containsKey(key) ) instanceTypeModifications[key] = new ArrayList<InstanceTypeModification>()
                  instanceTypeModifications[key].add( itm )
                }
              }
            }
          }
        }

        // check combinations
        product.productAddonCombos.each { combo ->
          if( selectedAddons && (combo.addonCombinations.any{ !selectedAddons.contains(it) }) ) {
            // Skip it if any of the addons in the combination is not in the list of selected addons.
            logger.debug "Skip addon combination '${combo.id}', missing some addons."
          } else {
            logger.debug "Using addon combination '${combo.id}'."
            combo.instanceTypeModifications.each { itm ->
              def key = itm.modifiedId
              if( !instanceTypeModifications.containsKey(key) ) instanceTypeModifications[key] = new ArrayList<InstanceTypeModification>()
              instanceTypeModifications[key].add( itm )
            }
            //instanceTypeModifications.addAll combo.instanceTypeModifications
            //combo.instanceTypeModifications.each { instanceTypeModifications.addAll( it.modifications ) }
          }
        }
      } else {
        println "Skip product: ${product.id}"
      }
    }

    println ""
    println "Server Instance Modifications (${instanceModifications.size()}) -----------------------"
    instanceTypeModifications.each { key, list ->
      println " Instance: '$key'"
      def shownMod = []
      list.each { mod ->
        shownMod.addAll( mod.modifications.findAll { m -> m instanceof AddNamedDatasource || m instanceof RemoveNamedDatasource } )
      }
      if( shownMod ) {
        println "  Data Source Modifications: "
        println "  $shownMod"
      }
    }

    println ""
    println "Server Instance Type Modifications (${instanceTypeModifications.size()}) -----------------------"
    instanceTypeModifications.each { key, list ->
      println " Instance Type: '$key'"
      def shownMod = []
      list.each { mod ->
        shownMod.addAll( mod.modifications.findAll { m -> m instanceof AddNamedDatasource || m instanceof RemoveNamedDatasource } )
      }
      if( shownMod ) {
        println "  Data Source Modifications: "
        println "  $shownMod"
      }
    }


  }
}


