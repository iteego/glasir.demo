<dsp:page>

  <%-- This page displays the items on the shoppers wish list, and provides options to delete/purchase them --%>

  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Range"/>
  <dsp:importbean bean="/atg/commerce/collections/filter/droplet/GiftlistSiteFilterDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />

  <%-- Deletes an item from the Wish List if requested --%>
  <dsp:include page="removeFromList.jsp"/>

  <dsp:setvalue beanvalue="Profile.wishlist" param="wishlist"/>
  <dsp:setvalue paramvalue="wishlist.giftlistItems" param="items"/>
  <dsp:setvalue paramvalue="wishlist.id" param="giftlistId"/>
  
  <%-- Set the defaults for page navigation --%>
  <dsp:getvalueof var="pageSize" vartype="java.lang.Object" bean="/atg/multisite/SiteContext.site.defaultPageSize"/>
  <dsp:getvalueof id="howMany" param="howMany"/>
  <c:if test="${empty howMany}">
    <c:set var="howMany" value="${pageSize}"/>
  </c:if>
  <dsp:getvalueof id="start" param="start"/>
  <c:if test="${empty start}">
    <c:set var="start" value="1"/>
  </c:if>

    
  <fmt:message var="tableSummary" key="myaccount_myWishList.listTableSummary" />

        <dsp:droplet name="GiftlistSiteFilterDroplet">
          <dsp:param name="collection" param="items"/>
          <dsp:oparam name="empty">
            <crs:messageContainer titleKey="myaccount_myWishList.noFavorites">
              <jsp:body>
                <dsp:include page="myWishListContinue.jsp"/>
              </jsp:body>
            </crs:messageContainer>
          </dsp:oparam>
          <dsp:oparam name="output">
            <dsp:setvalue param="filteredItems" paramvalue="filteredCollection" />

            <dsp:droplet name="Range">
              <dsp:param name="array" param="filteredItems"/>
              <dsp:param name="howMany" value="${howMany}"/>
              <dsp:param name="start" value="${start}"/>
    
              <dsp:oparam name="outputStart">
    
                <!--show top pagination links -->
                <dsp:include page="/global/gadgets/giftAndWishListPagination.jsp">
                  <dsp:param name="itemList" param="filteredItems"/>
                  <dsp:param name="arraySplitSize" value="${pageSize}"/>
                  <dsp:param name="size" param="size"/>
                  <dsp:param name="start" value="${start}"/>
                  <dsp:param name="top" value="${true}"/>
                  <dsp:param name="giftlistId" param="giftlistId"/>
                </dsp:include>
    
                <table valign="top" id="atg_store_cart" class="atg_store_myWishList" summary="${tableSummary}" cellspacing="0" cellpadding="0">
                  <thead>
                    <tr>
                      <dsp:droplet name="SharingSitesDroplet">
                        <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
                        <dsp:param name="excludeInputSite" value="true"/>
                        <dsp:oparam name="output">
                          <th>
                            <fmt:message key="common.site"/>
                          </th>
                        </dsp:oparam>
                      </dsp:droplet>                         
                      
                      <th scope="col" colspan="2" class="item">
                        <fmt:message key="common.item"/>
                      </th>
                      <th scope="col" class="price">
                        <fmt:message key="common.price"/>
                      </th>
                      <th scope="col" class="quantity">
                        <fmt:message key="common.qty"/>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                </dsp:oparam>
                <dsp:oparam name="output">
                  <dsp:setvalue param="giftItem" paramvalue="element"/>
                  <dsp:getvalueof id="count" param="count"/>
                  <dsp:getvalueof id="size" param="size"/>
      
                  <dsp:droplet name="/atg/commerce/catalog/ProductLookup">
                    <dsp:param name="id" param="giftItem.productId"/>
                    <dsp:oparam name="output">
                      <tr class="<crs:listClass count="${count}" size="${size}" selected="false"/>">
                        <%-- Render a row-entry for each Gift List item --%>
                        <dsp:include page="wishListRow.jsp">
                          <dsp:param name="product" param="element"/>
                        </dsp:include>
                      </tr>
                    </dsp:oparam>
                    <dsp:oparam name="wrongCatalog">
                      <%-- Include items from other sites that are shared with current site --%>
                      <tr class="<crs:listClass count="${count}" size="${size}" selected="false"/>">
                        <%-- Render a row-entry for each Gift List item --%>
                        <dsp:include page="wishListRow.jsp">
                          <dsp:param name="product" param="element"/>
                        </dsp:include>
                      </tr>
                    </dsp:oparam>
                    <dsp:oparam name="wrongSite">
                      <%-- Include items from other sites that are shared with current site --%>
                      <tr class="<crs:listClass count="${count}" size="${size}" selected="false"/>">
                        <%-- Render a row-entry for each Gift List item --%>
                        <dsp:include page="wishListRow.jsp">
                          <dsp:param name="product" param="element"/>
                        </dsp:include>
                      </tr>
                    </dsp:oparam>
                  </dsp:droplet> <%-- ProducLookup --%>
      
                </dsp:oparam>
                <dsp:oparam name="outputEnd">
                  </tbody>
                </table>
    
                <!--show bottom pagination links -->
                <dsp:include page="/global/gadgets/giftAndWishListPagination.jsp">
                  <dsp:param name="itemList" param="filteredItems"/>
                  <dsp:param name="arraySplitSize" value="${pageSize}"/>
                  <dsp:param name="size" param="size"/>
                  <dsp:param name="start" value="${start}"/>
                  <dsp:param name="top" value="${false}"/>
                  <dsp:param name="giftlistId" param="giftlistId"/>
                </dsp:include>
                <dsp:include page="myWishListContinue.jsp"/>
              </dsp:oparam>         
            </dsp:droplet>
          </dsp:oparam>
        </dsp:droplet>


</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/myWishList.jsp#2 $$Change: 635969 $--%>
