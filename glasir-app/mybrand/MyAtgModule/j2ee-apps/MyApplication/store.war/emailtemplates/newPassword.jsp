<dsp:page>

  <dsp:importbean bean="/atg/store/StoreConfiguration"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:getvalueof var="newPasswordFromAddress" bean="Site.newPasswordFromAddress" />

  <crs:emailPageContainer divId="atg_store_resetPasswordIntro" 
        titleKey="emailtemplates_newPassword.title" 
        messageSubjectKey="emailtemplates_newPassword.subject" 
        messageFromAddressString="${newPasswordFromAddress}"
        displayProfileLink="false">

    <dsp:getvalueof var="serverName" vartype="java.lang.String" bean="StoreConfiguration.siteHttpServerName"/>
    <dsp:getvalueof var="serverPort" vartype="java.lang.String" bean="StoreConfiguration.siteHttpServerPort"/>
    <dsp:getvalueof var="httpServer" vartype="java.lang.String" value="http://${serverName}:${serverPort}"/>

<%-- 
----------------------------------------------------------------
Begin Main Content
----------------------------------------------------------------
--%>

  <table border="0" cellpadding="0" cellspacing="0" width="609" style="font-size:14px;margin-top:20px;margin-bottom:30px">
    <tr>
      <td style="color:#666;font-family:Tahoma,Arial,sans-serif;">
        <fmt:message key="emailtemplates_newPassword.greeting">
          <fmt:param>
            <dsp:valueof bean="Profile.firstName"/>
          </fmt:param>
        </fmt:message>
        
        <br /><br />
        <fmt:message key="emailtemplates_newPassword.passwordChanged"/>
        <br /><br />
        <fmt:message key="emailtemplates_newPassword.newPassword"/> <span style="color:#000000"><dsp:valueof param="newpassword"/></span>
        <br /><br />
        <fmt:message key="emailtemplates_newPassword.newPasswordAssigned">
          <fmt:param>
              <fmt:message var="linkText" key="emailtemplates_newPassword.logOn"/>
              <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
                <dsp:param name="path" value="/myaccount/login.jsp"/>
                <dsp:param name="queryParams" value="loginSuccessURL=profile.jsp"/>
                <dsp:param name="httpserver" value="${httpServer}"/>
                <dsp:param name="linkStyle" value="font-size:14px;font-family:Tahoma,Arial,sans-serif;color:#4F7BC4;text-decoration: underline;"/>
                <dsp:param name="linkText" value="${linkText}"/>
              </dsp:include>
            </fmt:param>
        </fmt:message>
      </td>
    </tr>
  </table>

<%-- 
----------------------------------------------------------------
End Main Content
----------------------------------------------------------------
--%>

  </crs:emailPageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/newPassword.jsp#1 $$Change: 633540 $--%>
