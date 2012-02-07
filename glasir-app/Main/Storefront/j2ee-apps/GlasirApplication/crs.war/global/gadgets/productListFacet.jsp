<dsp:page>
    <%--
      Container page for main category
      Parameters - 
      - category - Repository item of the Category being traversed
      - trailSize - Size of the facet trail traversed so far
      - facetTrail - Facet trail traversed so far
      - facetSearchResponse - Facet Search Response Object from ATG-Search Server
  --%>
    <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup" />
    <%-- unpack dsp:param --%>

    <dsp:getvalueof var="atgSearchInstalled" bean="/atg/store/StoreConfiguration.atgSearchInstalled"/>
    <c:if test="${atgSearchInstalled == true}">
      <dsp:include page="/facet/gadgets/facetSearchResults.jsp" flush="true">
        <dsp:param name="facetSearchResponse" param="facetSearchResponse" />
        <dsp:param name="trailSize" param="trailSize" />
        <dsp:param name="question" param="question"/>

      </dsp:include>
    </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/productListFacet.jsp#2 $$Change: 635969 $--%>