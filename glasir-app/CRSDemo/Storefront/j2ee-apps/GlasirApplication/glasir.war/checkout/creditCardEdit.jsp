<%-- This page renders the form that allows a shopper to edit a saved credit card --%>

<dsp:page>
  <crs:pageContainer divId="atg_store_cart" 
                     index="false" 
                     follow="false"
                     bodyClass="atg_store_checkout atg_store_editCreditCard atg_store_rightCol">
    <jsp:body>
      <fmt:message key="checkout_title.checkout" var="title"/>
      <crs:checkoutContainer currentStage="billing"
                             showOrderSummary="true" 
                             title="${title}">
        <jsp:attribute name="formErrorsRenderer">
          <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
          <fmt:message var="submitText" key="common.button.saveChanges"/>
          <div id="atg_store_formValidationError">
            <dsp:include page="/myaccount/gadgets/myAccountErrorMessage.jsp">
              <dsp:param name="formHandler" bean="B2CProfileFormHandler"/>
              <dsp:param name="submitFieldText" value="${submitText}"/>
              <dsp:param name="errorMessageClass" value="errorMessage"/>
            </dsp:include>
          </div>
        </jsp:attribute>
        <jsp:body>
          <div id="atg_store_checkout" class="atg_store_main">
            <div class="atg_store_checkoutOption">
              <fieldset>
                <ol>
                  <dsp:include page="/myaccount/gadgets/paymentInfoCardAddEdit.jsp">
                    <dsp:param name="mode" value="edit"/>
                    <dsp:param name="successURL" value="billing.jsp"/>
                    <dsp:param name="cancelURL" value="billing.jsp"/>
                    <dsp:param name="checkout" value="true"/>
                  </dsp:include>
                </ol>
              </fieldset>
            </div>
          </div>
        </jsp:body>
      </crs:checkoutContainer>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/creditCardEdit.jsp#2 $$Change: 635969 $--%>
