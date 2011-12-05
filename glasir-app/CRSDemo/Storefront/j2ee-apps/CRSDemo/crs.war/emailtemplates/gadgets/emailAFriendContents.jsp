<dsp:page>

  <%-- Email To A Friend email template contents page
      Parameters from TemplateEmailSender - 
      - locale - Current locale of the Shopper when she sent the email
      - productId - Repository Id of the Product being emailed
      - senderName - Name of the Shopper who is sending the Email
      - recipientEmail - Name of the Shopper who is receiving the Email
      - message - Optional Message to be delivered as part of the Email
  --%>

  <dsp:importbean var="storeConfig" bean="/atg/store/StoreConfiguration"/>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>

  <%-- Set RequestLocale.locale as the email is sent in a new session only for that purpose --%>
  <%-- Locale has to be explicitly set on the template to send the message in the Shoppers locale --%>
  <dsp:getvalueof var="var_locale" param="locale"/>
  <dsp:setvalue bean="/atg/dynamo/servlet/RequestLocale.localeString" value="${var_locale}"/>

  <fmt:setLocale value="${requestLocale.locale}"/>

  <fmt:setBundle basename="${config.resourceBundle}" />

  <dsp:getvalueof var="var_productId" param="productId"/>
  <dsp:getvalueof var="var_senderName" param="senderName"/>
  <dsp:getvalueof var="var_message" param="message"/>

  <c:set var="httpserver" value="http://${storeConfig.siteHttpServerName}:${storeConfig.siteHttpServerPort}"/>
  
<%-- 
----------------------------------------------------------------
Begin Main Content
----------------------------------------------------------------
--%>

  <dsp:droplet name="ProductLookup">
    <dsp:param name="id" value="${var_productId}"/>
    <dsp:oparam name="output">

      <%-- Name a product parameter so we can keep track of things --%>
      <dsp:setvalue param="product" paramvalue="element"/>
          
        <dsp:getvalueof var="productTemplateUrl" param="product.template.url"/>
        <c:choose>
        <c:when test="${not empty productTemplateUrl}">
          <%-- Product Template is set --%>
          
          <%-- Get cross site link for product template --%>
          <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="siteId" bean="/atg/multisite/Site.id"/>
            <dsp:param name="queryParams" value="productId=${var_productId}"/>
          </dsp:include>
          
          <dsp:getvalueof var="var_productUrl"  value="${httpserver}${siteLinkUrl}"/>
          <c:url var="var_productUrl" value="${var_productUrl}">
            <c:param name="locale"><dsp:valueof param="locale"/></c:param>
          </c:url>
          <c:set var="isProductUrlEmpty" value="false" />
        </c:when>
        <c:otherwise>
          <%-- Product Template not set --%>
          <c:set var="isProductUrlEmpty" value="true" />
        </c:otherwise>
      </c:choose>
      <%-- End is template empty --%>
          
      <%-- Include /emailtemplates/emailAFriendContentsContainer.jsp to include all gadgets --%> 
      <dsp:getvalueof var="container" vartype="java.lang.String" param="container"/>
      <dsp:include page="${container}" flush="true">
        <dsp:param name="product" param="product"/>
        <dsp:param name="productUrl" value="${var_productUrl}"/>
        <dsp:param name="locale" value="${var_locale}"/>
        <dsp:param name="productId" value="${var_productId}"/>
        <dsp:param name="recipientEmail" param="recipientEmail"/>
        <dsp:param name="senderName" value="${var_senderName}"/>
        <dsp:param name="message" value="${var_message}"/>
        <dsp:param name="isProductUrlEmpty" value="${isProductUrlEmpty}"/>
      </dsp:include>
    </dsp:oparam>

    <dsp:oparam name="empty">
      <fmt:message key="common.productNotFound">
        <fmt:param>
          <dsp:valueof param="productId">
            <fmt:message key="common.productIdDefault"/>
          </dsp:valueof>
        </fmt:param>
      </fmt:message>
    </dsp:oparam>
  
  </dsp:droplet>

<%-- 
----------------------------------------------------------------
End Main Content
----------------------------------------------------------------
--%>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailAFriendContents.jsp#1 $$Change: 633540 $--%>
