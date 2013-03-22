<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<!--
*
* This jhtml file demonstrates how to display the results of a simple
* search for products in the product catalog repository.  The session scoped
* CatalogSearch form handler will store results of search in the property
* searchResultsByItemType.  This page will iterate through information in
* that property using the switch and foreach droplets.
*
* The first ForEach droplet used is to iterate through each result set returned
* for a given item type.  The results are stored in a table indexed by item
* type or key.  The next droplet used is Switch which tests for a specific
* item type (category or product).  Finally, an inner ForEach droplet is
* used to iterate over each item in the result set to be displayed.  The
* corresponding template is used to display the particular item.
*
-->

<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/commerce/catalog/CatalogSearch"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<dsp:setvalue bean="Profile.currentLocation" value="catalog_search"/>

<html>
<head>
<title>Search Results</title>
</head>

<body>
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i><BR>
<dsp:a href="index.jsp">Catalog Home</dsp:a><BR>
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a>

<h3>Search Results</h3>

<!-- CatalogSearch will return multiple result sets based on item type,
category and product.  iterate through each result set by item type
to display the type of item returned by the query. -->
<dsp:droplet name="ForEach">
  <dsp:param bean="CatalogSearch.searchResultsByItemType" name="array"/>
  <dsp:oparam name="output">
  <dsp:droplet name="Switch">
    <dsp:param name="value" param="key"/>
    <!-- item type equals category, display all categories found -->
    <dsp:oparam name="category">
    <h2>Category Results</h2>
    <blockquote>
    <!-- using an inner loop, so assign subResultSet to parameter
    outerelem -->
    <dsp:setvalue paramvalue="element" param="outerelem"/>
    <dsp:droplet name="IsEmpty">
    <dsp:param name="value" param="outerelem"/>
    <dsp:oparam name="false">
    <OL>
    <!-- for each item found in subResultSet, outerelem, loop through
    and display each category -->
    <dsp:droplet name="ForEach">
      <dsp:param name="array" param="outerelem"/>
      <dsp:oparam name="output">
        <LI>
      <!-- use category_fragment to display each category -->
      <dsp:getvalueof id="pval0" param="element"><dsp:include page="category_fragment.jsp"><dsp:param name="childCategory" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>
      </dsp:oparam>
    </dsp:droplet>
    </OL>
    </dsp:oparam>
    <!-- no categories found -->
    <dsp:oparam name="true">
    No category items in the catalog could be found that match your search
    </dsp:oparam>
    </dsp:droplet>
    </blockquote>

    </dsp:oparam>
    <!-- item type equals product, display all products found -->
    <dsp:oparam name="product">
    <h2>Product Results</h2>
    <blockquote>
    <dsp:setvalue paramvalue="element" param="outerelem"/>
    <dsp:droplet name="IsEmpty">
      <dsp:param name="value" param="outerelem"/>
      <dsp:oparam name="false">
        <OL>
        <!-- for each item found in subResultSet, outerelem, loop through
        and display each product -->
        <dsp:droplet name="ForEach">
          <dsp:param name="array" param="outerelem"/>
          <dsp:oparam name="output">
          <LI>
            <!-- use product_fragment.jhtml to display each product -->
            <dsp:getvalueof id="pval0" param="element"><dsp:include page="product_fragment.jsp"><dsp:param name="childProduct" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>
      </dsp:oparam>
      </dsp:droplet>
      </OL>
    </dsp:oparam>
    <dsp:oparam name="true">
    No product items in the catalog could be found that match your search
    </dsp:oparam>
    </dsp:droplet>
    </blockquote>
    </dsp:oparam>
  </dsp:droplet>
  </dsp:oparam>
</dsp:droplet>

<!-- include catalog_search_form.jhtml for other searches -->
<dsp:include page="catalog_search_form.jsp"></dsp:include>

</body>
</html>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/catalog_search_results.jsp#2 $$Change: 635969 $--%>
