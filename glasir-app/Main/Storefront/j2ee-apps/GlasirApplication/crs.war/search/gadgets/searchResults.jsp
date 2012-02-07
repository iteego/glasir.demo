<dsp:page>

  <%-- This JSP renders the search results --%>
  <%-- Parameters -
  --%>

  <dsp:importbean bean="/atg/commerce/catalog/ProductSearch"/>

  <dsp:setvalue param="resultArray" beanvalue="ProductSearch.searchResults"/>

  <dsp:getvalueof var="formExceptions" bean="ProductSearch.formExceptions"/>
  <c:choose>
    <%-- No matching items found for search term --%>
    <c:when test="${not empty formExceptions}">
      <crs:messageContainer optionalClass="atg_store_noMatchingItem"
        titleKey="facet_facetSearchResults.noMatchingItem"/>
    </c:when>

    <%-- Display search results. Pass either results from simple or adv search --%>
    <c:otherwise>

      <%-- Check to see if there are any results --%>
      <dsp:getvalueof var="resultArray" param="resultArray"/>
      <c:choose>
        <c:when test="${not empty resultArray}">
          <div id="atg_store_searchResults">
            <dsp:include page="/global/gadgets/productListRange.jsp">
              <dsp:param name="productArray" param="resultArray"/>
              <dsp:param name="productActionsClassName" value="atg_store_productActions"/>
              <dsp:param name="productDescriptionClassName" value="atg_store_prodList"/>
              <dsp:param name="productDivName" value="atg_store_prodList"/>
              <dsp:param name="productImageClassName" value="atg_store_productImage"/>
              <dsp:param name="productPriceClassName" value="atg_store_productPrice"/>
              <dsp:param name="productTitleClassName" value="atg_store_productTitle"/>
              <dsp:param name="sortClassName" value="atg_store_searchSort"/>
              <dsp:param name="isSimpleSearchResults" value="true"/>

              <dsp:param name="searchFeatures" bean="ProductSearch.propertyValues.features"/>
              <dsp:param name="searchCategoryId" bean="ProductSearch.hierarchicalCategoryId"/>
              <dsp:param name="sSearchInput" bean="ProductSearch.searchInput"/>
              <dsp:param name="q_pageNum" value="${param.q_pageNum}"/>
              <dsp:param name="searchResultsSize" bean="ProductSearch.searchResultsSize"/>
              <dsp:param name="viewAll" value="${param.viewAll}"/>
              <dsp:param name="displaySiteIndicator" value="true"/>
            </dsp:include>
          </div>
        </c:when>

        <c:otherwise>
          <crs:messageContainer optionalClass="atg_store_noMatchingItem"
            titleKey="facet_facetSearchResults.noMatchingItem"/>
        </c:otherwise>
      </c:choose>

    </c:otherwise>
  </c:choose>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/search/gadgets/searchResults.jsp#2 $$Change: 633752 $--%>