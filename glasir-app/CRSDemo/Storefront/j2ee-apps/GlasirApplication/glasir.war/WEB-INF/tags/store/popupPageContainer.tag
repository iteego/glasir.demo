<%-- 
Tag that acts as a container for all popup pages, including all relevant header, footer and nav
elements.
The body of this tag should include any required gadgets.

If any of the divId, titleKey or textKey attributes are set, then the popupPageIntro gadget will be included.
If none of these attributes are specified, then the popPageIntro gadget will not be included.

This tag accepts the following input parameters
pageTitle (optional) - string to be displayed as the <title> for the page
divId (optional) - id for the containing div. Will be passed to popupPageIntro gadget.
titleKey (optional)- resource bundle key for the title/heading of the page. Will be passed to popupPageIntro gadget.
textKey (optional) - resource bundle key for the intro text. Will be passed to popupPageIntro gadget.
titleString(optional) - String returned in message text when title key not found. Title String  that will be passed to the popupPageIntro gadget
textString(optional) - Intro text string that will be passed to the popupPageIntro gadget
useCloseImage(optional)- true or false, Default value - true.
--%>

<%@ include file="/includes/taglibs.jspf" %>
<%@ tag language="java" %>
<%@ attribute name="pageTitle" %>
<%@ attribute name="divId" %>
<%@ attribute name="titleKey" %>
<%@ attribute name="textKey" %>
<%@ attribute name="titleString" %>
<%@ attribute name="textString" %>
<%@ attribute name="useCloseImage" %>
<%@ attribute name="customCssFile" %>

<%-- Use the titleKey/titleString for the page title if no pageTitle is provided --%>
<c:if test="${empty pageTitle && (!empty titleKey || !empty titleString)}">
  <crs:messageWithDefault key="${titleKey}" string="${titleString}"/>
  <c:set var="pageTitle" value="${messageText}"/>
</c:if>

<%-- Custom css file can be specified --%>

<dsp:include page="/includes/popupStart.jsp" flush="true">
  <dsp:param name="index" value="${index}"/>
  <dsp:param name="follow" value="${follow}"/>
  <dsp:param name="pageTitle" value="${pageTitle}"/>
  <dsp:param name="customCssFile" value="${customCssFile}"/>
</dsp:include>

<c:if test="${!empty divId and (!empty titleKey or !empty textKey or !empty titleString or !empty textString)}">
  <dsp:include page="/global/gadgets/popupPageIntro.jsp" flush="true">
    <dsp:param name="divId" value="${divId}" />
    <dsp:param name="titleKey" value="${titleKey}" />
    <dsp:param name="textKey" value="${textKey}" />
    <dsp:param name="titleString" value="${titleString}"/>
    <dsp:param name="textString" value="${textString}"/>
    <dsp:param name="useCloseImage" value="${useCloseImage}" />
  </dsp:include>
</c:if>
<jsp:doBody/>

<dsp:include page="/includes/popupEnd.jsp" flush="true" />
<%-- @version $Id$$Change$--%>
