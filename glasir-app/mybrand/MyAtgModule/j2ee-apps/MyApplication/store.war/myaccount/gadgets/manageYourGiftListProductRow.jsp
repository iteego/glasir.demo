<dsp:page>
  <%--
      Form Condition:
      - This gadget must be contained inside of a form.
        GiftlistFormHandler must be invoked from a submit 
        button in this form for fields in this page to be processed
  --%>
<dsp:importbean bean="/atg/dynamo/droplet/Compare"/>

  <!-- repeat -->
  <dsp:getvalueof var="count" idtype="int" param="count"/>
  <dsp:getvalueof var="size" idtype="int" param="size"/>
  <dsp:getvalueof var="index" idtype="int" param="index"/>
  <dsp:getvalueof var="productId" idtype="java.lang.String" param="productId"/>
  <dsp:getvalueof var="path" idtype="java.lang.String" param="path"/>  
  <dsp:getvalueof var="displaySiteIndicator" param="displaySiteIndicator"/>
    
  <%-- search for SKU and set it as param, search not only current catalog and current site --%>  
  <dsp:droplet name="/atg/commerce/catalog/SKULookup">
    <dsp:param name="id" param="giftlistitem.catalogRefId"/>
    <dsp:oparam name="output">
      <dsp:getvalueof var="sku" param="element"/>
    </dsp:oparam>
    <dsp:oparam name="wrongSite">
      <dsp:getvalueof var="sku" param="element"/>
    </dsp:oparam>
    <dsp:oparam name="wrongCatalog">
      <dsp:getvalueof var="sku" param="element"/>
    </dsp:oparam>
  </dsp:droplet>
  
  <dsp:setvalue param="sku" value="${sku}"/>
 
     <tr class="<crs:listClass count='${count}' size='${size}' selected='${index == currentSelection}'/>">
       <c:if test="${displaySiteIndicator}">
         <td>
           <dsp:include page="/global/gadgets/siteIndicator.jsp">
             <dsp:param name="mode" value="icon"/>              
             <dsp:param name="siteId" param="giftlistitem.siteId"/>
             <dsp:param name="product" param="product"/>
           </dsp:include>
         </td>
       </c:if>
     
       <dsp:getvalueof var="thumbnailImageUrl" param="sku.thumbnailImage.url"/>
       <c:choose>
         <c:when test="${not empty thumbnailImageUrl}">
           <td class="image">
             <%--to display the thumbnailImage of the product related--%>
             <dsp:include page="/browse/gadgets/productThumbImg.jsp">
               <dsp:param name="product" param="product"/>
               <dsp:param name="alternateImage" param="sku.thumbnailImage"/>
               <dsp:param name="siteId" param="giftlistitem.siteId"/>
             </dsp:include>
           </td>
         </c:when>
         <c:otherwise>
           <td class="image">
             <%--to display the thumbnailImage of the product related--%>
             <dsp:include page="/browse/gadgets/productThumbImg.jsp">
               <dsp:param name="product" param="product"/>
               <dsp:param name="siteId" param="giftlistitem.siteId"/>
             </dsp:include>
           </td>
         </c:otherwise>
       </c:choose>

        <td class="item">
          <%-- Get this products template --%>
          <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="product.template.url"/>
            <c:choose>
              <%-- If the product has a template generate a link --%>
              <c:when test="${not empty pageurl}">
                <p class="name">
                  <dsp:include page="/global/gadgets/crossSiteLink.jsp">
                    <dsp:param name="siteId" param="giftlistitem.siteId"/>
                    <dsp:param name="product" param="product"/>
                  </dsp:include>
                </p>
              </c:when>
              <%-- Otherwise just display the displayname --%>
              <c:otherwise>
                <dsp:valueof param="product.displayName">
                  <fmt:message key="common.noDisplayName"/>
                </dsp:valueof>
              </c:otherwise>
            </c:choose>

            <dsp:include page="/global/util/displaySkuProperties.jsp">
              <dsp:param name="product" param="product"/>
              <dsp:param name="sku" param="sku"/>
              <dsp:param name="displayAvailabilityMessage" value="true"/>
            </dsp:include>
        </td>
        <td class="numerical price atg_store_productPrice">
          <%--to display the price of the product related--%>
          <dsp:include page="/global/gadgets/priceLookup.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="sku" param="sku"/>
          </dsp:include>
        </td>
        <td class="requstd quantity">
          <label for="atg_store_giftQuantityField">
            <dsp:getvalueof var="quantityDesired" vartype="java.lang.String" param="giftlistitem.quantityDesired"/>
          </label>
         <input name="<dsp:valueof param="giftlistitem.id"/>" size="2" type="text" value="<fmt:formatNumber value="${quantityDesired}" type="number"/>" class="text qty atg_store_numericInput"/>
        </td>
        <td class="remain">
          <dsp:getvalueof var="quantityRemaining" vartype="java.lang.String" param="giftlistitem.quantityRemaining"/>
          <fmt:formatNumber value="${quantityRemaining}" type="number"/>
        </td>
        <td class="atg_store_actionItems">
           <div class="atg_store_giftListActions">
            <%-- Add to cart action --%>
            <dsp:getvalueof var="quantityRemaining" param="giftlistitem.quantityRemaining"/>
            <c:choose>
              <c:when test="${quantityRemaining != '0'}">
                <%--to display the addToCart information of the product related--%>
                <dsp:include page="giftListAddToCart.jsp">
                  <dsp:param name="product" param="product"/>
                  <dsp:param name="skuId" param="sku.repositoryId"/>
                </dsp:include>
              </c:when>
            </c:choose>
            
            <%-- Delete action --%>
            <div class="atg_store_GiftListItemDelete">
            <fmt:message var="deleteTitle" key="myaccount_manageYourGiftlistProductRow.deleteItem"/>
            <dsp:getvalueof var="viewAll" param="viewAll"/>
            <c:choose>
              <c:when test="${viewAll == true}">
            
                <dsp:droplet name="Compare">
                  <dsp:param name="obj1" param="start" converter="number"/>
                  <dsp:param name="obj2" param="size" />
                  
                   <dsp:oparam name="default">
           
                        <dsp:a title="${deleteTitle}" href="${path}"
                               iclass="atg_store_giftListRemove">
                          <span><fmt:message key="common.button.removeText"/></span>
                          <dsp:param name="giftId" param="giftlistitem.id"/>
                          <dsp:param name="giftlistId" param="giftlistId"/>
                          <dsp:param name="start" param="start"/>
                        </dsp:a>
                
                    </dsp:oparam>
                  <dsp:oparam name="equal">
           
                      <dsp:a title="${deleteTitle}" href="${path}" 
                             iclass="atg_store_giftListRemove">
                        <span><fmt:message key="common.button.removeText"/></span>
                        <dsp:param name="giftId" param="giftlistitem.id"/>
                        <dsp:param name="giftlistId" param="giftlistId"/>
                        <dsp:param name="start" value="1"/>
                      </dsp:a>
              
                  </dsp:oparam>
                </dsp:droplet>
              </c:when>
              <c:otherwise>
           
                  <dsp:a title="${deleteTitle}" href="${path}"
                         iclass="atg_store_giftListRemove">
                    <span><fmt:message key="common.button.removeText"/></span>
                    <dsp:param name="giftId" param="giftlistitem.id"/>
                    <dsp:param name="giftlistId" param="giftlistId"/>
                    <dsp:param name="howMany" param="howMany"/>
                    <dsp:param name="viewAll" value="true"/>
                  </dsp:a>
        
            </c:otherwise>
            </c:choose>
          </div>
          </div>
        </td>
       </tr>
  
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/manageYourGiftListProductRow.jsp#3 $$Change: 635969 $--%>
