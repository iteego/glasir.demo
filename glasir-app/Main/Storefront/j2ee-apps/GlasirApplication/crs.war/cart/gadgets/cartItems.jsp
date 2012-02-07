<dsp:page>

  <%-- 
       This gadgets renders the header for the item list, then iterates through the cart, rendering
       the itemListingBody.jsp gadget for each item 

       Form Condition:
       - This gadget must be contained inside of a form.
         CartFormHandler must be invoked from a submit 
         button in the form for these fields to be processed
  --%>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>

  <dsp:getvalueof var="items" vartype="java.lang.Object" bean="ShoppingCart.current.commerceItems"/> 
  <c:if test="${not empty items}">
    <dsp:include page="itemListingHeader.jsp"/>
    <dsp:getvalueof var="size" value="${fn:length(items)}"/>

    <c:forEach var="currentItem" items="${items}" varStatus="status">
      <dsp:param name="currentItem" value="${currentItem}"/>
      <dsp:getvalueof var="count" value="${status.count}"/>
      <dsp:getvalueof var="commerceItemClassType" param="currentItem.commerceItemClassType"/>
      <c:choose>
        <c:when test='${commerceItemClassType == "giftWrapCommerceItem"}'>
          <%-- Filter out the giftWrapCommerceItem, but add as hidden input so it doesn't --%>
          <%-- get removed from the cart. --%>
          <input type="hidden" name="<dsp:valueof param='currentItem.id'/>"
                 value="<dsp:valueof param='currentItem.quantity'/>">
        </c:when>
        <c:otherwise>
          <dsp:include page="itemListingBody.jsp">
            <dsp:param name="count" value="${count}"/>
            <dsp:param name="size" value="${size}"/>
          </dsp:include>
        </c:otherwise>
      </c:choose>

    </c:forEach>
    <dsp:include page="itemListingFooter.jsp"/>
  </c:if>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/cartItems.jsp#2 $$Change: 635969 $--%>