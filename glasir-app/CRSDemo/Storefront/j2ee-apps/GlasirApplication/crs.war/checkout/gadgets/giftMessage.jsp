<%-- This gadget displays the form that allows the shopper to add a gift message to the order --%>

<dsp:page>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/profile/RequestBean"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/GiftMessageFormHandler"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>

  <%-- Need to pass a page param here. If the user is going through
      express checkout, then we need to forward them to the confirm
      page and not shipping. --%>
  <dsp:getvalueof id="expressCheckout" idtype="java.lang.Boolean" value="${false}"/>
  <dsp:getvalueof id="expressCheckoutParam" param="${express}"/>
  <dsp:getvalueof id="giftMessageTo" bean="ShoppingCart.current.specialInstructions.giftMessageTo"/> 
  <dsp:getvalueof id="giftMessageFrom" bean="ShoppingCart.current.specialInstructions.giftMessageFrom"/> 
  <dsp:getvalueof id="giftMessage" bean="ShoppingCart.current.specialInstructions.giftMessage"/>
  
  <c:if test="${(not empty expressCheckoutParam)&&(expressCheckoutParam)}">
    <c:set var="expressCheckout" value="true"/>
  </c:if>
  <fmt:message var="addMessageButtonText" key="common.button.continueText"/>

  <%-- Prefill the form if we have values --%>
  <c:if test="${not empty giftMessageTo}">
    <dsp:setvalue bean="GiftMessageFormHandler.giftMessageTo"
                  beanvalue="ShoppingCart.current.specialInstructions.giftMessageTo"/>
  </c:if>
  
  <c:if test="${not empty giftMessageFrom}">
    <dsp:setvalue bean="GiftMessageFormHandler.giftMessageFrom"
                  beanvalue="ShoppingCart.current.specialInstructions.giftMessageFrom"/>
  </c:if>

  <c:if test="${not empty giftMessage}">
    <dsp:setvalue bean="GiftMessageFormHandler.giftMessage"
                  beanvalue="ShoppingCart.current.specialInstructions.giftMessage"/>
  </c:if>
<div class="atg_store_checkoutOption">
  
      <dsp:input type="hidden" bean="GiftMessageFormHandler.addGiftMessageErrorURL"
                 beanvalue="/OriginatingRequest.requestURI"/>
      <h3>
       <fmt:message key="checkout_giftMessage.title" />
    </h3>
     <ul class="atg_store_basicForm atg_store_addGiftNote">
       <li>
         <label for="atg_store_messageToInput" class="required">
           <fmt:message key="common.to"/></label>
                 <dsp:input type="text" bean="GiftMessageFormHandler.giftMessageTo" name="messageTo"
                      id="atg_store_messageToInput"  iclass="required" required="true" maxlength="100"/>
      </li>
      <li>
         <label for="atg_store_messageFromInput" class="required">
              <fmt:message key="common.from"/>
         </label>
           <dsp:input type="text" bean="GiftMessageFormHandler.giftMessageFrom" name="messageFrom"
                      id="atg_store_messageFromInput"  iclass="required" required="true" maxlength="100"/>
         </li>
         <li>
           <label for="atg_store_messageInput" class="required">
               <fmt:message key="checkout_giftMessage.note"/>
           </label>
            <dsp:textarea bean="GiftMessageFormHandler.giftMessage"  iclass="required" cols="30" rows="5" name="giftmessage"/> 
            <span class="example">
              <fmt:message key="checkout_giftMessage.noteLengthCaption"/>
            </span>
          </li></ul>

      <%-- Begin 'Add gift message and continue' --%>
      <dsp:droplet name="Compare">
        <dsp:param bean="Profile.securityStatus" name="obj1" converter="number"/>
        <dsp:param bean="PropertyManager.securityStatusLogin" name="obj2" converter="number"/>
        <dsp:oparam name="lessthan">
          <%-- User is not logged in, send to login page --%>
          <dsp:input type="hidden" bean="GiftMessageFormHandler.addGiftMessageSuccessURL" value="../checkout/login.jsp"/>
        </dsp:oparam>
        <dsp:oparam name="default">
          <%-- User is logged in, figure out if they are express checkout or just editing gift message--%>
          <dsp:getvalueof var="express" vartype="java.lang.String" param="express"/>
          <dsp:getvalueof var="editMessage" vartype="java.lang.String" param="editMessage"/>
          <%-- User is logged in, so figure out if they are express checkout --%>
          <c:choose>
            <c:when test='${express == "true"}'>
              <%-- User is in express checkout, head to confirm page --%>
              <%-- Using a String here instead of Boolean. Mysterious issues setting a Boolean in form submit --%>
              <dsp:input type="hidden" bean="GiftMessageFormHandler.expressCheckout" value="true"/>
              <dsp:input type="hidden" bean="GiftMessageFormHandler.addGiftMessageSuccessURL"
                         value="../checkout/confirm.jsp?expressCheckout=true"/>
            </c:when>
            <c:otherwise>
              <c:choose>
                <c:when test='${editMessage == "true"}'>
                  <%-- user is simply editing gift message, head to confirm page --%>
                  <dsp:input type="hidden" bean="GiftMessageFormHandler.addGiftMessageSuccessURL"
                             value="../checkout/confirm.jsp"/>
                </c:when>
                <c:otherwise>
                  <%-- user is not in express checkout, nor editing gift message, go to shipping page --%>
                  <dsp:input type="hidden" bean="GiftMessageFormHandler.addGiftMessageSuccessURL"
                           value="../checkout/shipping.jsp"/>
                </c:otherwise>
              </c:choose>
            </c:otherwise>
          </c:choose>
        </dsp:oparam>
      </dsp:droplet>

      <%--If user is anonymous and the session has expired, the cart looses its contents ,
              so the page gets redirected to the home page else it will be redirected to the
              checkout login page.
      --%>
      <dsp:droplet name="Compare">
        <dsp:param bean="Profile.securityStatus" name="obj1"/>
        <dsp:param bean="PropertyManager.securityStatusAnonymous" name="obj2"/>
        <dsp:oparam name="equal">
          <%-- User is anonymous --%>
          <dsp:input type="hidden" bean="GiftMessageFormHandler.sessionExpirationURL" value="${originatingRequest.contextPath}/index.jsp"/>
        </dsp:oparam>
        <dsp:oparam name="default">
          <dsp:input type="hidden" bean="GiftMessageFormHandler.sessionExpirationURL" value="login.jsp"/>
        </dsp:oparam>
      </dsp:droplet>

    <div class="atg_store_formFooter">
      <div class="atg_store_formKey">
        <span class="required">* <fmt:message key="common.requiredFields"/></span>
      </div>
      <div class="atg_store_giftMessage_AddMessage">
        <span class="atg_store_basicButton">
        <dsp:input type="submit" bean="GiftMessageFormHandler.addGiftMessage" id="atg_store_messageSubmitInput"
                   value="${addMessageButtonText}"/>
        </span>
     

      <%--
         If user has no items in cart, then show "Continue Shopping" button,
         otherwise, allow user to proceed. Again, set success URL based
        on whether the user is logged in or not.
      --%>
      <dsp:getvalueof var="commerceItemCount" vartype="java.lang.String" bean="ShoppingCart.current.commerceItemCount"/>
     
        <%-- If user doesn't have any items in cart, then force them to add items to cart
             before checking out. --%>
      <c:if test='${commerceItemCount == "0"}'>
        <crs:continueShopping>
          <dsp:input type="hidden" bean="CartFormHandler.cancelURL"
                      value="${continueShoppingURL}"/>
        </crs:continueShopping>
        <fmt:message key="common.button.continueShoppingText" var="continueShopping"/>
        <dsp:input type="submit" bean="CartFormHandler.cancel" value="${continueShopping}"
                    iclass="atg_store_button"/>
      </c:if>
    </div>
  </div>
</div>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/giftMessage.jsp#2 $$Change: 635969 $--%>
