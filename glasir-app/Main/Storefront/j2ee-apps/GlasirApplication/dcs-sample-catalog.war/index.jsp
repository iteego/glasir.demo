<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/targeting/TargetingForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>

<dsp:setvalue bean="Profile.currentLocation" value="home"/>
<html>
<head>
<title>Sample Product Catalog (home)</title>
</head>

<body>
Catalog Home - 
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
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i><BR>

<h3>Sample Product Catalog</h3>

<dsp:droplet name="Switch">
<dsp:param bean="Profile.transient" name="value"/>
<dsp:oparam name="false">
Welcome <dsp:valueof bean="Profile.firstName"/>!
</dsp:oparam>
<dsp:oparam name="true">
<dsp:a href="login.jsp">Login</dsp:a> or <dsp:a href="register.jsp">Register</dsp:a>
</dsp:oparam>
</dsp:droplet>

<P>

<dsp:droplet name="ForEach">
  <dsp:param name="array" bean="Profile.catalog.allRootCategories"/>
  <dsp:param name="elementName" value="category"/>
  <dsp:oparam name="output">
    <dsp:include page="category_navigation.jsp"></dsp:include>
  </dsp:oparam>
</dsp:droplet>

<dsp:include page="product_text_search.jsp" flush="true"></dsp:include>

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/index.jsp#1 $$Change: 633540 $--%>
