<dsp:page>

  <%--
    This page requests the user to enter his/her email address by redirecting to notifyMeRequest page
  --%>

  <crs:popupPageContainer divId="atg_store_notifyMeRequest"
                          titleKey="browse_notifyMeRequestPopup.title"
                          textKey="browse_notifyMeRequestPopup.intro"
                          useCloseImage="false">
    <dsp:include page="/browse/gadgets/notifyMeRequest.jsp"/>
  </crs:popupPageContainer>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/notifyMeRequestPopup.jsp#2 $$Change: 635969 $ --%>
