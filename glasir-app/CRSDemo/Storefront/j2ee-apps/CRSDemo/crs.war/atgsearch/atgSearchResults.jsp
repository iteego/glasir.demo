<dsp:page>

  <dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
  <dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
  <dsp:importbean bean="/atg/commerce/search/refinement/CommerceFacetTrailDroplet" />

  <crs:pageContainer divId="atg_store_facetGlossaryIntro" contentClass="category"
                     index="false" follow="false"
                     bodyClass="category atg_store_searchResults atg_store_leftCol">

    <jsp:body>
      <dsp:getvalueof bean="QueryFormHandler.searchResponse" var="queryResponse" scope="request"/>

      <dsp:getvalueof value="${queryResponse.groupCount}" var="totalCountVar"/>
      <dsp:getvalueof var="refinementVar" value="${queryResponse.refinements.refinementsList}"/>

      <dsp:include page="/atgsearch/atgSearchResultsContainer.jsp">


        <dsp:param name="trailSize" value="${trailSizeVar}"/>
        <dsp:param name="totalCount" value="${totalCountVar}"/>
        <dsp:param name="refinement" value="${refinementVar}"/>
        <dsp:param name="trailSize" value="0"/>


        <dsp:param name="question" bean="QueryFormHandler.searchResponse.question"/>

        <c:if test="${empty param.searchExecByFormSubmitVar}">
          <dsp:param name="q_docSort" bean="QueryFormHandler.searchResponse.docSort"/>
          <dsp:param name="q_docSortOrder" bean="QueryFormHandler.searchResponse.docSortOrder"/>
        </c:if>



        <dsp:getvalueof var="facetTrail" param="trail"/>

        <c:if test="${addFacet == null && facetTrail == null}">
          <c:set var="escapeVal" value="${fn:replace(question, ' ', '+')}" />
          <dsp:param name="addFacet" value="SRCH:${escapeVal}"/>
        </c:if>
      </dsp:include>
      <script type="text/javascript">
        var catNavNotSupported = true;
        dojo.require("dojo.back");
        dojo.back.init();
        dojo.back.setInitialState(new HistoryState(""));
      </script>

    </jsp:body>

  </crs:pageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/atgsearch/atgSearchResults.jsp#2 $$Change: 635969 $ --%>
