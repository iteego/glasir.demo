<%--
    High level jsp to render facet gadget when JS disabled.
--%>

<dsp:page>
  <dsp:importbean bean="/atg/search/repository/FacetSearchTools"/>
  <dsp:importbean bean="/atg/commerce/search/refinement/CommerceFacetTrailDroplet"/>


   <dsp:getvalueof var="question" param="question" />
   <dsp:getvalueof var="q_docSort" param="q_docSort" />
   <dsp:getvalueof var="q_docSortOrder" param="q_docSortOrder" />



  <dsp:getvalueof var="facetValueUrl" vartype="java.lang.String" bean="/OriginatingRequest.requestURI"/>


  <dsp:getvalueof var="facetHolders" bean="FacetSearchTools.facets"/>

  <dsp:getvalueof var="addFacet" param="addFacet"/>

  <dsp:getvalueof var="FSTfacetTrail" bean="FacetSearchTools.facetTrail"/>
  <c:if test="${empty FSTfacetTrail && not empty addFacet}">
    <dsp:setvalue bean="FacetSearchTools.facetTrail" value="${addFacet}"/>
  </c:if>

  <script type="text/javascript">
    //dojo.require("dijit.layout.ContentPane");
    var moreLable = "<fmt:message key='facet.panel.more'/>";
    var lessLable = "<fmt:message key='facet.panel.less'/>";
    var removeFacetLabel = "<fmt:message key='facet_facetTrailSimple.removeFacetTitle'/>";
    var filterByLabel = "<fmt:message key='facet_facetRenderer.title.filterBy'/>";
  </script>
  <div dojoType="dijit.layout.ContentPane" id="facetOptions" class="atg_store_facetsGroup_options">


    <%-- Convert the trail parameter to a bean --%>
    <dsp:droplet name="CommerceFacetTrailDroplet">
      <dsp:param name="trail" bean="FacetSearchTools.facetTrail"/>
      <dsp:param name="refineConfig" param="catRC"/>
      <dsp:param name="addFacet" param="addFacet"/>
      <dsp:oparam name="error">
        <fmt:message key="common.facetSrchErrorMessage"/>
      </dsp:oparam>

      <dsp:oparam name="output">
        <dsp:getvalueof var="facetTrailHolder" param="facetTrail" vartype="java.lang.Object"/>


      </dsp:oparam>

    </dsp:droplet>


    <c:set var="facetOrder" value="${param.facetOrder}"/>

    <c:choose>


      <c:when test="${not empty facetOrder}">

        <c:set value="${fn:trim(facetOrder)}" var="facetOrderVar"/>

        <c:set var="facetsCount" value="0"/>
        <c:forEach var="facetSelected" items="${facetTrailHolder.facetValues}" >
          <c:if test="${fn:contains(facetOrder, facetSelected.facet.id)}">
            <c:set var="facetsCount" value="${facetsCount + 1}"/>
          </c:if>
        </c:forEach>

        <c:forEach var="facetId" items="${facetOrderVar}">
          <c:forEach var="currentFacetHolder" items="${facetHolders}">
            <c:if test="${facetId eq currentFacetHolder.facet.id}">
              <%@include file="facetsRenderer.jspf" %>
            </c:if>
          </c:forEach>

          <c:forEach var="currentFacetHolder" items="${facetTrailHolder.facetValues}">
            <c:if test="${facetId eq currentFacetHolder.facet.id && currentFacetHolder.facet.refinementElement.label ne 'facet.label.Category'}">
              <c:set var="doNotIncludeFacetTrailParam" value="${facetsCount == 1}"/>
              <c:if test="${doNotIncludeFacetTrailParam && param.q_docSort != ''}">
                <!-- switch from ATG to simple navigation -->
                <c:choose>
                  <c:when test="${q_docSort == 'relevance'}">
                    <c:set var="q_docSort" value=""/>
                  </c:when>
                  <c:when test="${q_docSort == 'title'}">
                    <c:set var="q_docSort" value="displayName"/>
                  </c:when>
                </c:choose>
                
              </c:if>
              <%@ include file="facetObject.jspf" %>
              <c:set var="doNotIncludeFacetTrailParam" value="false"/>
            </c:if>
          </c:forEach>


        </c:forEach>


      </c:when>

      <c:otherwise>

        <c:forEach var="currentFacetHolder" items="${facetHolders}">
          <dsp:getvalueof var="facetProperty" vartype="java.lang.String"
                  value="${currentFacetHolder.facet.refinementElement.property}"/>
          <c:if test="${facetProperty != 'ancestorCategories.$repositoryId' && currentFacetHolder.facet.refinementElement.label ne 'facet.label.Category'}">
            <dsp:getvalueof var="facetId" vartype="java.lang.String" value="${currentFacetHolder.facet.id}"/>
            <c:choose>
              <c:when test="${empty facetOrder}">
                <c:set var="facetOrder" value="${facetId}"/>
              </c:when>
              <c:otherwise>
                <c:set var="facetOrder" value="${facetOrder},${facetId}"/>
              </c:otherwise>
            </c:choose>
          </c:if>
        </c:forEach>


        <c:forEach var="currentFacetHolder" items="${facetHolders}">
          <dsp:getvalueof var="facetProperty" vartype="java.lang.String"
                  value="${currentFacetHolder.facet.refinementElement.property}"/>
          <c:if test="${facetProperty != 'ancestorCategories.$repositoryId' && currentFacetHolder.facet.refinementElement.label ne 'facet.label.Category'}">
            <%@include file="facetsRenderer.jspf" %>
          </c:if>
        </c:forEach>


      </c:otherwise>
    </c:choose>
  </div>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/facet/gadgets/facetNavigationRenderer.jsp#2 $$Change: 635969 $--%>
