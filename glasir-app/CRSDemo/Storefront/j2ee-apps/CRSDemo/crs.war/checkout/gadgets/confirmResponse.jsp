<dsp:page>

<%-- This gadget renders the "thank you" message at the end of the checkout process --%>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupDroplet"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%-- clears out and left overs in the session scoped containers from the previous order --%>
  <dsp:droplet name="ShippingGroupDroplet">
    <dsp:param name="clear" value="true"/>
    <dsp:oparam name="output"/>
  </dsp:droplet>
<div class="atg_store_generalMessageContainer">
  <div id="atg_store_confirmResponse" class="atg_store_generalMessage">
    <h3><fmt:message key="checkout_confrimResponse.successTitle"/></h3>
    
    <p>
      <fmt:message var="orderNumberLinkTitle" key="checkout_confirmResponse.orderNumberLinkTitle"/>
      <fmt:message key="checkout_confirmResponse.omsOrderId">
        <fmt:param>
          <dsp:a page="/myaccount/orderDetail.jsp" title="${orderNumberLinkTitle}">
            <dsp:param name="selpage" value="MY ORDERS"/>
            <dsp:param name="orderId" bean="ShoppingCart.last.id"/>
            <dsp:valueof bean="ShoppingCart.last.omsOrderId"/>
          </dsp:a>
        </fmt:param>
      </fmt:message>
    </p>
    
    <p>
      <fmt:message key="checkout_confrimResponse.emailText"/>
      <span><dsp:valueof bean="Profile.email"/></span>
    </p>
    
    <p>
      <fmt:message key="checkout_confirmResponse.reviewOrderIdLink" var="ordersMenuTitle"/>
      <fmt:message key="checkout_confirmResponse.reviewOrderId">
        <fmt:param>
          <dsp:a page="/myaccount/myOrders.jsp" title="${ordersMenuTitle}">
            <dsp:param name="selpage" value="MY ORDERS"/>
            ${ordersMenuTitle}
          </dsp:a>
        </fmt:param>
      </fmt:message>
    </p>
  </div>
  </div>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/confirmResponse.jsp#2 $$Change: 635969 $--%>
