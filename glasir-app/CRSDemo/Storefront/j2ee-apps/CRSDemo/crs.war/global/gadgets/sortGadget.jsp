<dsp:page>
  <%-- This page is a gadget to render display of sort element.
     Parameters:
     - sortTitle - Sort element title.
     - liCss - li tag style.
     - addFacet - Add facet element
     - categoryId - Category id
     - start - Product start index 
     - q_pageNum - Current page number
   --%>
  <%-- Set sort by --%>
  <dsp:getvalueof var="sortTitle" param="sortTitle"/>
  <dsp:getvalueof id="originatingRequestURL" bean="/OriginatingRequest.requestURI"/>
  <dsp:getvalueof var="liCss" param="liCss"/>
  <dsp:getvalueof id="isATGFacetSearch" param="isATGFacetSearch"/>
  <dsp:getvalueof var="question" param="question"/>

  <%--
    Escape XML specific characters in all parameters that will be passed to JavaScript functions to
    prevent using them in XSS attacks. Performing escaping operation separately so that not mix JavaScript
    and JSTL EL functions like fn:escapeXml as this can cause issues on WebSphere.
  --%>
  
  <dsp:getvalueof id="q_docSort" param="sortParam"/>
  <c:set var="q_docSort" value="${fn:escapeXml(q_docSort)}"/>
  <dsp:getvalueof id="addFacet" param="addFacet"/>
  <c:set var="addFacet" value="${fn:escapeXml(addFacet)}"/>
  <dsp:getvalueof id="removeFacet" param="removeFacet"/>
  <c:set var="removeFacet" value="${fn:escapeXml(removeFacet)}"/>
  <dsp:getvalueof id="trail" param="trail"/>
  <c:set var="trail" value="${fn:escapeXml(trail)}"/>
  <dsp:getvalueof id="mode" param="mode"/>
  <c:set var="mode" value="${fn:escapeXml(mode)}"/>
  <dsp:getvalueof id="trailSize" param="trailSize"/>
  <c:set var="trailSize" value="${fn:escapeXml(trailSize)}"/>
  <dsp:getvalueof id="categoryId" param="categoryId"/>
  <c:set var="categoryId" value="${fn:escapeXml(categoryId)}"/>  
    
  <dsp:getvalueof id="selectedHowMany" param="size"/>
  <c:set var="selectedHowMany" value="${fn:escapeXml(selectedHowMany)}"/>
  <dsp:getvalueof id="start" param="start"/>
  <c:set var="start" value="${fn:escapeXml(start)}"/>
  <dsp:getvalueof id="q_pageNum" param="q_pageNum"/>
  <c:set var="q_pageNum" value="${fn:escapeXml(q_pageNum)}"/>
  <dsp:getvalueof id="order" param="sortOrder"/>
  <c:set var="order" value="${fn:escapeXml(order)}"/>
  <dsp:getvalueof id="viewAll" param="viewAll"/>
  <c:set var="viewAll" value="${fn:escapeXml(viewAll)}"/>
  <dsp:getvalueof id="arraySplitSize" param="arraySplitSize"/>
  <c:set var="arraySplitSize" value="${fn:escapeXml(arraySplitSize)}"/>
  
  <dsp:getvalueof id="q_facetTrail" param="q_facetTrail"/>
  <c:set var="q_facetTrail" value="${fn:escapeXml(q_facetTrail)}"/>
  <dsp:getvalueof id="facetOrder" param="facetOrder"/>
  <c:set var="facetOrder" value="${fn:escapeXml(facetOrder)}"/>
  <dsp:getvalueof var="q_docSortOrder" param="q_docSortOrder"/>
  <c:set var="q_docSortOrder" value="${fn:escapeXml(q_docSortOrder)}"/>

  <li class="${liCss}">

    <c:set var="url" value="${pageContext.request.requestURL}"/>
    <c:set var="facetTrailVar" value="${q_facetTrail}"/>
    <c:set var="pageNum" value="${param.q_pageNum}"/>
    <c:if test="${viewAll eq true}">
      <c:set var="viewAllLink" value="true"/>
    </c:if>
    <%@include file="/facet/gadgets/navLinkHelper.jspf" %>

    <c:choose>

      <c:when test="${isATGFacetSearch}">
        
        <dsp:a href="${url}"
               onclick="javascript:atg.store.facet.loadDataPagination('${start}','${addFacet}','${q_pageNum}','${trail}','${trailSize}','${categoryId}','${q_docSort}','','${viewAll}','${order}', '${arraySplitSize}',
               generateNavigationFragmentIdentifier('${q_docSort}', '${q_pageNum}', '${viewAll}','${q_facetTrail}', '${categoryId}', 'handleProductsLoad', true));return false;">
          <fmt:message key="${sortTitle}"/>
        </dsp:a>

      </c:when>

      <c:otherwise>

        <%-- category browsing --%>
        <dsp:a href="${url}"
               onclick="ajaxNavigation('${categoryId}', '${q_pageNum}', '${not empty viewAll}', '${q_docSort}',
               generateNavigationFragmentIdentifier('${q_docSort}', '${q_pageNum}', '${not empty viewAll}','${q_facetTrail}', '${categoryId}', 'categoryProducts', false));return false;">
          <fmt:message key="${sortTitle}"/>
        </dsp:a>

      </c:otherwise>
    </c:choose>

  </li>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/sortGadget.jsp#2 $$Change: 635969 $--%>
