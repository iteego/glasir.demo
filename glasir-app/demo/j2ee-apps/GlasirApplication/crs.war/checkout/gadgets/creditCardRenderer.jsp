<dsp:page>
  <dsp:importbean bean="/atg/commerce/util/PlaceLookup" />
  <dsp:importbean bean="/atg/commerce/util/MasterCountryList" />
  <dsp:importbean bean="/atg/store/droplet/CountryListDroplet" />
  <dsp:importbean bean="/atg/store/order/purchase/CommitOrderFormHandler"/>

      <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>      
      
      <dd class="vcard">
        
        <div>
          <strong><dsp:valueof param="creditCard.creditCardType"/></strong>
          <fmt:message key="global_displayCreditCard.endingIn"/>
          <%-- display only last 4 digits --%>
          
          <dsp:getvalueof var="creditCard" param="creditCard.creditCardNumber" />
          <strong><c:out value="${fn:substring(creditCard,fn:length(creditCard)-4,fn:length(creditCard))}"/></strong>
        </div>
        <div>
          <fmt:message key="checkout_creditCards.expiration" />:&nbsp;<dsp:valueof param="creditCard.expirationMonth" />/<dsp:valueof param="creditCard.expirationYear" /><br />
        </div>
        <div class="fn">
          <dsp:valueof param="creditCard.billingAddress.firstName" />
          <dsp:valueof param="creditCard.billingAddress.lastName" />
        </div>
        <div class="adr">
          <fmt:message key="checkout_confirmPaymentOptions.billTo"/>:&nbsp;<dsp:valueof param="creditCard.billingAddress.address1" />
        </div>
      </dd>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/creditCardRenderer.jsp#2 $$Change: 635969 $--%>