<dsp:page>

<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>
<dsp:importbean bean="/atg/userprofiling/ProfileErrorMessageForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/glasir/sample/MyAtgModule"/>

<html>
<head>
<title>Iteego Test Page</title>
</head>


<!-- This form should not show what the current profile attributes are so we will
     disable the ability to extract default values from the profile. -->
<dsp:setvalue bean="ProfileFormHandler.extractDefaultValuesFromProfile" value="false"/>

<body>
<div>The value of the MyAtgModule.someValue is <dsp:valueof bean="MyAtgModule.someValue">not set</dsp:valueof></div>
<div><a href="/dyn/admin">dynamo admin</div>

<dsp:droplet name="Switch">
  <dsp:param bean="Profile.transient" name="value"/>
  <dsp:oparam name="false">
    <dsp:a href="logout.jsp">Logout</dsp:a>
  </dsp:oparam>
  <dsp:oparam name="true">
    Login or <dsp:a href="register.jsp">Register</dsp:a>
  </dsp:oparam>
</dsp:droplet>

<h3>Member Login</h3>

<dsp:droplet name="Switch">
<dsp:param bean="ProfileFormHandler.profile.transient" name="value"/>
<dsp:oparam name="false">
  You are currently logged in as <dsp:valueof bean="Profile.firstName"></dsp:valueof> <dsp:valueof bean="Profile.lastName"></dsp:valueof> (<dsp:valueof bean="Profile.login">just logged out</dsp:valueof>).
  If you wish to login as a different user please logout first.
</dsp:oparam>

<dsp:oparam name="default">
<dsp:form action="." method="POST">
<dsp:input bean="ProfileFormHandler.loginSuccessURL" type="HIDDEN" value="index.jsp"/>

<dsp:droplet name="Switch">
<dsp:param bean="ProfileFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG><UL name="formErrors">
    <dsp:droplet name="ProfileErrorMessageForEach">
      <dsp:param bean="ProfileFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/> </LI>
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

</body>
</html>

</dsp:page>
