<dsp:page>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>

  <div id="atg_store_profileMyInfoEdit">
    <fmt:message  var="saveText" key="common.button.saveText"/>

    <%-- Show form errors --%>
    <dsp:include page="myAccountErrorMessage.jsp">
      <dsp:param name="formHandler" bean="B2CProfileFormHandler"/>
      <dsp:param name="submitFieldText" value="${saveText}"/>
    </dsp:include>

    <dsp:form action="${originatingRequest.requestURI}" method="post"
              id="atg_store_profilePasswordEditForm" formid="profilepasswordeditform">
      <dsp:setvalue bean="B2CProfileFormHandler.extractDefaultValuesFromProfile" value="false"/>
      <dsp:input bean="B2CProfileFormHandler.changePasswordSuccessURL" type="hidden" value="profile.jsp"/>
      <dsp:input bean="B2CProfileFormHandler.changePasswordErrorURL" type="hidden"
                 beanvalue="/OriginatingRequest.requestURI"/>
      <dsp:input bean="B2CProfileFormHandler.cancelURL" type="hidden" value="profile.jsp"/>
      <!-- set this form to require that the supplied password value should be the same
           as the confirm password parameter -->
      <dsp:input bean="B2CProfileFormHandler.confirmPassword" type="hidden" value="true"/>

      <fieldset>
        <ul class="atg_store_basicForm">
          <li>
              <label for="atg_store_profilePasswordEditOldPassword" class="required">
                <fmt:message key="myaccount_profilePasswordEdit.oldPassword"/>
                <span class="required">*</span>
              </label>
              <dsp:input bean="B2CProfileFormHandler.value.oldpassword" maxlength="35"
                         type="password" value="" required="true" iclass="required"
                         name="atg_store_profilePasswordEditOldPassword"
                         id="atg_store_profilePasswordEditOldPassword"/>
          </li>
          <li>
              <label for="atg_store_profilePasswordEditNewPassword" class="required">
                <fmt:message key="myaccount_profilePasswordEdit.newPassword"/>
                <span class="required">*</span>
              </label>
              <dsp:input bean="B2CProfileFormHandler.value.password" maxlength="35"
                         type="password" required="true" iclass="required"
                         name="atg_store_profilePasswordEditNewPassword"
                         id="atg_store_profilePasswordEditNewPassword"/>
              <span class="example"><fmt:message key="common.passwordCharacters"/></span>                         
          </li>
          <li>
              <label for="atg_store_profilePasswordEditRetyprPassword" class="required">
                <fmt:message key="common.confirmPassword"/>
                <span class="required">*</span>
              </label>
              <dsp:input bean="B2CProfileFormHandler.value.confirmpassword" maxlength="35"
                         type="password" required="true" iclass="required"
                         name="atg_store_profilePasswordEditRetypePassword"
                         id="atg_store_profilePasswordEditRetypePassword"/>
          </li>
        </ul>
      </fieldset>

      <div class="atg_store_formFooter">
        <div class="atg_store_formKey">
          <span class="required">* <fmt:message key="common.requiredFields"/></span>
        </div>
        <div class="atg_store_formActions">
          <fmt:message var="updateButton" key="common.button.saveChanges"/>
          <fmt:message var="cancelText" key="common.button.cancelText"/>
          <fmt:message var="cancelTitle" key="common.button.cancelTitle"/>

          <div class="atg_store_formActionItem">
            <span class="atg_store_basicButton">
              <dsp:input bean="B2CProfileFormHandler.changePassword"
                        type="submit" value="${updateButton}"
                        name="atg_store_profilePasswordEditSubmit"
                        id="atg_store_profilePasswordEditSubmit"/>
            </span>
          </div>
          <div class="atg_store_formActionItem">
            <span class="atg_store_basicButton secondary">
              <dsp:input type="submit"
                         value="${cancelText}" title="${cancelTitle}"
                         bean="B2CProfileFormHandler.cancel"
                         id="atg_store_profileMyInfoEditCancel"/>
            </span>
          </div>
        </div>
      </div>

    </dsp:form>
  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/profilePasswordEdit.jsp#2 $$Change: 633752 $--%>
