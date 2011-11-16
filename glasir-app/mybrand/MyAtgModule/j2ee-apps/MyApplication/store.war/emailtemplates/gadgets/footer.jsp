<dsp:page>
  <%-- This page expects the following parameters 
     1. httpserver - the server name and port so we can construct image src tags
  --%>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:getvalueof var="httpserverVar" param="httpserver"/>
  <dsp:getvalueof var="messageFromEmailAddress" param="messageFrom"/>
  <dsp:getvalueof var="serverURL" vartype="java.lang.String" value="${httpserverVar}/crsdocroot/"/>  
    

<%-- 
----------------------------------------------------------------
End Main Content 
----------------------------------------------------------------
--%>
              
              <div align="center" style="font-family:Tahoma,Arial,sans-serif;font-size:11px;margin-top:8px;margin-bottom:0px;color:#999999">
              <c:if test="${not empty messageFromEmailAddress}">
                <fmt:message key="emailtemplates_footer.addToAddressBook">
                  <fmt:param>
                    <a class="email" target="_blank" href="mailto:${messageFromEmailAddress}">${messageFromEmailAddress}</a>
                    
                  </fmt:param>
                </fmt:message>  
              </c:if>
              </div>
            </td>
          </tr>
     
          </table>
        </td>
      </tr>
    </table>

<%-- 
----------------------------------------------------------------
Begin Footer
----------------------------------------------------------------
--%>

    <div align="center">
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
      <tr>
        <td align="center" style="font-family:Verdana,Arial,sans-serif;font-size:12px;color:#4F7BC4;padding-top:16px">
          <fmt:message var="linkText" key="company_terms.title"/>
          <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
            <dsp:param name="path" value="/company/terms.jsp?selpage=terms"/>
            <dsp:param name="httpserver" param="httpserver"/>
            <dsp:param name="linkStyle" value="margin-left:6px;margin-right:6px;color:#4F7BC4;text-decoration:none;font-weight:bold"/>
            <dsp:param name="linkText" value="${linkText}"/>
          </dsp:include> 
          &nbsp;&nbsp;|&nbsp;&nbsp;
          <fmt:message var="linkText" key="emailtemplates_footer.privacyPolicy"/>
          <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
            <dsp:param name="path" value="/company/privacy.jsp?selpage=privacy"/>
            <dsp:param name="httpserver" param="httpserver"/>
            <dsp:param name="linkStyle" value="margin-left:6px;margin-right:6px;color:#4F7BC4;text-decoration:none;font-weight:bold"/>
            <dsp:param name="linkText" value="${linkText}"/>
          </dsp:include> 
          &nbsp;&nbsp;|&nbsp;&nbsp;
          <fmt:message var="linkText" key="emailtemplates_footer.shipping"/>
          <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
            <dsp:param name="path" value="/company/shipping.jsp?selpage=shipping"/>
            <dsp:param name="httpserver" param="httpserver"/>
            <dsp:param name="linkStyle" value="margin-left:6px;margin-right:6px;color:#4F7BC4;text-decoration:none;font-weight:bold"/>
            <dsp:param name="linkText" value="${linkText}"/>
          </dsp:include> 
          &nbsp;&nbsp;|&nbsp;&nbsp;
          <fmt:message var="linkText" key="emailtemplates_footer.contactUs"/>
          <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
            <dsp:param name="path" value="/company/customerService.jsp?selpage=customerService"/>
            <dsp:param name="httpserver" param="httpserver"/>
            <dsp:param name="linkStyle" value="margin-left:6px;margin-right:6px;color:#4F7BC4;text-decoration:none;font-weight:bold"/>
            <dsp:param name="linkText" value="${linkText}"/>
          </dsp:include>
        </td>
      </tr>
      <tr>
        <td align="center" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;padding-top:16px;color:#999999">
          <dsp:include page="/global/gadgets/copyright.jsp" flush="true">
            <dsp:param name="copyrightDivId" value="copyrightText"/>
          </dsp:include>
        </td>
      </tr>
    </table>
    </div>
  </div>

</body>
</html>

<%-- 
----------------------------------------------------------------
End Footer
----------------------------------------------------------------
--%>

  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/footer.jsp#1 $$Change: 633540 $--%>
