<dsp:page>

  <dsp:importbean bean="/atg/targeting/TargetingRandom"/>

  <dsp:droplet name="TargetingRandom">
    <dsp:param name="howMany" value="4"/>
    <dsp:param name="targeter" bean="/atg/registry/Slots/RelatedItemsOfCart"/>
    <dsp:param name="fireViewItemEvent" value="false"/>
    <dsp:oparam name="outputStart">
      <div id="atg_store_recommendedProductsDetail">
        <h3><fmt:message  key="common.cart.youMayLike"/></h3>
        <div id="atg_store_recommendAddToCart" class="atg_store_product_recommendations">
          <ul class="atg_store_product">
    </dsp:oparam>
    <dsp:oparam name="output">
      <dsp:getvalueof id="count" param="count"/>
      <c:if test="${count == 1}">
        <li class="odd first">
      </c:if>
      <c:if test="${count == 2}">
        <li class="even">
      </c:if>
      <c:if test="${count == 3}">
        <li class="odd">
      </c:if>
      <c:if test="${count == 4}">
        <li class="odd last">
      </c:if>
        <dsp:include page="/promo/gadgets/promotionalItemRenderer.jsp" flush="true">
          <dsp:param name="product" param="element"/>
        </dsp:include>
      </li>
    </dsp:oparam>
    <dsp:oparam name="outputEnd">
          </ul>
        </div>
      </div>
    </dsp:oparam>
  </dsp:droplet>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/orderRelatedProducts.jsp#2 $$Change: 635969 $--%>
