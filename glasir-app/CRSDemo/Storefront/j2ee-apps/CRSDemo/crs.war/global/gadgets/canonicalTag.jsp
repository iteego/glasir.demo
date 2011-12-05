<%-- This page renders canonical tag --%>
<dsp:page>
  <dsp:getvalueof var="categoryId" param="categoryId" />
  <dsp:getvalueof var="productId" param="productId" />

  <%-- Eval base part of link --%>
  <dsp:getvalueof var="serverName" vartype="java.lang.String" bean="/atg/dynamo/Configuration.siteHttpServerName" />
  <dsp:getvalueof var="serverPort" vartype="java.lang.String" bean="/atg/dynamo/Configuration.siteHttpServerPort" />
  <dsp:getvalueof var="httpServer" vartype="java.lang.String" value="http://${serverName}:${serverPort}" />
  <dsp:getvalueof var="contextPath" vartype="java.lang.String" bean="/OriginatingRequest.contextPath" />
  <dsp:getvalueof var="httpLink" vartype="java.lang.String" value="${httpServer}${contextPath}" />
  <c:choose>
    <c:when test="${not empty categoryId && empty productId}">
      <dsp:droplet name="/atg/repository/seo/CanonicalItemLink">
        <dsp:param name="id" param="categoryId" />
        <dsp:param name="itemDescriptorName" value="category" />
        <dsp:param name="repositoryName" value="/atg/commerce/catalog/ProductCatalog" />
        <dsp:oparam name="output">
          <dsp:getvalueof var="pageUrl" param="url" vartype="java.lang.String" />
          <link rel="canonical" href="${httpLink}${pageUrl}" />
        </dsp:oparam>
      </dsp:droplet>
    </c:when>
    <c:when test="${not empty productId}">
      <dsp:droplet name="/atg/repository/seo/CanonicalItemLink">
        <dsp:param name="id" param="productId" />
        <dsp:param name="itemDescriptorName" value="product" />
        <dsp:param name="repositoryName" value="/atg/commerce/catalog/ProductCatalog" />
        <dsp:oparam name="output">
          <dsp:getvalueof var="pageUrl" param="url" vartype="java.lang.String" />
          <link rel="canonical" href="${httpLink}${pageUrl}" />
        </dsp:oparam>
      </dsp:droplet>
    </c:when>
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/canonicalTag.jsp#2 $$Change: 635969 $--%>