<%--
  This page includes the gadgets for the select shipping method page for a single shipping group.
  (That is, all items will be shipped to the same shipping address)
--%>

<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  
  <crs:pageContainer divId="atg_store_cart"
                     index="false" 
                     follow="false"
                     levelNeeded="SHIPPING"
                     redirectURL="../cart/cart.jsp">
    <jsp:attribute name="bodyClass">atg_store_pageShipping atg_store_checkout atg_store_rightCol</jsp:attribute>


    <jsp:body>
      <dsp:form id="atg_store_checkoutShippingMethod" iclass="atg_store_checkoutOption" formid="atg_store_checkoutShippingAddress"
          action="${pageContext.request.requestURI}" method="post">
        <dsp:param name="skipCouponFormDeclaration" value="true"/>
      <fmt:message key="checkout_title.checkout" var="title"/>
      <crs:checkoutContainer currentStage="shipping"
                               showOrderSummary="true" 
                               title="${title}">
        <jsp:attribute name="formErrorsRenderer">
          <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
            <dsp:param name="formhandler" bean="ShippingGroupFormHandler"/>
          </dsp:include>
          <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
            <dsp:param name="formhandler" bean="CouponFormHandler"/>
          </dsp:include>
        </jsp:attribute>
        <jsp:body>
          <div id="atg_store_checkout" class="atg_store_main"> 
            
            <%-- Check if there are any not gift shipping groups --%>
            <dsp:getvalueof var="anyHardgoodShippingGroups" vartype="java.lang.String" 
                bean="ShippingGroupFormHandler.anyHardgoodShippingGroups"/>
                
            <c:if test='${anyHardgoodShippingGroups == "true"}'>
                <%-- Include hidden form params --%>
                <dsp:include page="/checkout/gadgets/shippingFormParams.jsp" flush="true"/>
                
                <%-- Include available shipping methods --%> 
                <dsp:include page="gadgets/shippingOptions.jsp"/>
                
                <%-- Submit button --%>
                <fmt:message var="continueButtonText" key="common.button.continueText"/>
                <div class="atg_store_formActions">
                <span class="atg_store_basicButton">
                  <dsp:input type="submit"  bean="ShippingGroupFormHandler.updateShippingMethod" value="${continueButtonText}"/>
                </span>
                </div>
            </c:if>
          </div>
        </jsp:body>
      </crs:checkoutContainer>
      </dsp:form>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/shippingMethod.jsp#2 $$Change: 635969 $--%>
