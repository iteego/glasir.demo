<dsp:page>
  <%-- This page expects the following parameters 
     1. httpserver - the server name and port so we can construct image src tags
  --%>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:getvalueof var="httpserverVar" param="httpserver"/>
  <dsp:getvalueof var="serverURL" vartype="java.lang.String" value="${httpserverVar}/crsdocroot/"/>  
  
  <html>
    <head>
      <title>
        <fmt:message key="common.storeTitle">
          <fmt:param>
            <dsp:valueof bean="Site.name"/>
          </fmt:param>
        </fmt:message>
      </title>
    </head> 

<%-- 
----------------------------------------------------------------
Begin Header Content
----------------------------------------------------------------
--%>
    <body style="background-color:#CAD2D4;margin:0px;padding:0px;font-family:Tahoma,Arial,sans-serif;font-size:12px;">
      <div align="center" style="padding:0px;margin:0px">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding:0px;margin:0px">
        <tr>
          <td align="center" style="padding-left:0px;padding-right:0px;padding-top:8px;background-color:#CAD2D4">
            <table width="682px" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="text-align:left;width:650px;background-color:#FFFFFF;padding-top:16px;padding-left:16px;padding-right:16px;vertical-align:bottom;" valign="top">
                <%-- Begin Store Logo and My Account Link --%>
               
               <table style="width:100%;">
               <tr>
                 <td>
                      <dsp:getvalueof var="siteIconUrl" bean="Site.largeSiteIcon"/>
                        
                      <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
                        <dsp:param name="path" value="/index.jsp"/>
                        <dsp:param name="httpserver" value="${httpserverVar}"/>
                        <dsp:param name="imageUrl" value="${httpserverVar}${siteIconUrl}"/>
                      </dsp:include>
                   
                  </td>
                  <td style="vertical-align:bottom;text-align:right">
                  
                  <%-- Display link to account only for registered users --%>

              <dsp:getvalueof var="isTransient" bean="Profile.transient"/>
              <c:if test="${!isTransient}">
                  <dsp:getvalueof var="displayProfileLink" vartype="java.lang.String" param="displayProfileLink"/>
                  <c:if test="${displayProfileLink == 'true' or empty displayProfileLink}">
                   
                    <fmt:message var="linkText" key="emailtemplates_header.myAccount"/>
                    <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
                      <dsp:param name="path" value="/myaccount/profile.jsp"/>
                      <dsp:param name="httpserver" value="${httpserverVar}"/>
                      <dsp:param name="linkStyle" value="font-size:12px;font-family:Tahoma,Arial,sans-serif;color: #7F7F8C;text-decoration: none;margin-right: 10px;"/>
                      <dsp:param name="linkText" value="${linkText}"/>
                    </dsp:include>
                      
                  </c:if>
               </c:if>
               
               <%-- End Store Logo and My Account Link --%>
                
              </td>
            </tr>
          </table>
          <hr size="1" style="color:#7F7F8C;">
        </td>
      </tr>
<%-- 
----------------------------------------------------------------
End Header Content 
----------------------------------------------------------------
--%>   

<%-- 
----------------------------------------------------------------
Begin Main Content 
----------------------------------------------------------------
--%>
      <tr>
        <td align="center" style="padding-left:0px;padding-right:2px;padding-bottom:0px;background-color:#FFFFFF">
          <table width="681px" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td style="text-align:left;width:650px;background-color:#FFFFFF;padding:16px" valign="top">

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/header.jsp#2 $$Change: 635969 $--%>
