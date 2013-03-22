<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/commerce/order/purchase/ExpressCheckoutFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:setvalue bean="Profile.currentLocation" value="checkout"/>
<html>
<head>
<title>Order Confirmation</title>
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

<h3>Order Confirmation</h3>

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

<p>

<dsp:form action="order_confirmation.jsp" method="post">
<dsp:input bean="ExpressCheckoutFormHandler.commitOrder" type="hidden" value="true"/>
<dsp:input bean="ExpressCheckoutFormHandler.paymentGroupNeeded" type="hidden" value="false"/>
<dsp:input bean="ExpressCheckoutFormHandler.shippingGroupNeeded" type="hidden" value="false"/>
<dsp:input bean="ExpressCheckoutFormHandler.expressCheckoutSuccessURL" type="hidden" value="order_commit.jsp"/>

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
  <dsp:param bean="ShoppingCart.current.commerceItems" name="array"/>
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

  <dsp:oparam name="empty">
<tr valign=top>
<td>No Items</td>
</tr>
  </dsp:oparam>
</dsp:droplet>

<tr><td colspan=15><hr size=0></td></tr>
<tr>
<td colspan=4 align=right>Subtotal</td>
<td>
<dsp:valueof bean="ShoppingCart.current.priceInfo.amount" converter="currency">no price</dsp:valueof>
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
<dsp:valueof bean="ShoppingCart.current.priceInfo.total" converter="currency">no price</dsp:valueof>
</td>
<td align=right><b></b></td>
</tr>
</table>
</table>


<b>Shipping Information</b><BR>

<dsp:droplet name="ForEach">
  <dsp:param bean="ShoppingCart.current.ShippingGroups" name="array"/>
  <dsp:param name="elementName" value="ShippingGroup"/>

  <!-- First output all of the address information for this shipping group -->
  <dsp:oparam name="output">

    <dsp:droplet name="Switch">
      <dsp:param name="value" param="ShippingGroup.shippingGroupClassType"/>

      <dsp:oparam name="hardgoodShippingGroup"> 
        <i>Ship via <dsp:valueof param="ShippingGroup.shippingMethod"/> to:</i><BR>
        <dsp:valueof param="ShippingGroup.shippingAddress.firstName"/>
        <dsp:valueof param="ShippingGroup.shippingAddress.middleName"/>
        <dsp:valueof param="ShippingGroup.shippingAddress.lastName"/><BR>
        <dsp:valueof param="ShippingGroup.shippingAddress.address1"/><BR>
        <dsp:droplet name="IsEmpty">
         <dsp:param name="value" param="ShippingGroup.shippingAddress.address2"/>
         <dsp:oparam name="false">
           <dsp:valueof param="ShippingGroup.shippingAddress.address2"/><BR>
         </dsp:oparam>
        </dsp:droplet>
        <dsp:valueof param="ShippingGroup.shippingAddress.city"/>, 
        <dsp:valueof param="ShippingGroup.shippingAddress.state"/> 
        <dsp:valueof param="ShippingGroup.shippingAddress.postalCode"/><BR>
        <dsp:valueof param="ShippingGroup.shippingAddress.country"/><BR>
        <dsp:valueof param="ShippingGroup.shippingAddress.email"/><BR>
        <dsp:valueof param="ShippingGroup.shippingAddress.phoneNumber"/><BR>
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
<b>Payment Information:</b><BR>


<dsp:droplet name="ForEach">
  <dsp:param bean="ShoppingCart.current.PaymentGroups" name="array"/>
  <dsp:param name="elementName" value="PaymentGroup"/>
  <dsp:oparam name="output">

    <dsp:valueof param="PaymentGroup.billingAddress.firstName"/>
    <dsp:valueof param="PaymentGroup.billingAddress.middleName"/>
    <dsp:valueof param="PaymentGroup.billingAddress.lastName"/><BR>
    <dsp:valueof param="PaymentGroup.billingAddress.address1"/><BR>
    <dsp:droplet name="IsEmpty">
     <dsp:param name="value" param="PaymentGroup.billingAddress.address2"/>
     <dsp:oparam name="false">
       <dsp:valueof param="PaymentGroup.billingAddress.address2"/><BR>
     </dsp:oparam>
    </dsp:droplet>
    <dsp:valueof param="PaymentGroup.billingAddress.city"/>, 
    <dsp:valueof param="PaymentGroup.billingAddress.state"/> 
    <dsp:valueof param="PaymentGroup.billingAddress.postalCode"/><BR>
    <dsp:valueof param="PaymentGroup.billingAddress.country"/><BR>
    <dsp:valueof param="PaymentGroup.billingAddress.email"/><BR>
    <dsp:valueof param="PaymentGroup.billingAddress.phoneNumber"/><BR>
    
    Credit Card: <dsp:valueof param="PaymentGroup.creditCardType"/> 
    <dsp:valueof converter="creditcard" param="PaymentGroup.creditCardNumber"/><BR>
    Expiration Date: <dsp:valueof param="PaymentGroup.expirationMonth"/>/<dsp:valueof param="PaymentGroup.expirationYear"/>
    <P>

  </dsp:oparam>
</dsp:droplet>

<dsp:input bean="ExpressCheckoutFormHandler.expressCheckout" type="submit" value="Purchase"/>


</dsp:form>

</body>
</html>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/order_confirm_b2c.jsp#2 $$Change: 635969 $--%>
