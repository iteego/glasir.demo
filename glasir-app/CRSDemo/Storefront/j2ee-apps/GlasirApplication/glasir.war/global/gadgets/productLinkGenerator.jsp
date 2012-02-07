<%-- 
  Calculates a valid URL to be displayed for the specified product. Calculated URL is stored within 'productUrl' request-scoped variable.

  This page expects the following parameters
    - product        (required) - the product repository item to build URL for
    - navLinkAction  (optional) - type of breadcrumb navigation to use for product detail links.
                                  Valid values are push, pop, or jump. Default is jump.
    - categoryNavIds (optional) - ':' separated list representing the category navigation trail
    - categoryNav    (optional) - Determines if breadcrumbs are updated to reflect category navigation trail on click through
--%>

<dsp:page>  
  <dsp:getvalueof var="searchClickId" param="searchClickId"/>
  <dsp:getvalueof var="templateUrl" param="product.template.url"/>
  
  <c:choose>
    <c:when test="${empty templateUrl}">
      <c:set var="productUrl" scope="request" value=""/>
    </c:when>
    <c:otherwise>
      <dsp:droplet name="/atg/repository/seo/ProductLookupItemLink">
        <dsp:param name="item" param="product"/>
        <dsp:param name="categoryId" param="categoryId"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="url"/>
        </dsp:oparam>
      </dsp:droplet>
      
      <%-- Determine if the generated URL is indirect URL for search spiders by 
           checking the browser type. --%>
      <dsp:droplet name="/atg/repository/seo/BrowserTyperDroplet">
        <dsp:oparam name="output">
          <dsp:getvalueof var="browserType" param="browserType"/>
          <c:set var="isIndirectUrl" value="${browserType eq 'robot'}"/>
        </dsp:oparam>
      </dsp:droplet>
 
      <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
        <dsp:param name="product" param="product"/>
        <dsp:param name="customUrl" value="${pageurl}"/>
        <dsp:param name="siteId" param="siteId"/>
      </dsp:include>
      
      <%-- Do not add additional parameters if the URL for search spiders as this
           will turn the static URL back to dynamic one --%>
      
      <c:url var="pageurl" value="${siteLinkUrl}" context="/">
        <c:if test="${not isIndirectUrl}">
          <dsp:getvalueof var="atgSearchInstalled" bean="/atg/store/StoreConfiguration.atgSearchInstalled"/>
          <c:if test="${atgSearchInstalled == 'true'}">
            <c:param name="selectedColor" value="${param.selectedColor}"/>
            <c:param name="selectedSize" value="${param.selectedSize}"/>
            <c:if test="${not empty searchClickId}">
              <c:param name="searchClickId" value="${searchClickId}"/>
            </c:if>
          </c:if>
          
          <dsp:getvalueof var="categoryNavIds" param="categoryNavIds"/>
          <c:if test="${!empty categoryNavIds}">
            <c:param name="categoryNavIds" value="${categoryNavIds}"/>
          </c:if>
          <dsp:getvalueof var="categoryNav" param="categoryNav"/>
          <c:if test="${!empty categoryNav}">
            <c:param name="categoryNav" value="${categoryNav}"/>
          </c:if>
          <dsp:getvalueof var="navLinkAction" param="navLinkAction"/>
          <c:if test="${empty navLinkAction}">
            <c:set var="navLinkAction" value="jump"/>
          </c:if>
          <dsp:getvalueof var="navCount" bean="/atg/commerce/catalog/CatalogNavHistory.navCount"/>
          <c:param name="navAction" value="${navLinkAction}"/>
          <c:param name="navCount" value="${navCount}"/>
        </c:if>
      </c:url>
      <c:set var="productUrl" scope="request" value="${pageurl}"/>
      
    </c:otherwise>
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/productLinkGenerator.jsp#2 $$Change: 633752 $--%>