<dsp:page>

  <%-- Display price bean's discounts --%>
  <dsp:getvalueof var="currentItemOnSale" param="currentItem.priceInfo.onSale"/>
  <dsp:getvalueof var="pricingModels" vartype="java.lang.Object" param="unitPriceBean.pricingModels"/>
  <c:if test="${currentItemOnSale or not empty pricingModels}">
    <p class="note">
      
      <c:if test="${currentItemOnSale}">
        <fmt:message key="cart_detailedItemPrice.salePriceB"/>
        <c:set var="writingStarted" value="${true}"/>
      </c:if>
      
      <c:forEach var="pricingModel" items="${pricingModels}" varStatus="status">
        <dsp:param name="pricingModel" value="${pricingModel}"/>
        <c:if test="${currentItemOnSale or not status.first}">
          <fmt:message key="common.and"/>
        </c:if>
        <dsp:valueof param="pricingModel.displayName" valueishtml="true">
         <fmt:message key="common.promotionDescriptionDefault"/>
        </dsp:valueof>
      </c:forEach><%-- End for each promotion used to create the unit price --%>
    </p>
  </c:if>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/displayItemPricePromotions.jsp#2 $$Change: 635969 $--%>