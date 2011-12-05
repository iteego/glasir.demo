<dsp:page>

  <%-- 
      This gadget allows the user to specify a new billing address on the billing checkout page 

      Form Condition:
      - This gadget must be contained inside of a form.
        BillingFormHandler must be invoked from a submit 
        button in this form for fields in this page to be processed
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CheckoutOptionSelections"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>

  <%--Prefill billing address value --%>
  <dsp:getvalueof var="prefillAddress" vartype="java.lang.String" bean="CheckoutOptionSelections.prefillBillingAddress"/>

  <c:choose>
    <c:when test='${prefillAddress == "true" or defaultError}'>
      <dsp:getvalueof var="prefill" vartype="java.lang.Boolean" value="true"/>
    </c:when>
    <c:when test='${prefillAddress == "false" and !defaultError}'>
      <dsp:getvalueof var="prefill" vartype="java.lang.Boolean" value="false"/>
    </c:when>
  </c:choose>
  
  <fieldset class="atg_store_newBillingAddress">

  <ul class="atg_store_basicForm atg_store_addNewAddress">

    <dsp:include page="/global/gadgets/addressAddEdit.jsp">
      <dsp:param name="formhandlerComponent" value="/atg/store/order/purchase/BillingFormHandler.creditCard.billingAddress"/>
      <dsp:param name="checkForRequiredFields" value="false"/>
      <dsp:param name="hideNameFields" value="false"/>
      <dsp:param name="preFillValues" value="${prefill}"/>
      <dsp:param name="restrictionDroplet" value="/atg/store/droplet/BillingRestrictionsDroplet"/>
    </dsp:include>
    
    <%-- If the shopper is transient (a guest shopper) we don't offer to save the address --%>
    <dsp:getvalueof var="transient" bean="Profile.transient"/>
    
    <%-- Save this address checkbox. Hide if the profile is transient --%>
    <c:choose>
      <c:when test="${transient == 'true'}">
        <li class="last option" style="display:none;">
        <c:set var="showSaveAddress" value="false"/>
      </c:when>
      <c:otherwise>
        <li class="last option">
        <c:set var="showSaveAddress" value="true"/>
      </c:otherwise>
    </c:choose>
    
      <label for="atg_store_addressAddSaveAddressInput">
                  <dsp:input type="checkbox" name="atg_store_addressAddSaveAddressInput"
                    id="atg_store_addressAddSaveAddressInput" checked="${showSaveAddress}"
                    bean="BillingFormHandler.saveBillingAddress"/>
          </label>
          <span><fmt:message key="checkout_addressAdd.saveAddress"/></span>
    </li>
    
  </ul>
  </fieldset>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/billingAddressAdd.jsp#3 $$Change: 635969 $--%>