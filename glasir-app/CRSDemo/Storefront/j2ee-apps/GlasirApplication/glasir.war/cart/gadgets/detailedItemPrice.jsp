<dsp:page>

  <%-- Display price detail for each item --%>

  <dsp:importbean bean="/atg/commerce/pricing/UnitPriceDetailDroplet"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  
  <dsp:getvalueof var="displayDiscountFirst" param="displayDiscountFirst"/>
  <dsp:getvalueof var="displayQuantity" param="displayQuantity"/>

  <dsp:getvalueof var="listPrice" param="currentItem.priceInfo.listPrice"/>

  <dsp:droplet name="UnitPriceDetailDroplet">
    <dsp:param name="item" param="currentItem"/>
    <dsp:oparam name="output">

      <dsp:getvalueof var="unitPriceBeans" vartype="java.lang.Object" param="unitPriceBeans"/>
      <c:set var="priceBeansNumber" value="${fn:length(unitPriceBeans)}"/>
      
      <c:forEach var="unitPriceBean" items="${unitPriceBeans}" varStatus="unitPriceBeanStatus">
        <c:if test="${displayDiscountFirst}">
          <%-- promotions info --%>
          <dsp:include page="displayItemPricePromotions.jsp">
            <dsp:param name="currentItem" param="currentItem"/>
            <dsp:param name="unitPriceBean" value="${unitPriceBean}"/>
          </dsp:include>
        </c:if>
            
        <dsp:include page="displayItemPrice.jsp">
          <dsp:param name="quantity" value="${unitPriceBean.quantity}"/>
          <dsp:param name="displayQuantity" value="${priceBeansNumber > 1}"/>
          <dsp:param name="price" value="${unitPriceBean.unitPrice}"/>
          <dsp:param name="oldPrice" value=""/>
        </dsp:include>
          
        <c:if test="${not displayDiscountFirst}">
          <dsp:include page="displayItemPricePromotions.jsp">
            <dsp:param name="currentItem" param="currentItem"/>
            <dsp:param name="unitPriceBean" value="${unitPriceBean}"/>
          </dsp:include>
        </c:if>

        <%--
          Note that we never displayed old price for a price bean before. This is done to dislpay prices in the following format:
            Current price
            All applied promotions
            Old price 
         --%>
        <c:if test="${listPrice != unitPriceBean.unitPrice}">
          <dsp:include page="displayItemPrice.jsp">
            <dsp:param name="displayQuantity" value="false"/>
            <dsp:param name="oldPrice" value="${listPrice}"/>
          </dsp:include>
        </c:if>
      </c:forEach>
    </dsp:oparam>
  </dsp:droplet><%-- End for unit price detail droplet --%>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/detailedItemPrice.jsp#2 $$Change: 635969 $--%>