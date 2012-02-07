<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>

<!-- Display giftlist items if any -->
<dsp:setvalue paramvalue="giftlist.giftlistItems" param="items"/>
<dsp:setvalue paramvalue="giftlist.id" param="giftlistId"/>
<dsp:setvalue paramvalue="giftlist.eventName" param="listName"/>

<dsp:form action="<%=request.getRequestURI()%>" method="post">

<dsp:input bean="GiftlistFormHandler.updateGiftlistItemsSuccessURL" type="hidden" value="<%=request.getRequestURI()%>"/>
<dsp:input bean="GiftlistFormHandler.updateGiftlistItemsErrorURL" type="hidden" value="<%=request.getRequestURI()%>"/>
<dsp:input bean="GiftlistFormHandler.giftlistId" paramvalue="giftlistId" type="hidden"/>

<!-- Display giftlist name -->

<table cellspacing=2 cellpadding=0 border=0 width=75%>

<tr>
<td colspan=20><strong><dsp:valueof param="giftlist.eventName"/></strong>
on <dsp:valueof date="MMMM dd, yyyy" param="giftlist.eventDate"/>
<dsp:droplet name="/atg/dynamo/droplet/Switch">
  <dsp:param name="value" param="giftlist.published"/>
  <dsp:oparam name="true">(<i>public</i>)</dsp:oparam>
  <dsp:oparam name="false">(<i>private</i>)</dsp:oparam>
</dsp:droplet>
</td>
</tr>

<dsp:droplet name="IsEmpty">
  <dsp:param name="value" param="items"/>
  <dsp:oparam name="false">
    <tr>
    <td>Delete</td>
    <td>Quantity<br>desired</td><td></td>
    <td>Quantity<br>purchased</td><td></td>
    <td>Item</td><td></td><td></td>
    </tr>

    <dsp:droplet name="/atg/dynamo/droplet/ForEach">
      <dsp:param name="array" param="items"/>
      <dsp:param name="elementName" value="giftItem"/>
      <dsp:oparam name="output">
        <tr valign=top>
        <td><dsp:input bean="GiftlistFormHandler.removeGiftitemIds" paramvalue="giftItem.id" type="checkbox"/></td>
        <td><input name='<dsp:valueof param="giftItem.id"/>' size="2" type="text" value='<dsp:valueof param="giftItem.quantityDesired"/>'></td>
        <td></td><td><dsp:valueof param="giftItem.quantityPurchased">-</dsp:valueof></td>
        <td></td>
        <td>
        <dsp:a href="display_product.jsp">
          <dsp:param name="id" param="giftItem.productId"/>
          <dsp:droplet name="/atg/commerce/catalog/SKULookup">
            <dsp:param name="id" param="giftItem.catalogRefId"/>
            <dsp:param name="elementName" value="giftSku"/>
            <dsp:oparam name="output"><dsp:valueof param="giftSku.displayName"/></dsp:oparam>
          </dsp:droplet>
        </dsp:a>
        </td>
        <td></td>
        <td><dsp:a href="shoppingcart.jsp">
              <dsp:param name="giftId" param="giftItem.id"/>
              <dsp:param name="giftlistId" param="giftlistId"/>Add to Shopping Cart</dsp:a>
        </td>
        </tr>
        <p>
      </dsp:oparam>
    </dsp:droplet>

    <tr>
    <td colspan=8>
    <dsp:input bean="GiftlistFormHandler.updateGiftlistItems" type="submit" value="Update list"/></td>
    </td>
    </tr>

    <tr>
    <td colspan=10>
    &gt; <dsp:a href="./lists_new.jsp">
           <dsp:param name="giftlistId" param="giftlistId"/>Edit this list</dsp:a><br>

    <dsp:droplet name="Switch">
      <dsp:param bean="ShoppingCart.current.totalCommerceItemCount" name="value"/>
      <dsp:oparam name="0"></dsp:oparam>
      <dsp:oparam name="default">
        &gt; <dsp:a href="move_from_cart.jsp">
               <dsp:param name="giftlistId" param="giftlistId"/>
               <dsp:param name="listName" param="listName"/>
               Move items to this gift list from the Shopping Cart
              </dsp:a>
      </dsp:oparam>
    </dsp:droplet>
    </td>
    </tr>
  </dsp:oparam>
      
  <dsp:oparam name="true">
    <tr>
    <td colspan=20>
    This list is empty, <dsp:a href="index.jsp">go shop</dsp:a>.<P>
    &gt; <dsp:a href="./lists_new.jsp"><dsp:param name="giftlistId" param="giftlistId"/>Edit this list</dsp:a><br>

    <dsp:droplet name="Switch">
      <dsp:param bean="ShoppingCart.current.totalCommerceItemCount" name="value"/>
      <dsp:oparam name="0"></dsp:oparam>
      <dsp:oparam name="default">
        &gt; <dsp:a href="move_from_cart.jsp">
               <dsp:param name="giftlistId" param="giftlistId"/>
               <dsp:param name="listName" param="listName"/>
               Move items to this gift list from the Shopping Cart
             </dsp:a>
      </dsp:oparam>
    </dsp:droplet>
    </td>
    </tr>
  </dsp:oparam>
</dsp:droplet>

</table>
</dsp:form>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/manage_singlegiftlist.jsp#2 $$Change: 635969 $--%>
