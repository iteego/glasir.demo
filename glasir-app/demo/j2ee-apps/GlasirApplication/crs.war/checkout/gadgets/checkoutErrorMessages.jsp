<dsp:page>

  <%-- This page expects the following parameters:
       -  formhandler - The form handler whose errors we display
       -  divid (optional) - A different div id to wrap the error in
       -  submitFieldText (optional) - Text on the "commit" field which is added to the message
                                       shown for missing required data after the work "click "
                                       (for example, "click Save")

       Form Condition:
       - This gadget must be contained inside of more than one forms.
         Following Formhandlers must be invoked from a submit
         button in one of the forms for fields in this page to be processed :
         - BillingFormHandler
         - CartFormHandler
         - CommitOrderFormHandler
         - ShippingGroupFormHandler
  --%>


  <dsp:importbean bean="/atg/store/profile/RequestBean"/>

  <dsp:getvalueof var="defaultError" vartype="java.lang.String" value="false" scope="request"/>
  <dsp:getvalueof var="formExceptions" vartype="java.lang.Object" param="formhandler.formExceptions"/> 
  <dsp:getvalueof id="divid" param="divid"/>
  <dsp:getvalueof id="submitFieldText" param="submitFieldText"/>

  <c:if test="${empty divid}">
    <c:set var="divid" value="atg_store_formValidationError"/>
  </c:if>


  <c:if test="${empty submitFieldText}">
    <fmt:message var="submitFieldText" key="common.button.continueCheckoutText"/>
  </c:if>

  <c:if test="${not empty formExceptions}">
    <div id="${divid}">
      <c:forEach var="formException" items="${formExceptions}">
        <dsp:param name="formException" value="${formException}"/>
        <%-- Check the error message code to see what we should do --%>
        <dsp:getvalueof var="errorCode" vartype="java.lang.String" param="formException.errorCode"/>
  
        <c:choose>
          <c:when test='${errorCode == "missingRequiredValue" || errorCode == "missingRequiredAddressProperty"}'>
            <dsp:getvalueof var="missReqValue" vartype="java.lang.String" bean="RequestBean.values.miss_req_value"/>
  
            <c:choose>
              <c:when test='${missReqValue == "true"}'>
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
            </c:choose>
          </c:when>
          <c:otherwise>
            <dsp:getvalueof var="defaultError" vartype="java.lang.String" value="true" scope="request"/>
            <div class="errorMessage">
              <dsp:valueof param="formException.message" valueishtml="true">
                <fmt:message key="common.errorMessageDefault" />
              </dsp:valueof>
            </div>
          </c:otherwise>
        </c:choose>
      </c:forEach>
    </div>
  </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/checkoutErrorMessages.jsp#1 $$Change: 633540 $--%>
