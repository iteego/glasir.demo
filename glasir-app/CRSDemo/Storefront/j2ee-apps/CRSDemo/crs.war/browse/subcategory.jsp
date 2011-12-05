<dsp:page>

  <%--
      Layout page for sub-category

      This page expects the following parameters :
      
      -categoryId - Repository Id of the Category being traversed
      -categoryNavIds (optional) - ':' separated list representing the category navigation trail
--%>
  
  <dsp:importbean bean="/atg/commerce/search/refinement/CommerceFacetTrailDroplet"/>
  <dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
  <dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
  <dsp:importbean bean="/atg/commerce/search/StoreBrowseConstraints"/>
  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/targeting/TargetingFirst"/>
  <dsp:importbean bean="/atg/multisite/Site"/>

  <%@include file="/atgsearch/gadgets/categorySearch.jspf" %>

  <dsp:droplet name="CategoryLookup">
    <dsp:param name="id" param="categoryId"/>
    
    <%-- Droplet output --%>    
    <dsp:oparam name="output">
      <%-- Send 'Category Browsed' event --%>
      <dsp:droplet name="/atg/commerce/catalog/CategoryBrowsed">
        <dsp:param name="eventobject" param="element"/>    
      </dsp:droplet>

      <%-- Update last browsed category in profile --%>
      <dsp:include page="gadgets/categoryLastBrowsed.jsp">
        <dsp:param name="lastBrowsedCategory" param="categoryId"/>
      </dsp:include>

      <%-- Set the categoryObject for individual gadgets to work on --%>
      <dsp:getvalueof var="categoryObject" param="element" vartype="java.lang.Object" scope="request"/>

      <%-- Track the user's navigation to provide the appropriate breadcrumbs --%>
      <dsp:include page="gadgets/breadcrumbsNavigation.jsp" flush="true">
        <dsp:param name="categoryNavIds" param="categoryNavIds"/>
        <dsp:param name="defaultCategory" value="${categoryObject}"/>
      </dsp:include>

      <%-- Check for trailSize parameter. If not found, init to 0. Parameter is used for faceted Navigation --%>
      <c:choose>
        <c:when test="${(! empty param.trailSize) && (fn:length(fn:trim(param.trailSize)) > 0) }">
          <dsp:getvalueof var="trailSizeVar" param="trailSize"/>
        </c:when>
        <c:otherwise>
          <dsp:getvalueof var="trailSizeVar" value="0"/>
        </c:otherwise>
      </c:choose>
     
      <%-- Include /browse/subcategoryDisplay.jsp to include all gadgets --%>
      <dsp:include page="/browse/subcategoryDisplay.jsp" flush="true">
        <dsp:param name="category" value="${categoryObject}"/>
        <dsp:param name="facetTrail" value="${facetTrail}"/>
        <dsp:param name="trailSize" value="${trailSizeVar}"/>
        <dsp:param name="categoryNavIds" param="categoryNavIds"/>
      </dsp:include>

    </dsp:oparam>
    
    <%-- Empty Output --%>
    <dsp:oparam name="empty"> 
 			<dsp:include page="/browse/gadgets/categoryNotAvailable.jsp"/>
    </dsp:oparam>
    
    <%-- When an error message is passed back from the bean --%>
    <dsp:oparam name="error">
      <dsp:include page="/browse/gadgets/categoryNotAvailable.jsp">
        <dsp:valueof param="errorMsg"/>
      </dsp:include>
    </dsp:oparam>
    
    <%-- When the wrong site parameter is passed back from the bean --%>
    <dsp:oparam name="wrongSite">
      <dsp:include page="/browse/gadgets/categoryNotAvailable.jsp">
        <dsp:param name="site" bean="Site.name"/>
      </dsp:include>
    </dsp:oparam>
    
  </dsp:droplet>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/subcategory.jsp#2 $$Change: 635969 $--%>

