<dsp:page>
  <%-- Set a request scoped var to indicate that the rich cart shouldn't do any form
       hijacking. Any 'Add To Cart' links/buttons clicked on the cart page need the entire
       page to refresh to reflect the changes --%>
 
  <c:set var="noRichCartFormHijacking" value="${true}" scope="request"/>

  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  
  <dsp:getvalueof var="commerceItemCount" bean="ShoppingCart.current.CommerceItemCount"/>
  
  <%-- Determine CSS class for shopping cart page container --%>
  <c:set var="cartPageClass" value="atg_store_pageCart atg_store_rightCol" />
  <c:if test='${commerceItemCount == 0}'>
    <c:set var="cartPageClass" value="atg_store_pageEmptyCart"/>
  </c:if>

  <crs:pageContainer divId="" titleKey="" index="false" follow="false">
    <jsp:attribute name="bodyClass"><c:out value="${cartPageClass}"/></jsp:attribute>  
    
    <jsp:body>
      <dsp:include page="/global/gadgets/orderReprice.jsp" flush="true"/>
      
      <dsp:form action="${pageContext.request.requestURI}" method="post" name="cartform" formid="cartform">
      <div class="atg_store_nonCatHero"><h2 class="title"><fmt:message  key="common.cart.shoppingCart"/>
        <dsp:include page="/global/gadgets/closenessQualifiers.jsp" flush="true"/></h2></div>
      <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
        <dsp:param name="formhandler" bean="CartFormHandler"/>
      </dsp:include>
      <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
        <dsp:param name="formhandler" bean="CartFormHandler.storeExpressCheckoutFormHandler"/>
      </dsp:include>
      <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
        <dsp:param name="formhandler" bean="CouponFormHandler"/>
      </dsp:include>
      <div id="atg_store_shoppingCart" class="atg_store_main">
        <dsp:include page="gadgets/cartContents.jsp" flush="true" />

        <div id="atg_store_recommendedProductsDetail">
          <dsp:include page="/navigation/gadgets/orderRelatedProducts.jsp" flush="true" >
            <dsp:param name="order" bean="CartFormHandler.order"/>
          </dsp:include>
        </div>
      
      </div>
      
      <%-- Order summary and action buttons --%>
      <c:if test='${commerceItemCount != 0}'>
        <dsp:include page="/checkout/gadgets/checkoutOrderSummary.jsp">
          <dsp:param name="skipCouponFormDeclaration" value="true"/>
          <dsp:param name="order" bean="ShoppingCart.current"/>
          <dsp:param name="isShoppingCart" value="true"/>
        </dsp:include>
      </c:if>
            
      </dsp:form>
    
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/cart.jsp#2 $$Change: 635969 $--%>
