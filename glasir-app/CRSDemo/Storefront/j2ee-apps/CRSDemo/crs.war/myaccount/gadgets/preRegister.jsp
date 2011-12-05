<%--
  This gadget asks for email address for new customers. If address is valid,
  registration continues. 
 --%>
<dsp:page>

  <dsp:importbean bean="/atg/store/profile/RegistrationFormHandler"/>
  <dsp:importbean var="originatingRequest" bean="/OriginatingRequest"/>
  <dsp:getvalueof var="contextPath" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof var="submitText" param="submitFieldText"/>
  <dsp:setvalue bean="RegistrationFormHandler.extractDefaultValuesFromProfile" value="false"/>
  
  <div class="atg_store_accountLogin" id="atg_store_newCustomerPreLogin">
    <h2>
      <span class="open">
        <fmt:message key="login.newCustomer" />
      </span>
    </h2>
    
    <dsp:form method="post" action="${originatingRequest.requestURI}" 
      id="atg_store_preRegisterForm" formid="atg_store_preRegisterForm">
    
      <%-- If email validation succeeds, go to the registration page and continue fill in required information --%>
      <dsp:input bean="RegistrationFormHandler.preRegisterSuccessURL" type="hidden" value="registration.jsp"/>
      
      <%-- If validation fails, redisplay login page with errors shown --%>
      <dsp:input bean="RegistrationFormHandler.preRegisterErrorURL" type="hidden" value="${originatingRequest.requestURI}"/>
      <ul class="atg_store_basicForm">
      <%-- Email field --%>
      <li>
      <label for="atg_store_registerEmailAddress" class="required">
        <fmt:message key="common.email" />
      </label>
    
      <dsp:input bean="RegistrationFormHandler.value.email" iclass="text" type="text" 
        required="true" id="atg_store_registerEmailAddress"/>
    
        <%-- Link to privacy policy popup --%>
        <fmt:message var="privacyPolicyTitle" key="common.button.privacyPolicyTitle"/>
  
        <dsp:a href="${contextPath}/company/privacyPolicyPopup.jsp"
          iclass="info_link" target="popup" title="${privacyPolicyTitle}">
          <fmt:message key="common.button.privacyPolicyText"/>
        </dsp:a>
    
      </li>
      
      </ul>

      <%-- 'Create my account' button --%>
      <fmt:message var="submitText" key="myaccount_registration.preRegister"/>
      
      <div class="atg_store_formFooter">
        <div class="atg_store_formActions">
          <span class="atg_store_basicButton atg_store_chevron">
            <dsp:input bean="RegistrationFormHandler.preRegister" type="submit" 
              alt="${submitText}" value="${submitText}" id="atg_store_createAccountButton"/>
          </span>    
        </div>
      </div>
      
      <dsp:input bean="RegistrationFormHandler.preRegister" type="hidden" value="submit"/>
          
    </dsp:form>
    

  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/preRegister.jsp#2 $$Change: 633752 $--%>