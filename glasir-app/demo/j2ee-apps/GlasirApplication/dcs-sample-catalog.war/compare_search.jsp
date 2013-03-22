<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<dsp:importbean bean="/atg/commerce/catalog/AdvProductSearch"/>
<dsp:importbean bean="/atg/commerce/catalog/RepositoryValues"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<html>
<head>
<title>Product Comparison: Product Search</title>
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
<dsp:droplet name="IsEmpty">
  <dsp:param bean="ProductList.items" name="value"/>
  <dsp:oparam name="true"><h3>Search for products to compare</h3></dsp:oparam>
  <dsp:oparam name="false"><h3>Search for more products to compare</h3></dsp:oparam>
</dsp:droplet>

<P>

Here we allow the user to search the product catalog for products to
add to his or her product comparison list.  We use the advanced search
form handler so the user can limit the search to a single category, or
search the entire catalog.

<%-- Display any errors resulting from a failed search attempt  --%>

<dsp:droplet name="Switch">
  <dsp:param bean="AdvProductSearch.formError" name="value"/>
  <dsp:oparam name="true">
    <font color=cc0000><P><STRONG><UL>
      <dsp:droplet name="ErrorMessageForEach">
        <dsp:param bean="AdvProductSearch.formExceptions" name="exceptions"/>
        <dsp:oparam name="output">
        <LI> <dsp:valueof param="message"/>
        </dsp:oparam>
      </dsp:droplet>
    </UL></STRONG></font>
  </dsp:oparam>
</dsp:droplet>

<%-- Display the search form  --%>

<dsp:form action="compare_search.jsp" method="POST">
  <dsp:input bean="AdvProductSearch.successURL" type="hidden" value="compare_search_results.jsp"/>

  <table border=0 cellpadding=8 cellspacing=0>
  <tr>
    <td align=right>Search in category</td>
    <td>
    <dsp:select bean="AdvProductSearch.hierarchicalCategoryId">
      <dsp:option value=""/>-- All categories --
      <dsp:droplet name="RepositoryValues">
	<dsp:param name="itemDescriptorName" value="category"/>
	<dsp:oparam name="output">
	  <dsp:droplet name="ForEach">
	    <dsp:param name="array" param="values"/>
	    <dsp:param name="sortProperties" value="+displayName"/>
	    <dsp:oparam name="output">
	      <dsp:getvalueof id="option178" param="element.repositoryId" idtype="java.lang.String">
	      <dsp:option value="<%=option178%>"/>
	      </dsp:getvalueof>
	      <dsp:valueof param="element.displayName"/>
	    </dsp:oparam>
	  </dsp:droplet>
	</dsp:oparam>
      </dsp:droplet>
    </dsp:select>
    </td>
  </tr>

  <tr>
    <td align=right>Search text</td>
    <td><dsp:input bean="AdvProductSearch.searchInput" size="25" type="text"/>
<%--Include hidden input field so hitting return here submits the form --%>
        <dsp:input bean="AdvProductSearch.search" type="hidden" value="Search"/></td>
  </tr>

  <tr>
    <td></td>
    <td>
      <dsp:input bean="AdvProductSearch.search" type="submit" value="Search"/>
    </td>
  </tr>

  </table>
</dsp:form>

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/compare_search.jsp#2 $$Change: 635969 $--%>
