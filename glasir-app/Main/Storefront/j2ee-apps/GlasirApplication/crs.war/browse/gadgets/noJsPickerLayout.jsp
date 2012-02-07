<%--
  This page expects the following parameters:
    product - current displayed product
    skus - collection of product's child SKUs
    categoryId - current displayed category ID (optional)
  
  This page displays a non-JavaScript version of SKU picker
--%>
<dsp:page>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>

  <%-- Get useful properties as EL variables, for future use in the URL construction processes --%>
  <dsp:getvalueof var="contextRoot" vartype="java.lang.String"  bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof var="uri" vartype="java.lang.String"  bean="/OriginatingRequest.requestURI"/>
  <dsp:getvalueof var="productId" param="product.repositoryId"/>
  <dsp:getvalueof var="categoryId" param="categoryId"/>
  <dsp:getvalueof var="status" param="status"/>
  
  <%-- Choose what to display --%>
  <c:choose>
    <%-- When unavailable status display the please notify me dialog --%>
	  <c:when test="${status == 'unavailable'}">
	    <dsp:include page="/browse/noJavascriptNotifyMeRequest.jsp">
	      <dsp:param name="redirectURL" value="${uri}?productId=${productId}&categoryId=${categoryId}"/>
	      <dsp:param name="productId" param="productId"/>
	      <dsp:param name="skuId" param="skuId"/>
	    </dsp:include>
	  </c:when>
	  <%-- When emailSent display the we'll notify you dialog --%>
	  <c:when test="${status == 'emailSent'}">
	    <dsp:include page="/browse/noJavascriptNotifyMeConfirm.jsp"/>
	  </c:when>
	  <c:otherwise>
		  <%-- All contents are displayed as a single form, cause there is a need to work simultaneously with several form handlers
		      and there is a need to send multiple parameters in a single user click --%>
		  <div id="no_js_picker_contents">
		    <dsp:form method="post" action="${uri}" id="pickerForm" formid="pickerForm">
		      <div id="atg_store_picker">
		        <div class="atg_store_selectAttributes">
		          <div class="atg_store_pickerContainer">
		      
		                      <div class="atg_store_productPrice">
		                        <dsp:include page="/global/gadgets/priceRange.jsp">
		                          <dsp:param name="product" param="product"/>
		                          <dsp:param name="showPriceLabel" value="true"/>
		                        </dsp:include>
		                      </div>
		            
		
		            <div class="atg_store_pickerLabel">
		              <%-- A 'Color/Size' label --%>
		              <fmt:message key="common.color"/><fmt:message key="common.separator"/><fmt:message key="common.size"/>:
		            </div>
		            
		            <%-- The number of skus in the sku picker --%>
		            <c:set var="skuCount" value="0"/>
		            
		            <%-- Start of Color/Size selector pane --%>
		            <div class="atg_store_colorSizePicker">
		              <%-- SKU ID to be added into shopping cart or into gift/wish list is saved into SessionBean,
		                  then this ID is taken by form handlers during their initialization (there are links in the *.properties files
		                  from form handlers to the SessionBean)
		                  This solution enables us to save value into multiple form handlers properties from a single HTML element --%>
		              <dsp:select bean="/atg/store/profile/RequestBean.skuIdToAdd" priority="10">
		                <dsp:droplet name="/atg/dynamo/droplet/ForEach">
		                  <dsp:param name="array" param="skus"/>
		                  
		                  <dsp:oparam name="output">
                            <dsp:setvalue param="sku" paramvalue="element"/>
		                    <dsp:getvalueof var="skuId" vartype="java.lang.String" param="sku.repositoryId"/>
		                    <dsp:option value="${skuId}">              
		                      <%-- Count the number of skus --%>
		                      <c:set var="skuCount" value="${skuCount + 1}"/>
		                      <%-- Each SKU is displayed in the following format: '[SKU ID]: [Color]/[Size] $[Price]' --%>
		                      <dsp:valueof param="sku.repositoryId"/><fmt:message key="common.labelSeparator"/>
		                      <dsp:valueof param="sku.color"/><fmt:message key="common.separator"/><dsp:valueof param="sku.size"/>
		                      <dsp:droplet name="/atg/commerce/pricing/priceLists/PriceDroplet">
		                        <dsp:param name="product" param="product"/>
		                        <dsp:param name="sku" param="sku"/>
		                        <dsp:oparam name="output">
		                          <dsp:getvalueof var="listPrice" param="price.listPrice"/>
		                          <dsp:droplet name="/atg/commerce/pricing/priceLists/PriceDroplet">
		                            <dsp:param name="priceList" bean="Profile.salePriceList"/>
		                            <dsp:oparam name="output">
		                              <%-- Found sale price, display it instead of list price --%>
		                              <dsp:getvalueof var="salePrice" param="price.listPrice"/>
		                              <dsp:include page="/global/gadgets/formattedPrice.jsp">
		                                <dsp:param name="price" value="${salePrice}"/>
		                              </dsp:include>
		                            </dsp:oparam>
		                            <dsp:oparam name="empty">
		                              <%-- Item is not on sale, display list price --%>
		                              <dsp:include page="/global/gadgets/formattedPrice.jsp">
		                                <dsp:param name="price" value="${listPrice}"/>
		                              </dsp:include>
		                            </dsp:oparam>
		                          </dsp:droplet>
		                        </dsp:oparam>
		                      </dsp:droplet>
		                    </dsp:option>
		                  </dsp:oparam>
		                </dsp:droplet>
		              </dsp:select>
		              
		              <c:if test="${skuCount > 1}">
		                <strong class="details">
		                  <a href="gadgets/sizeChart.jsp" target="_blank" class="chart atg_store_help">
		                    <fmt:message key="browse_picker.sizeChart"/>
		                  </a>
		                </strong>
		             </c:if>
		             
		            </div><%-- end of atg_store_colorSizePicker --%>
		            <%-- Start of Add to Cart pane --%>
		            <div class="atg_store_priceQtyAddToCartContainer">
		              <div class="atg_store_priceQtyAddToCart">
		      
		                <div class="atg_store_addQty">
		                <div class="atg_store_quantity">
		                  <span class="atg_store_pickerLabel">
		                    <fmt:message key="common.qty"/><fmt:message key="common.labelSeparator"/>
		                  </span>
		                  <dsp:input bean="CartFormHandler.addItemToOrderErrorURL" 
		                      value="${uri}?productId=${productId}&categoryId=${categoryId}" type="hidden"/>
		                  <dsp:input bean="CartFormHandler.addItemToOrderSuccessURL" value="${contextRoot}/cart/cart.jsp" type="hidden"/>
		                  <dsp:input bean="CartFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
		                  <dsp:input bean="CartFormHandler.quantity" id="atg_store_quantityField_nojs" value="1"
		                      size="2">
		                      <dsp:tagAttribute name="maxlength" value="5"/>
		                  </dsp:input>
		                  <dsp:input bean="CartFormHandler.skuUnavailableURL" 
		                    value="${uri}?productId=${productId}&categoryId=${categoryId}&status=unavailable&skuId=${skuId}" type="hidden"/>
		                </div>
		                
		                
		                <div class="atg_store_productAvailability">
		                <span class="atg_store_basicButton add_to_cart_link">
		                  <fmt:message key="common.button.addToCartText" var="addToCartCaption"/>
		                  <dsp:input bean="CartFormHandler.addItemToOrder" type="submit" iclass="atg_behavior_addItemToCart"
		                      value="${addToCartCaption}"/>
		                </span>
		                </div>
		              </div>
		            </div><%-- End of atg_store_priceQtyAddToCartContainer --%>
		          </div>
		        </div>
		        </div>
		      </div><%-- End of atg_store_picker --%>
		      
		      <dsp:input bean="GiftlistFormHandler.addItemToGiftlistSuccessURL" value="${uri}?productId=${productId}&categoryId=${categoryId}" 
		          type="hidden"/>
		      <dsp:input bean="GiftlistFormHandler.addItemToGiftlistErrorURL" type="hidden"
		          value="${uri}?productId=${productId}&categoryId=${categoryId}"/>
		      <dsp:input bean="GiftlistFormHandler.addItemToGiftlistLoginURL" value="${contextRoot}/global/util/loginRedirect.jsp" type="hidden"/>
		      <dsp:input bean="GiftlistFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
		      <dsp:input bean="GiftlistFormHandler.quantity" value="1" type="hidden"/>
		      <dsp:input bean="GiftlistFormHandler.siteId" beanvalue="/atg/multisite/Site.id" type="hidden"/>
		      
		      <%-- Start of 'Gift List' - ... - 'Email' buttons pane --%>
		      <div class="atg_store_pickerActions">
		        <ul id="moreactions">
		          <%-- 'Gift List' button --%>
		          <dsp:getvalueof var="isTransient" bean="Profile.transient"/>
		          <c:if test="${isTransient == 'false'}">
		            <dsp:getvalueof var="giftlists" bean="Profile.giftlists"/>
		            <c:if test="${not empty giftlists}">
		                <dsp:droplet name="/atg/commerce/collections/filter/droplet/GiftlistSiteFilterDroplet">
		                  <dsp:param name="collection"  bean="Profile.giftlists"/>
		                  <dsp:oparam name="output">
		                    <dsp:getvalueof var="filteredGiftLists" param="filteredCollection"/>
		                    <c:if test="${not empty filteredGiftLists}">
                          <li class="atg_store_giftListsActions">
                            <a href="#"><fmt:message key="common.button.addToGiftListText" /></a>
    		                    <div class="atg_store_giftListMenuContainer">
    		                      <h4>Add this item to Gift List:</h4>
    		                      <ul class="atg_store_giftListMenu">
    		                        <c:forEach var="giftlist" items="${filteredGiftLists}">
    		                          <dsp:param name="giftlist" value="${giftlist}"/>
    		                          <dsp:getvalueof var="giftlistId" param="giftlist.repositoryId" vartype="java.lang.String" />
    		                          <dsp:getvalueof var="giftlistName" param="giftlist.eventName" vartype="java.lang.String"/>
    		                          <li>
    		                            <dsp:input bean="GiftlistFormHandler.giftlistIdToValue.${giftlistId}" value="${giftlistName}" type="submit"/>
    		                          </li>
    		                        </c:forEach>
    		                      </ul>
  		                      </div>
                          </li>
		                    </c:if>
		                  </dsp:oparam>
		                </dsp:droplet>
		            </c:if>
		          </c:if>
		          <%-- 'Wish List' button --%>
		          <li class="atg_store_wishListsActions">
		            <dsp:getvalueof bean="Profile.wishlist.id" var="wishlistId" vartype="java.lang.String"/>
		            <fmt:message key="common.button.addToWishListText" var="addToWishlistCaption"/>
		            <dsp:input bean="GiftlistFormHandler.giftlistIdToValue.${wishlistId}" value="${addToWishlistCaption}" type="submit" iclass="atg_store_textButton"/>
		          </li>
		          <%-- 'Comparisons' button --%>
		          <li class="atg_store_compareActions">
		            <dsp:droplet name="/atg/commerce/catalog/comparison/ProductListContains">
		              <dsp:param name="productList" bean="/atg/commerce/catalog/comparison/ProductList"/>
		              <dsp:param name="productID" param="product.repositoryId"/>
		              <dsp:oparam name="false">
		                <dsp:include page="/browse/gadgets/productAction.jsp">
		                  <dsp:param name="product" param="product"/>
		                  <dsp:param name="categoryId" param="categoryId"/>
		                  <dsp:param name="action" value="compare"/>
		                </dsp:include>
		              </dsp:oparam>
		              <dsp:oparam name="true">
		                <fmt:message var="linkTitle" key="browse_productAction.viewComparisonsTitle"/>
		                <dsp:a page="/browse/productComparisons.jsp" title="${linkTitle}">
		                  <fmt:message key="browse_productAction.viewComparisonsLink"/>
		                </dsp:a>
		              </dsp:oparam>
		            </dsp:droplet>
		          </li>
		          <%-- 'Email' button --%>
		          <li class="atg_store_emailActions">
		            <dsp:include page="/browse/gadgets/productAction.jsp">
		              <dsp:param name="product" param="product"/>
		              <dsp:param name="categoryId" param="categoryId"/>
		              <dsp:param name="action" value="emailFriend"/>
		            </dsp:include>
		          </li>
		        </ul>
		      </div>
		    </dsp:form>
		  </div>
	  </c:otherwise>            
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/noJsPickerLayout.jsp#2 $$Change: 633752 $--%>
