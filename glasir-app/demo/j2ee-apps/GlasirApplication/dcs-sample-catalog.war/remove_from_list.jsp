<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>




<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>

<!-- check if parameter giftlistId and giftId has been passed 
     into page.  ifso, then call RemoveItemFromGiftlist droplet 
     to remove item from the giftlist -->

<dsp:droplet name="IsEmpty">
<dsp:param name="value" param="giftId"/>
<dsp:oparam name="false">
  <dsp:droplet name="/atg/commerce/gifts/RemoveItemFromGiftlist">
    <dsp:param name="giftlistId" param="giftlistId"/>
    <dsp:param name="giftId" param="giftId"/>
    <dsp:oparam name="error">
      <font color=cc0000><STRONG><UL>
      <li>Either gift list not found or you are not the owner.
      </UL></STRONG></font>
    </dsp:oparam>
  </dsp:droplet>
</dsp:oparam>
</dsp:droplet>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/remove_from_list.jsp#2 $$Change: 635969 $--%>
