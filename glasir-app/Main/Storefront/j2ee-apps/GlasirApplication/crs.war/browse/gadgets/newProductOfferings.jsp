
<dsp:page>

  <%-- This page renders links to main-catgeory-specific anchors on the Whats New Page --%>

  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet"/>
  <dsp:importbean bean="/atg/store/droplet/NewItemsRQL"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <div id="atg_store_newProductOfferings">
    <h3>
      <fmt:message key="browse_whatsNew.newProductOfferings"/>
    </h3>
    <ul>
      
      <dsp:getvalueof var="childCategories" bean="Profile.catalog.rootNavigationCategory.childCategories"/>
      <c:choose>
        <c:when test="${not empty childCategories}" >
          <c:forEach var="cat" items="${childCategories}" varStatus="childCategoriesStatus">  
            <dsp:param name="cat" value="${cat}"/>
            <dsp:droplet name="NewItemsRQL">
              <dsp:param name="numRQLParams" value="1"/>
              <dsp:param name="param0" param="cat.repositoryId"/>
              <dsp:oparam name="output">
                <dsp:droplet name="CatalogItemFilterDroplet">
                  <dsp:param name="collection" param="items"/>
                  <dsp:oparam name="output">
                    <dsp:getvalueof var="filteredItemSize" value="${fn:length(filteredCollection)}"/>
                    <c:if test="${filteredItemSize != '0'}">
                      <!-- repeat classes used: first last odd active -->
                      <dsp:getvalueof id="size" value="${fn:length(childCategories)}"/>
                      <dsp:getvalueof id="count" value="${childCategoriesStatus.count}"/>
                      <dsp:getvalueof id="index" value="${childCategoriesStatus.index}"/>
                      <li class="<crs:listClass count="${count}" size="${size}" selected="${index == currentSelection}"/>">
                        <dsp:getvalueof var="repositoryId" vartype="java.lang.String"
                          param="cat.repositoryId" />
                        <dsp:getvalueof var="displayName" vartype="java.lang.String"
                          param="cat.displayName" />
                        <c:set var="displayName"><c:out value="${displayName}" escapeXml="true"/></c:set>
                        <a href="#anchor<c:out value="${repositoryId}" />" title="${displayName}">
                          <c:out value="${displayName}" >
                            <fmt:message key="common.categoryNameDefault"/>
                          </c:out>
                        </a>
                      </li>
                    </c:if><%-- End check to see if any items remain --%>
                  </dsp:oparam>
                </dsp:droplet><%-- End filtering products by newness --%>
              </dsp:oparam>
            </dsp:droplet><%-- End fetching all the descendants for this cateogry --%>
          </c:forEach>
        </c:when> 
        <c:otherwise>
          <fmt:message key="browse_whatsNew.noCategoriesDefault"/>
        </c:otherwise>
      </c:choose>
    </ul>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/newProductOfferings.jsp#2 $$Change: 635969 $--%>