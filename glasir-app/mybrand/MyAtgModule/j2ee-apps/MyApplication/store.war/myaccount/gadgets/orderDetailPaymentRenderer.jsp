<dsp:page>
<%-- 
      This gadget renders the payment groups of a type specified by the paymentGroupType parameter. 
      
      This page expects the following parameters  - 
      - paymentGroupType - payment group type to render
  --%>  
  
  <dsp:getvalueof var="paymentGroupRelationships" vartype="java.lang.Object" param="order.paymentGroupRelationships"/>
  <dsp:getvalueof var="paymentGroupType" vartype="java.lang.String" param="paymentGroupType"/>
  
  <c:forEach var="paymentGroupRelationship" items="${paymentGroupRelationships}">
    <dsp:param name="rel" value="${paymentGroupRelationship}"/>
    <dsp:setvalue param="paymentGroup" paramvalue="rel.paymentGroup"/>
    <dsp:getvalueof var="paymentGroupClassType" param="paymentGroup.paymentGroupClassType"/>
    
    <c:if test="${paymentGroupType == paymentGroupClassType}">
      <dl class="atg_store_infoList">        
        <c:choose>
          <c:when test="${paymentGroupClassType == 'creditCard'}">
            <dt>
              <fmt:message key="common.creditCard"/><fmt:message key="common.labelSeparator"/>
            </dt>
            <dd>
             <dsp:valueof param="paymentGroup.creditCardType">
               <fmt:message key="common.type"/>
             </dsp:valueof>
             <dsp:valueof param="paymentGroup.creditCardNumber" converter="creditCard">
               <fmt:message key="myaccount_orderDetailBilledTo.cardNumber"/>
             </dsp:valueof>
            </dd>
          
            <dt>
              <fmt:message key="common.name"/><fmt:message key="common.labelSeparator"/>
            </dt>
            <dd>
             <dsp:valueof param="paymentGroup.billingAddress.firstName">
               <fmt:message key="common.cardHolderFirstName"/>
             </dsp:valueof>
             <dsp:valueof param="paymentGroup.billingAddress.lastName">
               <fmt:message key="common.cardHolderLastName"/>
             </dsp:valueof>
           </dd>
          
            <dt>
              <fmt:message key="common.expirationDate"/><fmt:message key="common.labelSeparator"/>
            </dt>
            <dd>
             <dsp:valueof param="paymentGroup.expirationMonth">
               <fmt:message key="common.expirationMonth"/>
             </dsp:valueof><fmt:message key="common.separator"/><dsp:valueof param="paymentGroup.expirationYear">
               <fmt:message key="common.expirationYear"/>
             </dsp:valueof>
           </dd>
          </c:when>
          <c:when test="${paymentGroupClassType == 'storeCredit'}">
            <dt>
              <fmt:message key="common.storeCredit"/>
            </dt>
            <dd>
              <fmt:message key="common.referenceNumber"/><fmt:message key="common.labelSeparator"/>
              <dsp:valueof param="paymentGroup.storeCreditNumber"/>
            </dd>
          </c:when>
        </c:choose>
        <dsp:getvalueof var="relationshipType" param="rel.relationshipType"/>
        <c:if test="${relationshipType == '401'}">
          <dt>
            <fmt:message key="common.amountUsed"/><fmt:message key="common.labelSeparator"/>
          </dt>       
          <dd>
            <dsp:getvalueof var="amountUsed" vartype="java.lang.Double" param="rel.amount"/>
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${amountUsed }"/>
            </dsp:include>
          </dd>
        </c:if>
      </dl>
    </c:if><%--end of check upon payment group type --%>
  </c:forEach>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/orderDetailPaymentRenderer.jsp#2 $$Change: 635969 $--%>