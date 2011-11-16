<dsp:page>

<%-- This page renders each line-item in the shopping cart --%>

  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>  
    
  <dsp:getvalueof id="count" param="count"/>
  <dsp:getvalueof id="size" param="size"/>
  
  <tr class="<crs:listClass count="${count}" size="${size}" selected="false"/>">
    <dsp:include page="/global/gadgets/skuAvailabilityLookup.jsp">
      <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
      <dsp:param name="skuId" param="currentItem.auxiliaryData.catalogRef.repositoryId"/>
      <dsp:param name="showUnavailable" value="true"/>
    </dsp:include>
    
    <%-- Visual indication of site product belongs to --%>
    <dsp:droplet name="/atg/dynamo/droplet/multisite/SharingSitesDroplet">
      <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
      <dsp:param name="excludeInputSite" value="true"/>
      <dsp:oparam name="output">
        <td class="site">
          <dsp:include page="/global/gadgets/siteIndicator.jsp">
            <dsp:param name="mode" value="icon"/>              
            <dsp:param name="siteId" param="currentItem.auxiliaryData.siteId"/>
            <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
          </dsp:include>
        </td>
      </dsp:oparam>
    </dsp:droplet>
	
    <td class="image">
      <dsp:include page="cartItemImg.jsp">
        <dsp:param name="commerceItem" param="currentItem"/>
      </dsp:include>
    </td>
    
    <td class="item">
      <p class="name">
        <%-- Link back to the product detail page --%>
        <dsp:getvalueof var="url" vartype="java.lang.Object" param="currentItem.auxiliaryData.productRef.template.url"/> 
        <c:choose>
          <c:when test="${not empty url}">
            <dsp:include page="/global/gadgets/crossSiteLink.jsp">
              <dsp:param name="item" param="currentItem"/>
            </dsp:include>
          </c:when>
          <c:otherwise>
            <dsp:valueof param="currentItem.auxiliaryData.productRef.displayName">
              <fmt:message key="common.noDisplayName"/>
            </dsp:valueof>
          </c:otherwise>
        </c:choose>

      </p>
      
      <dsp:include page="/global/util/displaySkuProperties.jsp">
        <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
        <dsp:param name="sku" param="currentItem.auxiliaryData.catalogRef"/>
        <dsp:param name="displayAvailabilityMessage" value="true"/>
      </dsp:include>
    </td>
    
    <td class="atg_store_actionItems">
      <dsp:setvalue paramvalue="currentItem.auxiliaryData.productRef.NavigableProducts" param="navigable"/>
       <ul>
         <dsp:include page="itemListingButtons.jsp"/>
       </ul>
    </td>
    
    <td class="price">
      <dsp:include page="detailedItemPrice.jsp"/>
    </td>
    
    <td class="quantity">
      <%-- Don't allow user to modify samples or collateral in cart --%>
      <dsp:getvalueof var="auxiliaryDataType" vartype="java.lang.String" param="currentItem.auxiliaryData.catalogRef.type"/>
      <c:choose>
        <c:when test='${auxiliaryDataType == "sampleSku"}'>
          <input type="hidden" name="<dsp:valueof param='currentItem.id'/>"
                 value="<dsp:valueof param='currentItem.quantity'/>">
          <dsp:valueof param="currentItem.quantity"/>
        </c:when>
        <c:otherwise>
          <fieldset>
            <input class="text qty atg_store_numericInput" type="text" name="<dsp:valueof param='currentItem.id'/>"
                   value="<dsp:valueof param='currentItem.quantity'/>" dojoType="atg.store.widget.enterSubmit" targetButton="atg_store_update">

            <fmt:message var="updateItemText" key="common.button.updateItemText"/>
           
              <dsp:input id="atg_store_update" iclass="atg_store_textButton" type="submit" bean="CartFormHandler.update" value="${updateItemText}"/>
            

          </fieldset>
        </c:otherwise>
      </c:choose>
    </td>
    
    <td class="total">
      <dsp:getvalueof var="amount" vartype="java.lang.Double" param="currentItem.priceInfo.amount"/>
      <dsp:getvalueof var="currencyCode" vartype="java.lang.String" bean="ShoppingCart.current.priceInfo.currencyCode"/>
      <p class="price">
        <dsp:include page="/global/gadgets/formattedPrice.jsp">
          <dsp:param name="price" value="${amount }"/>
        </dsp:include>
      </p>

 
    </td>
  </tr>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/itemListingBody.jsp#2 $$Change: 635969 $--%>
