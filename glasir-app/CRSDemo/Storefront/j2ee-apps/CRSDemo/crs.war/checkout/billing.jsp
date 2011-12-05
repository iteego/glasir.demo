<%-- 
  This page includes the gadgets for the billing page during the checkout process
--%>

<dsp:page>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart" />
  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler" />
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
    
  <crs:pageContainer divId="atg_store_cart" 
                     index="false" 
                     follow="false" 
                     bodyClass="atg_store_pageBilling atg_store_checkout atg_store_rightCol"
                     levelNeeded="BILLING"
                     redirectURL="../cart/cart.jsp">
    <jsp:body>
      <%-- Apply available store credits to the order  --%>
      <dsp:setvalue bean="BillingFormHandler.applyStoreCreditsToOrder" value=""/>
      
      <dsp:include page="gadgets/storeCreditPayment.jsp"/>
      <dsp:setvalue param="storeCreditAmount" value="${storeCreditAmount}"/>
      
      <dsp:form id="atg_store_checkoutBilling" formid="atg_store_checkoutBilling"
          action="${pageContext.request.requestURI}" method="post">
        <dsp:param name="skipCouponFormDeclaration" value="true"/>
      <fmt:message key="checkout_title.checkout" var="title"/>
      <crs:checkoutContainer currentStage="billing"
                             title="${title}"
                             showOrderSummary="true">
        <jsp:attribute name="formErrorsRenderer">
          <fmt:message var="submitFieldText" key="common.button.continueText"/>
          <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
            <dsp:param name="formhandler" bean="BillingFormHandler"/>
            <dsp:param name="submitFieldText" value="${submitFieldText}"/>
          </dsp:include>
          <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
            <dsp:param name="formhandler" bean="CouponFormHandler"/>
            <dsp:param name="submitFieldText" value="${submitFieldText}"/>
          </dsp:include>
        </jsp:attribute>
        <jsp:body>
        <div id="atg_store_checkout" class="atg_store_main">
          <dsp:droplet name="Compare">
            <%-- Don't offer enter credit card's info if order's total is 0.0 --%>
            <dsp:param name="obj1" bean="ShoppingCart.current.priceInfo.total" />
            <dsp:param name="obj2" value="${storeCreditAmount}" number="0.0" />
            <dsp:oparam name="greaterthan">
              <dsp:include page="gadgets/billingForm.jsp" flush="true"/>
            </dsp:oparam>
            <dsp:oparam name="default">
              <div class="atg_store_zeroBalance">
                <h3>
                  <fmt:message key="checkout_billing.yourOrderTotal"/>
                  <dsp:include page="/global/gadgets/formattedPrice.jsp">
                    <dsp:param name="price" value="0"/>
                  </dsp:include>
                </h3>
                <p><fmt:message key="checkout_billing.yourOrderTotalMessage"/></p>
                <dsp:input bean="BillingFormHandler.moveToConfirmSuccessURL" type="hidden" value="confirm.jsp"/>
                <span class="atg_store_basicButton">
                  <fmt:message var="caption" key="common.button.continueText"/>
                  <dsp:input bean="BillingFormHandler.billingWithStoreCredit" type="submit" value="${caption}"/>
                </span>
              </div>
            </dsp:oparam>
            
          </dsp:droplet>
        </div>
        </jsp:body>
      </crs:checkoutContainer>
      </dsp:form>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/billing.jsp#2 $$Change: 635969 $--%>
