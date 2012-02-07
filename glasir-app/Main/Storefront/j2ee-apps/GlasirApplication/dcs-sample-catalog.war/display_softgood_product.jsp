<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier"/>
<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
<dsp:importbean bean="/atg/commerce/pricing/PriceItem"/>
<dsp:importbean bean="/atg/commerce/pricing/PriceEachItem"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/commerce/pricing/UserPricingModels"/>
<dsp:importbean bean="/atg/commerce/catalog/ProductBrowsed"/>

<dsp:setvalue bean="Profile.currentLocation" value="catalog_product"/>
<dsp:droplet name="/atg/commerce/catalog/ProductLookup">
   <dsp:param name="elementName" value="product"/>
   <!-- id would also be a param here but it was passed in -->
   <dsp:oparam name="output">

<%-- This droplet will fire an event into the Scenario Server to indicate that the product has been seen  --%>
<dsp:droplet name="ProductBrowsed">
  <dsp:param name="eventobject" param="product"/>
</dsp:droplet>

<html>
<head>
<title><dsp:valueof param="product.displayName"/></title>
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

<P>

<h2>Product: <dsp:valueof param="product.displayName"/></h2>

<P>

This sample product template attempts to show many different ways one can 
interact and display product information. Included are three examples of how
one could add the product to the shopping cart, adding the item to a gift list
and displaying relevant pricing and inventory information.

<P>

<strong>Pricing and Inventory</strong>

<P>

This table is generated through a combination of the <code>/atg/commerce/pricing/PriceEachItem</code> and
<code>/atg/commerce/inventory/InventoryLookup</code> droplets. The PriceEachItem droplet returns a list of 
CommerceItem objects. Then from the CommerceItem one can fetch both the product, sku and price information.
The inventory droplet returns an instance of <code>atg.commerce.inventory.InventoryInfo</code>. This class
has a number of properties (e.g. <i>stockLevel</i>) that make available inventory data.

<P>

<table border=1>
<tr>
<td>SKU</td>
<td>Price</td>
<td>Availability Status</td>
<!--<td>Availability Status Code</td>-->
<td>Availability Date</td>
<td>Stock Level</td>
<td>Backorder Level</td>
<td>Preorder Level</td>
<!--<td>Inventory Error?</td>-->
<dsp:droplet name="PriceEachItem">
  <dsp:param name="items" param="product.childSKUs"/>
  <dsp:param name="elementName" value="element"/>
  <!-- the product param is defined at the top of the page -->
  <dsp:oparam name="output">
    <dsp:droplet name="/atg/dynamo/droplet/ForEach">
    <dsp:param name="array" param="element"/>
    <dsp:param name="elementName" value="pricedItem"/>
    <dsp:oparam name="output">
      <dsp:setvalue paramvalue="pricedItem.auxiliaryData.catalogRef" param="sku"/>
      <tr>
      <td><dsp:valueof param="sku.displayName"/></td>
      <td>
      <dsp:droplet name="Switch">
        <dsp:param name="value" param="pricedItem.priceInfo.onSale"/>
        <dsp:oparam name="false"><dsp:valueof converter="currency" param="pricedItem.priceInfo.amount">no price</dsp:valueof></dsp:oparam>
        <dsp:oparam name="true">List price for <dsp:valueof converter="currency" param="pricedItem.priceInfo.listPrice">no price</dsp:valueof> <strong>on sale for <dsp:valueof converter="currency" param="pricedItem.priceInfo.salePrice">no price</dsp:valueof>!</strong></dsp:oparam>
      </dsp:droplet>
      </td>

      <dsp:droplet name="/atg/commerce/inventory/InventoryLookup">
        <dsp:param name="itemId" param="sku.repositoryId"/>
        <dsp:param name="useCache" value="true"/>
        <dsp:oparam name="output">
          <td><dsp:valueof param="inventoryInfo.availabilityStatusMsg">-</dsp:valueof></td>
          <!--<td><dsp:valueof param="inventoryInfo.availabilityStatus">-</dsp:valueof></td>-->
          <td><dsp:valueof param="inventoryInfo.availabilityDate">-</dsp:valueof></td>
          <td><dsp:valueof param="inventoryInfo.stockLevel">-</dsp:valueof></td>
          <td><dsp:valueof param="inventoryInfo.backorderLevel">-</dsp:valueof></td>
          <td><dsp:valueof param="inventoryInfo.preorderLevel">-</dsp:valueof></td>
          <!--<td><dsp:valueof param="error">-</dsp:valueof></td>-->
        </dsp:oparam>
      </dsp:droplet>

      </tr>
    </dsp:oparam>   
    </dsp:droplet>
  </dsp:oparam>
</dsp:droplet>
</table>

<P>

<strong>Adding an item to the Shopping Cart</strong>

<P>

<dsp:droplet name="/atg/dynamo/droplet/Switch">
<dsp:param bean="ShoppingCartModifier.formError" name="value"/>
<dsp:oparam name="true">
  <blockquote>
  This section displays any errors that may have occured when the user submitted the request
  to add an item to the shopping cart.
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
      <dsp:param bean="ShoppingCartModifier.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
  </UL></STRONG></font>
  </blockquote>
</dsp:oparam>
</dsp:droplet>

<i>Example 1:</i><BR>
This form displays all the SKU selections in a single drop-down list. The SKU's <i>displayName</i> is 
used to show what can be selected. This type of form allows one to select a single type of SKU and
a quanity of items to add to the shopping cart.

<dsp:form action="display_softgood_product.jsp" method="post">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:input bean="ShoppingCartModifier.addSoftGoodToOrderSuccessURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="ShoppingCartModifier.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>
<dsp:input bean="ShoppingCartModifier.productId" paramvalue="product.repositoryId" type="hidden"/>
<dsp:select bean="ShoppingCartModifier.catalogRefIds">
<dsp:droplet name="/atg/dynamo/droplet/ForEach">
  <dsp:param name="array" param="product.childSKUs"/>
  <dsp:param name="elementName" value="sku"/>
  <dsp:param name="indexName" value="skuIndex"/>
  <dsp:oparam name="output">
<dsp:getvalueof id="option379" param="sku.repositoryId" idtype="java.lang.String">
<dsp:option value="<%=option379%>"/>
</dsp:getvalueof><dsp:valueof param="sku.displayName"/>
  </dsp:oparam>
</dsp:droplet>
</dsp:select>
Quantity: <dsp:input bean="ShoppingCartModifier.quantity" size="4" type="text" value="1"/><BR>
Email to deliver to: <dsp:input bean="ShoppingCartModifier.softGoodRecipientEmailAddress" size="25" type="text"/><BR>
<dsp:input bean="ShoppingCartModifier.addSoftGoodToOrder" type="submit" value="Add To Cart"/>
</dsp:form>

<i>Example 2:</i><BR>
This second example allows the customer to select multiple SKUs and add the same quanity of items for each one. 
As a further example of pricing, we utilize the <code>/atg/commerce/pricing/PriceItem</code> droplet to compute
the price for each individual SKU.

<dsp:form action="display_product.jsp" method="post">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:input bean="ShoppingCartModifier.addSoftGoodToOrderSuccessURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="ShoppingCartModifier.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>
<dsp:input bean="ShoppingCartModifier.productId" paramvalue="product.repositoryId" type="hidden"/>

<table border=1>
<tr>
<td>Add?</td>
<td>SKU</td>
<td>Price</td>
</tr>
<dsp:droplet name="/atg/dynamo/droplet/ForEach">
  <dsp:param name="array" param="product.childSKUs"/>
  <dsp:param name="elementName" value="sku"/>
  <dsp:param name="indexName" value="skuIndex"/>
  <dsp:oparam name="output">
    <tr>
    <td><dsp:input bean="ShoppingCartModifier.catalogRefIds" paramvalue="sku.repositoryId" type="checkbox"/></td>
    <td><dsp:valueof param="sku.displayName"/></td>
    <td>
    <dsp:droplet name="PriceItem">
      <dsp:param name="item" param="sku"/>
      <!-- the product param is defined at the top of the page -->
      <dsp:param name="elementName" value="pricedItem"/>
      <dsp:oparam name="output"><dsp:valueof converter="currency" param="pricedItem.priceInfo.amount">no price</dsp:valueof></dsp:oparam>
    </dsp:droplet>
    </td>
    </tr>
  </dsp:oparam>
</dsp:droplet>
</table>
<BR>
Quantity: <dsp:input bean="ShoppingCartModifier.quantity" size="4" type="text" value="1"/><BR>
Email to deliver to: <dsp:input bean="ShoppingCartModifier.softGoodRecipientEmailAddress" size="25" type="text"/><BR>
<dsp:input bean="ShoppingCartModifier.addSoftGoodToOrder" type="submit" value="Add To Cart"/>
</dsp:form>

<i>Example 3:</i><BR>
Finally, this last shopping cart example allows one to select individual SKUs and to specify a unique
quantity for each item.
<dsp:form action="display_product.jsp" method="post">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:input bean="ShoppingCartModifier.addSoftGoodToOrderSuccessURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="ShoppingCartModifier.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>
<dsp:input bean="ShoppingCartModifier.productId" paramvalue="product.repositoryId" type="hidden"/>
<table border=1>
<tr>
<td>Add?</td>
<td>SKU</td>
<td>Quantity</td>
</tr>
<dsp:droplet name="/atg/dynamo/droplet/ForEach">
  <dsp:param name="array" param="product.childSKUs"/>
  <dsp:param name="elementName" value="sku"/>
  <dsp:param name="indexName" value="skuIndex"/>
  <dsp:oparam name="output">
    <tr>
    <td><dsp:input bean="ShoppingCartModifier.catalogRefIds" paramvalue="sku.repositoryId" type="checkbox"/></td>
    <td><dsp:valueof param="sku.displayName"/></td>
    <td><input name='<dsp:valueof param="sku.repositoryId"/>' size="4" type="text" value="1"></td>
    </tr>
  </dsp:oparam>
</dsp:droplet>
</table>
<BR>
<dsp:input bean="ShoppingCartModifier.addSoftGoodToOrder" type="submit" value="Add To Cart"/>
</dsp:form>

<P>

<strong>Giftlist</strong>

<P>

In addition to allowing customers to add items to their current shopping cart, we can also allow them
to add the item to a gift list. This form allow one to select a quanity of SKU, and add it to a particular
gift list. By default all user's are given a "My Wishlist" gift list.

<dsp:form action="lists.jsp" method="post">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:input bean="GiftlistFormHandler.addItemToGiftlistSuccessURL" type="hidden" value="lists.jsp"/>
<dsp:input bean="GiftlistFormHandler.addItemToGiftlistErrorURL" type="hidden" value="lists.jsp"/>
<dsp:input bean="GiftlistFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
<dsp:select bean="GiftlistFormHandler.catalogRefIds">
<dsp:droplet name="/atg/dynamo/droplet/ForEach">
  <dsp:param name="array" param="product.childSKUs"/>
  <dsp:param name="elementName" value="sku"/>
  <dsp:param name="indexName" value="skuIndex"/>
  <dsp:oparam name="output">
<dsp:getvalueof id="option597" param="sku.repositoryId" idtype="java.lang.String">
<dsp:option value="<%=option597%>"/>
</dsp:getvalueof><dsp:valueof param="sku.displayName"/>
  </dsp:oparam>
</dsp:droplet>
</dsp:select>
<BR>
Quantity: <dsp:input bean="GiftlistFormHandler.quantity" size="4" type="text" value="1"/>
<dsp:select bean="GiftlistFormHandler.giftlistId">
  <dsp:getvalueof id="option613" bean="Profile.wishlist.id" idtype="java.lang.String">
<dsp:option value="<%=option613%>"/>
</dsp:getvalueof>My Wishlist
  <dsp:droplet name="/atg/dynamo/droplet/ForEach">
    <dsp:param bean="Profile.giftlists" name="array"/>
    <dsp:param name="elementName" value="giftlist"/>
    <dsp:oparam name="output">
    <dsp:getvalueof id="option623" param="giftlist.id" idtype="java.lang.String">
<dsp:option value="<%=option623%>"/>
</dsp:getvalueof><dsp:valueof param="giftlist.eventName">Undefined</dsp:valueof>
    </dsp:oparam>
   </dsp:droplet>
</dsp:select><BR>
Email to deliver to: <dsp:input bean="ShoppingCartModifier.softGoodRecipientEmailAddress" size="25" type="text"/><BR>
<dsp:input bean="GiftlistFormHandler.addItemToGiftlist" type="submit" value="Add To Giftlist"/>
</dsp:form>

</body>
</html>



</dsp:oparam>
</dsp:droplet>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/display_softgood_product.jsp#2 $$Change: 635969 $--%>
