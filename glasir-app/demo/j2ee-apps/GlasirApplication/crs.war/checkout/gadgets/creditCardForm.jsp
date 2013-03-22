<dsp:page>

  <%-- 
      This gadget renders the form for a user to enter a new credit card on the billing page

      Form Condition:
      - This gadget must be contained inside of a form.
        BillingFormHandler must be invoked from a submit 
        button in this form for fields in this page to be processed
  --%>

  <dsp:importbean bean="/atg/store/StoreConfiguration"/>
  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CheckoutOptionSelections"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%--Prefill credit card value --%>
  <dsp:getvalueof var="prefillCreditCard" vartype="java.lang.String" bean="CheckoutOptionSelections.prefillCreditCard"/>
  <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>

  <c:choose>
    <c:when test='${prefillCreditCard == "true" or defaultError}'>
      <dsp:getvalueof var="prefill" vartype="java.lang.Boolean" value="true"/>
    </c:when>
    <c:when test='${prefillCreditCard == "false" && !defaultError}'>
      <dsp:getvalueof var="prefill" vartype="java.lang.Boolean" value="false"/>
    </c:when>
  </c:choose>

  <%-- Credit Card Nickname Input --%>
  <ul class="atg_store_basicForm atg_store_addNewCreditCard">
    <li>
      <label for="card_nickname" class="atg_store_cardNickName">
         <fmt:message key="common.nicknameThisCard"/>
      </label>
      <c:if test="${prefill}">
        <dsp:input bean="BillingFormHandler.creditCardNickName" type="text" maxlength="42" id="atg_store_nickNameInput"/>
      </c:if>
      <c:if test="${!prefill}">
        <dsp:input bean="BillingFormHandler.creditCardNickname" type="text" maxlength="42" id="atg_store_nickNameInput" value=""/>
      </c:if>
    </li>
    
    
    <%-- Credit Card Type Input --%>
    <c:if test="${prefill}">
      <dsp:getvalueof var="nodefault" vartype="java.lang.String" value="false"/>
    </c:if>
    <c:if test="${!prefill}">
      <dsp:getvalueof var="nodefault" vartype="java.lang.String" value="true"/>
    </c:if>
    <li class="atg_store_cardType">
    <label for="card_type">
      <fmt:message key="common.cardType"/><span class="required">*</span>
    </label>
      <dsp:select bean="BillingFormHandler.creditCard.creditCardType" id="atg_store_cardTypeSelect"
                  title="${creditCardTypeTitle}" nodefault="${nodefault}">
        <dsp:option value=""><fmt:message key="common.chooseCardType"/></dsp:option>
        <dsp:option value="Visa"><fmt:message key="common.visa"/></dsp:option>
        <dsp:option value="MasterCard"><fmt:message key="common.masterCard"/></dsp:option>
        <dsp:option value="Discover"><fmt:message key="common.discover"/></dsp:option>
        <dsp:option value="AmericanExpress"><fmt:message key="common.americanExpress"/></dsp:option>
      </dsp:select>
    </li>
    
    <!--  Credit Card Number Input -->
    <li class="atg_store_ccNumber">
      <label for="card_number">
        <fmt:message key="common.cardNumber"/><span class="required">*</span>
      </label>
      <dsp:input bean="BillingFormHandler.creditCard.creditCardNumber" type="text" converter="creditCard"
                 groupingsize="4" maskcharacter="X" numcharsunmasked="4" maxlength="16" id="atg_store_cardNumberInput"
                 autocomplete="off" value=""/>
    </li>
    
    <%-- Verification Number Input --%>
    <dsp:getvalueof var="requireCreditCardVerification" vartype="java.lang.String"
                     bean="StoreConfiguration.requireCreditCardVerification"/>

    <%--  Expiration Date Select --%>
    <li class="atg_store_expiration">
      <label for="atg_store_expirationDateMonthSelect" class="required">
        <fmt:message key="common.expirationDate"/><span class="required">*</span>
      </label>
      <fmt:message var="expirationMonthTitle" key="checkout_creditCardForm.expirationMonthTitle"/>
      <c:if test="${prefill}">
        <dsp:getvalueof var="nodefault" vartype="java.lang.String" value="false"/>
      </c:if>
      <c:if test="${!prefill}">
        <dsp:getvalueof var="nodefault" vartype="java.lang.String" value="true"/>
      </c:if>
      <div class="atg_store_ccExpiration">
      <dsp:select bean="BillingFormHandler.creditCard.expirationMonth" id="atg_store_expirationDateMonthSelect"
                  title="${expirationMonthTitle}" nodefault="${nodefault}">
        <dsp:option><fmt:message key="common.month"/></dsp:option>
        <dsp:option value="01"><fmt:message key="common.january"/></dsp:option>
        <dsp:option value="02"><fmt:message key="common.february"/></dsp:option>
        <dsp:option value="03"><fmt:message key="common.march"/></dsp:option>
        <dsp:option value="04"><fmt:message key="common.april"/></dsp:option>
        <dsp:option value="05"><fmt:message key="common.may"/></dsp:option>
        <dsp:option value="06"><fmt:message key="common.june"/></dsp:option>
        <dsp:option value="07"><fmt:message key="common.july"/></dsp:option>
        <dsp:option value="08"><fmt:message key="common.august"/></dsp:option>
        <dsp:option value="09"><fmt:message key="common.september"/></dsp:option>
        <dsp:option value="10"><fmt:message key="common.october"/></dsp:option>
        <dsp:option value="11"><fmt:message key="common.november"/></dsp:option>
        <dsp:option value="12"><fmt:message key="common.december"/></dsp:option>
      </dsp:select>

      <fmt:message var="expirationYearTitle" key="checkout_creditCardForm.expirationYearTitle"/>
      <c:if test="${prefill}">
        <dsp:getvalueof var="nodefault" vartype="java.lang.String" value="false"/>
      </c:if>
      <c:if test="${!prefill}">
        <dsp:getvalueof var="nodefault" vartype="java.lang.String" value="true"/>
      </c:if>

      <crs:yearList numberOfYears="16" 
                      bean="/atg/store/order/purchase/BillingFormHandler.creditCard.expirationYear"
                      id="atg_store_expirationDateYearSelect"
                      title="${expirationYearTitle}"
                      nodefault="${nodefault}" />
                      </div>
    </li>
    
    <li class="atg_store_ccCsvCode">
      <c:if test='${requireCreditCardVerification == "true"}'>
        <label for="atg_store_verificationNumberInput">
          <fmt:message key="checkout_billing.securityCode"/><span class="required">*</span>
        </label>
        <dsp:input bean="BillingFormHandler.newCreditCardVerificationNumber" type="text"
                   name="atg_store_verificationNumberInput" id="atg_store_verificationNumberInput" 
                   value="" autocomplete="off"/>

          <fmt:message var="whatisThisTitle" key="checkout_billing.whatIsThis"/>           
          <a href="${contextroot}/checkout/whatsThisPopup.jsp" title="${whatisThisTitle}" class="atg_store_help" target="popup">
            ${whatisThisTitle}
          </a>
 
      </c:if>
    </li>

    <%-- If the shopper is transient (a guest shopper) we don't offer to save the card --%>
    <dsp:getvalueof var="transient" bean="Profile.transient"/>
    
    <%-- Save this card checkbox. Hide if the profile is transient --%>

    <c:choose>
      <c:when test="${transient == 'true'}">
        <c:set value="false" var="showSaveCard"/>
        <li id="saveCreditCardInfoBox" style="display:none;">
      </c:when>
      <c:otherwise>
        <c:set value="true" var="showSaveCard"/>
        <li class="atg_store_saveCC">
      </c:otherwise>
    </c:choose>
      <label for="save_credit_card_info"><fmt:message key="checkout_billing.savePaymentInfor"/></label>
      <dsp:input type="checkbox" bean="BillingFormHandler.saveCreditCard" name="addCard" iclass="checkbox" checked="${showSaveCard}" id="atg_store_addressAddSaveAddressInput" />
    </li>
  </ul>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/creditCardForm.jsp#3 $$Change: 635969 $--%>
