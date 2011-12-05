<dsp:page>

<%-- This page expects the following parameters
     - product - the product repository item to display
     - categoryId - the repository ID of the product, category or
                     the name of an alternate nav category
     - navLinkAction (optional) - type of breadcrumb navigation to use for product 
                     detail links. Valid values are push, pop, or jump. Default is jump.
     - showAsLink - specifies if product name should be displayed as link if possible,
                    true by default
     - categoryNavIds - ':' separated list representing the category navigation trail
     - categoryNav - Determines if breadcrumbs are updated to reflect category navigation trail on click through
--%>

  <dsp:getvalueof var="productName" param="product.displayName"/>
  
  <dsp:getvalueof var="showAsLink" param="showAsLink"/>
  <c:choose>
    <c:when test="${showAsLink == 'false'}">
      <c:set var="productUrl" value=""/>
    </c:when>
    <c:otherwise>
      <dsp:include page="/global/gadgets/productLinkGenerator.jsp">
        <dsp:param name="product" param="product"/>
        <dsp:param name="navLinkAction" param="navLinkAction"/>
        <dsp:param name="categoryNavIds" param="categoryNavIds"/>
        <dsp:param name="categoryNav" param="categoryNav"/>
        <dsp:param name="siteId" param="siteId"/>
      </dsp:include>
    </c:otherwise>
  </c:choose>
  
  <c:choose>
    <c:when test="${empty productUrl}">
      <c:out value="${productName}"/>
    </c:when>
    <c:otherwise>
      <dsp:a href="${productUrl}">
        <c:out value="${productName}"/>
      </dsp:a>
    </c:otherwise>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productName.jsp#1 $$Change: 633540 $--%><%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productName.jsp#1 $$Change: 633540 $--%>
