<dsp:page>

  <%-- 
      This gadget renders either the text box to submit a promotion code, or a message displaying
      the applied promotion code with a "Remove Coupon" button 

      Form Condition:
      - This gadget must be contained inside of a form.
        CartFormHandler must be invoked from a submit 
        button in the form for these fields to be processed
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>

  <dsp:getvalueof var="couponCode" bean="ShoppingCart.current.couponCode"/>
  <dsp:getvalueof var="editCoupon" param="editCoupon"/>
  <dsp:getvalueof var="requestURI" bean="/OriginatingRequest.requestURI"/>
  <dsp:getvalueof var="useInternalForm" param="useInternalForm"/>
  <dsp:getvalueof var="expressCheckout" param="expressCheckout"/>
  <dsp:getvalueof var="nickName" param="nickName"/>
  <dsp:getvalueof var="selectedAddress" param="selectedAddress"/>
  <dsp:getvalueof var="successURL" param="successURL"/>
  
  <%-- Build the redirect url. --%>
  <c:choose>
    <%--
    If we have the nickName, selectedAddress and successURL parameters then we
    are on the shippingAddressEdit.jsp from the single shipping screen editing
    an address and need to pass these parameters back to the jsp.
    --%>
    <c:when test="${not empty nickName &&  not empty selectedAddress && not empty successURL}">
      <c:url var="couponTargetUrl" value="${requestURI}" context="/">
        <c:param name="nickName" value="${nickName }"/>
        <c:param name="selectedAddress" value="${selectedAddress }"/>
        <c:param name="successURL" value="${successURL }"/>
      </c:url>
    </c:when>
    <%--
    If we have the nickName and successURL parameters then we are on the 
    shippingAddressEdit.jsp from another screen, editing an address and need
    to pass these parameters back to the jsp.
    --%>
    <c:when test="${not empty nickName && not empty successURL}">
      <c:url var="couponTargetUrl" value="${requestURI}" context="/">
        <c:param name="nickName" value="${nickName }"/>
        <c:param name="successURL" value="${successURL }"/>
      </c:url>
    </c:when>
    <c:otherwise>
      <c:set var="couponTargetUrl" value="${requestURI}"/>
    </c:otherwise>
  </c:choose>
  
  <c:if test="${expressCheckout}">
    <c:url var="couponTargetUrl" value="${couponTargetUrl}" context="/">
      <c:param name="expressCheckout" value="true"/>
    </c:url>
  </c:if>

  <%--
    If there is an 'editCard' specified on the B2CProfileFormHandler, we should re-post it with the next request.
    This property specifies, which user's credit card should be edited, and it's mandatory for /checkout/creditCardEdit.jsp page.
    That's why we have to re-post it when applying coupon.
  --%>
  <dsp:getvalueof var="selectedCard" vartype="java.lang.String" bean="/atg/userprofiling/B2CProfileFormHandler.editCard"/>
  <c:if test="${not empty selectedCard}">
    <dsp:input bean="/atg/userprofiling/B2CProfileFormHandler.editCard" type="hidden" value="${selectedCard}"/>
  </c:if>
  
  <dl class="couponCode"> 
  <c:choose>
    <c:when test="${not empty couponCode}">
      <c:choose>
        <c:when test="${not empty editCoupon}">
          <dt>
            <fmt:message key="common.cart.promotionCode"/>
          </dt>

          <dd>
            <dsp:input bean="CouponFormHandler.couponCode" priority="10"
                  type="text" id="atg_store_promotionCodeInput" 
                  value="${couponCode}" autocomplete="off">
                  <dsp:tagAttribute name="dojoType" value="atg.store.widget.enterSubmit" />
                  <dsp:tagAttribute name="targetButton" value="atg_store_applyCoupon" />
              </dsp:input>

            <fmt:message var="updateTotalMsg" key="common.button.updateTotalText" />
            <dsp:input iclass="atg_store_textButton" id="atg_store_applyCoupon" bean="CouponFormHandler.claimCoupon" type="submit" value="${updateTotalMsg}"/>
          </dd>
        </c:when>
        <c:otherwise>
          <dt>
            <fmt:message key="common.cart.promotionCode"/>
          </dt>

          <dd>
            <%-- Use hidden coupon field to maintain the existing coupon code as an
                 empty coupon code will trigger it's removal --%>
            <dsp:input bean="CouponFormHandler.couponCode" priority="10"
                      type="hidden" id="atg_store_promotionCodeInput" value="${couponCode}"/>

            <span>
              <fmt:message key="cart_promotionCode.orderMsg">
                <fmt:param value="${fn:toUpperCase(couponCode)}"/>
              </fmt:message>
            </span>

            <%--
              If there is an 'editCard' specified on the B2CProfileFormHandler, we should re-post it with the next request.
              This property specifies, which user's credit card should be edited, and it's mandatory for /checkout/creditCardEdit.jsp page.
              That's why we have to re-post it when applying coupon.
            --%>
            <dsp:a href="${couponTargetUrl}" bean="/atg/userprofiling/B2CProfileFormHandler.editCard"
                   beanvalue="/atg/userprofiling/B2CProfileFormHandler.editCard">
              <dsp:param name="editCoupon" value="true"/>
              <fmt:message key="common.button.editText"/>
            </dsp:a>
          </dd>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
      <dt>
        <fmt:message key="common.cart.promotionCode"/>
      </dt>

      <dd>
        <dsp:input bean="CouponFormHandler.couponCode" priority="10"
            type="text" id="atg_store_promotionCodeInput" autocomplete="off">
            <dsp:tagAttribute name="dojoType" value="atg.store.widget.enterSubmit" />
            <dsp:tagAttribute name="targetButton" value="atg_store_applyCoupon" />
        </dsp:input>

        <fmt:message var="updateTotalMsg" key="common.button.updateTotalText" />
        <dsp:input iclass="atg_store_textButton" id="atg_store_applyCoupon" bean="CouponFormHandler.claimCoupon" type="submit" value="${updateTotalMsg}"/>
      </dd>
    </c:otherwise>
  </c:choose>
  </dl>  
    
  <dsp:input bean="CouponFormHandler.applyCouponSuccessURL" type="hidden" value="${couponTargetUrl}"/>
  <dsp:input bean="CouponFormHandler.applyCouponErrorURL" type="hidden" value="${couponTargetUrl}"/>
  <dsp:input bean="CouponFormHandler.editCouponSuccessURL" type="hidden"  value="${couponTargetUrl}"/>
  <dsp:input bean="CouponFormHandler.editCouponErrorURL"  type="hidden"  value="${couponTargetUrl}"/>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/promotionCode.jsp#2 $$Change: 633752 $--%>