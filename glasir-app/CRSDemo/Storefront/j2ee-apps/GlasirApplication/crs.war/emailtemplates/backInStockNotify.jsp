<dsp:page>

  <%-- This page expects the following parameters
       1. productId - the id of the product that's back in stock
  --%>

  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>
  <dsp:getvalueof var="backInStockFromAddress" bean="Site.backInStockFromAddress" />

  <dsp:droplet name="ProductLookup">
    <dsp:param name="id" param="productId"/>
    <dsp:oparam name="output">      
      <dsp:setvalue param="product" paramvalue="element"/>
      <dsp:getvalueof var="productName" param="product.displayName"/>
    </dsp:oparam>
  </dsp:droplet>

  <fmt:message var="emailSubject" key="emailtemplates_backInStockNotify.subject">
    <fmt:param>
      <dsp:valueof bean="Site.name" />
    </fmt:param>
    <fmt:param>
      <c:out value="${productName}" />
    </fmt:param>
  </fmt:message>

  <crs:emailPageContainer divId="atg_store_backInStockNotifyIntro" 
        titleKey="emailtemplates_backInStockNotify.title" 
        messageSubjectString="${emailSubject}"
        messageFromAddressString="${backInStockFromAddress}">

    <jsp:body>
      <dsp:include page="/emailtemplates/gadgets/backInStockNotify.jsp">
        <dsp:param name="productId" param="productId"/>
      </dsp:include>
    </jsp:body>

  </crs:emailPageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/backInStockNotify.jsp#2 $$Change: 635969 $--%>
