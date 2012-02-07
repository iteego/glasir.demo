<%-- This page includes the gadgets for the shipping page for a single shipping group.
     (That is, all items will be shipped to the same shipping address) --%>

<dsp:page>
  <crs:pageContainer index="false" 
                     follow="false">
    <jsp:attribute name="bodyClass">atg_store_pageLogin atg_store_checkout</jsp:attribute>
    <jsp:body>
        <dsp:include page="checkoutLoginContainer.jsp" flush="true"/>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/loginPage.jsp#2 $$Change: 635969 $--%>
