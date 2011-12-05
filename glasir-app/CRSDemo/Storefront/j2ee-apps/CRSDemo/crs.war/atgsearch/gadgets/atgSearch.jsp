<dsp:page>

  <dsp:importbean bean="/atg/commerce/search/catalog/QueryFormHandler"/>
  <dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/store/profile/SessionBean" />
  <dsp:importbean bean="/atg/search/routing/command/search/DynamicTargetSpecifier"/>

  <dsp:getvalueof var="contextroot" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
  <%-- this is the form that shows --%>
  <dsp:form method="post" formid="searchform" id="searchForm" action="${contextroot}/atgsearch/gadgets/atgSearch.jsp">
    <fmt:message var="hintText" key="common.search.input"/>

    <dsp:input iclass="text atg_store_searchInput" value="${hintText}" bean="QueryFormHandler.searchRequest.question" type="text" id="atg_store_searchInput" autocomplete="off"/>
    <dsp:getvalueof bean="QueryFormHandler.searchResponse.question" var="question"/>
    
    <%-- Escape XML in the question to prevent XSS attacks --%>
    <input type="hidden" id="questionSaved" name="questionSaved" value="${fn:escapeXml(question)}"/>

    <%-- Escape XML in categoryId parameter to prevent using it in XSS attacks --%>
    <input type="hidden" id="catIdSaved" name="catIdSaved" value="${fn:escapeXml(param.categoryId)}"/>

    <fmt:message var="submitText" key="search_simpleSearch.submit"/>
    
    <dsp:getvalueof var="pageSize" vartype="java.lang.Object" bean="Site.defaultPageSize"/>

    <%-- for sorting --%>
    <dsp:input id="qfh_docSort" bean="QueryFormHandler.searchRequest.docSort" type="hidden" value="relevance"/>
    <dsp:input id="qfh_docSortOrder" bean="QueryFormHandler.searchRequest.docSortOrder" type="hidden" value="descending"/>
    <dsp:input id="qfh_multiSearchSession" bean="QueryFormHandler.searchRequest.multiSearchSession" type="hidden" value="true"/>
    <dsp:input id="qfh_saveRequest" bean="QueryFormHandler.searchRequest.saveRequest" type="hidden" value="true"/>
    <dsp:input id="qfh_pageSize" bean="QueryFormHandler.searchRequest.pageSize" type="hidden" value="${pageSize}"/>

    <%-- 
      Check if the current site has a shareable. If yes, then this site
      is going to be the first checked read-only checkbox and other sites
      will be editable check boxes.
      
      If site hasn't have a shareable then search within current site context.
    --%>
    
    <dsp:getvalueof var="currentSiteId" bean="Site.id"/>
    <div id="atg_store_searchStoreSelect">
    <dsp:droplet name="SharingSitesDroplet">
      <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
      <dsp:param name="excludeInputSite" value="true"/>

      <dsp:oparam name="output">
        <%-- Sort sites --%>
        <dsp:getvalueof var="sites" param="sites"/>
        <dsp:getvalueof var="size" value="${fn:length(sites)}" />
        
        <dsp:droplet name="ForEach">
          <dsp:param name="array" param="sites"/>
          <dsp:setvalue param="site" paramvalue="element"/>
          
          <%-- current site, selected and disabled --%>      
          <dsp:oparam name="outputStart">
         
            <dsp:input bean="SessionBean.searchSiteIds" type="hidden" value="${currentSiteId}" priority="10" />
          </dsp:oparam>
          
          <%-- other sites --%>
          <dsp:oparam name="output">
            <dsp:getvalueof var="siteId" param="site.id"/>
            <div>
              <dsp:input bean="SessionBean.searchSiteIds" type="checkbox" value="${siteId}" priority="10" id="otherStore" checked="false"/>
              <label for="otherStore">
                <fmt:message key="search.otherStoresLabel">
                  <fmt:param>
                    <dsp:valueof param="site.name"/>
                  </fmt:param>
                </fmt:message>           
              </label>
            </div>    
          </dsp:oparam>
        </dsp:droplet>
      </dsp:oparam>
      
      <dsp:oparam name="empty">
        <dsp:input bean="SessionBean.searchSiteIds" type="hidden" value="${currentSiteId}" priority="10" />
      </dsp:oparam>
    </dsp:droplet>
  </div>
    <input type="hidden" name="searchExecByFormSubmit" value="true">

    <dsp:input type="hidden" bean="QueryFormHandler.successURL" value="${pageContext.request.contextPath}/atgsearch/atgSearchResults.jsp"/>
    <dsp:input type="hidden" bean="QueryFormHandler.search" value=""/>
    <span class="atg_store_smallButton">
      <input type="submit" value="${submitText}" id="atg_b2cstore_search"/>
    </span>

  </dsp:form>
  <div id="facetTrailSaved"></div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/atgsearch/gadgets/atgSearch.jsp#4 $$Change: 638941 $ --%>

