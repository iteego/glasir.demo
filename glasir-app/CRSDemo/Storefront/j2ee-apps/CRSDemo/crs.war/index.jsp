<%--
  Default welcome page
 --%>
<dsp:page>
  <crs:pageContainer>
    
    <jsp:attribute name="SEOTagRenderer">
      <dsp:include page="/global/gadgets/metaDetails.jsp" flush="true" />
    </jsp:attribute>
    <jsp:attribute name="bodyClass">atg_store_pageHome</jsp:attribute>
    
    <jsp:body>
      <dsp:include page="/navigation/gadgets/homePromotions.jsp" flush="true" />
      <dsp:include page="/promo/gadgets/homeFeaturedProducts.jsp" flush="true" />
    </jsp:body>
    
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/index.jsp#3 $$Change: 635969 $ --%>

