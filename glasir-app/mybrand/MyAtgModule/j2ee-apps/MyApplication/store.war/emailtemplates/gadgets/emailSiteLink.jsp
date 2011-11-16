<dsp:page>
<%--
  This gadget generates fully-qualified site link and puts it into request scope parameter 'siteLinkUrl'
  
  Parameter:
    httpserver - URL prefix that includes protocol and server name
    path - base URL to wrap into site details
    queryParams - optional query parameters to include into URL
--%>

  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SiteLinkDroplet"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  
  <dsp:getvalueof var="siteId" bean="Site.id"/>
  <dsp:getvalueof var="httpserver" param="httpserver"/>
    
  <c:choose>
    <c:when test="${not empty siteId}">
      <dsp:droplet name="SiteLinkDroplet">
        <dsp:param name="siteId" value="${siteId}"/>
        <dsp:param name="path" param="path"/>
        <dsp:param name="queryParams" param="queryParams"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="siteUrl" param="url"/>
          <c:url var="siteUrl" value="${siteUrl}" context="/">
            <c:param name="locale"><dsp:valueof param="locale"/></c:param>
          </c:url> 
          <c:set var="siteLinkUrl" scope="request" value="${httpserver}${siteUrl}"/>
        </dsp:oparam>
      </dsp:droplet>
    </c:when>
    <c:otherwise>
       
    </c:otherwise>
  </c:choose>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailSiteLink.jsp#2 $$Change: 635969 $--%>
