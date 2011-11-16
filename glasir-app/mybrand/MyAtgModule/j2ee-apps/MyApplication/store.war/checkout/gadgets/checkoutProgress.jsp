<%-- 
  This gadget displays the checkout steps, indicating which have been completed.
  
  We provide the following combinations:
    - Login
    - Register
    - 1.Shipping 2.Billing 3.Confirm
--%>

<dsp:page>
  <ol class="atg_store_checkoutNav">
    <%-- Selected step --%>
    <dsp:getvalueof var="currentStage" vartype="java.lang.String" param="currentStage" />
    <c:choose>
      <c:when test="${currentStage == 'login'}">
        <fmt:message key="checkout_checkoutProgress.login" var="description"/>
        <dsp:include page="checkoutProgressStep.jsp">
          <dsp:param name="cssClass" value="login current"/>
          <dsp:param name="stepDescription" value="${description}"/>
        </dsp:include>
      </c:when>
      <c:when test="${currentStage == 'register'}">
        <fmt:message key="checkout_checkoutProgress.register" var="description"/>
        <dsp:include page="checkoutProgressStep.jsp">
          <dsp:param name="cssClass" value="register current"/>
          <dsp:param name="stepDescription" value="${description}"/>
        </dsp:include>
      </c:when>
      <c:when test="${currentStage == 'shipping' || currentStage == 'billing' || currentStage == 'confirm'}">
        <fmt:message key="checkout_checkoutProgress.shipping" var="shippingDescription"/>
        <fmt:message key="checkout_checkoutProgress.billing" var="billingDescription"/>
        <fmt:message key="checkout_checkoutProgress.confirm" var="confirmDescription"/>
        
        <dsp:include page="checkoutProgressStep.jsp">
          <dsp:param name="cssClass" value="shipping${currentStage == 'shipping' ? ' current' : ''}"/>
          <dsp:param name="step" value="1"/>
          <dsp:param name="stepDescription" value="${shippingDescription}"/>
        </dsp:include>
        
        <dsp:include page="checkoutProgressStep.jsp">
          <dsp:param name="cssClass" value="billing${currentStage == 'billing' ? ' current' : ''}"/>
          <dsp:param name="step" value="2"/>
          <dsp:param name="stepDescription" value="${billingDescription}"/>
        </dsp:include>
        
        <dsp:include page="checkoutProgressStep.jsp">
          <dsp:param name="cssClass" value="confirm${currentStage == 'confirm' ? ' current' : ''}"/>
          <dsp:param name="step" value="3"/>
          <dsp:param name="stepDescription" value="${confirmDescription}"/>
        </dsp:include>
      </c:when>
    </c:choose>
  </ol>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/checkoutProgress.jsp#2 $$Change: 635969 $--%>