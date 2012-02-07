<dsp:page>

  <%--
      Global gadget used for rendering SEO meta tags

      Parameters:
      - catalogItem (optional) - product or category item used to combine product/category attributes
                                  with static SEO content from repository.
      - contentKey (optional) - key used to search SEOTags repository item, if not provided
                                  then page URL used instead.
  --%>
  <dsp:getvalueof var="catalogItem"  param="catalogItem"/>
  <c:set var="pageUrl" value="${pageContext.request.servletPath}" />
  <c:set var="key" value="${(not empty contentKey) ? contentKey : pageUrl}"/>
  <dsp:getvalueof var="site" bean="/atg/multisite/Site.id"/>
  <c:set var="queryRQL" value="${(not empty site) ? 'key = :key AND sites INCLUDES :site' : 'key = :key'}"/>
  
  
  <dsp:droplet name="/atg/dynamo/droplet/RQLQueryRange">
    <dsp:param name="repository" value="/atg/seo/SEORepository" />
    <dsp:param name="itemDescriptor" value="SEOTags" />
    <dsp:param name="howMany" value="1" />
    <dsp:param name="key" value="${key}" />
    <dsp:param name="site" bean="/atg/multisite/Site.id"/>
    <dsp:param name="queryRQL" value="${queryRQL}" />
    <dsp:oparam name="output">
      <dsp:getvalueof var="title" param="element.title"/>
      <dsp:getvalueof var="description" param="element.description"/>
      <dsp:getvalueof var="keywords" param="element.keywords"/>
    </dsp:oparam> 
  </dsp:droplet><%-- End of RQLQueryRange --%>

  <%-- Add product/category specific information to title and meta keywords/description if
          catalogItem is passed in --%>
      
  <c:if test="${not empty catalogItem}">
   
    <dsp:getvalueof var="itemName" param="catalogItem.displayName"/>
    <dsp:getvalueof var="itemDescription" param="catalogItem.longDescription"/>
    <dsp:getvalueof var="itemKeywords" param="catalogItem.keywords"/>
    <c:if test="${not empty itemName}">
      <c:set var="title" value="${itemName} ${title}"/> 
    </c:if>
    <c:if test="${not empty itemDescription}">
      <c:set var="description" value="${itemDescription} ${description}"/>
    </c:if>
    <c:if test="${not empty itemKeywords}">
      <c:set var="keywords" value="${fn:substring(itemKeywords,fn:indexOf(itemKeywords,'[')+1,fn:indexOf(itemKeywords,']'))},${keywords}"/>
    </c:if>
  </c:if> 
  
  <%-- Page's title --%>
  <c:choose>
    <c:when test="${not empty title}">    
      <title>${title}</title>
    </c:when>  
    <c:otherwise>
      <title>
        <fmt:message key="common.storeTitle">
          <fmt:param>
            <crs:outMessage key="common.storeName"/>
          </fmt:param>
        </fmt:message>
      </title> 
    </c:otherwise>
  </c:choose>   
  
  
  
  <%-- Page's meta description --%>
  <c:if test="${not empty description}">
    <c:set var="description" value="${fn:replace(description, '\"', '')}" />    
    <meta name="description" content="${description}" />
  </c:if>     
       
  <%-- Page's meta keywords --%>
  <c:if test="${not empty keywords}">
    <c:set var="keywords" value="${fn:replace(keywords, '\"', '')}" />
    <meta name="keywords" content="${keywords}"/>
  </c:if>
  
  <%-- Author meta tag --%>
  <fmt:message var="author" key="common.author" />
  <meta name="author" content="${author}"/>
     
  <%-- Dublin Core meta tags --%>
  <link rel="schema.DC" href="http://www.purl.org/dc/elements/1.1/" />
  <link rel="schema.DCTERMS" href="http://www.purl.org/dc/terms/" />
  <link rel="schema.DCMITYPE" href="http://www.purl.org/dc/dcmitype/" />

  <%--DC.DC.title content will be the same as page's title content --%>
  <meta name="DC.title" content="${title}" />
  
  <meta name="DC.creator" content="${author}" />
    
  <%--DC.subject content will be the same as keywords meta tag content --%>
  <meta name="DC.subject" content="${keywords}" />
    
  <%--DC.DC.description content will be the same as description meta tag content --%>
  <meta name="DC.description" content="${description}" />
    
  <%-- a person, an organization, or a service responsible for making the resource available --%>
  <meta name="DC.publisher" content="${author}" />
    
  <meta name="DC.type" scheme="DCTERMS.DCMIType" content="Text" />
   
  <meta name="DC.format" content="text/html" />
    
  <meta name="DC.language" scheme="RFC1766" content="en" />
    
  <meta name="DC.rights" content="/company/terms.jsp" />
    
    
  <meta name="DC.identifier" scheme="DCTERMS.URI" content="${pageUrl}" />
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/metaDetails.jsp#1 $$Change: 633540 $--%>