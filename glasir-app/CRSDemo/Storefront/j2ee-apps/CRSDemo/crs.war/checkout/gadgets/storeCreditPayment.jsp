<dsp:page>

  <%-- 
      This gadget calculates the amount of the order that is covered by store credit
      payment groups and sets the calculated amount to "storeCreditAmount" request's scope
      variable.
      
      Expects the following parameters:
      
      - order (optional) -  if not provided the current shopping cart is used. 
  --%>
  
  <dsp:importbean bean="/atg/commerce/ShoppingCart" />
  <dsp:getvalueof var="order" param="order"/>
  <c:choose>
    <c:when test="${empty order}">
      <dsp:getvalueof var="paymentGroupRelationships" vartype="java.lang.Object" bean="ShoppingCart.current.paymentGroupRelationships"/>
    </c:when>
    <c:otherwise>
      <dsp:getvalueof var="paymentGroupRelationships" vartype="java.lang.Object" param="order.paymentGroupRelationships"/>
    </c:otherwise>
  </c:choose>
  
  
  <c:set var="overallStoreCreditAmount" value="0"/>
  <c:forEach var="paymentGroupRelationship" items="${paymentGroupRelationships}">
    <dsp:param name="rel" value="${paymentGroupRelationship}"/>
    <dsp:setvalue param="paymentGroup" paramvalue="rel.paymentGroup"/>
    <dsp:getvalueof var="paymentGroupClassType" param="paymentGroup.paymentGroupClassType"/>
    
    <c:if test="${paymentGroupClassType == 'storeCredit'}">
      <dsp:getvalueof var="paymentGroupAmount" param="paymentGroup.amount"/>
      <c:set var="overallStoreCreditAmount" value="${overallStoreCreditAmount + paymentGroupAmount}"/>
      
    </c:if><%--end of check upon payment group type --%>
  </c:forEach>
  
  <c:set var="storeCreditAmount" scope="request" value="${overallStoreCreditAmount}" />
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/storeCreditPayment.jsp#2 $$Change: 635969 $--%>
