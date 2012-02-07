<dsp:page>

<%--
  This page Return Policy of the Merchant, as a popup 
--%>

  <fmt:message var="pageTitle" key="company_returnPolicyPopup.title"/>
  <crs:popupPageContainer pageTitle="${pageTitle}">
    <jsp:body>
      <dsp:include page="gadgets/returnPolicyPopupIntro.jsp">
        <dsp:param name="useCloseImage" value="false"/>
      </dsp:include>
    </jsp:body>
  </crs:popupPageContainer>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/returnPolicyPopup.jsp#2 $$Change: 635969 $ --%>
