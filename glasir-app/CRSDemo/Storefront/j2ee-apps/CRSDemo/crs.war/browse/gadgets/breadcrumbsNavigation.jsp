<dsp:page>
  <%--
     Track the user's category navigation to provide the appropriate breadcrumbs
     This page expects the following parameters:
       categoryNavIds - ':' separated list representing the category navigation trail
       defaultCategory - Default category for the breadcrumb trail if no categoryNavIds provided
  --%>

  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>

  <dsp:getvalueof var="categoryNavIds" param="categoryNavIds"/>
  <c:choose>
    <c:when test="${!empty categoryNavIds}">
      <c:forEach var="categoryNavId"
                 items="${fn:split(categoryNavIds, ':')}"
                 varStatus="status">
        <c:set var="navAction" value="push"/>
        <c:if test="${status.first}">
          <c:set var="navAction" value="jump"/>
        </c:if>

        <dsp:droplet name="CategoryLookup">
          <dsp:param name="id" value="${categoryNavId}"/>
          <dsp:oparam name="output">
            <dsp:getvalueof var="currentCategory" param="element" vartype="java.lang.Object" scope="request"/>

            <dsp:droplet name="/atg/commerce/catalog/CatalogNavHistoryCollector">
              <dsp:param name="item" value="${currentCategory}" />
              <dsp:param name="navAction" value="${navAction}" />
            </dsp:droplet>
          </dsp:oparam>
        </dsp:droplet>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <dsp:droplet name="/atg/commerce/catalog/CatalogNavHistoryCollector">
        <dsp:param name="item" param="defaultCategory" />
        <dsp:param name="navAction" value="jump" />
      </dsp:droplet>
    </c:otherwise>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/breadcrumbsNavigation.jsp#2 $$Change: 635969 $--%>
