<%-- 
  This is the confirmation page that appears as the last step
  of the checkout process
 --%>

<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CommitOrderFormHandler"/>

  <crs:pageContainer divId="atg_store_cart" 
                     index="false" 
                     follow="false"
                     levelNeeded="CONFIRM"
                     redirectURL="../cart/cart.jsp"
                     bodyClass="atg_store_orderConfirmation atg_store_checkout atg_store_rightCol">

    <jsp:body>
      <dsp:include page="gadgets/repriceOrderTotal.jsp" flush="true">
        <dsp:param name="formhandlerComponent" value="/atg/store/order/purchase/CommitOrderFormHandler"/>
      </dsp:include>

      <fmt:message key="checkout_title.checkout" var="title"/>

      <dsp:form formid="confirmgadgetsform" action="${originatingRequest.requestURI}"  method="post">
        <dsp:param name="skipCouponFormDeclaration" value="true"/>
        <crs:checkoutContainer showOrderSummary="true" currentStage="confirm" title="${title}">
          <jsp:attribute name="formErrorsRenderer">
            <dsp:include page="gadgets/checkoutErrorMessages.jsp">
              <dsp:param name="formhandler" bean="CommitOrderFormHandler"/>
            </dsp:include>
            <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
              <dsp:param name="formhandler" bean="CouponFormHandler"/>
            </dsp:include>
          </jsp:attribute>
          <jsp:body>
          <div id="atg_store_checkout" class="atg_store_main">          
            <dsp:droplet name="/atg/dynamo/droplet/multisite/SharingSitesDroplet">
              <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
              <dsp:param name="excludeInputSite" value="true"/>
              <dsp:oparam name="output">
                <c:set var="hideSiteIndicator" value="false"/>
              </dsp:oparam>
              <dsp:oparam name="empty">
                <c:set var="hideSiteIndicator" value="true"/>
              </dsp:oparam>
            </dsp:droplet>
            <dsp:include page="/global/gadgets/orderSummary.jsp" flush="true">
              <dsp:param name="order" bean="/atg/commerce/ShoppingCart.current"/>
              <dsp:param name="isCurrent" value="true"/>
              <dsp:param name="hideSiteIndicator" value="${hideSiteIndicator}"/>
            </dsp:include>
            <div class="atg_store_confirmFooterLink">      
            <dsp:a page="/cart/cart.jsp" iclass="atg_store_modifyCart" title="">
              <fmt:message key="global_orderShippingItems.modifyCart"/>
            </dsp:a>
              </div>
          </div>
          </jsp:body>
        </crs:checkoutContainer>
      </dsp:form>  
    </jsp:body>
    
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/confirm.jsp#2 $$Change: 635969 $--%>
