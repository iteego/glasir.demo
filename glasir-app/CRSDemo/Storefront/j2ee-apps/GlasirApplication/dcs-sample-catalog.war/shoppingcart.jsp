<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/commerce/gifts/GiftShippingGroups"/>
<dsp:importbean bean="/atg/commerce/order/purchase/CartModifierFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>
<dsp:setvalue bean="Profile.currentLocation" value="shopping_cart"/>

<HTML>
<HEAD>
<TITLE>Shopping Cart</TITLE>
</HEAD>

<BODY>
<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
<dsp:a href="product_search.jsp">Product Search</dsp:a> - 
Shopping Cart - 
<dsp:a href="lists.jsp">My Lists</dsp:a> - 
<dsp:a href="comparison.jsp">Product Comparison</dsp:a> -
<dsp:a href="giftlist_search.jsp">Gift List Search</dsp:a> - 
<dsp:droplet name="Switch">
  <dsp:param bean="Profile.transient" name="value"/>
  <dsp:oparam name="false">
    <dsp:a href="logout.jsp">Logout</dsp:a>
  </dsp:oparam>
  <dsp:oparam name="true">
    <dsp:a href="login.jsp">Login</dsp:a> or <dsp:a href="register.jsp">Register</dsp:a>
  </dsp:oparam>
</dsp:droplet>
<BR>
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i>

<P>

<!-- call GiftShippingGroups droplet with parameter order to check for shipping
     groups which contain gifts in a given order and set parameter giftsg -->
<dsp:droplet name="GiftShippingGroups">
<dsp:param bean="ShoppingCart.current" name="order"/>
<dsp:oparam name="true">

  You have some gifts in your order<br>
  <dsp:droplet name="ForEach">
  <dsp:param name="array" param="giftsg"/>
  <dsp:param name="elementName" value="sg"/>
  <dsp:oparam name="output">
    The following gifts are going to <dsp:valueof param="sg.shippingAddress.firstName">unknown</dsp:valueof><br>
    <dsp:droplet name="ForEach">
		  <dsp:param name="array" param="sg.CommerceItemRelationships"/>
			<dsp:param name="elementName" value="CiRelationship"/>
			<dsp:oparam name="output">
			<dsp:valueof param="CiRelationship.Quantity"/>
			<i><dsp:valueof param="CiRelationship.CommerceItem.auxiliaryData.productRef.displayName"/></i><br>
			</dsp:oparam>
    </dsp:droplet> <br>
  </dsp:oparam>
  </dsp:droplet>
</dsp:oparam>
<dsp:oparam name="false">
  You have no gifts in your order
</dsp:oparam>
</dsp:droplet>
<p>

<!-- check if parameter giftId has been passed into page.  if
     it has, then call Buy item from giftlist to move item
     from giftlist to shopping cart -->
<dsp:droplet name="IsEmpty">
<dsp:param name="value" param="giftId"/>
<dsp:oparam name="false">
  <dsp:droplet name="/atg/commerce/gifts/BuyItemFromGiftlist">
    <dsp:param name="giftlistId" param="giftlistId"/>
    <dsp:param name="giftId" param="giftId"/>
  </dsp:droplet>
</dsp:oparam>
</dsp:droplet>
                            
<h3>My Shopping Cart</h3>

<p>

<dsp:droplet name="/atg/dynamo/droplet/Switch">
<dsp:param bean="CartModifierFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
      <dsp:param bean="CartModifierFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
    </UL></STRONG></font>
</dsp:oparam>
</dsp:droplet>

<p>

<dsp:form action="shoppingcart.jsp" method="post">

<%-- 
In the B2B commerce case we want submitting this form to take the user down
the checkout path that begins with the shipping page where she can split 
items among shipping groups, and proceeds to the pages that offer complex
payment options.  In the B2C commerce case we want to skip all of this and
move directly to the consumer-oriented simplified checkout process
--%>

<dsp:droplet name="ComponentExists">
  <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
  <dsp:oparam name="true">
    <dsp:input bean="CartModifierFormHandler.moveToPurchaseInfoByRelIdSuccessURL" type="hidden" value="shipping.jsp?init=true"/>
  </dsp:oparam>
  <dsp:oparam name="false">
    <dsp:input bean="CartModifierFormHandler.moveToPurchaseInfoByRelIdSuccessURL" type="hidden" value="purchase_info.jsp"/>
  </dsp:oparam>
</dsp:droplet>

<dsp:input bean="CartModifierFormHandler.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>

<table cellspacing=0 cellpadding=0 border=0 width=100%>
<tr valign=top><td><table cellspacing=2 cellpadding=0 border=0>
<tr>
<td><b>Delete</b></td>
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
	<dsp:param bean="CartModifierFormHandler.Order.ShippingGroups" name="array"/>
	<dsp:param name="elementName" value="ShippingGroup"/>
	<dsp:param name="indexName" value="shippingGroupIndex"/>

	<dsp:oparam name="output">   			
	<dsp:droplet name="ForEach">
		<dsp:param name="array" param="ShippingGroup.CommerceItemRelationships"/>
		<dsp:param name="elementName" value="CiRelationship"/>
		<dsp:param name="indexName" value="index"/>
		<dsp:oparam name="output">		
			<tr valign=top>
			<td>
				<dsp:input bean="CartModifierFormHandler.removalRelationshipIds" paramvalue="CiRelationship.Id" type="checkbox" checked="<%=false%>"/>
			</td>
			<td>
				<input name='<dsp:valueof param="CiRelationship.Id"/>' size="4" value='<dsp:valueof param="CiRelationship.quantity"/>'>
			</td>
			<td></td>
			<td></td>
			<td>
				<dsp:getvalueof id="pval0" param="CiRelationship.commerceItem.auxiliaryData.productRef"><dsp:include page="product_fragment.jsp"><dsp:param name="childProduct" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>
			</td>
			<td>&nbsp;&nbsp;</td>
			<td>
				<dsp:valueof param="CiRelationship.commerceItem.auxiliaryData.catalogRef.displayName"/>
			</td>
			<td>&nbsp;&nbsp;</td>
			<td align=right>
				<dsp:valueof converter="currency" param="CiRelationship.commerceItem.priceInfo.listPrice">no price</dsp:valueof>
			</td>
			<td>&nbsp;&nbsp;</td>
			<td align=right>
				<dsp:droplet name="Switch">
					<dsp:param name="value" param="CiRelationship.commerceItem.priceInfo.onSale"/>
					<dsp:oparam name="true"><dsp:valueof converter="currency" param="CiRelationship.commerceItem.priceInfo.salePrice"/></dsp:oparam>
				</dsp:droplet>
			</td>
			<td>&nbsp;&nbsp;</td>
			<td align=right>
				<dsp:valueof converter="currency" param="CiRelationship.commerceItem.priceInfo.amount">no price</dsp:valueof>
			</td>
			</tr>
		</dsp:oparam>
		<dsp:oparam name="empty">
			<tr valign=top>
			<td>No Items</td>
			</tr>
		</dsp:oparam>
	</dsp:droplet>				
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

<tr>
<td>
<dsp:input bean="CartModifierFormHandler.setOrderByRelationshipIdErrorURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="CartModifierFormHandler.moveToPurchaseInfoByRelIdErrorURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="CartModifierFormHandler.setOrderByRelationshipId" type="submit" value="Recalculate"/> &nbsp; &nbsp;
<dsp:input bean="CartModifierFormHandler.moveToPurchaseInfoByRelId" type="submit" value="Checkout"/>
</td>
</tr>

</table>

</dsp:form>

<strong>Detailed Item Price Information</strong>

<table>
<tr>
<td>Quantity</td>
<td>Product</td>
<td>SKU</td>
<td>Subtotal</td>
<td>Unit Adjustments</td>
</tr>

<tr>
<dsp:droplet name="ForEach">
<dsp:param bean="ShoppingCart.current.commerceItems" name="array"/>
<dsp:param name="elementName" value="item"/>
<dsp:oparam name="output">
<dsp:droplet name="ForEach">
<dsp:param name="array" param="item.priceInfo.currentPriceDetails"/>
<dsp:param name="elementName" value="detail"/>
<dsp:oparam name="output">
<td><dsp:valueof param="detail.quantity"/></td>
<td><dsp:valueof param="item.auxiliaryData.productRef.displayName"/></td>
<td><dsp:valueof param="item.auxiliaryData.catalogRef.displayName"/></td>
<td><dsp:valueof converter="currency" param="detail.amount">no price</dsp:valueof></td>
<td>
<dsp:droplet name="ForEach">
<dsp:param name="array" param="detail.adjustments"/>
<dsp:param name="elementName" value="adjustment"/>
<dsp:oparam name="output">
<dsp:valueof param="adjustment.pricingModel.repositoryId"/> adjusted by 
<dsp:valueof converter="currency" param="adjustment.adjustment">no price</dsp:valueof><BR>
</dsp:oparam>
</dsp:droplet>
</td>
</tr>
</dsp:oparam>
<dsp:oparam name="empty"><DD>no detail info available</dsp:oparam>
</dsp:droplet>
</dsp:oparam>
</dsp:droplet>
</table>

<P>
<hr size=0>
<dsp:droplet name="Switch">
<dsp:param bean="Profile.transient" name="value"/>
<dsp:oparam name="true">
<dsp:a href="login.jsp">Login</dsp:a> or <dsp:a href="register.jsp">Register</dsp:a>
to save your cart for later
</dsp:oparam>
</dsp:droplet>

<dsp:form action="shoppingcart.jsp" method="post">
<dsp:droplet name="Switch">
<dsp:param bean="ShoppingCart.savedEmpty" name="value"/>
<dsp:oparam name="false">
Shopping Cart
<dsp:select bean="ShoppingCart.handlerOrderId">
<dsp:droplet name="ForEach">
  <dsp:param bean="ShoppingCart.saved" name="array"/>
  <dsp:param name="elementName" value="savedcart"/>
  <dsp:oparam name="output">
<dsp:getvalueof id="option704" param="savedcart.id" idtype="java.lang.String">
<dsp:option value="<%=option704%>"/>
</dsp:getvalueof><dsp:valueof param="savedcart.id"/>
  </dsp:oparam>
</dsp:droplet>
</dsp:select>:

<dsp:input bean="ShoppingCart.switch" type="submit" value="Switch"/> to,
<dsp:input bean="ShoppingCart.delete" type="submit" value="Delete"/> or
<dsp:input bean="ShoppingCart.create" type="submit" value="Create"/> another shopping cart.<BR>
<dsp:input bean="ShoppingCart.deleteAll" type="submit" value="Delete All Shopping Carts"/>
</dsp:oparam>
<dsp:oparam name="true">
<dsp:input bean="ShoppingCart.create" type="submit" value="Create"/> another shopping cart
</dsp:oparam>
</dsp:droplet>
</dsp:form>

<%--
In the B2B commerce case we will optionally display a link to the 
express checkout page.  The only reason we limit this link to the 
B2B case is because the exp_checkout.jsp page in the sample catalog
assumes a B2B user profile, with properties named defaultBillingAddress, 
defaultShippingAddress, and defaultPaymentType.  These properties do
not exist in the default B2C user profile.  If we wanted to demonstrate
express checkout for the B2C case, we could write a different version
of the exp_checkout.jsp page that used he B2C profile and generate a 
link to that page in the ComponentExist droplet's "false" oparam.
--%>

<dsp:droplet name="ComponentExists">
  <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
  <dsp:oparam name="true">
    <dsp:droplet name="Switch">
    <dsp:param bean="Profile.expressCheckout" name="value"/>
    <dsp:oparam name="true">
      <p><dsp:a href="exp_checkout.jsp">Express Checkout</dsp:a>
    </dsp:oparam>
    </dsp:droplet>
 </dsp:oparam>
</dsp:droplet>

</BODY>
</HTML>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/shoppingcart.jsp#2 $$Change: 635969 $--%>
