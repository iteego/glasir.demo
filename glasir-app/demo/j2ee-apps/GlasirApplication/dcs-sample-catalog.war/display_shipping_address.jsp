<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>

<dsp:valueof param="address.firstName"/>
<dsp:valueof param="address.middleName"/>
<dsp:valueof param="address.lastName"/><BR>
<dsp:valueof param="address.address1"/><BR>
<dsp:droplet name="IsEmpty">
 <dsp:param name="value" param="address.address2"/>
 <dsp:oparam name="false">
   <dsp:valueof param="address.address2"/><BR>
 </dsp:oparam>
</dsp:droplet>
<dsp:valueof param="address.city"/>, 
<dsp:valueof param="address.state"/> 
<dsp:valueof param="address.postalCode"/><BR>
<dsp:valueof param="address.country"/><BR>
<dsp:valueof param="address.email"/><BR>
<dsp:valueof param="address.phoneNumber"/><BR>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/display_shipping_address.jsp#2 $$Change: 635969 $--%>
