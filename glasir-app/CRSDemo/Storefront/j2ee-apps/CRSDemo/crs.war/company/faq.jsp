<dsp:page>

  <%-- This page is the companys About Us page --%>

  <crs:pageContainer divId="atg_store_company"
                     bodyClass="atg_store_faq atg_store_leftCol atg_store_company"
                     titleKey="">
    <crs:getMessage var="storeName" key="common.storeName"/>
    <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="company_help.title"/>
      </h2>
    </div>

    <div class="atg_store_main">    
      <h3><fmt:message key="company_help.subTitle"/></h3>
      <h4>
        <crs:outMessage key="company_help.question1" storeName="${storeName}"/>
      </h4>
      <p>
        <crs:outMessage key="company_help.answer1" storeName="${storeName}"/>
      </p>

      <h4>
        <crs:outMessage key="company_help.question2" storeName="${storeName}"/>
      </h4>
      <p>
        <crs:outMessage key="company_help.answer2" storeName="${storeName}"/>
      </p>

      <h4>
        <crs:outMessage key="company_help.question3" storeName="${storeName}"/>
      </h4>
      <p>
        <crs:outMessage key="company_help.answer3" storeName="${storeName}"/>
      </p>

      <h4>
        <crs:outMessage key="company_help.question4" storeName="${storeName}"/>
      </h4>
      <p>
        <crs:outMessage key="company_help.answer4" storeName="${storeName}"/>
      </p>

      <h4>
        <crs:outMessage key="company_help.question5" storeName="${storeName}"/>
      </h4>
      <p>
        <crs:outMessage key="company_help.answer5" storeName="${storeName}"/>
      </p>
    </div>
    
    <div class="atg_store_companyNavigation aside">
      <dsp:include page="/company/gadgets/navigationPanel.jsp"/>
    </div>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/faq.jsp#2 $$Change: 635969 $--%>