<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/catalog/CategoryBrowsed"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>

<dsp:setvalue bean="Profile.currentLocation" value="catalog_category"/>


<dsp:droplet name="/atg/commerce/catalog/CategoryLookup">
   <dsp:param name="elementName" value="category"/>
   <!-- id would also be a param here but it was passed in -->
   <dsp:oparam name="output">

     <html>
     <head>
     <title><dsp:valueof param="category.displayName"/></title>
     </head>

     <body>

     <dsp:droplet name="CategoryBrowsed">
       <dsp:param name="eventobject" param="category"/>
     </dsp:droplet>

<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
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
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i>

     <P>

     <dsp:include page="category_navigation.jsp"></dsp:include>

     </body>
     </html>

  </dsp:oparam>
</dsp:droplet>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/display_category.jsp#2 $$Change: 635969 $--%>
