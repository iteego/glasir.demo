<dsp:page>

  <%--
    This page shows popup with instructions what should be entered in credit card's security code field.
  --%>

  <crs:popupPageContainer divId="atg_store_whatsThisPopup"
                          titleKey="checkout_whatsThisPopup.title"
                          useCloseImage="false">
    <jsp:body>
      <div id="atg_store_whatsThisPopupContent">
        
        <p><fmt:message key="checkout_whatsThisPopup.intro"/></p>
        <p><fmt:message key="checkout_whatsThisPopup.instructions"/></p>
        <div class="atg_Store_visa">
          <strong><fmt:message key="common.visa"/>, <fmt:message key="common.masterCard"/>, <fmt:message key="common.discover"/></strong>
          <p><fmt:message key="checkout_whatsThisPopup.instructions.visa"/></p>
         <img src="/crsdocroot/images/storefront/cc_visamcdisc.png" />
        </div>
        <div class="atg_store_amex">
          <strong><fmt:message key="common.americanExpress"/></strong>
          <p><fmt:message key="checkout_whatsThisPopup.instructions.americanExpress"/></p>
          <img src="/crsdocroot/images/storefront/cc_amex.png" />
      </div>
    </jsp:body>    
  </crs:popupPageContainer>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/whatsThisPopup.jsp#2 $$Change: 635969 $ --%>
