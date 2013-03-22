<%-- This page includes a gadget that will check if the user is already logged in.
     If so, it redirects to the shipping page --%>

<dsp:page>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>

  <dsp:getvalueof var="express" vartype="java.lang.String" param="express"/>

  <dsp:droplet name="Compare">
    <dsp:param bean="Profile.securityStatus" name="obj1"/>
    <dsp:param bean="PropertyManager.securityStatusLogin" name="obj2"/>
    <dsp:oparam name="equal">
      <c:choose>
        <c:when test='${express == "true"}'>
          <dsp:include page="confirm.jsp?expressCheckout=true"/>
        </c:when>
        <c:otherwise>
          <dsp:include page="shipping.jsp"/>
        </c:otherwise>
      </c:choose>
    </dsp:oparam>
    <dsp:oparam name="default">
      <dsp:include page="loginPage.jsp"/>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/login.jsp#2 $$Change: 635969 $--%>
