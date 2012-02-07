<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsNull"/>
<dsp:importbean bean="/atg/commerce/order/purchase/CartModifierFormHandler"/>
<dsp:importbean bean="/atg/commerce/gifts/GiftitemLookupDroplet"/>
<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
<dsp:importbean bean="/atg/commerce/gifts/GiftlistLookupDroplet"/>
<dsp:importbean bean="/atg/commerce/pricing/PriceItem"/>
<dsp:importbean bean="/atg/commerce/pricing/PriceEachItem"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/commerce/pricing/UserPricingModels"/>
<dsp:importbean bean="/atg/commerce/catalog/ProductBrowsed"/>
<dsp:importbean bean="/atg/commerce/catalog/SKULookup"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListContains"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>

<dsp:setvalue bean="Profile.currentLocation" value="catalog_product"/>
<dsp:droplet name="/atg/commerce/catalog/ProductLookup">
   <dsp:param name="elementName" value="product"/>
   <%-- id would also be a param here but it was passed in --%>
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
interact and display product information. Included are four examples of how
one could add the product to the shopping cart, adding the item to a gift list
and displaying relevant pricing and inventory information.
If the user came here from viewing a giftlist, there is also an example of
purchasing the item from the giftlist.

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
<%--<td>Availability Status Code</td>--%>
<td>Availability Date</td>
<td>Stock Level</td>
<td>Backorder Level</td>
<td>Preorder Level</td>
<%--<td>Inventory Error?</td>--%>
<dsp:droplet name="PriceEachItem">
  <dsp:param name="items" param="product.childSKUs"/>
  <dsp:param name="elementName" value="element"/>
  <%-- the product param is defined at the top of the page --%>
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
          <%--<td><dsp:valueof param="inventoryInfo.availabilityStatus">-</dsp:valueof></td>--%>
          <td><dsp:valueof param="inventoryInfo.availabilityDate">-</dsp:valueof></td>
          <td><dsp:valueof param="inventoryInfo.stockLevel">-</dsp:valueof></td>
          <td><dsp:valueof param="inventoryInfo.backorderLevel">-</dsp:valueof></td>
          <td><dsp:valueof param="inventoryInfo.preorderLevel">-</dsp:valueof></td>
          <%--<td><dsp:valueof param="error">-</dsp:valueof></td>--%>
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
<dsp:param bean="CartModifierFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <blockquote>
  This section displays any errors that may have occured when the user submitted the request
  to add an item to the shopping cart.
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
      <dsp:param bean="CartModifierFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
  </UL></STRONG></font>
  </blockquote>
</dsp:oparam>
</dsp:droplet>

<dsp:droplet name="Switch">
  <dsp:param name="value" param="gift"/>
  <dsp:oparam name="true">
    <i>Example 0: Purchasing a gift</i><BR>
    This form displays the SKU that was specified in a giftlist that the shopper is shopping from.
    This type of form allows one to add a quantity of items to the shopping cart.

    <dsp:droplet name="GiftlistLookupDroplet">
      <dsp:param name="id" param="giftlistId"/>
      <dsp:param name="elementName" value="giftlist"/>
      <dsp:oparam name="output">
        <dsp:form action="display_product.jsp" method="post">
        <input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
        <dsp:input bean="CartModifierFormHandler.addItemToOrderSuccessURL" type="hidden" value="shoppingcart.jsp"/>
        <dsp:input bean="CartModifierFormHandler.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>
        <dsp:input bean="CartModifierFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
        <dsp:input bean="CartModifierFormHandler.giftlistId" paramvalue="giftlistId" type="hidden"/>
        <dsp:input bean="CartModifierFormHandler.giftlistItemId" paramvalue="giftId" type="hidden"/>
        <dsp:droplet name="GiftitemLookupDroplet">
          <dsp:param name="id" param="giftId"/>
          <dsp:param name="elementName" value="giftitem"/>
          <dsp:oparam name="output">
            <dsp:input bean="CartModifierFormHandler.catalogRefIds" paramvalue="giftitem.catalogRefId" type="hidden"/>

            <dsp:valueof param="giftlist.owner.firstName">firstname</dsp:valueof> wants 
            <dsp:valueof param="giftitem.quantityDesired">?</dsp:valueof> 
            <dsp:droplet name="SKULookup">
              <dsp:param name="id" param="giftitem.catalogRefId"/>
              <dsp:param name="elementName" value="sku"/>
              <dsp:oparam name="output">
      	        <dsp:valueof param="sku.displayName">sku</dsp:valueof><br>
              </dsp:oparam>
            </dsp:droplet>
            and so far people have bought <dsp:valueof param="giftitem.quantityPurchased">?</dsp:valueof>.
            <br>
          </dsp:oparam>
        </dsp:droplet>
        Quantity: <dsp:input bean="CartModifierFormHandler.quantity" size="4" type="text" value="1"/><BR>
        <dsp:input bean="CartModifierFormHandler.addItemToOrder" type="submit" value="Add Gift To Cart"/>
        </dsp:form>
      </dsp:oparam>
    </dsp:droplet>
  </dsp:oparam>
</dsp:droplet>

<i>Example 1:</i><BR>
This form displays all the SKU selections in a single drop-down list. The SKU's <i>displayName</i> is 
used to show what can be selected. This type of form allows one to select a single type of SKU and
a quantity of items to add to the shopping cart.

<dsp:form action="display_product.jsp" method="post">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:input bean="CartModifierFormHandler.addItemToOrderSuccessURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="CartModifierFormHandler.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>
<dsp:input bean="CartModifierFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
<dsp:select bean="CartModifierFormHandler.catalogRefIds">
<dsp:droplet name="/atg/dynamo/droplet/ForEach">
  <dsp:param name="array" param="product.childSKUs"/>
  <dsp:param name="elementName" value="sku"/>
  <dsp:param name="indexName" value="skuIndex"/>
  <dsp:oparam name="output">
<dsp:option paramvalue="sku.repositoryId"/>
<dsp:valueof param="sku.displayName"/>
  </dsp:oparam>
</dsp:droplet>
</dsp:select>
Quantity: <dsp:input bean="CartModifierFormHandler.quantity" size="4" type="text" value="1"/><BR>
<dsp:input bean="CartModifierFormHandler.addItemToOrder" type="submit" value="Add To Cart"/>
</dsp:form>

<i>Example 2:</i><BR>
This second example allows the customer to select multiple SKUs and add the same quanity of items for each one. 
As a further example of pricing, we utilize the <code>/atg/commerce/pricing/PriceItem</code> droplet to compute
the price for each individual SKU.

<dsp:form action="display_product.jsp" method="post">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:input bean="CartModifierFormHandler.addItemToOrderSuccessURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="CartModifierFormHandler.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>
<dsp:input bean="CartModifierFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>

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
    <td><dsp:input bean="CartModifierFormHandler.catalogRefIds" paramvalue="sku.repositoryId" type="checkbox"/></td>
    <td><dsp:valueof param="sku.displayName"/></td>
    <td>
    <dsp:droplet name="PriceItem">
      <dsp:param name="item" param="sku"/>
      <%-- the product param is defined at the top of the page --%>
      <dsp:param name="elementName" value="pricedItem"/>
      <dsp:oparam name="output"><dsp:valueof converter="currency" param="pricedItem.priceInfo.amount">no price</dsp:valueof></dsp:oparam>
    </dsp:droplet>
    </td>
    </tr>
  </dsp:oparam>
</dsp:droplet>
</table>
<BR>
Quantity: <dsp:input bean="CartModifierFormHandler.quantity" size="4" type="text" value="1"/><BR>
<dsp:input bean="CartModifierFormHandler.addItemToOrder" type="submit" value="Add To Cart"/>
</dsp:form>

<i>Example 3:</i><BR>
The third example allows the customer to select individual SKUs and to specify a unique
quantity for each item. This version uses the form handler's catalogRefIds property to
specify the SKUs.
<dsp:form action="display_product.jsp" method="post">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:input bean="CartModifierFormHandler.addItemToOrderSuccessURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="CartModifierFormHandler.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>
<dsp:input bean="CartModifierFormHandler.productId" paramvalue="product.repositoryId" type="hidden"/>
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
    <td><dsp:input bean="CartModifierFormHandler.catalogRefIds" paramvalue="sku.repositoryId" type="checkbox"/></td>
    <td><dsp:valueof param="sku.displayName"/></td>
    <td><input name='<dsp:valueof param="sku.repositoryId"/>' size="4" type="text" value="1"></td>
    </tr>
  </dsp:oparam>
</dsp:droplet>
</table>
<BR>
<dsp:input bean="CartModifierFormHandler.addItemToOrder" type="submit" value="Add To Cart"/>
</dsp:form>

<i>Example 4:</i><BR>
Like the third example, this one also allows the customer to select individual SKUs and to specify a unique
quantity for each item. Only SKUs with non-zero quantities are added.
This version uses the form handler's items property to specify the SKUs and quantities.
This version also adds configurable commerce items rather than plain items for configurable SKUs.
<dsp:form action="display_product.jsp" method="post">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:input bean="CartModifierFormHandler.addItemToOrderSuccessURL" type="hidden" value="shoppingcart.jsp"/>
<dsp:input bean="CartModifierFormHandler.SessionExpirationURL" type="hidden" value="session_expired.jsp"/>
<table border=1>
<tr>
<td>SKU</td>
<td>Quantity</td>
</tr>
<dsp:droplet name="/atg/dynamo/droplet/ForEach">
  <dsp:param name="array" param="product.childSKUs"/>
  <dsp:param name="elementName" value="sku"/>
  <dsp:param name="indexName" value="skuIndex"/>
  <dsp:oparam name="outputStart">
    <dsp:input bean="CartModifierFormHandler.addItemCount" paramvalue="size" type="hidden"/>
  </dsp:oparam>
  <dsp:oparam name="output">
    <tr>
    <td><dsp:valueof param="sku.displayName"/></td>
    <td>
      <dsp:input bean="CartModifierFormHandler.items[param:skuIndex].quantity" size="4" type="text" value="0"/>
      <dsp:input bean="CartModifierFormHandler.items[param:skuIndex].catalogRefId" paramvalue="sku.repositoryId" type="hidden"/>
      <dsp:input bean="CartModifierFormHandler.items[param:skuIndex].productId" paramvalue="product.repositoryId" type="hidden"/>
      <dsp:droplet name="Switch">
        <dsp:param name="value" param="sku.type"/>
        <dsp:oparam name="configurableSku">
      <dsp:input bean="CartModifierFormHandler.items[param:skuIndex].commerceItemType" beanvalue="CartModifierFormHandler.configurableItemTypeName" type="hidden"/>
        </dsp:oparam>
      </dsp:droplet>
    </td>
    </tr>
  </dsp:oparam>
</dsp:droplet>
</table>
<BR>
<dsp:input bean="CartModifierFormHandler.addItemToOrder" type="submit" value="Add To Cart"/>
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
<dsp:option paramvalue="sku.repositoryId"/>
<dsp:valueof param="sku.displayName"/>
  </dsp:oparam>
</dsp:droplet>
</dsp:select>
<BR>
Quantity: <dsp:input bean="GiftlistFormHandler.quantity" size="4" type="text" value="1"/>
<dsp:select bean="GiftlistFormHandler.giftlistId">
  <dsp:droplet name="IsNull">
    <dsp:param bean="Profile.wishlist" name="value"/>
    <dsp:oparam name="false">
<dsp:option beanvalue="Profile.wishlist.id"/>
My Wishlist
    </dsp:oparam>
  </dsp:droplet>
  <dsp:droplet name="/atg/dynamo/droplet/ForEach">
    <dsp:param bean="Profile.giftlists" name="array"/>
    <dsp:param name="elementName" value="giftlist"/>
    <dsp:oparam name="output">id:<dsp:valueof param="giftlist.id">null</dsp:valueof>
<dsp:option paramvalue="giftlist.id"/>
<dsp:valueof param="giftlist.eventName">Undefined</dsp:valueof>
    </dsp:oparam>
   </dsp:droplet>
</dsp:select><BR>
<dsp:input bean="GiftlistFormHandler.addItemToGiftlist" type="submit" value="Add To Giftlist"/>
</dsp:form>

<P>

<strong>Product Comparison</strong>

<P>

Catalog pages provide one convenient place for users to add products to their 
product comparison lists.  This form displays a single button, labeled either 
"Add to Comparison List" or "Remove from Comparison List", depending on whether
the product is already in the list.  We use the <code>ProductListContains</code>
droplet to query the list, and the <code>ProductListHandler</code> form handler
to add or remove products from the list.

<dsp:form action="display_product.jsp" method="POST">
<input name="id" type="hidden" value='<dsp:valueof param="product.repositoryId"/>'>
<dsp:droplet name="ProductListContains">
  <dsp:param bean="ProductList" name="productList"/>
  <dsp:param name="productID" param="product.repositoryId"/>
  <dsp:oparam name="true">
    <dsp:input bean="ProductListHandler.productID" paramvalue="product.repositoryId" type="hidden"/>
    <dsp:input bean="ProductListHandler.removeProduct" type="submit" value="Remove from Comparison List"/>
  </dsp:oparam>
  <dsp:oparam name="false">
    <dsp:input bean="ProductListHandler.productID" paramvalue="product.repositoryId" type="hidden"/>
    <dsp:input bean="ProductListHandler.addProduct" type="submit" value="Add to Comparison List"/>
  </dsp:oparam>
</dsp:droplet> 
</dsp:form>

<p>

<strong>Related Products</strong>

<P>

This displays the related products in this catalog by using a variant of the
<code>ForEach</code> that is catalog specific named <code>ForEachItemInCatalog</code>.
<P>
<%-- related items --%>
<dsp:droplet name="/atg/commerce/catalog/ForEachItemInCatalog">
  <dsp:param name="array" param="product.relatedProducts"/>
  <dsp:param name="elementName" value="relProduct"/>
  <dsp:oparam name="output">
    <dsp:a href="display_product.jsp">
    <dsp:param name="id" param="relProduct.repositoryId"/>
    <dsp:valueof param="relProduct.displayName">No name</dsp:valueof></dsp:a><br>
  </dsp:oparam>
</dsp:droplet>

</body>
</html>
</dsp:oparam>
</dsp:droplet>



</dsp:page>
<%-- Version: $Change: 633540 $$DateTime: 2011/02/08 15:52:16 $--%>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/display_product.jsp#1 $$Change: 633540 $--%>
