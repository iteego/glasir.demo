<dsp:page>

  <%-- This page expects the following parameters
       - product - the product repository item to display
       - imagesize (optional) - the size of image to render (thumbnail or promo)
                      default is promo.
  --%>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  
  <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
    <dsp:param name="product" param="product"/>
  </dsp:include>
  <dsp:getvalueof var="pageUrl" value="${siteLinkUrl}"/>
  <dsp:getvalueof var="categoryId" param="product.parentCategory.id"/>
  
  <%-- SELECT IMAGE TO DISPLAY --%>
  <dsp:a href="${pageUrl}">
    <dsp:param name="productId" param="product.repositoryId"/>
    <c:if test="${not empty categoryId}">
      <dsp:param name="categoryId" value="${categoryId }"/>
    </c:if>
    <span class="atg_store_productImage">
      
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
            <dsp:param name="categoryId" value="${categoryId }"/>
            <dsp:param name="alt" param="product.displayName"/>
            <dsp:param name="showAsLink" value="false"/>
          </dsp:include>
        </c:otherwise>
      </c:choose>    
    </span>
 
    <%-- DISPLAY NAME --%>
      <span class="atg_store_productTitle">      
        <dsp:include page="/browse/gadgets/productName.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="categoryId" value="${categoryId }"/>
          <dsp:param name="showAsLink" value="false"/>
        </dsp:include>      
      </span>
  
      <%-- Check the size of the sku array to see how we handle things --%>
      <dsp:getvalueof var="childSKUs" param="product.childSKUs"/>
      <c:set var="totalSKUs" value="${fn:length(childSKUs)}"/>
       
      <dsp:droplet name="Compare">
        <dsp:param name="obj1" value="${totalSKUs}" converter="number"/>
        <dsp:param name="obj2" value="1" converter="number"/>
        <dsp:oparam name="equal">
          <%--                            --%>
          <%-- Size is one, just add to cart --%>
          <%-- Display Price --%>
          <span class="atg_store_productPrice">            
            <dsp:include page="/global/gadgets/priceLookup.jsp">
              <dsp:param name="product" param="product"/>
              <dsp:param name="sku" param="product.childSKUs[0]"/>
            </dsp:include>            
          </span>
                         
        </dsp:oparam>
            
        <dsp:oparam name="default">
          <%--                            --%>
          <%-- Size is not one, show link --%>
          <%-- Display Price Range (and Get Details link)--%>
          
          <span class="atg_store_productPrice">            
            <dsp:include page="/global/gadgets/priceRange.jsp">
              <dsp:param name="product" param="product"/>
            </dsp:include>            
          </span>
            
        </dsp:oparam>
      </dsp:droplet> <%-- End Compare droplet to see if the product has a single sku --%>
                   
    <dsp:include page="/global/gadgets/siteIndicator.jsp">
      <dsp:param name="mode" value="name"/>              
      <dsp:param name="product" param="product"/>
      <dsp:param name="displayCurrentSite" value="false"/>
    </dsp:include>
  </dsp:a>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/promo/gadgets/promotionalItemRenderer.jsp#3 $$Change: 635969 $--%>
