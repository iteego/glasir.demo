<dsp:page>
  <%-- 
    Layout page without color/size picker.
    
    For items that have multiple SKUs but no size or color properties
    will show a list of SKUs, each row detailing the display name, 
    item number, and price. Each SKU have a textbox present for a user
    to enter the desired quantity to add to cart. The quantity initial
    value is 0 for items with multiple SKUs and 1 if item have only 1 sku.
    
    Includes action buttons.
--%>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest" />
  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet" />
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler" />
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup" />
  <dsp:importbean bean="/atg/userprofiling/Profile" />
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler" />
  <dsp:importbean bean="/atg/userprofiling/PropertyManager" />
  <dsp:importbean bean="/atg/store/profile/SessionBean" />
  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList" />
  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListContains" />
  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListHandler" />

  <dsp:droplet name="ProductLookup">
    <dsp:param name="id" param="productId" />
    <dsp:oparam name="output">
      <dsp:setvalue param="product" paramvalue="element" />

      <%-- Filter out the skus --%>
      <dsp:droplet name="CatalogItemFilterDroplet">
        <dsp:param name="collection" param="product.childSKUs" />
        <dsp:oparam name="output">
          <div class="atg_store_selectAttributes">
            <dsp:form id="addToCart" formid="atg_store_addToCart"
                      action="${originatingRequest.requestURI}" method="post" name="addToCart">

              <dsp:getvalueof var="filteredCollection" param="filteredCollection" />
              <%-- collection of SKUs to iterate on --%>
              <dsp:getvalueof id="collectionSize" value="${fn:length(filteredCollection)}" />
  
              <%-- number of elements to allocate in the items array --%>
              <dsp:input bean="CartFormHandler.addItemCount" value="${collectionSize}" type="hidden" />
  
              <dsp:getvalueof var="contextRoot" vartype="java.lang.String" bean="/OriginatingRequest.contextPath" />
  
              <dsp:getvalueof var="productId" param="productId" />
              <dsp:getvalueof var="categoryId" param="categoryId" />
  
              <dsp:getvalueof var="productTemplateURL" vartype="java.lang.String" param="product.template.url" />
              <dsp:getvalueof var="errorURL" vartype="java.lang.String"
                value="${originatingRequest.contextPath}${productTemplateURL}?productId=${productId}&categoryId=${categoryId}" />
  
              <%-- Hidden URLs parameters --%>
              <dsp:input bean="CartFormHandler.addItemToOrderErrorURL" type="hidden" value="${errorURL}" />
              <dsp:input bean="CartFormHandler.addItemToOrderSuccessURL" type="hidden" value="${originatingRequest.contextPath}/cart/cart.jsp" />
              <dsp:input bean="CartFormHandler.sessionExpirationURL" type="hidden" value="${originatingRequest.contextPath}/global/sessionExpired.jsp" />
              <%-- URLs for the RichCart AJAX response. Renders cart contents as JSON --%>
              <dsp:input bean="CartFormHandler.ajaxAddItemToOrderSuccessUrl" type="hidden"
                value="${originatingRequest.contextPath}/cart/json/cartContents.jsp" />
              <dsp:input bean="CartFormHandler.ajaxAddItemToOrderErrorUrl" type="hidden" value="${originatingRequest.contextPath}/cart/json/errors.jsp" />
  
              <%--
                sets default quantity. if item have more than 1 sku then quantity is 0,
                otherwise 1
              --%>
              <c:set var="defaultQuantity" value="1" />
              <c:if test="${collectionSize > 1}">
                <c:set var="defaultQuantity" value="0" />
              </c:if>
  
              <%--
                Iterate over the list of SKUs to show display name,
                item id, price, and quantity textbox
              --%>
              <ul class="atg_store_singleSku">
                <c:forEach var="sku" items="${filteredCollection}" varStatus="status">
                  <li><dsp:param name="selectedSku" value="${sku}" /> <dsp:input bean="CartFormHandler.items[${status.index}].catalogRefId"
                    paramvalue="selectedSku.repositoryId" type="hidden" /> <dsp:input bean="CartFormHandler.items[${status.index}].productId"
                    paramvalue="product.repositoryId" type="hidden" /> <%-- display name --%>
                  <p class="item_name"><dsp:valueof param="selectedSku.displayName" /></p>
  
                 
                   
                  <%-- price --%> 
                  <%@include file="/browse/gadgets/pickerPriceAttribute.jspf"%>
                   <%-- item id --%> 
                   <%@include file="/browse/gadgets/pickerItemId.jspf"%>
                   <%-- SKU availability message --%>
                   <%@include file="/browse/gadgets/pickerAvailabilityMessage.jspf"%> 
                  <%-- quantity  with initial 0 value --%>
                  <p class="atg_store_quantity"><span class="atg_store_pickerLabel"> <fmt:message key="common.qty" /><fmt:message
                    key="common.labelSeparator" /> </span> <dsp:input  iclass="atg_store_numericInput" name="atg_store_quantityField${status.index}" size="2"
                    type="text" value="${defaultQuantity}" bean="CartFormHandler.items[${status.index}].quantity"
                    class="atg_store_numericInput" /></p>
                  
                    
                  </li>
                </c:forEach>
              </ul>
              

              <%@include file="pickerActions.jspf"%>

            </dsp:form>
          </div>

          <%@include file="pickerRefreshForm.jspf"%>

        </dsp:oparam>
      </dsp:droplet>

    </dsp:oparam>
  </dsp:droplet>
  <%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/skuListingLayout.jsp#2 $$Change: 633752 $--%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/skuListingLayout.jsp#2 $$Change: 633752 $--%>