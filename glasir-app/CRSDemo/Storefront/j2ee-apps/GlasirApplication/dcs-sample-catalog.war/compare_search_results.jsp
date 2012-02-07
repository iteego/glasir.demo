<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<dsp:importbean bean="/atg/commerce/catalog/AdvProductSearch"/>
<dsp:importbean bean="/atg/commerce/catalog/RepositoryValues"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>
<dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListHandler"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<html>
<head>
<title>Product Comparison: Search Results</title>
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
<h3>Search Results</h3>

<P>

Here we present the results of a product search, and allow the user
to select the ones he or she would like added to the product comparison
list.

<P>

<dsp:getvalueof id="results" bean="AdvProductSearch.searchResults" idtype="java.util.Collection">
Got <%=results.size()%> results.
<p>
</dsp:getvalueof>

<dsp:form action="comparison.jsp" method="POST">
<dsp:droplet name="ForEach">
  <dsp:param bean="AdvProductSearch.searchResults" name="array"/>
  <dsp:param name="sortProperties" value="+displayName,+description"/>

  <dsp:oparam name="empty">
    <blockquote><strong>No matching products were found.</strong></blockquote>
  </dsp:oparam>

  <dsp:oparam name="outputStart">
    <blockquote>
    <strong>Select items to add to your product comparison list:</strong>
    <P>
    <table border=0 cellpadding=0 cellspacing=0>
  </dsp:oparam>

  <dsp:oparam name="output">
    <tr>
    <td>
      <dsp:input bean="ProductListHandler.productIdList" paramvalue="element.repositoryId" type="checkbox"/>
      <dsp:valueof param="element.displayName"/>
    </td>
    </tr>
  </dsp:oparam>

  <dsp:oparam name="outputEnd">
    </table></br>
    <dsp:input bean="ProductListHandler.addProductList" type="submit" value="Add to list"/>
    </blockquote>
  </dsp:oparam>

</dsp:droplet>
</dsp:form>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/compare_search_results.jsp#2 $$Change: 635969 $--%>
