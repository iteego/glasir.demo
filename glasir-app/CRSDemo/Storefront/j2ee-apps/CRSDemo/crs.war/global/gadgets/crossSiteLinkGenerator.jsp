<dsp:page>
<%--
  This gadget generates cross site link and creates request scope parameter 'siteLinkUrl'
  
  Parameter:
    product - product item
    customUrl - can be used in order to customize specific url via SiteLinkDroplet (e.g. in SEO case)
    queryParams - optional query parameters to include into URL
--%>

  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SiteLinkDroplet"/>
  <dsp:importbean bean="/atg/commerce/multisite/SiteIdForCatalogItem"/>
     
   <dsp:getvalueof var="product" param="product"/>
   <dsp:getvalueof var="siteId" param="siteId"/>
   <dsp:getvalueof var="customUrl" param="customUrl"/>

   <c:choose>
     <c:when test="${empty customUrl && empty product}">
       <dsp:getvalueof var="urlToUpdate" value=""/>
     </c:when>
     <c:when test="${empty customUrl && !empty product}">
       <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
     </c:when>
     <c:otherwise>  
       <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
     </c:otherwise>
   </c:choose> 

    <c:choose>
      <c:when test="${empty siteId && empty product}">
        <dsp:getvalueof var="siteLinkUrl" value="#" scope="request"/>
      </c:when>
      <c:when test="${empty siteId && !empty product}">
        <dsp:droplet name="SiteIdForCatalogItem">
          <dsp:param name="item" param="product"/>
          <dsp:oparam name="output">
            <dsp:getvalueof var="productSiteId" param="siteId"/>

            <dsp:droplet name="SiteLinkDroplet">
               <dsp:param name="siteId" value="${productSiteId}"/>
               <dsp:param name="path" value="${urlToUpdate}"/>
               <dsp:param name="queryParams" param="queryParams"/>
               <dsp:oparam name="output">
                  <dsp:getvalueof var="siteLinkUrl" param="url" scope="request"/>
               </dsp:oparam>
            </dsp:droplet>
          </dsp:oparam>
        </dsp:droplet>
      </c:when>
      <c:otherwise>
        <dsp:droplet name="SiteLinkDroplet">
          <dsp:param name="siteId" value="${siteId}"/>
          <dsp:param name="path" value="${urlToUpdate}"/>
          <dsp:param name="queryParams" param="queryParams"/>
          <dsp:oparam name="output">
            <dsp:getvalueof var="siteLinkUrl" param="url" scope="request"/>
         </dsp:oparam>
      </dsp:droplet>
    </c:otherwise>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/crossSiteLinkGenerator.jsp#2 $$Change: 635969 $--%>
