<%-- 
  This container page renders the shipping-single form
--%>

<dsp:page>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart" />
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
    
  <dsp:getvalueof var="savedAddresses" bean="Profile.secondaryAddresses"></dsp:getvalueof>
  <dsp:getvalueof var="giftShippingGroups" bean="ShippingGroupFormHandler.giftShippingGroups"/>

  <div class="${(!empty savedAddresses or !empty giftShippingGroups) ?'atg_store_existingAddresses ':''}atg_store_checkoutOption" id="atg_store_checkoutOptionArea"> 

      <div id="atg_store_selectAddress"> 
        <dsp:include page="shippingAddresses.jsp" flush="true"/>
      </div>
      <dsp:include page="shippingForm.jsp" flush="true"/>
      
      <%-- Ship to Multiple Addresses button --%>
  
      <dsp:getvalueof var="totalCommerceItemCount" bean="ShoppingCart.current.totalCommerceItemCount"/>
      <c:if test="${totalCommerceItemCount eq 2}">
        <%-- Check if the second commerce item is a gift wrap --%>
        <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" bean="ShoppingCart.current.commerceItems"/>
    
        <%-- Determine gift wrap --%>
        <c:forEach var="currentItem" items="${commerceItems}" varStatus="status">
          <dsp:param name="currentItem" value="${currentItem}"/>
          <dsp:getvalueof var="commerceItemClassType" param="currentItem.commerceItemClassType"/>
      
          <c:if test="${commerceItemClassType == 'giftWrapCommerceItem'}">
            <%-- order contains gift wrap commerce item, subtract it from the total 
                 commerce items  count --%>
            <c:set var="totalCommerceItemCount" value="${totalCommerceItemCount - 1}"/>
          </c:if>
       </c:forEach>
      </c:if>
       
      <c:if test="${totalCommerceItemCount > 1}">
        <%-- Display Ship to multiple addresses link --%>
        <div class="atg_store_checkoutFooterLink">
          <fmt:message var="shippingMultipleLinkText" key="checkout_shippingOptions.button.shipToMultipleText"/>
          <c:url var="successUrlVar" value="/checkout/shippingMultiple.jsp">
            <c:param name="init" value="true"/>
          </c:url>
          <dsp:input type="hidden"  bean="ShippingGroupFormHandler.addAddressAndMoveToMultipleShippingSuccessURL" 
                     value="${successUrlVar}"/>
          <dsp:input type="hidden"  bean="ShippingGroupFormHandler.addAddressAndMoveToMultipleShippingErrorURL" 
                     beanvalue="/OriginatingRequest.requestURI"/>
          
          <span class="atg_store_basicButton">
            <dsp:input type="submit"  bean="ShippingGroupFormHandler.addAddressAndMoveToMultipleShipping" value="${shippingMultipleLinkText}"/>
          </span>
        </div>
      </c:if>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingSingleForm.jsp#2 $$Change: 635969 $--%>
