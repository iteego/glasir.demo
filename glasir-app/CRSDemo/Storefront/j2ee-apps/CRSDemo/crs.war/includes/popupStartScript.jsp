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

  <%--
    Include all Javascript files that need to be loaded for the page. 
    All <script> blocks should be included on this page to perform any page initialization.
  --%>
  <c:set var="javascriptRoot" value="${pageContext.request.contextPath}/javascript"/>

  <%-- Include other required external Javascript files --%>
  <script type="text/javascript" src="${javascriptRoot}/store.js"></script>
  
  <script type="text/javascript" charset="utf-8">
  var formIdArray = ["atg_store_preRegisterForm","atg_store_registerLoginForm","atg_store_checkoutLoginForm","searchForm","simpleSearch"];
   dojo.addOnLoad(function(){
     atg.store.util.addTextAreaCounter();
     atg.store.util.addNumericValidation();
     atg.store.util.addReturnHandling();
   });
  </script>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/includes/popupStartScript.jsp#2 $$Change: 633752 $--%>
