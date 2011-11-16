<dsp:page>
  
  <dsp:importbean bean="/atg/store/StoreConfiguration" />
  <dsp:getvalueof var="atgSearchInstalled" bean="StoreConfiguration.atgSearchInstalled" />
  <div id="atg_store_search">
  <c:choose>
    <c:when test="${atgSearchInstalled == 'true'}">
      <dsp:include page="/atgsearch/gadgets/atgSearch.jsp" />
    </c:when>
    <c:otherwise>
      <dsp:include page="/search/gadgets/simpleSearch.jsp" />
    </c:otherwise>
  </c:choose>
  </div>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/search.jsp#2 $$Change: 635969 $ --%>
