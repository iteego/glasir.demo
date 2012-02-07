<dsp:page>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  
  <%-- Check to see if the user is already logged in --%>
  <dsp:droplet name="Compare">
    <dsp:param name="obj1" bean="Profile.securityStatus"/>
    <dsp:param name="obj2" bean="PropertyManager.securityStatusCookie"/>
  
    <%-- New user or unrecognized member --%>
    <dsp:oparam name="lessthan">
      <dsp:include page="/global/gadgets/pageIntro.jsp" flush="true">
        <dsp:param name="divId" value="atg_store_registerIntro" />
        <dsp:param name="titleKey" value="myaccount_login.title" />
        <dsp:param name="textKey" value="myaccount_login.newUserPromotion" />
      </dsp:include>
    </dsp:oparam>
  
    <%-- User auto-logged in with cookie --%>
    <%-- or --%>
    <%-- User logged in with login/password --%>
    <dsp:oparam name="default">
      <dsp:include page="/global/gadgets/pageIntro.jsp" flush="true">
        <dsp:param name="divId" value="atg_store_registerIntro" />
        <dsp:param name="titleKey" value="myaccount_login.title" />
      </dsp:include>
    </dsp:oparam>
  </dsp:droplet>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/registerIntro.jsp#2 $$Change: 635969 $--%>
