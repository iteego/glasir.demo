<dsp:page>

<%-- This page display the comparison of different products --%>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/collections/filter/ColorSorter"/>
  <dsp:importbean bean="/atg/store/collections/filter/SizeSorter"/>
  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>
  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Format"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />

  <crs:pageContainer divId="atg_store_productComparisonsIntro" titleKey=""
                     index="false" follow="false" bodyClass="atg_store_comparison">
    
  <c:url value="productComparisons.jsp" var="comparisonsUrl" scope="page">
    <c:param name="selpage">COMPARISONS</c:param>
  </c:url>  
    
  <div class="atg_store_nonCatHero"><h2 class="title"><fmt:message key="browse_productComparisons.title"/></h2></div>
    
    <dsp:getvalueof var="productListItems" bean="ProductList.items"/>
      
    <c:choose>
      <c:when test="${not empty productListItems}">
        <div id="atg_store_productComparisons">
          <fmt:message var="tableSummary" key="browse_productComparisons.tableSummary" />
          <fmt:message var="altText" key="browse_productComparisons.productPreviewAlt"/>
          
          <table summary="${tableSummary}">
            <dsp:getvalueof var="productItems" bean="ProductList.items"/>
                 

            <%-- Product images --%>

            <tr>
              <c:forEach var="element" items="${productItems}">
                <dsp:param name="element" value="${element}" />
                  <td class="image">
                    <dsp:include page="/browse/gadgets/productImgCart.jsp">
                      <dsp:param name="product" param="element.product" />
                      <dsp:param name="alt" value="${altText}" />
                      <dsp:param name="siteId" param="element.siteId"/>
                    </dsp:include>
                  </td>
              </c:forEach>
            </tr>
        
            <%-- Product names --%>

            <tr>
              <c:forEach var="element" items="${productItems}">
                <dsp:param name="element" value="${element}" />
                <td class="atg_store_comparisonsTitle">
                  <dsp:include page="/browse/gadgets/productName.jsp">
                    <dsp:param name="product" param="element.product" />
                    <dsp:param name="siteId" param="element.siteId"/>
                  </dsp:include>
                </td>
              </c:forEach>
            </tr>
            
            <%-- Prices --%>
                      
            <fmt:message var="headingPrices" key="common.price"/>
            <dsp:param name="heading" value="${headingPrices}${labelSep}"/>
          
            <tr>
              <c:forEach var="element" items="${productItems}">
                <dsp:param name="element" value="${element}" />
                <td class="atg_store_productPrice">
                  <dsp:include page="/global/gadgets/priceRange.jsp">
                    <dsp:param name="product" param="element.product" />
                  </dsp:include>
                </td>
              </c:forEach>
            </tr>
            
            
            <%-- Action buttons --%>

            <tr>        
              <c:forEach var="element" items="${productItems}">
              <dsp:param name="element" value="${element}" />
                <td class="atg_store_comparisonActions">
                  <%-- Check the size of the sku array to see what button to render --%>
                  <dsp:getvalueof var="childSKUs" param="element.product.childSKUs" />
                  <c:choose>
                    <c:when test="${fn:length(childSKUs) == 1}">
                      <%-- Size is one, show Add to Cart --%>
                      <dsp:include page="/browse/gadgets/productAddToCart.jsp">
                        <dsp:param name="siteId" param="element.siteId"/>
                        <dsp:param name="product" param="element.product"/>
                        <dsp:param name="sku" param="element.product.childSKUs[0]"/>
                        <dsp:param name="displayAvailability" value="true"/>
                      </dsp:include>
                    </c:when>
                    <c:otherwise>
                      <%-- Size is not one, show Get Details --%>
                      <dsp:getvalueof var="productLink" param="element.productLink" />
                      <c:if test="${not empty productLink}">
                        <%-- Product Template is set --%>
                        <dsp:a href="${productLink}" iclass="atg_store_basicButton">
                          <span><fmt:message key="common.viewDetails"/></span>
                        </dsp:a>
                      </c:if>
                    </c:otherwise>
                  </c:choose>

                  <dsp:droplet name="Format">
                    <dsp:param name="format" value="remove_{productId}" />
                    <dsp:param name="productId" param="element.product.repositoryId" />
                    <dsp:oparam name="output">
                      <dsp:form name="${param.message}"
                        action="${comparisonsUrl}" method="post"
                        formid="removeProduct">
                        <%-- Hidden Params --%>

                        <dsp:input bean="ProductListHandler.removeProductSuccessURL"
                          type="hidden" value="${comparisonsUrl}" />
                        <dsp:input bean="ProductListHandler.removeProductErrorURL"
                          type="hidden" value="${comparisonsUrl}" />
                        <dsp:input bean="ProductListHandler.productId"
                          paramvalue="element.product.repositoryId" type="hidden" />
                        <dsp:input bean="ProductListHandler.siteId"
                          paramvalue="element.siteId" type="hidden" />
                        <dsp:input bean="ProductListHandler.skuId" 
                          paramvalue="element.sku.repositoryId" type="hidden" />
                        <dsp:input bean="ProductListHandler.categoryId" 
                          paramvalue="element.category.repositoryId" type="hidden" />

                        <%-- Submit the form --%>
                        <fmt:message var="removeButtonText"
                          key="common.button.removeText" />
                         
                          <dsp:input bean="ProductListHandler.removeProduct"
                                type="submit"
                                value="${removeButtonText}" 
                                iclass="atg_store_textButton atg_store_compareRemove"/>
                       

                      </dsp:form>
                    </dsp:oparam>
                  </dsp:droplet>
                </td>
              </c:forEach>
            </tr>
            
            <%-- Site information --%>
            <tr>
             <c:forEach var="element" items="${productItems}">
                <dsp:param name="element" value="${element}" />
                <td class="atg_store_compareSite">
                <dsp:getvalueof var="currentSiteId" vartype="java.lang.String" bean="/atg/multisite/Site.id"/>
                <dsp:getvalueof var="elementSiteId" vartype="java.lang.String" param="element.siteId"/>
                <c:if test="${currentSiteId != elementSiteId}">
                  <dsp:include page="/global/gadgets/siteIndicator.jsp">
                    <dsp:param name="mode" value="name"/>              
                    <dsp:param name="siteId" value="${elementSiteId}"/>
                    <dsp:param name="product" value="${element.product}"/>
                  </dsp:include>
                </c:if>
                </td>
              </c:forEach>
                       
            </tr>
            <fmt:message var="labelSep" key="common.labelSeparator" />


            <%-- Display all properties --%>
            <dsp:include page="/browse/gadgets/productChildDisplay.jsp">
              <dsp:param name="properties" bean="/atg/commerce/catalog/CatalogTools.propertyToLabelMap"/>
            </dsp:include>


            <%-- Features --%>
            <fmt:message var="headingFeatures" key="common.features"/>
            <dsp:include page="/browse/gadgets/productFeatures.jsp">
              <dsp:param name="heading" value="${headingFeatures}${labelSep}"/>
              <dsp:param name="childProperty" value="features"/>
              <dsp:param name="displayProperty" value="displayName"/>
            </dsp:include>
          </table>
        </div>
        
        <%-- 'Remove All' button  --%>
        <div class="atg_store_formActions">
        <div id="atg_store_productComparisonsRemoveAll">
          <dsp:form name="removeall" action="${comparisonsUrl}" method="post" formid="removeAll">
            <fmt:message var="removeAllButtonText" key="common.button.removeAllText"/>
              <dsp:input bean="ProductListHandler.clearList" type="submit" value="${removeAllButtonText}" iclass="atg_store_textButton atg_store_compareRemove"/>
          </dsp:form>
          <crs:continueShopping>
             <div class="atg_store_formActions">
            <a class="atg_store_basicButton" href="${continueShoppingURL}">
              <span><fmt:message key="common.button.continueShoppingText"/></span>
            </a>
            </div>
          </crs:continueShopping>
        </div>
      </c:when>
        
      <c:otherwise>
        <crs:messageContainer 
          titleKey="browse_productComparison.productNotSelectedTitle" 
          messageKey="browse_productComparison.productNotSelectedMsg">
          <jsp:body>
            <crs:continueShopping>
              <div class="atg_store_formActions">
                <a class="atg_store_basicButton" href="${continueShoppingURL}">
                  <span><fmt:message key="common.button.continueShoppingText"/></span>
                </a>
              </div>
            </crs:continueShopping>
          </jsp:body>
        </crs:messageContainer>
      </c:otherwise>
    </c:choose>

  </div>
  </crs:pageContainer>


</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/productComparisons.jsp#1 $$Change: 633540 $--%>
