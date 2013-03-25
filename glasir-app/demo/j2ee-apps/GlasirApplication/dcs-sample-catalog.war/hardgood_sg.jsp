<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>

<%-- 
This page dispatches to either the B2B or B2C hardgood shipping
group page, depending on whether Dynamo is currently 
running with the B2BCommerce module loaded.
--%>

<dsp:droplet name="ComponentExists">
  <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
  <dsp:oparam name="true">
    <dsp:include page="hardgood_sg_b2b.jsp"/>
  </dsp:oparam>
  <dsp:oparam name="false">
    <dsp:include page="hardgood_sg_b2c.jsp"/>
  </dsp:oparam>
</dsp:droplet>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/hardgood_sg.jsp#2 $$Change: 635969 $--%>
