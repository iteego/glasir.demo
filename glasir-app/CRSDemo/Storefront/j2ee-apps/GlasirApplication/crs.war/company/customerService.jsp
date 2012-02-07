<dsp:page><%-- This page is the company's "customer service" page --%>

  <crs:pageContainer divId="atg_store_company"
                     bodyClass="atg_store_contact atg_store_leftCol atg_store_company"
                     index="false" follow="false">
    <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="company.gadget.customer_service.title"/>
      </h2>
    </div>
    <div class="atg_store_main">
      <h3>
        <fmt:message key="company.gadget.customer_service.byPhoneTitle"/>
      </h3>
      <p>
        <crs:outMessage key="company.gadget.customer_service.byPhone"/>
      </p>
      
      <dsp:include page="/navigation/gadgets/clickToCallLink.jsp">
        <dsp:param name="pageName" value="contactUs"/>
      </dsp:include>

      <h3>
        <fmt:message key="company.gadget.customer_service.byFaxTitle"/>
      </h3>
      <p>
        <crs:outMessage key="company.gadget.customer_service.byFax"/>
      </p>

      <h3>
        <fmt:message key="company.gadget.customer_service.byMailTitle"/>
      </h3>
      <p>
        <crs:outMessage key="company.gadget.customer_service.byMail"/>
      </p>

      <h3>
        <fmt:message key="company.gadget.customer_service.byEmailTitle"/>
      </h3>
      <p>
        <crs:outMessage key="company.gadget.customer_service.byEmail"/>
      </p>
    </div>
        
    <div class="atg_store_companyNavigation aside">
      <dsp:include page="/company/gadgets/navigationPanel.jsp"/>
    </div>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/customerService.jsp#2 $$Change: 635969 $--%>