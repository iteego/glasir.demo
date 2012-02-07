<%--
  Shipping address and shipping method for the given shipping group
--%>
<dsp:page>
  <dsp:getvalueof var="shippingGroup" param="shippingGroup"/>
  <dsp:param name="shippingAddress" param="shippingGroup.shippingAddress"/>
  <dsp:getvalueof var="isCurrent" param="isCurrent"/>
  
  <dl class="atg_store_groupShippingAddress">
    <dt>
      <fmt:message key="checkout_confirmPaymentOptions.shipTo"/>: 
    </dt>             
    <dd>
      <dsp:include page="/global/util/displayAddress.jsp">
        <dsp:param name="address" param="shippingAddress"/>
      </dsp:include>

    <c:if test="${isCurrent}">
      <dsp:a page="/checkout/shipping.jsp" title=""  iclass="atg_store_editAddress">
        <span><fmt:message key="common.button.editText" /></span>
      </dsp:a>
    </c:if>
    
    </dd>
    <dt>
      <fmt:message key="checkout_confirmPaymentOptions.viaMethod"/>: 
    </dt>
    <dd class="atg_store_orderDate">
      <dsp:getvalueof var="shippingMethod" param="shippingGroup.shippingMethod"/>
      <strong><fmt:message key="common.delivery${fn:replace(shippingMethod, ' ', '')}"/></strong>
      
      <c:if test="${isCurrent}">
        <dsp:a page="/checkout/shippingMethod.jsp" title="">
          <span><fmt:message key="common.button.editText" /></span>
        </dsp:a>
      </c:if>
    </dd>
  </dl>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/orderSingleShippingInfo.jsp#1 $$Change: 633540 $--%>