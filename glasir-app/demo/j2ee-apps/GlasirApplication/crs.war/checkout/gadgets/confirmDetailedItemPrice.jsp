<dsp:page>

  <%-- Display price detail for each item --%>

  <dsp:importbean bean="/atg/commerce/pricing/UnitPriceDetailDroplet"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
    
  <%-- First check to see if the item was discounted --%>
  <dsp:getvalueof var="rawPrice" param="currentItem.priceInfo.rawTotalPrice"/>
  <dsp:getvalueof var="actualPrice" param="currentItem.priceInfo.amount"/>
  <dsp:getvalueof var="listPrice" param="currentItem.priceInfo.listPrice"/>
  <dsp:getvalueof var="priceBeans" vartype="java.util.Collection" param="priceBeans"/>
  
    <c:choose>
      <c:when test="${rawPrice == actualPrice}">
        <%-- They match, no discounts --%>
      
          <c:choose>
            <%-- Price beans already found with StorePriceBeansDroplet, use their quantities --%>
            <c:when test="${not empty priceBeans}">
              <dsp:include page="confirmItemPrice.jsp">
                <dsp:param name="quantity" param="priceBeansQuantity"/>
                <dsp:param name="price" param="currentItem.priceInfo.listPrice"/>
              </dsp:include>
            </c:when>
            <c:otherwise>
              <dsp:include page="confirmItemPrice.jsp">
                <dsp:param name="quantity" param="currentItem.quantity"/>
                <dsp:param name="price" param="currentItem.priceInfo.listPrice"/>
              </dsp:include>
            </c:otherwise>
          </c:choose>
   
      </c:when>
      <c:otherwise>
        <%-- There's some discountin' going on --%>
        <dsp:droplet name="UnitPriceDetailDroplet">
          <dsp:param name="item" param="currentItem"/>
          <dsp:oparam name="output">
            <%-- Always use price beans got from outer droplet, if any; otherwise use price beans generated for commerce item --%>
            <c:set var="unitPriceBeans" value="${priceBeans}"/>
            <c:if test="${empty unitPriceBeans}">
              <dsp:getvalueof var="unitPriceBeans" vartype="java.lang.Object" param="unitPriceBeans"/>
            </c:if>
            <c:set var="priceBeansNumber" value="${fn:length(unitPriceBeans)}"/>
            <c:forEach var="unitPriceBean" items="${unitPriceBeans}">
              <dsp:param name="unitPriceBean" value="${unitPriceBean}"/>
              <dsp:include page="confirmItemPrice.jsp">
                <dsp:param name="currentItem" param="currentItem"/>
                <dsp:param name="unitPriceBean" param="unitPriceBean"/>
                <dsp:param name="quantity" param="unitPriceBean.quantity"/>
                <dsp:param name="price" param="unitPriceBean.unitPrice"/>
                <dsp:param name="oldPrice" value="${unitPrice == listPrice ? '' : listPrice}"/>
              </dsp:include>
            </c:forEach>
          </dsp:oparam>
        </dsp:droplet><%-- End for unit price detail droplet --%>
      </c:otherwise>
    </c:choose>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/confirmDetailedItemPrice.jsp#2 $$Change: 635969 $--%>
