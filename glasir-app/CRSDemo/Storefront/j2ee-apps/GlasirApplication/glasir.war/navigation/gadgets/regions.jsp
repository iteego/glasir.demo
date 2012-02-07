<%--
  This page renders regions (locations). 
--%>
<dsp:page>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />
  
  <dsp:droplet name="ComponentExists">
    <dsp:param name="path" value="/atg/modules/InternationalStore" />
    <dsp:oparam name="true">
      
      <dsp:droplet name="SharingSitesDroplet">
        <dsp:param name="shareableTypeId" value="crs.RelatedRegionalStores"/>
        <dsp:oparam name="output">
    
          <dsp:getvalueof var="sites" param="sites"/>
          <dsp:getvalueof var="size" value="${fn:length(sites)}" />
      
          <c:if test="${size > 1}">
          
            <dsp:getvalueof var="currentSiteId" bean="Site.id"/>
        
            <div id="atg_store_regions">
              <h2>
                <fmt:message key="navigation_internationalStores.RegionsTitle" />
                <fmt:message key="common.labelSeparator"/>
              </h2>

              <ul>
                <dsp:droplet name="ForEach">
                  <dsp:param name="array" param="sites"/>
                  <dsp:setvalue param="site" paramvalue="element"/>
                  
                  <dsp:oparam name="output">
                    <dsp:getvalueof var="size" param="size"/>
                    <dsp:getvalueof var="count" param="count"/>
                    <dsp:getvalueof var="siteId" param="site.id"/>
                    <fmt:message key="navigation_country.${siteId}" var="countryName"/>
                    
                    <li class="<crs:listClass count="${count}" size="${size}" selected="${siteId == currentSiteId}" />">
                      <c:choose>
                        <c:when test="${siteId == currentSiteId}">
                          <dsp:valueof value="${countryName}" />
                        </c:when>
                        <c:otherwise>
                          <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
                            <dsp:param name="siteId" value="${siteId}"/>
                            <dsp:param name="customUrl" value="/"/>
                          </dsp:include>
                          <dsp:a href="${siteLinkUrl}" title="${countryName}">${countryName}</dsp:a>
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
    </dsp:oparam>
  </dsp:droplet>  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/regions.jsp#1 $$Change: 633540 $--%>