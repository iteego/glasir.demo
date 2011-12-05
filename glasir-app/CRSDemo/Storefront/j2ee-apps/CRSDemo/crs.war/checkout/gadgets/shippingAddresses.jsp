<%-- 
  This gadget renders the user's saved shipping addresses for selection
--%>

<dsp:page>

  <dsp:importbean bean="/atg/commerce/util/MapToArrayDefaultFirst"/>
  <dsp:importbean bean="/atg/store/droplet/ShippingRestrictionsDroplet"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupContainerService"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/store/profile/ProfileCheckoutPreferences"/>
  
  <%-- Get profile saved addresses or gift addresses --%>
  <dsp:getvalueof var="secondaryAddresses" bean="Profile.secondaryAddresses"/>
  <dsp:getvalueof var="giftShippingGroups" bean="ShippingGroupFormHandler.giftShippingGroups"/>
  <c:if test="${not empty secondaryAddresses or not empty giftShippingGroups}">
  
    <fieldset class="atg_store_chooseShippingAddresses">
            <%-- Include hidden form params --%>
            <dsp:include page="shippingFormParams.jsp" flush="true"/>
                
            <%-- Specify that saved profile address is used for shipping --%>
            <dsp:input type="hidden" bean="ShippingGroupFormHandler.shipToNewAddress" value="false"/>
            
            <dsp:getvalueof var="shippingGroupMap" vartype="java.lang.Object" bean="ShippingGroupContainerService.shippingGroupMap"/>
         
            
            <dsp:droplet name="MapToArrayDefaultFirst">
              <dsp:param name="map" value="${shippingGroupMap}"/>
              <dsp:param name="defaultKey" bean="ProfileCheckoutPreferences.defaultShippingAddressNickname"/>
              <dsp:param name="sortByKeys" value="true"/>
              <dsp:oparam name="output">
                <dsp:getvalueof var="sortedArray" vartype="java.lang.Object" param="sortedArray"/>
                 
                <c:if test="${not empty sortedArray}">
                
                  <h3><fmt:message key="checkout_shippingAddresses.selectShippingAddress"/></h3>
                  <div id="atg_store_savedAddresses">
                  
                    
                    <%-- loop through profile addresses --%>
                    <c:forEach var="shippingAddressVar" items="${sortedArray}">
                      <dsp:getvalueof var="shippingGroup" vartype="java.lang.Object" value="${shippingAddressVar}"/>
                      <dsp:getvalueof var="shippingGroupValue" value="${shippingGroup.value}"/>
                      
                      <dsp:getvalueof var="shippingAddress" value="${shippingGroupValue.shippingAddress}"/>
                      
                      <c:if test="${not empty shippingAddress}">
                        <div class="atg_store_addressGroup">
                        <dsp:droplet name="ShippingRestrictionsDroplet">
                          <dsp:param name="countryCode" value="${shippingAddress.country}"/>
                          <dsp:oparam name="false">
                            <%-- shipping address is allowed for shipping --%>
                            <dl class="atg_store_savedAddresses">
                              <dt>
                                <dsp:getvalueof var="shipToAddressName" vartype="java.lang.String" bean="ShippingGroupFormHandler.shipToAddressName"/>
                                <dsp:input type="radio" name="address" value="${shippingGroup.key}"
                                           id="${shippingAddress.repositoryItem.repositoryId}" checked="${shippingGroup.key == shipToAddressName}"
                                           bean="ShippingGroupFormHandler.shipToAddressName"/>
                                <%-- Display Address Details --%>
                                <label for="${shippingAddress.repositoryItem.repositoryId}">
                                  <dsp:valueof value="${shippingGroup.key}"/>
                                </label>
                              </dt>
                              <dd class="atg_store_addressSelect">                
            
                                <dsp:include page="/global/util/displayAddress.jsp" flush="false">
                                  <dsp:param name="address" value="${shippingAddress}"/>
                                  <dsp:param name="private" value="false"/>
                                </dsp:include>
                              </dd>
                              <c:set var="description" value="${shippingGroupValue.description}"/>
                              <dsp:getvalueof var="giftPrefix" bean="/atg/commerce/gifts/GiftlistManager.giftShippingGroupDescriptionPrefix"/>
                              <c:set var="giftPrefix" value="${giftPrefix}"/>
                              <c:if test="${!(fn:startsWith(description, giftPrefix))}">
                                <%-- Display Edit/Remove Links --%>
                                <dd class="atg_store_storedAddressActions">
                                  <ul>
                                    <fmt:message var="editAddressTitle" key="common.button.editAddressTitle"/>
                                    <li class="<crs:listClass count="1" size="2" selected="false"/>">
                                      <dsp:a page="/checkout/shippingAddressEdit.jsp" value="${shippingGroup.key}">
                                        <dsp:param name="nickName" value="${shippingGroup.key}"/>
                                        <dsp:param name="selectedAddress" bean="ShippingGroupFormHandler.shipToAddressName"/>
                                        <dsp:param name="successURL" value="shipping.jsp"/>
                                        <fmt:message key="checkout_shipping.edit"/>
                                      </dsp:a>
                                    </li>
                                    <fmt:message var="removeAddressTitle" key="common.button.deleteTitle"/>
                                    <dsp:getvalueof id="requestURL" idtype="java.lang.String" bean="/OriginatingRequest.requestURI"/>
                                    <li class="<crs:listClass count="2" size="2" selected="false"/>">
                                      <dsp:a title="${removeAddressTitle}"
                                        bean="B2CProfileFormHandler.removeAddress"
                                        href="${requestURL}" value="${shippingGroup.key}">
                                        <span><fmt:message key="common.button.deleteText"/></span>
                                      </dsp:a>
                                    </li>
                                  </ul>
                                </dd> 
                              </c:if>
                            </dl>
                
                          </dsp:oparam>
                        </dsp:droplet><%-- ShippingRestrictionsDroplet --%>
                      </div><%-- atg_store_addressGroup --%>
                      </c:if>
                     
                    </c:forEach><%-- End loop through addresses --%>
                   
                   
                  
                </div>
                </c:if>
              </dsp:oparam>
            </dsp:droplet> <%-- MapToArrayDefaultFirst (sort stored addresses) --%>
            </fieldset>
            <%-- Ship to this address button --%>
            <fmt:message var="shipToButtonText" key="checkout_shippingAddresses.button.shipToThisAddress"/>
            <div class="atg_store_saveSelectAddress atg_store_formActions">
            <span class="atg_store_basicButton">
              <dsp:input type="submit"  bean="ShippingGroupFormHandler.moveToBilling" value="${shipToButtonText}"/>
            </span>
            </div>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingAddresses.jsp#1 $$Change: 633540 $--%>
