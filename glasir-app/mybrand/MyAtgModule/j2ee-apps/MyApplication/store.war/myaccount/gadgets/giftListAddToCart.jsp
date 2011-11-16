
<%-- This page expects the following parameters
     product - the product repository item to display
     skuId - the sku item's repository ID
     gifitlist - the giftlist being displayed
     gifitlistitem - the giftlist item being displayed
--%>

<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>

  <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>

  <%--to fetch the title for the button to be displayed alongside of the product--%>
  <dsp:include page="/global/gadgets/skuAvailabilityLookup.jsp">
    <dsp:param name="product" param="product"/>
    <dsp:param name="skuId" param="skuId"/>
    <dsp:param name="showUnavailable" value="true"/>
  </dsp:include>

  <%-- for displaying the button --%>
  <c:if test="${!empty addButtonText}">


      <c:choose>
        <c:when test="${availabilityType == 'unavailable'}">
          <dsp:getvalueof var="sid" param="skuId"/>
          <dsp:getvalueof var="pid" param="product.repositoryId"/>
          <a href="${contextroot}/browse/notifyMeRequestPopup.jsp?skuId=${sid}&productId=${pid}" title="${addButtonTitle}"
             class="atg_store_basicButton" target="popup">
            <span>${addButtonText}</span>
          </a>
        </c:when>
        <c:otherwise>
          <dsp:a page="/cart/cart.jsp" 
                 iclass="add_to_cart_link atg_behavior_addItemToCart atg_store_basicButton" 
				 title="${addButtonTitle}" >
            <%-- Pass values as request params --%>
			<dsp:property bean="CartFormHandler.giftlistId" paramvalue="giftlist.repositoryId" name="gl_rId" />
			<dsp:property bean="CartFormHandler.giftlistitemId" paramvalue="giftlistitem.repositoryId" name="gli_rId" />
			<dsp:property bean="CartFormHandler.productId" paramvalue="giftlistitem.productId" name="gli_pId" />
      <dsp:property bean="CartFormHandler.siteId" paramvalue="giftlistitem.siteId"/>
			<dsp:property bean="CartFormHandler.catalogRefIds" paramvalue="giftlistitem.catalogRefId" name="gli_cRId" />
            <%-- URLs for the RichCart AJAX response to render cart contents as JSON --%>
			<dsp:property bean="CartFormHandler.ajaxAddItemToOrderSuccessUrl" value="${contextroot}/cart/json/cartContents.jsp" name="successUrl" />
			<dsp:property bean="CartFormHandler.ajaxAddItemToOrderErrorUrl" value="${contextroot}/cart/json/errors.jsp" name="errorUrl" />
            <%-- Assume a quantitiy of the remaining value since we are not allowing users to select quantity from here --%>
			<dsp:property bean="CartFormHandler.quantity" paramvalue="giftlistitem.quantityRemaining" name="gli_qR" />
			<%-- Call the form handler addItemToOrder method--%>
			<dsp:property bean="CartFormHandler.addItemToOrder" value="" />
			
			<span>  ${addButtonText}</span>
          </dsp:a>
        </c:otherwise>
      </c:choose>

  </c:if>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/giftListAddToCart.jsp#2 $$Change: 635969 $--%>