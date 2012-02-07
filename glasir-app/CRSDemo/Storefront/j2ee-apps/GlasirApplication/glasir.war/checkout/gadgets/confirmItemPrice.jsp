<dsp:page>
   <%-- Display priceBean details including quantity, discounted price, promotion applied and old price.
        Parameters:
        - currentItem - commerce item to display prices for (used to display promotion message)
        - unitPriceBean - priceBean to display details for (used to display promotion message)
        - quantity - items quantity
        - price - item's price
        - oldPrice - list price for item (before applying discounts)
    --%>
  <dsp:getvalueof var="currentItem" param="currentItem"/>
  <dsp:getvalueof var="unitPriceBean" param="unitPriceBean"/>
  <dsp:getvalueof var="quantity" param="quantity"/>
  <dsp:getvalueof var="price" param="price"/>
  <dsp:getvalueof var="oldPrice" param="oldPrice"/>
  <dsp:getvalueof var="displayPromotion" param="displayPromotion"/>
  
    <div class="atg_store_itemQty">
  <span class="quantity">
    <c:if test="${not empty quantity}">
      <fmt:formatNumber value="${quantity}" type="number"/>
      <fmt:message key="common.atRateOf"/>
    </c:if>
  </span>
  
    <span class="price">
      <c:choose>
        <c:when test="${empty oldPrice}">
          <span>
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${price }"/>
            </dsp:include>
          </span>
          
          <dsp:include page="/cart/gadgets/displayItemPricePromotions.jsp">
            <dsp:param name="currentItem" param="currentItem"/>
            <dsp:param name="unitPriceBean" param="unitPriceBean"/>
          </dsp:include>
          
        </c:when>
        <c:otherwise>
          <c:if test="${not empty price}">
            <span class="atg_store_newPrice">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${price}"/>
              </dsp:include>
            </span>
          </c:if>
          
          <dsp:include page="/cart/gadgets/displayItemPricePromotions.jsp">
            <dsp:param name="currentItem" param="currentItem"/>
            <dsp:param name="unitPriceBean" param="unitPriceBean"/>
          </dsp:include>
                        
          <p class="price">
          <span class="atg_store_oldPrice">
            <fmt:message key="common.price.old"/>
            <del>
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${oldPrice}"/>
              </dsp:include>
            </del>
          </span>
          </p>
        </c:otherwise>
      </c:choose>
    </span>
  </div>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/confirmItemPrice.jsp#3 $$Change: 635969 $--%>