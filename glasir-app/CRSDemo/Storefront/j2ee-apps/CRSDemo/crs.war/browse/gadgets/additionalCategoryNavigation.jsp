<dsp:page>

<%-- This page expects the following parameters 
     category - category repository item being displayed.
--%>

  <dsp:importbean bean="/atg/dynamo/droplet/Cache"/>
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale" var="requestLocale"/>
  <dsp:importbean bean="/atg/repository/seo/BrowserTyperDroplet"/>
  <dsp:importbean bean="/atg/targeting/TargetingRandom"/>

  <dsp:param name="bestSellerCatName" param="category.parentCategory.displayName" />

  <div id="atg_store_recommendedProductsListing">

    <dsp:droplet name="BrowserTyperDroplet">
      <dsp:oparam name="output">

        <dsp:getvalueof var="categoryId" vartype="java.lang.String" param="category.repositoryId"/>

        <dsp:droplet name="Cache">
          <dsp:param name="key" value="bp_${categoryId}_${param.browserType}_${requestLocale.locale}"/>
          <dsp:oparam name="output">
          
            <%-- Display the category best sellers --%>
            <dsp:getvalueof var="bestSellers" vartype="java.lang.Object" param="category.bestSellers"/>
            <c:if test="${not empty bestSellers}">
              <!-- ************************* begin category bestsellers ************************* --> 
              <h3>
                <dsp:valueof param="bestSellerCatName"/> <fmt:message key="browse_rtNavCatCommon.bestSellers"/>
              </h3>
              <dl>
                <dsp:getvalueof id="size" value="${fn:length(bestSellers)}"/>
                <c:forEach var="bestSeller" items="${bestSellers}" varStatus="bestSellerStatus">
                  <dsp:getvalueof id="count" value="${bestSellerStatus.count}"/>
                  <dsp:getvalueof id="index" value="${bestSellerStatus.index}"/>
                  <dsp:param name="relatedProduct" value="${bestSeller}"/>
                  <c:set var="classString">
                    <crs:listClass count="${count}" size="${size}" selected="false"/>
                  </c:set>

                  <dsp:getvalueof var="relatedProductTemplateUrl" param="relatedProduct.template.url"/>
                  <c:choose>
                    <c:when test="${not empty relatedProductTemplateUrl}">

                      <%-- New Implementation for SEO --%>
                      <%-- Renders the links to common categories related to the
                      current sub-category on the sub-category product range page, 
                      in the right navigation panel, depending on the userAgent
                      visiting the site --%>
                      <dsp:droplet name="/atg/repository/seo/CatalogItemLink">
                        <dsp:param name="item" param="relatedProduct"/>
                        <dsp:oparam name="output">
                          <dsp:getvalueof id="finalUrl" idtype="String" param="url"/>

                          <dt class="${classString} active">
                            <dsp:a page="${finalUrl}">
                              <dsp:valueof param="relatedProduct.displayName">
                                <fmt:message key="common.productNameDefault"/>
                              </dsp:valueof>
                            </dsp:a>
                          </dt>

                          <dd class="${classString} active">
                            <dsp:include page="productThumbImg.jsp">
                              <dsp:param name="product" param="relatedProduct"/>
                            </dsp:include>
                          </dd>
                        </dsp:oparam> <%-- End oparam output --%>
                      </dsp:droplet> <%-- End CatalogItemLink droplet --%>
                      <%-- SEO --%>

                    </c:when>
                    <c:otherwise>
                      <dt class="${classString} disabled">
                        <dsp:valueof param="relatedProduct.displayName">
                          <fmt:message key="common.productNameDefault"/>
                        </dsp:valueof>
                      </dt>

                      <dd class="${classString} disabled">
                        <dsp:include page="productThumbImg.jsp">
                          <dsp:param name="product" param="relatedProduct"/>
                        </dsp:include>
                      </dd>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </dl>
              <!-- ************************* end category bestsellers ************************* -->
            </c:if>

            <%-- Show Category Promotion if it exists --%>
            <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="category.categoryPromo.template.url"/>
            <c:if test="${not empty pageurl}">
              <!-- ************************* begin category promotion ************************* -->
              <dsp:include page="${pageurl}">
                <dsp:param name="promotionalContent" param="category.categoryPromo"/>
              </dsp:include>
              <!-- ************************* end category promotion ************************* -->
            </c:if>
          </dsp:oparam>
        </dsp:droplet><%-- End Cache Droplet --%>
      </dsp:oparam>
    </dsp:droplet><%-- End BrowserTyperDroplet --%>

  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/additionalCategoryNavigation.jsp#2 $$Change: 635969 $--%>
