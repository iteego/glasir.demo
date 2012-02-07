<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
<dsp:importbean bean="/atg/commerce/ShoppingCart"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>

<dsp:include page="remove_from_list.jsp"></dsp:include>

<dsp:setvalue beanvalue="Profile.wishlist" param="wishlist"/>
<dsp:setvalue paramvalue="wishlist.giftlistItems" param="items"/>
<dsp:setvalue paramvalue="wishlist.id" param="giftlistId"/>

<dsp:form action="<%=request.getRequestURI()%>" method="post">  
<dsp:input bean="GiftlistFormHandler.updateGiftlistItemsSuccessURL" type="hidden" value="<%=request.getRequestURI()%>"/>
<dsp:input bean="GiftlistFormHandler.updateGiftlistItemsErrorURL" type="hidden" value="<%=request.getRequestURI()%>"/>
<dsp:input bean="GiftlistFormHandler.giftlistId" paramvalue="giftlistId" type="hidden"/>

<strong>My Wish List</strong><BR>

<dsp:droplet name="IsEmpty">
  <dsp:param name="value" param="items"/>
  <dsp:oparam name="false">
    <table cellspacing=2 cellpadding=0 border=0 width=75%>
    <tr valign=top><td>Delete</td><td>Quantity</td><td>Item</td><td></td></tr>
    <dsp:droplet name="/atg/dynamo/droplet/ForEach">
      <dsp:param name="array" param="items"/>
      
      <dsp:oparam name="output">
        <tr>
        <td><dsp:input bean="GiftlistFormHandler.removeGiftitemIds" paramvalue="element.id" type="checkbox"/></td>
        <td><input name='<dsp:valueof param="element.id"/>' size="2" type="text" value='<dsp:valueof param="element.quantityDesired"/>'></td>
        <td>
          <dsp:droplet name="/atg/commerce/catalog/ProductLookup">
            <dsp:param name="id" param="element.productId"/>
            <dsp:param name="elementName" value="product"/>
            <dsp:oparam name="output">
              <dsp:a href="display_product.jsp">
                <dsp:param name="id" param="id"/>
                <dsp:param name="navAction" value="jump"/>
                <dsp:droplet name="/atg/commerce/catalog/SKULookup">
              <dsp:param name="id" param="element.catalogRefId"/>
              <dsp:param name="elementName" value="giftSku"/>
              <dsp:oparam name="output"><dsp:valueof param="giftSku.displayName"/></dsp:oparam>
                </dsp:droplet>
              </dsp:a>
            </dsp:oparam>
          </dsp:droplet>
        </td>
        <td></td><td><dsp:a href="shoppingcart.jsp"><dsp:param name="giftId" param="element.id"/><dsp:param name="giftlistId" param="giftlistId"/>Add to Shopping Cart</dsp:a></td>
        </tr>               
      </dsp:oparam>
      <dsp:oparam name="empty">
         <tr><td>There's nothing in your wish list yet. Don't you want something?</td></tr>
      </dsp:oparam>
    </dsp:droplet>
    <tr>
    <td colspan=3>
    <dsp:input bean="GiftlistFormHandler.updateGiftlistItems" type="submit" value="Update list"/>
    </td>
    </tr>
    </table>
  </dsp:oparam>

  <dsp:oparam name="true">
    Your Wish List is empty, <dsp:a href="index.jsp">go shop</dsp:a>.
    <P>
  </dsp:oparam>
</dsp:droplet>

<dsp:droplet name="Switch">
  <dsp:param bean="ShoppingCart.current.totalCommerceItemCount" name="value"/>
  <dsp:oparam name="0"></dsp:oparam>
  <dsp:oparam name="default">
    &gt; <dsp:a href="move_from_cart.jsp">
           <dsp:param name="giftlistId" param="giftlistId"/>
           <dsp:param name="listName" value="My Wish List"/>
            Move items to this wish list from the Shopping Cart
          </dsp:a>
  </dsp:oparam>
</dsp:droplet>

</dsp:form>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/manage_wishlist.jsp#2 $$Change: 635969 $--%>
