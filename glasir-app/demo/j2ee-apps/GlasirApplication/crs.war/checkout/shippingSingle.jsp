<%--
  This page includes the gadgets for the shipping page for a single shipping group.
  (That is, all items will be shipped to the same shipping address)
--%>

<dsp:page>
  <crs:pageContainer divId="atg_store_cart"
                     index="false" 
                     follow="false"
                     levelNeeded="SHIPPING"
                     redirectURL="../cart/cart.jsp">
    <jsp:attribute name="bodyClass">atg_store_pageShipping atg_store_checkout atg_store_rightCol</jsp:attribute>

    <jsp:body>
      <dsp:include page="gadgets/shippingInitialize.jsp" flush="true">
        <dsp:param name="oneInfoPerUnit" value="false"/>
        <dsp:param name="initSingleShippingForm" value="true"/>
      </dsp:include>

      <dsp:form id="atg_store_checkoutShippingAddress" iclass="atg_store_checkoutOption" formid="atg_store_checkoutShippingAddress"
          action="${pageContext.request.requestURI}" method="post">
        <dsp:param name="skipCouponFormDeclaration" value="true"/>
        <fmt:message key="checkout_title.checkout" var="title"/>
        <crs:checkoutContainer currentStage="shipping"
                               showOrderSummary="true" 
                               title="${title}">
          <jsp:attribute name="formErrorsRenderer">
            <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
            <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
            <fmt:message  var="submitText" key="checkout_shippingAddresses.button.shipToThisAddress"/>
            <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
              <dsp:param name="formhandler" bean="ShippingGroupFormHandler"/>
              <dsp:param name="submitFieldText" value="${submitText}"/>
            </dsp:include>
          
            <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
              <dsp:param name="formhandler" bean="CouponFormHandler"/>
              <dsp:param name="submitFieldText" value="${submitText}"/>
            </dsp:include>
          </jsp:attribute>
          <jsp:body>
             <div id="atg_store_checkout" class="atg_store_main">
              <dsp:include page="gadgets/shippingSingleForm.jsp" flush="true"/>
            </div>
          </jsp:body>
        </crs:checkoutContainer>
      </dsp:form>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/shippingSingle.jsp#2 $$Change: 635969 $--%>
