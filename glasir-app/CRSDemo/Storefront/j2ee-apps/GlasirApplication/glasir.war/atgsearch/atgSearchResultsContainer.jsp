<%@ taglib prefix="dsp" uri="http://www.atg.com/taglibs/daf/dspjspTaglib1_0" %>
<dsp:page>

  <%-- This page is a container page for facetGlossary page
      Parameters -
      - trailSize - the trail size (number of facets traversed) upto this point
      - facetTrail - The facet trail traversed upto this point
      - refinement - the refinement list with facets
      - searchResults - the search results
      - totalCount - results count
  --%>
  <dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup" />

  <%-- unpack dsp:param --%>
  <dsp:getvalueof var="trailSizeVar" param="trailSize" />
<div class="atg_store_nonCatHero">
  <h2 class="title">
    <fmt:message key="search_searchResults.title"/>
  </h2>
  </div>

  <div class="atg_store_main">


        <div id="ajaxContainer" >
        <div divId="ajaxRefreshableContent">


          <dsp:getvalueof bean="QueryFormHandler.searchResponse" var="queryResponse" scope="request"/>

          <dsp:getvalueof var="searchResults" value="${queryResponse.results}"/>

        <c:forEach var="element" items="${searchResults}">
          <dsp:param name="element" value="${element}"/>
          <dsp:getvalueof var="p_tempProd" param="element.document.properties.$repositoryId" />
          <dsp:getvalueof var="matchingItemsList" value="${matchingItemsList} ${p_tempProd}" />
        </c:forEach>

        <dsp:include page="/browse/gadgets/categoryContents.jsp" flush="true" >
          <dsp:param name="matchingItemsList" value="${matchingItemsList}" />
          <dsp:param name="numResults" param="totalCount" />
          <dsp:param name="viewAll" param="viewAll" />
          <dsp:param name="categoryId" param="categoryId" />
          <dsp:param name="addFacet" param="addFacet" />
        </dsp:include>



        </div>
          <div name="transparentLayer" id="transparentLayer"></div>
          <div name="ajaxSpinner" id="ajaxSpinner"></div>
        </div>


  </div>

  <div class="aside">

    <dsp:include page="/facet/gadgets/facetPanelContainer.jsp" flush="true">
      <dsp:param name="facetTrail" param="facetTrail" />
      <dsp:param name="trailSize" value="${trailSizeVar}" />
      <dsp:param name="facetSearchResponse" param="refinement" />
      <dsp:param name="addFacet" param="addFacet" />
    </dsp:include>

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
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/atgsearch/atgSearchResultsContainer.jsp#1 $$Change: 633540 $ --%>
