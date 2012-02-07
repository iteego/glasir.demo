<%--
  This gadget renders available sites (stores).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
  
  <dsp:getvalueof var="currentSiteId" bean="Site.id"/>

  <dsp:droplet name="SharingSitesDroplet">
    <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
    <dsp:oparam name="output">
    
      <dsp:getvalueof var="sites" param="sites"/>
      <dsp:getvalueof var="size" value="${fn:length(sites)}" />
      
      <c:if test="${size > 1}">
        <div id="atg_store_sites">
          <h2>
            <fmt:message key="navigation_internationalStores.internationalStoresTitle" />
            <fmt:message key="common.labelSeparator"/>
          </h2>

          <ul>
          
          <dsp:droplet name="ForEach">
            <dsp:param name="array" param="sites"/>
            <dsp:setvalue param="site" paramvalue="element"/>
            <dsp:param name="sortProperties" value="-name"/>
            
            <dsp:oparam name="output">
              <dsp:getvalueof var="size" param="size"/>
              <dsp:getvalueof var="count" param="count"/>
              <dsp:getvalueof var="siteName" param="site.name"/>
              <dsp:getvalueof var="siteId" param="site.id"/>
              
              <li class="<crs:listClass count="${count}" size="${size}" selected="${siteId == currentSiteId}" />">
                <c:choose>
                  <c:when test="${siteId == currentSiteId}">
                    <dsp:valueof value="${siteName}" />
                  </c:when>
                  <c:otherwise>
                    <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
                      <dsp:param name="siteId" value="${siteId}"/>
                      <dsp:param name="customUrl" value="/"/>
                    </dsp:include>
                    <dsp:a href="${siteLinkUrl}" title="${siteName}">${siteName}</dsp:a>
                  </c:otherwise>
                </c:choose>
              </li>
            </dsp:oparam>                            
          </dsp:droplet>
          </ul>
        </div>
      </c:if>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/sites.jsp#2 $$Change: 635969 $ --%>