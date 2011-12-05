<dsp:page>

  <dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
  <dsp:getvalueof bean="QueryFormHandler.searchResponse" var="queryResponse" scope="request"/>

  <dsp:getvalueof var="url" param="url"/>
  <dsp:getvalueof var="title" param="title"/>

  <dsp:a href="${url}" title="${title}">
    <%-- Set sort by --%>
    <%-- Preserve other parameters --%>
    <dsp:param name="categoryId" param="categoryId"/>
    <dsp:param name="start" param="start"/>
    <dsp:param name="selectedHowMany" param="selectedHowMany"/>
    <dsp:param name="featureId" param="featureId"/>
    <dsp:param name="viewAll" param="viewAll"/>
    <dsp:param name="addFacet" param="addFacet"/>
    <dsp:param name="removeFacet" param="removeFacet"/>
    <dsp:param name="trail" param="trail"/>
    <dsp:param name="mode" param="mode"/>
    <dsp:property bean="QueryFormHandler.searchRequest.requestChainToken"
                  value="${queryResponse.requestChainToken}" name="qfh_rct" priority="30"/>
    <dsp:property bean="QueryFormHandler.searchRequest.multiSearchSession"
                  value="true" name="qfh_mss" priority="29"/>
    <dsp:property bean="QueryFormHandler.searchRequest.saveRequest"
                  value="true" name="qfh_sr" priority="28"/>
    <dsp:property bean="QueryFormHandler.searchRequest.facetSearchRequest"
                  value="true" name="qfh_fsr" priority="31"/>
    <dsp:property bean="QueryFormHandler.search" value="submit" name="qfh_s_s"/>
    <dsp:valueof param="linkText"/>
  </dsp:a>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/productSortLinkWithSearch.jsp#2 $$Change: 635969 $--%>
