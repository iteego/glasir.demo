<%--
  This gadget renders the checkout login page
--%>

<dsp:page>
  
    <fmt:message key="checkout_title.checkout" var="title"/>
    <crs:checkoutContainer currentStage="login"
                           showOrderSummary="false"
                           skipSecurityCheck="true"
                           title="${title}">
      <jsp:body>
        <dsp:include page="gadgets/checkoutLogin.jsp" flush="true"/>
      </jsp:body>
    </crs:checkoutContainer>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/checkoutLoginContainer.jsp#1 $$Change: 633540 $--%>
