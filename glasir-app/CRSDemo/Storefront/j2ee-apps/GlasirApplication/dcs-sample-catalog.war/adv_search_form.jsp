<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<!--
*
* This jhtml code demonstrates how to perform an advanced search on the
* product catalog repository.  The AdvProductSearch form handler is used to 
* take customer input and perform the search.  The formhandler is configured 
* following properties which define the search:
* 
* doKeywordSearch(true) - search for input in keyword properties
* keywordPropertyNames(keywords) - which properties to search
* doAdvancedSearch(true) - search using advanced searching criteria
* advancedSearchPropertyNames(weightRange) - advanced properties to search
* itemTypes(product) - which item types to search in.
* scope(session) - information used across multiple pages.
*
* The call to handleSearch will take the input and formhandler configuration
* and generate the query to perform on the repository.  The resultset
* will be stored in a property and displayed on the results page.
*
* The first ForEach droplet is called to iterate over each advanced search
* property name.  For each property that has specific choices as options, 
* the handler returns all possible property values from the repository.  
* This information to create a dropdown list for the customer to choose 
* from for advanced searching.  'ANY' is selected by default.  For properties
* that allow a string search like part number, this form provides an input
* box for the customer to enter a string.
*
-->

<dsp:importbean bean="/atg/commerce/catalog/AdvProductSearch"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<dsp:form action="adv_search_results.jsp" method="post">
<strong>Advanced</strong><BR>

Text search for <dsp:input bean="AdvProductSearch.searchInput" size="38" type="text"/>
<!-- use this hidden form tag to make sure the search handler is invoked if
     someone does not hit the submit button -->

<P>
and match these attributes:
<blockquote>
<dsp:droplet name="ForEach">
  <!-- For each property specified in 
   AdvProductSearch.advancedSearchPropertyNames, retrieve all possible 
   property values.  This allows the customer
   to pick one to search on for advanced searching. -->
  <dsp:param bean="AdvProductSearch.propertyValuesByType" name="array"/>
  <dsp:oparam name="output">
  <dsp:droplet name="Switch">
    <dsp:param name="value" param="key"/>
    <!-- One property that a product in the store can have is weight range.
     In this case, if the property is weight range, we want to put all
     possible choices in a pulldown menu. -->
    <dsp:oparam name="weightRange">Weight
      <!-- property to store the customer's selection is propertyValues -->
      <dsp:select bean="AdvProductSearch.propertyValues.weightRange">
	    <dsp:option value=""/>ANY
      <dsp:setvalue paramvalue="element" param="outerelem"/>
      <dsp:droplet name="ForEach">
        <dsp:param name="array" param="outerelem"/>
        <dsp:oparam name="output">
	  <dsp:getvalueof id="optval" idtype="String" param="element">
	  <dsp:option value="<%=optval%>"/><dsp:valueof param="element">UNDEFINED</dsp:valueof>
	  </dsp:getvalueof>
        </dsp:oparam>
      </dsp:droplet>
      </dsp:select><BR>
    </dsp:oparam>
    <dsp:oparam name="manufacturer">
      Manufacturer 
      <!-- property to store the customer's selection is propertyValues -->
      <dsp:select bean="AdvProductSearch.propertyValues.manufacturer">
	<dsp:option value=""/>ANY
      <dsp:setvalue paramvalue="element" param="outerelem"/>
      <dsp:droplet name="ForEach">
        <dsp:param name="array" param="outerelem"/>
        <dsp:oparam name="output">
	  <dsp:getvalueof id="optval2" idtype="String" param="element">
	  <dsp:option value="<%=optval2%>"/><dsp:valueof param="element">UNDEFINED</dsp:valueof>
          </dsp:getvalueof>
        </dsp:oparam>
      </dsp:droplet>
      </dsp:select><br>
    </dsp:oparam>
    <dsp:oparam name="childSKUs">
      Part Number
      <!-- property to store the customer's selection is propertyValues -->
      <dsp:input bean="AdvProductSearch.propertyValues.childSKUs" size="10" type="text" value=""/><br> 
    </dsp:oparam>
  </dsp:droplet>
  </dsp:oparam>
</dsp:droplet>

</blockquote>

<input name="repositoryKey" type="hidden" value='<dsp:valueof bean="Profile.locale"/>'>
<dsp:input bean="AdvProductSearch.search" type="hidden" value="Search"/>
<dsp:input bean="AdvProductSearch.search" type="submit" value="Search"/>


</dsp:form>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/adv_search_form.jsp#2 $$Change: 635969 $--%>
