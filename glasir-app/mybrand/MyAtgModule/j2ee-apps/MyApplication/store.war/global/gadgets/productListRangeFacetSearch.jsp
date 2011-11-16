<dsp:page>

  <%-- This page renders the product range for specified category, sub category by atg search.
     
    Parameters - 
     - q_pageNum - Current page number.
     - facetSearchResponse - atg search facetSearchResponse object.
     - selectedHowMany - Display product number.
  --%>
  <dsp:importbean bean="/atg/dynamo/droplet/Range" />
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale" var="requestLocale"/>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>


  <dsp:getvalueof var="viewAll" param="viewAll" />
  <dsp:getvalueof var="prodDivName" param="productDivName" />

  <dsp:getvalueof id="originatingRequestURL" bean="/OriginatingRequest.requestURI" />

  <%--Set the sort properties and max value defaults--%>

  <dsp:getvalueof var="pageSize" vartype="java.lang.Object" bean="/atg/multisite/SiteContext.site.defaultPageSize"/>

  <dsp:getvalueof id="selectedHowMany" param="selectedHowMany" />
  <dsp:getvalueof id="howMany" value="${selectedHowMany}" />
  <c:if test="${empty howMany}">
    <c:set var="howMany" value="${pageSize}" />
  </c:if>

  <%--Set display product columnCount--%>
  <c:set var="columnCount" value="4"/>
  <%--
    <c:if test="${columnCount>pageSize}">
      <c:set var="columnCount" value="${pageSize}"/>
    </c:if>
  --%>
  <dsp:getvalueof id="q_pageNum" param="q_pageNum" />

  <c:if test="${empty q_pageNum}">
    <c:set var="q_pageNum" value="1" />
  </c:if>

  <%--setting the sort properties and max value defaults--%>
  <dsp:getvalueof var="name" value="name" />

  

  <dsp:param name="selectedHowMany" value="${howMany}" />

  <dsp:param name="mode" value="${mode}" />

  <%--End setting the sort properties and max value defaults--%>

  <c:if test="${not empty productListHeading}">
    <h2>
      <dsp:valueof param="productListHeading" />
    </h2>
  </c:if>

  <dsp:param name="name" value="name" />         

  <dsp:getvalueof var="searchResults" param="searchResults" />
  <c:choose>
    <c:when test="${not empty searchResults}">
                   
      <dsp:droplet name="Range">
        <dsp:param name="array" param="searchResults"/>
        <dsp:setvalue param="currentResponse" paramvalue="element"/>
        <c:if test="${viewAll == true}">
          <dsp:param name="howMany" value="5000" />
        </c:if>
        <c:if test="${viewAll != true}">
          <dsp:param name="howMany" value="${howMany}" />
        </c:if>
        <dsp:oparam name="empty">
          <crs:messageContainer optionalClass="atg_store_noMatchingItem" titleKey="facet_facetSearchResults.noMatchingItem"/>
        </dsp:oparam>
        <dsp:oparam name="outputStart">
          <div id="ajaxContainer">
            <div divId="ajaxRefreshableContent">
              <%--start Pagination Top--%>
              <dsp:include page="/global/gadgets/productListRangePagination.jsp">
                <dsp:param name="size" param="numResults" />
                <dsp:param name="top" value="true" />
                <dsp:param name="q_pageNum" value="${q_pageNum}" />
                <dsp:param name="arraySplitSize" value="${pageSize}" />
                <dsp:param name="isATGFacetSearch" value="${true}" />
              </dsp:include>
              <dsp:include page="sortDisplay.jsp">
                <dsp:param name="arraySplitSize" value="${pageSize}" />
                <dsp:param name="isATGFacetSearch" value="${true}" />
              </dsp:include>
              <div id="atg_store_prodList">
                <ul class="atg_store_product">
        </dsp:oparam>
        <dsp:oparam name="output">
          <dsp:droplet name="/atg/search/droplet/GetClickThroughId">
            <dsp:param name="result" param="element"/>
            <dsp:oparam name="output">
 
              <dsp:droplet name="ProductLookup">
                <dsp:param bean="/OriginatingRequest.requestLocale.locale" name="repositoryKey"/>
                <dsp:param name="id" param="currentResponse.document.properties.$repositoryId"/>
                <dsp:param name="categoryId" param="categoryId"/>
                <%-- search results already filtered out by input constraints --%>
                <dsp:param name="filterBySite" value="false"/>
                <dsp:param name="filterByCatalog" value="false"/>
                <dsp:oparam name="output">
                  <dsp:setvalue param="product" paramvalue="element"/>
                  <dsp:getvalueof var="index" param="index"/>
                  <dsp:getvalueof var="count" param="count"/>
                  <dsp:getvalueof var="size"  param="size"/>           
                  <dsp:getvalueof var="additionalClasses" vartype="java.lang.String" 
                                 value="${(count % columnCount) == 1 ? 'prodListBegin' : ((count % columnCount) == 0 ? 'prodListEnd':'')}"/>
           
                  <li class="<crs:listClass count="${count}" size="${size}" selected="false"/>${empty additionalClasses ? '' : ' '}${additionalClasses}">
                    <%-- 
                      Category id is empty if we are using search.
                      Use parent category's id in this case.
                    --%>  
                    <dsp:getvalueof var="catId" param="categoryId"/>
                    <c:if test="${empty catId}">
                      <dsp:getvalueof var="catId" param="product.parentCategory.id"/>
                    </c:if>
                    
                    <fmt:message var="siteIndicatorPrefix" key="common.from"/>
                    <dsp:include page="/global/gadgets/productListRangeRow.jsp">
                      <dsp:param name="categoryId" value="${catId}" />                      
                      <dsp:param name="product" param="product" />
                      <dsp:param name="categoryNav" value="false" />
                      <dsp:param name="searchClickId" param="searchClickId" />
                      <dsp:param name="displaySiteIndicator" value="true"/>
                      <dsp:param name="displayCurrentSite" value="false"/>
                      <dsp:param name="mode" value="name"/>
                      <dsp:param name="noSiteIcon" value="false"/>
                      <dsp:param name="sitePrefix" value="${siteIndicatorPrefix}"/>
                    </dsp:include>
                         
                  </li>
                </dsp:oparam>
              </dsp:droplet>
            </dsp:oparam>
          </dsp:droplet>
        </dsp:oparam>

        <dsp:oparam name="outputEnd">
                </ul>
              </div>
              <%--start Pagination Top--%>
              <dsp:include page="/global/gadgets/productListRangePagination.jsp">
                <dsp:param name="size" param="numResults" />
                <dsp:param name="top" value="true" />
                <dsp:param name="q_pageNum" value="${q_pageNum}" />
                <dsp:param name="arraySplitSize" value="${pageSize}" />
                <dsp:param name="isATGFacetSearch" value="${true}" />  
              </dsp:include>
            </div>
            <div name="transparentLayer" id="transparentLayer"></div>
            <div name="ajaxSpinner" id="ajaxSpinner"></div>
          </div>
        </dsp:oparam>
      </dsp:droplet>
    </c:when>
    <c:otherwise>
      <dsp:droplet name="Range">
        <dsp:param name="array" param="facetSearchResponse.matchingItems"/>
        <dsp:setvalue param="currentResponse" paramvalue="element"/>
        <dsp:param name="howMany" value="${howMany}" />
        <dsp:oparam name="empty">
          <crs:messageContainer 
            optionalClass="atg_store_noMatchingItem" 
            messageKey="facet_facetSearchResults.noMatchingItem"/>
        </dsp:oparam>
        <dsp:oparam name="outputStart">

          <%--start Pagination Top--%>
          <dsp:include page="/global/gadgets/productListRangePagination.jsp">
            <dsp:param name="itemList" param="facetSearchResponse.matchingItems" />
            <dsp:param name="size" param="size" />
            <dsp:param name="top" value="true" />
            <dsp:param name="q_pageNum" value="${q_pageNum}" />
            <dsp:param name="arraySplitSize" value="${pageSize}" />
            <dsp:param name="isATGFacetSearch" value="${true}" />  
          </dsp:include>
          <dsp:include page="sortDisplay.jsp">
            <dsp:param name="arraySplitSize" value="${pageSize}" />
            <dsp:param name="isATGFacetSearch" value="${true}" />
          </dsp:include>
          <div id="atg_store_prodList">
            <ul class="atg_store_product">
        </dsp:oparam>
        <dsp:oparam name="output">
          <dsp:droplet name="ProductLookup">
            <dsp:param bean="/OriginatingRequest.requestLocale.locale" name="repositoryKey"/>
            <dsp:param name="id" param="currentResponse.properties.$repositoryId"/>
            <dsp:param name="categoryId" param="categoryId"/>
            <%-- search results already filtered out by input constraints --%>
            <dsp:param name="filterBySite" value="false"/>
            <dsp:param name="filterByCatalog" value="false"/>
            <dsp:oparam name="output">
              <dsp:setvalue param="product" paramvalue="element"/>
              <dsp:getvalueof var="index" param="index"/>
              <dsp:getvalueof var="count" param="count"/>
              <dsp:getvalueof var="size"  param="size"/>           
              <dsp:getvalueof var="additionalClasses" vartype="java.lang.String" 
                             value="${(count % columnCount) == 1 ? 'prodListBegin' : ((count % columnCount) == 0 ? 'prodListEnd':'')}"/>
       
              <li class="<crs:listClass count="${count}" size="${size}" selected="false"/>${empty additionalClasses ? '' : ' '}${additionalClasses}">
              
                <dsp:include page="/global/gadgets/productListRangeRow.jsp">
                  <dsp:param name="categoryId" param="categoryId" />                      
                  <dsp:param name="product" param="product" />
                  <dsp:param name="categoryNav" value="false" />
                </dsp:include>
                     
              </li>
            </dsp:oparam>
          </dsp:droplet>
               
        </dsp:oparam>

        <dsp:oparam name="outputEnd">
              </ul>
            </div>
            <%--start Pagination Top--%>
            <dsp:include page="/global/gadgets/productListRangePagination.jsp">
              <dsp:param name="itemList" param="facetSearchResponse.matchingItems" />
              <dsp:param name="size" param="size" />
              <dsp:param name="top" value="true" />
              <dsp:param name="q_pageNum" value="${q_pageNum}" />
              <dsp:param name="arraySplitSize" value="${pageSize}" />
            <dsp:param name="isATGFacetSearch" value="${true}" />
          </dsp:include>
        </dsp:oparam>
      </dsp:droplet>
    </c:otherwise>
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/productListRangeFacetSearch.jsp#2 $$Change: 633752 $--%>