<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/BeanProperty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupDroplet"/>
<dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsNull"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/commerce/pricing/AvailableShippingMethods"/>
<dsp:importbean bean="/atg/commerce/pricing/UserPricingModels"/>
<dsp:importbean bean="/atg/commerce/order/purchase/CreateHardgoodShippingGroupFormHandler"/>
<dsp:importbean bean="/atg/commerce/order/purchase/CreateElectronicShippingGroupFormHandler"/>

<dsp:setvalue bean="Profile.currentLocation" value="checkout"/>
<html>
<head>
<title>Shipping Information</title>
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
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i><p>

<%-- Check for errors  --%>
<dsp:droplet name="Switch">
  <dsp:param bean="ShippingGroupFormHandler.formError" name="value"/>
  <dsp:oparam name="true">
    <font color=cc0000><STRONG><UL>
      <dsp:droplet name="ErrorMessageForEach">
        <dsp:param bean="ShippingGroupFormHandler.formExceptions" name="exceptions"/>
        <dsp:oparam name="output">
        <LI> <dsp:valueof param="message"/>
        </dsp:oparam>
      </dsp:droplet>
    </UL></STRONG></font>
  </dsp:oparam>
</dsp:droplet>


<dsp:droplet name="ShippingGroupDroplet">
  <dsp:param name="clearShippingGroups" value="false"/>
  <dsp:param name="initShippingGroups" value="false"/>
  <dsp:param name="initShippingInfos" param="init"/>
  <dsp:oparam name="output">
  <%-- begin output --%>

<table border=0 cellpadding=0 cellspacing=0 width=800>
  
  <tr>
    <td width=55></td>
  <td valign="top" width=745>
  <table border=0 cellpadding=4 width=80%>
    <tr><td></td></tr>
    <tr><td></td></tr>
    <tr valign=top>
        <td>
<%-- table with multiple rows with 11 cells  --%>
        <table border=0 cellpadding=4 cellspacing=1 width=100%>
          <tr> 
            <td colspan=11><span class=help>To ship a line item to another address select the address and click the "Save" button. To ship only some of the items to another address change the quanity and select the address. You must save changes individually before continuing.
            </span></td>
          </tr>
          <tr bgcolor="#CCCCCC" valign=bottom>
            <td colspan=2><span class=smallbw>Part #</span></td>
            <td colspan=2><span class=smallbw>Name</span></td>
            <td colspan=2 align=middle><span class=smallbw>Qty</span></td>
            <td colspan=2 align=middle><span class=smallbw>Qty to move</span></td>
            <td colspan=2 align=middle><span class=smallbw>Shipping address</span></td>
            <td><span class=smallbw>Save changes</span></td>

          </tr>
<%-- get the real shopping cart items  --%>
          <dsp:droplet name="ForEach">
            <dsp:param name="array" param="order.commerceItems"/>
            <dsp:oparam name="output">
              <dsp:setvalue paramvalue="element" param="commerceItem"/>
              <dsp:setvalue bean="ShippingGroupFormHandler.listId" paramvalue="commerceItem.id"/>
              <dsp:droplet name="ForEach">
                <dsp:param bean="ShippingGroupFormHandler.currentList" name="array"/>
                <dsp:oparam name="output">
                  <%-- begin line item --%>
                  <dsp:setvalue paramvalue="element" param="cisiItem"/>
                  <dsp:form action="complex_shipping.jsp" method="post">
                  <tr valign=top>
              <dsp:droplet name="ComponentExists">
                <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
                <dsp:oparam name="true">
                   <td><nobr><dsp:valueof param="commerceItem.auxiliaryData.catalogRef.manufacturer_part_number"/></nobr></td>
                </dsp:oparam>
                <dsp:oparam name="false">
                   <td>&nbsp;</td>
                </dsp:oparam>
              </dsp:droplet>
                   <td></td>
                   <td><dsp:valueof param="commerceItem.auxiliaryData.catalogRef.displayName"/></td>
                   <td></td>
        
                   <td align=right><dsp:valueof param="element.quantity"/></td>
                   <td>&nbsp;</td>
                   <td>
                   <dsp:input bean="ShippingGroupFormHandler.currentList[param:index].splitQuantity" paramvalue="element.quantity" size="4" type="text"/></td>
                   <td>&nbsp;</td>
                   <td>
                     <dsp:select bean="ShippingGroupFormHandler.currentList[param:index].splitShippingGroupName">
                     <dsp:droplet name="ForEach">
                       <dsp:param name="array" param="shippingGroups"/>
                       <dsp:oparam name="output">
                         <dsp:droplet name="Switch">
                           <dsp:param name="value" param="key"/>
                           <dsp:getvalueof id="nameval4" param="cisiItem.shippingGroupName" idtype="java.lang.String">
<dsp:oparam name="<%=nameval4%>">
                             <dsp:getvalueof id="option305" param="key" idtype="java.lang.String">
<dsp:option selected="<%=true%>" value="<%=option305%>"/>
</dsp:getvalueof><dsp:valueof param="key"/>
                           </dsp:oparam>
</dsp:getvalueof>
                           <dsp:oparam name="default">
                             <dsp:getvalueof id="option313" param="key" idtype="java.lang.String">
<dsp:option selected="<%=false%>" value="<%=option313%>"/>
</dsp:getvalueof><dsp:valueof param="key"/>
                           </dsp:oparam>
                         </dsp:droplet>
                       </dsp:oparam>
                     </dsp:droplet>
                     </dsp:select>
                   </td>
                   <td></td>
                   <td>
                     <dsp:input bean="ShippingGroupFormHandler.splitShippingInfosSuccessURL" type="hidden" value="complex_shipping.jsp?init=false"/>
                     <dsp:input bean="ShippingGroupFormHandler.ListId" paramvalue="commerceItem.id" priority="<%=(int)9%>" type="hidden"/>
                     <dsp:input bean="ShippingGroupFormHandler.splitShippingInfos" type="submit" value=" Save "/>
                   </td>
                  </tr>
                  </dsp:form>
                  <%-- end line item --%>
                </dsp:oparam>
                <dsp:oparam name="empty">
                  <tr valign=top>
              <dsp:droplet name="ComponentExists">
                <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
                <dsp:oparam name="true">
                   <td><nobr><dsp:valueof param="commerceItem.auxiliaryData.catalogRef.manufacturer_part_number"/></nobr></td>
                </dsp:oparam>
                <dsp:oparam name="false">
                   <td>&nbsp;</td>
                </dsp:oparam>
              </dsp:droplet>
                   <td></td>
                   <td><dsp:valueof param="commerceItem.auxiliaryData.catalogRef.displayName"/></td>
                   <td></td>
        
                   <td align=right><dsp:valueof param="commerceItem.quantity"/></td>
                   <td>&nbsp;</td>
                   <td colspan=5>
                     No shipping choices (normal for a gift)
                   </td>
                  </tr>
                </dsp:oparam>
              </dsp:droplet><%-- end ForEach CommerceItemShippingInfos for one item --%>
            </dsp:oparam>
          </dsp:droplet><%-- end ForEach order.commerceItems --%>

        <tr>
          <td colspan=11>
<%-- table with one row with one cell  --%>
          <table border=0 cellpadding=0 cellspacing=0 width=100%>
            <tr bgcolor="#CCCCCC">
              <td></td>
            </tr>
          </table>
          </td>
        </tr>
      </table>
      </td>
    </tr>
    <tr>
      <td>
        <dsp:form action="complex_shipping.jsp" method="post">
        <dsp:input bean="ShippingGroupFormHandler.applyShippingGroupsSuccessURL" type="hidden" value="billing.jsp?init=true"/>
        <dsp:input bean="ShippingGroupFormHandler.applyShippingGroups" type="submit" value="Continue"/>
        </dsp:form>
     </td>
   </tr>
 </table>
 </td>
</tr>
</table>

  <%-- end output --%>
  </dsp:oparam>
</dsp:droplet><%-- end ShippingGroupDroplet --%>

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/complex_shipping.jsp#2 $$Change: 635969 $--%>
