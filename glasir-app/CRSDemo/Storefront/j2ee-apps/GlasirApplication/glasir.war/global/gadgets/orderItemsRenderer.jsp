<dsp:page>

<%--
  Renders commerce item information
 --%>

  <%--Get the currency code --%>
  <dsp:getvalueof var="hideSiteIndicator" param="hideSiteIndicator"/>
  
  <dsp:getvalueof var="missingProductId" vartype="java.lang.String" bean="/atg/commerce/order/processor/SetProductRefs.substituteDeletedProductId"/>
  <dsp:getvalueof var="currentItem" vartype="atg.commerce.order.CommerceItem" param="currentItem"/>
  <dsp:getvalueof param="currentItem.auxiliaryData.productRef.NavigableProducts" var="navigable" vartype="java.lang.Boolean"/>
  <dsp:getvalueof var="dislpayProductAsLink" vartype="java.lang.Boolean" param="dislpayProductAsLink"/>
  <c:if test="${empty dislpayProductAsLink}">
    <c:set var="dislpayProductAsLink" value="${false}"/>
  </c:if>
  <tr>
                
    <%--  Display site indicator --%>
     <c:if test="${empty hideSiteIndicator or (hideSiteIndicator == 'false')}">
      <td class="site">
        <dsp:getvalueof var="displaySiteIcon" vartype="java.lang.Boolean" param="displaySiteIcon"/>
        <c:if test="${displaySiteIcon or empty displaySiteIcon}">
          <dsp:include page="/global/gadgets/siteIndicator.jsp">
            <dsp:param name="mode" value="icon"/>              
            <dsp:param name="siteId" param="currentItem.auxiliaryData.siteId"/>
            <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
          </dsp:include>
        </c:if>
      </td>
    </c:if>
     
    <td class="image">
      <c:choose>
        <c:when test="${missingProductId != currentItem.auxiliaryData.productRef.repositoryId && navigable && dislpayProductAsLink}">
          <dsp:include page="/cart/gadgets/cartItemImg.jsp">
            <dsp:param name="commerceItem" param="currentItem" />
          </dsp:include>  
        </c:when>
        <c:otherwise>
          <dsp:include page="/cart/gadgets/cartItemImg.jsp">
            <dsp:param name="commerceItem" param="currentItem" />
            <dsp:param name="displayAslink" value="false"/>  
          </dsp:include>
        </c:otherwise>
      </c:choose>

    </td>
    
    <td class="item">
      <p class="name"><%-- Link back to the product detail page --%>
        <dsp:getvalueof var="pageurl" idtype="java.lang.String" param="currentItem.auxiliaryData.productRef.template.url"/>
        
        <c:choose>
          <c:when test="${empty pageurl || !navigable}">
            <dsp:valueof param="currentItem.auxiliaryData.productRef.displayName">
              <fmt:message key="common.noDisplayName" />
            </dsp:valueof>
          </c:when>
          <c:otherwise>
            <c:choose>
              <c:when test="${(missingProductId != currentItem.auxiliaryData.productRef.repositoryId or empty missingProductId) 
                  and dislpayProductAsLink}">
                <%-- build site-aware cross link --%>
                <dsp:include page="/global/gadgets/crossSiteLink.jsp">
                  <dsp:param name="item" param="currentItem"/>
                </dsp:include>
              </c:when>
              <c:otherwise>
                <dsp:valueof param="currentItem.auxiliaryData.productRef.displayName">
                  <fmt:message key="common.noDisplayName" />
                </dsp:valueof>
              </c:otherwise>
            </c:choose>

          </c:otherwise>
        </c:choose>
      </p>
      <dsp:include page="/global/util/displaySkuProperties.jsp">
        <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
        <dsp:param name="sku" param="currentItem.auxiliaryData.catalogRef"/>
        <dsp:param name="displayAvailabilityMessage" param="displayAvailabilityMessage"/>
      </dsp:include>
    </td>
    <td  class="atg_store_quantityPrice price" colspan="2">
      <dsp:include page="/checkout/gadgets/confirmDetailedItemPrice.jsp" >
        <dsp:param name="displayQuantity" value="true"/>        
      </dsp:include>
    </td>
    <td class="total">
      <%-- If there are price beans calculated, display their amount, not commerce item's (SG-CI relationship case) --%>
      <dsp:getvalueof var="amount" vartype="java.lang.Double" param="priceBeansAmount"/>
      <c:if test="${empty amount}">
        <dsp:getvalueof var="amount" vartype="java.lang.Double" param="currentItem.priceInfo.amount" />
      </c:if>
      <p class="price">
        <fmt:message key="common.equals"/>
        <dsp:include page="/global/gadgets/formattedPrice.jsp">
          <dsp:param name="price" value="${amount }"/>
        </dsp:include>
      </p>
      <c:if test="${editItems}">
      <ul class="atg_store_actionItems">
        <dsp:include page="../../cart/gadgets/itemListingButtons.jsp">
          <dsp:param name="navigable" value="${navigable}"/>
        </dsp:include>
      </ul>
      </c:if>
    </td>
  </tr>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/orderItemsRenderer.jsp#1 $$Change: 633540 $--%>