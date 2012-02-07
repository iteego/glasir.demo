<dsp:page>
  <%--
      Layout page for reset the password.
  --%>
  <crs:pageContainer divId="atg_store_profilePasswordForgotIntro" 
                     index="false" follow="false"
                     bodyClass="atg_store_forgotPassword">
    <jsp:body>
      <div class="atg_store_nonCatHero">
        <h2 class="title"><fmt:message key="myaccount_profilePasswordForgot.title"/></h2>
      </div>
      <%-- Show form errors --%>
      <dsp:getvalueof var="formExceptions" vartype="java.lang.Object" bean="/atg/userprofiling/ForgotPasswordHandler.formExceptions"/>
      <c:if test="${not empty formExceptions}">
        <div id="atg_store_formValidationError" class="errorMessage">
          <c:forEach var="formException" items="${formExceptions}">
            <dsp:param name="formException" value="${formException}"/>
            <p>
              <%-- Check the error message code to see what we should do --%>
              <dsp:getvalueof var="errorCode" param="formException.errorCode"/>
              <c:choose>
                <c:when test="${errorCode == 'missingRequiredValue'}">
                  <fmt:message key="myaccount_profilePasswordForgot.fillEmailAddress"/>
                </c:when>
                <c:otherwise>
                  <dsp:valueof param="formException.message" valueishtml="true">
                    <fmt:message key="common.errorMessageDefault"/>
                  </dsp:valueof>
                </c:otherwise>
              </c:choose>
            </p>
          </c:forEach><%-- End For Each error --%>
        </div>
      </c:if>
      <crs:messageContainer titleKey="myaccount_profilePasswordForgot.noProblem"
        messageKey="myaccount_profilePasswordForgot.intro">
        <jsp:body>
          <dsp:include page="gadgets/profilePasswordForgot.jsp" flush="true"/>
        </jsp:body>
      </crs:messageContainer>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/passwordReset.jsp#1 $$Change: 633540 $--%>
