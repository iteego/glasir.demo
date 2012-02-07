<%@include file="/includes/taglibs.jspf"%>
<%@include file="/includes/context.jspf"%>

<%@ variable name-given="continueShoppingURL" variable-class="java.lang.String" %>

  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <dsp:getvalueof var="contextroot" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof var="categoryLastBrowsed" bean="Profile.categoryLastBrowsed"/>
  <c:choose>
    <c:when test="${not empty categoryLastBrowsed}">
      <dsp:droplet name="CategoryLookup">
        <dsp:param name="id" bean="Profile.categoryLastBrowsed"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="templateURL" vartype="java.lang.String" param="element.template.url"/>
          <c:choose>
            <c:when test="${not empty templateURL}">
              <dsp:getvalueof var="categoryId" vartype="java.lang.String" param="element.repositoryId"/>
              <c:url var="continueShoppingURL" context="${contextroot}" value="${templateURL}">
                <c:param name="categoryId" value="${categoryId}"/>
              </c:url>
            </c:when>
            <c:otherwise>
               <%-- No Id in profile for last category browsed --%>
               <c:set var="continueShoppingURL" value="${contextroot}/index.jsp"/>
            </c:otherwise>
          </c:choose><%-- End is empty check on category --%>
        </dsp:oparam>
        <dsp:oparam name="wrongCatalog">
          <%-- Category not found in this catalog lookup --%>
          <c:url var="continueShoppingURL" context="${contextroot}" value="/index.jsp"/>
        </dsp:oparam>
        <dsp:oparam name="wrongSite">
          <%-- Category not found in current site catalog --%>
          <c:url var="continueShoppingURL" context="${contextroot}" value="/index.jsp"/>
        </dsp:oparam>
        <dsp:oparam name="noCatalog">
          <%-- No catalog found in this catalog lookup --%>
          <c:url var="continueShoppingURL" context="${contextroot}" value="/index.jsp"/>
        </dsp:oparam>
        <dsp:oparam name="error">
          <%-- No catalog found in this catalog lookup --%>
          <c:url var="continueShoppingURL" context="${contextroot}" value="/index.jsp"/>
        </dsp:oparam>
        <dsp:oparam name="empty">
          <%-- Category not found with lookup --%>
          <c:url var="continueShoppingURL" context="${contextroot}" value="/index.jsp"/>
        </dsp:oparam>
      </dsp:droplet><%-- End lookup last category browsed --%>
    </c:when>
    <c:otherwise>
      <%-- No Id in profile for last category browsed --%>
      <c:url var="continueShoppingURL" context="${contextroot}" value="/index.jsp"/>
    </c:otherwise>
  </c:choose><%-- End is empty check on category last browsed --%>
  <jsp:doBody/>
<%-- @version $Id$$Change$--%>
