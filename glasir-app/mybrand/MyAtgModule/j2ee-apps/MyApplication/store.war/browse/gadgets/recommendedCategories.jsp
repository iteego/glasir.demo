<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object being displayed
  --%>
  <dsp:getvalueof id="product" param="product"/>

  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet"/>
  <dsp:importbean bean="/atg/commerce/catalog/CategoriesForProductGroup"/>

  <%-- Find any categories that include this product from a content group --%>
  <dsp:droplet name="CategoriesForProductGroup">
    <dsp:param name="product" param="product"/>
    <dsp:oparam name="output">
      <%-- Filter out any categories in other catalogs --%>
      <dsp:droplet name="CatalogItemFilterDroplet">
        <dsp:param name="collection" param="associatedCategories"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="filteredCollection" vartype="java.lang.Object" param="filteredCollection"/>
          <c:if test="${not empty filteredCollection}">
            <dsp:getvalueof id="size" value="${fn:length(filteredCollection)}"/>
            <div id="atg_store_recommendedCategories">
              <h3>
                <fmt:message key="browse_recommendedCategories.recommend"/>
              </h3>
              <ul>
                <c:forEach var="filteredItem" items="${filteredCollection}" varStatus="filteredItemStatus">
                  <dsp:getvalueof id="count" value="${filteredItemStatus.count}"/>
                  <dsp:param name="cat" value="${filteredItem}"/>
                  <c:set var="classString">
                    <crs:listClass count="${count}" size="${size}" selected="false"/>
                  </c:set>
                  <%-- Check to see if category url is empty --%>
                  <dsp:getvalueof var="templateUrl" param="cat.template.url"/>
                  <c:choose>
                    <c:when test="${not empty templateUrl}">
                      <dsp:droplet name="/atg/repository/seo/CatalogItemLink">
                        <dsp:param name="item" param="cat"/>
                        <dsp:oparam name="output">
                          <fmt:message var="linkTitle" key="browse_recommendedCategories.categoryLinkTitle"/>
                          <li class="<crs:listClass count="${count}" size="${size}" selected="false"/>">
                            <dsp:a href="${param.url}" title="${linkTitle}">
                              <dsp:valueof param="cat.displayName"/>
                            </dsp:a>
                          </li>
                        </dsp:oparam> <%-- End oparam output --%>
                      </dsp:droplet> <%-- End CatalogItemLink droplet --%>
                    </c:when>
                    <c:otherwise>
                      <li class="<crs:listClass count="${count}" size="${size}" selected="false"/> disabled">
                        <dsp:valueof param="cat.displayName"/>
                      </li>
                    </c:otherwise>
                  </c:choose>
                </c:forEach><%-- End For Each Category --%>
              </ul>
            </div>
          </c:if>
        </dsp:oparam>
      </dsp:droplet><%-- End filter out categories --%>
    </dsp:oparam>
  </dsp:droplet><%-- End Categories for product group --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/recommendedCategories.jsp#2 $$Change: 635969 $--%>
