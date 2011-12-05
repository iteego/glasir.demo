<dsp:page>

  <%--
      This page renders all stored addresses for a registered user
      Form Condition:
      - This gadget must be contained inside of a form.
        B2CProfileFormHandler must be invoked from a submit
        button in this form for fields in this page to be processed
  --%>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/util/MapToArrayDefaultFirst"/>

  <%-- Iterate through all this user's shipping addresses, sorting the array so that the
       default shipping address is first. --%>
  <dsp:droplet name="MapToArrayDefaultFirst">
    <dsp:param name="map" bean="Profile.secondaryAddresses"/>
    <dsp:param name="defaultId" bean="Profile.shippingAddress.repositoryId"/>
    <dsp:oparam name="output">
      <dsp:getvalueof var="sortedArray" vartype="java.lang.Object" param="sortedArray"/>
      <c:if test="${not empty sortedArray}">        
  
          <c:set var="counter" value="0"/>
        <div id="atg_store_selectAddress"> 
          <fieldset class="atg_store_chooseBillingAddresses">
          <h3><fmt:message key="common.useSavedAddressAsBillingAddress"/></h3>
        
          <div id="atg_store_savedAddresses">
            <dsp:getvalueof var="defaultAddressId" vartype="java.lang.String" bean="Profile.shippingAddress.repositoryId"/>
            <c:forEach var="shippingAddress" items="${sortedArray}" varStatus="status">
              <dsp:param name="shippingAddress" value="${shippingAddress}"/>
              <c:if test="${not empty shippingAddress}">
                <c:set var="count" value="0"/>
                <%-- BillingRestrictionsDroplet is used below to disable radio buttons for the case where
                     shippable addresses are restricted for billing --%>
                <div class="atg_store_addressGroup">
                  <c:set var="counter" value="${counter + 1}"/>
                  <dl class="atg_store_savedAddresses">
                    <dt>
                      <dsp:getvalueof var="addressKey" vartype="java.util.String" param="shippingAddress.key"/>
  
                      <dsp:droplet name="Compare">
                        <dsp:param name="obj1" bean="Profile.shippingAddress.repositoryId"/>
                        <dsp:param name="obj2" param="shippingAddress.value.id"/>
  
                        <dsp:oparam name="equal">
                          <dsp:droplet name="/atg/store/droplet/BillingRestrictionsDroplet">
                            <dsp:param name="countryCode" param="shippingAddress.value.country"/>
                            <dsp:oparam name="true">
                              <dsp:input type="radio" name="address" paramvalue="shippingAddress.key"
                                         id="${shippingAddress.value.repositoryId}" disabled="true"
                                         bean="B2CProfileFormHandler.billAddrValue.newNickname"/>
                            </dsp:oparam>
                            <dsp:oparam name="false">
                              <dsp:input type="radio" name="address" paramvalue="shippingAddress.key"
                                         id="${shippingAddress.value.repositoryId}" checked="true"
                                         bean="B2CProfileFormHandler.billAddrValue.newNickname"/>
                            </dsp:oparam>
                          </dsp:droplet>
                        </dsp:oparam>
  
                        <dsp:oparam name="default">
                          <dsp:droplet name="/atg/store/droplet/BillingRestrictionsDroplet">
                            <dsp:param name="countryCode" param="shippingAddress.value.country"/>
                            <dsp:oparam name="true">
                              <dsp:input type="radio" name="address" paramvalue="shippingAddress.key"
                                         id="${shippingAddress.value.repositoryId}" disabled="true"
                                         bean="B2CProfileFormHandler.billAddrValue.newNickname"/>
                            </dsp:oparam>
                            <dsp:oparam name="false">
                              <dsp:input type="radio" name="address" paramvalue="shippingAddress.key"
                                         id="${shippingAddress.value.repositoryId}" checked="${status.index == 0 and empty defaultAddressId}"
                                         bean="B2CProfileFormHandler.billAddrValue.newNickname"/>
                            </dsp:oparam>
                          </dsp:droplet>
                        </dsp:oparam>
  
                      </dsp:droplet>
  
                      <%-- Display Address Details --%>
                      <label for="${shippingAddress.value.repositoryId}">
                        <dsp:valueof param="shippingAddress.key"/>
                      </label>
                    </dt>
                    <dd class="atg_store_addressSelect">                
  
                      <dsp:include page="/global/util/displayAddress.jsp" flush="false">
                        <dsp:param name="address" param="shippingAddress.value"/>
                        <dsp:param name="private" value="false"/>
                      </dsp:include>
                    </dd>
                    <%-- Display Edit/Remove Links --%>
                    <dd class="atg_store_storedAddressActions">
                      <ul>
                        <fmt:message var="editAddressTitle" key="common.button.editAddressTitle"/>
                        <li class="<crs:listClass count="1" size="2" selected="false"/>">
                          <dsp:a title="${editAddressTitle}"
                                 bean="B2CProfileFormHandler.editAddress"
                                 page="/myaccount/accountAddressEdit.jsp" paramvalue="shippingAddress.key">
                            <dsp:param name="successURL" bean="/OriginatingRequest.requestURI"/>
                            <dsp:param name="addEditMode" value="edit"/>
                            <span><fmt:message key="common.button.editAddressText"/></span>
                          </dsp:a>
                        </li>
                        
                        <fmt:message var="removeAddressTitle" key="myaccount_addressBookDefault.button.removeAddressTitle"/>
                        <dsp:getvalueof id="requestURL" idtype="java.lang.String" bean="/OriginatingRequest.requestURI"/>
                        <li class="<crs:listClass count="2" size="2" selected="false"/>">
                          <dsp:a title="${removeAddressTitle}"
                                 bean="B2CProfileFormHandler.removeAddress"
                                 href="${requestURL}" paramvalue="shippingAddress.key">
                           <span><fmt:message key="common.button.deleteText"/></span>
                          </dsp:a>
                        </li>
                      </ul>
                    </dd> 
                  </dl>
                </div><%-- atg_store_addressGroup --%>
           
              </c:if><%-- End c:if to see if current indexed address is empty --%>
            </c:forEach><%-- End For Each Stored Address (sorted) --%>
                 
          </div><%-- atg_store_savedAddresses --%>
          </fieldset>
          <div class="atg_store_saveSelectAddress atg_store_formActions">
            <fmt:message var="submitText" key="common.button.saveCardText"/>
            <span class="atg_store_basicButton">
              <dsp:input type="submit" value="${submitText}" id="atg_store_paymentInfoAddNewCardSubmit"
                         bean="B2CProfileFormHandler.createNewCreditCard"/>
            </span>
          
            <p><fmt:message key="common.using" />&nbsp;<span><fmt:message key="myaccount_paymentInfoCardAddEdit.savedBillingAddress" /></span></p>
          </div>
          
        </div><%-- atg_store_selectAddress --%>
      </c:if>
    </dsp:oparam>
  </dsp:droplet><%-- End Map To Default Sorted Array Droplet (sort stored addresses) --%>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/creditCardAddressSelect.jsp#2 $$Change: 635969 $--%>
