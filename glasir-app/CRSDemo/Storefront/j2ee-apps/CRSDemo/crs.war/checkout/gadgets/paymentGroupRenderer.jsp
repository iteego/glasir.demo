<dsp:page>
<%-- 
  This gadget renders billing address and payment information 
--%>
  <dsp:importbean bean="/atg/store/order/purchase/CommitOrderFormHandler"/>
  
  <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof var="isCurrent" param="isCurrent"/>
  <dsp:getvalueof var="isExpressCheckout" param="isExpressCheckout"/>
  

      <dl class="atg_store_groupBillingAddress">
        <dt>
          <fmt:message key="checkout_confirmPaymentOptions.billTo"/><fmt:message key="common.labelSeparator"/>
        </dt>             
        <dd>
          
          <dsp:include page="/global/util/displayAddress.jsp">
            <dsp:param name="address" param="paymentGroup.billingAddress"/>
          </dsp:include>
 
          <c:if test="${isCurrent}">
            <dsp:a page="/checkout/billing.jsp" title="">
              <span><fmt:message key="common.button.editText"/></span>
            </dsp:a>
          </c:if>
        </dd>
      </dl>
            
      <dl class="atg_store_groupPayment">
        
        <dt>
          <fmt:message key="checkout_confirmPaymentOptions.payment"/><fmt:message key="common.labelSeparator"/>
        </dt>

        <dd class="atg_store_groupPaymentCardType">
          <strong><dsp:valueof param="paymentGroup.creditCardType"/>:</strong>
          <fmt:message key="global_displayCreditCard.endingIn"/>
          <dsp:getvalueof var="creditCard" param="paymentGroup.creditCardNumber" />
          <c:out value="${fn:substring(creditCard,fn:length(creditCard)-4,fn:length(creditCard))}"/>
        </dd>
        
        <dd class="atg_store_groupPaymentCardExp">
          <strong><fmt:message key="global_displayCreditCard.expDate"/>:</strong>
          <dsp:getvalueof var="var_expirationMonth" vartype="java.lang.String" param="paymentGroup.expirationMonth"/>
          <dsp:getvalueof var="var_expirationYear" vartype="java.lang.String" param="paymentGroup.expirationYear"/>
          <fmt:message key="myaccount.creditCardExpShortDate">
            <fmt:param value="${var_expirationMonth}"/>
            <fmt:param value="${var_expirationYear}"/>
          </fmt:message>
          <c:if test="${isCurrent}">
            <dsp:a page="/checkout/billing.jsp" title="">
              <span><fmt:message key="common.button.editText" /></span>
            </dsp:a>
          </c:if>
        </dd>
        
        <c:if test="${isCurrent && isExpressCheckout}">
          
          <dd class="atg_store_groupPaymentCardCSV">
            <div class="atg_store_billingEnterCardCSV">
              <ul class="atg_store_basicForm">
                <li>
                  <label><fmt:message key="checkout_billing.securityCode"/></label>
                  <dsp:input bean="CommitOrderFormHandler.creditCardVerificationNumber" value="" type="text"
                             iclass="required" id="atg_store_verificationNumberInput" autocomplete="off">
                             <dsp:tagAttribute name="dojoType" value="atg.store.widget.enterSubmit" />
                               <dsp:tagAttribute name="targetButton" value="atg_store_placeMyOrderButton" />
                             </dsp:input>
                </li>
              </ul>
              
              <fmt:message var="whatisThisTitle" key="checkout_billing.whatIsThis"/>           
              <a href="${contextroot}/checkout/whatsThisPopup.jsp" title="${whatisThisTitle}" class="atg_store_help" target="popup">
                ${whatisThisTitle}
              </a>
            </div>
          </dd>
        </c:if>
      
      </dl>
  
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/paymentGroupRenderer.jsp#2 $$Change: 633752 $--%>