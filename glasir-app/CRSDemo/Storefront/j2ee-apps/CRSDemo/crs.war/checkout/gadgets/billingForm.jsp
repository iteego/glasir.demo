<%--
    This page renders the billing form
--%>

<dsp:page>
  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler" />
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/store/droplet/EnsureCreditCard"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupDroplet"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/order/purchase/CheckoutOptionSelections"/>  

  <dsp:getvalueof var="isTransient" bean="Profile.transient"/>
  <dsp:getvalueof var="checkoutOption" vartype="java.lang.String" bean="CheckoutOptionSelections.checkoutOption"/>

  <dsp:droplet name="ShippingGroupDroplet">
    <dsp:param name="createOneInfoPerUnit" value="true"/>
    <dsp:param name="clearShippingInfos" value="true"/>
    <dsp:param name="shippingGroupTypes" value="hardgoodShippingGroup"/>
    <dsp:param name="initShippingGroups" value="true"/>
    <dsp:param name="initBasedOnOrder" value="true"/>
    <dsp:oparam name="output"/>
  </dsp:droplet>

  <dsp:droplet name="EnsureCreditCard">
    <dsp:param name="order" bean="ShoppingCart.current"/>
  </dsp:droplet>

  <dsp:getvalueof var="savedAddresses" bean="Profile.secondaryAddresses"></dsp:getvalueof>
    <div class="${!empty savedAddresses?'atg_store_existingAddresses ':''}atg_store_checkoutOption"       
         id="atg_store_checkoutOptionArea">
  
      <input id="cntFlag" type="hidden" value="select" />

      <%-- Retrieve saved credit cards --%>
      <dsp:getvalueof var="creditCards" vartype="java.lang.Object" bean="Profile.creditCards"/>

      <c:if test="${!empty creditCards}">
        <c:if test="${storeCreditAmount >0}">
          <div class="atg_store_appliedStoreCredit">
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${storeCreditAmount }"/>
            </dsp:include>
            <fmt:message key="checkout_billing.storeCreditApplied"/>
          </div>
        </c:if>
        <h2 class="atg_store_usedSavedCardHeader"><fmt:message key="checkout_billing.useSavedCreditCard"/></h2>
        <%-- Get the last user's choice whether profile's saved credit cards to use or 
             new credit card to create --%>
        <dsp:getvalueof var="usingProfileCreditCard" bean="BillingFormHandler.usingProfileCreditCard"/>

        <%-- Tab with a list of saved credit cards and addresses --%>
        <fieldset class="atg_store_savedCreditCard">
           <dsp:include page="savedCreditCards.jsp" flush="true" />
        </fieldset>
      </c:if>

        
      <fieldset class="atg_store_creditCardForm">
        <h2><fmt:message key="checkout_billing.newCreditCard"/></h2>
        <%-- New credit card form --%>
        
          <dsp:include page="creditCardForm.jsp" flush="true" />
        </fieldset>

        <%-- Show this only if we have saved secondary addresses --%>
        <dsp:getvalueof var="secondaryAddresses" vartype="java.lang.Object" bean="Profile.secondaryAddresses"/>
        <dsp:getvalueof var="usingSavedAddress" bean="BillingFormHandler.usingSavedAddress"/>
   
    <div id="atg_store_chooseCardAddress">
        <c:if test="${not empty secondaryAddresses}">
          <div id="atg_store_selectAddress">
          <h3><fmt:message key="checkout_billing.useSavedAddresses"/></h3>
          <fieldset class="atg_store_billingAddresses">
            <dsp:include page="billingAddressSelect.jsp" flush="true"/>
          </fieldset>
          </div>
        </c:if>
      <div id="atg_store_enterNewBillingAddress">
        <h3><fmt:message key="checkout_billing.newBillingAddress"/></h3>
        <dsp:include page="billingAddressAdd.jsp" flush="true"/>
      </div>

    </div>
    
    <%-- Action buttons --%>
    <fieldset class="atg_store_checkoutContinue">
      <dsp:include page="billingFormControls.jsp" flush="true" />
    </fieldset>
    
       </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/billingForm.jsp#1 $$Change: 633540 $--%>
