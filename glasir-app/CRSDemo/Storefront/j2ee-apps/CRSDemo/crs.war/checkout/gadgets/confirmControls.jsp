<dsp:page>

  <%-- 
      This gadget renders the "cancel order" and "place order" buttons on the order-confirmation page 

      Form Condition:
      - This gadget must be contained inside of a form.
      CommitOrderFormHandler must be invoked from a submit 
      button in this form for fields in this page to be processed
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/CommitOrderFormHandler"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/CancelOrderFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="expressCheckout" param="expressCheckout"/>

  <fieldset class="atg_store_placeOrder">
    
      <%-- If user is anonymous and the session has expired, the cart looses its contents ,
           so the page gets redirected to the home page else it will be redirected to the
           checkout login page.
      --%>
      <dsp:droplet name="Compare">
        <dsp:param bean="Profile.securityStatus" name="obj1"/>
        <dsp:param bean="PropertyManager.securityStatusAnonymous" name="obj2"/>
        <dsp:oparam name="equal">
          <%-- User is anonymous --%>
          <dsp:input type="hidden" bean="CommitOrderFormHandler.sessionExpirationURL" value="${originatingRequest.contextPath}/index.jsp"/>
        </dsp:oparam>
        <dsp:oparam name="default">
          <dsp:input type="hidden" bean="CommitOrderFormHandler.sessionExpirationURL" value="${originatingRequest.contextPath}/checkout/login.jsp"/>
        </dsp:oparam>
      </dsp:droplet>
      <dsp:getvalueof bean="/OriginatingRequest.requestURI" var="errorUrl"/>
      <c:if test="${expressCheckout}">
        <c:set var="errorUrl" value="${errorUrl}?expressCheckout=true"/>
      </c:if>
      <dsp:input bean="CommitOrderFormHandler.commitOrderSuccessURL" type="hidden" value="confirmResponse.jsp"/>
      <dsp:input bean="CommitOrderFormHandler.commitOrderErrorURL" type="hidden" value="${errorUrl}"/>
<div class="atg_store_formActions">
    <div class="atg_store_actionItems">
      <fmt:message var="placeOrderButtonText" key="checkout_confirmPlaceOrder.button.placeOrderText"/>

      <span class="atg_store_basicButton">
        <dsp:input type="submit" bean="CommitOrderFormHandler.commitOrder" id="atg_store_placeMyOrderButton" value="${placeOrderButtonText}"
                   iclass="atg_store_actionSubmit"/>
      </span>
    </div>
  </div>
    
    <dsp:include page="/checkout/gadgets/confirmEmail.jsp"/>

    
    <%--
      Determines profile status and
      
      - if the profile is registered, then redirect him to orderNotPlaced.jsp and do not 
        modify order;
      - if the profile is anonymous, then invoke CancelOrderFormHandler 
        form handler to cancel the current order
     --%>
    <dsp:getvalueof var="profileSecurityStatus" vartype="java.lang.Integer" bean="Profile.securityStatus"/>
    <dsp:getvalueof var="anonymousSecurityStatus" vartype="java.lang.Integer" bean="PropertyManager.securityStatusAnonymous"/>
     
    <c:choose>
      <c:when test="${profileSecurityStatus > anonymousSecurityStatus}">
        <div id="atg_store_confirmCancel">
          <fmt:message var="cancelLinkTitle" key="checkout_confirmCancel.button.cancelTitle"/>
          <dsp:a page="/cart/orderNotPlaced.jsp" title="${cancelLinkTitle}">
            <span><fmt:message key="checkout_confirmCancel.button.cancelText"/></span>
          </dsp:a>
        </div>
      </c:when>
      <c:when test="${profileSecurityStatus == anonymousSecurityStatus}">
        <div id="atg_store_confirmCancel">
          <fmt:message var="cancelLinkTitle" key="checkout_confirmAnonCancel.button.cancelText"/>
          
          <dsp:a page="/index.jsp" title="${cancelLinkTitle}">
            <span><fmt:message key="checkout_confirmAnonCancel.button.cancelText"/></span>
            <dsp:property bean="CancelOrderFormHandler.cancelOrderSuccessURL" value="${originatingRequest.contextPath}/index.jsp"/>
            <dsp:property bean="CancelOrderFormHandler.cancelOrderErrorURL" value="${originatingRequest.requestURI}"/>
            <dsp:property bean="CancelOrderFormHandler.cancelCurrentOrder" value="submit"/>
          </dsp:a>
        </div>      
      </c:when> 
    </c:choose>
    
  </fieldset>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/confirmControls.jsp#2 $$Change: 633752 $--%>
