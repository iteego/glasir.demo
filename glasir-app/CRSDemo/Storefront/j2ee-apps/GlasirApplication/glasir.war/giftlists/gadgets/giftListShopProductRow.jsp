<dsp:page>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/commerce/catalog/SKULookup"/>
  
  <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof var="originatingRequest" bean="/OriginatingRequest"/>
  
  <dsp:getvalueof id="count" param="count"/>
  <dsp:getvalueof id="size" param="size"/>
  <dsp:getvalueof id="displaySiteIndicator" param="displaySiteIndicator"/>
  <dsp:getvalueof id="errorPath" param="errorPath"/>
  
  <dsp:droplet name="SKULookup">
    <dsp:param name="id" param="giftlistitem.catalogRefId"/>
    <dsp:oparam name="output">
      <dsp:getvalueof var="sku" param="element"/>
    </dsp:oparam>
    <dsp:oparam name="wrongCatalog">
      <dsp:getvalueof var="sku" param="element"/>
    </dsp:oparam>
    <dsp:oparam name="wrongSite">
      <dsp:getvalueof var="sku" param="element"/>
    </dsp:oparam>
  </dsp:droplet>
  
  <dsp:setvalue param="sku" value="${sku}"/>
  
      <tr class="<crs:listClass count="${count}" size="${size}" selected="false"/>">
        <c:if test="${displaySiteIndicator}">
          <td class="site">
            <dsp:include page="/global/gadgets/siteIndicator.jsp">
              <dsp:param name="mode" value="icon"/>              
              <dsp:param name="siteId" param="giftlistitem.siteId"/>
              <dsp:param name="product" param="product"/>
            </dsp:include>
          </td>
        </c:if>
        
        <td class="image">
        
          <dsp:getvalueof var="skuThumbnailImageUrl" param="sku.thumbnailImage.url"/>
          <c:choose>
            <c:when test="${empty skuThumbnailImageUrl}">
              <dsp:include page="/browse/gadgets/productThumbImg.jsp">
                <dsp:param name="product" param="product"/>
                <dsp:param name="siteId" param="giftlistitem.siteId"/>
              </dsp:include>
            </c:when>

            <c:otherwise>
              <dsp:include page="/browse/gadgets/productThumbImg.jsp">
                <dsp:param name="product" param="product"/>
                <dsp:param name="siteId" param="giftlistitem.siteId"/>
                <dsp:param name="alternateImage" param="sku.thumbnailImage"/>
              </dsp:include>
            </c:otherwise>
          </c:choose><%-- End is empty check on the SKU thumbnail image --%>
        </td>
				
        <td class="item">
          <%-- Get this products template --%>
          <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="product.template.url"/>
          <c:choose>
            <%-- If the product has a template generate a link --%>
            <c:when test="${not empty pageurl}">
              <p class="name">
                <dsp:include page="/global/gadgets/crossSiteLink.jsp">
                  <dsp:param name="product" param="product"/>
                  <dsp:param name="siteId" param="giftlistitem.siteId"/>
                </dsp:include>
              </p>
            </c:when>
            <%-- Otherwise just display the displayname --%>
            <c:otherwise>
              <dsp:valueof param="product.displayName">
                <fmt:message key="common.noDisplayName"/>
              </dsp:valueof>
            </c:otherwise>
          </c:choose>

          <dsp:include page="/global/util/displaySkuProperties.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="sku" param="sku"/>
            <dsp:param name="displayAvailabilityMessage" value="true"/>
          </dsp:include>

          <dsp:getvalueof var="skuDescription" param="sku.description"/>
          <c:if test="${not empty skuDescription}">                             
            <dsp:valueof param="sku.description"/>
            <br />
          </c:if>
        </td>
        <td class="atg_store_productPrice">
          <dl>
            <dsp:include page="/global/gadgets/priceLookup.jsp">
              <dsp:param name="product" param="product"/>
              <dsp:param name="sku" param="sku"/>
            </dsp:include>
          </dl>    
        </td>
        <%-- Total Number Requested--%>
        <td class="requstd">
          <dsp:getvalueof var="quantityDesired" vartype="java.lang.Double" param="giftlistitem.quantityDesired"/>
          <fmt:formatNumber value="${quantityDesired}" type="number"/>
        </td>
        <td class="remain">
          <dsp:getvalueof var="quantity" vartype="java.lang.Double"
                          param="giftlistitem.quantityRemaining"/>
          <fmt:formatNumber value="${quantity}" type="number"/>
        </td>
        <td class="quantity"> 
          <dsp:form id="addToCart" formid="addToCart"
                    action="${originatingRequest.requestURI}" method="post"
                    name="addToCart">
                    
            <%-- Set the items siteId --%>
            <dsp:input bean="CartFormHandler.siteId" paramvalue="giftlistitem.siteId" type="hidden"/>
            
            <%-- quantity input field --%>
            
            <%-- Check inventory --%>
            <dsp:include page="/global/gadgets/multiSkuAvailabilityLookup.jsp">
              <dsp:param name="product" param="product"/>
              <dsp:param name="skuId" param="sku.repositoryId"/>
            </dsp:include>

            <c:choose>
              <c:when test="${showNotifyButton == true}">
                <div class="atg_store_productAvailability">
              
                  <dsp:input bean="CartFormHandler.quantity" size="2"
                             type="hidden" iclass="atg_store_quantity" value="0" id="atg_store_quantity1"/>
                  <dsp:getvalueof var="sid" vartype="java.lang.String"
                                  param="sku.repositoryId"/>
                  <dsp:getvalueof var="pid" vartype="java.lang.String"
                                param="product.repositoryId"/>
                  <fmt:message var="linkTitle" key="common.button.emailMeInStockTitle"/>
                  <dsp:a target="popup" href="${contextroot}/browse/notifyMeRequestPopup.jsp?skuId=${sid}&productId=${pid}"
                         title="${linkTitle}" iclass="atg_store_basicButton atg_store_emailMe" >
                    <span><fmt:message key="common.button.emailMeInStockText"/></span>
                  </dsp:a>
                  <div class="atg_store_emailMeMessage">
                    <fmt:message key="common.whenAvailable"/>
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <dsp:input bean="CartFormHandler.quantity" type="text" value="0" size="2"
                           iclass="atg_store_quantity atg_store_numericInput" id="atg_store_quantity1"/>
                <%-- Hidden params for redirects --%>         
                <dsp:input bean="CartFormHandler.addItemToOrderErrorURL" type="hidden" paramvalue="errorPath"/>
                <dsp:input bean="CartFormHandler.addItemToOrderSuccessURL" type="hidden"
                           value="${contextroot}/cart/cart.jsp"/>
                
                <%-- URLs for the RichCart AJAX response. Renders cart contents as JSON --%>
                <dsp:input bean="CartFormHandler.ajaxAddItemToOrderSuccessUrl" type="hidden" 
                           value="${contextroot}/cart/json/cartContents.jsp"/>
                <dsp:input bean="CartFormHandler.ajaxAddItemToOrderErrorUrl" type="hidden" 
                           value="${contextroot}/cart/json/errors.jsp"/>
                           
                <dsp:input bean="CartFormHandler.sessionExpirationURL" type="hidden"
                           value="${contextroot}/global/sessionExpired.jsp"/>
                
                <dsp:input bean="CartFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
                <dsp:input bean="CartFormHandler.catalogRefIds" paramvalue="sku.repositoryId" type="hidden"/>                   
                <dsp:input bean="CartFormHandler.giftlistItemId" paramvalue="giftlistitem.id" type="hidden" />
                <dsp:input bean="CartFormHandler.giftlistId" paramvalue="giftlist.id" type="hidden" />
                <c:choose>
                  <c:when test="${availabilityType == 'preorderable'}">
                    <span class="atg_store_basicButton add_to_cart_link_preorder">
                      <dsp:input bean="CartFormHandler.addItemToOrder" type="submit"
                                 value="${addButtonText}" title="${addButtonTitle}" iclass="atg_behavior_addItemToCart"/>
                    </span>
                  </c:when>

                  <c:when test="${availabilityType == 'backorderable'}">
                    <span class="atg_store_basicButton add_to_cart_link_backorder">
                      <dsp:input bean="CartFormHandler.addItemToOrder" type="submit"
                                 value="${addButtonText}" title="${addButtonTitle}" iclass="atg_behavior_addItemToCart"/>
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="atg_store_basicButton add_to_cart_link">
                      <dsp:input bean="CartFormHandler.addItemToOrder" type="submit" value="${addButtonText}"
                                 title="${addButtonTitle}" alt="${addButtonTitle}" iclass="atg_behavior_addItemToCart" />                  
                    </span>
                  </c:otherwise>
                </c:choose>
              </c:otherwise>
            </c:choose>
            
          </dsp:form>
        </td>   
        
      </tr>
      
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/giftlists/gadgets/giftListShopProductRow.jsp#3 $$Change: 635969 $--%>
