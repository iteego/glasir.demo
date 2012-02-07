<%--
  Renders gift wrap item and gift message. 
 --%>
<dsp:page>
  
  <dsp:getvalueof var="containsGiftMessage" vartype="java.lang.String" param="order.containsGiftMessage"/>
  <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" param="order.commerceItems"/>
  
  <%-- Determine gift wrap --%>
  <c:forEach var="currentItem" items="${commerceItems}" varStatus="status">
    <dsp:param name="currentItem" value="${currentItem}"/>
    <dsp:getvalueof var="commerceItemClassType" param="currentItem.commerceItemClassType"/>
    
    <c:if test="${commerceItemClassType == 'giftWrapCommerceItem'}">
      <dsp:param name="giftWrapItem" value="${currentItem}"/>
    </c:if>
    
  </c:forEach>

  <%-- Display table only if we have either gift message or gift wrap --%>
  <dsp:getvalueof var="giftWrapItem" param="giftWrapItem"/>                
  <c:if test="${not empty giftWrapItem || containsGiftMessage == 'true'}">

    <table id="atg_store_cart">
      <tr>
        <dsp:getvalueof var="hideSiteIndicator" vartype="java.lang.String" param="hideSiteIndicator"/>
        <th class="atg_store_orderExtraHeader"
            colspan="${empty hideSiteIndicator or (hideSiteIndicator == 'false') ? '6' : '5'}">
          <fmt:message key="checkout_confirmExtras.title"/>
        </th>
      </tr>
      
      <%-- Gift wrap goes first --%>
      <c:if test="${not empty giftWrapItem}">
        <dsp:include page="/global/gadgets/orderItemsRenderer.jsp">
          <dsp:param name="currentItem" param="giftWrapItem"/>
          <dsp:param name="count" value="1"/>
          <dsp:param name="size" value="1"/>
          <dsp:param name="hideSiteIndicator" param="hideSiteIndicator"/>
          <dsp:param name="displaySiteIcon" value="false"/>
        </dsp:include>
      </c:if>
      
      <%-- Gift message --%>
      <dsp:include page="/checkout/gadgets/confirmGiftMessage.jsp">
        <dsp:param name="order" param="order"/>
        <dsp:param name="isCurrent" param="isCurrent"/>
      </dsp:include>
    </table>
  </c:if>
          
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/orderExtras.jsp#1 $$Change: 633540 $--%>