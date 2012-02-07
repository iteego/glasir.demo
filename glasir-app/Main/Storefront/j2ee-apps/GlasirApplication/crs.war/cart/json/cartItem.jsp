<%-- Template that is used to render each cart item --%>
<dsp:page>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/commerce/pricing/UnitPriceDetailDroplet"/>
  
  <json:object>
  
    <%---------------------------------------------------------------------------%>
    <%-- Core properties for the item --%>
    <json:property name="name">
      <dsp:getvalueof var="displayName" scope="page" param="currentItem.auxiliaryData.productRef.displayName"/>
      <c:out value="${displayName}" escapeXml="false"/>
    </json:property>
    
    <json:property name="url" escapeXml="false">
      <dsp:getvalueof var="productId" vartype="java.lang.String" param="currentItem.auxiliaryData.productId"/>
      <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
        <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
        <dsp:param name="siteId" param="item.auxiliaryData.siteId"/>
        <dsp:param name="queryParams" value="productId=${productId}"/>
      </dsp:include>
      <dsp:getvalueof var="siteLinkUrl" param="siteLinkUrl"/>
      <c:out value="${siteLinkUrl}"/>
    </json:property>
    
    <json:property name="imageUrl">
      <dsp:getvalueof param="currentItem.auxiliaryData.catalogRef.thumbnailImage.url" var="imageUrl"/>
                
      <c:if test="${empty imageUrl}">
        <%-- No alternate image, so use product image --%>
        <dsp:getvalueof param="currentItem.auxiliaryData.productRef.thumbnailImage.url" var="imageUrl"/>
      </c:if>
      
      <%-- Render the image URL, with a default if still empty --%>
      <c:out value="${imageUrl}" default="/images/unavailable.gif" escapeXml="false"/>         
    </json:property>
    
    
    <%-- 'modified' flag to indicate if this item was just modified. This should be true
         if the item has just been added, or the quantity has just been changed.
         The rich cart will highlight and scroll into view the modified item --%>
  
    <dsp:getvalueof bean="/atg/store/order/purchase/CartFormHandler.items" var="itemsJustAdded"/>
    <c:set var="itemModified" value="${false}"/>
  
    <%-- Items have been added to the cart on this request. Check to see if this is it. --%>  
    <c:forEach items="${itemsJustAdded}" var="itemToCheck">
      <dsp:setvalue param="formHandlerItem" value="${itemToCheck}" /> 
      
      <dsp:droplet name="Compare">
        <dsp:param name="obj1" param="formHandlerItem.catalogRefId" />
        <dsp:param name="obj2" param="currentItem.catalogRefId" />
        <dsp:oparam name="equal">
          <%-- Item in the cart matches one in the formhander. Check that the quantity just added
               is non zero --%>
          <dsp:getvalueof param="formHandlerItem.quantity" var="qtyAdded"/>
          <c:if test="${qtyAdded > 0}">
            <%-- Item has just been added to the cart, so set the flag --%>
            <c:set var="itemModified" value="${true}"/>
          </c:if>
        </dsp:oparam>  
      </dsp:droplet>   
    </c:forEach> 
    <json:property name="modified" value="${itemModified}"/>
    
    <%-- Link Item - should the item's image and title be rendered as a clickable link? --%>
    <dsp:getvalueof param="currentItem.commerceItemClassType" var="itemType"/>
    <json:property name="linkItem" value="${itemType != 'giftWrapCommerceItem'}"/>

    
    <%---------------------------------------------------------------------------%>
    <%-- Pricing properties --%>  
    <dsp:tomap param="currentItem.priceInfo" var="priceInfo"/>
    
    <%-- Check to see whether the item has any priceInfo - if not, then we need to reprice the order.
         This should only need to be done once per session. --%>
    <c:if test="${empty priceInfo}"> 
      <dsp:include page="/global/gadgets/orderReprice.jsp" flush="true"/>
      <dsp:tomap param="currentItem.priceInfo" var="priceInfo"/>
    </c:if>
  
    <%-- First check to see if the item was discounted --%>
    <dsp:getvalueof var="rawPrice" param="currentItem.priceInfo.rawTotalPrice"/>
    <dsp:getvalueof var="actualPrice" param="currentItem.priceInfo.amount"/>
    
    <json:array name="prices">
      <c:choose>
        <c:when test="${rawPrice == actualPrice}">
          <%-- They match, no discounts --%>
          <json:object>
            <json:property name="quantity"><dsp:valueof param="currentItem.quantity"/></json:property>
            <json:property name="price">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" param="currentItem.priceInfo.listPrice"/>
              </dsp:include>
            </json:property>
          </json:object>
        </c:when>
        <c:otherwise>
          <%-- There's some discountin' going on --%>
          <dsp:droplet name="UnitPriceDetailDroplet">
            <dsp:param name="item" param="currentItem"/>
            <dsp:oparam name="output">
              <dsp:getvalueof var="unitPriceBeans" vartype="java.lang.Object" param="unitPriceBeans"/>
              <c:forEach var="unitPriceBean" items="${unitPriceBeans}">
                <dsp:param name="unitPriceBean" value="${unitPriceBean}"/>
             
                <json:object>
                  <json:property name="quantity"><dsp:valueof param="unitPriceBean.quantity"/></json:property>
                  <json:property name="price">
                    <dsp:include page="/global/gadgets/formattedPrice.jsp">
                      <dsp:param name="price" param="unitPriceBean.unitPrice"/>
                    </dsp:include>
                  </json:property>
                </json:object>
                  
              </c:forEach>
            </dsp:oparam>
          </dsp:droplet><%-- End for unit price detail droplet --%>
        </c:otherwise>
      </c:choose>
    </json:array>    
    
    <%---------------------------------------------------------------------------%>
    <%-- Extra item properties 
         These properties will be listed in the rich cart item in the order they are listed here
         Each object should contain name: and value: elements --%>
    <dsp:getvalueof var="skuType" vartype="java.lang.String" param="currentItem.auxiliaryData.catalogRef.type"/>
    <json:array name="properties">
      <c:choose>
        <c:when test="${skuType == 'clothing-sku'}">
          <%-- Size --%>
          <dsp:include page="cartItemProperty.jsp" flush="true">
            <dsp:param name="propertyValue" param="currentItem.auxiliaryData.catalogRef.size"/>
            <dsp:param name="propertyNameKey" value="common.size"/>
          </dsp:include>
          
          <%-- Color  --%>
          <dsp:include page="cartItemProperty.jsp" flush="true">
            <dsp:param name="propertyValue" param="currentItem.auxiliaryData.catalogRef.color"/>
            <dsp:param name="propertyNameKey" value="common.color"/>
          </dsp:include>
        </c:when>
        <c:when test="${skuType == 'furniture-sku'}">
          <dsp:include page="cartItemProperty.jsp" flush="true">
            <dsp:param name="propertyValue" param="currentItem.auxiliaryData.catalogRef.woodFinish"/>
            <dsp:param name="propertyNameKey" value="common.woodFinish"/>
          </dsp:include>
        </c:when>
      </c:choose>
      
      <%-- Description  --%>
      <dsp:include page="cartItemProperty.jsp" flush="true">
        <dsp:param name="propertyValue" param="currentItem.auxiliaryData.catalogRef.description"/>
        <dsp:param name="propertyNameKey" value="common.description"/>
      </dsp:include>
      
    </json:array>
    
    <%---------------------------------------------------------------------------%>
    <%-- Availability Message - if an availability message should be shown in the 
         Rich Cart, then set a JSON 'availability' property. The cart will display 
         this if set.  --%>         
    <dsp:include page="/global/gadgets/skuAvailabilityLookup.jsp" flush="true">
      <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
      <dsp:param name="skuId" param="currentItem.auxiliaryData.catalogRef.repositoryId"/>
    </dsp:include>
    <c:if test="${!empty availabilityMessage}">
      <json:property name="availability" escapeXml="false">
        ${availabilityMessage}
      </json:property>
    </c:if>
      
    <%-- Display site information only for items from sites other than given. --%>
    <dsp:getvalueof var="currentSiteId" bean="Site.id"/>
    <dsp:getvalueof var="itemSiteId" param="currentItem.auxiliaryData.siteId"/>
    
    <c:if test="${currentSiteId != itemSiteId}">
      <json:property name="siteName" escapeXml="false">
        <dsp:include page="/global/gadgets/siteIndicator.jsp">
          <dsp:param name="mode" value="name"/>              
          <dsp:param name="siteId" param="currentItem.auxiliaryData.siteId"/>
          <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
        </dsp:include>
      </json:property>
    </c:if>
  </json:object>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/json/cartItem.jsp#3 $$Change: 635969 $--%>
