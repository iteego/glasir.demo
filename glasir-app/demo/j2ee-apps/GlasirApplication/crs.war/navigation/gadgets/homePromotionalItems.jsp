<dsp:page>
  <dsp:importbean bean="/atg/targeting/TargetingRandom"/>
  
  <c:set var="displayHomePromotionalItems" value="false"/>
  
  <%-- Check if slots contain any items --%>
  <dsp:droplet name="TargetingRandom">
    <dsp:param name="targeter" bean="/atg/registry/Slots/HomePromotionalItem1"/>
      <dsp:oparam name="output">
        <c:set var="displayHomePromotionalItems" value="true"/>
      </dsp:oparam>
  </dsp:droplet>
  <c:if test="${!displayHomePromotionalItems}">
    <dsp:droplet name="TargetingRandom">
    <dsp:param name="targeter" bean="/atg/registry/Slots/HomePromotionalItem2"/>
      <dsp:oparam name="output">
        <c:set var="displayHomePromotionalItems" value="true"/>
      </dsp:oparam>
    </dsp:droplet>
  </c:if>
  <c:if test="${!displayHomePromotionalItems}">
    <dsp:droplet name="TargetingRandom">
    <dsp:param name="targeter" bean="/atg/registry/Slots/HomePromotionalItem3"/>
      <dsp:oparam name="output">
        <c:set var="displayHomePromotionalItems" value="true"/>
      </dsp:oparam>
    </dsp:droplet>
  </c:if>
  <c:if test="${displayHomePromotionalItems}">
    <div id="atg_store_homePromotionalItems">
  
      <ul class="atg_store_product">
        <%-- The first promotional product --%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp" flush="true">
          <dsp:param name="targeter" bean="/atg/registry/Slots/HomePromotionalItem1"/>
          <dsp:param name="renderer" value="/promo/gadgets/homePromotionalItemRenderer.jsp"/>
          <dsp:param name="elementName" value="product"/>
          <dsp:param name="showAddToCart" value="false"/>
        </dsp:include>
    
        <%-- The second promotional product --%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp" flush="true">
          <dsp:param name="targeter" bean="/atg/registry/Slots/HomePromotionalItem2"/>
          <dsp:param name="renderer" value="/promo/gadgets/homePromotionalItemRenderer.jsp"/>
          <dsp:param name="elementName" value="product"/>
          <dsp:param name="showAddToCart" value="false"/>
        </dsp:include>
    
        <%-- The third promotional product --%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp" flush="true">
          <dsp:param name="targeter" bean="/atg/registry/Slots/HomePromotionalItem3"/>
          <dsp:param name="renderer" value="/promo/gadgets/homePromotionalItemRenderer.jsp"/>
          <dsp:param name="elementName" value="product"/>
          <dsp:param name="showAddToCart" value="false"/>
        </dsp:include>
      
      </ul>
    </div>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/homePromotionalItems.jsp#2 $$Change: 635969 $--%>