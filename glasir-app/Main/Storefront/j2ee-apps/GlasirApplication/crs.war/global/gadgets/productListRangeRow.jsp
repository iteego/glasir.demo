<dsp:page>
  <%-- This page renders the product range for specified category/searchCriteria/feature
    Parameters - 
    - product - product repository item to display
    - categoryId - Core metrics category id string
    - categoryNav - Determines if breadcrumbs are updated to reflect category navigation on click through
    - productActionsClassName
    - productDescriptionClassName
    - productImageClassName
    - productPriceClassName
    - productTitleClassName
  --%>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale" var="requestLocale"/>
  <dsp:importbean bean="/atg/repository/seo/BrowserTyperDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <dsp:getvalueof var="prodActionsClassName" param="productActionsClassName"/>
  <dsp:getvalueof var="prodDescriptionClassName" param="productDescriptionClassName"/>
  <dsp:getvalueof var="prodImageClassName" param="productImageClassName"/>  
  <dsp:getvalueof var="prodPriceClassName" param="productPriceClassName"/>
  <dsp:getvalueof var="prodTitleClassName" param="productTitleClassName"/>
  <dsp:getvalueof var="productListRangeRowLinkTitle" param="browse_productListRangeRow.linkTitle"/>
  
  <dsp:getvalueof var="displaySiteIndicator" param="displaySiteIndicator"/>

  <%-- Get productId for use in Cache droplets --%>
  <dsp:getvalueof var="productId" vartype="java.lang.String" param="product.repositoryId"/>
  <dsp:getvalueof var="storeId" vartype="java.lang.String" bean="Profile.storeId"/>
  <dsp:getvalueof var="categoryNav" param="categoryNav"/>  

  <dsp:include page="productLinkGenerator.jsp">
    <dsp:param name="product" param="product"/>
    <dsp:param name="navLinkAction" param="navLinkAction"/>
    <dsp:param name="categoryNavIds" param="categoryNavIds"/>
    <dsp:param name="categoryNav" param="categoryNav"/>
    <dsp:param name="searchClickId" param="searchClickId"/>
  </dsp:include>
  
  <a href="${productUrl}">
    <%-- thumbnail image --%>
    <span class="atg_store_productImage">
      <dsp:include page="/browse/gadgets/productThumbImg.jsp">
        <dsp:param name="product" param="product" />
        <dsp:param name="categoryNav" value="${categoryNav}" />
        <dsp:param name="showAsLink" value="false"/>
      </dsp:include>
    </span>
  
    <%-- product name --%>
    <span class="atg_store_productTitle">
      <dsp:include  page="/browse/gadgets/productName.jsp">
        <dsp:param name="product" param="product" />
        <dsp:param name="categoryNav" value="${categoryNav}" />
        <dsp:param name="showAsLink" value="false"/>
      </dsp:include>
    </span>  

  
    <%-- Check the size of the sku array to see how we handle things --%>
    <dsp:getvalueof var="childSKUs" param="product.childSKUs"/>
    <c:set var="totalSKUs" value="${fn:length(childSKUs)}"/>
       
    <dsp:droplet name="Compare">
      <dsp:param name="obj1" value="${totalSKUs}" converter="number" />
      <dsp:param name="obj2" value="1" converter="number"/>
      <dsp:oparam name="equal">
        <%-- Size is one, just add to cart --%>
        <%-- Display Price --%>
        <dsp:param name="sku" param="product.childSKUs[0]"/>
        <span class="atg_store_productPrice">         
          <%@ include file="priceLookup.jsp" %>
        </span>
          
        <%-- end alt. content --%>
      </dsp:oparam>
      <dsp:oparam name="default">
        <%-- Size is not one, show link --%>
        <%-- Display Price Range --%>
        <span class="atg_store_productPrice">
          <%@ include file="priceRange.jsp" %>
        </span>
      </dsp:oparam>
    </dsp:droplet> <%-- End Compare droplet to see if the product has a single sku --%>
    
    <%-- Site indication --%>
    <c:if test="${displaySiteIndicator}">
			
      <dsp:getvalueof var="mode" param="mode"/>
      <c:if test="${empty mode}">
        <dsp:getvalueof var="mode" value="icon"/>
      </c:if>

      <dsp:include page="/global/gadgets/siteIndicator.jsp">
        <dsp:param name="mode" value="${mode}"/>              
        <dsp:param name="product" param="product"/>
      </dsp:include>
    </c:if>
  </a>
  
  <dsp:getvalueof var="productTemplateUrl" param="product.template.url"/>
  <c:if test="${not empty productTemplateUrl}">
    <%-- Product Template is set --%>
    <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="product.template.url"/>

    <%-- Get browser-specific URL for product --%>
    <dsp:droplet name="/atg/repository/seo/CatalogItemLink">
      <dsp:param name="item" param="product"/>
      <dsp:oparam name="output">
        <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="url"/>
      </dsp:oparam>
    </dsp:droplet>
  </c:if> <%-- End is template empty --%>
</dsp:page>                              

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/productListRangeRow.jsp#2 $$Change: 635969 $--%>
