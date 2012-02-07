<dsp:page>

  <%-- This page expects the following input parameters
       useCloseImage - passed on to the popupPageIntro.jsp gadget
    --%>
  <dsp:getvalueof id="useCloseImage" param="useCloseImage"/>

  <crs:outMessage var="introText" key="company_returnPolicyPopup.text"/>

  <dsp:include page="/global/gadgets/popupPageIntro.jsp" flush="true">
    <dsp:param name="divId" value="atg_store_returnPolicy"/>
    <dsp:param name="titleKey" value="company_returnPolicyPopup.title"/>
    <dsp:param name="textString" value="${introText}"/>
    <dsp:param name="useCloseImage" value="${useCloseImage}"/>
  </dsp:include>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/gadgets/returnPolicyPopupIntro.jsp#1 $$Change: 633540 $--%>
