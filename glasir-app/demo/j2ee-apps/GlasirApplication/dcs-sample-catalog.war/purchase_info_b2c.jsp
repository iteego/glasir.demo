<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsNull"/>
<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/commerce/order/purchase/ExpressCheckoutFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/commerce/pricing/UserPricingModels"/>
<dsp:importbean bean="/atg/commerce/pricing/AvailableShippingMethods"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:setvalue bean="Profile.currentLocation" value="checkout"/>
<html>
<head>
<title>Purchase Information</title>
</head>

<body>
<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
<dsp:a href="product_search.jsp">Product Search</dsp:a> - 
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a> - 
<dsp:a href="lists.jsp">My Lists</dsp:a> - 
<dsp:a href="comparison.jsp">Product Comparison</dsp:a> -
<dsp:a href="giftlist_search.jsp">Gift List Search</dsp:a> - 
<dsp:droplet name="/atg/dynamo/droplet/Switch">
  <dsp:param bean="/atg/userprofiling/Profile.transient" name="value"/>
  <dsp:oparam name="false">
    <dsp:a href="logout.jsp">Logout</dsp:a>
  </dsp:oparam>
  <dsp:oparam name="true">
    <dsp:a href="login.jsp">Login</dsp:a> or <dsp:a href="register.jsp">Register</dsp:a>
  </dsp:oparam>
</dsp:droplet>
<BR>
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i>

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

<dsp:form action="purchase_info.jsp" method="post">
<dsp:input bean="ExpressCheckoutFormHandler.commitOrder" type="hidden" value="false"/>
<dsp:input bean="ExpressCheckoutFormHandler.paymentGroupNeeded" type="hidden" value="false"/>
<dsp:input bean="ExpressCheckoutFormHandler.shippingGroupNeeded" type="hidden" value="false"/>
<dsp:input bean="ExpressCheckoutFormHandler.expressCheckoutSuccessURL" type="hidden" value="order_confirmation.jsp"/>

<strong>Purchase Information</strong>

<table>
<tr><td colspan=20><i>Shipping Information</i></td></tr>

<tr>
<td>
<table>

<tr>
<td>Shipping Method</td>
<td>
<table>
<tr>
<td>
<dsp:droplet name="AvailableShippingMethods">
<dsp:param bean="ExpressCheckoutFormHandler.shippingGroup" name="shippingGroup"/>
<dsp:oparam name="output">
<dsp:select bean="ExpressCheckoutFormHandler.shippingGroup.shippingMethod">
<dsp:droplet name="ForEach">
  <dsp:param name="array" param="availableShippingMethods"/>
  <dsp:param name="elementName" value="method"/>
  <dsp:oparam name="output">
  <dsp:option paramvalue="method"/><dsp:valueof param="method"/>
  </dsp:oparam>
</dsp:droplet>
</dsp:select>
</dsp:oparam>
</dsp:droplet>
</td>

<td colspan=20>
<dsp:droplet name="IsNull">
<dsp:param bean="ExpressCheckoutFormHandler.shippingGroup.specialInstructions.allowPartialShipment" name="value"/>
<dsp:oparam name="true">
<dsp:droplet name="Switch">
<dsp:param bean="Profile.allowPartialShipment" name="value"/>
<dsp:oparam name="true">
<dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.specialInstructions.allowPartialShipment" type="checkbox" checked="<%=true%>" value="true"/> Allow Partial Shipments
</dsp:oparam>
<dsp:oparam name="false">
<dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.specialInstructions.allowPartialShipment" type="checkbox" value="true"/> Allow Partial Shipments
</dsp:oparam>
</dsp:droplet>
</dsp:oparam>
<dsp:oparam name="false">
<dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.specialInstructions.allowPartialShipment" type="checkbox"/> Allow Partial Shipments
</dsp:oparam>
</dsp:droplet>
<BR>
<i>(<dsp:a href="allow_partial.jsp"><dsp:param name="returnURL" value="purchase_info.jsp"/>
change profile setting</dsp:a>)</i>

</td>
</tr>
</table>
</td>
</tr>

<tr>
<td>First Name:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.firstName" beanvalue="Profile.firstName" size="30" type="text"/></td>
</tr>
<tr>
<td>Middle Name:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.middleName" beanvalue="Profile.middleName" size="30" type="text"/></td>
</tr>
<tr>
<td>Last Name:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.lastName" beanvalue="Profile.lastName" size="30" type="text"/></td>
</tr>
<tr>
<td>Email Address:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.email" beanvalue="Profile.email" size="30" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Phone Number:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.phoneNumber" beanvalue="Profile.daytimeTelephoneNumber" size="10" type="text"/></td>
</tr>
</table>
</td>

<td>
<table>
<tr>
<td>Address:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.address1" beanvalue="Profile.shippingAddress.address1" size="30" type="text"/></td>
</tr>
<tr>
<td>Address (line 2):</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.address2" beanvalue="Profile.shippingAddress.address2" size="30" type="text"/></td>
</tr>
<tr>
<td>City:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.city" beanvalue="Profile.shippingAddress.city" size="30" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>State:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.state" maxsize="2" beanvalue="Profile.shippingAddress.state" size="2" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Postal Code:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.postalCode" beanvalue="Profile.shippingAddress.postalCode" size="10" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Country:</td><td><dsp:input bean="ExpressCheckoutFormHandler.shippingGroup.shippingAddress.country" beanvalue="Profile.shippingAddress.country" size="10" type="text"/></td>
</tr>
</table>
</td>
</tr>

<tr>
<td colspan=20><i>Payment Information</i></td></tr>
</td>
</tr>

<tr>
<td>
<table>
<tr>
<td>First Name:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.firstName" beanvalue="Profile.firstName" size="30" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Middle Name:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.middleName" beanvalue="Profile.middleName" size="30" type="text"/></td>
</tr>
<tr>
<td>Last Name:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.lastName" beanvalue="Profile.lastName" size="30" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Email Address:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.email" beanvalue="Profile.email" size="30" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Phone Number:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.phoneNumber" beanvalue="Profile.daytimeTelephoneNumber" size="10" type="text"/></td>
</tr>

<tr>
<td>Credit Card Type:</td>
<td><dsp:select bean="ExpressCheckoutFormHandler.paymentGroup.creditCardType" required="<%=true%>">
<dsp:option value="Visa"/>Visa
<dsp:option value="MasterCard"/>Master Card
<dsp:option value="americanExpress"/>American Express
<dsp:option value="Discover"/>Discover
</dsp:select>
</td>
</tr>

<tr>
<td>
Number:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.creditCardNumber" maxsize="20" size="20" type="text" value="4111111111111111" required="<%=true%>"/>
</td>
</tr>
<tr>
<td>Expiration Date:</td>
<td>
Month: <dsp:select bean="ExpressCheckoutFormHandler.paymentGroup.expirationMonth">
<dsp:option value="1"/>January
<dsp:option value="2"/>February
<dsp:option value="3"/>March
<dsp:option value="4"/>April
<dsp:option value="5"/>May
<dsp:option value="6"/>June
<dsp:option value="7"/>July
<dsp:option value="8"/>August
<dsp:option value="9"/>September
<dsp:option value="10"/>October
<dsp:option value="11"/>November
<dsp:option value="12"/>December
</dsp:select>
Year: <dsp:select bean="ExpressCheckoutFormHandler.paymentGroup.expirationYear">
<dsp:option value="2005"/>2005
<dsp:option value="2006"/>2006
<dsp:option value="2007"/>2007
<dsp:option value="2008"/>2008
<dsp:option value="2009"/>2009
<dsp:option value="2010"/>2010
<dsp:option value="2011"/>2011
<dsp:option value="2012"/>2012
</dsp:select>
</td>
</tr>

<tr>
<td><dsp:input bean="ExpressCheckoutFormHandler.expressCheckout" type="submit" value="Confirm Order"/></td>
</tr>

</table>
</td>

<td>
<table>
<tr>
<td>Address:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.address1" beanvalue="Profile.billingAddress.address1" size="30" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Address (line 2):</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.address2" beanvalue="Profile.billingAddress.address2" size="30" type="text"/></td>
</tr>
<tr>
<td>City:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.city" beanvalue="Profile.billingAddress.city" size="30" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>State:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.state" maxsize="2" beanvalue="Profile.billingAddress.state" size="2" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Postal Code:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.postalCode" beanvalue="Profile.billingAddress.postalCode" size="10" type="text" required="<%=true%>"/></td>
</tr>
<tr>
<td>Country:</td><td><dsp:input bean="ExpressCheckoutFormHandler.paymentGroup.billingAddress.country" beanvalue="Profile.billingAddress.country" size="10" type="text"/></td>
</tr>

<tr>
<td>
</td>
</tr>

</table>
</td>
</tr>

<tr>
<td>
<table>

</table>
</td>
</tr>

</table>



</dsp:form>
</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/purchase_info_b2c.jsp#2 $$Change: 635969 $--%>
