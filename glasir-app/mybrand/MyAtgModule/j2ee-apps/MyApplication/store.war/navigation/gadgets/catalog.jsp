<%--
  This page renders links to categories and subcategories,
  featured products for every catagory, and also
  highlight selected top level category. 
--%>
<dsp:page>

  <dsp:importbean bean="/atg/store/StoreConfiguration" />
  <dsp:importbean bean="/atg/repository/seo/CatalogItemLink" />
  <dsp:importbean bean="/atg/targeting/TargetingFirst" />
  <dsp:importbean bean="/atg/userprofiling/Profile" />
  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet" />

  <dsp:getvalueof var="atgSearchInstalled" bean="StoreConfiguration.atgSearchInstalled" />
  
  <%-- 
    Attempt to resolve selected top category using navigation history.
    when user opens category/subcategory page category parameter is initialized,
    when user opens product detail page - product parameter is initialized    
  --%>
  <dsp:getvalueof var="product" param="product"/>
  <dsp:getvalueof var="category" param="category"/>

  <c:choose>
    <c:when test="${not empty category}">
      <dsp:getvalueof var="e" param="category"/>
    </c:when>
    <c:when test="${not empty product}">
      <dsp:getvalueof var="e" param="product"/>
    </c:when>
  </c:choose>
  
  <%-- invoke NavHistoryCollector to build navigation history for the given element --%>
  <c:if test="${not empty e}">
    <%-- get navigation history --%>
    <dsp:getvalueof var="navHistory" bean="/atg/commerce/catalog/CatalogNavHistory.navHistory"/>
    <dsp:getvalueof var="historySize" value="${fn:length(navHistory)}" />

    <%-- first element in history is already root, so skip it --%>
    <c:if test="${historySize > 0}">
      <dsp:getvalueof var="selectedCategoryId" value="${navHistory[1].repositoryId}"/>
    </c:if>
  </c:if>
  
  <%-- Retrieve list of top categories from the root category --%>
  <dsp:getvalueof var="childCategories"
    bean="Profile.catalog.rootNavigationCategory.childCategories" />

  <%-- Iterate over the list of top level categories --%>
  <c:forEach var="element" items="${childCategories}"  varStatus="status">
    <dsp:param name="topCategory" value="${element}" />
    <dsp:getvalueof var="categoryId" vartype="String" param="topCategory.repositoryId" />

    <c:set var="categoryNavIds" value="${categoryId}" />

    <%-- Highlight selected top level category --%>
    <li class="${categoryId==selectedCategoryId?' currentCat':' '}">

      <%-- Display the category link as text --%>
      <dsp:droplet name="CatalogItemLink">
        <dsp:param name="item" param="topCategory" />
        <dsp:oparam name="output">
          <dsp:getvalueof id="finalUrl" idtype="String" param="url" />
          <%-- Determine if the generated URL is indirect URL for search spiders by 
               checking the browser type. --%>
          <dsp:droplet name="/atg/repository/seo/BrowserTyperDroplet">
            <dsp:oparam name="output">
              <dsp:getvalueof var="browserType" param="browserType"/>
              <c:set var="isIndirectUrl" value="${browserType eq 'robot'}"/>
            </dsp:oparam>
          </dsp:droplet>
          <%-- Filters faceted display by Sub-Category, if Search is installed,
                               otherwise, simply displays the sub-category selected --%>
          <c:choose>
            <c:when test="${isIndirectUrl}">
              <dsp:a page="${finalUrl}" iclass="topCatLinks">
                <dsp:valueof param="topCategory.displayName">
                  <fmt:message key="common.categoryNameDefault" />
                </dsp:valueof>
              </dsp:a>
            </c:when>
            <c:when test="${atgSearchInstalled == 'true'}">

              <%-- TargetingFirst --%>
              <%-- Retrieve ID of the Global Category refineElement and tie it to Category Navigation--%>
              <dsp:droplet name="TargetingFirst">
                <dsp:param name="howMany" value="1" />
                <dsp:param name="targeter"
                           bean="/atg/registry/RepositoryTargeters/RefinementRepository/GlobalCategoryFacet" />

                <dsp:oparam name="output">

                  <dsp:getvalueof id="refElemRepId" idtype="String"
                                  param="element.repositoryId" />

                  <dsp:a page="${finalUrl}" iclass="topCatLinks">
                    <dsp:param name="addFacet"
                               value="${refElemRepId}:${categoryId}" />
                    <dsp:param name="categoryNavIds" value="${categoryNavIds}"/>
                    <dsp:valueof param="topCategory.displayName">
                      <fmt:message key="common.categoryNameDefault" />
                    </dsp:valueof>
                  </dsp:a>
                </dsp:oparam>

                <dsp:oparam name="empty">
                  <dsp:a page="${finalUrl}" iclass="topCatLinks">
                    <dsp:param name="categoryNavIds" value="${categoryNavIds}"/>
                    <dsp:valueof param="topCategory.displayName">
                      <fmt:message key="common.categoryNameDefault" />
                    </dsp:valueof>
                  </dsp:a>
                </dsp:oparam>
              </dsp:droplet>
            </c:when>
            <%-- no ATG Search installed --%>
            <c:otherwise>
              <dsp:a page="${finalUrl}" iclass="topCatLinks">
                <dsp:param name="categoryNavIds" value="${categoryNavIds}"/>
                <dsp:valueof param="topCategory.displayName">
                  <fmt:message key="common.categoryNameDefault" />
                </dsp:valueof>
              </dsp:a>
            </c:otherwise>
          </c:choose>
          <%-- Switch --%>

        </dsp:oparam>
        <%-- CatalogItemLink output end--%>
      </dsp:droplet>
      <%-- CatalogItemLink --%>

      <%-- Render the subcategories allowing style and javascript to
             handle displaying in place versus a flyout
         --%>
      <div class="atg_store_catSubNv">
        <dsp:getvalueof var="childCategories" param="topCategory.childCategories"/>
        <dsp:getvalueof id="size" value="${fn:length(childCategories)}" />

        <ul class="sub_category">
        <c:forEach var="el" items="${childCategories}" varStatus="status">
          <dsp:param name="el" value="${el}"/>
          <dsp:getvalueof id="count" value="${status.count}" />
          <li class="<crs:listClass count="${count}" size="${size}" selected="${selectedCategoryId == el.repositoryId}"/>">

          <c:set var="categoryNavIds" value="${categoryId}:${el.repositoryId}" />

          <%-- Check to see if url is empty --%>
          <dsp:getvalueof  var="templateUrl" param="el.template.url" />
          <c:choose>
            <c:when test="${not empty templateUrl}">
              <dsp:droplet name="CatalogItemLink">
                <dsp:param name="item" param="el" />
                <dsp:oparam name="output">
                  <dsp:getvalueof id="pageSubUrl" idtype="String" param="url" />
                  <%-- Filters faceted display by Sub-Category, if Search is installed,
                                                    otherwise, simply displays the sub-category selected --%>
                  <c:choose>
                    <c:when test="${isIndirectUrl}">
                      <dsp:a page="${pageSubUrl}">
                        <dsp:valueof param="el.displayName" />
                      </dsp:a>
                    </c:when>
                    <c:when test="${atgSearchInstalled == 'true'}">

                      <dsp:getvalueof id="subCategoryId" idtype="String" param="el.repositoryId" />

                      <%-- Retrieve ID of the Global Category refineElement and tie it to Category Navigation--%>
                      <dsp:droplet name="TargetingFirst">
                        <dsp:param name="howMany" value="1" />
                        <dsp:param name="targeter"
                                   bean="/atg/registry/RepositoryTargeters/RefinementRepository/GlobalCategoryFacet" />

                        <dsp:oparam name="output">
                          <dsp:setvalue param="catRefine" paramvalue="element"/>
                          <dsp:getvalueof id="refElemRepId" idtype="String"
                                          param="catRefine.repositoryId" />
                          <dsp:a page="${pageSubUrl}">
                            <dsp:param name="addFacet"
                                       value="${refElemRepId}:${subCategoryId}" />
                            <dsp:param name="categoryNavIds" value="${categoryNavIds}" />
                            <dsp:valueof param="el.displayName" />
                          </dsp:a>
                        </dsp:oparam>

                        <dsp:oparam name="empty">
                          <dsp:a page="${pageSubUrl}">
                            <dsp:param name="categoryNavIds" value="${categoryNavIds}"/>
                            <dsp:valueof param="el.displayName" />
                          </dsp:a>
                        </dsp:oparam>

                      </dsp:droplet>
                      <%-- TargetingFirst --%>
                    </c:when>

                    <c:otherwise>
                      <dsp:a page="${pageSubUrl}">
                        <dsp:param name="categoryNavIds" value="${categoryNavIds}"/>
                        <dsp:valueof param="el.displayName" />
                      </dsp:a>
                    </c:otherwise>

                  </c:choose>
                  <%-- Switch --%>

                </dsp:oparam>
              </dsp:droplet>
            </c:when>

            <c:otherwise>
              <dsp:valueof param="el.displayName" />
            </c:otherwise>

          </c:choose> <%-- End Is Empty Check  --%></li>
        </c:forEach>
        </ul>

        <%-- Renders related products for selected category --%>
        <dsp:getvalueof  var="relProducts" param="topCategory.relatedProducts" />
        <c:if  test="${not empty relProducts}">

          <ul class="atg_store_featureProducts">
            <dsp:droplet name="CatalogItemFilterDroplet">
              <dsp:param name="collection" param="topCategory.relatedProducts" />
              <dsp:oparam name="output">
                <li class="atg_store_featureProductsTitle">
                  <fmt:message key="navigation.featuredProducts" />
                </li>

                <dsp:getvalueof var="filteredCollection" param="filteredCollection"/>
                <%-- Displays only five featured products --%>
                <c:forEach var="e" items="${filteredCollection}" begin="0" end="4">
                  <dsp:param name="e" value="${e}" />
                  <c:if test="${not empty e}">
                    <li>
                      <dsp:include page="/browse/gadgets/productName.jsp">
                        <dsp:param name="product" param="e" />
                        <dsp:param name="categoryNavIds" value="${element.repositoryId}" />
                        <dsp:param name="categoryId" value="${element.repositoryId}" />
                        <dsp:param name="categoryNav" value="true" />
                        <dsp:param name="navLinkAction" value="push" />
                      </dsp:include>
                    </li>
                  </c:if>
                  <%-- End Is related product Empty --%>
                </c:forEach>
              <%-- End For Each Related Product --%>
            </dsp:oparam>

          </dsp:droplet>
        </ul>
        </c:if>
      </div>
    </li>
  </c:forEach>
  <%-- End For Each 'root' category --%>
  <li>
    <dsp:a page="/browse/whatsNew.jsp">
      <fmt:message key="navigation_caterory.newItems" />
    </dsp:a>
  </li>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/catalog.jsp#3 $$Change: 635969 $ --%>
