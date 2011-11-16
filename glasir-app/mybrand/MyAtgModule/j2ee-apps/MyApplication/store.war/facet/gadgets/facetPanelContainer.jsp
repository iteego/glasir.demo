<dsp:page>
  <%-- This page renders the facet contents.
      Parameters - 
       - facetTrail - The facet trail traversed upto this point
       - trailSize - The trail size (number of facets traversed) upto this point
       - numResults - Number of search results
       - categoryId - The category under consideration
       - addFacet - The facet value for which refinement is requested
       - trail - The facet trail traversed so far
    --%>
  <dsp:getvalueof var="numResults" param="numResults"/>
  <dsp:getvalueof var="categoryId" param="categoryId"/>
  <dsp:getvalueof var="addFacet" param="addFacet"/>
  <dsp:getvalueof var="trail" param="trail"/>
  <dsp:getvalueof var="facetTrail" param="facetTrail"/>
  <dsp:getvalueof var="trailSize" param="trailSize"/>
  <dsp:getvalueof var="removeFacet" param="removeFacet"/>



  <script type="text/javascript">
    //set the facet search target for live updating of a div
      setFacetTarget("searchResults");

      var jsonFacets = <%@include file="/facetjson/facetData.jsp" %>;

      <c:set var="removeFacet"><dsp:valueof param="removeFacet" valueishtml="false"/></c:set>   
      <c:set var="trailSize"><dsp:valueof param="trailSize" valueishtml="false"/></c:set>
      <c:set var="facetTrail"><dsp:valueof param="facetTrail" valueishtml="false"/></c:set>
      <c:set var="addFacet"><dsp:valueof param="addFacet" valueishtml="false"/></c:set>
      <c:set var="categoryId"><dsp:valueof param="categoryId" valueishtml="false"/></c:set>
      <c:set var="numResults"><dsp:valueof param="numResults" valueishtml="false"/></c:set>
      <c:set var="question"><dsp:valueof param="question" valueishtml="false"/></c:set>
  
      var content = {
          removeFacet:'${removeFacet}',
          trailSize:'${trailSize}',
          facetTrail:'${facetTrail}',
          addFacet:'${addFacet}',
          categoryId:'${categoryId}',
          numResults:'${numResults}',
          question:'${question}'
      };

      // set the globle variable nRedirect
      // it indicate that whether need to redirect the whole page to the urlFacet location, instead of updating
      setRedirect(0);

      dojo.addOnLoad(function() {
          handleFacetLoad(jsonFacets, '${categoryId}');
      });
  </script>

  <dsp:getvalueof var="facetHolders" bean="FacetSearchTools.facets"/>
  <c:if test="${(not empty facetHolders) || (not empty param.facetOrder)}">
    <div id="atg_store_facets">
      <dsp:include page="/facet/gadgets/facetNavigationRenderer.jsp" />
    </div>
  </c:if>

   
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/facet/gadgets/facetPanelContainer.jsp#3 $$Change: 638606 $--%>
