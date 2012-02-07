<dsp:page>

  <%-- This page displays the product listing, faceting information specific to the 
      main category being browsed. 
      This page expects the following parameters :
      
      - categoryId (required)- repository id of the category being browsed.
      - container  (required)- Page fragment is used for displaying category page   .
        Optional parameters:
      - trailSize - It is used for faceted Navigation .
      - categoryNavIds - ':' separated list representing the category navigation trail
      - showErrorOnEmptyCategory - if set to true and there are no categorys
        found we will display the no category found page
  --%>
  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/search/refinement/CommerceFacetTrailDroplet"/>
  <dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
	
	<%-- This page is used by search and the category page, we dont want to display
	the 'no category found' page if we are called via search and there is no 
	categorys found--%>
	<dsp:getvalueof id="showErrorOnEmptyCategory" param="showErrorOnEmptyCategory"/>
	
  <%-- Retrieve the Category to browse --%>
  <dsp:droplet name="CategoryLookup">
    <dsp:param name="id" param="categoryId"/>

    <dsp:oparam name="output">
      <%-- Send 'Category Browsed' event --%>
      <dsp:droplet name="/atg/commerce/catalog/CategoryBrowsed">
        <dsp:param name="eventobject" param="element"/>    
      </dsp:droplet>

      <%-- Update last browsed category in profile --%>
      <dsp:include page="categoryLastBrowsed.jsp">
        <dsp:param name="lastBrowsedCategory" param="categoryId"/>
      </dsp:include>

      <%-- Set the categoryObject for individual gadgets to work on --%>
      <dsp:getvalueof var="categoryObject" param="element" vartype="java.lang.Object" scope="request"/>

      <%-- Track the user's navigation to provide the appropriate breadcrumbs --%>
      <dsp:include page="breadcrumbsNavigation.jsp" flush="true">
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

      <dsp:getvalueof var="container" vartype="java.lang.String" param="container"/>
      <dsp:getvalueof var="hideResults" param="hideResults"/>

      <c:choose>

        <c:when test="${container == null}">  <%-- this is AJAX and search --%>
          <div style="display:none;">facetJsonStart<dsp:include page="/atgsearch/gadgets/ajaxSearch.jsp"/>facetJsonEnd
          </div>
          <%@ include file="/browse/gadgets/facetSearchProductsForCategory.jspf" %>

        </c:when>

        <c:otherwise>   <%-- this is coming from the top tier category page --%>
          <dsp:include page="${container}" flush="true">
            <dsp:param name="hideResults" param="hideResults"/>
            <dsp:param name="facetTrail" param="facetTrail"/>
            <dsp:param name="facetSearchResponse" value="${facetSearchResponseVar}"/>
            <dsp:param name="category" value="${categoryObject}"/>
            <dsp:param name="trailSize" value="${trailSizeVar}"/>
          </dsp:include>
        </c:otherwise>
      </c:choose>

    </dsp:oparam>

		<%-- When an error message is passed back from the bean --%>
    <dsp:oparam name="error">
      <dsp:include page="/browse/gadgets/categoryNotAvailable.jsp">
        <dsp:valueof param="errorMsg"/>
      </dsp:include>
    </dsp:oparam>
    
    <%-- When the empty parameter is passed back from the bean --%>
    <dsp:oparam name="empty">
      <c:if test="${!empty showErrorOnEmptyCategory}">
        <c:if test="${showErrorOnEmptyCategory == 'true'}">
          <dsp:include page="/browse/gadgets/categoryNotAvailable.jsp"/>
        </c:if>
      </c:if>
    </dsp:oparam>
    
    <%-- When the wrong site parameter is passed back from the bean --%>
    <dsp:oparam name="wrongSite">
      <dsp:include page="/browse/gadgets/categoryNotAvailable.jsp">
        <dsp:param name="site" bean="Site.name"/>
      </dsp:include>
    </dsp:oparam>

  </dsp:droplet>

  <dsp:getvalueof var="categoryId" param="categoryId"/>

  <c:if test="${empty categoryId}">
    <div style="display:none;">facetJsonStart<dsp:include page="/atgsearch/gadgets/ajaxSearch.jsp"/>facetJsonEnd</div>
    <%@ include file="/browse/gadgets/facetSearchProductsForCategory.jspf" %>
  </c:if>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/categoryContents.jsp#2 $$Change: 635969 $--%>

