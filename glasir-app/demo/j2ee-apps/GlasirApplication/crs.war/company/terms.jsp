<dsp:page>

  <%-- This page is the company's "Terms & Conditions" page --%>

  <crs:pageContainer divId="atg_store_company"
                     bodyClass="atg_store_terms atg_store_leftCol atg_store_company"
                     index="false"
                     follow="false">
    <crs:getMessage var="storeName" key="common.storeName"/>

    <div class="atg_store_nonCatHero">
        <h2 class="title">
          <fmt:message key="company_terms.title"/>
        </h2>
    </div>

    <div class="atg_store_main">
      <p>
        <crs:outMessage key="company_terms.welcomeNote" storeName="${storeName}"/>
      </p>
  
      <h4>
        <crs:outMessage key="company_terms.siteContents"/>
      </h4>
      <p>
        <crs:outMessage key="company_terms.siteContentsInfo1" storeName="${storeName}"/>
      </p>
      <p>
        <crs:outMessage key="company_terms.siteContentsInfo2"/>
      </p>
  
      <h4>
        <crs:outMessage key="company_terms.userComment"/>
      </h4>
      <p>
        <crs:outMessage key="company_terms.userCommentInfo1" storeName="${storeName}"/>
      </p>
      <p>
        <crs:outMessage key="company_terms.userCommentInfo2"/>
      </p>
  
      <h4>
        <crs:outMessage key="company_terms.revisions"/>
      </h4>
      <p>
        <crs:outMessage key="company_terms.revisionInfo"/>
      </p>
      <p>
        <crs:outMessage key="company_terms.revisionInfo1"/>
      </p>
  
      <h4>
        <fmt:message key="company_terms.inaccuracyDisclaimer"/>
      </h4>
      <p>
        <crs:outMessage key="company_terms.inaccuracyDisclaimerInfo" storeName="${storeName}"/>
      </p>
  
      <h4>
        <fmt:message key="company_terms.linkToOtherWebSites"/>
      </h4>
      <p>
        <crs:outMessage key="company_terms.linkToOtherWebSitesInfo" storeName="${storeName}"/>
      </p>
  
      <h4>
        <fmt:message key="company_terms.disclaimer"/>
      </h4>
      <p>
        <crs:outMessage key="company_terms.disclaimerInfo" storeName="${storeName}"/>
      </p>
  
      <h4>
        <fmt:message key="company_terms.jurisdiction"/>
      </h4>
      <p>
        <crs:outMessage key="company_terms.jurisdictionInfo" storeName="${storeName}"/>
      </p>
  
      <h4>
        <fmt:message key="company_terms.termination"/>
      </h4>
      <p>
        <crs:outMessage key="company_terms.terminationInfo" storeName="${storeName}"/>
      </p>
      
    </div>
    <div class="atg_store_companyNavigation aside">
      <dsp:include page="/company/gadgets/navigationPanel.jsp"/>
    </div>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/terms.jsp#2 $$Change: 635969 $--%>
