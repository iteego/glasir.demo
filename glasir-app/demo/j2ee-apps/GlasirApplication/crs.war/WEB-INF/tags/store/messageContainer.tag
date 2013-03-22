<%--
  Tag that renders a "message" box with message title,
  message text, and additional information.
  
  Input parameters:
    titleKey - resource bundle key for the message title, optional
    titleText - message title, optional
    messageKey - resource bundle key for the message, optional
    messageTitle - message, optional
    optionalClass - additional class for message container, optional
    id - id for the atg_store_generalMessageContainer div
--%>

<%@ include file="/includes/taglibs.jspf" %>
<%@ include file="/includes/context.jspf" %>

<%@attribute name="titleKey"%>
<%@attribute name="titleText"%>
<%@attribute name="messageKey"%>
<%@attribute name="messageText"%>
<%@attribute name="optionalClass"%>
<%@attribute name="id"%>

<dsp:page>
  <div id="${id}" class="${optionalClass} atg_store_generalMessageContainer">
    <div class="atg_store_generalMessage">
      
      <%-- Message title --%>
      <c:choose>
        <c:when test="${not empty titleKey}">
          <h3>
            <fmt:message key="${titleKey}"/>
          </h3>
        </c:when>
        <c:when test="${not empty titleText and empty titleKey}">
          <h3>
            <c:out value="${titleText}" escapeXml="true"/>
          </h3>
        </c:when>
      </c:choose>
      
      <%-- Message text --%>
      <c:choose>
        <c:when test="${not empty messageKey}">
          <p>
            <fmt:message key="${messageKey}"/>
          </p>
        </c:when>
        <c:when test="${not empty messageText and empty messageKey}">
          <p>
            <c:out value="${messageText}" escapeXml="true"/>
          </p>
        </c:when>
      </c:choose>
      <%-- Additional content will be render here --%>
      <jsp:doBody/>
    </div>
  </div>  
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/WEB-INF/tags/store/messageContainer.tag#3 $$Change: 635969 $--%>