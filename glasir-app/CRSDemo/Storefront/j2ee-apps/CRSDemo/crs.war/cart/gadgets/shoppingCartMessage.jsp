<dsp:page>

  <%--
    This page displays the shopping cart message for the user to navigate to further shopping

     Form Condition:
     - This gadget must be contained inside of a form.
       CartFormHandler must be invoked from a submit 
       button in the form for these fields to be processed
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>

  <div id="atg_store_sectionTitle">
    <div class="atg_store_message">
      <h2><fmt:message key="cart_shoppingCartMessage.ItemMsg"/></h2>
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
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/shoppingCartMessage.jsp#2 $$Change: 635969 $--%>
