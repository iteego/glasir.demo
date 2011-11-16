<dsp:page>

  <%--
    This page renders the gift wrap details as a popup
  --%>

  <%-- Get the supplied gift wrap price --%>
  <dsp:getvalueof var="price" param="giftWrapPrice"/>
  
  <%-- Apply the gift wrap price parameter to the resource string --%>
  <c:set var="giftWrapText">
    <%-- Escape price value to prevent using it in XSS attacks --%>
    <crs:outMessage key="cart_giftWrapPopup.text" price="${fn:escapeXml(price)}"/>
  </c:set>

  <%-- Supply the gift wrap text details to the popup page container --%>
  <crs:popupPageContainer divId="atg_store_giftWrapDetails"
                          titleKey="cart_giftWrapPopup.title"
                          textString="${giftWrapText}"
                          useCloseImage="false">
  </crs:popupPageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/giftWrapDetailsPopup.jsp#2 $$Change: 635969 $ --%>
