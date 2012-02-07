<dsp:page>

  <%-- This page will actually calculate the price for the user.
       This page expects the following parameters
       - price - price to format
       - priceListLocale (optional) - locale in which to format prices. If not passed then Profile's
                                      price lists's locale will be used.
  --%>
  <dsp:importbean bean="/atg/commerce/pricing/CurrencyCodeDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale"/>
  <dsp:importbean bean="/atg/multisite/SiteContext"/>
	<dsp:importbean bean="/atg/store/StoreConfiguration" />

  <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="priceListLocale"/>
  <c:if test="${empty priceListLocale}">
    <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" bean="Profile.priceList.locale"/>
  </c:if>
  <dsp:getvalueof var="requestLocale" vartype="java.lang.String" bean="RequestLocale.locale"/>
  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>
  
  <dsp:droplet name="CurrencyCodeDroplet">
    <dsp:param name="locale" value="${priceListLocale}"/>
    <dsp:oparam name="output">
      <dsp:getvalueof var="currencyCode" vartype="java.lang.String" param="currencyCode"/>
      
      <dsp:getvalueof var="price" vartype="java.lang.Double" param="price"/>
      
      <c:if test="${priceListLocale != requestLocale}">
        <%-- Reset page's locale to the pricelist locale --%>
        <c:if test="${fn:length(priceListLocale)>5 }">
          <c:set var="variant" value="${fn:substring(priceListLocale,6,fn:length(priceListLocale))}"/>
          <c:set var="priceListLocale" value="${fn:substring(priceListLocale,0,5)}"/>
        </c:if>
        <fmt:setLocale value="${priceListLocale}" variant="${variant}"/>
        <%-- Reset resource bundle so that locale of page's localization context 
             will be updated to the pricelist locale too --%>
        
        <dsp:getvalueof var="resourceBundle" bean="SiteContext.site.resourceBundle" />
        <dsp:getvalueof var="defaultResourceBundle" bean="StoreConfiguration.defaultResourceBundle" />
        
        <c:choose>
          <c:when test="${not empty resourceBundle}">
            <fmt:setBundle basename="${resourceBundle}"/>
          </c:when>
          <c:otherwise>
            <fmt:setBundle basename="${defaultResourceBundle}"/>
          </c:otherwise>
        </c:choose>
        
      </c:if>
      <%-- display price formatted according to the pricelist locale --%>
      <c:choose>
        <c:when test="${saveFormattedPrice}">
          <fmt:formatNumber var="formattedPrice" value="${price}" type="currency" currencyCode="${currencyCode }" scope="request"/>
        </c:when>
        <c:otherwise>
          <fmt:formatNumber value="${price}" type="currency" currencyCode="${currencyCode }"/>
        </c:otherwise>
      </c:choose>
      
     
    </dsp:oparam>
  </dsp:droplet><%-- End CurrencyCode Droplet --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/formattedPrice.jsp#2 $$Change: 635969 $--%>
