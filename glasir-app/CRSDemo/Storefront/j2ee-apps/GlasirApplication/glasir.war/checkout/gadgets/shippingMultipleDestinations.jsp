<dsp:page>
  <%--

  This gadget display list of items and allow to select shipping address per item

      Form Condition:
      - This gadget must be contained inside of a form.
        ShippingGroupFormHandler must be invoked from a submit
        button in this form for fields in this page to be processed
  --%>
  <dsp:importbean bean="/atg/commerce/util/MapToArrayDefaultFirst"/>
  <dsp:importbean bean="/atg/store/droplet/ShippingRestrictionsDroplet"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupContainerService"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet"/>
  <dsp:importbean bean="/atg/commerce/pricing/AvailableShippingMethods"/>
  <dsp:importbean bean="/atg/store/profile/ProfileCheckoutPreferences"/>

<div class="atg_store_multiShipHeader">
  <fmt:message var="shippingDestinationsTableSummary" key="checkout_shippingMultipleDestinations.tableSummary"/>

  <h2><fmt:message key="checkout_shippingOptions.button.shipToMultipleText"/></h2>
  <ul class="atg_store_multiShipAdderessOptions">
    <li>
  <fmt:message var="addShippingAddressTitle" key="checkout_shippingMultipleDestinations.createNewAddressTitle" />
  <fmt:message var="addShippingAddress" key="checkout_shippingMultipleDestinations.createNewAddress"/>

  <dsp:a href="${pageContext.request.contextPath}/checkout/shippingAddressAdd.jsp" title="${addShippingAddressTitle}">
    <span>
      ${addShippingAddress}
    </span>
  </dsp:a>
</li>
<li>
  <fmt:message var="editAddressesTitle" key="checkout_shippingMultipleDestinations.editAddressesTitle" />
  <fmt:message var="editAddresses" key="checkout_shippingMultipleDestinations.editAddresses"/>

  <dsp:a href="${pageContext.request.contextPath}/checkout/editShippingAddresses.jsp" title="${editAddressesTitle}">
    <span>
      ${editAddresses}
    </span>
  </dsp:a>
</li> 
    </ul>
    </div>
  <table summary="${shippingDestinationsTableSummary}" cellspacing="0" cellpadding="0"
         class="atg_store_multiShipProducts" id="atg_store_cart">

    <tbody>

      <%-- calc number of available items --%>
      <dsp:getvalueof var="allHardgoodCommerceItemShippingInfos" vartype="java.lang.Object"
            bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos"/>
      <c:set var="itemsSize" value="${fn:length(allHardgoodCommerceItemShippingInfos)}"/>
      <c:set var="itemsCount" value="0"/>

      <dsp:getvalueof var="giftShippingGroups" vartype="java.lang.Object" bean="ShippingGroupFormHandler.giftShippingGroups"/>

      <c:forEach var="giftShippingGroup" items="${giftShippingGroups}" varStatus="giftShippingGroupsStatus">
        <dsp:param name="giftShippingGroup" value="${giftShippingGroup}"/>
        <dsp:getvalueof var="commerceItemRelationships" vartype="java.lang.Object" param="giftShippingGroup.commerceItemRelationships"/>
        <c:set var="itemsSize" value="${itemsSize + fn:length(commerceItemRelationships)}"/>
      </c:forEach>

      <%-- Generate price beans for each product row on page --%>
      <dsp:droplet name="/atg/store/droplet/StorePriceBeansDroplet">
        <dsp:param name="order" bean="/atg/commerce/ShoppingCart.current"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="priceBeansMap" vartype="java.util.Map" param="priceBeansMap"/>
      <%-- For each hardgood CommerceItemInfo in the map do the following: --%>
      <dsp:getvalueof var="allHardgoodCommerceItemShippingInfos" vartype="java.lang.Object"
          bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos"/>
      <c:forEach var="cisiItem" items="${allHardgoodCommerceItemShippingInfos}" varStatus="status">
        <dsp:param name="cisiItem" value="${cisiItem}"/>
        <c:set var="index" value="${status.index}"/>

        <c:set var="itemsCount" value="${itemsCount + 1}"/>
        <tr class='<crs:listClass count="${itemsCount}" size="${itemsSize}" selected="false"/>'>

          <dsp:getvalueof var="commerceItemClassType" param="cisiItem.commerceItem.commerceItemClassType"/>
          <c:if test='${commerceItemClassType != "giftWrapCommerceItem"}'>
            <dsp:droplet name="SharingSitesDroplet">
              <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
              <dsp:param name="excludeInputSite" value="true"/>
              <dsp:oparam name="output">
                <td class="site">
                  <dsp:include page="/global/gadgets/siteIndicator.jsp">
                    <dsp:param name="mode" value="icon"/>
                    <dsp:param name="siteId" param="cisiItem.commerceItem.auxiliaryData.siteId"/>
                    <dsp:param name="product" param="cisiItem.commerceItem.auxiliaryData.productRef"/>
                  </dsp:include>
                </td>
              </dsp:oparam>
            </dsp:droplet>
            <td class="image">
              <dsp:include page="/cart/gadgets/cartItemImg.jsp">
                <dsp:param name="commerceItem" param="cisiItem.commerceItem"/>
                <dsp:param name="displayAslink" value="false"/>
              </dsp:include>
            </td>
            <td class="item">
              <%-- display shipping address --%>
              <dsp:include page="/global/gadgets/shippingProductDetails.jsp">
                <dsp:param name="commerceItem" param="cisiItem.commerceItem"/>
                <dsp:param name="quantity" value="1"/>
                <dsp:param name="displayAslink" param="false"/>
              </dsp:include>
            </td>
            <td class="atg_store_actionItems">
              <%-- Get price bean only once! when you take it, it's being removed from map --%>
              <c:set var="currentPriceBean" value="${priceBeansMap[cisiItem.commerceItem.id]}"/>
              <dsp:include page="/cart/gadgets/displayItemPricePromotions.jsp">
                <dsp:param name="currentItem" value="${cisiItem.commerceItem}"/>
                <dsp:param name="unitPriceBean" value="${currentPriceBean}"/>
              </dsp:include>
              <dsp:include page="/cart/gadgets/displayItemPrice.jsp">
                <dsp:param name="quantity" value="${currentPriceBean.quantity}"/>
                <dsp:param name="displayQuantity" value="true"/>
                <dsp:param name="price" value="${currentPriceBean.unitPrice}"/>
                <dsp:param name="oldPrice" value="${currentPriceBean.unitPrice != cisiItem.commerceItem.priceInfo.listPrice ?
                    cisiItem.commerceItem.priceInfo.listPrice : ''}"/>
              </dsp:include>

              <ul>
                <li>
                  <label>
                    <fmt:message key="checkout_confirmPaymentOptions.shipTo"/><fmt:message key="common.labelSeparator"/>
                  </label>
                  <dsp:select bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos[${index}].shippingGroupName"
                              required="true" id="atg_store_multiShippingAddressesSelect1">
                    <dsp:getvalueof var="state" bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos[${index}].shippingGroupName"/>
                    <dsp:getvalueof var="defaultShippingAddressNickname" bean="ProfileCheckoutPreferences.defaultShippingAddressNickname"/>
                    <dsp:getvalueof var="shippingGroupMap" vartype="java.lang.Object" bean="ShippingGroupContainerService.shippingGroupMap"/>

                    <c:if test="${empty shippingGroupMap}">
                      <dsp:option value="">
                        <fmt:message key="checkout_shippingMultipleDestinations.noneAvailable"/>
                      </dsp:option>
                    </c:if>

                    <%-- Sort shipping groups by nicknames with default address in the beginning --%>
                    <dsp:droplet name="MapToArrayDefaultFirst">
                      <dsp:param name="map" bean="ShippingGroupContainerService.shippingGroupMap"/>
                      <dsp:param name="defaultKey" bean="ProfileCheckoutPreferences.defaultShippingAddressNickname"/>
                      <dsp:param name="sortByKeys" value="true"/>
                      <dsp:oparam name="output">
                        <dsp:getvalueof var="sortedArray" vartype="java.lang.Object" param="sortedArray"/>
                        <%-- Add the nick name of every shipping group in the container to the
                             dropdown list and automatically select the shipping group that the info
                             is currently pointing at --%>
                        <c:forEach var="shippingGroup" items="${sortedArray}"
                                                       varStatus="shippingGroupLoop">
                          <dsp:param name="shippingGroup" value="${shippingGroup}"/>
                          <dsp:getvalueof var="shippingGroupClassType" vartype="java.lang.String" param="shippingGroup.value.shippingGroupClassType"/>
                          <dsp:getvalueof var="SGName" vartype="java.lang.String" param="cisiItem.shippingGroupName"/>

                          <dsp:getvalueof var="key" vartype="java.lang.String" value="${shippingGroup.key}"/>
                          <c:choose>
                            <c:when test='${shippingGroupClassType == "hardgoodShippingGroup"}'>
                              <dsp:getvalueof var="address" vartype="java.lang.String" value="${shippingGroup.value.shippingAddress.address1}"/>
                              <%-- Only render the option if the address is valid given the country restrictions --%>
                              <dsp:droplet name="ShippingRestrictionsDroplet">
                                <dsp:param name="countryCode" param="shippingGroup.value.shippingAddress.country"/>
                                <dsp:oparam name="false">
                                  <c:set var="selected"
                                         value="${key == SGName
                                                  || (empty SGName && key == defaultShippingAddressNickname)
                                                  || (empty SGName && empty defaultShippingAddressNickname && shippingGroupLoop.index == 0)}"/>
                                  <dsp:option value="${key}" selected="${selected}">
                                    <dsp:valueof value="${key}"/>- <dsp:valueof value="${address}"/>
                                  </dsp:option>
                                </dsp:oparam>
                              </dsp:droplet> <%-- ShippingRestrictionsDroplet --%>

                            </c:when>
                          </c:choose>

                        </c:forEach>
                      </dsp:oparam>
                    </dsp:droplet>
                  </dsp:select> <%-- Dropdown list of addresses --%>
                </li>

                <%-- Select shipping method dropdown --%>
                <li>
                  <label>
                    <fmt:message key="checkout_shippingOptions.shipVia"/><fmt:message key="common.labelSeparator"/>
                  </label>

                  <dsp:getvalueof var="anyShippingGroup" bean="ShippingGroupFormHandler.firstNonGiftHardgoodShippingGroupWithRels"/>
                  <c:if test="${empty anyShippingGroup}">
                    <dsp:getvalueof var="giftShippingGroups" bean="ShippingGroupFormHandler.giftShippingGroups"/>
                    <c:if test="${not empty giftShippingGroups}">
                      <dsp:getvalueof var="anyShippingGroup" value="${giftShippingGroups[0]}"/>
                    </c:if>
                  </c:if>
                   <dsp:getvalueof var="currentMethod" bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos[${index}].shippingMethod"/>
                   <dsp:getvalueof var="defaultShippingMethod" bean="ProfileCheckoutPreferences.defaultShippingMethod"/>
                   
                  <dsp:select bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos[${index}].shippingMethod"
                              required="true" id="atg_store_multiShippingMethodSelect">

                    <%-- Display available methods --%>
                    <dsp:droplet name="AvailableShippingMethods">
                      <dsp:param name="shippingGroup" value="${anyShippingGroup}"/>
                      <dsp:oparam name="output">
                        <dsp:getvalueof var="availableShippingMethods" vartype="java.lang.Object" param="availableShippingMethods"/>

                        <%-- Check if current shipping method defined in the shipping group is
                             the one from available shipping methods --%>
                        <c:if test="${not empty currentMethod}">
                          <c:set var="isCurrentInAvailableMethods" value="false"/>
                          <c:forEach var="method" items="${availableShippingMethods}" varStatus="status">
                            <c:if test="${currentMethod eq method}">
                              <c:set var="isCurrentInAvailableMethods" value="true"/>
                            </c:if>
                          </c:forEach>
                        </c:if>

                        <c:if test="${(empty availableShippingMethods or not isCurrentInAvailableMethods) and empty defaultShippingMethod}">
                          <dsp:option value="" selected="true">
                            <fmt:message key="checkout_shippingOptions.availableShippingMethods"/>
                          </dsp:option>
                        </c:if>
                        
                        <c:forEach var="method" items="${availableShippingMethods}" varStatus="shippingMethodLoop">
                          <dsp:param name="method" value="${method}"/>

                          <c:set var="shippingMethod" value="${fn:replace(method, ' ', '')}"/>
                          <c:set var="shippingMethodResourceKey" value="checkout_shipping.delivery${shippingMethod}"/>

                          <c:set var="selected"
                                 value="${isCurrentInAvailableMethods && (currentMethod == method) 
                                 || (empty currentMethod && method == defaultShippingMethod)}"/>
                          <dsp:option selected="${selected}" paramvalue="method">
                            <fmt:message key="${shippingMethodResourceKey}"/>
                          </dsp:option>
                        </c:forEach>
                      </dsp:oparam>
                    </dsp:droplet><%-- End Available Shipping Methods Droplet --%>
                  </dsp:select>

                </li>
              </ul>

            </td>
          </c:if>
        </tr>
      </c:forEach>
      </dsp:oparam>
      </dsp:droplet>
    </tbody>
  </table>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingMultipleDestinations.jsp#2 $$Change: 633752 $--%>
