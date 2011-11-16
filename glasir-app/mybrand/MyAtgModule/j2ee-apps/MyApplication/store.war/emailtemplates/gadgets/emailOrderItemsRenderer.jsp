<dsp:page>

<%-- Note: This page recieves following parameters
  -  order- To get the currencyCode 
  -  commerceItem - To use for display of commerce item description, qty, unit price, and total price.
  -  priceListLocale - the locale to use for price formatting
--%>
  
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/commerce/pricing/UnitPriceDetailDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>     
  
  <dsp:getvalueof var="currencyCode" vartype="java.lang.String" param="order.priceInfo.currencyCode"/>
  <dsp:getvalueof id="count" param="count"/>
  <dsp:getvalueof id="size" param="size"/> 
  <dsp:getvalueof id="httpserver" param="httpserver"/>
  
  <tr>
    <td style="font-family:Tahoma,Arial,sans-serif;font-size:12px;width:60px;height:60px;">
      
      <dsp:include page="/global/gadgets/siteIndicator.jsp">
        <dsp:param name="mode" value="icon"/>              
        <dsp:param name="siteId" param="commerceItem.auxiliaryData.siteId"/>
        <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
        <dsp:param name="absoluteResourcePath" value="true"/>
      </dsp:include>
     
      <%-- The code below is used to display a thumbmail of the product --%>
      <%-- 
      <dsp:include page="../../cart/gadgets/cartItemImg.jsp">
        <dsp:param name="commerceItem" param="commerceItem"/>        
      </dsp:include> 
      --%>
    </td>

    <td style="font-family:Tahoma,Arial,sans-serif;font-size:12px;width:170px;">
      <%-- Display name --%>
      <span style="font-size:14px;color:#333;">
        <dsp:include page="/global/gadgets/productLinkGenerator.jsp">
          <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
        </dsp:include>

        <dsp:getvalueof var="navigable" vartype="java.lang.Boolean" param="commerceItem.auxiliaryData.productRef.NavigableProducts"/>
        <c:choose>
          <c:when test="${!navigable}">
            <dsp:valueof param="commerceItem.auxiliaryData.productRef.displayName">
              <fmt:message key="common.noDisplayName"/>
            </dsp:valueof>
          </c:when>
          <c:otherwise>
            <dsp:a href="${httpserver}${productUrl}">
              <dsp:param name="productId" param="commerceItem.auxiliaryData.productRef.repositoryId"/>
              <dsp:valueof param="commerceItem.auxiliaryData.productRef.displayName">
                <fmt:message key="common.noDisplayName"/>
              </dsp:valueof>
            </dsp:a>
          </c:otherwise>
        </c:choose>
      </span>
      
      <%-- Check the SKU type to display type-specific properties --%>
      <dsp:getvalueof var="skuType" vartype="java.lang.String" param="commerceItem.auxiliaryData.catalogRef.type"/>
      <c:choose>
        <%-- 
          for 'clothing-sku' SKU type display the following properties:
            1. size
            2. color
        --%>
        <c:when test="${skuType == 'clothing-sku'}">
          <dsp:getvalueof var="catalogRefSize" param="commerceItem.auxiliaryData.catalogRef.size"/>
          <c:if test="${not empty catalogRefSize}">
            <p><span style="font-size:12px;color:#666666;"><fmt:message key="common.size"/><fmt:message key="common.labelSeparator"/></span>
            <span style="font-size:12px;color:#000000;">${catalogRefSize}</span></p>
          </c:if>
        
          <dsp:getvalueof var="catalogRefColor"    param="commerceItem.auxiliaryData.catalogRef.color"/>
          <c:if test="${not empty catalogRefColor}">
            <p><span style="font-size:12px;color:#666666;"><fmt:message key="common.color"/><fmt:message key="common.labelSeparator"/></span>
            <span style="font-size:12px;color:#000000;">${catalogRefColor}</span></p>
          </c:if>
        </c:when>
        <%-- 
          for 'furniture-sku' SKU type display the following properties:
            1. woodFinish
        --%>
        <c:when test="${skuType == 'furniture-sku'}">
          <dsp:getvalueof var="catalogRefWoodFinish" param="commerceItem.auxiliaryData.catalogRef.woodFinish"/>
          <c:if test="${not empty catalogRefWoodFinish}">
            <p><span style="font-size:12px;color:#666666;"><fmt:message key="common.woodFinish"/><fmt:message key="common.labelSeparator"/></span>
            <span style="font-size:12px;color:#000000;">${catalogRefWoodFinish}</span></p>
          </c:if>
        </c:when>
      </c:choose>
      
      <%-- SKU description --%>
      <dsp:getvalueof var="catalogRefDescription"    param="commerceItem.auxiliaryData.catalogRef.description"/>
      <c:if test="${not empty catalogRefDescription}">
        <p>${catalogRefDescription}</p>
      </c:if>    
      
      <c:if test="${not empty availabilityMessage}">
         <p>${availabilityMessage}</p>
       </c:if>    
    </td>

    <td colspan="2" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;color#666666;width:205px;">
        <%-- To get the request scope expression variable availabilyMessage for the status of sku --%> 
        <dsp:getvalueof var="stateAsString" param="order.stateAsString"/>
        <c:choose>
          <c:when test="${stateAsString == 'INCOMPLETE'}">
            <dsp:include page="/global/gadgets/skuAvailabilityLookup.jsp">
              <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
              <dsp:param name="skuId"
                         param="commerceItem.auxiliaryData.catalogRef.repositoryId"/>
            </dsp:include>
            <%-- End of include --%>
          </c:when>
          <c:otherwise>
            <dsp:include page="/global/gadgets/itemAvailabilityLookup.jsp">
              <dsp:param name="commerceItem" param="commerceItem"/>
            </dsp:include>
          </c:otherwise>
        </c:choose>

 
        
        <%-- First check to see if the item was discounted --%>
        <dsp:droplet name="Compare">
          <dsp:param name="obj1" param="commerceItem.priceInfo.rawTotalPrice" converter="number"/>
          <dsp:param name="obj2" param="commerceItem.priceInfo.amount" converter="number"/>
          <dsp:oparam name="equal">
      
            <%-- They match, no discounts --%>
            <dsp:getvalueof var="listPrice" vartype="java.lang.Double" param="commerceItem.priceInfo.listPrice"/>
            <dsp:getvalueof var="quantity" vartype="java.lang.Double" param="commerceItem.Quantity"/>
            <table style="border-collapse: collapse; width: 215px;">
              <tr>
            <%-- Quantity --%>
            <td style="width:65px;color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif; ">
            <fmt:formatNumber value="${quantity}" type="number"/>
            <fmt:message key="common.atRateOf"/>
            </td>
            <%-- Price --%>
            <td style="color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif;width:150px; ">
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${listPrice }"/>
              <dsp:param name="priceListLocale" param="priceListLocale"/>
            </dsp:include>
            </td>
          </tr>
          </table>

            </dsp:oparam>
            <dsp:oparam name="default">

              <dsp:droplet name="UnitPriceDetailDroplet">
                <dsp:param name="item" param="commerceItem"/>
                <dsp:oparam name="output">
                  <%-- Always use price beans got from outer droplet, if any; otherwise use price beans generated for commerce item --%>
                  <dsp:getvalueof var="unitPriceBeans" vartype="java.util.Collection" param="priceBeans"/>
                  <c:if test="${empty unitPriceBeans}">
                    <dsp:getvalueof var="unitPriceBeans" vartype="java.lang.Object" param="unitPriceBeans"/>
                  </c:if>
            
                <%-- The commerce item was discounted, loop through all price details and
                     display each as separate line --%>
                <table style="border-collapse: collapse; width: 215px;">
                <c:forEach var="unitPriceBean" items="${unitPriceBeans}">        
                  <dsp:param name="unitPriceBean" value="${unitPriceBean}"/>
                  <tr>
                    
                  <%-- Quantity --%>
                  <td style="width:65px;color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif;">
                  <dsp:getvalueof var="quantity" vartype="java.lang.Double" param="unitPriceBean.quantity"/>
                  <fmt:formatNumber value="${quantity}" type="number"/>
                  <fmt:message key="common.atRateOf"/>
                  </td>
                  <%-- Price --%>
                  <td style="color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif; width: 150px; ">
                  <dsp:getvalueof var="unitPrice" vartype="java.lang.Double" param="unitPriceBean.unitPrice"/>
                  <dsp:include page="/global/gadgets/formattedPrice.jsp">
                    <dsp:param name="price" value="${unitPrice }"/>
                    <dsp:param name="priceListLocale" param="priceListLocale"/>
                  </dsp:include>
          
                  <%-- Discount message --%>
                  <span style="display:block;font-size:12px;font-family:Tahoma,Arial,sans-serif;">
                  <dsp:getvalueof var="pricingModels" vartype="java.lang.Object" param="unitPriceBean.pricingModels"/> 
                  <c:choose>
                    <c:when test="${not empty pricingModels}">
                      <c:forEach var="pricingModel" items="${pricingModels}">
                        <dsp:param name="pricingModel" value="${pricingModel}"/>
                        <dsp:valueof param="pricingModel.displayName" valueishtml="true">
                         <fmt:message key="common.promotionDescriptionDefault"/>
                        </dsp:valueof>
                      </c:forEach>
                      <%-- End for each promotion used to create the unit price --%>
                    </c:when>
                    
                    <c:otherwise>
                      <dsp:getvalueof var="commerceItemOnSale" param="commerceItem.priceInfo.onSale"/> 
                      <c:if test='${commerceItemOnSale == "true"}'>
                       <fmt:message key="cart_detailedItemPrice.salePriceB"/>
                      </c:if>
                    </c:otherwise>
                  </c:choose>
            </span>
            </td>
            </tr>
                </c:forEach>
              </dsp:oparam>
            </dsp:droplet>
            <%-- End for unit price detail droplet --%>
          </table>
          </dsp:oparam>
        </dsp:droplet>
        <%-- End Compare check to see if item was discounted --%>
    </td>
  
    <%-- Total commerce item's amount --%>
    <td align="right" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;color:#000000; white-space:nowrap;">
      =
      <span style="color:#000000">
        <%-- If there are price beans calculated, display their amount, not commerce item's (SG-CI relationship case) --%>
        <dsp:getvalueof var="amount" vartype="java.lang.Double" param="priceBeansAmount"/>
        <c:if test="${empty amount}">
          <dsp:getvalueof var="amount" vartype="java.lang.Double" param="commerceItem.priceInfo.amount" />
        </c:if>
        <dsp:include page="/global/gadgets/formattedPrice.jsp">
          <dsp:param name="price" value="${amount}"/>
          <dsp:param name="priceListLocale" param="priceListLocale"/>
        </dsp:include>     
      </span>             
    </td>
  </tr>
  <tr><td colspan="5"><hr size="1"></td></tr>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailOrderItemsRenderer.jsp#2 $$Change: 633752 $--%>
