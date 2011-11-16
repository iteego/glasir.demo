<dsp:page>
  <dsp:importbean bean="/atg/store/profile/RegistrationFormHandler"/>
  <dsp:importbean bean="/atg/store/droplet/AddItemsToOrder"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  
  <dsp:droplet name="AddItemsToOrder">
    <dsp:param name="order" bean="ShoppingCart.current"/>
    <dsp:param name="profile" bean="Profile"/>
  </dsp:droplet>

  <crs:pageContainer index="false" follow="false" bodyClass="atg_store_pageRegistration atg_store_checkout atg_store_rightCol">
    <jsp:body>
      <fmt:message key="checkout_title.checkout" var="title"/>
      <crs:checkoutContainer currentStage="register" showOrderSummary="false" skipSecurityCheck="true" title="${title}">
        <dsp:include page="./gadgets/checkoutErrorMessages.jsp">
          <dsp:param name="formhandler" bean="RegistrationFormHandler"/>
        </dsp:include>
        
        <dsp:include page="../myaccount/gadgets/register.jsp" flush="true" >
          <dsp:param name="restrictionDroplet" value="/atg/store/droplet/CountryListDroplet"/>
          <dsp:param name="checkout" value="true"/>
        </dsp:include>
        
        <dsp:include page="../myaccount/gadgets/benefits.jsp"/>
      </crs:checkoutContainer>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/registration.jsp#2 $$Change: 635969 $--%>
