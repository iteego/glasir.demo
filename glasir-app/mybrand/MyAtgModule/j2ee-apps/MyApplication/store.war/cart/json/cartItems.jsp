<dsp:page>

  <%-- 
    This page renders JSON data when there are items in the cart 
  --%>

  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:getvalueof var="items"         bean="ShoppingCart.current.commerceItems"/>
  <dsp:getvalueof var="itemCount"     bean="ShoppingCart.current.CommerceItemCount" />
  <dsp:getvalueof var="currencyCode"  bean="ShoppingCart.current.priceInfo.currencyCode"/>
  <dsp:getvalueof var="subtotal"      bean="ShoppingCart.current.priceInfo.amount"/>
  
  <c:set var="itemsQuantity" value="${0}"/>
  <c:forEach var="item" items="${items}">
    <dsp:param name="item" value="${item}"/>
    <dsp:getvalueof var="commerceItemClassType" param="item.commerceItemClassType"/>
    <c:if test="${commerceItemClassType != 'giftWrapCommerceItem'}">
      <c:set var="itemsQuantity" value="${itemsQuantity + item.quantity}"/>
    </c:if>
  </c:forEach>
  
  <json:object>
    <json:property name="itemCount" value="${itemCount}"/>
    <json:property name="itemsQuantity" value="${itemsQuantity}"/>
    <json:property name="subtotal">
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${subtotal }"/>
      </dsp:include>
    </json:property>
    
    <json:array name="items">
      <c:forEach var="item" items="${items}">
        <dsp:param name="item" value="${item}"/>
        <dsp:getvalueof var="commerceItemClassType" param="item.commerceItemClassType"/>
      
        <c:if test="${commerceItemClassType != 'giftWrapCommerceItem'}">
          <dsp:include page="cartItem.jsp" flush="true">
            <dsp:param name="currentItem" value="${item}" />
          </dsp:include>
        </c:if>
      </c:forEach>
    </json:array>
    
  </json:object>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/json/cartItems.jsp#2 $$Change: 635969 $--%>
