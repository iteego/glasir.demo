 <dsp:page>
  <%-- This page renders sort contents
        Parameters:
     - sortClassName - sort element css class name.
  --%>
  <dsp:getvalueof var="isATGFacetSearch" param="isATGFacetSearch"/>
  <dsp:getvalueof var="sortClassName" param="sortClassName"/>
  <div class="${sortClassName}">
    <h3>
      <fmt:message key="common.sortBy" />:
    </h3>
    <ul>
      <dsp:getvalueof var="q_docSort" param="q_docSort"/>
      <dsp:include page="sortGadget.jsp">
        <dsp:param name="isATGFacetSearch" param="isATGFacetSearch" />

        <c:choose>
          <c:when test="${isATGFacetSearch}">
            <dsp:param name="sortParam" value="relevance" /><%-- in other cases products will be shown in the oreder they were added to the category --%>
          </c:when>
          <c:otherwise>
            <dsp:param name="sortParam" value="" />
          </c:otherwise>
        </c:choose>


        <dsp:param name="sortTitle" value="common.topPicks"/>
        <dsp:param name="sortOrder" value="descending" />
        <c:choose>
          <c:when test="${(q_docSort=='relevance') ||(empty q_docSort)}">
            <dsp:param name="liCss" value="odd first active"/>
          </c:when>
          <c:otherwise>
            <dsp:param name="liCss" value="odd first"/>
          </c:otherwise>
        </c:choose>
      </dsp:include>

      <dsp:include page="sortGadget.jsp">
        <dsp:param name="isATGFacetSearch" param="isATGFacetSearch" />

        <c:choose>
          <c:when test="${isATGFacetSearch}">
            <dsp:param name="sortParam" value="title" />
          </c:when>
          <c:otherwise>
            <dsp:param name="sortParam" value="displayName" />
          </c:otherwise>
        </c:choose>


        <dsp:param name="sortTitle" value="common.name"/>
        <dsp:param name="sortOrder" value="ascending" />
        <c:choose>
          <c:when test="${q_docSort=='title' || q_docSort=='displayName'}">
          <dsp:param name="liCss" value="even last active"/>
          </c:when>
          <c:otherwise>
            <dsp:param name="liCss" value="even last"/>
          </c:otherwise>
        </c:choose>
      </dsp:include>

    </ul>
  </div>
 </dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/sortDisplay.jsp#2 $$Change: 635969 $--%>
