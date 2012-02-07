
<dsp:page>

<%--  This page recieves following parameters
     Parameters:
     order - The order to use for display of subtotal,tax,discount and shipping charges of the order
     showTotal (optional) - Boolean indicating if the order total should also be displayed
 --%>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>

  <dsp:getvalueof bean="ShippingGroupFormHandler.shippingMethod" var="currentShippingMethod"/>

  <dsp:getvalueof var="showTotal" vartype="java.lang.String" param="showTotal"/>
  <dsp:getvalueof var="showTotal" vartype="java.lang.String" param="showTotal"/>

  <%--Get the Currency Code --%>
  <dsp:getvalueof var="currencyCode" vartype="java.lang.String" param="order.priceInfo.currencyCode"/>

  <dsp:getvalueof var="rawSubtotal" vartype="java.lang.Double" param="order.priceInfo.rawSubtotal" />
  <dsp:getvalueof var="total" vartype="java.lang.Double" param="order.priceInfo.total"/>
  <dsp:getvalueof var="discountAmount" vartype="java.lang.Double" param="order.priceInfo.discountAmount" />
  <dsp:getvalueof var="tax" vartype="java.lang.Double" param="order.priceInfo.tax" />
  <dsp:getvalueof var="shipping" vartype="java.lang.Double" param="order.priceInfo.shipping" />
  <dsp:getvalueof var="tax" vartype="java.lang.Double" param="order.priceInfo.tax" />
  <dsp:getvalueof var="order"  param="order" />

  <tr>
    <td class="atg_store_orderSubTotals" colspan="5">
      <div>

        <dl>
          <dt><fmt:message key="common.subTotal" /></dt>
          <dd>
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${rawSubtotal }"/>
            </dsp:include>
          </dd>
        </dl>

        <dsp:droplet name="Compare">
          <%-- Don't show if no discount--%>
          <dsp:param name="obj1" param="order.priceInfo.discountAmount" />
          <dsp:param name="obj2" value="0" number="0.0" />
          <dsp:oparam name="greaterthan">
            <dl>
              <dt><fmt:message key="common.discount" /></dt>
              <dd>

                -
                <dsp:include page="/global/gadgets/formattedPrice.jsp">
                  <dsp:param name="price" value="${discountAmount }"/>
                </dsp:include>
              </dd>
            </dl>
          </dsp:oparam>
        </dsp:droplet>
        <dl>
          <dt><fmt:message key="common.shipping" /></dt>
          <dd>
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${shipping }"/>
            </dsp:include>
          </dd>
        </dl>
        <dl>
          <dt><fmt:message key="common.tax" /></dt>
          <dd>
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${tax }"/>
            </dsp:include>
          </dd>
        </dl>
      </div>
    </td>
  </tr>

  <%-- Only display here if specified by parameter --%>
  <c:if test="${showTotal}">
    <tfoot class="atg_store_subTotalBar">
      <tr>
        <td class="atg_store_popupLinks" colspan="4"></td>
        <td class="atg_store_subTotal" align="right" colspan="2">
          <p><fmt:message key="common.total" /><fmt:message key="common.labelSeparator" />
            <strong>
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${total}"/>
              </dsp:include>
            </strong>
          </p>
        </td>
      </tr>
    </tfoot>
  </c:if>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/orderSubtotalRenderer.jsp#2 $$Change: 635969 $--%>