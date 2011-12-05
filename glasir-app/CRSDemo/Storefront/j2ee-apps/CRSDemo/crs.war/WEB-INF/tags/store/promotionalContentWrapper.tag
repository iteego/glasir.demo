<jsp:root xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:dsp="http://www.atg.com/taglibs/daf/dspjspTaglib1_0"
    xmlns:c="http://java.sun.com/jsp/jstl/core" version="2.0">
  <!-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/WEB-INF/tags/store/promotionalContentWrapper.tag#2 $$Change: 633752 $ -->
  <!--
    This tag renders a link to proper place specified by the promotional content.
    Inner contents of this link should be provided by tag's body.
    
    Input parameters:
      1. promotionalContent - promotion to be linked;
      
    Attributes:
      1. var - variable specified by this name will contain a name of linked object (category, product or promotion);
    
    Tag's logic is as follows:
      1. If associatedCategory has an URL, render link to this category;
      2. If associatedProduct has an URL, render link to this product;
      3. If promotionalContent has an URL on it, render link to this place;
      4. If promotionalContent has an associated site, render link to this site's home page;
      5. Otherwise just render the body.
  -->
  <jsp:directive.tag language="java" body-content="scriptless"/>
  <!-- 
    Output variable, the variable specified by this attribute will contain a title of linked element (category, product or promotion).
  -->
  <jsp:directive.attribute name="var" rtexprvalue="false" required="true"/>
  <jsp:directive.variable name-from-attribute="var" alias="title" scope="NESTED"/>
  <dsp:page>
    <div class="atg_store_categoryPromotion">
      <dsp:getvalueof var="categoryUrl" vartype="java.lang.String" param="promotionalContent.associatedCategory.template.url"/>
      <dsp:getvalueof var="prodUrl" vartype="java.lang.String" param="promotionalContent.associatedProduct.template.url"/>
      <dsp:getvalueof var="pageUrl" vartype="java.lang.String" param="promotionalContent.linkUrl"/>
      <dsp:getvalueof var="siteId" vartype="java.lang.String" param="promotionalContent.associatedSite"/>
      <dsp:getvalueof var="omitTooltip" vartype="java.lang.Boolean" param="omitTooltip"/>
      <!-- 
        It's OK to have several 'c:when' tags in a row, only the first one with 'true' test result will be rendered,
        all others will be ignored by server.
      -->
      <c:choose>
        <!-- Do we have a link to category? If yes, make a link to it and display body content. -->
        <c:when test="${not empty categoryUrl}">
          <dsp:getvalueof var="categoryDisplayName" vartype="java.lang.String" param="promotionalContent.associatedCategory.displayName"/>
          <dsp:getvalueof var="promotionalContentName" vartype="java.lang.String" param="promotionalContent.displayName"/>
          <!-- Escape category's name, cause it can contain restricted characters. -->
          <c:set var="title"><c:out value="${promotionalContentName}" escapeXml="true"/></c:set>
          <c:if test="${!omitTooltip}">
            <c:set var="tooltip" value="${title}"/>  
          </c:if>
          <dsp:a page="${categoryUrl}" title="${tooltip}">
            <dsp:param name="categoryId" param="promotionalContent.associatedCategory.repositoryId"/>
            <jsp:doBody/>
          </dsp:a>
        </c:when>
        <!-- Do we have a link to product? If yes, make a link to it and display body content. -->
        <c:when test="${not empty prodUrl}">
          <dsp:getvalueof var="productDisplayName" vartype="java.lang.String" param="promotionalContent.associatedProduct.displayName"/>
          <!-- Escape product's name, cause it can contain restricted characters. -->
          <c:set var="title"><c:out value="${productDisplayName}" escapeXml="true"/></c:set>
          <dsp:a page="${prodUrl}" title="${title}">
            <dsp:param name="productId" param="promotionalContent.associatedProduct.repositoryId"/>
            <jsp:doBody/>
          </dsp:a>
        </c:when>
        <!-- Do the promotion itself points somewhere? If yes, link to this place and render body. -->
        <c:when test="${not empty pageUrl}">
          <dsp:getvalueof var="promotionalContentDisplayName" vartype="java.lang.String" param="promotionalContent.displayName"/>
          <!-- Escape promotion's name, cause it can contain restricted characters. -->
          <c:set var="title"><c:out value="${promotionalContentDisplayName}" escapeXml="true"/></c:set>
          <dsp:a page="${pageUrl}" title="${title}">
            <jsp:doBody/>
          </dsp:a>
        </c:when>
        <!-- Do we have a link to some site? If yes, make a link to its home page. -->
        <c:when test="${not empty siteId}">
          <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
            <dsp:param name="siteId" value="${siteId}"/>
            <dsp:param name="customUrl" value="/index.jsp"/>
          </dsp:include>
          <dsp:getvalueof var="promotionalContentDisplayName" vartype="java.lang.String" param="promotionalContent.displayName"/>
          <!-- Escape promotion's name, cause it can contain restricted characters. -->
          <c:set var="title"><c:out value="${promotionalContentDisplayName}" escapeXml="true"/></c:set>
          <dsp:a href="${siteLinkUrl}" title="${title}">
            <jsp:doBody/>
          </dsp:a>
        </c:when>
        <!-- Nothing helped, just render the body. -->
        <c:otherwise>
          <jsp:doBody/>
        </c:otherwise>
      </c:choose>
    </div>
  </dsp:page>
</jsp:root>
