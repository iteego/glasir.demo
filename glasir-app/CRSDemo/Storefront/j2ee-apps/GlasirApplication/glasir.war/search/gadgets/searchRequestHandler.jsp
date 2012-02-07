<dsp:page>
  <dsp:importbean bean="/atg/commerce/catalog/ProductSearch"/>
  <c:set var="cp" value="${pageContext.request.contextPath}"/>





  <c:if test="${not empty param.searchInput}">
    <dsp:setvalue bean="ProductSearch.searchInput" value="${param.searchInput}" />
  </c:if>



  <c:choose>
    <c:when test="${param.viewAll eq 'true'}">
      <dsp:setvalue bean="ProductSearch.resultsPerPage" value="-1"/>
      <dsp:setvalue bean="ProductSearch.currentPage" value="-1"/>
    </c:when>
    <c:otherwise>
      <dsp:setvalue bean="ProductSearch.resultsPerPage" value="${param.q_pageSize}"/>
      <dsp:setvalue bean="ProductSearch.currentPage" value="${param.q_pageNum}"/>
    </c:otherwise>
  </c:choose>


  <dsp:setvalue bean="ProductSearch.enableCountQuery" value="true"/>


  <dsp:getvalueof var="preventFormHandlerRedirect" vartype="java.lang.Boolean" param="preventFormHandlerRedirect"/>
  <c:choose>
    <c:when test="${preventFormHandlerRedirect}">
      <dsp:setvalue bean="ProductSearch.successURL" value=""/>
      <dsp:setvalue bean="ProductSearch.errorURL" value=""/>
    </c:when>
    <c:otherwise>
      <dsp:setvalue bean="ProductSearch.successURL" value="${cp}/search/gadgets/searchResults.jsp?mode=${param.mode}&q_pageNum=${param.q_pageNum}&viewAll=${param.viewAll}"/>
      <dsp:setvalue bean="ProductSearch.errorURL" value="${cp}/search/gadgets/searchResults.jsp?mode=${param.mode}"/>
    </c:otherwise>
  </c:choose>

  <dsp:setvalue bean="ProductSearch.search" value="Search"/>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/search/gadgets/searchRequestHandler.jsp#1 $$Change: 633540 $--%>







