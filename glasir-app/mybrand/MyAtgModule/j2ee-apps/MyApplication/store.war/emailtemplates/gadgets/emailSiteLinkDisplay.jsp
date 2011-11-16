<dsp:page>
<%--
  This gadget rendered link with fully-qualified site URL and displays it as text link or image link.
  
  Parameter:
    httpserver - URL prefix that includes protocol and server name
    path - base URL to wrap into site details.
    linkStyle - CSS style for anchor tag
    linkText - text to display for link
    linkTitle - link title
    imageUrl - image URL for a link
    imageTitle - image title
    imageAltText - image alt text
--%>

   
  <dsp:getvalueof var="linkStyle" param="linkStyle"/>
  <dsp:getvalueof var="linkText" param="linkText"/>
  <dsp:getvalueof var="linkTitle" param="linkTitle"/>
  <dsp:getvalueof var="imageUrl" param="imageUrl"/>
  <dsp:getvalueof var="imageTitle" param="imageTitle"/>
  <dsp:getvalueof var="imageAltText" param="imageAltText"/>
  
  
  <dsp:include page="/emailtemplates/gadgets/emailSiteLink.jsp">
    <dsp:param name="path" param="path"/>
    <dsp:param name="httpserver" param="httpserver"/>
    <dsp:param name="queryParams" param="queryParams"/>
  </dsp:include>
  
  <dsp:a href="${siteLinkUrl}" style="${linkStyle}">
    <c:choose>
      <c:when test="${not empty imageUrl}">
        <img src="${imageUrl}" border="0" title="${imageTitle}" alt="${imageAltText}" style="max-width:171px;max-height:68px;">
        <c:if test="${not empty linkText}" >
          <span>${linkText}</span>
        </c:if>
      </c:when>
      <c:otherwise>
        ${linkText}
      </c:otherwise>
    </c:choose>
  </dsp:a>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailSiteLinkDisplay.jsp#1 $$Change: 633540 $--%>
