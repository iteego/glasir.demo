<%-- This gadget displays shipping group's nickname and address with edit and remove links. --%>
     
<dsp:page>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  
  <dsp:importbean var="originatingRequest" bean="/OriginatingRequest"/>
 
  <dsp:getvalueof var="shippingGroup" param="shippingGroup"/>
  <dsp:getvalueof var="shippingAddressNickname" param="shippingAddressNickname"/>
  <dsp:getvalueof var="editShippingAddressSuccessURL" param="editShippingAddressSuccessURL"/>
  <dsp:getvalueof var="removeShippingAddressSuccessURL" param="removeShippingAddressSuccessURL"/>
  <dsp:getvalueof var="isDefault" param="isDefault"/>
  

  <dsp:getvalueof var="shippingGroupClassType" vartype="java.lang.String" param="shippingGroup.shippingGroupClassType"/>
  
  <c:if test='${shippingGroupClassType == "hardgoodShippingGroup"}'>

    <dsp:getvalueof var="shippingAddress" param="shippingGroup.shippingAddress"/>
    <dsp:setvalue param="shippingAddress" value="${shippingAddress}"/>
    
    <c:if test="${not empty shippingAddress}">

      <%-- Display Address Details --%>
      <div class="atg_store_addressGroup${isDefault ? ' atg_store_addressGroupDefault' : ''}">
        <c:set var="counter" value="${counter + 1}"/>
        <dl>
          <%-- Show Default Label if it is the default value --%>
          <c:choose>
            <c:when test="${isDefault}">
              <dt class="atg_store_defaultShippingAddress">
                ${shippingAddressNickname}
                <fmt:message var="defaultAddressTitle" key="common.defaultShipping"/>
                                          
                <dsp:a page="/myaccount/profileDefaults.jsp" title="${defaultAddressTitle}">
                  <span>${defaultAddressTitle}</span>
                </dsp:a>
                         
              </dt>             
            </c:when>
            <c:otherwise>
              <dt>${shippingAddressNickname}</dt>
            </c:otherwise>
          </c:choose> 
          
          <dd>
            <dsp:include page="/global/gadgets/shippingAddressView.jsp" flush="false">
              <dsp:param name="address" param="shippingAddress"/>
              <dsp:param name="private" value="false"/>
            </dsp:include>
          </dd>
        </dl>

        
        <c:set var="description" value="${shippingGroup.description}"/>
        <dsp:getvalueof var="giftPrefix" bean="/atg/commerce/gifts/GiftlistManager.giftShippingGroupDescriptionPrefix"/>
        <c:set var="giftPrefix" value="${giftPrefix}"/>
        <c:if test="${!(fn:startsWith(description, giftPrefix))}">
          <ul class="atg_store_storedAddressActions">
          
            <%-- Display Edit Link --%>
            <fmt:message var="editAddressTitle" key="common.button.editAddressTitle"/>
            <c:set var="count" value="1"/>
            <li class="<crs:listClass count="${count}" size="2" selected="false"/>">
              <dsp:a title="${editAddressTitle}"
                     iclass="atg_store_addressBookDefaultEdit"
                     page="/checkout/shippingAddressEdit.jsp">
                <dsp:param name="nickName" value="${shippingAddressNickname}"/>
                <dsp:param name="successURL" value="${originatingRequest.contextPath}${editShippingAddressSuccessURL}"/>
                <span><fmt:message key="common.button.editAddressText"/></span>
              </dsp:a>
            </li>
            
            <%-- Display Remove Link --%>
            <fmt:message var="removeAddressTitle" key="myaccount_addressBookDefault.button.removeAddressTitle"/>
            <c:set var="count" value="${count + 1}"/>
            <li class="<crs:listClass count="${count}" size="2" selected="false"/>">
              <dsp:a title="${removeAddressTitle}"
                     iclass="atg_store_addressBookDefaultRemove"
                     page="${removeShippingAddressSuccessURL}">
                <dsp:property bean="ShippingGroupFormHandler.removeShippingAddressNickName" value="${shippingAddressNickname}"/>
                <dsp:property bean="ShippingGroupFormHandler.removeShippingAddress" value="${shippingAddressNickname}"/>
                <span><fmt:message key="myaccount_addressBookDefault.button.removeAddressText"/></span>
              </dsp:a>
            </li>
            
          </ul>
        </c:if>
      </div>
    </c:if><%-- check for empty shipping address --%>
  </c:if><%-- check for hard good shipping --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingGroupDetails.jsp#2 $$Change: 635969 $--%>