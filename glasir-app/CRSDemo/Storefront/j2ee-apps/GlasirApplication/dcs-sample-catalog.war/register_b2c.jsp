<%--
This version of the user registration page assumes you are using a
user profile like the default B2C user profile, which provides for
only one billing address and only one shipping addresses per user.

This version of the registration page stores the addresses provided
by the user in the billingAddress and shippingAddress properties of
the user profile.

The B2B version of the registration page works exactly the same
way, but assumes a B2B user profile with only multiple billing and
shipping addresses per user, so it stores the addresses provided 
here in the user's defaultBillingAddress and defaultShippingAddress
properties.  Except for this detail, the two pages are identical.
--%>

<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<HTML>
<HEAD>
<TITLE>Registration</TITLE>
</HEAD>

<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>
<dsp:importbean bean="/atg/userprofiling/ProfileErrorMessageForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>

<!-- This form should not show what the current profile attributes are so we will
     disable the ability to extract default values from the profile. -->
<dsp:setvalue bean="ProfileFormHandler.extractDefaultValuesFromProfile" value="false"/>

<BODY>
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
    <dsp:a href="login.jsp">Login</dsp:a> or Register
  </dsp:oparam>
</dsp:droplet>
<BR>

<h3>Member Registration</h3>

<dsp:droplet name="Switch">
<dsp:param bean="ProfileFormHandler.profile.transient" name="value"/>
<dsp:oparam name="false">
  You are currently logged in. If you wish to register as a new user
  please logout first.
</dsp:oparam>

<dsp:oparam name="default">
<dsp:form action="register.jsp" method="POST">
<dsp:input bean="ProfileFormHandler.createSuccessURL" type="HIDDEN" value="index.jsp"/>

<dsp:droplet name="Switch">
<dsp:param bean="ProfileFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="ProfileErrorMessageForEach">
      <dsp:param bean="ProfileFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
    </UL></STRONG></font>
</dsp:oparam>
</dsp:droplet>

<dsp:input bean="ProfileFormHandler.value.member" type="hidden" value="true"/>

<table>
<tr>

<td>
<table>
<tr>
<td>User Name:</td>
<td><dsp:input bean="ProfileFormHandler.value.login" maxsize="20" size="20" type="TEXT"/></td>
</tr>
<tr>
<td>Password:</td>
<td><dsp:input bean="ProfileFormHandler.value.password" maxsize="20" size="20" type="PASSWORD"/></td>
</tr>
<tr>
<td>Email Address:</td>
<td><dsp:input bean="ProfileFormHandler.value.email" maxsize="30" size="30" type="TEXT"/></td>
</tr>
</table>
</td>

<td>
<table>
<tr>
<td>First Name:</td>
<td><dsp:input bean="ProfileFormHandler.value.firstName" maxsize="30" size="30" type="TEXT"/></td>
</tr>
<tr>
<td>Middle Name:</td>
<td><dsp:input bean="ProfileFormHandler.value.middleName" maxsize="30" size="30" type="TEXT"/></td>
</tr>
<tr>
<td>Last Name:</td>
<td><dsp:input bean="ProfileFormHandler.value.lastName" maxsize="30" size="30" type="TEXT"/></td>
</tr>
</table>
</td>

</tr>

<tr>
<td>

<table>
<tr>
<td></td>
<td><i>Billing Address</i></td>
</tr>

<tr>
<td>Address:</td>
<td><dsp:input bean="ProfileFormHandler.value.billingAddress.address1" maxsize="30" size="30" type="TEXT"/></td>
</tr>

<tr>
<td>City:</td>
<td><dsp:input bean="ProfileFormHandler.value.billingAddress.city" maxsize="30" size="30" type="TEXT"/></td>
</tr>

<tr>
<td>State:</td>
<td>
<dsp:select bean="ProfileFormHandler.value.billingAddress.state">
<dsp:option value="AL"/>Alabama
<dsp:option value="AK"/>Alaska
<dsp:option value="AZ"/>Arizona
<dsp:option value="AR"/>Arkansas
<dsp:option value="CA"/>California
<dsp:option value="CO"/>Colorado
<dsp:option value="CT"/>Connecticut
<dsp:option value="DE"/>Delaware
<dsp:option value="FL"/>Florida
<dsp:option value="GA"/>Georgia
<dsp:option value="HI"/>Hawaii
<dsp:option value="ID"/>Idaho
<dsp:option value="IL"/>Illinois
<dsp:option value="IN"/>Indiana
<dsp:option value="IA"/>Iowa
<dsp:option value="KS"/>Kansas
<dsp:option value="KY"/>Kentucky
<dsp:option value="LA"/>Louisiana
<dsp:option value="ME"/>Maine
<dsp:option value="MD"/>Maryland
<dsp:option value="MA"/>Massachusetts
<dsp:option value="MI"/>Michigan
<dsp:option value="MN"/>Minnesota
<dsp:option value="MS"/>Mississippi
<dsp:option value="MO"/>Missouri
<dsp:option value="MT"/>Montana
<dsp:option value="NE"/>Nebraska
<dsp:option value="NV"/>Nevada
<dsp:option value="NH"/>New Hampshire
<dsp:option value="NJ"/>New Jersey
<dsp:option value="NM"/>New Mexico
<dsp:option value="NY"/>New York
<dsp:option value="NC"/>North Carolina
<dsp:option value="ND"/>North Dakota
<dsp:option value="OH"/>Ohio
<dsp:option value="OK"/>Oklahoma
<dsp:option value="OR"/>Oregon
<dsp:option value="PA"/>Pennsylvania
<dsp:option value="RI"/>Rhode Island
<dsp:option value="SC"/>South Carolina
<dsp:option value="SD"/>South Dakota
<dsp:option value="TN"/>Tennessee
<dsp:option value="TX"/>Texas
<dsp:option value="UT"/>Utah
<dsp:option value="VT"/>Vermont
<dsp:option value="VA"/>Virginia
<dsp:option value="WA"/>Washington
<dsp:option value="DC"/>Washington D.C.
<dsp:option value="WV"/>West Virginia
<dsp:option value="WI"/>Wisconsin
<dsp:option value="WY"/>Wyoming
</dsp:select>
</td>
</tr>

<tr>
<td>Zipcode:</td>
<td><dsp:input bean="ProfileFormHandler.value.billingAddress.postalCode" maxsize="10" size="10" type="TEXT"/></td>
</tr>

<tr>
<td>Country:</td>
<td><dsp:input bean="ProfileFormHandler.value.billingAddress.country" maxsize="10" size="10" type="TEXT"/></td>
</tr>
</table>
</td>

<td>

<table>
<tr>
<td></td>
<td><i>Shipping Address</i></td>
</tr>

<tr>
<td>Address:</td>
<td><dsp:input bean="ProfileFormHandler.value.shippingAddress.address1" maxsize="30" size="30" type="TEXT"/></td>
</tr>

<tr>
<td>City:</td>
<td><dsp:input bean="ProfileFormHandler.value.shippingAddress.city" maxsize="30" size="30" type="TEXT"/></td>
</tr>

<tr>
<td>State:</td>
<td>
<dsp:select bean="ProfileFormHandler.value.shippingAddress.state">
<dsp:option value="AL"/>Alabama
<dsp:option value="AK"/>Alaska
<dsp:option value="AZ"/>Arizona
<dsp:option value="AR"/>Arkansas
<dsp:option value="CA"/>California
<dsp:option value="CO"/>Colorado
<dsp:option value="CT"/>Connecticut
<dsp:option value="DE"/>Delaware
<dsp:option value="FL"/>Florida
<dsp:option value="GA"/>Georgia
<dsp:option value="HI"/>Hawaii
<dsp:option value="ID"/>Idaho
<dsp:option value="IL"/>Illinois
<dsp:option value="IN"/>Indiana
<dsp:option value="IA"/>Iowa
<dsp:option value="KS"/>Kansas
<dsp:option value="KY"/>Kentucky
<dsp:option value="LA"/>Louisiana
<dsp:option value="ME"/>Maine
<dsp:option value="MD"/>Maryland
<dsp:option value="MA"/>Massachusetts
<dsp:option value="MI"/>Michigan
<dsp:option value="MN"/>Minnesota
<dsp:option value="MS"/>Mississippi
<dsp:option value="MO"/>Missouri
<dsp:option value="MT"/>Montana
<dsp:option value="NE"/>Nebraska
<dsp:option value="NV"/>Nevada
<dsp:option value="NH"/>New Hampshire
<dsp:option value="NJ"/>New Jersey
<dsp:option value="NM"/>New Mexico
<dsp:option value="NY"/>New York
<dsp:option value="NC"/>North Carolina
<dsp:option value="ND"/>North Dakota
<dsp:option value="OH"/>Ohio
<dsp:option value="OK"/>Oklahoma
<dsp:option value="OR"/>Oregon
<dsp:option value="PA"/>Pennsylvania
<dsp:option value="RI"/>Rhode Island
<dsp:option value="SC"/>South Carolina
<dsp:option value="SD"/>South Dakota
<dsp:option value="TN"/>Tennessee
<dsp:option value="TX"/>Texas
<dsp:option value="UT"/>Utah
<dsp:option value="VT"/>Vermont
<dsp:option value="VA"/>Virginia
<dsp:option value="WA"/>Washington
<dsp:option value="DC"/>Washington D.C.
<dsp:option value="WV"/>West Virginia
<dsp:option value="WI"/>Wisconsin
<dsp:option value="WY"/>Wyoming
</dsp:select>
</td>
</tr>

<tr>
<td>Zipcode:</td>
<td><dsp:input bean="ProfileFormHandler.value.shippingAddress.postalCode" maxsize="10" size="10" type="TEXT"/></td>
</tr>
<tr>
<td>Country:</td>
<td><dsp:input bean="ProfileFormHandler.value.shippingAddress.country" maxsize="10" size="10" type="TEXT"/></td>
</tr>

</table>
</td>
</tr>
</table>

<dsp:input bean="ProfileFormHandler.create" type="SUBMIT" value="register"/> or <dsp:a href="login.jsp">login</dsp:a>

</dsp:form>
</dsp:oparam>
</dsp:droplet>

</BODY>
</HTML>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/register_b2c.jsp#2 $$Change: 635969 $--%>
