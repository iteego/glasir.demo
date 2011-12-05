<%--  
  Tag that will render a "checkout progress" bar and an order summary showing
  items, subtotal, and optionally, shipping & tax charges with a grand total.

  This tag accepts the following attributes:
      
  currentStage (required)
    The current stage of the checkout progress, for use by
    /checkout/gadgets/checkoutProgress.jsp.  Valid values
    out-of-the-box are "giftMessage", "login", "shipping", "shipping_multiple",
    "billing", "confirm", and "success".
          
  showOrderSummary (optional)
    Boolean indicating if the order summary should be shown.
    If not supplied, defaults to "true".

  repriceOrder (optional)
    Boolean indicating if the order should be repriced.
    If not supplied, defaults to "true".

  skipSecurityCheck (optional)
    Boolean indicating if we should skip the check to assure
    a registered user has authenticated.  Generally used on the
    checkout-login page.
    
  showProgressIndicator
    boolean indicating if the checkout progress bar should be shown.
    If not supplied, defaults to "true".

  title
    page title to be displayed.       
    
  formErrorsRenderer (optional, fragment)
    this fragment should render all page errors, these errors will be displayed after checkout page title
--%>

<%@ include file="/includes/taglibs.jspf" %>
<%@ include file="/includes/context.jspf" %>
<%@ attribute name="currentStage" %>
<%@ attribute name="showOrderSummary" %>
<%@ attribute name="showProgressIndicator" %>
<%@ attribute name="skipSecurityCheck" %>
<%@ attribute name="title" %>
<%@ attribute name="formErrorsRenderer" fragment="true"%>

<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
<dsp:importbean bean="/atg/userprofiling/PropertyManager"/>

<%-- By default, reprice order --%>
<c:if test="${empty repriceOrder}">
  <c:set var="repriceOrder" value="true"/>
</c:if>

<%-- By default, show order summary --%>
<c:if test="${empty showOrderSummary}">
  <c:set var="showOrderSummary" value="true"/>
</c:if>

<%-- By default, show checkout progress bar during checkout process --%>
<c:if test="${empty showProgressIndicator}">
  <c:set var="showProgressIndicator" value="true"/>
</c:if>

<dsp:getvalueof var="securityStatusBasicAuth" vartype="java.lang.Integer" bean="PropertyManager.securityStatusBasicAuth"/>
<dsp:getvalueof var="securityStatusCookie" vartype="java.lang.Integer" bean="PropertyManager.securityStatusCookie"/>
<dsp:getvalueof var="currentSecurityStatus" vartype="java.lang.Integer" bean="Profile.securityStatus"/>
<c:choose>
  <c:when test="${skipSecurityCheck != true && ((currentSecurityStatus == securityStatusCookie)
                                              || currentSecurityStatus == securityStatusBasicAuth)}">
    <jsp:include page="/checkout/checkoutLoginContainer.jsp"/>
  </c:when>
  <c:otherwise>
    <dsp:getvalueof var="commerceItemCount" vartype="java.lang.String" bean="ShoppingCart.current.commerceItemCount"/>
    <c:choose>
      <c:when test="${commerceItemCount == '0' && currentStage != 'success' && currentStage != 'login' && currentStage != 'register'}">
        <div id="atg_store_cantCheckoutMessage">
          <fmt:message key="checkout_checkoutForm.invalidOrder"/>
        </div>
      </c:when>
      <c:otherwise>
        <div class="atg_store_nonCatHero">
        <div id="atg_store_checkoutProgress">
          <h2 class="title">${title}</h2>
      
          <%-- Checkout progress indicator --%>
          <c:if test="${showProgressIndicator == true}">
            <dsp:include page="/checkout/gadgets/checkoutProgress.jsp" flush="true">
              <dsp:param name="currentStage" value="${currentStage}"/>
            </dsp:include>
          </c:if>
          </div>
          
          <%-- Reprice order --%>
          <c:if test="${repriceOrder == true}">
            <dsp:include page="gadgets/repriceOrderTotal.jsp" flush="true">
              <dsp:param name="formhandlerComponent" value="/atg/store/order/purchase/BillingFormHandler"/>
            </dsp:include>
          </c:if>
        </div>
        
        <%-- Display error messages --%>
        <jsp:invoke fragment="formErrorsRenderer"/>
        
        <%-- Order summary --%>
        <c:if test="${showOrderSummary}">
          <dsp:include page="/checkout/gadgets/checkoutOrderSummary.jsp">
            <dsp:param name="order" bean="ShoppingCart.current"/>
            <dsp:param name="currentStage" value="${currentStage}"/>
          </dsp:include>
        </c:if>
        
        <jsp:doBody/>
        
      </c:otherwise>
    </c:choose>
  </c:otherwise>
</c:choose>
<%-- @version $Id$$Change$--%>
