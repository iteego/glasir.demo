<dsp:page>

  <%-- 
       This page expects the following parameters:
       -  formHandler - The form handler whose errors we display
       -  submitFieldText (optional) - Text on the "commit" field which is added to
          the message shown for missing required data
       -  errorMessageClass (optional) - CSS class used for <p> tag when rendering
          error messages

       Form Condition:
       - This gadget may be contained inside of more than one form.
         One of the following form handlers must have been invoked from a submit
         button before this gadget will show any exception messages:
         - B2CProfileFormHandler
         - GiftlistFormHandler
         - RegistrationFormHandler
  --%>
  <dsp:importbean bean="/atg/store/profile/RequestBean"/>

  <dsp:getvalueof id="formHandler" param="formHandler"/>
  <dsp:getvalueof id="submitFieldText" param="submitFieldText"/>
  <dsp:getvalueof id="errorMessageClass" param="errorMessageClass"/>
  <c:if test="${empty submitFieldText}">
    <fmt:message var="submitFieldText" key="common.button.saveText"/>
  </c:if>

  <%-- Usually using ErrorMessageForEach droplet is a nice shortcut to get the 
       error messages.  In this case we need to weed out specific error messages 
       because we share a page with another form.
       
       Commerce Reference Application only wants to display a single error in cases where one or 
       more required properties have been omitted from the form.  To handle this 
       case we use the RequestBean to store page values useful only for this request.  
   --%> 

  <dsp:getvalueof var="formExceptions" vartype="java.lang.Object" param="formHandler.formExceptions"/>
  <c:if test="${not empty formExceptions}">
         
    <c:forEach var="formException" items="${formExceptions}">
      <dsp:param name="formException" value="${formException}"/>
      <%-- Check the error message code to see what we should do --%>
      <dsp:getvalueof var="errorCode" param="formException.errorCode"/>
      <c:choose>
        <c:when test="${errorCode == 'invalidLoginAlreadyLoggedIn'}">
          <div class="errorMessage">
            <fmt:message key="myaccount_login.currentLogin">
              <fmt:param>
                <dsp:valueof bean="/atg/userprofiling/Profile.firstName"/>
              </fmt:param>
            </fmt:message>
            <br/>
            <fmt:message key="myaccount_login.anotherLoginText">
              <fmt:param>
                <dsp:a page="/">
                  <dsp:property bean="/atg/userprofiling/B2CProfileFormHandler.logoutSuccessURL" value="myaccount/login.jsp"/>
                  <dsp:property bean="/atg/userprofiling/B2CProfileFormHandler.logout" value="true"/>
                  <fmt:message key="common.clickHere"/>
                </dsp:a>
              </fmt:param>
            </fmt:message>
          </div>
        </c:when>

        <c:when test="${errorCode == 'invalidPassword'}">
          <fmt:message var="linkTitle" key="myaccount_myAccountErrorMessage.resetPasswordTitle"/>
          <div class="errorMessage">
            <fmt:message key="myaccount_myAccountErrorMessage.invalidLoginText">
              <fmt:param>
                <dsp:a page="/myaccount/passwordReset.jsp?defaultToProfile=true" title="${linkTitle}">
                 <fmt:message key="common.here"/></dsp:a>
              </fmt:param>
            </fmt:message>
          </div>
        </c:when>

        <c:when test="${errorCode == 'invalidLogin'}">
          <fmt:message var="linkTitle" key="myaccount_myAccountErrorMessage.resetPasswordTitle"/>
          <div class="errorMessage">
            <fmt:message key="myaccount_myAccountErrorMessage.invalidLoginText">
              <fmt:param>
                <dsp:a page="/myaccount/passwordReset.jsp?defaultToProfile=true" title="${linkTitle}">
                  <fmt:message key="common.here"/></dsp:a>
              </fmt:param>
            </fmt:message>
          </div>
        </c:when>

        <c:when test="${errorCode == 'invalidDate'}">
          <div class="errorMessage">
            <fmt:message key="myaccount_myAccountErrorMessage.msgDOB"/>
          </div>
        </c:when>
        <c:when test="${errorCode == 'userAlreadyExists'}">
          <div class="errorMessage">
            <fmt:message key="common.emailExistsText">
              <fmt:param>
                <dsp:a page="/myaccount/passwordReset.jsp"> 
                  <fmt:message key="common.here"/></dsp:a>
              </fmt:param>
            </fmt:message>
          </div>
        </c:when>

        <c:when test="${errorCode == 'missingRequiredValue'}">
          <dsp:getvalueof var="miss_req_value" bean="RequestBean.values.miss_req_value"/>
          <c:choose>
            <c:when test="${miss_req_value == true}">
              <%-- We've already spoken for missing values --%>
            </c:when>
            <c:otherwise>
              <%-- Show the default message when an error is made --%>
              <%-- Mark that we've just spoken for missing values --%>
              <dsp:setvalue bean="RequestBean.values.miss_req_value" value="true"/>
              <dsp:getvalueof var="propertyName" param="formException.propertyName"/>
              <c:choose>
                <c:when test="${propertyName == 'login'}">
                  <dsp:setvalue bean="RequestBean.values.miss_req_value" value="false"/>
                  <div class="errorMessage"><fmt:message key="myaccount_myAccountErrorMessage.fillEmailAddress"/></div>
                </c:when>
                <c:when test="${propertyName == 'password'}">
                  <dsp:setvalue bean="RequestBean.values.miss_req_value" value="false"/>
                 <div class="errorMessage"><fmt:message key="myaccount_myAccountErrorMessage.fillPassword"/></div>
                </c:when>
                <c:otherwise>
                  <div class="errorMessage">
                    <fmt:message key="common.additionalInfoRequired">
                      <fmt:param value="${submitFieldText}"/>
                    </fmt:message>
                  </div>
                </c:otherwise>
                <%-- Notice how we do not have any default here, this is because the login page shares space
                     with other forms so we attempt to capture and display all login errors but suppress
                     the others --%>
              </c:choose><%-- End c:choose to see what field was not filled in --%>
            </c:otherwise>
          </c:choose><%-- End c:choose to see what field was not filled in --%>
        </c:when>

        <c:when test="${errorCode == 'missingCreditCardProperty'}">
          <dsp:getvalueof var="miss_req_value" bean="RequestBean.values.miss_req_value"/>
          <c:choose>
            <c:when test="${miss_req_value == 'true'}">
              <%-- We've already spoken for missing values --%>
            </c:when>
            <c:otherwise>
              <%-- Show the default message when an error is made --%>
              <div class="errorMessage">
                <fmt:message key="common.additionalInfoRequired">
                  <fmt:param value="${submitFieldText}"/>
                </fmt:message>
              </div>
              <%-- Mark that we've just spoken for missing values --%>
              <dsp:setvalue bean="RequestBean.values.miss_req_value" value="true"/>
            </c:otherwise>
          </c:choose><%-- End c:choose to see what field was not filled in --%>
        </c:when>

        <c:when test="${errorCode == 'missingCreditCardAddressNickname'}">
          <dsp:getvalueof var="miss_req_value" bean="RequestBean.values.miss_req_value"/>
          <c:choose>
            <c:when test="${miss_req_value == 'true'}">
              <%-- We've already spoken for missing values --%>
            </c:when>
            <c:otherwise>
              <%-- Show the default message when an error is made --%>
              <div class="errorMessage">
                <fmt:message key="common.additionalInfoRequired">
                  <fmt:param value="${submitFieldText}"/>
                </fmt:message>
              </div>
              <%-- Mark that we've just spoken for missing values --%>
              <dsp:setvalue bean="RequestBean.values.miss_req_value" value="true"/>
            </c:otherwise>
          </c:choose><%-- End c:choose to see what field was not filled in --%>
        </c:when>

        <c:otherwise>
          <div class="errorMessage">
            <dsp:valueof param="formException.message" valueishtml="true">
              <fmt:message key="myaccount_myAccountErrorMessage.errorCode"/>
            </dsp:valueof>
          </div>
        </c:otherwise>

      </c:choose>
    </c:forEach><%-- End For Each error --%>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/myAccountErrorMessage.jsp#1 $$Change: 633540 $--%>
