<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object whose details are shown
       colorSizePicker (optional) - set to true to show the color size picker
       categoryId (optional) - the id of the category the product is viewed from
       tabname (optional) - the name of a more details tab to display
       initialQuantity (optional) - sets the initial quantity to preset in the form
    --%>

  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest" />
  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet" />

  <crs:pageContainer bodyClass="atg_store_pageProductDetail">
    <jsp:attribute name="SEOTagRenderer">
      <dsp:include page="/global/gadgets/metaDetails.jsp" flush="true">
        <dsp:param name="catalogItem" param="product"/>     
      </dsp:include>
    </jsp:attribute>
    <jsp:body>
    
    <dsp:include page="/browse/gadgets/itemHeader.jsp">
      <dsp:param name="displayName" param="product.displayName"/>
      <dsp:param name="category" param="navCategory"/>
      <dsp:param name="categoryNavIds" param="categoryNavIds"/> 
    </dsp:include>
    
    <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
      <dsp:param name="formHandler" bean="CartFormHandler"/>
    </dsp:include>
    <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
      <dsp:param name="formHandler" bean="GiftlistFormHandler"/>
    </dsp:include>
    
    <div id="atg_store_productCore" class="atg_store_productMultiSkuWide">
    
    <dsp:droplet name="CatalogItemFilterDroplet">
      <dsp:param name="collection" param="product.childSKUs" />
      <dsp:oparam name="output">
    
      <div class="atg_store_productImageContainer">
        <div class="atg_store_productImage">
          <dsp:include page="gadgets/cacheProductDisplay.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="container" value="/browse/gadgets/productImage.jsp"/>
            <dsp:param name="categoryId" param="categoryId"/>
            <dsp:param name="keySuffix" value="image"/>
          </dsp:include>
        </div>
        
        <dsp:include page="gadgets/cacheProductDisplay.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="container" value="/browse/gadgets/productAttributes.jsp"/>
          <dsp:param name="categoryId" param="categoryId"/>
          <dsp:param name="keySuffix" value="details"/>
          <dsp:param name="initialQuantity" param="initialQuantity" />
        </dsp:include>
      </div>
 
      
          <dsp:getvalueof var="contextRoot" vartype="java.lang.String" bean="/OriginatingRequest.contextPath" />

          <dsp:getvalueof var="productId" param="productId" />
          <dsp:getvalueof var="categoryId" param="categoryId" />

          <dsp:getvalueof var="productTemplateURL" vartype="java.lang.String" param="product.template.url" />
          <c:url var="errorURL" value="${productTemplateURL}">
            <c:param name="productId" value="${productId}"/>
            <c:param name="categoryId" value="${categoryId}"/>
          </c:url>

          <dsp:getvalueof var="filteredCollection" param="filteredCollection" />
          <%-- collection of SKUs to iterate on --%>
          <dsp:getvalueof id="collectionSize" value="${fn:length(filteredCollection)}" />
              
        <c:forEach var="sku" items="${filteredCollection}" varStatus="status">
          <dsp:form id="addToCart${status.index}" formid="atg_store_addToCart" action="${originatingRequest.requestURI}" method="post" name="addToCart">
            <%-- Hidden URLs parameters --%>
            <dsp:input bean="CartFormHandler.addItemToOrderErrorURL" type="hidden" value="${errorURL}" />
            <dsp:input bean="CartFormHandler.addItemToOrderSuccessURL" type="hidden" value="${originatingRequest.contextPath}/cart/cart.jsp" />
            <dsp:input bean="CartFormHandler.sessionExpirationURL" type="hidden" value="${originatingRequest.contextPath}/global/sessionExpired.jsp" />
  
            <%-- URLs for the RichCart AJAX response. Renders cart contents as JSON --%>
            <dsp:input bean="CartFormHandler.ajaxAddItemToOrderSuccessUrl" type="hidden" value="${originatingRequest.contextPath}/cart/json/cartContents.jsp" />
            <dsp:input bean="CartFormHandler.ajaxAddItemToOrderErrorUrl" type="hidden" value="${originatingRequest.contextPath}/cart/json/errors.jsp" />
            
            <dsp:input bean="CartFormHandler.addItemCount" value="1" type="hidden" />
          <dsp:param name="selectedSku" value="${sku}" />
          <div class="atg_store_productSummaryContainer">
           <div class="atg_store_productSummary">
            <%-- display name --%>
            <div class="item_name">
              <dsp:valueof param="selectedSku.displayName"/>
            </div>
            <%-- price --%>
            <%@include file="/browse/gadgets/pickerPriceAttribute.jspf" %>
     
              <dsp:input bean="CartFormHandler.items[0].catalogRefId" paramvalue="selectedSku.repositoryId" type="hidden" /> 
              <dsp:input bean="CartFormHandler.items[0].productId" paramvalue="product.repositoryId" type="hidden" />
              <div class="atg_store_addQty">
                <%-- quantity --%>
                <div class="atg_store_quantity">
                  <%-- Quantity Field --%>
                  <%@include file="/browse/gadgets/pickerQuantityAttribute.jspf" %>
                  <%@include file="/browse/gadgets/pickerItemId.jspf" %>
                </div>
                <%-- 'Add to Cart' button --%>
                  
                     <div class="atg_store_productAvailability">
                        <%-- SKU id and availability status--%> 
                        <%@include file="/browse/gadgets/pickerAvailabilityMessage.jspf"%>
                  <%@include file="/browse/gadgets/pickerAddToCart.jspf" %>
                  </div>
              </div>
    
         
          <div class="atg_store_pickerActions">
            <%@include file="/browse/gadgets/pickerActions.jspf" %>
          </div>
          </div>
          </div>
          </dsp:form>
        </c:forEach>
      </dsp:oparam>
      </dsp:droplet>
    </div>
    <dsp:include page="gadgets/recommendedProducts.jsp">
      <dsp:param name="product" param="product"/>
    </dsp:include>
  </jsp:body>
  </crs:pageContainer>

  </dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/productDetailMultiSkuContainer.jsp#2 $$Change: 635969 $--%>
