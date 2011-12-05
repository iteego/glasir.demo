<dsp:page>
  <%-- 
    Add to Wish list link
    
    Parameters on this page:
      1. actionFlag - if true, display 'add to wishlist' action link; if false, display 'go to wishlist' link
    --%>
     
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:getvalueof var="actionFlag" param="actionFlag"/>  

  <c:choose>
    <c:when test="${actionFlag}">
      <%-- Show "Add to Wish List" link, if actionFlag is true --%>
           
      <dsp:getvalueof var="productId" vartype="java.lang.String" param="product.repositoryId"/>
      <dsp:getvalueof var="categoryId" vartype="java.lang.String" param="categoryId"/>
      <dsp:getvalueof var="templateURL" vartype="java.lang.String" param="product.template.url"/>
      
      <c:url value="${templateURL}" var="addToWishlistSuccessUrl" scope="page">
        <c:param name="productId" value="${productId}"/>
        <c:param name="categoryId" value="${categoryId}"/>
        <c:param name="categoryNavIds"><dsp:valueof param="categoryNavIds"/></c:param>
      </c:url>
      
      <dsp:getvalueof var="giftListId" bean="Profile.wishlist.id"/>
      
      <fmt:message var="addToWishListText" key="common.button.addToWishListText"/>
      <dsp:input type="hidden" bean="CartFormHandler.addItemToGiftlistSuccessURLMap.${giftListId}" value="${addToWishlistSuccessUrl}"/>
      <dsp:input type="hidden" bean="CartFormHandler.addItemToGiftlistErrorURL" value="${addToWishlistSuccessUrl}"/>
      <dsp:input type="hidden" bean="GiftlistFormHandler.giftlistId" beanvalue="Profile.wishlist.id"/>
      <dsp:input type="submit" iclass="atg_store_textButton" bean="CartFormHandler.addItemToWishlist" value="${addToWishListText}" submitvalue="${giftListId}" name="${giftListId}" />
      
    </c:when>
    <c:otherwise>
      <%-- Otherwise just navigate the user to his wishlist --%>
      <c:url value="/myaccount/myWishList.jsp" var="wishListUrl" scope="page"/>
      <dsp:a href="${wishListUrl}">
				<dsp:param name="selpage" value="WISHLIST"/>
        <fmt:message key="common.button.addToWishListText"/>
      </dsp:a>
    </c:otherwise>
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productAddToWishList.jsp#1 $$Change: 633540 $ --%>