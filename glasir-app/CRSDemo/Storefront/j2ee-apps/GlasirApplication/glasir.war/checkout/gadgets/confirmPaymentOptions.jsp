<dsp:page>
  <%--
    Displays payment information for the order
   --%>

  <dsp:importbean bean="/atg/store/order/purchase/CommitOrderFormHandler"/>
  
<dsp:getvalueof var="paymentGroupRelationships" vartype="java.lang.Object" param="order.paymentGroupRelationships"/>
<dsp:getvalueof var="paymentGroupRelationshipCount" vartype="java.lang.String" param="order.paymentGroupRelationshipCount"/>
<dsp:getvalueof var="creditCardRequired" vartype="java.lang.Boolean" bean="CommitOrderFormHandler.creditCardRequired"/>
<dsp:getvalueof var="isCurrent" param="isCurrent"/>
<dsp:getvalueof var="expressCheckout" param="expressCheckout"/>

<c:if test="${empty expressCheckout}">
  <c:set var="expressCheckout" value="false"/>
</c:if>

<c:choose>
  <%-- express checkout --%>
  <%-- If there is no need in credit card, do not display it. --%>
  <c:when test='${isCurrent && paymentGroupRelationshipCount == "0" && expressCheckout && creditCardRequired}'>
    <dsp:getvalueof var="creditCard" bean="CommitOrderFormHandler.creditCard"/>

    <c:if test="${not empty creditCard}">
      <dsp:include page="/checkout/gadgets/paymentGroupRenderer.jsp">
        <dsp:param name="isExpressCheckout" value="true"/>
        <dsp:param name="isCurrent" param="isCurrent"/>
        <dsp:param name="paymentGroup" bean="CommitOrderFormHandler.creditCard"/>
      </dsp:include>
    </c:if>
  </c:when>
  
  <%-- step-by-step checkout --%>
  <c:otherwise>
    <c:forEach var="paymentGroupRelationship" items="${paymentGroupRelationships}">
      <dsp:param name="rel" value="${paymentGroupRelationship}"/>
      <dsp:setvalue param="paymentGroup" paramvalue="rel.paymentGroup"/>
      <dsp:getvalueof var="paymentGroupClassType" param="paymentGroup.paymentGroupClassType"/>
      
      <c:if test="${paymentGroupClassType == 'creditCard'}">
        <dsp:include page="/checkout/gadgets/paymentGroupRenderer.jsp">
          <dsp:param name="isCurrent" param="isCurrent"/>
          <dsp:param name="paymentGroup" param="paymentGroup"/>
          <dsp:param name="isExpressCheckout" value="${expressCheckout}"/>
        </dsp:include>
      </c:if>
          
    </c:forEach>
  </c:otherwise>
</c:choose>  


</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/confirmPaymentOptions.jsp#3 $$Change: 635969 $--%>