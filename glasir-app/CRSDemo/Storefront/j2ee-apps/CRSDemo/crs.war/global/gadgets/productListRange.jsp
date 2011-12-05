<dsp:page>

  <%--

  This page is used to display content that includes:
      - sort properties
      - pagination links (made by /global/gadgets/productListRangePagination.jsp)
      - products

              Parameters:

     - productArray (required) - List of the products that will be displayed.

     - viewAll (optional) - Set value to true, if 'view all' is requested.

     - q_pageNum (required) -  Current page number as required by pagination functionality.

  --%>

  <dsp:importbean bean="/atg/dynamo/droplet/Range" />

  <dsp:importbean var="config" bean="/atg/store/StoreConfiguration" />

  <dsp:getvalueof var="prodDivName" param="productDivName" />
  <dsp:getvalueof var="sort" param="sortClassName" />
  <dsp:getvalueof id="originatingRequestURL" bean="/OriginatingRequest.requestURI" />
  <dsp:getvalueof var="isSimpleSearchResults" param="isSimpleSearchResults"/>
  <dsp:getvalueof var="productArray" param="productArray"/>
  <dsp:getvalueof var="searchResultsSize" param="searchResultsSize"/>
  <dsp:getvalueof var="viewAll" param="viewAll"/>
  <dsp:getvalueof var="q_docSort" param="q_docSort"/>

  <dsp:getvalueof var="atgSearchInstalled" bean="StoreConfiguration.atgSearchInstalled" />
  <%--Set the sort properties and max value defaults--%>


  <%--current page - for pagination --%>
  <dsp:getvalueof id="q_pageNum" param="q_pageNum" />
  <c:if test="${empty q_pageNum}">
    <c:set var="q_pageNum" value="1" />
  </c:if>

  <%--page size (how many products per page)--%>
  <dsp:getvalueof var="pageSize" vartype="java.lang.Object" bean="/atg/multisite/SiteContext.site.defaultPageSize"/>
  <c:set var="rowSize"  value="4" />

  <c:choose>
    <c:when test="${viewAll eq 'true'}">
      <c:set var="howMany" value="5000" />
      <c:set var="start" value="1" />
    </c:when>
    <c:otherwise>
      <c:set var="howMany" value="${pageSize}" />
      <c:set var="start" value="${((q_pageNum - 1) * howMany) + 1}" />
    </c:otherwise>
  </c:choose>

  <%-- sort options --%>



  <dsp:getvalueof var="prodListHeading" param="productListHeading"/>
  <c:if test="${not empty productListHeading}">
    <h2><dsp:valueof param="productListHeading" /></h2>
  </c:if>


  <dsp:getvalueof var="name" value="name" />
  <dsp:param name="name" value="name" />


  <c:set var="productsCollection"/>
  <c:choose>
    <c:when test="${isSimpleSearchResults ne true}">
      <%@include file="/global/gadgets/productListWithFilter.jspf" %>
      <c:set var="productsCollection" value="${filteredCollection}"/>
      <dsp:getvalueof var="collectionSize" value="${fn:length(productsCollection)}" />
    </c:when>
    <c:otherwise>
      <c:set var="productsCollection" value="${productArray}"/>
      <dsp:getvalueof var="collectionSize" value="${searchResultsSize}" />
      <c:set var="start" value="1" />
    </c:otherwise>
  </c:choose>


  <dsp:droplet name="Range">
    <dsp:param name="array" value="${productsCollection}"/>
    <dsp:param name="sortProperties" param="q_docSort"/>
    <dsp:param name="howMany" value="${howMany}"/>
    <dsp:param name="start" value="${start}"/>


      <dsp:oparam name="outputStart">

        <%--start Pagination Top--%>
        <dsp:include  page="/global/gadgets/productListRangePagination.jsp">
          <dsp:param name="itemList" value="${productsCollection}" />
          <dsp:param name="q_docSort" param="q_docSort" />
          <dsp:param name="size" value="${collectionSize}" />
          <dsp:param name="top" value="true" />
          <dsp:param name="q_pageNum" value="${q_pageNum}" />
          <dsp:param name="arraySplitSize" value="${pageSize}" />
          <dsp:param name="q_docSort" value="${q_docSort}" />
          <dsp:param name="start" value="${((q_pageNum - 1) * howMany) + 1}"/>
        </dsp:include>
        <%--end Pagination Top--%>


          <c:if test="${isSimpleSearchResults ne true}">
            <dsp:include page="sortDisplay.jsp">
              <dsp:param name="arraySplitSize" value="${pageSize}" />
              <dsp:param name="q_pageNum" value="${q_pageNum}" />
              <dsp:param name="q_docSort" value="${q_docSort}" />
            </dsp:include>
          </c:if>

            
         <div id="<c:out value='${prodDivName}'/>">
           <ul class="atg_store_product">
        </dsp:oparam>



        <dsp:oparam name="output">
          <dsp:setvalue param="product" paramvalue="element"/>
          <dsp:getvalueof var="count" vartype="java.lang.String" param="count"/>
          <dsp:getvalueof var="size" vartype="java.lang.String" param="size"/>
          <dsp:getvalueof var="additionalClasses" vartype="java.lang.String"
                           value="${(count % rowSize) == 1 ? 'prodListBegin' : ((count % rowSize) == 0 ? 'prodListEnd':'')}"/>

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
              <dsp:param name="categoryId" value="${catId}"/>
              <dsp:param name="product" param="product" />
              <dsp:param name="displaySiteIndicator" value="true"/>
              <dsp:param name="displayCurrentSite" value="false"/>
              <dsp:param name="noSiteIcon" value="false"/>
              <dsp:param name="sitePrefix" value="${siteIndicatorPrefix}"/>
              <c:choose>
                <c:when test="isSimpleSearchResults">
                  <dsp:param name="categoryNav" value="true" />
                </c:when>
                <c:otherwise>
                  <dsp:param name="categoryNav" value="false" />
                </c:otherwise>
              </c:choose>
            </dsp:include>

          </li>

        </dsp:oparam>



        <dsp:oparam name="outputEnd">
          </ul>
        </div>

          <%-- Start Pagination Bottom --%>
          <dsp:include page="/global/gadgets/productListRangePagination.jsp">
            <dsp:param name="itemList" value="${productsCollection}" />
            <dsp:param name="q_pageNum" value="${q_pageNum}" />
            <dsp:param name="size" value="${collectionSize}" />
            <dsp:param name="top" value="true" />
            <dsp:param name="arraySplitSize" value="${pageSize}" />
            <dsp:param name="q_docSort" value="${q_docSort}" />
            <dsp:param name="start" value="${((q_pageNum - 1) * howMany) + 1}"/>
          </dsp:include>
          <%--end Pagination Bottom--%>
        </dsp:oparam>
      </dsp:droplet><%--End of Range droplet  --%>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/productListRange.jsp#2 $$Change: 633752 $--%>
