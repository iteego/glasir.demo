<dsp:page>

  <%-- This page fragment is intended to be embedded on any page that requires a search capability. --%>
  <dsp:importbean bean="/atg/commerce/catalog/ProductSearch"/>
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale" var="requestLocale"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
  <dsp:importbean bean="/atg/multisite/Site"/>

  <dsp:getvalueof id="contextroot" idtype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
  <fmt:message var="searchInput" key="common.search.input"/>

  <dsp:form action="${contextroot}/search/searchResults.jsp" method="post" id="simpleSearch" formid="simplesearchform">
    <dsp:input bean="ProductSearch.successURL" type="hidden" value=""/>
    <dsp:input bean="ProductSearch.errorURL" type="hidden" value=""/>

    <dsp:getvalueof var="pageSize" vartype="java.lang.Object" bean="Site.defaultPageSize"/>
    <dsp:input bean="ProductSearch.currentPage" type="hidden" value="1"/>
    <dsp:input bean="ProductSearch.resultsPerPage" type="hidden" value="${pageSize}"/>
    <input type="hidden" name="searchExecByFormSubmit" value="true">

    <dsp:input type="hidden" bean="ProductSearch.dummySearchText" value="${searchInput}"/>
    
     <dsp:input iclass="atg_store_searchInput enterSubmit" bean="ProductSearch.searchInput" type="text" name="atg_store_searchInput"
        value="${searchInput}" id="atg_store_searchInput" autocomplete="off"/>
    
    <%-- 
      Check if the current site has a shareable. If yes, then this site
      is going to be the first checked checkbox.
      
      If site hasn't have a shareable then do not display checkbox, just hidden field.
    --%>
    <div id="atg_store_searchStoreSelect">
      <dsp:droplet name="SharingSitesDroplet">
        <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
        <dsp:param name="excludeInputSite" value="true"/>
        
        <dsp:oparam name="output">
          <dsp:getvalueof var="sites" param="sites"/>
          
          <dsp:droplet name="ForEach">
          <dsp:param name="array" param="sites"/>
          <dsp:setvalue param="site" paramvalue="element"/>
          
            <%-- current site, selected and disabled --%>      
            <dsp:oparam name="outputStart">
    
              <dsp:input bean="ProductSearch.siteIds" type="hidden" beanvalue="Site.id"/>
            </dsp:oparam>

            <%-- other sites --%>
            <dsp:oparam name="output">
              <div>
                <dsp:input bean="ProductSearch.siteIds" type="checkbox" paramvalue="site.id" id="otherStore" checked="false"/>
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
          <dsp:input bean="ProductSearch.siteIds" type="hidden" beanvalue="Site.id"/>
        </dsp:oparam>
        
      </dsp:droplet>
    </div>
    
    <fmt:message var="submitText" key="search_simpleSearch.submit"/>
      <span class="atg_store_smallButton">
        <dsp:input bean="ProductSearch.search" type="submit" id="atg_b2cstore_search" value="${submitText}"/>
      </span>
    <dsp:input bean="ProductSearch.search" type="hidden" value="search"/>
    
  </dsp:form>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/search/gadgets/simpleSearch.jsp#3 $$Change: 635969 $ --%>
