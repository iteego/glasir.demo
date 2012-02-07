<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/userprofiling/ForgotPasswordHandler"/>

  <div id="atg_store_profilePasswordForgot">
    <dsp:form action="${originatingRequest.requestURI}" method="post"
              id="atg_store_profilePasswordForgotForm" formid="atg_store_profilePasswordForgotForm">
      <dsp:input bean="ForgotPasswordHandler.forgotPasswordSuccessURL" type="hidden"
                 value="tempPasswordSent.jsp"/>
      <dsp:input type="hidden" bean="ForgotPasswordHandler.forgotPasswordErrorURL"
                 value="passwordReset.jsp"/>
      <ul class="atg_store_basicForm">
        <li>
            <label for="atg_store_profilePasswordForgotEmail" class="required">
              <fmt:message key="common.loginEmailAddress"/>
              <span class="required">*</span>
            </label>
          <dsp:input type="text" bean="ForgotPasswordHandler.value.email" size="35" required="true"
                     name="atg_store_profilePasswordForgotEmail" iclass="required"
                     id="atg_store_profilePasswordForgotEmail"/>
        </li>
      </ul>

      <div class="atg_store_formFooter">
      <span class="required">* <fmt:message key="common.requiredFields"/></span>
      <div class="atg_store_formActions">
        <fmt:message var="submitText" key="common.button.emailMyPassword"/>
        <fmt:message var="submitTitle" key="common.button.emailMyPasswordTitle"/>
        <span class="atg_store_basicButton atg_store_emailMe">
        <dsp:input bean="ForgotPasswordHandler.forgotPassword" type="submit" name="atg_store_profilePasswordForgotSubmit"
                   id="atg_store_profilePasswordForgotSubmit"
                   title="${submitTitle}" value="${submitText}"/>
        </span>
        <dsp:input bean="ForgotPasswordHandler.forgotPassword" type="hidden" value="${submitText}"/>
      </div>
      </div>
    </dsp:form>

  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/profilePasswordForgot.jsp#2 $$Change: 635969 $--%>
