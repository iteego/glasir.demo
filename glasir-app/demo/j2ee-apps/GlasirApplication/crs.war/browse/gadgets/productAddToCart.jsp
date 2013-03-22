<%-- 
  This page renders an 'Add to Cart' button or 'Email Me' link, in accordance to the current Inventory state.
  This page expects the following parameters:
    - product - the product repository item to display
    - categoryId - the repository ID of the product's category
    - displayAvailability (optional) - boolean flag, whether availability message should be displayed or not; default is true 
    - siteId (optional) - The site the product belongs to
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>  

  <%-- Look for Product/SKU availability message and button labels --%>
  <dsp:include page="/global/gadgets/skuAvailabilityLookup.jsp">
    <dsp:param name="product" param="product"/>
    <dsp:param name="skuId" param="sku.repositoryId"/>
    <dsp:param name="showUnavailable" value="true"/>
  </dsp:include>
  
  <span>
    <dsp:getvalueof var="formId" vartype="java.lang.String" param="sku.repositoryId"/>
    <dsp:form id="${formId}" action="${pageContext.request.requestURI}" method="post">
      <%-- Set of redirect URLs to be used --%>
      <c:url var="errorUrl" value="${pageContext.request.requestURI}">
        <c:param name="productId"><dsp:valueof param="product.repositoryId"/></c:param>
        <c:param name="categoryId"><dsp:valueof param="categoryId"/></c:param>
      </c:url>
      <c:url var="successUrl" value="/cart/cart.jsp"/>
      <c:url var="sessionExpiredUrl" value="/global/sessionExpired.jsp"/>
      <c:url var="jsonSuccessUrl" value="/cart/json/cartContents.jsp"/>
      <c:url var="jsonErrorUrl" value="/cart/json/errors.jsp"/>
      <dsp:input bean="CartFormHandler.addItemToOrderErrorURL" type="hidden" value="${errorUrl}"/>        
      <dsp:input bean="CartFormHandler.addItemToOrderSuccessURL" type="hidden" value="${successUrl}"/>
      <dsp:input bean="CartFormHandler.sessionExpirationURL" type="hidden" value="${sessionExpiredUrl}"/>
      <dsp:input bean="CartFormHandler.ajaxAddItemToOrderSuccessUrl" type="hidden" value="${jsonSuccessUrl}"/>
      <dsp:input bean="CartFormHandler.ajaxAddItemToOrderErrorUrl" type="hidden" value="${jsonErrorUrl}"/>
      <%-- Actual FormHandler's input data --%>
      <dsp:input bean="CartFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
      <dsp:input bean="CartFormHandler.siteId" paramvalue="siteId" type="hidden"/>
      <dsp:input bean="CartFormHandler.quantity" type="hidden" value="1"/>
      <dsp:input bean="CartFormHandler.catalogRefIds" paramvalue="sku.repositoryId" type="hidden"/>
      
      <%-- Display availability message, if needed --%>
      <c:if test="${(displayAvailability or empty displayAvailability) and !empty availabilityMessage}">
        <div class="atg_store_availability">
          <span>${availabilityMessage}</span>
        </div>
      </c:if>
    
      <c:choose>
        <%-- Unavailable? Then display an 'Email Me' link --%>
        <c:when test="${availabilityType == 'unavailable'}">
          <c:url var="notifyMeUrl" value="/browse/notifyMeRequestPopup.jsp">
            <c:param name="skuId"><dsp:valueof param="sku.repositoryId"/></c:param>
            <c:param name="productId"><dsp:valueof param="product.repositoryId"/></c:param>
          </c:url>
          <a href="${notifyMeUrl}" class="atg_store_basicButton atg_store_emailMe" target="popup" title="${addButtonTitle}">
            <span><c:out value="${addButtonText}"/></span>
          </a>
          <div class="atg_store_emailMeMessage">
            <fmt:message key="common.whenAvailable"/>
          </div>
        </c:when>
        <%-- Otherwise display an 'Add to Cart' button --%>
        <c:otherwise>
          <c:choose>
            <c:when test="${availabilityType == 'preorderable'}">
              <c:set var="buttonStyle" value="add_to_cart_link_preorder"/>
            </c:when>
            <c:when test="${availabilityType == 'backorderable'}">
              <c:set var="buttonStyle" value="add_to_cart_link_backorder"/>
            </c:when>
            <c:otherwise>
              <c:set var="buttonStyle" value="add_to_cart_link"/>
            </c:otherwise>
          </c:choose>
          <span class="atg_store_basicButton ${buttonStyle}">
            <dsp:input bean="CartFormHandler.addItemToOrder" type="submit" value="${addButtonText}" title="${addButtonTitle}"
                iclass="atg_behavior_addItemToCart"/>
          </span>
        </c:otherwise>
      </c:choose>
    </dsp:form>
  </span>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productAddToCart.jsp#2 $$Change: 635969 $--%>
