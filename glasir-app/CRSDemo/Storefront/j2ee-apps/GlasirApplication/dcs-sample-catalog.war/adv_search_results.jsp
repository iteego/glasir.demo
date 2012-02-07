<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<!--
*
* This jhtml file demonstrates how to display the results of an advanced
* search for products in the product catalog repository.  The session scoped
* AdvProductSearch form handler will store results of search in the property
* searchResults.  This page will iterate through information in
* that property using the switch and foreach droplets.
*
* The ForEach droplet is used to iterate over each item in the result set 
* of items returned from the search.  The product template is used to 
* display the actual product.
*
-->

<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/commerce/catalog/AdvProductSearch"/>
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

<h3>Search Results</h3>

<blockquote>
<!-- Use the IsEmpty droplet on SearchResults to either display products
or a message that no products have been found -->
<dsp:droplet name="IsEmpty">
<dsp:param bean="AdvProductSearch.searchResults" name="value"/>
<dsp:oparam name="false">
<OL>
<!-- AdvProductSearch will return a single result set of all products
returned from the given search criteria.  Iterate through the result
set to display each product. -->
<dsp:droplet name="ForEach">
  <dsp:param bean="AdvProductSearch.searchResults" name="array"/>
  <dsp:oparam name="output">
    <LI>
<!-- use product_fragment to display each product in the result set -->
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
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/adv_search_results.jsp#2 $$Change: 635969 $--%>
