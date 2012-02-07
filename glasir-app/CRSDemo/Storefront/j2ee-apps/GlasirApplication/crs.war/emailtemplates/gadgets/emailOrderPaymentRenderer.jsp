<dsp:page>
<%-- 
      This gadget renders the payment groups of a type specified by the paymentGroupType parameter. 
      
      This page expects the following parameters  - 
      - order - order which payment groups should be rendered
      - paymentGroupType - payment group type to render
      - priceListLocale - the locale to use for price formatting
  --%>
  
  <dsp:getvalueof var="paymentGroupRelationships" vartype="java.lang.Object" param="order.paymentGroupRelationships"/>
  <dsp:getvalueof var="requestedPaymentGroupType" vartype="java.lang.String" param="paymentGroupType"/>
  

  <c:forEach var="paymentGroupRelationship" items="${paymentGroupRelationships}">
    <dsp:param name="rel" value="${paymentGroupRelationship}"/>
    <dsp:setvalue param="paymentGroup" paramvalue="rel.paymentGroup"/>

    <dsp:getvalueof var="paymentGroupType" param="paymentGroup.paymentGroupClassType"/>
    <c:if test="${paymentGroupType == requestedPaymentGroupType}">
      <c:choose>
        <c:when test="${paymentGroupType == 'creditCard'}">
          
            <span style="font-weight:bold;color:#000000;">
              <dsp:valueof param="paymentGroup.creditCardType">
                <fmt:message key="common.type"/>
              </dsp:valueof>
              <fmt:message key="common.labelSeparator"/>
            </span>              
              
            <fmt:message key="global_displayCreditCard.endingIn"/>
            <dsp:getvalueof var="creditCard" param="paymentGroup.creditCardNumber" />
            <c:out value="${fn:substring(creditCard,fn:length(creditCard)-4,fn:length(creditCard))}"/>  
            
            <br />
            <span style="font-weight:bold;color:#000000;">
               <fmt:message key="emailtemplates_orderConfirmation.exp"/>
            </span>    
            
            <dsp:valueof param="paymentGroup.expirationMonth">
               <fmt:message key="common.expirationMonth"/>
             </dsp:valueof><fmt:message key="common.separator"/><dsp:valueof param="paymentGroup.expirationYear">
               <fmt:message key="common.expirationYear"/>
             </dsp:valueof>

        </c:when>

        <c:when test="${paymentGroupType == 'storeCredit'}">
          <div style="margin-bottom: 10px;">
            <span style="font-weight: bold;">
              <fmt:message key="common.storeCredit"/><fmt:message key="common.labelSeparator"/>
            </span> 
            <dsp:valueof param="paymentGroup.storeCreditNumber"/>
            <br />
			<span style="font-weight: bold;">
              <fmt:message key="common.amount"/><fmt:message key="common.labelSeparator"/>
            </span> 
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" param="paymentGroup.amount"/>
              <dsp:param name="priceListLocale" param="priceListLocale"/>
            </dsp:include>
          </div>
        </c:when>
      </c:choose>
    </c:if><%--end of check upon payment group type --%>
  </c:forEach>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailOrderPaymentRenderer.jsp#1 $$Change: 633540 $--%>