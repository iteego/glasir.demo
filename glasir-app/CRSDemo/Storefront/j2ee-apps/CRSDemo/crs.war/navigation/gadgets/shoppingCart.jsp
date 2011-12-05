<dsp:page>
  <fmt:message var="itemLabel" key="navigation_richCart.checkout"/>
  <fmt:message var="itemTitle" key="navigation_personalNavigation.linkTitle">
    <fmt:param value="${itemLabel}"/>
  </fmt:message>

  <dsp:a page="/cart/cart.jsp" title="${itemTitle}"
         iclass="atg_store_navCart">
    <fmt:message key="navigation_richCart.checkout" />
  </dsp:a>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/shoppingCart.jsp#2 $$Change: 635969 $ --%>
