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
<td>Last Name:</td>
<td><dsp:input bean="ProfileFormHandler.value.lastName" maxsize="30" size="30" type="TEXT"/></td>
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
