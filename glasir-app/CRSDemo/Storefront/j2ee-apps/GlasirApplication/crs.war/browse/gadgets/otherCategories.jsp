<dsp:page>

  <%-- This page displays the other related categories
       Parameters 
       - category - category repository item being displayed.
  --%>

  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>

  <div id="atg_store_otherCategories">

    <%-- Show the Related Categories - these are the Solutions For X --%>
    <dsp:getvalueof var="relatedCategories" param="category.relatedCategories"/>
    <c:if test="${not empty relatedCategories}">
      <dsp:getvalueof id="size" value="${fn:length(relatedCategories)}"/>
      <h3>
        <fmt:message key="browse_otherCategories.otherCategories"/><fmt:message key="common.labelSeparator"/>
      </h3>
      <ul>
        <c:forEach var="relatedCategory" items="${relatedCategories}" varStatus="relatedCategoryStatus">
          <dsp:getvalueof id="count" value="${relatedCategoryStatus.count}"/>
          <dsp:getvalueof id="index" value="${relatedCategoryStatus.index}"/>
          <dsp:param name="relatedCategory" value="${relatedCategory}"/>

          <c:set var="classString">
            <crs:listClass count="${count}" size="${size}" selected="false"/>
          </c:set>
          <dsp:getvalueof var="relatedCategoryUrl" param="relatedCategory.template.url"/>
          <c:choose>
            <c:when test="${not empty relatedCategoryUrl}">
              <%-- New Implementation for SEO --%>
              <%--  Renders the links to categories related to the current sub-category
                    on the sub-category product range page, in the right navigation 
                    panel, depending on the userAgent visiting the site --%>
              <dsp:droplet name="/atg/repository/seo/CatalogItemLink">
                <dsp:param name="item" param="relatedCategory"/>
                <dsp:oparam name="output">

                  <dsp:getvalueof id="finalUrl" idtype="java.lang.String" param="url">

                    <fmt:message var="relatedCategoryTitle" 
                        key="browse_otherCategories.relatedCategoryTitleText" />

                    <dsp:getvalueof var="relatedCategoryText" value=""/>
                    <dsp:getvalueof var="relatedCategoryParent" param="relatedCategory.parentCategory.parentCategory"/>
                    <c:if test="${not empty relatedCategoryParent}">
                      <%-- We have a grandparent, so include our parent's name --%>
                      <dsp:getvalueof var="relatedCategoryText" param="relatedCategory.parentCategory.displayName"/>
                      <dsp:getvalueof var="relatedCategoryText" value="${relatedCategoryText} - " />
                    </c:if>
                    <dsp:getvalueof var="categoryName" param="relatedCategory.displayName"/>
                    <c:choose>
                      <c:when test="${not empty categoryName}">
                        <dsp:getvalueof var="relatedCategoryText" value="${relatedCategoryText}${categoryName}" />
                      </c:when>
                      <c:otherwise>
                        <fmt:message var="defaultCategoryName" key="common.categoryNameDefault"/>
                        <dsp:getvalueof var="relatedCategoryText" value="${relatedCategoryText}${defaultCategoryName}" />
                      </c:otherwise>
                    </c:choose>

                    <li class="${classString} active">

                      <dsp:a page="${finalUrl}" title="${relatedCategoryTitle}">
                        ${relatedCategoryText}
                      </dsp:a>
                    </li>

                  </dsp:getvalueof>

                </dsp:oparam> <%-- End oparam output --%>
              </dsp:droplet> <%-- End CatalogItemLink droplet --%>
              <%-- SEO --%>
            </c:when>
            <c:otherwise>
              <li class="${classString} disabled">
                <dsp:valueof bean="/OriginatingRequest.requestURIWithQueryString">
                </dsp:valueof>
                <fmt:message key="browse_otherCategories.URLDefault"/>
              </li>
            </c:otherwise>
          </c:choose><%-- End Is Empty Check on the template URL --%>
        <%-- ******************** end related categories ***************** --%>
        </c:forEach>
      </ul>
    </c:if>
  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/otherCategories.jsp#2 $$Change: 635969 $--%>
