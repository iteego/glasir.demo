<dsp:page>
  <%-- This page update the details of user profile and Default Shipping Method using RegistrationFormHandler--%>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/droplet/IsEmailRecipient"/>
  <dsp:importbean bean="/atg/store/profile/RegistrationFormHandler"/>
  <dsp:importbean bean="/atg/commerce/pricing/AvailableShippingMethods"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/dynamo/droplet/PossibleValues"/>
  <dsp:importbean bean="/atg/userprofiling/ProfileAdapterRepository"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%-- set the Date format on the basis of locale   --%>
  <fmt:message key="common.dateFormat" var="dateFormat"/>
  <dsp:setvalue bean="RegistrationFormHandler.dateFormat" value="${dateFormat}"/>
  <dsp:setvalue bean="RegistrationFormHandler.extractDefaultValuesFromProfile" value="true"/>

  <div id="atg_store_profileMyInfoEdit">  
    
    <%-- Show form errors --%>
    <fmt:message  var="submitText" key="common.button.saveProfileText"/>
    <div id="atg_store_formValidationError">  
      <dsp:include page="myAccountErrorMessage.jsp">
        <dsp:param name="formHandler" bean="RegistrationFormHandler"/>
        <dsp:param name="submitFieldText" value="${submitText}"/>
        <dsp:param name="errorMessageClass" value="errorMessage"/>
      </dsp:include>
    </div>  
      <%-- End of include --%>


    <dsp:form action="${originatingRequest.requestURI}" method="post" formid="atg_store_profileMyInfoEditForm">
      <%--hidden value required by RegistrationFormHandler --%>
      <dsp:input bean="RegistrationFormHandler.updateSuccessURL" type="hidden" value="profile.jsp"/>
      <dsp:input bean="RegistrationFormHandler.updateErrorURL" type="hidden" beanvalue="/OriginatingRequest.requestURI"/>
      <dsp:input bean="RegistrationFormHandler.cancelURL" type="hidden" value="profile.jsp"/>

      <dsp:input type="hidden" bean="RegistrationFormHandler.loginEmailAddress"
                 beanvalue="RegistrationFormHandler.value.email"/>
  
      <fieldset>
        <ul class="atg_store_basicForm">
          <li>
              <label for="atg_store_profileMyInfoEditEmailAddress" class="required">
                <fmt:message key="common.email"/>
                <span class="required">*</span>
         
              </label>
              <dsp:input type="text" iclass="required" maxlength="40"
                         id="atg_store_profileMyInfoEditEmailAddress"
                         bean="RegistrationFormHandler.value.email" required="true"/>
          </li>
          <li>
              <label for="atg_store_profileMyInfoEditFirstName" class="required">
                <fmt:message key="common.firstName"/>
                <span class="required">*</span>
              </label>
              <dsp:input id="atg_store_profileMyInfoEditFirstName"
                         iclass="required" maxlength="40" bean="RegistrationFormHandler.value.firstName"
                         type="text" required="true"/>
          </li>
          <li>
              <label for="atg_store_profileMyInfoEditLastName" class="required">
                <fmt:message key="common.lastName"/>
                <span class="required">*</span>
              </label>
              <dsp:input type="text" iclass="required" maxlength="40"
                         id="atg_store_profileMyInfoEditLastName"
                         bean="RegistrationFormHandler.value.lastName" required="true"/>
          </li>
          </ul>
          <h3><fmt:message key="myaccount_optionalInfo.title"/></h3>
          
          <ul class="atg_store_basicForm">
          <li>
              <label for="atg_store_profileMyInfoEditPostalCode" class="required">
                <fmt:message key="common.zipOrPostalCode"/>
                <span class="required">*</span>
              </label>
              <dsp:input type="text" iclass="required" maxlength="10" size="36"
                         id="atg_store_profileMyInfoEditPostalCode"
                          bean="RegistrationFormHandler.value.homeAddress.postalCode"
                          />
      </li>
      <li>
            <label for="atg_store_profileMyInfoEditGender">
              <fmt:message key="common.gender"/>
            </label>
          <dsp:select width="50" name="atg_store_profileMyInfoEditGender"
                      id="atg_store_profileMyInfoEditGender"
                      bean="RegistrationFormHandler.value.gender" >
            <%-- Get genders from droplet PossibleValues need to pass parameter
                 itemDescriptorName as user and propertyName as gender --%>
            <dsp:droplet name="PossibleValues">
              <dsp:param name="itemDescriptorName" value="user"/>
              <dsp:param name="propertyName" value="gender"/>
               <dsp:setvalue param="repository" beanvalue="ProfileAdapterRepository"/>
              <dsp:oparam name="output">
  
                <%-- get the output parameter of PossibleValues Droplet and put it
                     into the forEach  --%>
                <dsp:getvalueof var="values" vartype="java.lang.Object" param="values"/>
                <c:forEach var="gender" items="${values}">
                  <c:choose>
                    <%-- If value is unknown, show title --%>
                    <c:when test="${gender == 'unknown'}">
                      <dsp:option value="${gender}">
                        <fmt:message key="common.selectGender"/>
                      </dsp:option>
                    </c:when>
                    <%-- Otherwise get possible values from repository --%>
                    <c:otherwise>
                      <dsp:option value="${gender}">
                        <fmt:message key="${gender}"/>
                      </dsp:option>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </dsp:oparam>
            </dsp:droplet><%-- End Possible Values --%>
          </dsp:select><%-- End of dsp:select --%>
      </li>
      <li>
          <label for="atg_store_profileMyInfoEditDateOfBirth">
            <fmt:message key="common.DOB"/>

          </label>
          <dsp:input width="100" type="text" bean="RegistrationFormHandler.dateOfBirth" size="36">
          </dsp:input>
          
          <dsp:input type="hidden" bean="RegistrationFormHandler.dateFormat"
              value="${dateFormat}"/>
          <span class="example">
            <fmt:message key="common.dateFormatDisplay"/>
          </span>
      </li>

      <li class="atg_store_formElementGroup option">
         <label>
              <dsp:droplet name="IsEmailRecipient">
              <dsp:param name="email" bean="RegistrationFormHandler.value.email"/>
              <dsp:oparam name="true">
                <dsp:input bean="RegistrationFormHandler.previousOptInStatus"
                           type="hidden" value="true"/>
  
                <dsp:getvalueof var="formExceptions" bean="RegistrationFormHandler.formExceptions"/>
                <c:choose>
                  <c:when test="${empty formExceptions}">
                    <dsp:input type="checkbox" bean="RegistrationFormHandler.emailOptIn"
                               checked="true">
                             </dsp:input>
                  </c:when>
                  <c:otherwise>
                    <dsp:input type="checkbox" bean="RegistrationFormHandler.emailOptIn">
                  </dsp:input>
                  </c:otherwise>
                </c:choose>
              </dsp:oparam>
  
              <dsp:oparam name="false">
                <dsp:input bean="RegistrationFormHandler.previousOptInStatus"
                           type="hidden" value="false"/>
  
                <dsp:getvalueof var="formExceptions" bean="RegistrationFormHandler.formExceptions"/>
                <c:choose>
                  <c:when test="${empty formExceptions}">
                    <dsp:input type="checkbox" bean="RegistrationFormHandler.emailOptIn"
                               checked="false"/>
                  </c:when>
                  <c:otherwise>
                    <dsp:input type="checkbox" bean="RegistrationFormHandler.emailOptIn"/>
                  </c:otherwise>
                </c:choose>
              </dsp:oparam>
            </dsp:droplet><%-- End of IsEmailRecipient Droplet--%>
            </label>
            
                    <span>
                      <fmt:message key="common.productPromotionalInfo" />
                        <%-- Link to privacy policy popup --%>
                        <dsp:getvalueof var="contextPath" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
                        <fmt:message var="privacyPolicyTitle" key="common.button.privacyPolicyTitle"/>
                          <dsp:a href="${contextPath}/company/privacyPolicyPopup.jsp"
                         target="popup" title="${privacyPolicyTitle}">
                           <fmt:message key="common.button.privacyPolicyText"/>
                         </dsp:a>
                         </span>
      </li>
    </ul>
    </fieldset>
  
  
      
      <div class="atg_store_formFooter">
        <div class="atg_store_formKey">
          <span class="required">* <fmt:message key="common.requiredFields"/></span>
        </div>
        <div class="atg_store_formActions">
          <fmt:message var="saveProfileText" key="common.button.saveProfileText"/>
          <fmt:message var="saveProfileTitle" key="common.button.saveProfileTitle"/>
          <fmt:message var="cancelText" key="common.button.cancelText"/>
          <fmt:message var="cancelTitle" key="common.button.cancelTitle"/>

          <div class="atg_store_formActionItem">
            <span class="atg_store_basicButton">
              <dsp:input type="submit" 
                         value="${saveProfileText}" title="${saveProfileTitle}"
                         bean="RegistrationFormHandler.update"
                         id="atg_store_profileMyInfoEditSubmit"/>
            </span>
          </div>
          <div class="atg_store_formActionItem">
            <span class="atg_store_basicButton secondary">
              <dsp:input type="submit" 
                         value="${cancelText}" title="${cancelTitle}"
                         bean="RegistrationFormHandler.cancel"
                         id="atg_store_profileMyInfoEditCancel"/>
            </span>
          </div>
        </div>

      </div>
    </dsp:form><%-- End of form --%>
      </div>    
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/profileMyInfoEdit.jsp#2 $$Change: 633752 $--%>
