<dsp:page>

  <%-- This page is the company's "Return Policy" page --%>

  <crs:pageContainer divId="atg_store_company" 
                     bodyClass="atg_store_returns atg_store_leftCol atg_store_company"
                     titleKey="">
    <crs:getMessage var="storeName" key="common.storeName"/>
    <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="company_returnPolicyPopup.title"/>
      </h2>
    </div>
    <div class="atg_store_main">
      <p>
        <crs:outMessage key="company_returnPolicyPopup.text" storeName="${storeName}"/>
      </p>
    </div>

    <div class="atg_store_companyNavigation aside">
      <dsp:include page="/company/gadgets/navigationPanel.jsp"/>
    </div>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/returns.jsp#2 $$Change: 635969 $--%>
