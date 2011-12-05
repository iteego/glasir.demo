<%--
  This gadget displays order details after checkout process
  and offers register for anonymous users
 --%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupDroplet"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler" />
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean var="originatingRequest" bean="/OriginatingRequest"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  
  <dsp:getvalueof var="contextPath" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
  
  <div id="atg_store_confirmAndRegister">
  <%-- Show Form Errors --%>
  <dsp:include page="checkoutErrorMessages.jsp">
    <dsp:param name="formhandler" bean="BillingFormHandler"/>
  </dsp:include>
  <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
    <dsp:param name="formhandler" bean="CouponFormHandler"/>
  </dsp:include>
  
  <%-- Success area --%>
  <div id="atg_store_confirmResponse">
    <h3><fmt:message key="checkout_confrimResponse.successTitle"/></h3>
    <p>
      <fmt:message key="checkout_confirmResponse.omsOrderId">
        <fmt:param>
          <span><dsp:valueof bean="ShoppingCart.last.omsOrderId"/></span>
        </fmt:param>
      </fmt:message>
      </p>
      
      <dsp:getvalueof var="confirmationEmail" bean="Profile.email"/>
      <c:if test="${not empty confirmationEmail}">
        <p>
          <fmt:message key="checkout_confrimResponse.emailText"/>
          <span><dsp:valueof value="${confirmationEmail}"/></span>
        </p>
      </c:if>
      
      <p>
      <fmt:message key="checkout_confrimResponse.printOrderLink" var="orderNumberLinkTitle"/>
      <fmt:message key="checkout_confrimResponse.printOrderText">
        <fmt:param>
          <dsp:a page="/myaccount/orderDetail.jsp" title="${orderNumberLinkTitle}">
            <dsp:param name="orderId" bean="ShoppingCart.last.id"/>
            ${orderNumberLinkTitle}
          </dsp:a>
        </fmt:param>   
      </fmt:message>
    </p>
  </div>
  
          <%-- Registration area --%>
          <dsp:form method="post" action="${originatingRequest.requestURI}"
                  id="atg_store_registration" formid="atg_store_registerForm">

            <h3><fmt:message key="checkout_confrimResponse.registerTitle"/></h3>
              
           <%-- Registration form --%>
          <dsp:include page="/myaccount/gadgets/registrationForm.jsp">
            <dsp:param name="formHandler" value="BillingFormHandler"/>
            <dsp:param name="email" value="${confirmationEmail}"/>
          </dsp:include>
          
          <%-- If registration succeeds, go to my profile page and welcome new customer there --%>
          <dsp:input bean="BillingFormHandler.registerAccountSuccessURL" type="hidden" value="${contextPath}/myaccount/profile.jsp"/>
          <%-- If registration fails, redisplay this page with errors shown --%>
          <dsp:input bean="BillingFormHandler.registerAccountErrorURL" type="hidden" value="${originatingRequest.requestURI}"/>
  
          <div class="atg_store_formActions">
          <fmt:message key="common.button.continueText" var="submitText"/>
          <span class="atg_store_basicButton">
            <dsp:input bean="BillingFormHandler.registerUser" type="submit" alt="${submitText}" value="${submitText}" />
          </span>
          </div>
  
  </dsp:form>
</div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/confirmAndRegister.jsp#2 $$Change: 635969 $--%>