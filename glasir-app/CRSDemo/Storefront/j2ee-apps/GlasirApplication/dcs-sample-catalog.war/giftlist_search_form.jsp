<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/gifts/GiftlistSearch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>

<h3>Find a Gift List</h3>

<dsp:form action="giftlist_search.jsp" method="POST">

Name: <dsp:input bean="GiftlistSearch.searchInput" size="30" type="text"/>

<p>

Optional criteria that may make it easier to find the right list:

<blockquote>
<dsp:droplet name="ForEach">
  <!-- For each property specified in 
   GiftlistSearch.advancedSearchPropertyNames, retrieve all possible 
   property values.  This allows the customer
   to pick one to search on for advanced searching. -->
  <dsp:param bean="GiftlistSearch.propertyValuesByType" name="array"/>
  <dsp:oparam name="output">
  <dsp:droplet name="Switch">
    <dsp:param name="value" param="key"/>
    <!-- One property that a gift list can have is eventType.
     In this case, if the property is eventType, we want to put all
     possible choices in a pulldown menu. -->
    <dsp:oparam name="eventType">
    Event Type
      <!-- property to store the customer's selection is propertyValues -->
      <dsp:select bean="GiftlistSearch.propertyValues.eventType">
      <dsp:option value=""/>Any
      <dsp:setvalue paramvalue="element" param="outerelem"/>
      <dsp:droplet name="ForEach">
        <dsp:param name="array" param="outerelem"/>
        <dsp:oparam name="output">
	  <dsp:getvalueof id="optval" idtype="String" param="element">
          <dsp:option value="<%=optval%>"/><dsp:valueof param="element">UNDEFINED</dsp:valueof>
	  </dsp:getvalueof>
        </dsp:oparam>
      </dsp:droplet>
      </dsp:select><br>
    </dsp:oparam>
    <dsp:oparam name="eventName">
      Event Name
      <!-- property to store the customer's selection is propertyValues -->
      <dsp:input bean="GiftlistSearch.propertyValues.eventName" size="30" type="text" value=""/> <br> 
    </dsp:oparam>
    <dsp:oparam name="state">
      State
      <!-- property to store the customer's selection is propertyValues -->
      <dsp:input bean="GiftlistSearch.propertyValues.state" size="30" type="text" value=""/> <br> 
    </dsp:oparam>
  </dsp:droplet>
  </dsp:oparam>
</dsp:droplet>

<p>
<input type="hidden" name="searching" value="true">
<dsp:input bean="GiftlistSearch.search" type="hidden" value="Perform Search"/>
<dsp:input bean="GiftlistSearch.search" type="submit" value="Perform Search"/>

</dsp:form>



</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/giftlist_search_form.jsp#2 $$Change: 635969 $--%>
