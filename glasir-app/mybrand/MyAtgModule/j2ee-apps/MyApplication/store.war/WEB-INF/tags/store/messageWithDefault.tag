<%@include file="/includes/taglibs.jspf"%>
<%@include file="/includes/context.jspf"%>
<%@ tag body-content="empty" %>
<%@ attribute name="key" required="false" %>
<%@ attribute name="string" required="false" %>
<%@ variable name-given="messageText" variable-class="java.lang.String" scope="AT_END" %>

<%-- Tag that takes a message file key and default string and if the key is
     valid and contains a value it is returned in messageText.  If not, then
     the default string is returned in messageText.  Not passing in a key or
     default value is acceptable.
     
     Note that parameters are not supported for the msssage file entry.
--%>

<c:set var="messageText" value=""/>

<c:if test="${!empty key}">
  <c:set var="missingKeyResult" value="???${key}???"/>
  <fmt:message var="keyValue" key="${key}"/>
  <c:if test="${keyValue != missingKeyResult}">
    <c:set var="messageText" value="${keyValue}"/>
  </c:if>
</c:if>

<c:if test="${empty messageText}">
  <c:set var="messageText" value="${string}"/>
</c:if>
<%-- @version $Id$$Change$--%>
