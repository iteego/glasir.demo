<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>

<%--
Customers who are logged in are able to create new
giftlists. We'll display a message to anonymous users that this
feature is available later.
--%>

<dsp:droplet name="Switch">
  <dsp:param bean="Profile.transient" name="value"/>
  <dsp:oparam name="false">
    <strong>Make a new gift list</strong>
    <dsp:form action="lists_new.jsp" method="POST">
    <dsp:input bean="GiftlistFormHandler.createGiftlistSuccessURL" type="hidden" value="./lists_new.jsp"/>
    <dsp:input bean="GiftlistFormHandler.createGiftlistErrorURL" type="hidden" value="./lists.jsp"/>
    Name of event (i.e. Harry's Wedding List)<br>
    <dsp:input bean="GiftlistFormHandler.eventName" size="25" type="text" value="New Event"/>
    <dsp:input bean="GiftlistFormHandler.createGiftlist" type="submit" value="Create list"/>
    </dsp:form>
  </dsp:oparam>
  <dsp:oparam name="default">
    <b>Login or Register and create a gift list!</b><p>
    Registered customers are able to create, update and publish
    gift lists for upcoming events.  Register today and let your friends
    know what you'd like for your birthday. <dsp:a href="login.jsp">Login</dsp:a> or <dsp:a href="register.jsp">Register</dsp:a> now and start working on your gift list. 
  </dsp:oparam>
</dsp:droplet>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/create_newgiftlist.jsp#2 $$Change: 635969 $--%>
