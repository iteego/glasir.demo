<dsp:page>

  <%-- This page expects the following parameters
       1. product - the product repository item to display
       2. imagesize - the size of image to render (thumbnail or promo)
                      default is promo.
       3. categoryId - the repository ID of the product's category
  --%>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  
  <dsp:getvalueof var="productParam" param="product"/>
  <dsp:getvalueof var="categoryIdParam" param="categoryId"/>
  <dsp:getvalueof var="skuIdParam" param="product.childSKUs[0].repositoryId"/>
  <dsp:getvalueof var="skuParam" param="product.childSKUs[0]"/>
  <dsp:getvalueof var="size" value="${fn:length(product.childSKUs)}"/>
            
  <dsp:droplet name="Compare">
    <dsp:param name="obj1" value="${size}" converter="number"/>
    <dsp:param name="obj2" value="1" converter="number"/>
      
    <dsp:oparam name="default">
      <dsp:getvalueof var="canAddToCart" value="false"/>
      <dsp:getvalueof var="pageUrl" param="product.template.url"/>
      
      <span class="atg_store_promoProductImage">
        <dsp:a page="${pageUrl}">
          <dsp:param name="productId" param="product.repositoryId"/>
          <dsp:param name="categoryId" param="categoryId"/>
          <dsp:getvalueof var="imagesize" param="imagesize"/>
          <c:choose>
            <c:when test="${imagesize == 'thumbnail'}">
              <dsp:include page="/browse/gadgets/productThumbImg.jsp">
                <dsp:param name="product" param="product"/>
                <dsp:param name="showAsLink" value="false"/>
              </dsp:include>
            </c:when>
            <c:otherwise>
              <dsp:include page="/browse/gadgets/productPromoImg.jsp">
                <dsp:param name="product" param="product"/>
                <dsp:param name="categoryId" param="categoryId"/>
                <dsp:param name="alt" param="product.displayName"/>
                <dsp:param name="showAsLink" value="false"/>
              </dsp:include>
            </c:otherwise>
          </c:choose>
        </dsp:a>
      </span>
         
      <dsp:a page="${pageUrl}">
        <dsp:param name="productId" param="product.repositoryId"/>
        <dsp:param name="categoryId" param="categoryId"/>
              
        <%-- DISPLAY NAME --%>
        <div class="atg_store_productInfo">
        <dsp:getvalueof var="productDisplayName" param="product.displayName"/>
        <span class="atg_store_productTitle"> 
          <c:choose>
            <c:when test="${fn:length(productDisplayName) < 25}" >
                  ${productDisplayName}
            </c:when>
            <c:when test="empty productDisplayName">
              <fmt:message key="browse_recommendedProducts.displayNameDefault" />
            </c:when>
            <c:otherwise>
              <c:set var="myTest" value="${fn:substring(productDisplayName, 0, 25)}"/>
              <c:out value="${myTest}..."/>
            </c:otherwise>
          </c:choose>
        </span>

  

        <%-- Size is not one, show link --%>
        <%-- Display Price Range (and Get Details link)--%>
        <span class="atg_store_productPrice">
          <dsp:include page="/global/gadgets/priceRange.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="isNeedTags" value="false"/>
          </dsp:include>
        </span> 
  
        <span class="add_to_cart_text">
          <fmt:message key="common.promotionalContent.getDetails"/>
        </span></div>
      </dsp:a>
    </dsp:oparam>
  </dsp:droplet> <%-- End Compare droplet to see if the product has a single sku --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/promo/gadgets/cartFeaturedProduct.jsp#2 $$Change: 635969 $--%>
     