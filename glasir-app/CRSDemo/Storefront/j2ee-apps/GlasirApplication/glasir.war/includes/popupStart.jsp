<%--
  This page expects the following input parameters:
    pageTitle(optional) - HTML title for the page
--%>
<dsp:page>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/store/StoreConfiguration"/>

  <dsp:getvalueof id="pageTitle" param="pageTitle"/>

  <dsp:getvalueof var="contextPath" bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof var="language" bean="/OriginatingRequest.requestLocale.locale.language"/>

  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
                        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <%--
            Puts ie8 into "Compatibility" mode so it will render just like ie7
            http://blogs.msdn.com/ie/archive/2008/08/27/introducing-compatibility-view.aspx
            http://blogs.msdn.com/ie/archive/2009/03/12/site-compatibility-and-ie8.aspx
       --%>
      <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />

      <%-- Grid style sheet --%>
      <link rel="stylesheet" href="${contextPath}/css/grid.css"
            type="text/css" media="screen" title="no title" charset="utf-8" />

      <%-- According to the conditional comment this is Internet Explorer load the IE CSS --%>
      <!--[if IE]>
        <link rel="stylesheet" href="${contextPath}/css/ie.css"
        type="text/css" media="screen" title="no title" charset="utf-8" />
      <![endif]-->

      <%-- Load the site specific CSS --%>
      <dsp:getvalueof var="siteId" bean="Site.id" />
      <dsp:getvalueof var="siteCssFile" bean="Site.cssFile" />

      <c:choose>
        <c:when test="${empty siteCssFile}">
          <dsp:getvalueof var="siteCssFile" bean="StoreConfiguration.defaultCssFile" />
        </c:when>
      </c:choose>

      <c:if test="${not empty siteCssFile}">
        <link rel="stylesheet" href="${contextPath}/${siteCssFile}.css"
              type="text/css" media="screen" title="no title" charset="utf-8" />

        <c:if test="${siteId eq 'homeSite'}">
          <%-- According to the conditional comment this is Internet Explorer load the site IE CSS --%>
          <!--[if IE]>
            <link rel="stylesheet" href="${contextPath}${siteCssFile}_ie.css"
                  type="text/css" media="screen" title="no title" charset="utf-8" />
          <![endif]-->
        </c:if>

        <%-- Load language specific CSS if this is a language which requires additional styling --%>
        <c:if test="${language eq 'de'}">
          <link rel="stylesheet" href="${contextPath}${siteCssFile}_de.css"
                type="text/css" media="screen" title="no title" charset="utf-8" />
          <!--[if IE]>
            <link rel="stylesheet" href="${contextPath}${siteCssFile}_de_ie.css"
            type="text/css" media="screen" title="no title" charset="utf-8" />
          <![endif]-->
        </c:if>

        <c:if test="${language eq 'es'}">
          <link rel="stylesheet" href="${contextPath}${siteCssFile}_es.css"
                type="text/css" media="screen" title="no title" charset="utf-8" />
          <!--[if IE]>
            <link rel="stylesheet" href="${contextPath}${siteCssFile}_es_ie.css"
            type="text/css" media="screen" title="no title" charset="utf-8" />
          <![endif]-->
        </c:if>
      </c:if>


      <%-- Possible alternative print style sheet modify the css style file --%>
      <link rel="stylesheet" href="${contextPath}/css/common_print.css"
            type="text/css" media="print" title="no title" charset="utf-8" />

      <script type="text/javascript" charset="utf-8">
        <%-- Javascript on css style --%>
        document.write('<link rel="stylesheet" href="${contextPath}/css/javascript.css" type="text/css" charset="utf-8" />');

        <%-- Get rid of the IE rollover flicker. --%>
        try {
          document.execCommand('BackgroundImageCache', false, true);
        } catch(e) {}
      </script>

      <%-- Robots meta tag --%>
      <dsp:getvalueof var="index" param="index"/>
      <dsp:getvalueof var="follow" param="follow"/>

      <c:set var="indexValue" value="${((index eq null) || (index eq 'false')) ? 'noindex' : 'index'}"/>
      <c:set var="followValue" value="${((follow eq null) || (follow eq 'false')) ? 'nofollow' : 'follow'}"/>

      <meta name="robots" content="${indexValue},${followValue}"/>

      <title>
        <fmt:message key="common.popupStoreTitle">
          <fmt:param>
            <crs:outMessage key="common.storeName"/>
          </fmt:param>
          <fmt:param value="${pageTitle}" />
        </fmt:message>
      </title>

      <dsp:include page="/includes/popupStartScript.jsp"/>
    </head>

    <body id="atg_store_popup">
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/includes/popupStart.jsp#2 $$Change: 635969 $--%>
