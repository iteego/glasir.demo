<dsp:page>

  <%-- This is the company's "Employment" page that gives information about Employment oppotunities/benefits --%>

  <crs:pageContainer divId="atg_store_company"
                     bodyClass="atg_store_careers atg_store_leftCol atg_store_company"
                     index="false"
                     follow="false">
    <crs:getMessage var="storeName" key="common.storeName"/>
    <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="company_employment.title"/>
      </h2>
    </div>

    <div class="atg_store_main">
      <h3>
        <crs:outMessage key="company_employment.welcome" storeName="${storeName}"/>
      </h3>
      <p>
        <crs:outMessage key="company_employment.purpose" storeName="${storeName}"/>
      </p>
      <p>
        <crs:getMessage key="company_employment.purpose2" storeName="${storeName}" var="purpose2Message"/>
        ${fn:trim(purpose2Message)}<fmt:message key="common.labelSeparator"/>
      </p>

      <ul>
        <li>
          <crs:outMessage key="company_employment.medicalInsurance"/>
        </li>
        <li>
          <crs:outMessage key="company_employment.lifeInsurance"/>
        </li>
        <li>
          <crs:outMessage key="company_employment.termDisability"/>
        </li>
        <li>
          <crs:outMessage key="company_employment.paidTimeOff"/>
        </li>
        <li>
          <crs:outMessage key="company_employment.paidHolidays"/>
        </li>
        <li>
          <crs:outMessage key="company_employment.merchandiseDiscount"/>
        </li>
        <li>
          <crs:outMessage key="company_employment.matching401k"/>
        </li>
        <li>
          <crs:outMessage key="company_employment.profitSharing"/>
        </li>
        <li>
          <crs:outMessage key="company_employment.employeeStockPurchasePlan"/>
        </li>
      </ul>

      <p>
        <crs:outMessage key="company_employment.benefitClosing" storeName="${storeName}"/>
      </p>
      <p>
        <crs:outMessage key="company_employment.EOE"/>
      </p>
    </div>
      
    <div class="atg_store_companyNavigation aside">
      <dsp:include page="/company/gadgets/navigationPanel.jsp"/>
    </div>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/employment.jsp#3 $$Change: 635969 $--%>
