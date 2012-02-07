<%-- Tag that will invoke a browse query to generate the facets for a category or subcategory page

     -  categoryId - The ID of the category
  --%>

<%@include file="/includes/taglibs.jspf"%>
<%@include file="/includes/context.jspf"%>

<%@ tag body-content="empty" %>

<%@ attribute name="categoryId" required="true" type="java.lang.String" %>

<dsp:page>

  <dsp:importbean bean="/atg/commerce/search/StoreBrowseConstraints"/>
  <dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
  <dsp:importbean bean="/atg/registry/RepositoryTargeters/RefinementRepository/GlobalCategoryFacet"/>
  <dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
  <dsp:importbean bean="/atg/targeting/TargetingFirst"/>

  <%-- Only submit new request if there is no current response --%>
  <dsp:droplet name="IsEmpty">
    <dsp:param name="value" bean="QueryFormHandler.searchResponse"/>
    <dsp:oparam name="true">

      <dsp:droplet name="TargetingFirst">
        <dsp:param name="howMany" value="1"/>
        <dsp:param name="targeter" bean="GlobalCategoryFacet"/>

        <dsp:oparam name="output">
           <dsp:getvalueof id="refElemRepId" idtype="String" param="element.repositoryId"/>

           <dsp:setvalue param="addFacet" value="${refElemRepId}:${categoryId}"/>
           <dsp:setvalue bean="FacetSearchTools.facetTrail" value="${refElemRepId}:${categoryId}"/>
           <dsp:setvalue bean="QueryFormHandler.searchRequest.documentSetConstraints"
                         beanvalue="StoreBrowseConstraints" valueishtml="true"/>
           <dsp:setvalue bean="QueryFormHandler.searchRequest.startCategory" value="${categoryId}"/>
           <dsp:setvalue bean="QueryFormHandler.searchRequest.saveRequest" value="true"/>
           <dsp:setvalue bean="QueryFormHandler.search" value="submit"/>
           
        </dsp:oparam>
      </dsp:droplet><%-- TargetingFirst --%>

    </dsp:oparam>
  </dsp:droplet> <%-- IsEmpty --%>

</dsp:page>
<%-- @version $Id$$Change$--%>
