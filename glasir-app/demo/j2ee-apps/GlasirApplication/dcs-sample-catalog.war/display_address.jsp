<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<%--
Display an address 
--%>

<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>



<dsp:valueof param="address.address1"/><br>
<dsp:droplet name="IsEmpty">
  <dsp:param name="value" param="address.address2"/>
  <dsp:oparam name="false">
    <dsp:valueof param="address.address2"/><br>
  </dsp:oparam>
</dsp:droplet>    
<dsp:valueof param="address.city"/>,
<dsp:valueof param="address.state"/>
<dsp:valueof param="address.postalCode"/>
<br>
<dsp:valueof param="address.country"/>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/display_address.jsp#2 $$Change: 635969 $--%>
