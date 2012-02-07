<dsp:page>

<%--
  This page for rendering the logic as well as presentation for the account specific payment information details . 

   Parameters:
   - mode - whether Credit Card is being create or edited (allowed values - create/edit)
   - successURL - to redirect to , during the success of updation or creation of new Credit Card Details .
   - cancelURL - to redirect to , during the faliure of updation or creation of new Credit Card Details .
--%>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  
  <%-- Get the mode (create/edit) that this page is invoked with --%>
  <dsp:getvalueof var="paramMode" param="mode"/>

  <%-- Set appropriate title for submit button --%>
  <c:choose>
    <c:when test="${paramMode == 'edit'}">
      <fmt:message var="submitText" key="common.button.saveChanges"/>
    </c:when>
    <c:otherwise>
      <fmt:message var="submitText" key="common.button.saveCardText"/>
    </c:otherwise>
  </c:choose>
  
  <dsp:getvalueof var="savedAddresses" bean="Profile.secondaryAddresses"></dsp:getvalueof>

  <div id="atg_store_paymentInfoAddNewCard" class="${!empty savedAddresses?'atg_store_existingAddresses':''}">    

    <dsp:form formid="atg_store_paymentInfoAddNewCardForm"   
              name="atg_store_paymentInfoAddNewCardForm" 
              action="${pageContext.request.requestURI}" method="post">
      
      <dsp:getvalueof id="originatingRequestURL" bean="/OriginatingRequest.requestURI"/>
      <dsp:getvalueof var="contextPath" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
      
      <c:choose>
        <c:when test="${paramMode == 'edit'}">

          <fieldset class="atg_store_editCreditCard">
                  
            <%-- show form errors for non-checkout pages only, checkout pages display their errors themselves --%>
            <dsp:getvalueof var="isCheckout" vartype="java.lang.Boolean" param="checkout"/>
            <c:if test="${!isCheckout}">
              <div id="atg_store_formValidationError">        
                <dsp:include page="myAccountErrorMessage.jsp">
                  <dsp:param name="formHandler" bean="B2CProfileFormHandler"/>
                  <dsp:param name="submitFieldText" value="${submitText}"/>
                  <dsp:param name="errorMessageClass" value="errorMessage"/>
                </dsp:include>
              </div>
            </c:if>

            <%-- Get edited Card Nickname --%>
            <dsp:getvalueof var="cardNickName" bean="B2CProfileFormHandler.editValue.nickname" 
                            vartype="java.lang.String"/>
          
            <%-- ***** Set success/error url's ***** --%>
            <dsp:getvalueof var="cancelURL" param="cancelURL" vartype="java.lang.String"/>
            <dsp:getvalueof var="successURL" param="successURL" vartype="java.lang.String"/>   
  
            <dsp:input type="hidden" bean="B2CProfileFormHandler.updateCardSuccessURL" paramvalue="successURL"/>
            <dsp:input type="hidden" bean="B2CProfileFormHandler.cancelURL" 
                       value="${cancelURL}?preFillValues=false"/>
            <dsp:input type="hidden" bean="B2CProfileFormHandler.updateCardErrorURL" 
                       value="${originatingRequestURL}?preFillValues=true&cancelURL=${cancelURL}&successURL=${successURL}"/> 
            
            <dsp:getvalueof var="preFillValuesVar" value="true" vartype="java.lang.Boolean"/>
        </c:when>
        <c:otherwise>

          <div class="atg_store_dottedHR"></div>
            
          <fieldset>
          
            <%-- show form errors --%>
            <div id="atg_store_formValidationError">
              <dsp:include page="myAccountErrorMessage.jsp">
                <dsp:param name="formHandler" bean="B2CProfileFormHandler"/>
                <dsp:param name="submitFieldText" value="${submitText}"/>
                <dsp:param name="errorMessageClass" value="errorMessage"/>
              </dsp:include>
            </div>
                    
            <%-- ***** Set success/error url's ***** --%>
            <dsp:input bean="B2CProfileFormHandler.createCardSuccessURL" type="hidden" value="${contextPath}/myaccount/paymentInfo.jsp"/>
            <dsp:input bean="B2CProfileFormHandler.createCardErrorURL" type="hidden" 
                       value="${originatingRequestURL}?preFillValues=true&cancelURL=${cancelURL}"/>
            <dsp:input bean="B2CProfileFormHandler.removeCardSuccessURL" type="hidden" value="${contextPath}/myaccount/paymentInfo.jsp"/>
            <dsp:input bean="B2CProfileFormHandler.removeCardErrorURL" type="hidden"   
                       beanvalue="/OriginatingRequest.requestURI"/>

            <c:choose>
              <c:when test="${empty param.preFillValues}">
                <dsp:getvalueof var="preFillValuesVar" value="false" vartype="java.lang.Boolean"/>
              </c:when>
              <c:otherwise>
                <dsp:getvalueof var="preFillValuesVar" value="${param.preFillValues}" vartype="java.lang.Boolean"/>
              </c:otherwise>
            </c:choose>

        </c:otherwise>
      </c:choose>

     
      <c:choose>
        <c:when test="${paramMode == 'edit'}">
        <%-- ONLY USED IN THE EDIT VERSION OF THIS GADGET --%>
        <dsp:getvalueof var="creditCardNumber" 
            bean="B2CProfileFormHandler.editValue.creditCardNumber" vartype="java.lang.String"/>
        <dsp:getvalueof var="creditCardType" 
            bean="B2CProfileFormHandler.editValue.creditCardType" vartype="java.lang.String"/>

        <ul class="atg_store_basicForm">
            <%-- New nickname --%>          
            <li>
              <label for="atg_store_paymentInfoAddNewCardCreateNickname" class="required atg_store_cardNickName">
                <fmt:message key="common.nicknameThisCard"/>
                <span class="require">*</span>
              </label>
              <dsp:input bean="B2CProfileFormHandler.editValue.nickname" type="hidden"/>
              <dsp:input type="text" bean="B2CProfileFormHandler.editValue.newNickname"
                         id="atg_store_paymentInfoAddNewCardCreateNickname"
                         maxlength="42" iclass="required" required="true"/>
            </li>
            <%-- Credit card number --%>
            <li>
              <label>
                <fmt:message key="common.cardNumber"/>
              </label>
              <span class="atg_store_creditCardNumber">
                <strong><c:out value="${creditCardType}"/></strong>
                <fmt:message key="global_displayCreditCard.endingIn"/>              
                <%-- display only last 4 digits --%>
                <strong><c:out value="${fn:substring(creditCardNumber,fn:length(creditCardNumber)-4,fn:length(creditCardNumber))}"/></strong>
              </span>
            </li>          
            <%-- END EDIT ONLY VERSION --%>
        </c:when>
        <c:otherwise>
          <%-- ONLY USED IN THE CREATE VERSION OF THIS GADGET --%>
          <ul class="atg_store_basicForm atg_store_addNewCreditCard">
            <%-- Credit card nickname --%>
            <li>
              <label for="atg_store_paymentInfoAddNewCardCreateNickname" class="required atg_store_cardNickName">
                <fmt:message key="common.nicknameThisCard"/>
                <span class="require">*</span>
              </label>
              <dsp:input type="text" id="atg_store_paymentInfoAddNewCardCreateNickname"   
                         bean="B2CProfileFormHandler.editValue.creditCardNickname" 
                         maxlength="42" iclass="required" required="true"/>
            </li>
            <%-- Credit card type --%>
            <li class="atg_store_cardType">
              <label for="atg_store_cardType" class="required">
                <fmt:message key="common.cardType"/>
                <span class="require">*</span>
              </label>

              <dsp:select id="atg_store_paymentInfoAddNewCardCardType" 
                          bean="B2CProfileFormHandler.editValue.creditCardType" 
                          required="true" iclass="custom_select">
                <dsp:option value="">
                  <%-- Use an empty value to trip required error handling --%>
                  <fmt:message key="common.chooseCardType"/>
                </dsp:option>
                <dsp:option value="Visa">
                  <fmt:message key="common.visa"/>
                </dsp:option>
                <dsp:option value="MasterCard">
                  <fmt:message key="common.masterCard"/>
                </dsp:option>
                <dsp:option value="AmericanExpress">
                  <fmt:message key="common.americanExpress"/>
                </dsp:option>
                <dsp:option value="Discover">
                  <fmt:message key="common.discover"/>
                </dsp:option>
              </dsp:select>
            </li>
            <%-- Credit card number --%>
            <li class="atg_store_ccNumber">
              <label for="atg_store_cardNumber" class="required">
                <fmt:message key="common.cardNumber"/>
                <span class="require">*</span>
              </label>
              <dsp:input type="text" iclass="required"
                         id="atg_store_paymentInfoAddNewCardCardNumber" 
                         bean="B2CProfileFormHandler.editValue.creditCardNumber" maxlength="16" required="true" autocomplete="off"/>
            </li>
            <%-- END CREATE ONLY VERSION --%>          
        </c:otherwise>
      </c:choose>
      <%-- Expiration date --%>
      <li class="atg_store_expiration">
        <label for="atg_store_expirationDate" class="required">
          <fmt:message key="common.expirationDate"/>
          <span class="require">*</span>
        </label>
        <div class="atg_store_ccExpiration">
	      <dsp:select id="atg_store_paymentInfoAddNewCardMonth"
                      bean="B2CProfileFormHandler.editValue.expirationMonth" 
                      required="true" iclass="number">
            <dsp:option><fmt:message key="common.month"/></dsp:option>
            <dsp:option value="01"><fmt:message key="common.january"/></dsp:option>
            <dsp:option value="02"><fmt:message key="common.february"/></dsp:option>
            <dsp:option value="03"><fmt:message key="common.march"/></dsp:option>
            <dsp:option value="04"><fmt:message key="common.april"/></dsp:option>
            <dsp:option value="05"><fmt:message key="common.may"/></dsp:option>
            <dsp:option value="06"><fmt:message key="common.june"/></dsp:option>
            <dsp:option value="07"><fmt:message key="common.july"/></dsp:option>
            <dsp:option value="08"><fmt:message key="common.august"/></dsp:option>
            <dsp:option value="09"><fmt:message key="common.september"/></dsp:option>
            <dsp:option value="10"><fmt:message key="common.october"/></dsp:option>
            <dsp:option value="11"><fmt:message key="common.november"/></dsp:option>
            <dsp:option value="12"><fmt:message key="common.december"/></dsp:option>
          </dsp:select>
  
          <c:set var="listMode" value="true"/>
          <c:if test="${paramMode == 'edit'}">
            <c:set var="listMode" value="false"/>
          </c:if>
          
          <crs:yearList numberOfYears="16" 
                        bean="/atg/userprofiling/B2CProfileFormHandler.editValue.expirationYear"
                        id="atg_store_paymentInfoAddNewCardYear"
                        selectRequired="true"
                        nodefault="${listMode}" iclass="number"/>
        </div>
      </li>
        
      <%-- Default cart checkbox --%>
      <li class="option">
        <label><dsp:getvalueof var="creditCards" vartype="java.lang.Object" bean="Profile.creditCards"/>
          <dsp:getvalueof var="targetCardKey" vartype="java.lang.String" bean="B2CProfileFormHandler.editCard"/>
          <dsp:getvalueof var="userCards" vartype="java.util.Map" bean="Profile.creditCards"/>
          <dsp:getvalueof var="defaultCardId" vartype="java.lang.String" bean="Profile.defaultCreditCard.id"/>
          <dsp:input type="checkbox" checked="${empty creditCards or (defaultCardId == userCards[targetCardKey].repositoryId)}"
              id="atg_store_paymentInfoAddNewCardCheckbox" bean="B2CProfileFormHandler.editValue.newCreditCard" />
        </label>
        <span><fmt:message key="myaccount_paymentInfoCardAddEdit.defaultCard"/></span>
      </li>

      <c:choose>
        <c:when test="${paramMode == 'create'}">
            </ul>
          </fieldset>

          <div id="atg_store_chooseCardAddress"> 
    
            <%-- Prompt the shopper to select a saved address as Billing Address --%>
            <dsp:include page="creditCardAddressSelect.jsp" flush="true"/>


            <%-- Alternatively, prompt the shopper to provide a new address as Billing Address --%>
            <%-- If user is logged in, then display radio button for them to choose a NEW address rather than
            using an address-book address. --%>
            <div id="atg_store_enterNewBillingAddress">
              <fieldset>
            
                <h3>
                  <fmt:message key="common.newBillingAddress"/>
                </h3>
  
                <ul class="atg_store_basicForm atg_store_addNewAddress">
                  <%-- Billing address nickname --%>
                  <li>
                    <label for="atg_store_paymentInfoAddNewCardAddressNickname" class="required">
                      <fmt:message key="common.nicknameThisAddress"/>
                    </label>
                    <dsp:input type="text" id="atg_store_paymentInfoAddNewCardAddressNickname" 
                               maxlength="42" iclass="text" bean="B2CProfileFormHandler.billAddrValue.shippingAddrNickname" />
                  </li>
                  <dsp:getvalueof id="chkForRequired" value="false"/>
                </c:when>
                <c:otherwise>
                  </ul>
                  <h3>
                    <fmt:message key="myaccount_paymentInfoCardAddEdit.billingAddress"/>
                  </h3>
                    <ul class="atg_store_basicForm">      
                  <dsp:getvalueof id="chkForRequired" value="true"/>
                </c:otherwise>
              </c:choose>

              <dsp:include page="/global/gadgets/addressAddEdit.jsp">
                <dsp:param name="formhandlerComponent" value="/atg/userprofiling/B2CProfileFormHandler.billAddrValue"/>
                <dsp:param name="checkForRequiredFields" value="${chkForRequired}"/>
                <dsp:param name="restrictionDroplet" value="/atg/store/droplet/BillingRestrictionsDroplet"/>
                <dsp:param name="hideNameFields" value="false"/>
                <dsp:param name="preFillValues" value="${preFillValuesVar}"/>
              </dsp:include>
            </ul>
          </fieldset>
          <c:if test="${paramMode == 'create'}">
            <div class="atg_store_saveNewBillingAddress">
              <span class="atg_store_basicButton">
                <dsp:input type="submit" value="${submitText}" id="atg_store_paymentInfoAddNewCardAndAddressSubmit"
                           bean="B2CProfileFormHandler.createNewCreditCardAndAddress"/>
              </span>   
              <p><fmt:message key="common.using" />&nbsp;<span><fmt:message key="myaccount_paymentInfoCardAddEdit.newBillingAddress" /></span></p>
            </div>
        </div><%--atg_store_enterNewBillingAddress --%>
          </c:if>        
      
      <div class="atg_store_formActions">
        <div class="atg_store_formKey">
          <span class="required">* <fmt:message key="common.requiredFields"/></span>
        </div>


          <fmt:message var="cancelButtonText" key="common.button.cancelText" />
          <fmt:message var="cancelButtonTitle" key="common.button.cancelTitle" />
    
          <c:choose>
            <c:when test="${paramMode == 'edit'}">
              <%-- ONLY USED IN THE EDIT VERSION OF THIS GADGET --%>
                          <%-- Edit Cart Cancal button --%>          
                                  <div class="atg_store_formActionItem">
                            <span class="atg_store_basicButton">
                              <dsp:input type="submit" value="${submitText}" id="atg_store_editAddressSubmit"
                                         bean="B2CProfileFormHandler.updateCard"/>
                            </span>
                         </div>
              <%-- Edit Cart Save button --%>
                      <div class="atg_store_formActionItem">
                <span class="atg_store_basicButton secondary">
                  <dsp:input type="submit"  title="${cancelButtonTitle}" value="${cancelButtonText}"
                            id="atg_store_paymentInfoAddNewCardCancel" bean="B2CProfileFormHandler.cancel"/>
                </span>
              </div>
  
              <%-- END EDIT ONLY VERSION --%>
            </c:when>
            <c:otherwise>
              <%-- ONLY USED IN THE CREATE VERSION OF THIS GADGET --%>
              <%-- Create New Card Cancel button --%>
              <dsp:a href="${contextPath}/myaccount/paymentInfo.jsp" iclass="atg_store_basicButton secondary">
                <span><fmt:message key="common.button.cancelText"/></span>
              </dsp:a>              
              <%-- END CREATE ONLY VERSION --%>
            </c:otherwise>
          </c:choose>
              </div>
  <c:if test="${paramMode == 'create'}">
    </div><%-- atg_store_chooseCardAddress --%>
  </c:if>        
    </dsp:form>
  </div><%-- atg_store_paymentInfoAddNewCard --%>  
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/paymentInfoCardAddEdit.jsp#2 $$Change: 633752 $--%>
