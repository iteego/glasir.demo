<dsp:page>

<%-- 
  Layout with color/size picker.
  
  This page expects the following input parameters:
     product - the product object whose details are shown
     picker - set the attribute picker which will be rendered
     categoryId (optional) - the id of the category the product is viewed from
     tabname (optional) - the name of a more details tab to display
     initialQuantity (optional) - sets the initial quantity to preset in the form
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
    <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/atg/store/profile/SessionBean"/>
  

  <dsp:getvalueof id="picker" param="picker" />
  <dsp:getvalueof id="navCategory" param="navCategory" />

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
      
      <div id="promptSelectDIV" class="promptSelectDIV">
        <fmt:message key="browse_picker.beforeAddingToCartMessage"/>
      </div>
      <div id="promptSelectDIV2" class="promptSelectDIV">
        <fmt:message key="browse_picker.beforeAddingToWishListMessage"/>
      </div>
      <div id="promptSelectDIV3" class="promptSelectDIV">
        <fmt:message key="browse_picker.beforeAddingToGiftListMessage"/>
      </div>
      
      <div id="atg_store_productCore" class="atg_store_productWithPicker">

        <%-- Items that will not change and appear together are cached and handled here --%>
        <div class="atg_store_productImageContainer">
          <div class="atg_store_productImage">
            <dsp:include page="gadgets/cacheProductDisplay.jsp">
              <dsp:param name="product" param="product"/>
              <dsp:param name="container" value="/browse/gadgets/productImage.jsp"/>
              <dsp:param name="categoryId" param="categoryId"/>
              <dsp:param name="keySuffix" value="image"/>
            </dsp:include>
          </div>
        </div>
        <div class="atg_store_productSummaryContainer">
        <div class="atg_store_productSummary">
          <dsp:getvalueof var="contextRoot" vartype="java.lang.String"  bean="/OriginatingRequest.contextPath"/>
  
            <%-- because this page is called directly using ajax, it must look up the product --%>
            <dsp:droplet name="ProductLookup">
              <dsp:param name="id" param="productId"/>

              <dsp:oparam name="output">
                <dsp:setvalue param="product" paramvalue="element"/>
          
                <dsp:getvalueof var="productTemplateURL" vartype="java.lang.String" param="product.template.url"/>
                <c:url value="${productTemplateURL}" context="${originatingRequest.contextPath}" var="errorURL">
                  <c:param name="productId" value="${productId}"/>
                  <c:param name="categoryId" value="${categoryId}"/>
                </c:url>
                
                <dsp:getvalueof var="skus" param="product.childSKUs" />
                <dsp:getvalueof var="skulength" value="${fn:length(skus)}" />
          
                <%-- Filter out the skus --%>
                <dsp:droplet name="CatalogItemFilterDroplet">
                  <dsp:param name="collection" param="product.childSKUs"/>
                  
                  <dsp:oparam name="output">
                    
                    <dsp:include page="${picker}">
                        <dsp:param name="product" param="product"/>
                        <dsp:param name="categoryId" param="categoryId"/>
                        <dsp:param name="skus" param="filteredCollection"/>
                    </dsp:include>

                  </dsp:oparam>
                </dsp:droplet><%-- CatalogItemFilterDroplet --%>
              </dsp:oparam>
            </dsp:droplet><%-- ProductLookup --%>   

          <%-- Items that will not change and appear together are cached and handled here --%>
          
    
        </div>       
      </div>
              <dsp:include page="gadgets/cacheProductDisplay.jsp">
                <dsp:param name="product" param="product"/>
                <dsp:param name="container" value="/browse/gadgets/productAttributes.jsp"/>
                <dsp:param name="categoryId" param="categoryId"/>
                <dsp:param name="keySuffix" value="details"/>
                <dsp:param name="initialQuantity" param="initialQuantity" />
              </dsp:include>
      
      </div>
      
      <dsp:include page="gadgets/recommendedProducts.jsp">
        <dsp:param name="product" param="product"/>
      </dsp:include>
      
      <%-- Items that will not change and appear together are cached and handled here --%>
      <dsp:include page="gadgets/cacheProductDisplay.jsp">
        <dsp:param name="product" param="product"/>
        <dsp:param name="container" value="/browse/gadgets/recommendedCategories.jsp"/>
        <dsp:param name="categoryId" param="categoryId"/>
        <dsp:param name="keySuffix" value="aux"/>
      </dsp:include>

    </jsp:body>
  </crs:pageContainer>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/productDetailDisplay.jsp#2 $$Change: 635969 $ --%>
