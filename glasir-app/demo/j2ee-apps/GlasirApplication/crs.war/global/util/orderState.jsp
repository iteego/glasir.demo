<dsp:page>

<%--
      This page expects a param called "order".
--%>


    <dsp:getvalueof var="stateAsString" param="order.stateAsString"/>
    <c:choose>
      <c:when test="${stateAsString == 'SUBMITTED'}">
        <fmt:message key="common.orderPlaced"/>
      </c:when>
      <c:when test="${stateAsString == 'PROCESSING'}">
        <fmt:message key="common.orderProcessing"/>
      </c:when>
      <c:when test="${stateAsString == 'SAP_ACKNOWLEDGED'}">
        <fmt:message key="common.orderProcessing"/>
      </c:when>
      <c:when test="${stateAsString == 'PENDING_FULFILLMENT'}">
        <fmt:message key="common.orderProcessing"/>
      </c:when>
      <c:when test="${stateAsString == 'NO_PENDING_ACTION'}">
        <fmt:message key="common.orderShipped"/>
      </c:when>
      <c:when test="${stateAsString == 'PENDING_REMOVE'}">
        <fmt:message key="common.orderCancelled"/>
      </c:when>
      <c:when test="${stateAsString == 'REMOVED'}">
        <fmt:message key="common.orderCancelled"/>
      </c:when>
      <c:otherwise>
        <fmt:message key="common.orderProcessing"/>
      </c:otherwise>
    </c:choose>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/util/orderState.jsp#2 $$Change: 635969 $--%>
