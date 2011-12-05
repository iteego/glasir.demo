<dsp:page>

  <%--
    Top-level page for showing user related as well as global promotions available on the Store
  --%>

  <crs:pageContainer divId="atg_store_promotionsIntro" titleKey="" bodyClass="atg_store_promotions">
 <div class="atg_store_nonCatHero"><h2 class="title"><fmt:message key="browse_promotions.title"/></h2></div>
    <dsp:include page="/global/gadgets/promotions.jsp">
      <dsp:param name="divId" value="atg_store_promotions"/>
    </dsp:include>

  </crs:pageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/promo/promotions.jsp#2 $$Change: 635969 $--%>