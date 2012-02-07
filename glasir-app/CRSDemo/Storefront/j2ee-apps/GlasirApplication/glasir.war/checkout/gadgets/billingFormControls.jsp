<dsp:page>

  <%-- 
      This gadget renders the submit button on the billing information checkout page

      Form Condition:
      - This gadget must be contained inside of a form.
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  
  <div class="atg_store_formFooter">
    <%-- If user is anonymous and the session has expired, the cart looses its contents ,
         so the page gets redirected to the home page else it will be redirected to the
         checkout login page.
    --%>
    <dsp:droplet name="Compare">
      <dsp:param bean="Profile.securityStatus" name="obj1"/>
      <dsp:param bean="PropertyManager.securityStatusAnonymous" name="obj2"/>
      <dsp:oparam name="equal">
        <%-- User is anonymous --%>
        <dsp:input type="hidden" bean="BillingFormHandler.sessionExpirationURL" value="${originatingRequest.contextPath}/index.jsp"/>
      </dsp:oparam>
      <dsp:oparam name="default">
        <dsp:input type="hidden" bean="BillingFormHandler.sessionExpirationURL" value="${originatingRequest.contextPath}/checkout/login.jsp"/>
      </dsp:oparam>
    </dsp:droplet>

    <dsp:input type="hidden" bean="BillingFormHandler.moveToConfirmSuccessURL" value="confirm.jsp"/>
    <dsp:input type="hidden" bean="BillingFormHandler.moveToConfirmErrorURL" value="billing.jsp?preFillValues=true"/>

    <fmt:message var="reviewOrderButtonText" key="common.button.continueText"/>
    
    <%-- Continue with existing address --%>
    <dsp:getvalueof var="secondaryAddresses" vartype="java.lang.Object" bean="Profile.secondaryAddresses"/>
    <c:if test="${not empty secondaryAddresses}">
   <div class="atg_store_saveSelectAddress">
    <span class="atg_store_basicButton">
      <dsp:input type="submit" bean="BillingFormHandler.billingWithSavedAddressAndNewCard" value="${reviewOrderButtonText}" alt="${reviewOrderButtonText}"
                 id="submit" iclass="atg_store_actionSubmit atg_behavior_disableOnClick" />
    </span>
    
    <p><fmt:message key="checkout_billing.usingSavedAddress"/></p>
    </div>
    </c:if>
    
    <%-- Continue with new address --%>
    <div class="atg_store_saveNewBillingAddress">
    <span class="atg_store_basicButton">
      <dsp:input type="submit" bean="BillingFormHandler.billingWithNewAddressAndNewCard" value="${reviewOrderButtonText}" alt="${reviewOrderButtonText}"
                 id="submit" iclass="atg_store_actionSubmit atg_behavior_disableOnClick" />
    </span>
    <p><fmt:message key="checkout_billing.usingNewAddress"/></p>
    </div>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/billingFormControls.jsp#2 $$Change: 635969 $--%>
