<%-- 
  This gadget renders the order summary on the checkout pages:
  subtotal;
  discount;
  store credit;
  shipping;
  tax;
  promotion code;
  
  total.
--%>
<dsp:page>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>

  <dsp:getvalueof var="currencyCode" vartype="java.lang.String" param="order.priceInfo.currencyCode" />
  <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" param="order.commerceItems"/>
  <dsp:getvalueof var="shipping" vartype="java.lang.Double" param="order.priceInfo.shipping" />
  <dsp:getvalueof var="order"  param="order" />
  <dsp:getvalueof var="isShoppingCart" param="isShoppingCart"/>
  <dsp:getvalueof var="currentStage" param="currentStage"/>
  <dsp:getvalueof var="submittedOrder" param="submittedOrder"/>

  <div class="atg_store_orderSummary aside">
    <h2><fmt:message key="checkout_orderSummary.orderSummary" /></h2>
    <c:if test="${not empty commerceItems || not empty submittedOrder}">
      <ul>
       <li class="atg_store_orderSubTotals">
        
        <%-- Display Subtotal --%>
        <dl class="subtotal">
          <dt><fmt:message key="common.subTotal"/></dt>
          <dd>
            <dsp:getvalueof var="rawSubtotal" vartype="java.lang.Double" param="order.priceInfo.rawSubtotal" />
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${rawSubtotal }"/>
            </dsp:include>
           </dd>
        </dl>

        <%-- Display Discount --%>

        <dsp:droplet name="Compare">
          <%-- Don't show if no discount--%>
          <dsp:param name="obj1" param="order.priceInfo.discountAmount" />
          <dsp:param name="obj2" value="0" number="0.0" />
          <dsp:oparam name="greaterthan">
            
            <dl class="discount">
              <dt><fmt:message key="common.discount" />*</dt>
              <dd>
                <dsp:getvalueof var="discountAmount" vartype="java.lang.Double" param="order.priceInfo.discountAmount" />
                -
                <dsp:include page="/global/gadgets/formattedPrice.jsp">
                  <dsp:param name="price" value="${discountAmount }"/>
                </dsp:include>
              </dd>
            </dl>
          </dsp:oparam>
        </dsp:droplet>
        
        <%-- Display Shipping --%>
        <dl class="shipping">
          <dt><fmt:message key="common.shipping"/></dt>
          <dd>
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${shipping }"/>
            </dsp:include>
          </dd>
        </dl>
        
         <%-- Display Tax --%>
        <dl class="tax">
          <dt><fmt:message key="common.tax"/></dt>
          <dd>
            <dsp:getvalueof var="tax" vartype="java.lang.Double" param="order.priceInfo.tax" />
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${tax }"/>
            </dsp:include>
          </dd>
        </dl>
        
        
        <%-- Coupon code gadget --%>
        <c:if test="${empty submittedOrder}">
          <dsp:getvalueof var="skipForm" vartype="java.lang.Boolean" param="skipCouponFormDeclaration"/>
          <c:choose>
            <c:when test="${skipForm}">
              <dsp:include page="/cart/gadgets/promotionCode.jsp" />
            </c:when>
            <c:otherwise>
              <dsp:form action="${pageContext.request.requestURI}" method="post" name="couponform" formid="couponform">
                <dsp:include page="/cart/gadgets/promotionCode.jsp" />
              </dsp:form>
            </c:otherwise>
          </c:choose>
        </c:if>
        
        <%-- Display Store Credit --%>
        <c:choose>
          <c:when test="${empty submittedOrder}">
            <dsp:include page="/checkout/gadgets/onlineCredit.jsp" />
          </c:when>
          <c:otherwise>
            <dsp:include page="/checkout/gadgets/storeCreditPayment.jsp" />
          </c:otherwise>
        </c:choose>
        

        <c:choose>
          <c:when test="${not empty storeCreditAmount and storeCreditAmount > 0}">
            <dl class="shipping">
              <dt><fmt:message key="checkout_onlineCredit.useOnlineCredit"/></dt>
                     
              <dd>
                -
                <c:choose>
                  <c:when test="${empty submittedOrder}">
                    <%-- If order's amount is completely covered with store credit
                         display only store credit amount that will be applied to the order. --%>
                    <dsp:droplet name="Compare">
                      <dsp:param name="obj1" param="order.priceInfo.total" />
                      <dsp:param name="obj2" value="${storeCreditAmount}" number="0.0" />
                      <dsp:oparam name="greaterthan">
                        <dsp:include page="/global/gadgets/formattedPrice.jsp">
                          <dsp:param name="price" value="${storeCreditAmount }"/>
                        </dsp:include>
                      </dsp:oparam>
                      <dsp:oparam name="default">
                        <c:set var="orderIsCoveredWithStoreCredit" value="true"/>
                        <dsp:include page="/global/gadgets/formattedPrice.jsp">
                          <dsp:param name="price" param="order.priceInfo.total" />
                        </dsp:include>
                      </dsp:oparam>
                    </dsp:droplet>
                  </c:when>
                  <c:otherwise>
                    <dsp:include page="/global/gadgets/formattedPrice.jsp">
                      <dsp:param name="price" value="${storeCreditAmount }"/>
                    </dsp:include>
                  </c:otherwise>
                </c:choose>
              </dd>
            </dl>
          </c:when>
          <c:otherwise>
            <c:set var="storeCreditAmount" value="0"/>
          </c:otherwise>
        </c:choose>
        
        <div class="atg_store_appliedOrderDiscounts">
          <%--
            Display all available pricing adjustments except the first one.
            The first adjustment is always order's raw subtotal, and hence doesn't contain a discount.
          --%>
          <c:forEach var="priceAdjustment" varStatus="status" items="${order.priceInfo.adjustments}" begin="1">
            <c:out value="*"/>
            <dsp:tomap var="pricingModel" value="${priceAdjustment.pricingModel}"/>
            <c:out value="${pricingModel.description}" escapeXml="false"/>
            <br/>
          </c:forEach>
        </div>
        
        </li>
    
        <li class="atg_store_orderTotal">
          <dl class="total">
            <dt><fmt:message key="common.total"/><fmt:message key="common.labelSeparator"/></dt>
            <dd>
              <dsp:getvalueof var="total" vartype="java.lang.Double" param="order.priceInfo.total" />

              <c:set var="orderPrice" value="0"/>
              <c:if test="${!orderIsCoveredWithStoreCredit}">
                <c:set var="orderPrice" value="${total - storeCreditAmount}"/>
              </c:if>

              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${orderPrice}"/>
              </dsp:include>
            </dd>
          </dl>
          
          <c:if test="${empty submittedOrder}">
            <%-- Action items for --%>
            <c:if test="${not empty isShoppingCart}">
              <dsp:include page="/cart/gadgets/actionItems.jsp" />
            </c:if>
            <%-- display 'Place My Order' area --%>
            <c:if test="${(not empty currentStage) and (currentStage == 'confirm')}">
              <dsp:include page="/checkout/gadgets/confirmControls.jsp">
                <dsp:param name="expressCheckout" param="expressCheckout"/>
              </dsp:include>
            </c:if>
          </c:if>
        </li>
        

      </ul>
      
     </c:if>
    
    <c:if test="${empty submittedOrder}"> 
      <dsp:include page="/navigation/gadgets/clickToCallLink.jsp">
        <dsp:param name="pageName" value="cartSummary"/>
      </dsp:include>
    </c:if>
  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/checkoutOrderSummary.jsp#1 $$Change: 633540 $--%>