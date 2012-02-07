<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/commerce/order/purchase/ExpressCheckoutFormHandler"/>

The ExpressCheckoutFormHandler is used to expedite the checking out of an Order. This
supports creating a maximum of one Profile derived HardgoodShippingGroup and one Profile derived
CreditCard, followed by committing the Order.

<p><b>Shipping Information</b>
<br><dsp:getvalueof id="pval0" bean="Profile.defaultShippingAddress"><dsp:include page="display_address.jsp"><dsp:param name="address" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>

<p><b>Shipping Method</b>
<br><dsp:valueof bean="Profile.defaultCarrier"/>

<p><b>Billing Information</b>
<br><dsp:valueof bean="Profile.defaultPaymentType.creditCardType"/>
<dsp:valueof bean="Profile.defaultPaymentType.creditCardNumber" converter="creditcard"/>

<p><b>Billing Address</b>
<br><dsp:getvalueof id="pval0" bean="Profile.defaultBillingAddress"><dsp:include page="display_address.jsp"><dsp:param name="address" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>

<dsp:form action="exp_checkout.jsp" method="POST">

<dsp:droplet name="/atg/dynamo/droplet/Switch">
<dsp:param bean="ExpressCheckoutFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
      <dsp:param bean="ExpressCheckoutFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
    </UL></STRONG></font>
</dsp:oparam>
</dsp:droplet>

<dsp:input bean="ExpressCheckoutFormHandler.expressCheckoutSuccessURL" type="hidden" value="order_commit.jsp"/>

<dsp:input bean="ExpressCheckoutFormHandler.expressCheckout" type="submit" value="Checkout"/>
</dsp:form>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/exp_checkout.jsp#2 $$Change: 635969 $--%>
