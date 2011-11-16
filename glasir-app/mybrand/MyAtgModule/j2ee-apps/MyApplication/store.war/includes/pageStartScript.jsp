<dsp:page>
  <%--
    Include all Javascript files that need to be loaded for the page. 
    All <script> blocks should be included on this page to perform any page initialization.
  --%>

  <dsp:getvalueof var="storeConfig" bean="/atg/store/StoreConfiguration"/>
  <fmt:message key="common.button.pleaseWaitText" var="pleaseWaitMessage"/>
  <c:set var="javascriptRoot" value="${pageContext.request.contextPath}/javascript"/>

  <%-- Include dojo from WebUI module. 
       Context root for dojo version 1.0 is configured in WebUI module as '/dojo-1'
  --%>
  <script type="text/javascript">
    <%-- Dojo Configuration.
         Set baseScriptUri to the root where the dojo.js file is located. This allows us to substitute
         the source dojo build (dojo.src.js) so that the bootstrap file will load the inidividual modules.
         Enable/Disable Dojo debugging - This will log any dojo.debug calls to the Firebug console if installed. 
         Enable debugging by setting component /atg/store/StoreConfiguration.dojoDebug=true --%>
    var djConfig={
      baseScriptUri: "${fn:substringBefore(storeConfig.dojoUrl,"dojo.")}",
      disableFlashStorage: true,
      parseOnLoad: true,
      isDebug: ${storeConfig.dojoDebug}
    };
  </script>

 
  <script type="text/javascript" src="/dojo-1-4-2/dojo/dojo.js"></script>
  
  <script type="text/javascript" src="/dojo-1-4-2/dojo/dnd/autoscroll.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dojo/dnd/common.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dojo/dnd/Mover.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dojo/dnd/Moveable.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dojo/dnd/move.js"></script>  
  <script type="text/javascript" src="/dojo-1-4-2/dojo/dnd/TimedMoveable.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dojo/i18n.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2//dijit/nls/dijit-all_en-us.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dijit/dijit-all.js"></script>
  
  
  <script type="text/javascript" src="/dojo-1-4-2/dojo/fx/Toggler.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dojo/fx.js"></script>
  
  <%--
    Include all Javascript files that need to be loaded for the page. 
    All <script> blocks should be included on this page to perform any page initialization.
  --%>
  
  <c:set var="javascriptRoot" value="${pageContext.request.contextPath}/javascript"/>


  <script type="text/javascript" src="/dojo-1-4-2/dojo/i18n.js"></script>
  <script type="text/javascript"src="/dojo-1-4-2/dojo/html.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dijit/layout/ContentPane.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dijit/form/_FormMixin.js"></script>  
  <script type="text/javascript" src="/dojo-1-4-2/dijit/_DialogMixin.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dijit/DialogUnderlay.js"></script>
  <script type="text/javascript"src="/dojo-1-4-2/dijit/TooltipDialog.js"></script>
  <script type="text/javascript" src="/dojo-1-4-2/dijit/Dialog.js"></script>
  <script type="text/javascript"src="/dojo-1-4-2/dojox/fx/_base.js"></script>

  <script type="text/javascript">
    
    <%-- Create global var with webapp context path - this can be used to build absolute urls--%>
    var contextPath="${pageContext.request.contextPath}";
        
    <%-- Define Store javascript modules path --%>
    dojo.registerModulePath('atg.store', contextPath+'/javascript');
        
    <%-- Define all required dojo modules. Any custom defined widgets should be listed here. --%>
    
    
    <%-- Add any required page initialisation functions here. DO NOT use <body onload=...>  --%>

  </script>
  <script type="text/javascript" src="${javascriptRoot}/widget/RichCartTrigger.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/widget/RichCartSummary.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/widget/RichCartTrigger.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/widget/RichCartSummaryItem.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/widget/enterSubmit.js"></script>
  
  
  <%-- Include other required external Javascript files --%>
  <script type="text/javascript" src="${javascriptRoot}/Lightbox.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/picker.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/estore.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/store.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/AccordionNav.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/facet.js"></script>
  
  <%-- Include any store-specific Javascript files. These should be added to the jsp included
       here, and copied to the store-specific application directory  --%>

       <script type="text/javascript" charset="utf-8">
       var formIdArray = ["atg_store_preRegisterForm","atg_store_registerLoginForm","atg_store_checkoutLoginForm","searchForm","simpleSearch"];   
        dojo.addOnLoad(function(){
          atg.store.util.setUpPopupEnhance();
          atg.store.util.addNumericValidation();
          atg.store.util.addReturnHandling();
          atg.store.util.addTextAreaCounter();
          atg.store.util.initAddressHighlighter();
          atg.store.util.richButtons("atg_store_basicButton");
          atg.store.util.searchFieldBehaviors(dojo.byId("atg_store_searchInput"), dojo.byId("atg_b2cstore_search"));
          if(dojo.isMac){ dojo.addClass(dojo.doc.documentElement,"dj_osx"); }
        });
        
       </script>

  <dsp:include page="storeScript.jsp"/>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/includes/pageStartScript.jsp#3 $$Change: 635969 $--%>
