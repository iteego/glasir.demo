<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/catalog/ProductTextSearch"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<dsp:form action="product_text_results.jsp" method="post">
<strong>Text</strong><BR>
<dsp:input bean="ProductTextSearch.searchInput" size="50" type="text"/>
<!-- use this hidden form tag to make sure the search handler is invoked if
     someone does not hit the submit button -->

<input name="repositoryKey" type="hidden" value='<dsp:valueof bean="Profile.locale"/>'>
<dsp:input bean="ProductTextSearch.search" type="hidden" value="Search"/>
<dsp:input bean="ProductTextSearch.search" type="submit" value="Search"/>
</dsp:form>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/product_text_search.jsp#2 $$Change: 635969 $--%>
