<dsp:page>
  <%-- This page expects the following input parameters
       product - the product object being displayed
  --%>
  <dsp:getvalueof id="product" param="product" />

  <dsp:importbean  bean="/atg/commerce/collections/filter/droplet/ExcludeItemsInCartFilterDroplet" />
  <dsp:importbean bean="/atg/dynamo/droplet/Compare" />

    <dsp:droplet name="ExcludeItemsInCartFilterDroplet">
      <dsp:param name="collection" param="product.relatedProducts" />
      
      <dsp:oparam name="output">
        <%-- Filter out products with wrong site IDs.
             We will display related products from shared sites only. --%>
        <dsp:droplet name="/atg/commerce/collections/filter/droplet/CartSharingFilterDroplet">
          <dsp:param name="collection" param="filteredCollection"/>
          <dsp:oparam name="output">
            <dsp:getvalueof var="filteredCollection" param="filteredCollection"/>
            <c:if test="${not empty filteredCollection}">
              <div id="atg_store_recommendedProductsDetail">
                <h3>
                  <fmt:message key="browse_recommendedProducts.ourDesignersSuggest" /><fmt:message key="common.labelSeparator" />
                </h3>
                <div class="atg_store_product_recommendations" id="atg_store_recommendAddToCart">
                  <ul class="atg_store_product">
                    <dsp:getvalueof var="size" value="${fn:length(filteredCollection)}"/>
                    <%-- Only show five of them --%>
                    <c:forEach var="relatedProduct" items="${filteredCollection}" varStatus="status" begin="0" end="4">
                      <dsp:param name="relatedProduct" value="${relatedProduct}"/>
                      <dsp:getvalueof var="templateUrl" param="relatedProduct.template.url" />
                      <c:if test="${not empty templateUrl}">
                        <fmt:message var="linkTitle" key="browse_recommendedProducts.productLinkTitle" />
                        <li class="<crs:listClass count="${status.count}" size="${ size < 5 ? size : 5}" selected="false"/>">
                          <dsp:include page="/promo/gadgets/promotionalItemRenderer.jsp">
                            <dsp:param name="product" param="relatedProduct" />
                          </dsp:include>
                        </li>
                      </c:if> <%-- End is template empty --%>
                    </c:forEach><%-- End For Each related product --%>
                  </ul>
                </div>
              </div>
            </c:if>
          </dsp:oparam>  
        </dsp:droplet>
      </dsp:oparam>
    </dsp:droplet><%-- End ExcludeItemsInCartFilterDroplet --%>  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/recommendedProducts.jsp#3 $$Change: 635969 $ --%>
