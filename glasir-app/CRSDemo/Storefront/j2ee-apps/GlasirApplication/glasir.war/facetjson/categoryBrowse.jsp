<dsp:page>
  <%-- This page displays the product listing, faceting information specific to the 
      subcategory being browsed. It is called from facetData.jsp
      Parameters - 
    - same parameters as facetData.jsp
  --%>
  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/search/refinement/CommerceFacetTrailDroplet"/>
  <dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
  <dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
  <dsp:importbean bean="/atg/targeting/TargetingFirst"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
  <dsp:importbean bean="/atg/commerce/search/StoreBrowseConstraints"/>
    
  <dsp:getvalueof var="currentTrail" value="${facetTrail}" />

  <json:object>
    <json:property name="categoryId"><dsp:valueof param="categoryId"/></json:property>
    <json:property name="addFacet"><dsp:valueof param="addFacet"/></json:property>
    <json:property name="facetTrail"><dsp:valueof value="${currentTrail}"/></json:property>
    <json:property name="removeFacet"><dsp:valueof param="removeFacet"/></json:property>
    <json:property name="FacetSearchTools.facetTrail"><dsp:valueof bean="FacetSearchTools.facetTrail"/></json:property>
    <json:property name="sort"><dsp:valueof bean="QueryFormHandler.searchRequest.docSort"/></json:property>

    <%@include file="facetFacets.jspf" %>

    <%@include file="facetCategories.jspf" %>
    
    <%@include file="facetProducts.jspf" %>
    
    <%@include file="facetParams.jspf" %>
    
  </json:object>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/facetjson/categoryBrowse.jsp#2 $$Change: 635969 $--%>
