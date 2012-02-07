<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/gifts/GiftlistSearch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>


<dsp:droplet name="IsEmpty">
  <dsp:param bean="GiftlistSearch.searchResults" name="value"/>
  <dsp:oparam name="false">
    Your search found these gift lists.<br>
    Click the person's name to shop for them.
    <blockquote>
    <dsp:droplet name="ForEach">
      <dsp:param bean="GiftlistSearch.searchResults" name="array"/>
      <dsp:oparam name="output">
        <dsp:a href="giftlist_search.jsp">
          <dsp:param name="action" value="add"/>
          <dsp:param name="searching" value="false"/>
          <dsp:param name="giftlistId" param="element.id"/>
          <dsp:valueof param="element.owner.firstName"/>
          <dsp:valueof param="element.owner.middleName"/>
          <dsp:valueof param="element.owner.lastName"/>
   	 </dsp:a>
         <dsp:valueof param="element.eventName"/>
         <dsp:valueof param="element.eventDate"/>
         <br>
       </dsp:oparam>
     </dsp:droplet>  
     </blockquote>
  </dsp:oparam>
  <dsp:oparam name="true">
    Your search found no gift lists.
  </dsp:oparam>
</dsp:droplet>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/giftlist_search_results.jsp#2 $$Change: 635969 $--%>
