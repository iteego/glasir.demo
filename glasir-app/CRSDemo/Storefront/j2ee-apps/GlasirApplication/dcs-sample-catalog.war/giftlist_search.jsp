<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<%--
This template allows you to search for giftlists and choose
which you will be shopping for.
--%>

<dsp:importbean bean="/atg/commerce/gifts/GiftlistSearch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsNull"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<html>
<head>
<title>Find a Gift List</title>
</head>

<body>
<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
<dsp:a href="product_search.jsp">Product Search</dsp:a> - 
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a> - 
<dsp:a href="lists.jsp">My Lists</dsp:a> - 
<dsp:a href="comparison.jsp">Product Comparison</dsp:a> -
Gift List Search - 
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

<%-- If param:giftlistId is passed, then add or remove it from the profile.  --%>

<dsp:droplet name="IsEmpty">
<dsp:param name="value" param="giftlistId"/>
<dsp:oparam name="false">
  <dsp:droplet name="/atg/commerce/gifts/GiftlistDroplet">
    <dsp:param name="giftlistId" param="giftlistId"/>
    <dsp:param name="action" param="action"/>
    <dsp:param bean="/atg/userprofiling/Profile" name="profile"/>
  </dsp:droplet>
</dsp:oparam>
</dsp:droplet>

<%-- Display the giftlists that customer is shopping for.  --%>

<dsp:droplet name="IsEmpty">
  <dsp:param bean="Profile.otherGiftlists" name="value"/>
  <dsp:oparam name="false">
    <strong>You are shopping for these people</strong><br>
    <P>
    <dsp:droplet name="/atg/dynamo/droplet/ForEach">
    <dsp:param bean="Profile.otherGiftlists" name="array"/>
    <dsp:oparam name="output">
      <p>
      <b><dsp:valueof param="element.owner.firstName"/>
      <dsp:valueof param="element.owner.middleName"/>
      <dsp:valueof param="element.owner.lastName"/></b></br>
      <dsp:valueof param="element.eventName"/>
      <dsp:valueof date="dd-MMM-yyyy" param="element.eventDate"/><br>
      <b>Event Description</b><br>
      <dsp:valueof param="element.description"/><br>
      <b>Extra Information</b><br>
      <dsp:valueof param="element.instructions"/><br>
      &gt; <dsp:a href="giftlist_view.jsp"> <dsp:param name="giftlistId" param="element.id"/>View the items in this gift list</dsp:a>
      <br>
      &gt; <dsp:a href="giftlist_search.jsp">
 	     <dsp:param name="giftlistId" param="element.id"/>
             <dsp:param name="action" value="remove"/>
             Stop shopping for this person</dsp:a>
    </dsp:oparam>
    </dsp:droplet>
    <hr size=0>
</dsp:oparam>
</dsp:droplet>

<p>

<dsp:droplet name="IsNull">
  <dsp:param name="value" param="searching"/>
  <dsp:oparam name="false">
    <dsp:include page="giftlist_search_results.jsp"></dsp:include>
  </dsp:oparam>
</dsp:droplet>

<P>

<dsp:include page="giftlist_search_form.jsp"></dsp:include>

</BODY>
</HTML>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/giftlist_search.jsp#2 $$Change: 635969 $--%>
