<dsp:page>

  <%-- This page expects the following input parameters
       productId - the id of the product whose details are shown
       colorSizePicker (optional) - set to true to show the color size picker
       categoryId (optional) - the id of the category the product is viewed from
       tabname (optional) - the name of a more details tab to display
       initialQuantity (optional) - sets the initial quantity to preset in the form
       container - set to the container to call with the product object
       categoryNavIds (optional) - ':' separated list representing the category navigation trail
       categoryNav (optional) - Determines if breadcrumbs are updated to reflect category navigation trail on click through
       navAction (optional) - type of breadcrumb navigation used to reach this page for tracking. 
                                Valid values are push, pop, or jump. Default is jump.
       navCount (optional) - current navigation count used to track for the use of the back button. Default is 0.
    --%>
  <dsp:getvalueof id="productId" param="productId"/>
  <dsp:getvalueof id="colorSizePicker" param="colorSizePicker"/>
  <dsp:getvalueof id="categoryId" param="categoryId"/>
  <dsp:getvalueof id="tabname" param="tabname"/>
  <dsp:getvalueof id="quantity" param="quantity"/>
  <dsp:getvalueof id="container" param="container"/>
  <dsp:getvalueof var="missingProductId" vartype="java.lang.String" bean="/atg/commerce/order/processor/SetProductRefs.substituteDeletedProductId"/>
    
  <dsp:importbean bean="/atg/commerce/catalog/ProductBrowsed"/>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>
  <dsp:importbean bean="/atg/commerce/catalog/CatalogNavHistoryCollector"/>
  <dsp:importbean bean="/atg/userprofiling/Profile" />
  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  
 
  <%-- Default the navigation Action to jump if it is not provided --%>
  <dsp:getvalueof var="navAction" param="navAction"/>
  <c:choose>
    <c:when test="${empty navAction}">
      <dsp:setvalue param="navAction" value="jump"/>
    </c:when>
  </c:choose>
  
  <dsp:droplet name="ProductLookup">
    <dsp:param name="id" param="productId"/>
    
    <dsp:oparam name="output">
    
      <c:choose>
        <c:when test="${missingProductId != productId}">
        <%-- Notify anyone who cares that the current product has been viewed --%>
        <dsp:droplet name="ProductBrowsed">
          <dsp:param name="eventobject" param="element"/>    
        </dsp:droplet>
        
        <%-- Track the user's navigation to provide the appropriate breadcrumbs --%>
        <dsp:getvalueof var="categoryNavIds" param="categoryNavIds"/>
        <dsp:getvalueof var="categoryNav" param="categoryNav"/>

          <c:choose>
            <c:when test="${!empty categoryNavIds}">
              <c:forEach var="categoryNavId"
                         items="${fn:split(categoryNavIds, ':')}"
                         varStatus="status">
                <c:set var="navAction" value="push"/>
                <c:if test="${status.first}">
                  <c:set var="navAction" value="jump"/>
                </c:if>

                <dsp:droplet name="CategoryLookup">
                  <dsp:param name="id" value="${categoryNavId}"/>
                  <dsp:oparam name="output">
                    <dsp:getvalueof var="currentCategory" param="element" vartype="java.lang.Object" scope="request"/>
                    <dsp:droplet name="/atg/commerce/catalog/CatalogNavHistoryCollector">
                      <dsp:param name="item" value="${currentCategory}" />
                      <dsp:param name="navAction" value="${navAction}" />
                    </dsp:droplet>

                    <c:set var="navCategory" value="${currentCategory}"/>
                  </dsp:oparam>
                </dsp:droplet>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <%-- if no categoryNavIds found, search for categoryId and jump into it,
                  if this can't be found either, get default parent category and jump there --%>
              <dsp:getvalueof var="navCategory" param="categoryId"/>
              <c:choose>
                <c:when test="${empty navCategory}">
                  <dsp:getvalueof var="navCategory" param="element.parentCategory"/>
                </c:when>
                <c:otherwise>
                  <dsp:droplet name="/atg/commerce/catalog/CategoryLookup">
                    <dsp:param name="id" value="${navCategory}"/>
                    <dsp:oparam name="output">
                      <dsp:getvalueof var="category" param="element"/>
                      <c:set var="navCategory" value="${category}"/>
                    </dsp:oparam>
                  </dsp:droplet>
                </c:otherwise>
              </c:choose>
              <dsp:droplet name="/atg/commerce/catalog/CatalogNavHistoryCollector">
                <dsp:param name="item" value="${navCategory}" />
                <dsp:param name="navAction" value="jump" />
              </dsp:droplet>
            </c:otherwise>
          </c:choose>
            
          <%-- Update last browsed category in profile --%>
          <dsp:include page="categoryLastBrowsed.jsp"/>

          <%-- Call the container, passing along the product object and the colorSizePicker --%>
          <dsp:include page="${container}">
            <dsp:param name="product" param="element"/>
            <dsp:param name="colorSizePicker" param="colorSizePicker"/>
            <dsp:param name="categoryId" param="categoryId"/>
              <dsp:param name="navCategory" value="${navCategory}"/>
            <dsp:param name="tabname" param="tabname"/>
            <dsp:param name="quantity" param="quantity"/>
              <dsp:param name="categoryNavIds" param="categoryNavIds"/>
          </dsp:include>
        </c:when>
        <c:otherwise>
          <dsp:include page="/browse/gadgets/productNotAvailable.jsp" />
        </c:otherwise>
      </c:choose>
    </dsp:oparam>
    
    <dsp:oparam name="empty">
      <dsp:include page="/browse/gadgets/productNotAvailable.jsp" />
    </dsp:oparam>
    
    <%-- When the wrong site parameter is passed back from the bean --%>
    <dsp:oparam name="wrongSite">
      <dsp:include page="/browse/gadgets/productNotAvailable.jsp">
        <dsp:param name="site" bean="Site.name"/>
      </dsp:include>
    </dsp:oparam>
    
  </dsp:droplet>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productLookupForDisplay.jsp#2 $$Change: 635969 $ --%>
