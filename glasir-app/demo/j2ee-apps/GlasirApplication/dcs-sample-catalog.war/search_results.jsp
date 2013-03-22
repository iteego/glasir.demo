<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/commerce/catalog/ProductSearch"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:setvalue bean="Profile.currentLocation" value="catalog_search"/>

<html>
<head>
<title>Product Search Results</title>
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
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i><BR>

<h3>Search Results</h3>

<blockquote>
<dsp:droplet name="IsEmpty">
<dsp:param bean="ProductSearch.searchResults" name="value"/>
<dsp:oparam name="false">
<OL>
<dsp:droplet name="ForEach">
  <dsp:param bean="ProductSearch.searchResults" name="array"/>
  <dsp:oparam name="output">
    <LI>
<dsp:getvalueof id="pval0" param="element"><dsp:include page="product_fragment.jsp"><dsp:param name="childProduct" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>
  </dsp:oparam>
</dsp:droplet>
</OL>
</dsp:oparam>
<dsp:oparam name="true">
No items in the catalog could be found that match your search
</dsp:oparam>
</dsp:droplet>
</blockquote>

<P>
<dsp:include page="search_form.jsp"></dsp:include>
<P>
<dsp:include page="product_text_search.jsp"></dsp:include>
<P>
<dsp:include page="adv_search_form.jsp"></dsp:include>

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/search_results.jsp#2 $$Change: 635969 $--%>
