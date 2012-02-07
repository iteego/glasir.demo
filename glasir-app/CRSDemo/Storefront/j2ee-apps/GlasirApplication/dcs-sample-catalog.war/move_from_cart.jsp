<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>



<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<html>
<head>
<title>Move items from the Shopping Cart to <dsp:valueof param="listName">unknown gift list</dsp:valueof></title>
</head>

<body>

<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
<dsp:a href="product_search.jsp">Product Search</dsp:a> - 
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a> - 
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

<h3>Move items from the Shopping Cart to <dsp:valueof param="listName">unknown gift list</dsp:valueof></h3>

<dsp:droplet name="IsEmpty">
  <dsp:param bean="ShoppingCart.current.commerceItems" name="value"/>
  <dsp:oparam name="false">
    <dsp:form action="lists.jsp" method="POST">
    <dsp:input bean="GiftlistFormHandler.moveItemsFromCartSuccessURL" type="hidden" value="lists.jsp"/>

    <table>
    <tr><td>Move</td><td>Quantity</td><td>Item</td><td>Price</td></tr>
    <dsp:droplet name="ForEach">
      <dsp:param bean="ShoppingCart.current.commerceItems" name="array"/>
      <dsp:param name="elementName" value="item"/>
      <dsp:oparam name="output">
        <tr>
        <td><dsp:input bean="GiftlistFormHandler.itemIds" paramvalue="item.id" type="checkbox" checked="<%=false%>"/>
            <dsp:input bean="GiftlistFormHandler.giftlistId" paramvalue="giftlistId" type="hidden"/>
        </td>
        <td><input name='<dsp:valueof param="item.id"/>' size="4" type="text" value='<dsp:valueof param="item.quantity"/>'></td>
        <td><dsp:valueof param="item.auxiliaryData.catalogRef.displayName"/></td>
        <td><dsp:valueof converter="currency" param="item.priceInfo.amount">no price</dsp:valueof></td>
        </tr>
      </dsp:oparam>  
     </dsp:droplet>
     </table>
     <dsp:input bean="GiftlistFormHandler.moveItemsFromCart" type="submit" value="Move Checked Items"/></td>
     </dsp:form>
  </dsp:oparam>

  <dsp:oparam name="true">
    There are no items in your shopping cart to move.
  </dsp:oparam>
</dsp:droplet>

</BODY>
</HTML>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/move_from_cart.jsp#2 $$Change: 635969 $--%>
