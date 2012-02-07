<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>

<dsp:setvalue bean="Profile.currentLocation" value="checkout"/>

<html>
<head>
<title>Order Finalized</title>
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

<h3>Order Finalized</h3>

<strong>Order Confirmation Number</strong>: <dsp:valueof bean="ShoppingCart.last.id"/></ul>

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
<td align=right><b>Sale Price</b></td>
<td>&nbsp;&nbsp;</td>
<td align=right><b>Total Price</b></td>
</tr>

<tr><td colspan=15><hr size=0></td></tr>


<dsp:droplet name="ForEach">
  <dsp:param bean="ShoppingCart.last.commerceItems" name="array"/>
  <dsp:param name="elementName" value="item"/>
  <dsp:oparam name="output">
<tr valign=top>
<td>
<dsp:valueof param="item.quantity"/>
</td>
<td></td>
<td></td>
<td><dsp:valueof param="item.auxiliaryData.productRef.displayName"/></td>
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
<dsp:droplet name="Switch">
<dsp:param name="value" param="item.priceInfo.onSale"/>
<dsp:oparam name="true"><dsp:valueof converter="currency" param="item.priceInfo.salePrice"/></dsp:oparam>
</dsp:droplet>
</td>
<td>&nbsp;&nbsp;</td>
<td align=right>
<dsp:valueof converter="currency" param="item.priceInfo.amount">no price</dsp:valueof>
</td>
</tr>
  </dsp:oparam>

  <dsp:oparam name="empty"><tr valign=top><td>No Items</td></tr></dsp:oparam>
</dsp:droplet>

<tr><td colspan=15><hr size=0></td></tr>
<tr>
<td colspan=4 align=right>Subtotal</td>
<td>
<dsp:valueof bean="ShoppingCart.last.priceInfo.amount" converter="currency">no price</dsp:valueof>
</td>
<td align=right></td>
</tr>

<tr>
<td colspan=2 align=right></td>
<td></td>
<td align=right>Shipping</td>
<td>
<dsp:valueof bean="ShoppingCart.last.priceInfo.shipping" converter="currency">no price</dsp:valueof>
</td>
<td align=right></td>
</tr>

<tr>
<td colspan=4 align=right>Tax</td>
<td>
<dsp:valueof bean="ShoppingCart.last.priceInfo.tax" converter="currency">no price</dsp:valueof>
</td>
<td align=right></td>
</tr>
        
<tr>
<td colspan=4 align=right>Total</td>
<td>
<dsp:valueof bean="ShoppingCart.last.priceInfo.total" converter="currency">no price</dsp:valueof>
</td>
<td align=right><b></b></td>
</tr>
</table>
</table>

<b>Shipping Information</b><BR>

<dsp:droplet name="ForEach">
  <dsp:param bean="ShoppingCart.last.shippingGroups" name="array"/>
  <dsp:param name="elementName" value="ShippingGroup"/>
  <dsp:param name="indexName" value="shippingGroupIndex"/>

  <%-- 
    First output all of the address information for this shipping group.  We
    code the page so that it works for both B2C and B2B cases by handling both
    shipping group types, hardgoodShippingGroup and b2bHardgoodShippingGroup
  --%>

  <dsp:oparam name="output">

    <dsp:droplet name="Switch">
      <dsp:param name="value" param="ShippingGroup.shippingGroupClassType"/>

      <dsp:oparam name="hardgoodShippingGroup"> 
        <i>Ship via <dsp:valueof param="ShippingGroup.shippingMethod"/> to:</i><BR>
	<dsp:include page="display_shipping_address.jsp">
	  <dsp:param name="address" param="ShippingGroup.shippingAddress"/>
	</dsp:include>
      </dsp:oparam>    

      <dsp:oparam name="b2bHardgoodShippingGroup"> 
        <i>Ship via <dsp:valueof param="ShippingGroup.shippingMethod"/> to:</i><BR>
	<dsp:include page="display_shipping_address.jsp">
	  <dsp:param name="address" param="ShippingGroup.shippingAddress"/>
	</dsp:include>
      </dsp:oparam>    

      <dsp:oparam name="electronicShippingGroup">
       <p><i>Email to:</i><br>
       <dsp:valueof param="ShippingGroup.emailAddress"/>
      </dsp:oparam>

    </dsp:droplet> <!-- End switch on type of shipping Group -->

    <dsp:droplet name="Switch">
    <dsp:param name="value" param="ShippingGroup.specialInstructions.allowPartialShipment"/>
    <dsp:oparam name="true">Allow partial shipments</dsp:oparam>
    <dsp:oparam name="false">Do not allow partial shipments</dsp:oparam>
    </dsp:droplet>

  </dsp:oparam>
</dsp:droplet>  


<br><P>

<%-- 
  Display payment group information, using different display techniques for
  B2B vs. B2C cases.  In the B2B case we assume that an order may have multiple
  payment groups and iterate over them with a ForEach droplet, displaying a 
  summary of each one.  

  In the B2C case we assume a single payment group, and further assume that the 
  payment group is a credit card, so we display the billing address for the card
  along with its card number and expiration date.  We could just as easily use
  the ForEach technique in the B2C case, even though it would only find one 
  payment group.
--%>

<dsp:droplet name="ComponentExists">
  <dsp:param name="path" value="/atg/modules/B2BCommerce"/>

  <%-- B2B case: iterate over all payment groups --%>
  <dsp:oparam name="true">
  <b>Payment Information</b><BR>
  <dsp:droplet name="ForEach">
    <dsp:param bean="ShoppingCart.last.PaymentGroups" name="array"/>
    <dsp:param name="elementName" value="PaymentGroup"/>
    <dsp:param name="indexName" value="paymentGroupIndex"/>
    <dsp:oparam name="output">
      <dsp:droplet name="Switch">
	<dsp:param name="value" param="PaymentGroup.paymentGroupClassType"/>
	<dsp:oparam name="creditCard">
	  <BR>Credit Card: <dsp:valueof param="PaymentGroup.creditCardType"/> 
	  <dsp:valueof converter="creditcard" param="PaymentGroup.creditCardNumber"/>
	  <BR>Expiration Date: <dsp:valueof param="PaymentGroup.expirationMonth"/>/<dsp:valueof param="PaymentGroup.expirationYear"/>
	</dsp:oparam>
	<dsp:oparam name="default">
	  <BR><dsp:valueof param="PaymentGroup.paymentGroupClassType"/> <dsp:valueof param="PaymentGroup.id"/>
	</dsp:oparam>
      </dsp:droplet>
      Amount: <dsp:valueof param="PaymentGroup.amount" converter="currency"/>
    </dsp:oparam>
  </dsp:droplet>
  </dsp:oparam>

  <%-- B2C case: display details of the order's single payment group --%> 
  <dsp:oparam name="false">
  <b>Payment Information:</b><BR>
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.firstName"/>
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.middleName"/>
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.lastName"/><BR>
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.address1"/><BR>
  <dsp:droplet name="IsEmpty">
   <dsp:param bean="ShoppingCart.last.paymentGroups[0].billingAddress.address2" name="value"/>
   <dsp:oparam name="false">
     <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.address2"/><BR>
   </dsp:oparam>
  </dsp:droplet>
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.city"/>, 
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.state"/> 
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.postalCode"/><BR>
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.country"/><BR>
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.email"/><BR>
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].billingAddress.phoneNumber"/><BR>

  Credit Card: <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].creditCardType"/> 
  <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].creditCardNumber" converter="creditcard"/><BR>
  Expiration Date: <dsp:valueof bean="ShoppingCart.last.paymentGroups[0].expirationMonth"/>/<dsp:valueof bean="ShoppingCart.last.paymentGroups[0].expirationYear"/>
  <P>
  </dsp:oparam>

</dsp:droplet> 

</body>
</html>
</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/order_commit.jsp#2 $$Change: 635969 $--%>
