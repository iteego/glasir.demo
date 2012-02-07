<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<HTML>
<HEAD>
<TITLE>Login</TITLE>
</HEAD>

<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>
<dsp:importbean bean="/atg/userprofiling/ProfileErrorMessageForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>

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
    Login or <dsp:a href="register.jsp">Register</dsp:a>
  </dsp:oparam>
</dsp:droplet>
<BR>

<h3>Member Login</h3>

<dsp:droplet name="Switch">
<dsp:param bean="ProfileFormHandler.profile.transient" name="value"/>
<dsp:oparam name="false">
  You are currently logged in. If you wish to login as a different user
  please logout first.
</dsp:oparam>

<dsp:oparam name="default">
<dsp:form action="login.jsp" method="POST">
<dsp:input bean="ProfileFormHandler.loginSuccessURL" type="HIDDEN" value="index.jsp"/>

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

<table width=456 border=0>
  <tr>
    <td valign=middle align=right>User Name:</td>
    <td><dsp:input bean="ProfileFormHandler.value.login" maxsize="20" size="20" type="TEXT"/></td>
  </tr>

  <tr>
    <td valign=middle align=right>Password:</td>
    <td><dsp:input bean="ProfileFormHandler.value.password" maxsize="20" size="20" type="PASSWORD"/></td>
  </tr>

  <tr>
    <td valign=middle align=right></td>
    <td><dsp:input bean="ProfileFormHandler.login" type="SUBMIT" value="login"/> or <dsp:a href="register.jsp">register</dsp:a></td>
  </tr>
</table>

</dsp:form>
</dsp:oparam>
</dsp:droplet>

</BODY>
</HTML>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/login.jsp#2 $$Change: 635969 $--%>
