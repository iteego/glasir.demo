<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupDroplet"/>
<dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
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
<dsp:droplet name="Switch">
<dsp:param bean="CreateHardgoodShippingGroupFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="ErrorMessageForEach">
      <dsp:param bean="CreateHardgoodShippingGroupFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
    </UL></STRONG></font>
</dsp:oparam>
</dsp:droplet>
<dsp:droplet name="Switch">
<dsp:param bean="CreateElectronicShippingGroupFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="ErrorMessageForEach">
      <dsp:param bean="CreateElectronicShippingGroupFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
    </UL></STRONG></font>
</dsp:oparam>
</dsp:droplet>

<h3>Shipping Information</h3>
<dsp:droplet name="ShippingGroupDroplet">
  <dsp:param name="clear" param="init"/>
  <dsp:param name="shippingGroupTypes" value="hardgoodShippingGroup"/>
  <dsp:param name="initShippingGroups" param="init"/>
  <dsp:param name="initShippingInfos"  param="init"/>
  <dsp:oparam name="output">
  <!-- begin output -->
    <dsp:droplet name="ForEach">
      <dsp:param name="array" param="shippingGroups"/>
      <dsp:oparam name="outputStart">
      <dsp:form action="shipping.jsp" method="post">
        <dsp:input bean="ShippingGroupFormHandler.applyShippingGroupsSuccessURL" type="hidden" value="billing.jsp?init=true"/>
        <dsp:input bean="ShippingGroupFormHandler.specifyDefaultShippingGroupSuccessURL" type="hidden" value="complex_shipping.jsp?init=true"/>
        <dsp:input bean="ShippingGroupFormHandler.applyDefaultShippingGroup" type="hidden" value="true"/>
        <dsp:droplet name="Switch">
          <dsp:param name="value" param="size"/>
          <dsp:oparam name="0">
            You have not entered any shipping information.
          </dsp:oparam>
          <dsp:oparam name="1">
            <b>One ShippingGroup</b><BR>
            <dsp:droplet name="ForEach">
              <dsp:param name="array" param="shippingGroups"/>
              <dsp:oparam name="output">
                <br><dsp:input bean="ShippingGroupDroplet.ShippingGroupMapContainer.defaultShippingGroupName" paramvalue="key" type="hidden"/>
                <dsp:getvalueof id="pval0" param="element.shippingAddress"><dsp:include page="display_address.jsp"><dsp:param name="address" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>
                <dsp:input bean="ShippingGroupFormHandler.applyShippingGroups" type="submit" value="Ship Entire Order to this Address"/>  
              </dsp:oparam>
            </dsp:droplet>
          </dsp:oparam>
          <dsp:oparam name="default">
            <b>One ShippingGroup</b><BR>
            <dsp:droplet name="ForEach">
              <dsp:param name="array" param="shippingGroups"/>
              <dsp:oparam name="output">
                <br><dsp:input bean="ShippingGroupDroplet.ShippingGroupMapContainer.defaultShippingGroupName" paramvalue="key" type="radio"/>
                <dsp:valueof param="key"/>
              </dsp:oparam>
            </dsp:droplet>
            <dsp:input bean="ShippingGroupFormHandler.applyShippingGroups" type="submit" value="Ship Entire Order to this Address"/>  
            <p><b>Multiple ShippingGroups</b>
            <p>The entire order begins on the default ShipingGroup. Specific item quantities may then be split onto separate ShippingGroups.
            <dsp:droplet name="ForEach">
              <dsp:param name="array" param="shippingGroups"/>
              <dsp:oparam name="output">
                <br><dsp:input bean="ShippingGroupFormHandler.defaultShippingGroupName" paramvalue="key" type="radio"/>
                <dsp:valueof param="key"/>
              </dsp:oparam>
            </dsp:droplet>
            <dsp:input bean="ShippingGroupFormHandler.specifyDefaultShippingGroup" type="submit" value="Make this the default Address"/>
          </dsp:oparam>
        </dsp:droplet>
        </dsp:form>
      </dsp:oparam>
    </dsp:droplet><!-- end ForEach -->
  <!-- end output -->
  </dsp:oparam>
</dsp:droplet><!-- end ShippingGroupDroplet -->

<dsp:include page="hardgood_sg.jsp"></dsp:include>
<%-- <dsp:include page="electronic_sg.jsp"></dsp:include> %-->

<%-- 
In order to facilitate the creation of an ElectronicShippingGroup, then 
electronic_sg.jhtml should be used in place of hardgood_sg.jhtml. This feature
is used for those orders whose skus all use SoftgoodFulfillers.
--%>

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/shipping.jsp#2 $$Change: 635969 $--%>
