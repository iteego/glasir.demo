<%--
  This gadget displays:
  
  - item display name;
  - top-level category hero image;
  - top-level category promotion;
  - breadcrumbs for the current item;
  
  Input parameters:
    displayName - display name of category or product item
    category - current category;
    categoryNavIds - string of category IDs separated with ':' (optional)
 --%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/commerce/catalog/CatalogNavHistory" />

  <%-- extract input parameters --%>
  <dsp:getvalueof var="categoryNavIds" param="categoryNavIds"/>
  <dsp:getvalueof var="displayName" param="displayName"/>
  
  <%--
    determine top-level category and background image
    if we have categoryNavIds then use top level category from there,
    otherwise, use collected CatalogNavHistory.navHistory
   --%>
  <c:choose>
    <c:when test="${not empty categoryNavIds}">
      <dsp:getvalueof var="categoryIds" value="${fn:split(categoryNavIds, ':')}"/>
      
      <dsp:droplet name="CategoryLookup">
        <dsp:param name="id" value="${categoryIds[0]}"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="categoryHeroImageUrl" param="element.titleImage.url"/>
          <dsp:getvalueof var="topCategory" param="element"/>
        </dsp:oparam>
      </dsp:droplet>
    </c:when>
    <c:otherwise>
      <dsp:importbean bean="/atg/commerce/catalog/CatalogNavHistory" />
      <dsp:getvalueof var="navHistory" vartype="java.util.Collection" bean="CatalogNavHistory.navHistory"/>
      <c:if test="${fn:length(navHistory) > 1}">
        <dsp:getvalueof var="topCategory" bean="CatalogNavHistory.navHistory[1]" />
        <dsp:getvalueof var="categoryHeroImageUrl" bean="CatalogNavHistory.navHistory[1].titleImage.url"/>
      </c:if>
    </c:otherwise>
  </c:choose>
  <%-- Set top level category to the CatalogNavigation bean for further user in targeters--%>
  <dsp:setvalue bean="/atg/store/catalog/CatalogNavigation.topLevelCategory" value="${topCategory.repositoryId}"/>
  <c:choose>
    <c:when test="${not empty categoryHeroImageUrl}">
      <div id="atg_store_contentHeader" style="background:url(${categoryHeroImageUrl}) bottom left no-repeat">
    </c:when>
    <c:otherwise>
      <div id="atg_store_contentHeader">
    </c:otherwise>
  </c:choose>
  
  <div id="atg_store_contentHeadPromo"> 
    <dsp:include page="/browse/gadgets/categoryPromotions.jsp" flush="true">
      <dsp:param name="category" value="${topCategory}" />
    </dsp:include>
  </div>    
  
  <dsp:getvalueof var="displayName" param="displayName"/>
  <h2 class="title <crs:stringSizeClass string='${displayName}'/>">
    ${displayName}
  </h2>

  <div id="atg_store_breadcrumbs">
    <dsp:include page="/navigation/gadgets/breadcrumbs.jsp">
      <%-- The parameter element represents a top level category --%>
      <dsp:param name="element" param="category" />
      <dsp:param name="displaybreadcrumbs" value="true" />
      <dsp:param name="navAction" param="jump" />
    </dsp:include>
  </div>

  </div> <%-- end of atg_store_contentHeader div --%>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/itemHeader.jsp#2 $$Change: 635969 $--%>
