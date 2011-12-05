<dsp:page>
<div id="atg_store_storedCreditCards">
  <%--
      This gadget lists the user's saved credit cards as options on the billing page

      Form Condition:
      - This gadget must be contained inside of a form.
        BillingFormHandler must be invoked from a submit
        button in this form for fields in this page to be processed.        
  --%>

  <dsp:importbean bean="/atg/commerce/util/MapToArrayDefaultFirst"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler" />
  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler"/>
  
  <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>
  
  <%-- Check if the profile has credit cards and show them --%>
  <dsp:getvalueof var="creditCards" vartype="java.lang.Object" bean="Profile.creditCards"/>
  <c:if test="${not empty creditCards}">

        <dsp:droplet name="MapToArrayDefaultFirst">
          <dsp:param name="map" bean="Profile.creditCards"/>
          <dsp:param name="defaultId" bean="Profile.defaultCreditCard.repositoryId"/>
          <dsp:param name="sortByKeys" value="true"/>
          <dsp:oparam name="output">
            
            <dsp:getvalueof var="sortedArray" vartype="java.lang.Object" param="sortedArray"/>
            <c:if test="${not empty sortedArray}">
              
                <c:forEach var="userCard" items="${sortedArray}">
                  <dsp:param name="userCard" value="${userCard}"/>
                  <c:if test="${not empty userCard }">
                    <div class="atg_store_paymentInfoGroup">
                      <dl> 
        
                        <dsp:droplet name="Compare">
                          <dsp:param name="obj1" bean="Profile.defaultCreditCard.repositoryId"/>
                          <dsp:param name="obj2" param="userCard.value.id"/>
                          <dsp:oparam name="equal">
                            <dt class="atg_store_defaultCreditCard">
                            <dsp:input type="radio" paramvalue="userCard.key"
                              id="atg_store_savedAddressesHome"
                              bean="BillingFormHandler.storedCreditCardName"/>
                            <dsp:valueof param="userCard.key"/>
                            <span><fmt:message key="common.default"/></span>
                            </dt>
                          </dsp:oparam>
                          <dsp:oparam name="default">
                           <dt>
                           <dsp:input type="radio" paramvalue="userCard.key"
                             id="atg_store_savedAddressesHome"
                             bean="BillingFormHandler.storedCreditCardName"/>
                            <dsp:valueof param="userCard.key"/>
                          </dt>
                          </dsp:oparam>
                        </dsp:droplet>  
                      
                        <dsp:include page="creditCardRenderer.jsp">
                          <dsp:param name="creditCard" param="userCard.value"/>
                        </dsp:include>
                                 <ul class="atg_store_storedCreditCardsActions">  
                                    <li class="last">
                                      <fmt:message var="editCardTitle" key="common.button.editCardTitle" />
                                      <dsp:a bean="B2CProfileFormHandler.editCard" page="../creditCardEdit.jsp" paramvalue="userCard.key" title="${editCardTitle}">
                                        <fmt:message key="checkout_billing.Edit" />
                                      </dsp:a>
                                    </li>
                                    </ul>
                      </dl>               
                    </div>
                  </c:if>
                </c:forEach>
              </div>
              <div class="atg_store_billingEnterCardCSV">
              <ul class="atg_store_basicForm">
                <label><fmt:message key="checkout_billing.securityCode"/></label>
                
                <dsp:input bean="BillingFormHandler.creditCardVerificationNumber" value="" type="text"
                  iclass="required" id="atg_store_verificationNumberInput" autocomplete="off">
                  <dsp:tagAttribute name="dojoType" value="atg.store.widget.enterSubmit" />
                    <dsp:tagAttribute name="targetButton" value="atg_store_continueButton" />
                    </dsp:input>
                     <fmt:message var="whatisThisTitle" key="checkout_billing.whatIsThis"/></li>
                  </ul>
                <a href="${contextroot}/checkout/whatsThisPopup.jsp" title="${whatisThisTitle}" class="atg_store_help" target="popup">
                  ${whatisThisTitle}
                </a>
                <div class="atg_store_formActions">
                <span class="atg_store_basicButton tertiary">
                  <fmt:message key="common.button.continueText" var="submitText"/>
                  <dsp:input type="submit" value="${submitText}" id="atg_store_continueButton" bean="BillingFormHandler.billingWithSavedCard" />
                </span>  
                <span class="atg_store_buttonMessage"><fmt:message key="checkout_billing.usingCreditCard" /></span>
              </div>
              </div>
            </c:if>

          </dsp:oparam>
        </dsp:droplet> <%-- MapToArrayDefaultFirst (sort saved credit cards) --%>
  </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/savedCreditCards.jsp#2 $$Change: 633752 $--%>
