<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<%--
This page displays a table comparing attributes of all the products
in the user's product comparison list.
--%>

<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/BeanProperty"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:setvalue bean="Profile.currentLocation" value="catalog_comparison"/>

<html>
<head>
<title>Product Comparison</title>
</head>

<body>
<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
<dsp:a href="product_search.jsp">Product Search</dsp:a> - 
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a> - 
<dsp:a href="lists.jsp">My Lists</dsp:a> - 
Product Comparison -
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
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i>

<P>
<h3>Compare Products</h3>

<P>
This page displays a table comparing selected properties of the products
in the user's product comparison list.  The properties to display, and the 
column headings for each column, are configured through the <code>TableInfo</code> 
component at <code>/atg/commerce/catalog/comparison/TableInfo</code> in
Nucleus.  We don't necessarily know the property names when we write the
JSP for the table, so we use the <code>BeanProperty</code> droplet to 
render the value in each table cell based on the property names we see 
at runtime.

<P>

The <code>ProductList</code> bean holds a reference to this table description
object, allowing us to ask it for the list of columns to display and to manage
column sorting information if we want this table to be sortable by clicking
on its column headings.  (To keep the sample catalog simple, the table in this 
page is not sortable.  Refer to the Dynamo documentation on using the 
<code>TableInfo</code> component for detailed information on how to create 
sortable tables.)

<P>
<dsp:droplet name="ForEach">
  <dsp:param bean="ProductList.items" name="array"/>
  <dsp:param name="sortProperties" value="+product.displayName"/>

  <!-- If no entries in the list, tell the user -->
  <dsp:oparam name="empty">
    <strong>Your product comparison list is empty.</strong>
  </dsp:oparam>

  <!-- Display table headings using TableInfo class -->
  <dsp:oparam name="outputStart">
    <table border="1" cellpadding="5" cellspacing="1">
    <tr>
    <dsp:droplet name="ForEach">
      <dsp:param bean="ProductList.tableColumns" name="array"/>
      <dsp:param name="sortProperties" value=""/>
      <dsp:oparam name="output">
	<td><strong><dsp:valueof param="element.name"/></strong></td>
      </dsp:oparam>
    </dsp:droplet>	  
    </tr>
  </dsp:oparam>

  <!-- Display one table row for each item -->
  <dsp:oparam name="output">
    <dsp:setvalue paramvalue="element" param="currentProduct"/>
    <tr>
    <dsp:droplet name="ForEach">
      <dsp:param bean="ProductList.tableColumns" name="array"/>
      <dsp:param name="sortProperties" value=""/>
      <dsp:oparam name="output">
	<td>
	  <dsp:droplet name="BeanProperty">
	    <dsp:param name="bean" param="currentProduct"/>
	    <dsp:param name="propertyName" param="element.property"/>
	    <dsp:oparam name="output"><dsp:valueof valueishtml="<%=true%>" param="propertyValue"/></dsp:oparam>
	  </dsp:droplet>
	</td>
      </dsp:oparam>
    </dsp:droplet>	  
    </tr>
  </dsp:oparam>

  <!-- Close the table -->
  <dsp:oparam name="outputEnd">
    </table>
  </dsp:oparam>
</dsp:droplet>

<P>
<strong><dsp:a href="edit_comparison.jsp">Edit Comparison List</dsp:a></strong>
<P>
<strong><dsp:a href="compare_search.jsp">Search For More Products</dsp:a></strong>

</body>
</html>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/comparison.jsp#2 $$Change: 635969 $--%>
