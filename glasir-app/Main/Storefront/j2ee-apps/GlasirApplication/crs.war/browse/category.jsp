<dsp:page>

  <%--
      Layout page for main category

     This page expects the following parameters :
      -categoryId(required) - Repository Id of the Category being traversed
      -categoryNavIds (optional) - ':' separated list representing the category navigation trail

  --%>
  <dsp:importbean bean="/atg/commerce/search/refinement/CommerceFacetTrailDroplet"/>
  <dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
  <dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
  <dsp:importbean bean="/atg/commerce/search/StoreBrowseConstraints"/>
  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/targeting/TargetingFirst"/>

  <%@include file="/atgsearch/gadgets/categorySearch.jspf" %>

  <dsp:include page="/browse/gadgets/categoryContents.jsp" flush="true">
    <%-- showErrorOnEmptyCategory is used by categoryContents to optionally
      include an noCategorysFound jsp --%>
    <dsp:param name="showErrorOnEmptyCategory" value="true" />
    <dsp:param name="hideResults" value="true" />
    <dsp:param name="container" value="/browse/categoryDisplay.jsp" />
    <dsp:param name="categoryId" param="categoryId" />
    <dsp:param name="categoryNavIds" param="categoryNavIds" />
    <dsp:param name="facetTrail" value="${facetTrail}" />
  </dsp:include>


</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/category.jsp#2 $$Change: 635969 $ --%>