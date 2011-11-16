<dsp:page>

  <%-- 
      This gadget renders the shipping information on the order confirmation page. It assumes that it is rendered
      within the context of an HTML table, thereby requiring a <tr> at the top of the file.

      Form Condition:
      - This gadget must be contained inside of a form.
      
      Parameters:
       - order - The order to be rendered
       - httpserver - prefix for http links with protocol and server details
  --%>
  
  <dsp:importbean bean="/atg/commerce/catalog/SKULookup"/>
  <dsp:getvalueof var="shippingGroups" vartype="java.lang.Object" param="order.shippingGroups"/>
  <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="priceListLocale"/>
  
  
  <c:set var="shippingGroupsSize" value="${fn:length(shippingGroups) }" />
  <c:forEach var="shippingGroup" items="${shippingGroups}" varStatus="shippingGroupStatus">
    <dsp:include page="/emailtemplates/gadgets/shippingGroupRenderer.jsp">
      <dsp:param name="shippingGroup" value="${shippingGroup}"/>
      <dsp:param name="priceListLocale" value="${priceListLocale}"/>
    </dsp:include>
  </c:forEach>

  <dsp:getvalueof var="order" vartype="atg.projects.store.order.StoreOrderImpl" param="order"/>
  <c:if test="${order.containsGiftWrap}">
    <tr>
      <td colspan="5" style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;">
        <fmt:message key="checkout_confirmExtras.title"/>
      </td>
    </tr>
    <c:forEach var="commerceItem" items="${order.commerceItems}">
      <c:if test="${commerceItem.commerceItemClassType == 'giftWrapCommerceItem'}">
        <dsp:param name="commerceItem" value="${commerceItem}"/>
        <tr>
          <td style="font-family:Tahoma,Arial,sans-serif;font-size:12px;width:60px;height:60px;">
            &nbsp;<%-- it's a place for site-indicator --%>
          </td>
          <td style="font-family:Tahoma,Arial,sans-serif;font-size:12px;width:170px;">
            <dsp:valueof param="commerceItem.auxiliaryData.productRef.displayName">
              <fmt:message key="common.noDisplayName"/>
            </dsp:valueof>
          </td>
          <td colspan="2" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;color:#666666;width:205px;">
            <table style="border-collapse: collapse; width: 215px;">
              <tr>
                <td style="width:65px;color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif;">
                  <fmt:formatNumber value="${commerceItem.quantity}" type="number"/>
                  <fmt:message key="common.atRateOf"/>
                </td>
                <td style="color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif;width:150px;">
                  <dsp:include page="/global/gadgets/formattedPrice.jsp">
                    <dsp:param name="price" param="commerceItem.priceInfo.listPrice"/>
                    <dsp:param name="priceListLocale" value="${priceListLocale}"/>
                  </dsp:include>
                </td>
              </tr>
            </table>
          </td>
          <td align="right" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;color:#000000; white-space:nowrap;">
            =
            <span style="color:#000000">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" param="commerceItem.priceInfo.amount"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>
            </span>
          </td>
        </tr>
      </c:if>
    </c:forEach>
  </c:if>

  <dsp:include page="/emailtemplates/gadgets/emailOrderSubtotalRenderer.jsp" flush="true">
    <dsp:param name="order" param="order"/>
    <dsp:param name="showTotal" value="true"/>
    <dsp:param name="priceListLocale" value="${priceListLocale}"/>
  </dsp:include>          

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailOrderShippingAddresses.jsp#2 $$Change: 633752 $--%>