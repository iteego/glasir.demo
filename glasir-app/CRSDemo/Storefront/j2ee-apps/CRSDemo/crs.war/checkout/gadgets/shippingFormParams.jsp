<%-- 
  This container page contains hidden input param for shipping info form
--%>

<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>

  <%-- If user is anonymous and the session has expired, the cart looses its contents ,
       so the page gets redirected to the home page else it will be redirected to the
       checkout login page. --%>
  <dsp:droplet name="Compare">
    <dsp:param bean="Profile.securityStatus" name="obj1"/>
    <dsp:param bean="PropertyManager.securityStatusAnonymous" name="obj2"/>
    <dsp:oparam name="equal">
      <%-- User is anonymous --%>
      <dsp:input type="hidden" bean="ShippingGroupFormHandler.sessionExpirationURL" value="${originatingRequest.contextPath}/index.jsp"/>
    </dsp:oparam>
    <dsp:oparam name="default">
      <dsp:input type="hidden" bean="ShippingGroupFormHandler.sessionExpirationURL" value="${originatingRequest.contextPath}/checkout/login.jsp"/>
    </dsp:oparam>
  </dsp:droplet>
  
  <dsp:input type="hidden" bean="ShippingGroupFormHandler.moveToBillingSuccessURL" value="shippingMethod.jsp"/>
  <dsp:input type="hidden" bean="ShippingGroupFormHandler.moveToBillingErrorURL" value="shipping.jsp"/>

  <dsp:input type="hidden" bean="ShippingGroupFormHandler.updateShippingMethodSuccessURL" value="billing.jsp"/>
  <dsp:input type="hidden" bean="ShippingGroupFormHandler.updateShippingMethodErrorURL" value="shippingMethod.jsp"/>


  <dsp:input type="hidden" bean="ShippingGroupFormHandler.address.email" beanvalue="Profile.email"/>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingFormParams.jsp#2 $$Change: 635969 $--%>