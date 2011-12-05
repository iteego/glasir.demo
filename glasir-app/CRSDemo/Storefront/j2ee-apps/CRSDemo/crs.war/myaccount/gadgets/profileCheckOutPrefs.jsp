<dsp:page>

  <%--
    This page fragment renders Profile's checkout preferences: default shipping method, default credit card,
    default shipping address.
  --%>
  
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/store/profile/ProfileCheckoutPreferences"/>
  
  <div class="atg_store_checkoutPrefsContainer">
    <div id="atg_store_checkoutPrefs">
      <h2 class="atg_store_subHeadCustom">
        <fmt:message key="common.expressCheckoutPreferences"/>
      </h2>
    
      <ul>
        <li>
          <div class="atg_store_curentPref">
            <span class="atg_store_label"><fmt:message key="common.defaultShippingMethod"/></span>
            <span class="atg_store_myProfileText">
              <dsp:getvalueof var="defaultCarrier" vartype="java.lang.String" bean="Profile.defaultCarrier"/>
              <c:choose>
                <c:when test="${not empty defaultCarrier}">
                  <fmt:message key="checkout_shipping.delivery${fn:replace(defaultCarrier, ' ', '')}"/>
                </c:when>
                <c:otherwise>
                  <fmt:message key="common.notSpecified"/>
                </c:otherwise>
              </c:choose>
            </span>
          </div>
        </li>
        <li>
          <div class="atg_store_curentPref">
            <span class="atg_store_label"><fmt:message key="common.defaultShippingAddress"/></span>
            <span class="atg_store_myProfileText">
              <%-- Display Default Address Nickname--%>
              <dsp:getvalueof var="profileShippingAddress" bean="Profile.shippingAddress"/>
              <c:choose>
                <c:when test="${not empty profileShippingAddress}">
                  <dsp:getvalueof var="shippingAddress" bean="ProfileCheckoutPreferences.defaultShippingAddressNickname"/>
                  <c:choose>
                    <c:when test="${fn:length(shippingAddress) > 26}">
                      <c:out value="${fn:substring(shippingAddress,0,26)}..."/>
                    </c:when>
                    <c:otherwise>
                      <c:out value="${shippingAddress}"/>
                    </c:otherwise>
                  </c:choose>
                </c:when>
                <c:otherwise>
                  <fmt:message key="common.notSpecified"/>
                </c:otherwise>
              </c:choose>
            </span>
          </div>
        </li>
        <li>
          <div class="atg_store_curentPref">
            <span class="atg_store_label"><fmt:message key="common.defaultCreditCard"/></span>
            <span class="atg_store_myProfileText">
              <%-- Display Default Credit Card Nickname--%>
              <dsp:getvalueof var="profileDefaultCreditCard" bean="Profile.defaultCreditCard"/>
              <c:choose>
                <c:when test="${not empty profileDefaultCreditCard}">
                  <dsp:valueof bean="ProfileCheckoutPreferences.defaultCreditCardNickname"/>
                  <fmt:message key="common.textSeparator"/>
                  <dsp:getvalueof var="creditCardNumber" bean="Profile.defaultCreditCard.creditCardNumber" />
                  <c:out value="${fn:substring(creditCardNumber,fn:length(creditCardNumber)-4,fn:length(creditCardNumber))}"/>
                </c:when>
                <c:otherwise>
                  <fmt:message key="common.notSpecified"/>
                </c:otherwise>
              </c:choose>
            </span>
          </div>
        </li>
      </ul>
      <div class="atg_store_formActions">
        <a href="profileDefaults.jsp" class="atg_store_basicButton atg_store_prefEdit">
         <span><fmt:message key="common.button.editText"/></span>
        </a>
      </div>   
    </div>
  </div>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/profileCheckOutPrefs.jsp#2 $$Change: 635969 $--%>
