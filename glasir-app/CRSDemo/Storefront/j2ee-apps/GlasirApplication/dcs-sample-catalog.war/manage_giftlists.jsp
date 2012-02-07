<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>

<dsp:include page="remove_from_list.jsp"></dsp:include>

<dsp:droplet name="IsEmpty">
  <dsp:param bean="Profile.giftlists" name="value"/>
  <dsp:oparam name="false">  
    <dsp:droplet name="/atg/dynamo/droplet/ForEach">
      <dsp:param bean="Profile.giftlists" name="array"/>
      <dsp:oparam name="output">
        <dsp:getvalueof id="pval0" param="element"><dsp:include page="manage_singlegiftlist.jsp"><dsp:param name="giftlist" value="<%=pval0%>"/></dsp:include></dsp:getvalueof>
      </dsp:oparam>
    </dsp:droplet>
  </dsp:oparam>
</dsp:droplet>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/manage_giftlists.jsp#2 $$Change: 635969 $--%>
