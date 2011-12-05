<dsp:page>
<%-- This page determines if the cart is empty, and renders the appropriate gadgets --%>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  
  <%-- See how many items are in the cart --%>
  <dsp:getvalueof var="commerceItemCount" bean="ShoppingCart.current.CommerceItemCount"/>
  <c:choose>
    <c:when test='${commerceItemCount == 0}'>
      
        <%-- No items, check so see if the user is logged in --%>
        <dsp:droplet name="Compare">
          <dsp:param name="obj1" bean="Profile.securityStatus"/>
          <dsp:param name="obj2" bean="PropertyManager.securityStatusAnonymous"/>
          <dsp:oparam name="greaterthan">
            <%-- User is logged in, render "no items" page --%>
            <dsp:include page="shoppingCartMessage.jsp"/>
          </dsp:oparam>
          <dsp:oparam name="equal">
            <dsp:include page="shoppingCartAnonymousMessage.jsp"/>
          </dsp:oparam>
        </dsp:droplet>
    </c:when>
   
    <c:otherwise>     
       <dsp:input type="hidden" bean="CartFormHandler.moveToPurchaseInfoSuccessURL" value="../checkout/shipping.jsp"/>
       <dsp:input type="hidden" bean="CartFormHandler.moveToPurchaseInfoErrorURL"
                  value="${originatingRequest.requestURI}"/>
       <dsp:input type="hidden" bean="CartFormHandler.updateSuccessURL"
                  value="${originatingRequest.requestURI}"/>
       <dsp:input type="hidden" bean="CartFormHandler.updateErrorURL"
                  value="${originatingRequest.requestURI}"/>
       <dsp:input type="hidden" bean="CartFormHandler.expressCheckoutErrorURL"
                  value="${originatingRequest.requestURI}"/>

       <%-- Possible Success/Error URLs for Checkout/ExpressCheckout with/without GiftMessage --%>
       <dsp:input bean="CartFormHandler.giftMessageUrl" type="hidden"
                value="${originatingRequest.contextPath}/checkout/giftMessage.jsp"/>
       <dsp:input bean="CartFormHandler.shippingInfoURL" type="hidden"
                value="${originatingRequest.contextPath}/checkout/shipping.jsp"/>
       <dsp:input bean="CartFormHandler.loginDuringCheckoutURL" type="hidden"
                value="${originatingRequest.contextPath}/checkout/login.jsp"/>
       <dsp:input bean="CartFormHandler.confirmationURL" type="hidden"
                value="${originatingRequest.contextPath}/checkout/confirm.jsp?expressCheckout=true"/>

       <%-- URLs for the RichCart AJAX response. Renders cart contents as JSON --%>
       <dsp:input bean="CartFormHandler.ajaxAddItemToOrderSuccessUrl" type="hidden"
                value="${originatingRequest.contextPath}/cart/json/cartContents.jsp"/>
       <dsp:input bean="CartFormHandler.ajaxAddItemToOrderErrorUrl" type="hidden"
                value="${originatingRequest.contextPath}/cart/json/errors.jsp"/>
 
        <%-- This gadget is used to display cartItems information and relative operations (such as delete etc.) --%>
        <dsp:include page="cartItems.jsp" flush="true"/>
       
        <div class="order_details">
          <dsp:include page="giftWrap.jsp" flush="true"/>
        </div>
    </c:otherwise>
  </c:choose>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/cartContents.jsp#2 $$Change: 635969 $--%>