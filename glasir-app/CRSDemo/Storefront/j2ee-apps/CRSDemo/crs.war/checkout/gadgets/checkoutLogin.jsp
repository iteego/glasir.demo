<%-- 
  This gadget renders the login form during the checkout process
  Page consists of 3 tabs:
    - Returning Customer 
    - New Customer
    - Continue without an Account 
--%>

<dsp:page>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  
  <%-- show form errors --%>
  <dsp:include page="/myaccount/gadgets/myAccountErrorMessage.jsp">
    <dsp:param name="formHandler" bean="B2CProfileFormHandler"/>
    <dsp:param name="errorMessageClass" value="errorMessage"/>
  </dsp:include>

  <div id="atg_store_checkoutlogin">

  <dsp:getvalueof var="express" vartype="java.lang.String" param="express"/>
  <dsp:getvalueof var="currentLocale" vartype="java.lang.String" bean="/atg/dynamo/servlet/RequestLocale.localeString"/>
  <c:choose>
    <c:when test='${express == "true"}'>
      <dsp:getvalueof var="loginSuccessURL" value="confirm.jsp?expressCheckout=true&locale=${currentLocale}"/>
    </c:when>
    <c:otherwise>
      <dsp:getvalueof var="loginSuccessURL" value="shipping.jsp?locale=${currentLocale}"/>
    </c:otherwise>
  </c:choose>

  <%-- Exsisting customer tab --%>
  <div class="atg_store_checkoutLogin atg_store_accountLogin" id="atg_store_returningCustomerLogin">
    <h2>
      <span><fmt:message key="login.returningCustomer"/></span>
    </h2>
    <div class="atg_store_register">
      <dsp:form id="atg_store_checkoutLoginForm" formid="checkoutloginregistered" action="${originatingRequest.requestURI}" method="post">
        <dsp:input bean="B2CProfileFormHandler.loginSuccessURL" type="hidden" value="${loginSuccessURL}"/>
        <dsp:input bean="B2CProfileFormHandler.loginErrorURL" type="hidden" beanvalue="/OriginatingRequest.requestURI"/>
        <dsp:input bean="B2CProfileFormHandler.checkoutLoginOption" type="hidden" value="continueexistinguser"/>
        <fieldset class="enter_info atg_store_havePassword">
          <div class="hid">
            <ul class="atg_store_basicForm">
              <li>
                <label>
                  <fmt:message key="common.email"/>
                  <span class="required">*</span>
                </label>
                <dsp:getvalueof var="anonymousStatus" vartype="java.lang.Integer" bean="/atg/userprofiling/PropertyManager.securityStatusAnonymous"/>
                <dsp:getvalueof var="currentStatus" vartype="java.lang.Integer" bean="Profile.securityStatus"/>
                <dsp:getvalueof var="currentEmail" vartype="java.lang.String" bean="Profile.email"/>
                <dsp:input type="text" bean="B2CProfileFormHandler.emailAddress" name="email"
                    value="${currentStatus > anonymousStatus ? currentEmail : ''}" id="atg_store_emailInput"/>
              </li>
              <li>
                <label for="atg_store_passwordInput">
                  <fmt:message key="common.loginPassword"/>
                  <span class="required">*</span>
                </label>
                <dsp:input bean="B2CProfileFormHandler.value.password" type="password" name="password" id="atg_store_passwordInput" value="" />
                <fmt:message var="forgotPasswordTitle" key="checkout_checkoutLogin.forgotPasswordTitle"/>
         
                  <dsp:a page="/myaccount/passwordReset.jsp" title="${forgotPasswordTitle}" iclass="info_link atg_store_forgetPassword">
                    <fmt:message key="common.button.passwordResetText"/>
                  </dsp:a>
      
              </li>
            </ul>
          </div>
          <div class="atg_store_formFooter">
            <div class="atg_store_formActions">
              <span class="atg_store_basicButton">
                <fmt:message key="myaccount_login.submit" var="loginCaption"/>
                <dsp:input bean="B2CProfileFormHandler.loginDuringCheckout" id="atg_store_checkoutLoginButton" type="submit" value="${loginCaption}"/>
              </span>
            </div>
          </div>
        </fieldset>
      </dsp:form>
    </div>
  </div>
        
  <%-- New customer tab --%>
  <div class="atg_store_checkoutLogin atg_store_accountLogin" id="atg_store_newCustomerLogin">
    <h2>
      <span class="open"><fmt:message key="login.newCustomer"/></span>
    </h2>
    <div class="atg_store_register">
      <dsp:form id="atg_store_checkoutLoginForm" formid="checkoutloginnewuser" action="${originatingRequest.requestURI}" method="post">
      <!--[if IE]><input type="text" style="display: none;" disabled="disabled" size="1" /><![endif]-->
        <dsp:input bean="B2CProfileFormHandler.loginSuccessURL" type="hidden" value="../checkout/registration.jsp"/>
        <dsp:input bean="B2CProfileFormHandler.logoutSuccessURL" type="hidden" value="../checkout/registration.jsp"/>
        <dsp:input bean="B2CProfileFormHandler.loginErrorURL" type="hidden" beanvalue="/OriginatingRequest.requestURI"/>
        <dsp:input bean="B2CProfileFormHandler.checkoutLoginOption" type="hidden" value="createnewuser"/>
        <fieldset class="enter_info atg_store_noPassword">
          <div class="hid">
            <ul class="atg_store_basicForm">
              <li>
                <label>
                  <fmt:message key="common.email"/>
                  <span class="required">*</span>
                </label>
                <dsp:input type="text" bean="B2CProfileFormHandler.newCustomerEmailAddress" id="atg_store_emailInputRegister" />
                
          
                  <a class="info_link" href="javascript:void(0)" onclick="atg.store.util.openwindow('../company/privacyPolicyPopup.jsp', 'sizeChart', 500, 500)">
                    <fmt:message key="common.button.privacyPolicyText"/>
                  </a>
          
              </li>
            </ul>
          </div>
        </fieldset>
        <div class="atg_store_formFooter">
          <div class="atg_store_formActions">
            <span class="atg_store_basicButton">
              <fmt:message key="myaccount_registration.submit" var="createAccountCaption"/>
              <dsp:input bean="B2CProfileFormHandler.loginDuringCheckout" id="atg_store_createMyAccountButton" type="submit" value="${createAccountCaption}"/>
            </span>
          </div>
        </div>
      </dsp:form>
    </div>
  </div>

  <%-- Anonymous customer tab --%>
  <div class="atg_store_checkoutLogin atg_store_accountLogin" id="atg_store_anonCustomerLogin">
    <h2>
      <span class="open"><fmt:message key="checkout_login.button.anonymous"/></span>
    </h2>
    <div class="atg_store_register">
      <dsp:form id="atg_store_checkoutLoginForm" formid="checkoutloginanonymous" action="${originatingRequest.requestURI}" method="post">
        <dsp:input bean="B2CProfileFormHandler.loginSuccessURL" type="hidden" value="shipping.jsp"/>
        <dsp:input bean="B2CProfileFormHandler.logoutSuccessURL" type="hidden" value="shipping.jsp"/>
        <dsp:input bean="B2CProfileFormHandler.loginErrorURL" type="hidden" beanvalue="/OriginatingRequest.requestURI"/>
        <dsp:input bean="B2CProfileFormHandler.checkoutLoginOption" type="hidden" value="continueanonymous"/>
        <fieldset>
          <ul class="atg_store_basicForm">
            <li>
              <p><fmt:message key="checkout_login.description.anonymous"/></p>
            </li>
          </ul>
        </fieldset>
        <div class="atg_store_formFooter">
          <div class="atg_store_formActions">
            <span class="atg_store_basicButton">
              <fmt:message key="checkout_login.button.anonymous" var="anonymousCaption"/>
              <dsp:input bean="B2CProfileFormHandler.loginDuringCheckout" type="submit" value="${anonymousCaption}"/>
            </span>
          </div>
        </div>
      </dsp:form>
    </div>
  </div>
</div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/checkoutLogin.jsp#2 $$Change: 633752 $--%>
