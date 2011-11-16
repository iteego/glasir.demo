<dsp:page>

  <%--
      Global gadget used for editing addresses

      Parameters:
      -  submitClassName (optional) - The class name to be used in the "submit" input tag
      -  cancelClassName (optional) - The class name to be used in the "cancel" input tag
  --%>

  <dsp:getvalueof var="submitClassName" vartype="java.lang.String" param="submitClassName"/>
  <dsp:getvalueof var="cancelClassName" vartype="java.lang.String" param="cancelClassName"/>

  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>

  <%-- An update form must display current profile attributes; we will instruct the
       B2CProfileFormHandler to extract the default billing address from the profile.
   --%>

  <%-- Assume update success for nickname update --%>
  <dsp:setvalue bean="B2CProfileFormHandler.extractDefaultValuesFromProfile" value="true"/>

  <div id="atg_store_addressEdit">

    <dsp:form action="${pageContext.request.requestURI}" method="post" formid="address">

      <fmt:message var="submitButtonText" key="common.button.updateText"/>
      <fmt:message var="cancelButtonText" key="common.button.cancelText"/>

      <%-- Show Form Errors --%>
      <dsp:include page="/myaccount/gadgets/myAccountErrorMessage.jsp">
        <dsp:param name="formHandler" bean="B2CProfileFormHandler"/>
        <dsp:param name="submitFieldText" value="${submitButtonText}"/>
      </dsp:include>

      <dsp:input bean="B2CProfileFormHandler.changeAddressNicknameSuccessURL" paramvalue="successURL" type="hidden"/>
      <dsp:input bean="B2CProfileFormHandler.updateAddressSuccessURL" paramvalue="successURL" type="hidden"/>
      <dsp:input bean="B2CProfileFormHandler.cancelURL" paramvalue="successURL" type="hidden"/>
      <dsp:input bean="B2CProfileFormHandler.editValue.nickname" type="hidden"/>

      <dsp:getvalueof var="origRequest" vartype="java.lang.String" bean="/OriginatingRequest.requestURI"/>
      <dsp:getvalueof var="successURL" vartype="java.lang.String" param="successURL"/>

      <dsp:getvalueof var="paramRestrictCountry" vartype="java.lang.String" param="restrictCountry"/>
      <dsp:input bean="B2CProfileFormHandler.updateAddressErrorURL" type="hidden"
                 value="${origRequest}?successURL=${successURL}&restrictCountry=${paramRestrictCountry}"/>

      <dl>
        <dt class="atg_store_nickName"><fmt:message key="common.nickName"/></dt>
        <dd class="atg_store_nickName">
          <dsp:valueof bean="B2CProfileFormHandler.editValue.nickname"/>
        </dd>

        <dt class="atg_store_nickName"><label for="atg_store_firstNameInput" class="required">
          <fmt:message key="common.newNickName"/>
        </label></dt>
        <dd class="atg_store_nickName">
          <dsp:input type="text" bean="B2CProfileFormHandler.editValue.newNickname" maxlength="40" required="true"
                     id="atg_store_nickNameInput"/>
        </dd>

  <dsp:include page="/global/gadgets/addressAddEdit.jsp">
          <dsp:param name="formhandlerComponent" value="/atg/userprofiling/B2CProfileFormHandler.editValue"/>
          <dsp:param name="checkForRequiredFields" value="true"/>
  </dsp:include>


      </dl>

      <div class="atg_store_formControls">
        <dsp:input type="submit" bean="B2CProfileFormHandler.updateAddress"
                   value="${submitButtonText}" iclass="${submitClassName}"/>
        <dsp:input type="submit" bean="B2CProfileFormHandler.cancel"
                   value="${cancelButtonText}" iclass="${cancelClassName}"/>
      </div>

      <div class="atg_store_formDetailsMessage">
        <span class="required"><fmt:message key="common.requiredFields"/></span>
      </div>

      <dsp:input bean="B2CProfileFormHandler.updateAddress" type="hidden" value="update"/>

    </dsp:form>
  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/addressEdit.jsp#2 $$Change: 635969 $--%>
