<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:setvalue bean="Profile.currentLocation" value="checkout"/>
<html>
<head>
<title>Order Purchased</title>
</head>

<body>

<i>location: <dsp:valueof bean="Profile.currentLocation"/></i><BR>
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a><BR>
<P>

<h3>Order Purchased</h3>

<strong>Order Confirmation Number: <dsp:valueof bean="ShoppingCart.current.id"/></strong>
<P>

<table cellspacing=0 cellpadding=0 border=0 width=100%>
<tr valign=top><td><table cellspacing=2 cellpadding=0 border=0>
<tr>
<td><b>Quantity</b></td>
<td></td>
<td>&nbsp;&nbsp;</td>
<td><b>Product</b></td>
<td>&nbsp;&nbsp;</td>
<td><b>SKU</b></td>
<td>&nbsp;&nbsp;</td>
<td align=right><b>List Price</b></td>
<td>&nbsp;&nbsp;</td>
<td align=right><b>Total Price</b></td>
</tr>

<tr><td colspan=10><hr size=0></td></tr>


<dsp:droplet name="ForEach">
  <dsp:param bean="ShoppingCart.current.commerceItems" name="array"/>
  <dsp:param name="elementName" value="item"/>
  <dsp:oparam name="output">
<tr valign=top>
<td>
<dsp:valueof param="item.quantity"/>
</td>
<td></td>
<td></td>
<td>
<dsp:getvalueof id="pval0" param="item.auxiliaryData.productRef"><dsp:include page="product_fragment.jsp"><dsp:param name="childProduct" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>
<!--<br><i>Ship to 'me'</i><br><i>Assembled</i>-->
</td>
<td>&nbsp;&nbsp;</td>
<td>
<dsp:valueof param="item.auxiliaryData.catalogRef.displayName"/>
</td>
<td>&nbsp;&nbsp;</td>
<td align=right>
<dsp:valueof converter="currency" param="item.priceInfo.listPrice">no price</dsp:valueof>
</td>
<td>&nbsp;&nbsp;</td>
<td align=right>
<dsp:valueof converter="currency" param="item.priceInfo.amount">no price</dsp:valueof>
</td>
</tr>
  </dsp:oparam>

  <dsp:oparam name="empty"><tr valign=top><td>No Items</td></tr></dsp:oparam>
</dsp:droplet>

<tr><td colspan=10><hr size=0></td></tr>
<tr>
<td colspan=4 align=right>Subtotal</td>
<td>
<dsp:valueof bean="ShoppingCart.current.priceInfo.rawSubTotal" converter="currency">no price</dsp:valueof>
</td>
<td align=right></td>
</tr>

<tr>
<td colspan=2 align=right></td>
<td></td>
<td align=right>Shipping</td>
<td>
<dsp:valueof bean="ShoppingCart.current.priceInfo.shipping" converter="currency">no price</dsp:valueof>
</td>
<td align=right></td>
</tr>

<tr>
<td colspan=4 align=right>Tax</td>
<td>
<dsp:valueof bean="ShoppingCart.current.priceInfo.tax" converter="currency">no price</dsp:valueof>
</td>
<td align=right></td>
</tr>
        
<tr>
<td colspan=4 align=right>Total</td>
<td>
<dsp:valueof bean="ShoppingCart.current.priceInfo.amount" converter="currency">no price</dsp:valueof>
</td>
<td align=right><b></b></td>
</tr>
</table>
</table>

<table>
<tr>
<td>
<i>Ship via <dsp:valueof bean="ShoppingCart.current.shippingGroups[0].shippingMethod"/> to:</i><BR>
<dsp:valueof bean="ShoppingCart.current.shippingGroups[0].shippingAddress.firstName"/>
<dsp:valueof bean="ShoppingCart.current.shippingGroups[0].shippingAddress.lastName"/><BR>
<dsp:valueof bean="ShoppingCart.current.shippingGroups[0].shippingAddress.addressLine1"/><BR>
<dsp:valueof bean="ShoppingCart.current.shippingGroups[0].shippingAddress.city"/>, 
<dsp:valueof bean="ShoppingCart.current.shippingGroups[0].shippingAddress.state"/> 
<dsp:valueof bean="ShoppingCart.current.shippingGroups[0].shippingAddress.postalCode"/><BR>
</td>

<td>
<i>Payment Information:</i><BR>
<dsp:valueof bean="ShoppingCart.current.paymentGroups[0].billingAddress.firstName"/>
<dsp:valueof bean="ShoppingCart.current.paymentGroups[0].billingAddress.lastName"/><BR>
<dsp:valueof bean="ShoppingCart.current.paymentGroups[0].billingAddress.addressLine1"/><BR>
<dsp:valueof bean="ShoppingCart.current.paymentGroups[0].billingAddress.city"/>, 
<dsp:valueof bean="ShoppingCart.current.paymentGroups[0].billingAddress.state"/> 
<dsp:valueof bean="ShoppingCart.current.paymentGroups[0].billingAddress.postalCode"/><BR>
</td>
</tr>
<tr>
<td></td>
<td>
Credit Card: <dsp:valueof bean="ShoppingCart.current.paymentGroups[0].creditCardType"/> 
<dsp:valueof bean="ShoppingCart.current.paymentGroups[0].creditCardNumber" converter="creditcard"/><BR>
Expiration Date: <dsp:valueof bean="ShoppingCart.current.paymentGroups[0].expirationMonth"/>/<dsp:valueof bean="ShoppingCart.current.paymentGroups[0].expirationYear"/>
</td>
</tr>
</table>

</body>
</html>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/order_purchased.jsp#2 $$Change: 635969 $--%>
