<dsp:page>

  <%-- This page Renders a row entry for the Wish List item 
       Parameters - 
       - giftItem - Repository Item representing a SKU added to the Favourites/Wish List 
       - product - Repository Item of the product whose SKU is added to the Wish List
  --%>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/commerce/catalog/SKULookup"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>

  <%-- search for SKU and set it as param, search not only current catalog and current site --%>
  <dsp:droplet name="SKULookup">
    <dsp:param name="id" param="giftItem.catalogRefId"/>
    <dsp:oparam name="output">
      <dsp:getvalueof var="giftSku" param="element"/>
    </dsp:oparam>
    <dsp:oparam name="wrongSite">
      <dsp:getvalueof var="giftSku" param="element"/>
    </dsp:oparam>
    <dsp:oparam name="wrongCatalog">
      <dsp:getvalueof var="giftSku" param="element"/>
    </dsp:oparam>
  </dsp:droplet>
  <dsp:setvalue param="giftSku" value="${giftSku}"/>

  <dsp:getvalueof var="giftItemId" vartype="java.lang.String" param="giftItem.repositoryId"/>
  <dsp:getvalueof var="messageFormId" vartype="java.lang.String" value="formid_${giftItemId}"/>
  
  <!-- repeat -->
    <dsp:droplet name="/atg/dynamo/droplet/multisite/SharingSitesDroplet">
      <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
      <dsp:param name="excludeInputSite" value="true"/>
      <dsp:oparam name="output">
        <td class="site">
          <dsp:include page="/global/gadgets/siteIndicator.jsp">
            <dsp:param name="mode" value="icon"/>              
            <dsp:param name="siteId" param="giftItem.siteId"/>
            <dsp:param name="product" param="product"/>
          </dsp:include>
        </td>
      </dsp:oparam>
    </dsp:droplet>
      <td class="image">
        <dsp:include page="/browse/gadgets/productThumbImg.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="siteId" param="giftItem.siteId"/>
        </dsp:include>
        <dsp:getvalueof var="pageurl" value="${siteLinkUrl}"/>
      </td>

      <td class="item">
        <%-- Get this products template --%>
        <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="product.template.url"/>
        <c:choose>
          <%-- If the product has a template generate a link --%>
          <c:when test="${not empty pageurl}">
            <p class="name">
              <dsp:include page="/global/gadgets/crossSiteLink.jsp">
                <dsp:param name="siteId" param="giftItem.siteId"/>
                <dsp:param name="product" param="product"/>
              </dsp:include>
            </p>
           
            <dsp:getvalueof var="description" vartype="java.lang.String" param="giftSku.description"/>
            <c:if test="${empty size && empty color && !empty description}">
              <p><c:out value="${description}"/></p>
            </c:if>   
          </c:when>
          <%-- Otherwise just display the displayname --%>
          <c:otherwise>
            <%-- Product Template not set --%>
            <p class="brand"><ftm:message key="common.brandName"/></p>
            <dsp:getvalueof var="displayName" vartype="java.lang.String" param="product.displayName"/>
            <c:out value="${displayName}"/>
              
            <!-- end repeat-->
            
          </c:otherwise>
        </c:choose>

        <dsp:include page="/global/util/displaySkuProperties.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="sku" param="giftSku"/>
          <dsp:param name="displayAvailabilityMessage" value="true"/>
        </dsp:include>
      </td>
      <td class="numerical price atg_store_productPrice">
        <%-- Display Price --%>
      
        <dsp:include page="/global/gadgets/priceLookup.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="sku" param="giftSku"/>
        </dsp:include>
    
      </td>
      
      <%-- The quantity and wishlist actions button --%>
      <td class="quantity_fav_actions quantity">
        <dsp:form action="${originatingRequest.requestURI}" method="post" 
            name="${messageFormId}" id="${messageFormId}" formid="${messageFormId}">
   
            <dsp:input bean="CartFormHandler.quantity" iclass="qty atg_store_numericInput" type="text" paramvalue="giftItem.quantityRemaining"/>
    
              <%-- sku Availability Lookup --%>
              <dsp:include page="/global/gadgets/skuAvailabilityLookup.jsp">
                <dsp:param name="product" param="product"/>
                <dsp:param name="skuId" param="giftSku.Id"/>
              </dsp:include>
      <div class="wishList_actions">
              <%-- The Action Button --%>
              <c:choose>
                <c:when test="${not empty addButtonText}">
                    <%-- Hidden params in case the form errors --%>
                    <dsp:getvalueof var="currentCategoryId" vartype="java.lang.String" param="categoryId"/>
                    <dsp:getvalueof var="currentProductId" vartype="java.lang.String" param="productId"/>
                    <input type="hidden" name="categoryId" value="<dsp:valueof value='${currentCategoryId}'/>"/>
                    <input type="hidden" name="productId" value="<dsp:valueof value='${currentProductId}'/>"/>
      
                    <%-- Set the successURL --%>
                    <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>
                    <dsp:input bean="CartFormHandler.addItemToOrderSuccessURL" type="hidden" value="${contextroot}/cart/cart.jsp"/>
      
                    <%-- Set the errorURL --%>
                    <dsp:input bean="CartFormHandler.addItemToOrderErrorURL" type="hidden" value="${contextroot}/myaccount/myWishList.jsp"/>
                    
                    <%-- Set the sessionExpirationURL --%>
                    <dsp:input bean="CartFormHandler.sessionExpirationURL" type="hidden" value="${contextroot}/sessionExpired.jsp"/>
      
                    <%-- URLs for the RichCart AJAX response. Renders cart contents as JSON --%>
                    <dsp:input bean="CartFormHandler.ajaxAddItemToOrderSuccessUrl" type="hidden"
                             value="${contextroot}/cart/json/cartContents.jsp"/>
                    <dsp:input bean="CartFormHandler.ajaxAddItemToOrderErrorUrl" type="hidden"
                             value="${contextroot}/cart/json/errors.jsp"/>
      
                    <dsp:input bean="CartFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
                    <dsp:input bean="CartFormHandler.catalogRefIds" paramvalue="giftSku.repositoryId" type="hidden"/>
                    <dsp:input bean="CartFormHandler.siteId" paramvalue="giftItem.siteId" type="hidden"/>
      
                    <%-- The only submit we got --%>
                    
                    <span class="atg_store_basicButton add_to_cart_link">
                    <dsp:input bean="CartFormHandler.addItemToOrder" type="submit" value="${addButtonText}"
                        title="${addButtonTitle}" iclass="atg_behavior_addItemToCart" id="atg_store_wishListAdd"/>
                      </span>
      
                </c:when>
                <c:otherwise>
                  <%-- Unavailable --%>
                  <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>
                  <dsp:getvalueof var="sid" param="giftSku.repositoryId"/>
                  <dsp:getvalueof var="pid" param="product.repositoryId"/>
                  <fmt:message var="emailMeInStockText" key="common.button.emailMeInStockText"/>
                  <fmt:message var="emailMeInStockTitle" key="common.button.emailMeInStockTitle"/>
                  <a href="${contextroot}/browse/notifyMeRequestPopup.jsp?skuId=${sid}&productId=${pid}" title="${emailMeInStockTitle}" class="atg_store_basicButton atg_store_emailMe" target="popup">
                    <span><c:out value="${emailMeInStockText}"/></span>
                
                  </a>
                        <div class="atg_store_emailMeMessage">
                          <fmt:message key="common.whenAvailable"/>
                        </div>
                </c:otherwise>
              </c:choose>

              <%-- Delete item from wish list --%>
              <div class="atg_store_wishListDelete">
                <dsp:getvalueof var="giftId" vartype="java.lang.String" param="giftItem.id"/>
                <dsp:input type="hidden" bean="GiftlistFormHandler.removeItemsFromGiftlistSuccessURL"
                           value="${originatingRequest.contextPath}/myaccount/myWishList.jsp?selpage=WISHLIST"/>
                <dsp:input type="hidden" bean="GiftlistFormHandler.removeItemsFromGiftlistErrorURL"
                           value="${originatingRequest.contextPath}/myaccount/myWishList.jsp?selpage=WISHLIST"/>
                <dsp:input type="hidden" bean="GiftlistFormHandler.giftlistId" paramvalue="giftlistId"/>
                <dsp:input type="hidden" bean="GiftlistFormHandler.removeGiftitemIds" paramvalue="giftItem.id"/>
      
                <fmt:message var="removeText" key="common.button.removeText"/>
            
                <dsp:input type="submit" bean="GiftlistFormHandler.removeItemsFromGiftlist" value="${removeText}"
                           id="atg_store_deleteFromWishList" iclass="atg_store_textButton"/>
         
          </div>
          </div>
        </dsp:form>
      </td>
  <!-- end repeat -->   
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/wishListRow.jsp#2 $$Change: 633752 $--%>
