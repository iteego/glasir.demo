<%-- This gadget renders the "Delete" and "Add To WishList" buttons for each
     item in the cart --%>

<dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
<dsp:importbean bean="/atg/store/profile/SessionBean"/>
<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListContains"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListHandler"/>
<dsp:importbean bean="/atg/commerce/collections/filter/droplet/GiftlistSiteFilterDroplet"/>
<dsp:importbean bean="/atg/multisite/Site"/>

<dsp:getvalueof var="contextPath" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>

<dsp:getvalueof var="navigable" param="navigable"/>

<dsp:getvalueof id="productId" param="currentItem.auxiliaryData.productId"/>
<dsp:getvalueof id="currentItemId" param="currentItem.id"/>

<dsp:getvalueof id="count" param="count"/>

<fmt:message var="deleteButtonTitle" key="common.button.removeText"/>

<dsp:getvalueof var="auxiliaryDataType" vartype="java.lang.String" param="currentItem.auxiliaryData.catalogRef.type"/>

<c:choose>
  <c:when test='${auxiliaryDataType == "sampleSku"}'>
    <li>
      <dsp:input iclass="atg_store_textButton atg_store_actionDelete" type="submit" 
                  bean="CartFormHandler.removeItemFromOrder" value="${deleteButtonTitle}" submitvalue="${currentItemId}"/>
    </li>
  </c:when>
  <c:when test='${auxiliaryDataType == "webhostSku"}'>
    <li>
      <dsp:input iclass="atg_store_textButton atg_store_actionDelete" type="submit" 
                  bean="CartFormHandler.removeItemFromOrder" value="${deleteButtonTitle}" submitvalue="${currentItemId}"/>
    </li>
  </c:when>
  <c:otherwise>
    <li>
      <dsp:input iclass="atg_store_textButton atg_store_actionDelete" type="submit" name="remove_ci_${count}"
                  bean="CartFormHandler.removeItemFromOrder" value="${deleteButtonTitle}" submitvalue="${currentItemId}"/>
    </li>

    <%-- Non navigable items can't be added to wishlist --%>
    <dsp:getvalueof var="shippingGroupRelationships" vartype="java.lang.Object" param="currentItem.shippingGroupRelationships"/> 
    <c:if test="${not empty shippingGroupRelationships}">
      <c:forEach var="sgRel" items="${shippingGroupRelationships}" varStatus="status">

        <dsp:param name="sgRel" value="${sgRel}"/>
        <%-- We only care about the first shipping group --%>
        <c:if test='${status.index == "0"}'>
          <dsp:getvalueof var="shippingGroupClassType" param="sgRel.shippingGroup.shippingGroupClassType"/>

          <c:choose>
            <c:when test='${!navigable}'/>
            <c:otherwise>
              <fmt:message var="addToWishListTitle" key="common.button.addToWishListTitle"/>

              <%-- Check the security status of the user to see what 
                   options they have for wishlist --%>
              <dsp:droplet name="Compare">
                <dsp:param name="obj1" bean="Profile.securityStatus" converter="number"/>
                <dsp:param name="obj2" bean="PropertyManager.securityStatusCookie" converter="number"/>
                <dsp:oparam name="lessthan">

                  <%-- User is anonymous no add to wishlist just go to registration --%>
                  <%-- If they login then redirect back here--%>
                  <li>
                    <dsp:a page="/global/util/loginRedirect.jsp" title="${addToWishListTitle}"
                           iclass="atg_store_actionAddToWishList" bean="SessionBean.values.loginSuccessURL"
                           value="/cart/cart.jsp">
                      <fmt:message key="common.button.addToWishListText"/>
                    </dsp:a>
                  </li>

                </dsp:oparam>
                <dsp:oparam name="default">
                  <%-- The items Sku id --%>
                  <dsp:getvalueof param="currentItem.catalogRefId" var="skuId" vartype="java.lang.String"/>
									
                  <%-- The items Site id --%>
                  <dsp:getvalueof param="currentItem.auxiliaryData.siteId" var="skuSite" vartype="java.lang.String"/>
									
                  <%-- Determine which wishlist icon to display --%>
                  <c:set var="viewWishListButtonStyle" value=""/>
                  <dsp:droplet name="GiftlistSiteFilterDroplet">
                    <dsp:param name="collection" bean="Profile.wishlist.giftlistItems"/>
                    <dsp:oparam name="output">
                      <dsp:getvalueof param="filteredCollection" var="items" vartype="java.util.Collection"/>
                      <c:forEach items="${items}" var="item">
                        <dsp:param name="item" value="${item}"/>
                        <dsp:getvalueof param="item.catalogRefId" var="currentSkuId" vartype="java.lang.String"/>
                        
                        <%-- Check if this item exists in the WishList --%>
                        <c:if test="${skuId == currentSkuId}">
                          <%-- The current Site id --%>
                          <dsp:getvalueof bean="Site.id" var="currentSiteId" vartype="java.lang.String"/>
                          <%-- If we are on the items site View the WishList --%>
                          <c:if test="${skuSite == currentSiteId}">
                            <c:set var="viewWishListButtonStyle" value="atg_store_viewWishlist"/>		
                          </c:if>
                        </c:if>
												
                     </c:forEach>
                   </dsp:oparam>
                 </dsp:droplet>
									
                  <%-- WishList" --%>
                  <li>
                    <c:choose>											
                      <%-- Add to WishList --%>
                      <c:when test="${empty viewWishListButtonStyle}">
                        <dsp:a page="/cart/cart.jsp" title="${addToWishListTitle}"
                             iclass="atg_store_actionAddToWishList" id="${itemId}">
                          <fmt:message key="common.button.addToWishListText"/>

                          <dsp:property bean="GiftlistFormHandler.giftlistId" beanvalue="Profile.wishlist.id"/>
                          <dsp:property bean="GiftlistFormHandler.itemIds" paramvalue="currentItem.id"/>
                          <dsp:property bean="GiftlistFormHandler.quantity" value="1"/>
                          <dsp:property bean="GiftlistFormHandler.moveItemsFromCartSuccessURL" value="${pageContext.request.requestURI}"/>
                          <dsp:property bean="GiftlistFormHandler.moveItemsFromCartErrorURL" value="${pageContext.request.requestURI}"/>
                          <dsp:property bean="GiftlistFormHandler.moveItemsFromCartLoginURL" value="${contextPath}/global/util/loginRedirect.jsp"/>
                          <dsp:property bean="GiftlistFormHandler.moveItemsFromCart" value="true"/>
                        </dsp:a>
                      </c:when>
											
                      <%-- View WishList --%>
                      <c:otherwise>
                        <c:url value="/myaccount/myWishList.jsp" var="wishListUrl" scope="page"/>
                          <dsp:a href="${wishListUrl}" iclass="${viewWishListButtonStyle}">
				                    <dsp:param name="selpage" value="WISHLIST"/>
                            <fmt:message key="common.button.addToWishListText"/>
                          </dsp:a>
                      </c:otherwise>
                    </c:choose>
                  </li>

                </dsp:oparam>
              </dsp:droplet>
            </c:otherwise>
          </c:choose>
        </c:if>

      </c:forEach>
    </c:if>

  </c:otherwise>
</c:choose><%-- End Check to see what kind of sku we had --%>

<li>
  <dsp:droplet name="ProductListContains">
    <dsp:param name="productList" bean="ProductList"/>
    <dsp:param name="productID" value="${productId}"/>
    <dsp:param name="siteID" param="currentItem.auxiliaryData.siteId"/>

    <dsp:oparam name="false">
      <c:if test="${navigable}">
      <fmt:message var="addToComparisonsSubmitTitle" key="browse_productAction.addToComparisonsSubmit"/>
      <dsp:a page="/cart/cart.jsp"
             title="${addToComparisonsTitle}"
             iclass="atg_store_actionAddToComparisons">
        <fmt:message key="browse_productAction.addToComparisonsSubmit"/>
		<%-- load the values into the form handler bean --%>
		<dsp:property bean="ProductListHandler.productID" paramvalue="currentItem.auxiliaryData.productId" name="pID" />
		<dsp:property bean="ProductListHandler.addProductSuccessURL" beanvalue="/OriginatingRequest.requestURI" name="or_rURI" />
		<dsp:property bean="ProductListHandler.siteID" paramvalue="currentItem.auxiliaryData.siteId"/>

		<%-- Now call the method on the form handler bean --%>
		<dsp:property bean="ProductListHandler.addProduct" value="" />
      </dsp:a>
      </c:if>
    </dsp:oparam>

    <dsp:oparam name="true">
      <fmt:message var="linkTitle" key="browse_productAction.viewComparisonsTitle"/>
      <dsp:a page="/browse/productComparisons.jsp" title="${linkTitle}" iclass="atg_store_viewComparisons">
        <dsp:param name="selpage" value="COMPARISONS"/>
        <fmt:message key="browse_productAction.viewComparisonsLink"/>
      </dsp:a>
    </dsp:oparam>
  </dsp:droplet>
</li>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/itemListingButtons.jsp#2 $$Change: 633752 $--%>
