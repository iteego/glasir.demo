<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>


<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>

<span class=storelittle>
<b><dsp:a href="index.jsp">Catalog Home</dsp:a></b> >
<b><dsp:a href="giftlist_search.jsp">Giftlist Search</dsp:a></b> >
View Giftlist
</span>

<p>

<!-- check if parameter giftlistId has been passed into page.  if
     it has, then call GiftlistDroplet to do something -->
<dsp:droplet name="IsEmpty">
<dsp:param name="value" param="giftlistId"/>
<dsp:oparam name="false">
  <dsp:droplet name="/atg/commerce/gifts/GiftlistLookupDroplet">
    <dsp:param name="id" param="giftlistId"/>
    <dsp:oparam name="output">
      <dsp:setvalue paramvalue="element" param="giftlist"/>
      <span class=storebig>Gift List for 
      <dsp:valueof param="giftlist.owner.firstName"/>
      <dsp:valueof param="giftlist.owner.middleName"/>
      <dsp:valueof param="giftlist.owner.lastName"/>
      </span>
      <br>
      <p>
      <b>Event name:</b><dsp:valueof param="giftlist.eventName"/>
      <br>
      <b>Event date:</b><dsp:valueof date="d-MMM-yyyy" param="giftlist.eventDate"/>
      <p>

      <table cellspacing=0 cellpadding=0 border=0>
    	<tr valign=bottom>
   		<td><b>Quantity<br>wanted</b></td>
   		<td>&nbsp;</td>
  		<td><b>Quantity<br>bought</b></td>
  		<td>&nbsp;&nbsp;&nbsp;</td>
  		<td><b>Product</b></td>
    	</tr>
      <tr><td colspan=5><hr size=0></td></tr>
      <dsp:droplet name="/atg/dynamo/droplet/ForEach">
        <dsp:param name="array" param="giftlist.giftlistItems"/>
        <dsp:oparam name="output">
          <dsp:setvalue paramvalue="element" param="item"/>
          <dsp:droplet name="/atg/commerce/catalog/ProductLookup">
            <dsp:param name="elementName" value="product"/>
            <dsp:param name="id" param="item.productId"/>
            <dsp:oparam name="output">
          	  <tr valign=top>
              <td><dsp:valueof param="item.quantityDesired">quantity desired</dsp:valueof></td>
              <td></td>
              <td><dsp:valueof param="item.quantityPurchased">quantity purchased</dsp:valueof></td>
              <td></td>
              <td>
                <dsp:a href="display_product.jsp">
				          <dsp:param name="id" param="product.repositoryId"/>
				          <dsp:param name="giftId" param="item.id"/>
				          <dsp:param name="giftlistId" param="giftlistId"/>
				          <dsp:param name="gift" value="true"/>
				          <dsp:valueof param="product.displayName">ERROR:no product name</dsp:valueof> 
				        </dsp:a>
              </td>
              </tr>
            </dsp:oparam>
          </dsp:droplet>
        </dsp:oparam>
        <dsp:oparam name="empty">
          <tr><td colspan=5>Your giftlist is empty</td></tr>
        </dsp:oparam>
      </dsp:droplet>
      </table>
      <p>
      <b>Event description:</b><br>
      <dsp:valueof param="giftlist.description"/><br>
      <p>
      <b>Ship to:</b><br>
      <dsp:valueof param="giftlist.owner.firstName"/>
      <dsp:valueof param="giftlist.owner.middleName"/>
      <dsp:valueof param="giftlist.owner.lastName"/><br>
      <dsp:valueof param="giftlist.owner.shippingAddress.city"/>
      <dsp:valueof param="giftlist.owner.shippingAddress.state"/><br>
    </dsp:oparam>
    <dsp:oparam name="empty">
      Nothing to look at here.
    </dsp:oparam>
  </dsp:droplet>
</dsp:oparam>
</dsp:droplet>

</BODY>
</HTML>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/giftlist_view.jsp#2 $$Change: 635969 $--%>
