<%-- 
  This page renders header of order detail items for email templates
--%>
<dsp:page>
  
    <fmt:message var="tableSummary" key="global_orderItemsHeader.tableSummary"/>
    <tr><td colspan="5"><hr size="1"></td></tr>
    <tr style="border-collapse: collapse;">
      <td style="width:60px;color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold"><fmt:message key="emailtemplates_orderConfirmation.itemSite"/></td>
      <td style="color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold;width:237px;"><fmt:message key="emailtemplates_orderConfirmation.itemName"/></td>
      <td style="color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold; width: 65px;"><fmt:message key="emailtemplates_orderConfirmation.itemQuantity"/></td>
      <td align="left" style="text-align:left;color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold;width:150px;"><fmt:message key="emailtemplates_orderConfirmation.itemPrice"/></td>
      <td align="right" style="color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold; width: 170px;"><fmt:message key="emailtemplates_orderConfirmation.itemTotal"/></td>
    </tr>
    <tr><td colspan="5"><hr size="1"></td></tr>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailOrderItemsHeader.jsp#1 $$Change: 633540 $--%>