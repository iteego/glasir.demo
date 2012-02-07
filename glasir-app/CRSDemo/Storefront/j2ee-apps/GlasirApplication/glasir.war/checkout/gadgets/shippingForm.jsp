<%-- This gadget renders the form fields that allow the shopper to add a new shipping address.
 --%>

<dsp:page>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  
    <%-- Include hidden form params --%>        
    <dsp:include page="shippingFormParams.jsp" flush="true"/>
    
    <%-- Specify that new address will be created for shipping --%>
    <dsp:input type="hidden" bean="ShippingGroupFormHandler.shipToNewAddress" value="true"/>
    <dsp:input type="hidden" bean="ShippingGroupFormHandler.address.ownerId" beanvalue="Profile.id"/>
   
    
      <div id="atg_store_createNewShippingAddress">
     <fieldset class="atg_store_createNewShippingAddress">
        <h3><fmt:message key="checkout_shippingAddresses.createShippingAddress"/></h3>
        <dsp:include page="shippingAddressAdd.jsp"/>
      </fieldset>
      <fmt:message var="shipToButtonText" key="checkout_shippingAddresses.button.shipToThisAddress"/>
        <div class="atg_store_saveNewBillingAddress">
        <span class="atg_store_basicButton">
          <dsp:input type="submit"  bean="ShippingGroupFormHandler.createAndMoveToBilling" value="${shipToButtonText}"/>
        </span>
        </div>
      </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingForm.jsp#2 $$Change: 635969 $--%>
