<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<%--
This page edits the contents of the user's product comparison list.
--%>

<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/BeanProperty"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListHandler"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:setvalue bean="Profile.currentLocation" value="catalog_comparison"/>

<html>
<head>
<title>Edit Product Comparison List</title>
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
<h3>Edit Product Comparison List</h3>

<P>
This page edits the product comparison list using the standard
<code>ProductListHandler</code> form handler.  The form handler 
allows you to clear the list, remove specific items from the list
by id, or remove all items for a given category or product.  This
example demonstrates the first two uses of the form handler -- 
clearing the list, and removing selected items by item id.

<P>

<dsp:form action="edit_comparison.jsp" method="POST">
<dsp:droplet name="ForEach">
  <dsp:param bean="ProductList.items" name="array"/>
  <dsp:param name="sortProperties" value="+product.displayName"/>

  <dsp:oparam name="empty">
    <strong>Your product comparison list is empty.</strong>
  </dsp:oparam>

  <dsp:oparam name="outputStart">
    <strong>Select the items you wish to remove from your comparison list:</strong>
    <blockquote>
  </dsp:oparam>

  <dsp:oparam name="output">
    <dsp:setvalue paramvalue="element" param="currentEntry"/>
    <dsp:input bean="ProductListHandler.entryIds" paramvalue="currentEntry.id" type="checkbox"/>
    <dsp:valueof valueishtml="<%=true%>" param="currentEntry.product.displayName"/><br>
  </dsp:oparam>

  <dsp:oparam name="outputEnd">
    </blockquote>
    <br>
    <dsp:input bean="ProductListHandler.clearListSuccessURL" type="hidden" value="comparison.jsp"/>
    <dsp:input bean="ProductListHandler.clearList" type="submit" value="Clear List"/> &nbsp;
    <dsp:input bean="ProductListHandler.removeProductSuccessURL" type="hidden" value="comparison.jsp"/>
    <dsp:input bean="ProductListHandler.removeEntries" type="submit" value="Remove Selected Items"/>
  </dsp:oparam>
</dsp:droplet>
</dsp:form>
<P>
<strong><dsp:a href="compare_search.jsp">Search For More Products</dsp:a></strong>

</body>
</html>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/edit_comparison.jsp#2 $$Change: 635969 $--%>
