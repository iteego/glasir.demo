<dsp:page>

  <%--
  This page expects following parameters - 
    category - category repository item for which featured products are to be displayed
    trailSize - size of the facet trail traversed so far
  --%>

  <dsp:importbean var="originatingRequest" bean="/OriginatingRequest" />
  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet" />

  <%-- Check for trailSize parameter. If trailSize=0, render featured products, otherwise not. --%>
  <dsp:getvalueof var="trailSize" param="trailSize" />
  <c:if test="${trailSize == 0}">


    <dsp:droplet name="CatalogItemFilterDroplet">
      <dsp:param name="collection" param="category.relatedProducts" />

      <%-- Work with filtered collection --%>
      <dsp:oparam name="output">
        <div id="ajaxContainer">
        <div divId="ajaxRefreshableContent">
        <div id="featured_products">
          <h2><fmt:message  key="browse_featuredProducts.featuredItemTitle" /></h2>
  
          <%-- Display Related Products if you got 'em --%>
          <div id="atg_store_prodList">
            
            <%-- Calculate available featured products. 
               Display only 4 featured products.
           --%>
           <dsp:getvalueof var="filteredItems" param="filteredCollection" /> 
           <c:set var="numberOfProducts" value="4" />
           <dsp:getvalueof  var="size" value="${fn:length(filteredItems)}" />
           <c:if test="${size < numberOfProducts}">
             <c:set var="numberOfProducts" value="${size}" />
           </c:if>
  
           <ul class="atg_store_product">
              <%-- thumbnail image --%>
              
                <c:forEach var="product" items="${filteredItems}" begin="0" end="${numberOfProducts}" varStatus="status">
                  <dsp:getvalueof var="index" value="${status.index}"/>
                  <dsp:getvalueof var="count" value="${status.count}"/>
                  <dsp:getvalueof var="additionalClasses" vartype="java.lang.String" 
                                  value="${(count % numberOfProducts) == 1 ? 'prodListBegin' : ((count % numberOfProducts) == 0 ? 'prodListEnd':'')}"/>
                                  
                  <li class="<crs:listClass count="${count}" size="${size}" selected="false"/>${empty additionalClasses ? '' : ' '}${additionalClasses}">
                     
                    <dsp:include page="/global/gadgets/productListRangeRow.jsp">
                      <dsp:param name="categoryId" param="categoryId"/>
                      <dsp:param name="product" value="${product}" />
                      <dsp:param name="categoryNav" value="false" />
                    </dsp:include>
                  </li> 
                </c:forEach>
          </div>
        </div>
          </div>
          <div name="transparentLayer" id="transparentLayer"></div>
          <div name="ajaxSpinner" id="ajaxSpinner"></div>
        </div>
      </dsp:oparam>
    </dsp:droplet>

  </c:if>
  <%-- End Switch Droplet --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/featuredProducts.jsp#2 $$Change: 635969 $--%>
