<%-- This page renders the form where a user can add a shipping address --%>

<dsp:page>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <div class="atg_store_checkoutOption">
    
    <dsp:form action="${originatingRequest.requestURI}" method="post" id="atg_store_checkoutAddAddress"
      formid="shippingaddressaddform">
      <fieldset class="atg_store_checkoutAddAddressFormFields">
        <dsp:input type="hidden" bean="ShippingGroupFormHandler.addShippingAddressSuccessURL" value="shippingMultiple.jsp"/>
        <dsp:input type="hidden" bean="ShippingGroupFormHandler.addShippingAddressErrorURL" value="shippingAddressAdd.jsp?preFillValues=true"/>
        <dsp:input type="hidden" bean="ShippingGroupFormHandler.cancelURL" value="shippingMultiple.jsp"/>
        <dsp:input type="hidden" bean="ShippingGroupFormHandler.address.email" beanvalue="Profile.email"/>

        <div id="atg_store_shippingInformation">
          <h2><fmt:message key="myaccount_addressEdit.newAddress"/></h2>
          <dsp:include page="shippingAddressAdd.jsp"/>
        </div>
      </fieldset>

      <fieldset>
        <div class="atg_store_formFooter">
          <fmt:message var="cancelButtonText" key="common.button.cancelText"/>
          <fmt:message var="saveButtonText" key="common.button.saveText"/>
          <div class="atg_store_formActions">
            <div class="atg_store_formActionItem">
             <span class="atg_store_basicButton">
               <dsp:input type="submit" bean="ShippingGroupFormHandler.addShippingAddress" value="${saveButtonText}"/>
             </span>
             </div>
            <div class="atg_store_formActionItem">
            <span class="atg_store_basicButton secondary">
              <dsp:input type="submit" bean="ShippingGroupFormHandler.cancel" value="${cancelButtonText}"/>
            </span>
            </div>
 
          </div>
        </div>
      </fieldset>    
    </dsp:form>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingAddressAddForm.jsp#2 $$Change: 635969 $--%>
