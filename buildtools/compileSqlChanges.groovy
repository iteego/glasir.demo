
//------------------------------------------------------------------
// These sql files are valid for product selection: 
//  "atg b2c commerce", no commerce addons, switching datasource
//------------------------------------------------------------------

File abd = new File("/work/atg/atg1002")
pub( abd )
core( abd )
cat( abd )


/*
//------------------------------------------------------------------
For pub, also do the following data imports:
//------------------------------------------------------------------
1 Data Import: Repository:/atg/userprofiling/InternalProfileRepository Path:/Publishing/base/install/epub-role-data.xml Module:DSS.InternalUsers 
2 Data Import: Repository:/atg/epub/file/PublishingFileRepository Path:/Publishing/base/install/epub-file-repository-data.xml Module:Publishing.base 
3 Repository Loader: Files: DSS/atg/registry/data/scenarios/DSS/*.sdl & DSS/atg/registry/data/scenarios/recorders/*.sdl
4 Data Import: Repository:/atg/userprofiling/PersonalizationRepository Path:/DCS/install/data/initial-segment-lists.xml Module:DPS.Versioned 
5 Data Import: Repository:/atg/web/viewmapping/ViewMappingRepository Path:/BCC/install/data/viewmapping.xml Module:BCC 
6 Data Import: Repository:/atg/portal/framework/PortalRepository Path:/BIZUI/install/data/portal.xml Module:BIZUI 
7 Data Import: Repository:/atg/userprofiling/InternalProfileRepository Path:/BIZUI/install/data/profile.xml Module:BIZUI 
8 Data Import: Repository:/atg/web/viewmapping/ViewMappingRepository Path:/BIZUI/install/data/viewmapping.xml Module:BIZUI 
9 Data Import: Repository:/atg/web/viewmapping/ViewMappingRepository Path:/AssetUI/install/data/viewmapping.xml Module:AssetUI 
10 Data Import: Repository:/atg/web/viewmapping/ViewMappingRepository Path:/AssetUI/install/data/assetManagerViews.xml Module:AssetUI 
11 Data Import: Repository:/atg/web/viewmapping/ViewMappingRepository Path:/DPS-UI/install/data/viewmapping.xml Module:DPS-UI 
12 Data Import: Repository:/atg/web/viewmapping/ViewMappingRepository Path:/DPS-UI/install/data/examples.xml Module:DPS-UI 
*/

public appendFiles( java.util.List<String> requiredSqlFiles, File atgBaseDir, String outputFileName ) {
	StringBuilder data = new StringBuilder()
	File output = new File( outputFileName )
	requiredSqlFiles.each { String filename ->
		File input = new File( atgBaseDir, filename )
		data.append( "\n-- Source file for the following SQL is $filename\n" )
		data.append( input.text )
	}
	output.text = data.toString()
	println "All done."
}

public void cat( File atgBaseDir ) {
	def requiredSqlFiles = [
	"DAS/sql/db_components/mysql/id_generator.sql",
        "DAS/sql/db_components/mysql/dms_limbo_ddl.sql",
        "DAS/sql/db_components/mysql/seo_ddl.sql",
        "DAS/sql/db_components/mysql/site_ddl.sql",
        "DPS/sql/db_components/mysql/user_ddl.sql",
        "DPS/sql/db_components/mysql/logging_ddl.sql",
        "DPS/sql/db_components/mysql/logging_init.sql",
        "DPS/sql/db_components/mysql/personalization_ddl.sql",
        "DCS/sql/db_components/mysql/priceLists_ddl.sql",
        "DCS/sql/db_components/mysql/product_catalog_ddl.sql",
        "DCS/sql/db_components/mysql/custom_catalog_ddl.sql",
        "DCS/sql/db_components/mysql/promotion_ddl.sql",
        "DCS/sql/db_components/mysql/commerce_site_ddl.sql" ]

	appendFiles( requiredSqlFiles, atgBaseDir, "cata.sql" )
	appendFiles( requiredSqlFiles, atgBaseDir, "catb.sql" )
}

public void core( File atgBaseDir ) {
	def requiredSqlFiles = [
	"DAS/sql/db_components/mysql/id_generator.sql",
        "DAS/sql/db_components/mysql/dms_limbo_ddl.sql",
        "DAS/sql/db_components/mysql/cluster_name_ddl.sql",
        "DAS/sql/db_components/mysql/create_sql_jms_ddl.sql",
        "DAS/sql/db_components/mysql/create_staff_ddl.sql",
        "DAS/sql/db_components/mysql/create_gsa_subscribers_ddl.sql",
        "DAS/sql/db_components/mysql/create_sds.sql",
        "DAS/sql/db_components/mysql/integration_data_ddl.sql",
        "DAS/sql/db_components/mysql/nucleus_security_ddl.sql",
        "DAS/sql/db_components/mysql/media_ddl.sql",
        "DAS/sql/db_components/mysql/deployment_ddl.sql",
        "DAS/sql/db_components/mysql/sitemap_ddl.sql",
        "DPS/sql/db_components/mysql/user_ddl.sql",
        "DPS/sql/db_components/mysql/logging_ddl.sql",
        "DPS/sql/db_components/mysql/logging_init.sql",
        "DPS/sql/db_components/mysql/personalization_ddl.sql",
        "DSS/sql/db_components/mysql/business_process_rpt_ddl.sql",
        "DSS/sql/db_components/mysql/das_mappers.sql",
        "DSS/sql/db_components/mysql/dps_mappers.sql",
        "DSS/sql/db_components/mysql/dss_mappers.sql",
        "DSS/sql/db_components/mysql/markers_ddl.sql",
        "DSS/sql/db_components/mysql/profile_bp_markers_ddl.sql",
        "DSS/sql/db_components/mysql/scenario_ddl.sql",
        "DCS/sql/db_components/mysql/claimable_ddl.sql",
        "DCS/sql/db_components/mysql/commerce_user.sql",
        "DCS/sql/db_components/mysql/custom_catalog_user_ddl.sql",
        "DCS/sql/db_components/mysql/dcs_mappers.sql",
        "DCS/sql/db_components/mysql/inventory_ddl.sql",
        "DCS/sql/db_components/mysql/order_ddl.sql",
        "DCS/sql/db_components/mysql/order_markers_ddl.sql",
        "DCS/sql/db_components/mysql/user_giftlist_ddl.sql",
        "DCS/sql/db_components/mysql/user_promotion_ddl.sql" ]
	
	appendFiles( requiredSqlFiles, atgBaseDir, "core.sql" )
}

public void pub( File atgBaseDir ) {
	def requiredSqlFiles = [
    "DAS/sql/db_components/mysql/id_generator.sql",
    "DAS/sql/db_components/mysql/dms_limbo_ddl.sql",
    "DAS/sql/db_components/mysql/cluster_name_ddl.sql",
    "DAS/sql/db_components/mysql/create_sql_jms_ddl.sql",
    "DAS/sql/db_components/mysql/create_staff_ddl.sql",
    "DAS/sql/db_components/mysql/create_gsa_subscribers_ddl.sql",
    "DAS/sql/db_components/mysql/create_sds.sql",
    "DAS/sql/db_components/mysql/integration_data_ddl.sql",
    "DAS/sql/db_components/mysql/nucleus_security_ddl.sql",
    "DAS/sql/db_components/mysql/media_ddl.sql",
    "DAS/sql/db_components/mysql/deployment_ddl.sql",
    "DAS/sql/db_components/mysql/sitemap_ddl.sql",
    "DPS/sql/db_components/mysql/user_ddl.sql",
    "DPS/sql/db_components/mysql/logging_ddl.sql",
    "DPS/sql/db_components/mysql/logging_init.sql",
    "DPS/InternalUsers/sql/db_components/mysql/internal_user_ddl.sql",
    "DSS/sql/db_components/mysql/business_process_rpt_ddl.sql",
    "DSS/sql/db_components/mysql/das_mappers.sql",
    "DSS/sql/db_components/mysql/dps_mappers.sql",
    "DSS/sql/db_components/mysql/dss_mappers.sql",
    "DSS/sql/db_components/mysql/markers_ddl.sql",
    "DSS/sql/db_components/mysql/profile_bp_markers_ddl.sql",
    "DSS/sql/db_components/mysql/scenario_ddl.sql",
    "Portal/paf/sql/install/mysql/alert_ddl.sql",
    "Portal/paf/sql/install/mysql/membership_ddl.sql",
    "Portal/paf/sql/install/mysql/paf_mappers_ddl.sql",
    "Portal/paf/sql/install/mysql/portal_ddl.sql",
    "DCS/sql/db_components/mysql/commerce_user.sql",
    "DCS/sql/db_components/mysql/custom_catalog_user_ddl.sql",
    "DCS/sql/db_components/mysql/inventory_ddl.sql",
    "DCS/sql/db_components/mysql/user_promotion_ddl.sql",
    "DCS/sql/db_components/mysql/order_ddl.sql",
    "DCS/sql/db_components/mysql/user_giftlist_ddl.sql",
    "DCS/sql/db_components/mysql/dcs_mappers.sql",
    "DCS/sql/db_components/mysql/order_markers_ddl.sql",
    "DSS/InternalUsers/sql/db_components/mysql/internal_scenario_ddl.sql",
    "Publishing/base/sql/db_components/mysql/internal_user_profile_ddl.sql",
    "Publishing/base/sql/db_components/mysql/publishing_ddl.sql",
    "Publishing/base/sql/db_components/mysql/versioned_file_repository_ddl.sql",
    "Publishing/base/sql/db_components/mysql/versioned_process_data_ddl.sql",
    "Publishing/base/sql/db_components/mysql/versionmanager_ddl.sql",
    "Publishing/base/sql/db_components/mysql/workflow_ddl.sql",
    "DCS/Versioned/sql/db_components/mysql/versioned_claimable_ddl.sql",
    "DCS/Versioned/sql/db_components/mysql/versioned_commerce_site_ddl.sql",
    "DCS/Versioned/sql/db_components/mysql/versioned_priceLists_ddl.sql",
    "DCS/Versioned/sql/db_components/mysql/versioned_product_catalog_ddl.sql",
    "DCS/Versioned/sql/db_components/mysql/versioned_custom_catalog_ddl.sql",
    "DCS/Versioned/sql/db_components/mysql/versioned_promotion_ddl.sql",
    "DAS/Versioned/sql/db_components/mysql/versioned_seo_ddl.sql",
    "DAS/Versioned/sql/db_components/mysql/versioned_site_ddl.sql",
    "DPS/Versioned/sql/db_components/mysql/versioned_personalization_ddl.sql",
    "WebUI/sql/db_components/mysql/viewmapping_ddl.sql"
	]

	appendFiles( requiredSqlFiles, atgBaseDir, "pub.sql" )
}
