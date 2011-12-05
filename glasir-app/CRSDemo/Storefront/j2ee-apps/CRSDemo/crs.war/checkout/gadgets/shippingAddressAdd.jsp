<dsp:page>

  <%-- 
      This gadget renders the form fields that allow the shopper to add a new shipping address.

      Form Condition:
      - This gadget must be contained inside of a form.
        ShippingGroupFormHandler must be invoked from a submit 
        button in this form for fields in this page to be processed
  --%>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/atg/store/order/purchase/CheckoutOptionSelections"/>

  <ul class="atg_store_basicForm atg_store_addNewAddress">
    <li class="nickname">
      <label for="nickname">
        <fmt:message key="common.nicknameThisAddress"/>
      </label>
    
      <dsp:input type="text" name="atg_store_nickNameInput" id="atg_store_nickNameInput" maxlength="42"
                 bean="ShippingGroupFormHandler.newShipToAddressName"/>
    </li>
    
  <c:choose>
    <c:when test="${empty param.preFillValues}">
      <dsp:getvalueof var="preFillValuesVar" bean="CheckoutOptionSelections.prefillShippingAddress" vartype="java.lang.Boolean"/>
    </c:when>
    <c:otherwise>
      <dsp:getvalueof var="preFillValuesVar" value="${param.preFillValues}" vartype="java.lang.Boolean"/>
    </c:otherwise>
  </c:choose>
    
   <dsp:include page="/global/gadgets/addressAddEdit.jsp">
      <dsp:param name="formhandlerComponent" value="/atg/commerce/order/purchase/ShippingGroupFormHandler.address"/>
      <dsp:param name="checkForRequiredFields" value="false"/>
      <dsp:param name="preFillValues" value="${preFillValuesVar}"/>
      <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
    </dsp:include>
    
    <%-- If the shopper is transient (a guest shopper) we don't offer to save the address, but save it silently instead --%>
    <dsp:getvalueof var="transient" vartype="java.lang.Boolean" bean="Profile.transient"/>
    
    <%-- Save this address checkbox. Hide if the profile is transient --%>
    <c:choose>
      <c:when test="${transient}">
        <dsp:input bean="ShippingGroupFormHandler.saveShippingAddress" value="true" type="hidden"
            name="atg_store_addressAddSaveAddressInput" id="atg_store_addressAddSaveAddressInput"/>
      </c:when>
      <c:otherwise>
        <li class="last option">
          <label for="atg_store_addressAddSaveAddressInput">
            <dsp:input type="checkbox" name="atg_store_addressAddSaveAddressInput"
                id="atg_store_addressAddSaveAddressInput" checked="true"
                bean="ShippingGroupFormHandler.saveShippingAddress"/>
          </label>
          <span><fmt:message key="checkout_addressAdd.saveAddress"/></span>
        </li>
      </c:otherwise>
    </c:choose>
  </ul>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingAddressAdd.jsp#3 $$Change: 635969 $--%>
