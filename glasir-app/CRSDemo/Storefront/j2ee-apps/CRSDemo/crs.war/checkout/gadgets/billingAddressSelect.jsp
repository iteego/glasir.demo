<%--
  This gadget lists the user's saved billing addresses as options when adding a new credit card during
  the checkout process

  Form Condition:
  - This gadget must be contained inside of a form.
    BillingFormHandler must be invoked from a submit
    button in this form for fields in this page to be processed
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/util/MapToArrayDefaultFirst"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/atg/store/droplet/BillingRestrictionsDroplet"/>

  <%-- Check if the profile has secondary addresses and show them --%>
  <dsp:getvalueof var="secondaryAddresses" vartype="java.lang.Object" bean="Profile.secondaryAddresses"/>

  <c:choose>
    <c:when test="${not empty secondaryAddresses}">
      <fmt:message var="savedAddressesOption" key="checkout_billing.savedAddresses"/>

      <%-- They have secondary addresses, check their security status --%>

          <%-- List the user's saved billing addresses as options when adding a new --%>
          <%-- credit card during the checkout process                              --%>
          <dsp:droplet name="MapToArrayDefaultFirst">
            <dsp:param name="map" bean="Profile.secondaryAddresses"/>
            <dsp:param name="defaultId" bean="Profile.shippingAddress.repositoryId"/>
            <dsp:param name="sortByKeys" value="true"/>
            <dsp:oparam name="output">
              <dsp:getvalueof var="sortedArray" vartype="java.lang.Object" param="sortedArray"/>

              <%-- List of available billing addresses with details info --%>
              <c:choose>
                <c:when test="${not empty sortedArray}">
                  <dsp:getvalueof var="contextRoot" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
                  <dsp:getvalueof var="successURL" vartype="java.lang.String" value="${contextRoot}/checkout/billing.jsp"/>
                  
                      
                      <div id="atg_store_savedAddresses">
                          <%-- List of available billing addresses --%>
                          <c:forEach var="billingAddress" items="${sortedArray}">
                            <dsp:param name="billingAddress" value="${billingAddress}"/>
                            <c:if test="${not empty billingAddress }">
                              <%-- Sort out addresses we can't serve --%>
                              <dsp:droplet name="BillingRestrictionsDroplet">
                                <dsp:param name="countryCode" param="billingAddress.value.country"/>
                                <dsp:oparam name="true"/>
                                <dsp:oparam name="false">
                                  <%-- No restrictions, display address --%>
                                  <div class="atg_store_addressGroup">
                                  <dl class="atg_store_billingAddresses atg_store_savedAddresses">
                                    <dt>
                                    <dsp:param name="billingAddress" value="${billingAddress}"/>
                                    <dsp:getvalueof var="storedAddressSelection" vartype="java.lang.String" bean="BillingFormHandler.storedAddressSelection"/>
                                    <dsp:input type="radio" name="address" value="${billingAddress.key}"
                                               id="${billingAddress.value.repositoryId}"
                                               checked="${billingAddress.key == storedAddressSelection}"
                                               bean="BillingFormHandler.storedAddressSelection"/>
                                    <%-- Address nickname --%>
                                    <label for="${billingAddress.value.repositoryId}">
                                      <dsp:valueof param="billingAddress.key"/>
                                    </label>
                                    </dt>
                                    <%-- Address info --%>
                                    <dd class="atg_store_addressSelect">
                                    <dsp:include page="/global/util/displayAddress.jsp">
                                      <dsp:param name="address" param="billingAddress.value"/>
                                      <dsp:param name="private" value="false"/>
                                    </dsp:include>
                                  </dd>
                                    <%-- Link to edit address --%>
                                    <dd class="atg_store_storedAddressActions">
                                    <ul>
                                    <li>
                                    <dsp:a bean="B2CProfileFormHandler.editAddress" page="../billingAddressEdit.jsp" paramvalue="billingAddress.key">
                                      <dsp:param name="nickName" param="billingAddress.key"/>
                                      <dsp:param name="successURL" value="${successURL}"/>
                                      <fmt:message key="checkout_billing.Edit"/>
                                    </dsp:a>
                                    </li>
                                    <li class="last">
                                    <%-- Link to remove address --%>
                                    <fmt:message var="removeAddressTitle" key="common.button.deleteTitle"/>
                                    <dsp:getvalueof id="requestURL" idtype="java.lang.String" bean="/OriginatingRequest.requestURI"/>
                                    <dsp:a title="${removeAddressTitle}"
                                      bean="B2CProfileFormHandler.removeAddress"
                                      href="${requestURL}" paramvalue="billingAddress.key">
                                      <span><fmt:message key="common.button.deleteText"/></span>
                                    </dsp:a>
                                    </li>
                                    </ul>
                                    </dd>
                                  </dl>
                                </div>
                                </dsp:oparam>
                              </dsp:droplet>
                            </c:if>
                          </c:forEach>
                      </div>
              
                </c:when>
                <c:otherwise>
                      <label for="atg_store_addressOption">
                        <fmt:message key="checkout_shipping.selectAddress"/><fmt:message key="common.labelSeparator"/>
                      </label>
                      <dsp:select id="addressId"
                                  name="addressOptions"
                                  bean="BillingFormHandler.storedAddressSelection"/>
                </c:otherwise>
              </c:choose>
            </dsp:oparam>
          </dsp:droplet> <%-- MapToArrayDefaultFirst --%>
    </c:when>
    <c:otherwise>
      <select id="atg_store_addressOption">
      </select>
    </c:otherwise>
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/billingAddressSelect.jsp#2 $$Change: 633752 $--%>
