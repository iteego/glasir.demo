<dsp:page>

  <%-- This page is used to Display the Details of A Credit Card The NickName of the Card is not displayed here-in. 
      If required, it must be rendered just before a include to this JSP --%>

  <%-- As per initial gadget definition, this JSP should be included inside enclosing <dl> tag --%>
  <%-- This page expects the following input parameters
         - creditCard - A CreditCard Repository Item to display
    --%>
  <dsp:getvalueof var="displayCardHolder" param="displayCardHolder"/>
  
  <dd class="atg_store_creditCardProvider">
    <strong>
      <dsp:valueof param="creditCard.creditCardType"/>
    </strong>
    
    <fmt:message key="global_displayCreditCard.endingIn"/>
    
    <strong class="atg_store_creditCardNumber">
      <%-- display only last 4 digits --%>
      <dsp:getvalueof var="creditCard" param="creditCard.creditCardNumber" />
      <c:out value="${fn:substring(creditCard,fn:length(creditCard)-4,fn:length(creditCard))}"/>
    </strong>
  </dd>
  <c:if test="${not empty displayCardHolder}">
    <dd class="atg_store_creditCardHolderName">
      <dsp:valueof param="creditCard.billingAddress.firstName"/> <dsp:valueof param="creditCard.billingAddress.lastName"/>
    </dd>
  </c:if>
  
  <dd class="atg_store_expirationDate">
    <fmt:message key="checkout_creditCards.expiration"/><fmt:message key="common.labelSeparator"/>
    <dsp:getvalueof var="var_expirationMonth" vartype="java.lang.String" param="creditCard.expirationMonth"/>
    <dsp:getvalueof var="var_expirationYear" vartype="java.lang.String" param="creditCard.expirationYear"/>
    <fmt:message key="myaccount.creditCardExpShortDate">
      <fmt:param value="${var_expirationMonth}"/>
      <fmt:param value="${var_expirationYear}"/>
    </fmt:message>
  </dd>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/util/displayCreditCard.jsp#3 $$Change: 635969 $--%>
