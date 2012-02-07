<dsp:page>

<%--  
    This gadget renders the "continueShopping" "Update", "view favorites" , "Express Checkout", and "Checkout" buttons , on the cart page 

    Form Condition:
    - This gadget must be contained inside of a form.
      CartFormHandler must be invoked from a submit 
      button in this form for fields in this page to be processed
--%>

<dsp:importbean bean="/atg/store/droplet/ExpressCheckoutOk"/>
<dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%--
     On some browsers, when the form is submitted by clicking "Enter" within a
     form field, the parameters represented in the "submit" button will not be posted.
     This will prevent the form handler from working properly.  We add this invisible
     image here to assure the CartFormHandler.handleUpdate() is called, even when
     the form is submitted via the "Enter" key.
     
     <dsp:input type="image" bean="CartFormHandler.update" src="/crsdocroot/images/storefront/spacer.gif"/>
   --%>

  <fmt:message var="continueShoppingText" key="common.button.continueShoppingText"/>
  <fmt:message var="expressCheckoutText" key="common.button.expressCheckoutText"/>
  <fmt:message var="checkoutText" key="common.button.checkoutText"/>

<div class="actions">


     <span class="atg_store_basicButton">
      <dsp:input id="atg_store_checkout" type="submit"
                 bean="CartFormHandler.checkout" value="${checkoutText}"/>
    </span>

      <dsp:input bean="CartFormHandler.continueShoppingErrorURL" type="hidden"
                 beanvalue="/OriginatingRequest.requestURI"/>
                 
        <dsp:droplet name="ExpressCheckoutOk">
          <dsp:param name="profile" bean="Profile"/>
        <dsp:oparam name="true">
        <span class="atg_store_basicButton tertiary">
          <dsp:input id="atg_store_express_checkout" type="submit" bean="CartFormHandler.expressCheckout" value="${expressCheckoutText}"/>
         </span>

        </dsp:oparam>
      </dsp:droplet>
                 
      <crs:continueShopping>
        <dsp:input type="hidden" bean="CartFormHandler.continueShoppingSuccessURL"
                 value="${continueShoppingURL}"/>
      </crs:continueShopping>
    
    <dsp:input id="atg_store_continue" iclass="atg_store_textButton" type="submit" bean="CartFormHandler.continueShopping" value="${continueShoppingText}"/>
</div>  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/actionItems.jsp#2 $$Change: 635969 $--%>
