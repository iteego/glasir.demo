<dsp:page>

  <%--
      This page is specifically meant for handling the tasks of emailAFriendErrorMessage.jsp
        and giftListValidationMsg.jsp 
      This page expects the following parameters:
       1. formHandler  -  The form handler whose errors we display
       2. submitFieldKey  -  The value for the text to be enscribed on submit button
       
       Form Condition:
       - This gadget must be contained inside of more than one forms.
         Following Formhandlers must be invoked from a submit 
         button in one of the forms for fields in this page to be processed :
         - GiftlistSearch
         - EmailAFriendFormHandler
  --%>

  <dsp:importbean bean="/atg/store/profile/RequestBean"/>


  <dsp:getvalueof id="formHandler" param="formHandler"/>
  
  <%-- Usually using ErrorMessageForEach droplet is a nice shortcut to get the 
       error messages.  In this case we need to weed out specific error messages 
       because we share a page with another form.
       
       CRS Fashion only wants to display a single error in cases where one or 
       more required properties have been omitted from the form.  To handle this 
       case we use the RequestBean to store page values useful only for this request.  
  --%> 
  <dsp:getvalueof id="submitFieldKey" param="submitFieldKey"/>

  <dsp:getvalueof var="formExceptions" vartype="java.lang.Object" param="formHandler.formExceptions"/>
  <c:if test="${not empty formExceptions}">
    <div id="atg_store_formValidationError">
      <c:forEach var="formException" items="${formExceptions}">
        <dsp:param name="formException" value="${formException}"/>
        <%-- Check the error message code to see what we should do --%>
        <dsp:getvalueof var="errorCode" param="formException.errorCode"/>
        <c:choose>

          <c:when test="${errorCode == 'missingRequiredValue'}">
            <dsp:getvalueof var="miss_req_value" bean="RequestBean.values.miss_req_value"/>
            <c:choose>
              <c:when test="${miss_req_value == 'true'}">
                <%-- We've already spoken for missing values --%>
              </c:when>
              <c:otherwise>
                <%-- Show the default message when an error is made --%>
                <fmt:message var="submitFieldText" key="${submitFieldKey}"/>
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

          <c:when test="${errorCode == 'missingRequiredAddressProperty'}">
            <dsp:getvalueof var="miss_req_value" bean="RequestBean.values.miss_req_value"/>
            <c:choose>
              <c:when test="${miss_req_value == 'true'}">
                <%-- We've already spoken for missing values --%>
              </c:when>
              <c:otherwise>
                <%-- Show the default message when an error is made --%>
                  <fmt:message var="submitFieldText" key="common.button.continueCheckoutText"/>
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
                <fmt:message key="common.errorMessageDefault"/>
              </dsp:valueof>
            </div>
          </c:otherwise>
        </c:choose><%-- End c:choose on error type --%>
      </c:forEach><%-- End For Each error --%>
    </div>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/displayErrorMessage.jsp#1 $$Change: 633540 $--%>
