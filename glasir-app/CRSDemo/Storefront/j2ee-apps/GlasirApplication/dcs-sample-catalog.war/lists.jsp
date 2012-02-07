<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>




<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>

<HTML>
<HEAD>
<TITLE>My Lists</TITLE>
</HEAD>

<BODY>
<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
<dsp:a href="product_search.jsp">Product Search</dsp:a> - 
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a> - 
My Lists - 
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

<blockquote>
Lists allow you to save products you want for later, and share your giftlists with friends.<BR>
All customers are given a default wish list.  This wish list is private and is never 
published to other customers. 
</blockquote>

<!-- Display any errors processing form -->
<dsp:include page="display_giftlist_errors.jsp"></dsp:include>

<P>

<dsp:include page="manage_wishlist.jsp"></dsp:include>

<p>

<dsp:include page="manage_giftlists.jsp"></dsp:include>

<p>

<dsp:include page="create_newgiftlist.jsp"></dsp:include>

</BODY>
</HTML>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/lists.jsp#2 $$Change: 635969 $--%>
