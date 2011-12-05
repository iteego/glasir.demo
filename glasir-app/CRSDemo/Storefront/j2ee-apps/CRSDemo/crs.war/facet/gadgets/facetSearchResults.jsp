<dsp:page>

  <%-- Renders the Facet Search Results Product Listing
      Parameters -
      - facetTrail - facetTrail traversed by the Shopper so far
  --%>
  <dsp:importbean bean="/atg/store/StoreConfiguration" />
  
  <dsp:getvalueof var="atgSearchInstalled" bean="StoreConfiguration.atgSearchInstalled"/>

  <c:if test="${atgSearchInstalled == true}">
    <dsp:include page="/global/gadgets/productListRangeFacetSearch.jsp">
      <dsp:param name="sortClassName" value="atg_store_filter"/>
      <dsp:param name="productDivName" value="atg_store_prodList"/>
      <dsp:param name="productTitleClassName" value="atg_store_prodListItem"/>
      <dsp:param name="productImageClassName" value="atg_store_prodListThumb"/>
      <dsp:param name="productDescriptionClassName" value="atg_store_prodListDesc"/>
      <dsp:param name="productPriceClassName" value="atg_store_prodListPrice"/>
      <dsp:param name="productActionsClassName" value="atg_store_prodListDetLink"/>
      <dsp:param name="q_pageNum" param="q_pageNum"/>
      <dsp:param name="numResults" param="numResults"/>
      <dsp:param name="queryRequest" param="queryRequest"/>
    </dsp:include>
  </c:if>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/facet/gadgets/facetSearchResults.jsp#2 $$Change: 635969 $--%>