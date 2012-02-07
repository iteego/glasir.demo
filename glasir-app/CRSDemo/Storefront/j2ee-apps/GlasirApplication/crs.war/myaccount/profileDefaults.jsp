<dsp:page>

<%-- 
      Displayes preferences for express checkout.
      Includes gadget myAccountMenu to renderer Menu of My Account.
--%>

  <dsp:importbean bean="/atg/store/profile/RegistrationFormHandler"/>
  <dsp:importbean bean="/atg/commerce/pricing/AvailableShippingMethods"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <crs:pageContainer divId="atg_store_accountEditProfileIntro" 
                     index="false" follow="false"
                     bodyClass="atg_store_myAccountPage atg_store_leftCol">    
    <jsp:body>
    <div class="atg_store_nonCatHero">
      <h2 class="title"><fmt:message key="common.expressCheckoutPreferences"/></h2>
    </div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="MY PROFILE" />
      </dsp:include>
      <div class="atg_store_main atg_store_myAccount">

        <%-- Display error messages on the page --%>
        <dsp:include page="./gadgets/myAccountErrorMessage.jsp">
          <dsp:param name="formHandler" bean="RegistrationFormHandler"/>
          <dsp:param name="errorMessageClass" value="errorMessage"/>
        </dsp:include>
        
        <%-- Collect required 'Checkout Defaults' properties --%>
        <dsp:form action="profileDefaults.jsp" method="post">
          <ul class="atg_store_basicForm atg_store_chooseDefaults">
            <%-- Default shipping method --%>
            <li>
              <label><fmt:message key="myAccount.checkoutDefaults.shippingMethod"/></label>
              <dsp:select bean="RegistrationFormHandler.value.defaultCarrier">
                <dsp:droplet name="AvailableShippingMethods">
                  <dsp:param name="shippingGroup" bean="ShoppingCart.current.shippingGroups[0]"/>
                  <dsp:oparam name="output">
                    <dsp:getvalueof var="availableShippingMethods" vartype="java.lang.Object" param="availableShippingMethods"/>
                    <dsp:getvalueof var="defaultShippingMethod" vartype="java.lang.String" bean="Profile.defaultCarrier"/>
                    <option value="" selected="${empty defaultShippingMethod}">
                      <fmt:message key="myaccount_profileMyInfoEdit.selectDefaultShipping"/>
                    </option>
                    <c:forEach var="availableShippingMethod" items="${availableShippingMethods}">
                      <dsp:option value="${availableShippingMethod}" selected="${defaultShippingMethod == availableShippingMethod}">
                        <fmt:message key="checkout_shipping.delivery${fn:replace(availableShippingMethod, ' ', '')}"/>
                      </dsp:option>
                    </c:forEach>
                  </dsp:oparam>
                </dsp:droplet>
              </dsp:select>
            </li>
            <%-- Default shipping address --%>
            <li>
              <label><fmt:message key="myAccount.checkoutDefaults.shippingAddress"/></label>
              <dsp:select bean="RegistrationFormHandler.value.shippingAddress">
                <dsp:getvalueof var="secondaryAddresses" vartype="java.util.Map" bean="Profile.secondaryAddresses"/>
                <dsp:getvalueof var="defaultAddress" vartype="java.lang.String" bean="Profile.shippingAddress.repositoryId"/>
                <option value="" selected="${empty defaultAddress}">
                  <c:choose>
                    <c:when test="${fn:length(secondaryAddresses) == 0}">
                      <fmt:message key="myaccount_profileMyInfoEdit.noneAvailable"/>
                    </c:when>
                    <c:otherwise>
                      <fmt:message key="myaccount_profileMyInfoEdit.selectDefaultAddress"/>
                    </c:otherwise>
                  </c:choose>
                </option>
                <c:forEach var="address" items="${secondaryAddresses}">
                  <dsp:option value="${address.key}" selected="${defaultAddress == address.value.repositoryId}">
                    ${address.key}
                  </dsp:option>
                </c:forEach>
              </dsp:select>
              <dsp:a page="accountAddressEdit.jsp">
                <dsp:param name="addEditMode" value="add"/>
                <dsp:param name="successURL" value="addressBook.jsp"/>
                <fmt:message key="myAccount.checkoutDefaults.addAddress"/>
              </dsp:a>
            </li>
            <%-- Default credit card --%>
            <li>
              <label><fmt:message key="myAccount.checkoutDefaults.creditCard"/></label>
              <dsp:select bean="RegistrationFormHandler.value.defaultCreditCard">
                <dsp:getvalueof var="creditCards" vartype="java.lang.Map" bean="Profile.creditCards"/>
                <dsp:getvalueof var="defaultCard" vartype="java.lang.String" bean="Profile.defaultCreditCard.repositoryId"/>
                <option value="" selected="${empty defaultCard}">
                  <c:choose>
                    <c:when test="${fn:length(creditCards) == 0}">
                      <fmt:message key="myaccount_profileMyInfoEdit.noneAvailable"/>
                    </c:when>
                    <c:otherwise>
                      <fmt:message key="myaccount_profileMyInfoEdit.selectDefaultCard"/>
                    </c:otherwise>
                  </c:choose>
                </option>
                <c:forEach var="card" items="${creditCards}">
                  <dsp:param name="creditCard" value="${card}"/>
                  <%-- get last 4 digits of credit card number --%>
                  <dsp:getvalueof var="creditCardNumber" param="creditCard.value.creditCardNumber" />
                  <c:set var="creditCardNumber" value="${fn:substring(creditCardNumber,fn:length(creditCardNumber)-4,fn:length(creditCardNumber))}" />
                                                      
                  <dsp:option value="${card.key}" selected="${defaultCard == card.value.repositoryId}">
                    ${card.key}
                    <fmt:message key="common.textSeparator"/>
                    ${creditCardNumber}
                  </dsp:option>
                </c:forEach>
              </dsp:select>
              <dsp:a href="newCreditCard.jsp">
                <fmt:message key="myAccount.checkoutDefaults.addCreditCard"/>
              </dsp:a>
            </li>
          </ul>
          
          <%-- Action buttons --%>
          <dsp:input bean="RegistrationFormHandler.updateSuccessURL" value="profile.jsp" type="hidden"/>
          <div class="atg_store_formActions">
            <div class="atg_store_formActionItem">
            <span class="atg_store_basicButton">
              <fmt:message key="common.button.saveChanges" var="saveButtonCaption"/>
              <dsp:input type="submit" value="${saveButtonCaption}" bean="RegistrationFormHandler.checkoutDefaults"/>
            </span>
            </div>
             <div class="atg_store_formActionItem">
               <dsp:a iclass="atg_store_basicButton secondary" href="profile.jsp">
                 <span><fmt:message key="common.button.cancelText"/></span>
               </dsp:a>
             </div>
          </div>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/profileDefaults.jsp#2 $$Change: 635969 $--%>