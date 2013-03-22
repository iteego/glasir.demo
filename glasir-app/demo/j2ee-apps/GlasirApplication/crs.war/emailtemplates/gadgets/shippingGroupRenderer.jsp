<dsp:page>
  <dsp:getvalueof var="shippingGroup" vartype="atg.commerce.order.ShippingGroup" param="shippingGroup"/>
  <dsp:getvalueof var="shippingGroupClassType" vartype="java.lang.String" param="shippingGroup.shippingGroupClassType"/>
  <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="priceListLocale"/>
  
  <c:set var="itemsSize" value="${fn:length(shippingGroup.commerceItemRelationships)}"/>
  <c:if test="${itemsSize > 0 and shippingGroupClassType == 'hardgoodShippingGroup'}">
    <dsp:param name="shippingAddress" param="shippingGroup.shippingAddress"/>                    
    <dsp:getvalueof var="addressValue" param="shippingAddress.country"/>
    <c:if test='${addressValue != ""}'>
      <%-- 
        If this shipping group is gift shipping group then 
        add title "Gift Shipping Destination" and hide "Edit" link
      --%>
      <c:set var="isGiftShippingGroup" value="false"/>
      <c:set var="shippingGroupClass" value="atg_store_confirmHardgoodItem"/>
      
      <dsp:droplet name="/atg/commerce/gifts/IsGiftShippingGroup">
        <dsp:param name="sg" param="shippingGroup"/>
        <dsp:oparam name="true">
          <c:set var="isGiftShippingGroup" value="true"/>
          <c:set var="shippingGroupClass" value="atg_store_confirmGiftListItem"/>
        </dsp:oparam>
      </dsp:droplet>

      <tr>
        <td valign="top" style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;">
          <%-- Ship To Label --%>
          <fmt:message key="emailtemplates_orderConfirmation.shipTo"/>
        </td>
        <td valign="top" style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;">
          <%-- Gift Shipping Group --%>
          <c:if test="${isGiftShippingGroup}">
            <span style="font-weight:bold;">
              <fmt:message key="checkout_shippingGifts.giftShippingDestinations"/>
            </span>
          </c:if>
          
          <%-- 
          We cannot use the /global/gadgets/shippingAddressView.jsp component, 
          as we need to control the formatting of each part of the address without using CSS classes 
          --%>
          
          <dsp:getvalueof var="shippingAddress" param="shippingAddress"/>
          <dsp:getvalueof var="shippingMethod" param="shippingGroup.shippingMethod"/>
          
          <div style="padding-bottom:8px;font-size:20px;">
            <span><dsp:valueof value="${shippingAddress.firstName}"/></span>
            <span><dsp:valueof value="${shippingAddress.middleName}"/></span>
            <span><dsp:valueof value="${shippingAddress.lastName}"/></span>
          </div>
          <dsp:valueof value="${shippingAddress.address1}"/>
          <br />
          <c:if test="${not empty shippingAddress.address2}">
            <dsp:valueof value="${shippingAddress.address2}"/>
            <br />
          </c:if>
          <dsp:valueof value="${shippingAddress.city}"/><fmt:message key="common.comma"/>
          <c:if test="${not empty shippingAddress.state}">
            <dsp:valueof value="${shippingAddress.state}"/><fmt:message key="common.comma"/>
          </c:if>
          <dsp:valueof value="${shippingAddress.postalCode}"/>
          <br />  
          <dsp:droplet name="/atg/store/droplet/CountryListDroplet">
            <dsp:param name="userLocale" bean="/atg/dynamo/servlet/RequestLocale.locale" />
            <dsp:param name="countryCode" value="${shippingAddress.country}"/>
            <dsp:oparam name="false">
                <dsp:valueof param="countryDetail.displayName" />
            </dsp:oparam>
          </dsp:droplet>
          <br /> 
          <dsp:valueof value="${shippingAddress.phoneNumber}"/>
        </td>
        <td colspan="3" valign="top" style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:14px;">
          <%-- Via Label --%>
          <span style="font-size:16px;color:#666;font-weight:bold;">
            <fmt:message key="emailtemplates_orderConfirmation.via"/>
          </span>
          <c:if test="${not empty shippingMethod}">
            <span style="font-size:20px;color:#000;">
              <fmt:message key="common.delivery${fn:replace(shippingMethod, ' ', '')}"/>
            </span>
          </c:if>
        </td>
      </tr>      

      <dsp:getvalueof var="commerceItemRels" vartype="java.lang.Object" param="shippingGroup.commerceItemRelationships"/> 
      <dsp:getvalueof id="size" value="${fn:length(commerceItemRels)}"/>
      <c:if test="${not empty commerceItemRels}">
        <dsp:include page="/emailtemplates/gadgets/emailOrderItemsHeader.jsp" flush="true"/>
        <c:forEach var="currentItemRel" items="${commerceItemRels}" varStatus="status">
          <dsp:param name="currentItemRel" value="${currentItemRel}"/>              
          <dsp:getvalueof var="commItem" param="currentItemRel.commerceItem"/>
          <%-- Do not display gift wrap in the shipping group's commerce items list; we will display it later in 'order extras' secion --%>
          <c:choose>
            <c:when test="${commItem.commerceItemClassType != 'giftWrapCommerceItem'}">
              <%-- Generate price beans for current row (that is for shipping group-commerce item relationship --%>
              <dsp:droplet name="/atg/store/droplet/StorePriceBeansDroplet">
                <dsp:param name="relationship" value="${currentItemRel}"/>
                <dsp:oparam name="output">
                  <dsp:include page="/emailtemplates/gadgets/emailOrderItemsRenderer.jsp" flush="true">
                    <dsp:param name="order" param="order"/>
                    <dsp:param name="commerceItem" value="${commItem}"/>
                    <dsp:param name="priceListLocale" value="${priceListLocale}"/>
                  </dsp:include>
                </dsp:oparam>
              </dsp:droplet>
            </c:when>
            <c:otherwise>
              <c:set var="giftWrapAmount" scope="request" value="${commItem.priceInfo.listPrice}"/>
            </c:otherwise>
          </c:choose>
        </c:forEach>            
        <dsp:include page="/emailtemplates/gadgets/emailOrderItemsFooter.jsp" flush="true"/>
      </c:if>

    </c:if>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/shippingGroupRenderer.jsp#2 $$Change: 633752 $--%>