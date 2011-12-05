<dsp:page>
  <%-- 
  - Description: Generate the breadcrumbs that below the top menu.
  - This jsp snippet is responsible for maintaining and displaying navigation
  - history.  Navigation history is the path from the current location in the
  - catalog up to the top of the catalog as travelled by the user.
  --%>
  <dsp:importbean bean="/atg/commerce/catalog/CatalogNavHistory" />
  <dsp:importbean bean="/atg/commerce/catalog/CatalogNavHistoryCollector" />
  <dsp:importbean bean="/atg/repository/seo/CatalogItemLink"/>
  
  <dsp:droplet name="CatalogNavHistoryCollector">
    <dsp:param name="navAction" value="jump" />
    <dsp:param name="item" param="element" />
  </dsp:droplet>
    
  <dsp:getvalueof var="displayCrumb" param="displaybreadcrumbs"/>
  <c:if test="${displayCrumb == 'true'}">
      
      <dsp:getvalueof var="navHistory" bean="CatalogNavHistory.navHistory"/>
        
      <c:forEach var="navItem" items="${navHistory}" varStatus="status">
        <dsp:param name="navItem" value="${navItem}"/>
        <%--
           We want to put a separator between the items in the navHistory.  In this
           example we put a double sign between them starting from the second navItem.  
        --%>
        <c:if test="${status.count > 1}">
            <fmt:message key="common.breadcrumbSeparator"/>
        </c:if>
          
        <c:choose>
          <%-- For the first item we want render direct link to the main page --%>
          <c:when test="${status.count == 1}">
            <fmt:message var="itemLabel" key="common.home" />
            <dsp:a page="/index.jsp" iclass="atg_store_navLogo">
              ${itemLabel}
            </dsp:a>
          </c:when>
          <c:otherwise>
            <dsp:droplet name="CatalogItemLink">
              <dsp:param name="item" param="navItem"/>
              
              <dsp:oparam name="output">
                <dsp:getvalueof id="finalUrl" idtype="String" param="url"/>

                <dsp:a page="${finalUrl}">
                  <dsp:param name="navAction" value="pop"/>
                  <dsp:param name="navCount" bean="CatalogNavHistory.navCount"/>
                  <dsp:valueof param="navItem.displayName"/>
                </dsp:a>
              </dsp:oparam>
            </dsp:droplet>
          </c:otherwise>
        </c:choose> 
        </c:forEach>
    </c:if>
  <%-- end ForEach --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/breadcrumbs.jsp#2 $$Change: 635969 $--%>
