<%--
This page returns JSON data containing facets, categories, and products from a search query.
This page does the actual querying of the search engine.
Parameters:
 - q_question - question to the search engine
 - q_pageNum(optional) - desired page number of results
 - q_docSort - desired sorting parameter
 - q_docSortOrder - whether the sort is descending or ascending
 - viewAll(optional) - whether to display all
 - categoryId(optional) - repository id of category that is being browsed
--%>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>
<dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
<dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
<dsp:importbean bean="/atg/userprofiling/Profile" />
<dsp:importbean bean="/atg/commerce/search/refinement/CommerceFacetTrailDroplet" />
<dsp:importbean bean="/atg/commerce/catalog/CategoryLookup" />

<dsp:getvalueof var="question" bean="QueryFormHandler.searchRequest.question" />
<dsp:getvalueof var="currentTrail" bean="FacetSearchTools.facetTrail" />
<dsp:getvalueof var="categoryId" param="categoryId" />

<%-- if exists categoryId in url param, this is a category browse (with search), not a regular search --%>
<c:if test="${categoryId != null && categoryId !=''}">
  <%@include file="/facetjson/categoryBrowse.jsp" %>
</c:if>


<c:if test="${categoryId == null || categoryId == ''}">

  <c:choose>
  <%-- if there's already a trail, then turn that string into a bean --%>
  <c:when test="${currentTrail != null && currentTrail != ''}">
    <dsp:droplet name="CommerceFacetTrailDroplet">
      <dsp:param name="trail" value="${currentTrail}" />
      <dsp:param name="refineConfig" param="catRC" />
      <dsp:oparam name="output">
        <dsp:getvalueof var="currentTrail" param="facetTrail" />
      </dsp:oparam>
    </dsp:droplet>
  </c:when>

  <%-- if this is the first search, just make the facetTrail contain only the search --%>
  <c:when test="${currentTrail == null || currentTrail == ''}">
    <dsp:droplet name="CommerceFacetTrailDroplet">
      <dsp:param name="trail" value="" />
      <dsp:param name="addFacet" value="SRCH:${question}" />
      <dsp:param name="refineConfig" param="catRC" />
      <dsp:oparam name="output">
        <dsp:getvalueof var="currentTrail" param="facetTrail" />
      </dsp:oparam>
    </dsp:droplet>
  </c:when>
</c:choose>

  <json:object>
   
    <json:property name="categoryId"><dsp:valueof param="categoryId"/></json:property>
    <json:property name="addFacet"><dsp:valueof param="addFacet"/></json:property>
    <json:property name="facetTrail"><dsp:valueof bean="FacetSearchTools.facetTrail"/></json:property>
    <json:property name="currentTrail"><dsp:valueof value="${currentTrail}"/></json:property>
    <json:property name="removeFacet"><dsp:valueof param="removeFacet"/></json:property>
    <json:property name="sort"><dsp:valueof bean="QueryFormHandler.searchRequest.docSort"/></json:property>

   <%@include file="/facetjson/facetFacets.jspf" %>

    <%@include file="/facetjson/facetCategories.jspf" %>
    
    <%@include file="/facetjson/facetProducts.jspf" %>
    
    <%@include file="/facetjson/facetParams.jspf" %>
  </json:object>
</c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/facetjson/facetData.jsp#2 $$Change: 635969 $--%>