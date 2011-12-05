<dsp:page>
<%--
  This gadget generates <dsp:a> tag with cross site link.
  
  Parameter:
    item - commerce item (an implementation of atg.commerce.order.CommerceItem interface)
    product - product item
    imgUrl - image url
    httpserver - URL prefix to construst fully-qualified URLs in emails
--%>

  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SiteLinkDroplet"/>
  <dsp:importbean bean="/atg/commerce/multisite/SiteIdForCatalogItem"/>

  <dsp:getvalueof var="imgUrl" param="imgUrl"/>
  <dsp:getvalueof var="item" param="item"/>

  <c:choose>
    <c:when test="${not empty item}">
      <dsp:getvalueof var="displayName" param="item.auxiliaryData.productRef.displayName"/>
      <dsp:getvalueof var="productId" param="item.auxiliaryData.productId"/>
      <dsp:getvalueof var="siteId" param="item.auxiliaryData.siteId"/>

      <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
          <dsp:param name="product" param="item.auxiliaryData.productRef"/>
          <dsp:param name="siteId" value="${siteId}"/>
      </dsp:include>
    </c:when>
    <c:otherwise>
      <dsp:getvalueof var="displayName" param="product.displayName"/>
      <dsp:getvalueof var="productId" param="product.repositoryId"/>

      <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
          <dsp:param name="product" param="product"/>
      </dsp:include>
    </c:otherwise>
  </c:choose>

  <dsp:getvalueof var="siteLinkUrl" param="siteLinkUrl"/>
  <dsp:getvalueof var="httpserver" param='httpserver'/>
  <c:choose>
    <c:when test="${empty imgUrl}">
      <dsp:a href="${httpserver}${siteLinkUrl}" title="${displayName}">
        <dsp:valueof value="${displayName}">
          <fmt:message key="common.noDisplayName"/>
        </dsp:valueof>
        <dsp:param name="productId" value="${productId}"/>
      </dsp:a>
    </c:when>
    <c:otherwise>
      <dsp:a href="${httpserver}${siteLinkUrl}" title="${displayName}">
        <img src="${imgUrl}" alt="${displayName}"/>
        <dsp:param name="productId" value="${productId}"/>
      </dsp:a>
    </c:otherwise>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/crossSiteLink.jsp#1 $$Change: 633540 $--%>
