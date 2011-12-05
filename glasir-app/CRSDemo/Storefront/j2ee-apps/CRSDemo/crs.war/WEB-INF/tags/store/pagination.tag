<%-- Tag that determines what to display for paging links.  If the link is
     currently selected, it is displayed as plain text.  If the link is not
     selected, the fragment pageLinkRenderer or viewAllLinkRenderer is invoked.
     Parameters:
     -  size - Size of the listing to be displayed.
     -  arraySplitSize - Number of items to show on each page.
     -  start - Index (1 based) of first element being shown on this page.
     -  viewAll (optional) - Set to true if viewAll has been requested.
     -  top - Set to true if this is the top set of links, false if it is the bottom set
     -  itemList - The list of items to page.
     Variables set:
     -  linkTitle - The title to display for the link.
     -  linkText - The text to display for the link.
     -  startValue - The first item on the page the link it for.
     -  viewAllLinkClass - The class to use for the view all link.
  --%>

<%@include file="/includes/taglibs.jspf"%>
<%@include file="/includes/context.jspf"%>

<%@ tag body-content="empty" %>

<%@ attribute name="size" required="true" type="java.lang.Integer" %>
<%@ attribute name="arraySplitSize" required="true" type="java.lang.Integer" %>
<%@ attribute name="start" required="true" %>
<%@ attribute name="viewAll" required="true" type="java.lang.Boolean" %>
<%@ attribute name="top" required="true" type="java.lang.Boolean" %>
<%@ attribute name="itemList" required="true" type="java.lang.Object" %>

<%@ attribute name="pageLinkRenderer" fragment="true" %>
<%@ attribute name="viewAllLinkRenderer" fragment="true" %>

<%@ variable name-given="linkTitle" variable-class="java.lang.String" %>
<%@ variable name-given="linkText" variable-class="java.lang.String" %>
<%@ variable name-given="startValue" variable-class="java.lang.String" %>
<%@ variable name-given="viewAllLinkClass" variable-class="java.lang.String" %>

<dsp:page>

  <dsp:importbean bean="/atg/store/droplet/ArraySubsetHelper"/>

  <c:set var="viewAllLinkClass" value="atg_store_actionViewAll"/>

  <div class="atg_store_index">
          
            <ul>
              <%-- Show each page link --%>

        <dsp:getvalueof var="p_finalPageSize" value="${size/arraySplitSize + 1}" />
        <c:if test="${size % arraySplitSize == 0}">    <%-- don't add extra page when it divides evenly --%>
        <dsp:getvalueof var="p_finalPageSize" value="${size/arraySplitSize}" />
        </c:if>
        
        <c:forEach var="i" begin="1" end="${p_finalPageSize}" step="1" varStatus ="status">
          <c:set var="selected" value="${((i - 1) * arraySplitSize + 1) == start}"/>
          <li class="<crs:listClass count="${i}" size="${size/arraySplitSize + 1}" selected="${selected}"/>">
            <%-- See if we put a link on this one --%>
            <c:choose>
              <c:when test="${!selected || viewAll}">
                <fmt:message var="linkTitle" key="common.button.paginationTitle">
                  <fmt:param value="${i}"/>
                </fmt:message>
                <c:set var="linkText" value="${i}"/>
                <dsp:getvalueof id="startValue" value="${(i - 1) * arraySplitSize + 1}"/>
                <jsp:invoke fragment="pageLinkRenderer"/>
              </c:when>
              <c:otherwise>
                <span class="disabledLink">${i}</span>
              </c:otherwise>
            </c:choose>
          </li>
        </c:forEach>

              <%-- Show the "view all" link if needed --%>
              <c:if test="${size > arraySplitSize}">
                <li class="atg_store_paginationViewAll ${viewAll ? 'active' : ''}">
                  <fmt:message var="linkText" key="common.button.viewAllText"/>
                  <fmt:message var="linkTitle" key="common.button.viewAllTitle"/>
                  <c:choose>
                    <c:when test="${viewAll}">
                      <span class="disabledLink" title="${linkTitle}">${linkText}</span>
                    </c:when>
                    <c:otherwise>
                      <jsp:invoke fragment="viewAllLinkRenderer"/>
                    </c:otherwise>
                  </c:choose>
                </li>
              </c:if>
            </ul>
          </div>
</dsp:page>

<%-- @version $Id$$Change$ --%>
