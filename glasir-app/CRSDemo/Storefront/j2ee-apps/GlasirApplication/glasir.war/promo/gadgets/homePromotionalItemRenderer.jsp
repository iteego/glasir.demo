<dsp:page>

  <%-- This page expects the following parameters
       - product - the product repository item to display
       - categoryId - the repository ID of the product's category
  --%>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <li>
  
    <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
      <dsp:param name="product" param="product"/>
    </dsp:include>
    <dsp:getvalueof var="pageUrl" value="${siteLinkUrl}"/>
  
    <%-- SELECT IMAGE TO DISPLAY --%>
    <dsp:a href="${pageUrl}">
    
    
    <span class="atg_store_productImage">
      <dsp:include page="/browse/gadgets/productThumbImg.jsp">
        <dsp:param name="product" param="product"/>
        <dsp:param name="showAsLink" value="false"/>
      </dsp:include>
    </span>
    
      <%-- DISPLAY NAME --%>
      <dsp:param name="productId" param="product.repositoryId"/>
      <dsp:param name="categoryId" param="product.parentCategory.id"/>
      <span class="atg_store_productTitle">      
        <dsp:include page="/browse/gadgets/productName.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="categoryId" param="product.parentCategory.id"/>
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
      
    </dsp:a>
  </li>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/promo/gadgets/homePromotionalItemRenderer.jsp#3 $$Change: 635969 $--%>
