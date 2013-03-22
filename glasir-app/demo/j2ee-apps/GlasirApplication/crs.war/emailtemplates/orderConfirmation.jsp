<dsp:page>

  <dsp:importbean bean="/atg/store/StoreConfiguration" var="config"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>

  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  
  <dsp:getvalueof var="orderConfirmationFromAddress" bean="Site.orderConfirmationFromAddress" />
  <dsp:setvalue param="httpserver" value="http://${config.siteHttpServerName}:${config.siteHttpServerPort}"/>
  
  <dsp:getvalueof var="message" param="message"/>
  <%--Check if message is not empty so that not to override order parameter
      when template is used by Email Tester --%>
  <c:if test="${not empty message }">
    <dsp:setvalue param="order" paramvalue="message.order"/>
  </c:if>

  <fmt:message var="emailSubject" key="emailtemplates_orderConfirmation.subject">
    <fmt:param>
      <dsp:valueof bean="Site.name" />
    </fmt:param>
    <fmt:param>
      <dsp:valueof param="order.omsOrderId"/>
    </fmt:param>
  </fmt:message>
  
  <crs:emailPageContainer divId="atg_store_orderConfirmationIntro" 
                          titleKey="emailtemplates_orderConfirmation.title" 
                          messageSubjectString="${emailSubject}"
                          messageFromAddressString="${orderConfirmationFromAddress}">
  
<%-- 
----------------------------------------------------------------
Begin Main Content
----------------------------------------------------------------
--%>

  
  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom:4px;color:#666;font-family:Tahoma,Arial,sans-serif;font-size:14px; border-collapse: collapse;">
    <tr>
      <td colspan="5" style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:14px;padding-bottom:20px">

<%-- 
----------------------------------------------------------------
Begin Optional Text
----------------------------------------------------------------
--%> 
        <%-- Display link to order details only for registered users --%>
          <dsp:getvalueof var="isTransient" bean="Profile.transient"/>
          <c:if test="${!isTransient}">
            <fmt:message key="emailtemplates_orderShipped.track">
              <fmt:param>
                <fmt:message var="linkText" key="emailtemplates_orderConfirmation.orderDetails"/>
                <dsp:getvalueof var="orderId" param="order.omsOrderId"/>
                <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
                  <dsp:param name="path" value="/myaccount/gadgets/loginOrderDetail.jsp"/>
                  <dsp:param name="queryParams" value="orderId=${orderId}&selpage=MY ORDERS"/>
                  <dsp:param name="httpserver" param="httpserver"/>
                  <dsp:param name="linkText" value="${linkText}"/>
                </dsp:include>
              </fmt:param>
            </fmt:message>
          </c:if>
<%-- 
----------------------------------------------------------------
End Optional Text
----------------------------------------------------------------
--%>

      </td>
    </tr>
    <tr>
      <td style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;padding-bottom:10px;"><fmt:message key="emailtemplates_orderConfirmation.orderNumber"/></td>
       <td style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;font-weight:bold;padding-bottom:10px;"><dsp:valueof param="order.omsOrderId"/></td>
    </tr>
    <tr>
      <td style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;padding-bottom:10px;padding-right:5px;white-space:nowrap;"><fmt:message key="emailtemplates_orderConfirmation.placedOn"/></td>
      <td style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;font-weight:bold;padding-bottom:10px;white-space:nowrap;"><dsp:getvalueof var="submittedDate" vartype="java.util.Date" param="order.submittedDate"/><fmt:formatDate value="${submittedDate}" type="both" dateStyle="long"/></td>
    </tr>
    <tr>
      <td style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;padding-bottom:10px;"><fmt:message key="emailtemplates_orderConfirmation.status"/></td>
      <td style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;font-weight:bold;padding-bottom:10px;"><dsp:include page="/global/util/orderState.jsp"/></td>
    </tr>
    
<%-- 
----------------------------------------------------------------
Billing Info
----------------------------------------------------------------
--%>
    <%-- Retrieve the price lists's locale used for order. It will be used to
         format prices correctly. 
         We can't use Profile's price list here as it will not work in CSC where orders can be
         submitted by agent profile. So extract price list from commerce item's price info. --%>
    <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" param="order.commerceItems"/>     
    <c:if test="${not empty commerceItems}">
      <dsp:tomap var="priceListMap" param="order.commerceItems[0].priceInfo.priceList" />
      <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" value="${priceListMap.locale}"/>
    </c:if>
    <tr>
      <td valign="top" style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;padding-bottom:20px;"><fmt:message key="emailtemplates_orderConfirmation.billTo"/></td>
      <td style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;padding-bottom:20px;"><%-- Credit Card Info --%>
        <dsp:include page="/emailtemplates/gadgets/emailOrderPaymentRenderer.jsp">
          <dsp:param name="order" param="order"/>
          <dsp:param name="paymentGroupType" value="creditCard"/>
          <dsp:param name="priceListLocale" value="${priceListLocale}"/>
        </dsp:include>
        <%-- Store Credit Info --%>
        <dsp:include page="/emailtemplates/gadgets/emailOrderPaymentRenderer.jsp">
          <dsp:param name="order" param="order"/>
          <dsp:param name="paymentGroupType" value="storeCredit"/>
          <dsp:param name="priceListLocale" value="${priceListLocale}"/>
        </dsp:include>
      </td>
    </tr> 
    <tr><td colspan="5" width><hr size="1"></td></tr>
              
<%-- 
----------------------------------------------------------------
Shipping Info & Order Contents
----------------------------------------------------------------
--%>
   
   <dsp:include page="/emailtemplates/gadgets/emailOrderShippingAddresses.jsp" flush="true">
     <dsp:param name="priceListLocale" value="${priceListLocale}"/>
   </dsp:include>
          
   </table>
   <br />
  
<%-- 
----------------------------------------------------------------
End Main Content
----------------------------------------------------------------
--%>

  </crs:emailPageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/orderConfirmation.jsp#1 $$Change: 633540 $--%>
