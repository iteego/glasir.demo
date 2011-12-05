<dsp:page>
  <%--  This layout page includes
        -  /global/gadgets/pageIntro.jsp introduction message for the page.           
        -  gadgets/login.jsp login form for returned customers
        -  gadgets/register.jsp registration form for new customers
  --%>
  <crs:pageContainer index="false" follow="false" bodyClass="atg_store_pageLogin">    
    <jsp:body>
      <dsp:importbean bean="/atg/store/profile/RegistrationFormHandler"/>
      <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
      <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
      <dsp:importbean bean="/atg/userprofiling/Profile"/>
      <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
     <div class="atg_store_nonCatHero">
      <dsp:include page="/global/gadgets/pageIntro.jsp" flush="true">
        <dsp:param name="divId" value="atg_store_registerIntro" />
        <dsp:param name="titleKey" value="myaccount_login.title" />        
      </dsp:include>
    </div>
      
      <c:if test="${not empty param['error']}">
        <div class="errorMessage">
          <%--
            Escape XML specific characters in error message key to prevent
            using it in XSS attacks.
          --%>
          <fmt:message key="${fn:escapeXml(param['error'])}"/>
        </div>
      </c:if>
      
      <fmt:message var="submitText" key="myaccount_registration.preRegister"/>
      
      <dsp:getvalueof var="regFormExceptions" vartype="java.lang.Object" bean="RegistrationFormHandler.formExceptions"/>
      <c:if test="${not empty regFormExceptions}">
          <dsp:include page="gadgets/myAccountErrorMessage.jsp">
            <dsp:param name="formHandler" bean="RegistrationFormHandler"/>
            <dsp:param name="submitFieldText" value="${submitText}"/>
          </dsp:include>         
      </c:if>

      <dsp:getvalueof var="b2cFormExceptions" vartype="java.lang.Object" bean="B2CProfileFormHandler.formExceptions"/>
      <c:if test="${not empty b2cFormExceptions}">
          <dsp:include page="gadgets/myAccountErrorMessage.jsp">
            <dsp:param name="formHandler" bean="B2CProfileFormHandler"/>                  
          </dsp:include>
      </c:if>
      
      <dsp:droplet name="Compare">
        <dsp:param name="obj1" bean="Profile.securityStatus"/>
        <dsp:param name="obj2" bean="PropertyManager.securityStatusCookie"/>
    
        <%-- New user or unrecognized member --%>
        <dsp:oparam name="lessthan">
          <c:set var="showLoginForm" value="true" scope="request"/>
          <c:set var="useDefaultProfileValues" value="false" scope="request"/>
        </dsp:oparam>
    
        <%-- User auto-logged in with cookie --%>
        <dsp:oparam name="equal">
          <c:set var="showLoginForm" value="true" scope="request"/>
          <c:set var="useDefaultProfileValues" value="true" scope="request"/>
          <div class="errorMessage">
            <fmt:message key="myaccount_login.verifyPassword"/>
          </div>
        </dsp:oparam>
    
        <%-- User logged in with login/password --%>
        <dsp:oparam name="greaterthan">
          <c:set var="showLoginForm" value="false" scope="request"/>
          <c:set var="loginState" value="loggedIn"/>
          <div class="errorMessage">
            <fmt:message key="myaccount_login.currentLogin">
              <fmt:param>
                <dsp:valueof bean="Profile.firstName"/>
              </fmt:param>
            </fmt:message>
            <p>
              <fmt:message var="anotherLoginTitle" key="myaccount_login.anotherLoginTitle"/>
            </p>
          </div>
        </dsp:oparam>
      </dsp:droplet>

      <div id="atg_store_accountLogin">

        <div id="atg_store_loginOrRegister">  
          

      
          <dsp:include page="gadgets/login.jsp" flush="true" />
          
          <dsp:include page="gadgets/preRegister.jsp" flush="true">
            <dsp:param name="submitFieldText" value="${submitText}"/>
          </dsp:include>
                    
        </div><%-- atg_store_loginOrRegister --%>
      </div><%-- login --%>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/login.jsp#2 $$Change: 635969 $--%>
