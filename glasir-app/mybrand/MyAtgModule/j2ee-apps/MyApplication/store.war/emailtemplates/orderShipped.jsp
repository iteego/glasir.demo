<dsp:page>

  <dsp:importbean bean="/atg/store/StoreConfiguration" var="config"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>

  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <dsp:getvalueof var="orderShippedFromAddress" bean="Site.orderShippedFromAddress" />
  <dsp:setvalue param="httpserver" value="http://${config.siteHttpServerName}:${config.siteHttpServerPort}"/>
  
  <dsp:getvalueof var="message" param="message"/>
  
  <%--Check if message is not empty so that not to override order parameter
      when template is used by Email Tester --%>
  <c:if test="${not empty message }">
    <dsp:setvalue param="order" paramvalue="message.order"/>
    <dsp:setvalue param="shippingGroup" paramvalue="message.shippingGroup"/>
  </c:if>
  
  <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" param="message.order.commerceItems"/>     
  <c:if test="${not empty commerceItems}">
    <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="message.order.commerceItems[0].priceInfo.priceList.locale"/>
  </c:if>

  <fmt:message var="emailSubject" key="emailtemplates_orderShipped.subject">
    <fmt:param>
      <dsp:valueof bean="Site.name" />
    </fmt:param>
    <fmt:param>
      <dsp:valueof param="order.omsOrderId"/>
    </fmt:param>
  </fmt:message>
  
  <crs:emailPageContainer divId="atg_store_orderConfirmationIntro" 
                          titleKey="emailtemplates_orderShipped.title" 
                          messageSubjectString="${emailSubject}"
                          messageFromAddressString="${orderShippedFromAddress}">
  
<%-- 
----------------------------------------------------------------
Begin Main Content
----------------------------------------------------------------
--%>
  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:20px;margin-bottom:4px;color:#666;font-family:Tahoma,Arial,sans-serif;font-size:14px; border-collapse: collapse;">
    <tr>
      <td colspan="5" style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:14px;padding-bottom:20px">

<%-- 
----------------------------------------------------------------
Begin Optional Text
----------------------------------------------------------------
--%>

      <dsp:getvalueof var="isTransient" bean="Profile.transient"/>
      <c:if test="${!isTransient}">
        <fmt:message key="emailtemplates_orderShipped.track">
          <fmt:param>
            <fmt:message var="linkText" key="emailtemplates_orderConfirmation.orderDetails"/>
            <dsp:getvalueof var="orderId" param="order.omsOrderId"/>
            <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
              <dsp:param name="path" value="/myaccount/gadgets/loginOrderDetail.jsp"/>
              <dsp:param name="httpserver" param="httpserver"/>
              <dsp:param name="queryParams" value="orderId=${orderId}"/>              
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
      <td style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;padding-bottom:10px; white-space: nowrap;">
          <fmt:message key="emailtemplates_orderShipped.orderNumber"/>
       </td>
       <td colspan="4" style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;font-weight:bold;padding-bottom:10px;">
          <dsp:valueof param="order.omsOrderId"/>
        </td>
    </tr>
    <tr>
      <td style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;padding-bottom:10px; white-space: nowrap;">
       
          <fmt:message key="emailtemplates_orderShipped.placedOn"/>
       
      </td>
      <td colspan="4" style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;font-weight:bold;padding-bottom:10px;">
        <dsp:getvalueof var="submittedDate" vartype="java.util.Date" param="order.submittedDate"/>
        
          <fmt:formatDate value="${submittedDate}" type="both" dateStyle="long"/>
       
      </td>
    </tr>
    <tr>
      <td style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;padding-bottom:10px; white-space: nowrap;">
       
          <fmt:message key="emailtemplates_orderShipped.status"/>
      
      </td>
      <td colspan="4" style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;font-weight:bold;padding-bottom:10px;">
       
          <dsp:include page="/global/util/orderState.jsp"/>
       
      </td>
    </tr>
    
    <tr style="margin-top:20px;padding-bottom:10px">
      <td colspan="5"><hr size="1"></td>
    </tr> 
              
<%-- 
----------------------------------------------------------------
Shipping Info & Order Contents
----------------------------------------------------------------
--%>
          
    <dsp:include page="/emailtemplates/gadgets/shippingGroupRenderer.jsp" flush="true">
      <dsp:param name="shippingGroup" param="shippingGroup"/>
    </dsp:include>
          
    <tr><td colspan="5">&nbsp;</td></tr>
    <tr>
      <td colspan="2"></td>
      <td colspan="2" style="font-size:12px;line-height:18px;">
        <fmt:message key="common.subTotal" />
      </td>
      <td align="right" style="color:#000000;font-weight:bold;font-size:12px;line-height:18px;">
        <dsp:getvalueof var="shipItemRels" vartype="java.util.Collection" param="shippingGroup.commerceItemRelationships"/>
        <c:set var="totalAmount" value="0"/>
        <c:forEach var="shipItemRelationship" items="${shipItemRels}">
          <dsp:droplet name="/atg/store/droplet/StorePriceBeansDroplet">
            <dsp:param name="relationship" value="${shipItemRelationship}"/>
            <dsp:oparam name="output">
              <dsp:getvalueof var="amount" vartype="java.lang.Double" param="priceBeansAmount"/>
              <c:set var="totalAmount" value="${totalAmount + amount}"/>
            </dsp:oparam>
          </dsp:droplet>
        </c:forEach>
        <dsp:include page="/global/gadgets/formattedPrice.jsp">
          <dsp:param name="price" value="${totalAmount - giftWrapAmount}"/>
          <dsp:param name="priceListLocale" value="${priceListLocale}"/>
        </dsp:include>
      </td>
    </tr>
    <tr>
      <td colspan="2"></td>
      <td colspan="2" style="font-size:12px;line-height:18px;">
        <fmt:message key="common.shipping" />
      </td>
      <td align="right" style="color:#000000;font-weight:bold;font-size:12px;line-height:18px;">
        <dsp:include page="/global/gadgets/formattedPrice.jsp">
          <dsp:param name="price" param="shippingGroup.priceInfo.amount"/>
          <dsp:param name="priceListLocale" value="${priceListLocale}"/>
        </dsp:include>
      </td>
    </tr>
   </table>
   <br />
  
<%-- 
----------------------------------------------------------------
End Main Content
----------------------------------------------------------------
--%>

  </crs:emailPageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/orderShipped.jsp#2 $$Change: 633752 $--%>

