<%--
  This page renders links to child categories pages for selected category.  
--%>
<dsp:page>
  <dsp:importbean bean="/atg/targeting/TargetingFirst"/>
  <dsp:importbean bean="/atg/repository/seo/CatalogItemLink"/>
      
  <dsp:getvalueof var="atgSearchInstalled" bean="/atg/store/StoreConfiguration.atgSearchInstalled"/>
  
  <c:if test="${atgSearchInstalled == 'true'}">
    
    <dsp:droplet name="TargetingFirst">
      <dsp:param name="howMany" value="1"/>
      <dsp:param name="targeter" bean="/atg/registry/RepositoryTargeters/RefinementRepository/GlobalCategoryFacet"/>

      <dsp:oparam name="output">
        <dsp:getvalueof id="refElemRepId" idtype="String" param="element.repositoryId"/>
      </dsp:oparam>
    </dsp:droplet>
  </c:if>                                           

  <div id="atg_store_categories">
    <dsp:getvalueof var="navHistory" vartype="java.util.Collection" scope="page" bean="/atg/commerce/catalog/CatalogNavHistory.navHistory"/>
    <dsp:getvalueof var="childCategories" vartype="java.util.Collection" scope="page" param="category.childCategories"/>
    
    <%-- Link to grand-parent is displayed for non top-level leaf categories --%>
    <c:if test="${fn:length(navHistory) > 2 && empty childCategories}">
      <h3 class="atg_store_categoryParent">
        <dsp:include page="linkToNavItem.jsp">
          <dsp:param name="itemIndex" value="${fn:length(navHistory) - 2}"/>
        </dsp:include>
      </h3>
    </c:if>
    <%-- Link to a parent is always displayed --%>
    <h3 class="atg_store_categoryCurrent${empty childCategories ? 'Leaf' : ''}">
      <dsp:include page="linkToNavItem.jsp">
        <dsp:param name="itemIndex" value="${fn:length(navHistory) - 1}"/>
      </dsp:include>
    </h3>

    <div class="atg_store_facetsGroup_options_catsub">
      <%-- Iterate over the list of subcategories and create link
           for every subcategory.
      --%>
      
      <ul>
        <c:forEach var="childCategory" items="${childCategories}" varStatus="childCategoriesStatus">
          <dsp:param name="childCategory" value="${childCategory}"/>
          <dsp:getvalueof var="selectedCategoryId" param="category.repositoryId" />
          <dsp:getvalueof var="childCategoryId" param="childCategory.repositoryId"/>
          <dsp:getvalueof id="q_docSort" param="q_docSort"/>
          <dsp:getvalueof id="addFacet" value="${refElemRepId}:${childCategoryId}"/>
          
          <dsp:droplet name="CatalogItemLink">
            <dsp:param name="item" param="childCategory"/>
            <dsp:oparam name="output">
              <dsp:getvalueof id="url" idtype="String" param="url"/>
              <%-- Determine if the generated URL is indirect URL for search spiders by 
                   checking the browser type. --%>
              <dsp:droplet name="/atg/repository/seo/BrowserTyperDroplet">
                <dsp:oparam name="output">
                  <dsp:getvalueof var="browserType" param="browserType"/>
                  <c:set var="isIndirectUrl" value="${browserType eq 'robot'}"/>
                </dsp:oparam>
              </dsp:droplet>
              
              <li  onmouseover="this.className='selected';" onmouseout="this.className='';">

                <%-- Create link for subcategory --%>
                <dsp:a page="${url}">
                  <c:if test="${not isIndirectUrl}">
                    <dsp:param name="q_docSort" param="q_docSort"/>
                    <dsp:param name="addFacet" value="${refElemRepId}:${childCategoryId}"/>
                  </c:if>
                  <dsp:valueof param="childCategory.displayName"/>
                </dsp:a>
              </li>
            </dsp:oparam>
          </dsp:droplet><%-- CatalogItemLink --%>
        </c:forEach>
      </ul>
    </div>
  </div>  

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/categoryPanel.jsp#1 $$Change: 633540 $ --%>