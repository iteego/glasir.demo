<%--
  This page displays a link to an item stored in the CatalogNavHistory.
  Parameters:
    1. itemIndex - a zero-based index of the item to be displayed, must be greater or equal to one
  This page displays an item defined by the 'shift' paremter and links it to it's parent.
  I.e. if the CatalogNavHistory is Home->Category2->Category3 and shift is 1, it will display <a href="[link to home]">Category2</a>
--%>
<dsp:page>
  <dsp:getvalueof var="navItemShift" vartype="java.lang.Integer" param="itemIndex"/>
  <c:if test="${navItemShift > 0}">
    <dsp:getvalueof var="navHistory" vartype="java.util.Collection" scope="page" bean="/atg/commerce/catalog/CatalogNavHistory.navHistory"/>
    <dsp:param name="displayNameCategory" value="${navHistory[navItemShift]}"/>
    <c:choose>
      <c:when test="${navItemShift == 1}">
        <%-- Parent is a home page --%>
        <c:url var="url" scope="page" value="/index.jsp"/>
      </c:when>
      <c:otherwise>
        <%-- Otherwise, parent is a regular category --%>
        <dsp:droplet name="/atg/repository/seo/CatalogItemLink">
          <dsp:param name="item" value="${navHistory[navItemShift - 1]}"/>
          <dsp:oparam name="output">
            <dsp:getvalueof var="url" vartype="java.lang.String" scope="page" param="url"/>
            <%-- Determine if the generated URL is indirect URL for search spiders by 
                   checking the browser type. --%>
            <dsp:droplet name="/atg/repository/seo/BrowserTyperDroplet">
              <dsp:oparam name="output">
                <dsp:getvalueof var="browserType" param="browserType"/>
                <c:set var="isIndirectUrl" value="${browserType eq 'robot'}"/>
              </dsp:oparam>
            </dsp:droplet>
            <dsp:getvalueof var="atgSearchInstalled" bean="/atg/store/StoreConfiguration.atgSearchInstalled"/>
            <c:url var="url" scope="page" value="${url}">
              <c:if test="${not isIndirectUrl}">
                <c:param name="q_docSort"><dsp:valueof param="q_docSort"/></c:param>
                <c:if test="${atgSearchInstalled == 'true'}">
                  <dsp:droplet name="/atg/targeting/TargetingFirst">
                    <dsp:param name="howMany" value="1"/>
                    <dsp:param name="targeter" bean="/atg/registry/RepositoryTargeters/RefinementRepository/GlobalCategoryFacet"/>
                    <dsp:oparam name="output">
                      <dsp:getvalueof var="refElemRepId" vartype="java.lang.String" scope="page" param="element.repositoryId"/>
                    </dsp:oparam>
                  </dsp:droplet>
                  <c:param name="addFacet" value="${refElemRepId}:${navHistory[navItemShift - 1].repositoryId}"/>
                </c:if>
              </c:if>
            </c:url>
          </dsp:oparam>
        </dsp:droplet>
      </c:otherwise>
    </c:choose>
    <a href="${url}">
      <dsp:valueof param="displayNameCategory.displayName"/>
    </a>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/linkToNavItem.jsp#1 $$Change: 633540 $--%>
