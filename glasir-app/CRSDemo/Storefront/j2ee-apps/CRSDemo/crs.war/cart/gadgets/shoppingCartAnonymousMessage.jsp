<dsp:page>

  <%--
    This page redirects anonymous users to the login page while going for the checkout process

     Form Condition:
     - This gadget must be contained inside of a form.
       CartFormHandler must be invoked from a submit 
       button in the form for these fields to be processed
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/store/profile/SessionBean"/>

  <div id="atg_store_sectionTitle">
    <div class="atg_store_message">
      <h2><fmt:message key="cart_shoppingCartAnonymousMessage.noItemMsg"/></h2>
      
      <p><fmt:message key="cart_shoppingCartAnonymousMessage.viewMsg">
           <fmt:param>
             <dsp:a page="/global/util/loginRedirect.jsp" bean="SessionBean.values.loginSuccessURL" paramvalue="message">
               <fmt:message key="common.login"/>
             </dsp:a>
           </fmt:param>
         </fmt:message></p>

    </div>
    <crs:continueShopping>
      <dsp:input type="hidden" bean="CartFormHandler.cancelURL"
                 value="${continueShoppingURL}"/>
    </crs:continueShopping>
    <fmt:message key="common.button.continueShoppingText" var="continueShopping"/>
    <div class="atg_store_formActions">
      <span class="atg_store_basicButton secondary">
        <dsp:input type="submit" bean="CartFormHandler.cancel" value="${continueShopping}"/>
      </span>
    </div>
  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/shoppingCartAnonymousMessage.jsp#2 $$Change: 635969 $--%>
