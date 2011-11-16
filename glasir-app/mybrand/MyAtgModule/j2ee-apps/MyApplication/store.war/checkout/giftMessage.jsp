<%-- This page presents a form to the shopper to fill in details of the Gift Note to be sent with the 
       Shipped items. --%>

<dsp:page>
  <crs:pageContainer index="false" 
                     follow="false"
                     bodyClass="atg_store_giftMessage atg_store_checkout atg_store_rightCol">
    <jsp:body>
      <dsp:include page="/global/gadgets/orderReprice.jsp" flush="true"/>
      <dsp:form action="${originatingRequest.requestURI}" name="GiftMessageForm" method="post"
              id="atg_store_giftMessaageForm" formid="giftmessageform">
        <dsp:param name="skipCouponFormDeclaration" value="true"/>
      <fmt:message key="checkout_title.checkout" var="title"/>
      <crs:checkoutContainer currentStage="shipping"
                             showOrderSummary="true" 
                             skipSecurityCheck="true"
                             title="${title}">
        <jsp:attribute name="formErrorsRenderer">
          <dsp:importbean bean="/atg/store/order/purchase/GiftMessageFormHandler"/>
          <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
          <fmt:message key="common.button.continueText" var="submitButtonCaption"/>
          <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
            <dsp:param name="formhandler" bean="GiftMessageFormHandler"/>
            <dsp:param name="submitFieldText" value="${submitButtonCaption}"/>
          </dsp:include>
          <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
            <dsp:param name="formhandler" bean="CouponFormHandler"/>
          </dsp:include>
        </jsp:attribute>
        <jsp:body>
          <div id="atg_store_checkout" class="atg_store_gift_message">
            <dsp:include page="gadgets/giftMessage.jsp" flush="true"/>
          </div>
        </jsp:body>
      </crs:checkoutContainer>
      </dsp:form>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/giftMessage.jsp#3 $$Change: 635969 $--%>
