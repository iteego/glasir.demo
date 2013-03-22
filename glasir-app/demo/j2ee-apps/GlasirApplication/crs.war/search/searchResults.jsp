<dsp:page>

  <%-- This JSP renders the search results and the Featured Search form --%>
  <%-- Expected parameters - 
  --%>
  <dsp:importbean bean="/atg/commerce/catalog/ProductSearch"/>



  <crs:pageContainer
      divId="atg_store_searchResultsIntro"
      index="false" follow="false"
      bodyClass="category atg_store_searchResults atg_store_leftCol">


    <jsp:body>

      <c:if test="${empty param.searchExecByFormSubmit}">
        <dsp:include page="/search/gadgets/searchRequestHandler.jsp">
          <dsp:param name="preventFormHandlerRedirect" value="true"/>
        </dsp:include>
      </c:if>

      <dsp:getvalueof var="question" bean="ProductSearch.searchInput" />
      <dsp:getvalueof var="searchResultsSize" bean="ProductSearch.searchResultsSize"/>
      <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="search_searchResults.title"/>
      </h2>
      </div>
      <div class="atg_store_main">

        <div id="atg_store_mainHeader">
          <c:if test="${not empty question}">
            <div class="atg_store_searchReultsCount">
              <c:choose>
                <c:when test="${searchResultsSize == 1}">
                  <fmt:message var="resultsMessage" key="facet.facetGlossaryContainer.oneResultFor"/>
                </c:when>
                <c:otherwise>
                  <fmt:message var="resultsMessage" key="facet.facetGlossaryContainer.resultFor"/>
                </c:otherwise>
              </c:choose>
              <c:out value="${searchResultsSize}"/>&nbsp;<c:out value="${resultsMessage}"/>&nbsp;<span class="searchTerm"><dsp:valueof value="${question}" /></span>
            </div>
          </c:if>
        </div>


        <div id="ajaxContainer">
        <div divId="ajaxRefreshableContent">
          <dsp:include page="/search/gadgets/searchResults.jsp"/>
          <div name="transparentLayer" id="transparentLayer"></div>
          <div name="ajaxSpinner" id="ajaxSpinner"></div>
        </div>
        </div>
      </div>

      <div class="aside">
          <%-- Rendering promotions--%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp" flush="true">
          <dsp:param name="targeter" bean="/atg/registry/Slots/CategoryPromotionContent1"/>
          <dsp:param name="renderer" value="/promo/gadgets/promotionalContentTemplateRenderer.jsp"/>
          <dsp:param name="elementName" value="promotionalContent"/>
        </dsp:include>
        <dsp:include page="/global/gadgets/targetingRandom.jsp" flush="true">
          <dsp:param name="targeter" bean="/atg/registry/Slots/CategoryPromotionContent2"/>
          <dsp:param name="renderer" value="/promo/gadgets/promotionalContentTemplateRenderer.jsp"/>
          <dsp:param name="elementName" value="promotionalContent"/>
        </dsp:include>
      </div>


    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/search/searchResults.jsp#2 $$Change: 635969 $--%>