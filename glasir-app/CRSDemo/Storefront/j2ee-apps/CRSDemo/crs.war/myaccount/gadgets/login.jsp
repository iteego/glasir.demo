<dsp:page>
  <%-- This page fragment renders login form for returned customers    
  --%>
  <dsp:importbean bean="/atg/store/profile/SessionBean"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean var="originatingRequest" bean="/OriginatingRequest"/>
  
  <dsp:getvalueof var="currentLocale" vartype="java.lang.String" bean="/atg/dynamo/servlet/RequestLocale.localeString"/>
  <div class="atg_store_accountLogin" id="atg_store_returningCustomerLogin">
      <h2>
        <span class="open"><fmt:message key="login.returningCustomer" /></span>
      </h2>              
        
    <div class="atg_store_register">
      <fieldset class="atg_store_havePassword">
        <c:if test="${showLoginForm}">
          <dsp:setvalue bean="B2CProfileFormHandler.extractDefaultValuesFromProfile" value="${useDefaultProfileValues}"/>
          <dsp:form action="${originatingRequest.requestURI}" method="post" id="atg_store_registerLoginForm" formid="atg_store_registerLoginForm">
            
            <%-- Get the loginSuccessURL from SessionBean --%>
            <dsp:getvalueof var="loginSuccessURL" bean="SessionBean.values.loginSuccessURL"/>
						
            <%-- If its not set in the Session bean check for a loginSuccessURL paramater --%>
            <c:if test="${empty loginSuccessURL}">
              <dsp:getvalueof var="loginSuccessURL" param="loginSuccessURL"/>
              <%-- Set the SessionBean incase the page is reloaded --%>
              <dsp:setvalue bean="SessionBean.values.loginSuccessURL" value="${loginSuccessURL}"/>
            </c:if>
						
            <c:choose>
              <c:when test="${not empty loginSuccessURL}">
                
                <%-- Get the selected page value that the user was trying to get to --%>
                <dsp:getvalueof var="selpage" bean="SessionBean.values.selpage"/>
                
                <%-- If we were redirected to here before going to selected page, append the 
                     selected page value to the success URL (if available). 
                 --%>
                <c:choose>
                  <c:when test="${not empty selpage}">
                    <c:url value="${loginSuccessURL}" var="successURL" scope="page">
                      <c:param name="selpage" value="${selpage}"/>
                      <c:param name="locale" value="${currentLocale}"/>
                    </c:url>
                  </c:when>
                  <c:otherwise>
                    <c:url value="${loginSuccessURL}" var="successURL" scope="page">
                      <c:param name="locale" value="${currentLocale}"/>
                    </c:url>
                  </c:otherwise>
                </c:choose>

                <dsp:input bean="B2CProfileFormHandler.loginSuccessURL" type="hidden"
                           value="${successURL}"/>
              </c:when>
              <%-- Default to the home page if there is no loginSuccessURL --%>
              <c:otherwise>
                <dsp:input bean="B2CProfileFormHandler.loginSuccessURL" type="hidden" value="../index.jsp?locale=${currentLocale}"/>
              </c:otherwise>
            </c:choose>
      
            <ul class="atg_store_basicForm">
            <li>
              <label for="atg_store_registerLoginEmailAddress"><fmt:message key="common.loginEmailAddress"/></label>
            
              <dsp:input bean="B2CProfileFormHandler.value.login" iclass="text"
                         type="text" required="true"
                         name="atg_store_registerLoginEmailAddress"
                         id="atg_store_registerLoginEmailAddress" />
            </li>
            <li>
              <label for="atg_store_registerLoginPassword"><fmt:message key="common.loginPassword"/></label>
              
              <dsp:input bean="B2CProfileFormHandler.value.password" iclass="text"
                         type="password" required="true" value=""
                         name="atg_store_registerLoginPassword"
                         id="atg_store_registerLoginPassword" />
                        
               <fmt:message var="passwordResetTitle" key="common.button.passwordResetTitle" />
               <dsp:a page="../passwordReset.jsp" title="${passwordResetTitle}" iclass="info_link atg_store_forgetPassword">
                 <fmt:message key="common.button.passwordResetText" />
               </dsp:a>
         
              
            </li>
            </ul>

            <div class="atg_store_formFooter">
              <div class="atg_store_formActions">
                <fmt:message var="submitText" key="myaccount_login.submit"/>
                <span class="atg_store_basicButton atg_store_chevron">
                <dsp:input bean="B2CProfileFormHandler.login" type="submit"
                           alt="${submitText}" value="${submitText}" id="atg_store_loginButton"/>
                </span>
              </div>
            </div>     
          </dsp:form>
        </c:if>
    </div><%-- atg_store_register --%>
  </div><%-- atg_store_accountLogin --%> 
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/login.jsp#2 $$Change: 633752 $--%>
