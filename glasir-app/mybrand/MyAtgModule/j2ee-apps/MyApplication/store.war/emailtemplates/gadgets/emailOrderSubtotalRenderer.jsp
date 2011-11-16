
<dsp:page>

<%--  This page recieves following parameters
     Parameters:
     order - The order to use for display of subtotal,tax,discount and shipping charges of the order
     showTotal (optional) - Boolean indicating if the order total should also be displayed
     priceListLocale - the locale to use for price formatting
 --%>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>

  <dsp:getvalueof var="showTotal" vartype="java.lang.String" param="showTotal"/>
  <dsp:getvalueof var="showTotal" vartype="java.lang.String" param="showTotal"/>
  <dsp:getvalueof var="shipping" vartype="java.lang.Double" param="order.priceInfo.shipping" />
  <dsp:getvalueof var="order"  param="order" />

  <%--Get the Currency Code --%>
  <dsp:getvalueof var="currencyCode" vartype="java.lang.String" param="order.priceInfo.currencyCode"/>

  <tr><td colspan="5">&nbsp;</td></tr>
  <tr>
    <td colspan="2"></td>
    <td colspan="2" style="font-size:12px;line-height:18px;">
      <fmt:message key="common.subTotal" />
    </td>
    <td align="right" style="color:#000000;font-weight:bold;font-size:12px;line-height:18px;">
      <dsp:getvalueof var="rawSubtotal" vartype="java.lang.Double" param="order.priceInfo.rawSubtotal" />
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${rawSubtotal}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </td>
  </tr>
  <dsp:droplet name="Compare">
    <%-- Only show if there is a discount--%>
    <dsp:param name="obj1" param="order.priceInfo.discountAmount" />
    <dsp:param name="obj2" value="0" number="0.0" />
    <dsp:oparam name="greaterthan">
      <tr>
        <td colspan="2"></td>
        <td colspan="2" style="font-size:12px;line-height:18px;"><fmt:message key="common.discount" /></td>
        <td align="right" style="color:#000000;font-weight:bold;font-size:12px;line-height:18px;">
          <dsp:getvalueof var="discountAmount" vartype="java.lang.Double" param="order.priceInfo.discountAmount" />
          -
          <dsp:include page="/global/gadgets/formattedPrice.jsp">
            <dsp:param name="price" value="${discountAmount}"/>
            <dsp:param name="priceListLocale" param="priceListLocale"/>
          </dsp:include>
        </td>
      </tr>
    </dsp:oparam>
  </dsp:droplet>
  <tr>
    <td colspan="2"></td>
    <td colspan="2" style="font-size:12px;line-height:18px;"><fmt:message key="common.shipping" /></td>
    <td align="right" style="color:#000000;font-weight:bold;font-size:12px;line-height:18px;">
       <c:choose>
         <c:when test="${shipping > 0 || order.state != '0'}">
           <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${shipping}"/>
              <dsp:param name="priceListLocale" param="priceListLocale"/>
            </dsp:include>
         </c:when>
         <c:otherwise>---</c:otherwise>
      </c:choose>
    </td>
  </tr>
  <tr>
    <td colspan="2"></td>
    <td colspan="2" style="font-size:12px;line-height:18px;"><fmt:message key="common.tax" /></td>
    <td align="right" style="color:#000000;font-weight:bold;font-size:12px;line-height:18px;">
      <c:choose>
         <c:when test="${shipping > 0 || order.state != '0'}">
           <dsp:getvalueof var="tax" vartype="java.lang.Double" param="order.priceInfo.tax" />
           <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${tax}"/>
              <dsp:param name="priceListLocale" param="priceListLocale"/>
            </dsp:include>
         </c:when>
         <c:otherwise>---</c:otherwise>
      </c:choose>

    </td>
  </tr>

  <%-- Only display here if specified by parameter --%>
  <c:if test="${showTotal}">
      <tr><td colspan="5">&nbsp;</td></tr>
      <tr>
        <td colspan="2"></td>
        <td colspan="2" style="color:#000000;font-weight:bold;"><fmt:message key="common.total" /><fmt:message key="common.labelSeparator" /></td>
        <td align="right" style="color:orange;font-weight:bold;">
          <strong>
              <dsp:getvalueof var="total" vartype="java.lang.Double" param="order.priceInfo.total"/>
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${total}"/>
                <dsp:param name="priceListLocale" param="priceListLocale"/>
              </dsp:include>              
            </strong>
        </td>
      </tr>
  </c:if>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailOrderSubtotalRenderer.jsp#1 $$Change: 633540 $--%>