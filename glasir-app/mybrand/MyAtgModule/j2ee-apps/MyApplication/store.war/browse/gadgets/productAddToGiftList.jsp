<dsp:page>

  <%-- 
    Displays Add to gift list link.
    This page requires the following parameters:
      product - product to be added to giftlist
      sku - sku to be added to giftlist
      categoryId - current category id
    --%>
  
  <dsp:importbean bean="/atg/userprofiling/Profile" />
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/atg/store/profile/SessionBean"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
     
  <dsp:getvalueof var="showAddGiftList" param="showAddGiftList"/>
  
  
  <c:if test="${showAddGiftList != false}">
    <dsp:droplet name="/atg/commerce/collections/filter/droplet/GiftlistSiteFilterDroplet">
      <dsp:param name="collection"  bean="Profile.giftlists"/>
      <dsp:oparam name="output">
        <dsp:getvalueof var="filteredGiftLists" param="filteredCollection" />
        
        <c:if test="${not empty filteredGiftLists}">
          <li class="atg_store_giftListsActions">
            <a href="#"><fmt:message key="common.button.addToGiftListText" /></a>
            
            <div class="atg_store_giftListMenuContainer">
              <h4><fmt:message key="common.giftListHeader"/><fmt:message key="common.labelSeparator"/></h4>
              <ul class="atg_store_giftListMenu">
                <dsp:getvalueof var="productId" vartype="java.lang.String" param="product.repositoryId"/> 
                                                                
                <c:forEach var="giftlist" items="${filteredGiftLists}">
                  <dsp:param name="giftlist" value="${giftlist}" />
                  <li>
                    <%-- On Success Go to the GiftList page --%>
                    <dsp:getvalueof var="giftListId" param="giftlist.repositoryId" vartype="java.lang.String" />
                    <c:url var="successUrl" scope="page" value="/myaccount/giftListEdit.jsp">
                      <c:param name="productId"><dsp:valueof param="product.repositoryId"/></c:param>
                      <c:param name="giftlistId">${giftListId}</c:param>
                      <c:param name="selpage">GIFT LISTS</c:param>
                    </c:url>
										
                    <%-- On Error stay on the product page --%>
	                  <dsp:getvalueof var="templateURL" vartype="java.lang.String" param="product.template.url"/>
                    <c:url value="${templateURL}" var="errorUrl" scope="page">
                      <c:param name="productId"><dsp:valueof param="product.repositoryId"/></c:param>
                      <c:param name="categoryId" value="${categoryId}"/>
                      <c:param name="categoryNavIds"><dsp:valueof param="categoryNavIds"/></c:param>
                    </c:url>
										
                    <dsp:input type="hidden" bean="GiftlistFormHandler.giftlistId" value="${giftListId}"/>
                    <dsp:input type="hidden" bean="CartFormHandler.addItemToGiftlistSuccessURLMap.${giftListId}" value="${successUrl}"/>
                    <dsp:input type="hidden" bean="CartFormHandler.addItemToGiftlistErrorURL" value="${errorUrl}"/>
                    
                    <dsp:getvalueof var="addItemToGiftlistText" param="giftlist.eventName"/>
                    <dsp:input type="submit" bean="CartFormHandler.addItemToGiftlist" value="${addItemToGiftlistText}" submitvalue="${giftListId}" name="${giftListId}"/>
                      
                  </li>
                </c:forEach>
              </ul>
            </div>
          </li>
        </c:if><%-- gift lists are not empty--%>
      </dsp:oparam>
    </dsp:droplet>    
  </c:if><%-- showAddGiftList not false --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productAddToGiftList.jsp#1 $$Change: 633540 $ --%>