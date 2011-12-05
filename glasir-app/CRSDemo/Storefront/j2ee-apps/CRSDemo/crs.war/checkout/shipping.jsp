<%-- 
    This page determines which shipping page to show based on the number and type of
    shipping groups in the order.
--%>

<dsp:page>

  <dsp:importbean bean="/atg/commerce/order/purchase/RepriceOrderDroplet"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CheckoutOptionSelections"/>
  <dsp:importbean bean="/atg/store/droplet/AddItemsToOrder"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  
  <dsp:droplet name="AddItemsToOrder">
    <dsp:param name="order" bean="ShoppingCart.current"/>
    <dsp:param name="profile" bean="Profile"/>
  </dsp:droplet>

  <%-- if there's a checkout option param, remember it in the CheckoutOptionSelections for use on later pages --%>
  <dsp:getvalueof var="checkoutoption" param="checkoutoption"/> 
  <c:if test="${not empty checkoutoption}">
    <dsp:setvalue bean="CheckoutOptionSelections.checkoutOption" paramvalue="checkoutoption"/>
  </c:if>
  <%-- Reprice before any page rendering occurs --%>
  <dsp:droplet name="RepriceOrderDroplet">
    <dsp:param name="pricingOp" value="ITEMS"/>
  </dsp:droplet>

  <%-- If the order has any hard goods shipping groups, figure out which hard goods page
       to use. --%>
  <dsp:getvalueof var="anyHardgoodShippingGroups" vartype="java.lang.String"
                  bean="ShippingGroupFormHandler.anyHardgoodShippingGroups"/>
  <dsp:getvalueof var="multipleNonGiftHardgoodShippingGroups" vartype="java.lang.String"
                  bean="ShippingGroupFormHandler.multipleNonGiftHardgoodShippingGroups"/>
  <dsp:getvalueof var="giftShippingGroups" vartype="java.lang.Object" 
                  bean="ShippingGroupFormHandler.giftShippingGroups"/>                
  <dsp:getvalueof var="giftShippingGroupsSize" vartype="int" value="${fn:length(giftShippingGroups)}"/>
  <dsp:getvalueof var="nonGiftShippingGroupCount"
                  bean="ShippingGroupFormHandler.NonGiftHardgoodShippingGroupCount"/>
  
  <c:choose>
    <c:when test='${anyHardgoodShippingGroups}'>
      <%-- If the order has more than one hard goods shipping group, go to the
           multi shipping group page. Otherwise, single shipping group page --%>
      <c:choose>
      
        <%-- 
          show multi shipping groups page 
          if we have more than one gift shipping group 
          or at least one gift shipping group and one and more non-gift 
          shipping groups
        --%>
        <c:when test='${giftShippingGroupsSize > 1 || (giftShippingGroupsSize > 0 && nonGiftShippingGroupCount > 0)}'>
          <dsp:include page="shippingMultiple.jsp">
            <dsp:param name="init" value="true"/>
          </dsp:include>
        </c:when>
       
        <c:when test='${!multipleNonGiftHardgoodShippingGroups || giftShippingGroupsSize == 1}'>
          <dsp:include page="shippingSingle.jsp">
            <dsp:param name="init" value="true"/>
          </dsp:include>
        </c:when>
        
        <c:when test='${multipleNonGiftHardgoodShippingGroups}'>
          <dsp:include page="shippingMultiple.jsp">
            <dsp:param name="init" value="true"/>
          </dsp:include>
        </c:when>

      </c:choose>
    </c:when>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/shipping.jsp#2 $$Change: 635969 $ --%>
