<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<!--
*
* This jhtml code demonstrates how to perform a simple search on the
* product catalog repository.  The CatalogSearch form handler is used to 
* take customer input and perform the search.  The formhandler is configured 
* following properties which define the search:
* 
* doKeywordSearch(true) - search for input in keyword properties
* keywordPropertyNames(keywords) - which properties to search
* itemTypes(category,product) - which item types to search in.
* scope(session) - information used across multiple pages.
*
* The call to handleSearch will take the input and formhandler configuration
* and generate the query to perform on the repository.  The result set(s)
* by itemtype will be stored in a property and displayed in results page.
*
-->

<dsp:importbean bean="/atg/commerce/catalog/CatalogSearch"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<h3>Product Search</h3>

<dsp:form action="catalog_search_results.jsp" method="post">
<dsp:input bean="CatalogSearch.searchInput" size="50" type="text"/><BR>
<!-- use this hidden form tag to make sure the search handler is invoked if
     someone does not hit the submit button -->

<input name="repositoryKey" type="hidden" value='<dsp:valueof bean="Profile.locale"/>'>
<dsp:input bean="CatalogSearch.search" type="hidden" value="Perform Search"/>
<dsp:input bean="CatalogSearch.search" type="submit" value="Perform Search"/>
</dsp:form>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/catalog_search_form.jsp#2 $$Change: 635969 $--%>
