<%-- 
  This page takes the "giftListId" and uses it to display all the items in the list for various operations e.g
  adding to cart, deleting the item from list...
  
  Parameters - 
  - giftListId - Id of Gift List from which chopper plans to purchase gifts
         
  Optional parameters:
    viewAll - set to true of the user wants to see all items on one page
    start - set to the first index (1 based) to show on the page (defaults to 1)
    howMany - used for viewAll to pass in the total number of items in the list
--%>
  
<dsp:page>
  <crs:pageContainer divId="atg_store_giftListIntro"
                     titleKey=""
                     bodyClass="atg_store_pageGiftList">
  
    <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
    <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>      
    <dsp:importbean bean="/atg/commerce/gifts/GiftlistLookupDroplet"/>
    <dsp:importbean bean="/atg/dynamo/droplet/Range"/>
    <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />


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

    <dsp:getvalueof var="contextroot" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
    
    <div class="atg_store_nonCatHero">
      <h2 class="title"><fmt:message key="common.giftListTitle"/></h2>
    </div>
    
    <div id="atg_store_giftListShop">

      <!-- ************************* begin display gift list ************************* -->
      <dsp:include page="/checkout/gadgets/checkoutErrorMessages.jsp">
        <dsp:param name="formhandler" bean="CartFormHandler"/>
      </dsp:include>

      <%--Displaying the top message--%>
      <dsp:droplet name="GiftlistLookupDroplet">
        <dsp:param name="id" param="giftlistId"/>
        
        <dsp:oparam name="output">
          
          <dsp:setvalue param="giftlist" paramvalue="element"/>
          <div id="atg_store_giftListShopHeader">
          
            <dl>
              <%-- Gift List Title --%>
              <dt><dsp:valueof param="giftlist.eventName"/></dt>
              <%-- Gift List Owner --%>
              <dd>
                <span><dsp:valueof param="giftlist.owner.firstName"/></span>
                <span><dsp:valueof param="giftlist.owner.lastName"/></span>
              </dd>
              <%-- Gift List Type --%>
              <dd>
                <dsp:getvalueof var="eventType" param="giftlist.eventType"/>
                <c:set var="eventTypeResourceKey" value="${fn:replace(eventType, ' ', '')}"/>
                <c:set var="eventTypeResourceKey" value="giftlist.eventType${eventTypeResourceKey}"/>
                <fmt:message key="${eventTypeResourceKey}"/>
              </dd>
              <%-- Gift List Date --%>
              <dsp:getvalueof var="eventDate" vartype="java.util.Date" param="giftlist.eventDate"/>
              <dd><fmt:formatDate value="${eventDate}" dateStyle="short" /></dd>
            </dl>          
            <%-- Gift List Description, if it exists --%>
            <dsp:getvalueof var="listDescription" param="giftlist.description"/>
            <c:if test="${not empty listDescription}">
              <p class="atg_store_giftListDescription">
                <dsp:valueof param="giftlist.description"/>
              </p>
            </c:if>             
            <%-- Gift List Special Instructions, if it exists --%>
            <p class="atg_store_giftListSpecialInstructions"><dsp:valueof param="giftlist.instructions"/></p>
          </div>
          <dsp:getvalueof var="giftlistId" vartype="java.lang.Double" param="giftlistId"/>
          <c:choose>
            <c:when test="${empty param.viewAll}">
              <c:set var="errorPath" 
                     value="${contextroot}/giftlists/giftListShop.jsp?giftlistId=${giftlistId}&start=${start}"/>
            </c:when>
            <c:otherwise>
              <c:set var="errorPath"
                     value="${contextroot}/giftlists/giftListShop.jsp?giftlistId=${giftlistid}&howMany=${howMany}&viewAll=true"/>
            </c:otherwise>
          </c:choose>
  
            <dsp:droplet name="Range">
              <dsp:param name="array" param="giftlist.giftlistItems"/>
              <dsp:param name="howMany" value="${howMany}"/>
              <dsp:param name="start" value="${start}"/>
  
              <dsp:oparam name="empty">
                <crs:messageContainer titleKey="giftlist_giftListShop.noItemInList"/>
              </dsp:oparam>
  
              <dsp:oparam name="outputStart">
  
                <!--show paging links -->
                <dsp:include page="/global/gadgets/giftAndWishListPagination.jsp">
                  <dsp:param name="itemList" param="giftlist.giftlistItems"/>
                  <dsp:param name="arraySplitSize" value="${pageSize}"/>
                  <dsp:param name="size" param="size"/>
                  <dsp:param name="start" value="${start}"/>
                  <dsp:param name="top" value="${true}"/>
                  <dsp:param name="giftlistId" param="giftlistId"/>
                </dsp:include>
  
                <fmt:message var="productList" key="giftlist_giftListShop.productList"/>
                <table summary="${productList}" id="atg_store_cart" cellspacing="0" cellpadding="0">
                  <thead>
                    <tr>
                      <dsp:droplet name="SharingSitesDroplet">
                        <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
                        <dsp:param name="excludeInputSite" value="true"/>
                        <dsp:oparam name="output">
                          <th class="site"><fmt:message key="common.site"/></th>
                          <c:set var="displaySiteIndicator" value="true"/>
                        </dsp:oparam>
                      </dsp:droplet>
                      <th class="item" colspan="2"><fmt:message key="common.item"/></th>
                      <th class="price" class="numerical"><fmt:message key="common.price"/></th>
                      <th class="remain"><fmt:message key="giftlist_giftListShop.wants"/></th>
                      <th class="requstd" class="numerical"><fmt:message key="giftlist_giftListShop.needs"/></th>
                      <th class="quantity"><fmt:message key="common.qty"/></th>                      
                    </tr>
                  </thead>
                  <tbody>
              </dsp:oparam>

              <dsp:oparam name="output">
                <dsp:setvalue param="giftlistitem" paramvalue="element"/>
                <dsp:param name="count" param="count"/>
                <dsp:param name="size" param="size"/>
                <dsp:droplet name="ProductLookup">
                  <dsp:param name="id" param="giftlistitem.productId"/>
                  <dsp:oparam name="output">
                    <dsp:include page="gadgets/giftListShopProductRow.jsp">
                      <dsp:param name="displaySiteIndicator" value="${displaySiteIndicator}"/>
                      <dsp:param name="errorPath" value="${errorPath}"/>
                      <dsp:param name="product" param="element"/>
                    </dsp:include>                      
                  </dsp:oparam>
                  <dsp:oparam name="wrongCatalog">
                    <%-- Include items from other sites that are shared with current site --%>
                    <dsp:include page="gadgets/giftListShopProductRow.jsp">
                      <dsp:param name="displaySiteIndicator" value="${displaySiteIndicator}"/>
                      <dsp:param name="errorPath" value="${errorPath}"/>
                      <dsp:param name="product" param="element"/>
                    </dsp:include>                                            
                  </dsp:oparam>
                  <dsp:oparam name="wrongSite">
                   <%-- Include items from other sites that are shared with current site --%>
                    <dsp:include page="gadgets/giftListShopProductRow.jsp">
                      <dsp:param name="displaySiteIndicator" value="${displaySiteIndicator}"/>
                      <dsp:param name="errorPath" value="${errorPath}"/>
                      <dsp:param name="product" param="element"/>
                    </dsp:include>                                            
                  </dsp:oparam>
                </dsp:droplet><%-- End of productLookup  --%>
              </dsp:oparam>

              <dsp:oparam name="outputEnd">
                  </tbody>
                </table>
                <div class="atg_store_formActions">
                <fieldset class="atg_store_actionItems">
                  <div class="atg_store_formControls">
                    <dsp:a href="${contextroot}/giftlists/giftListSearch.jsp" iclass="atg_store_basicButton secondary">
                       <span><fmt:message key="giftlist_giftListShop.findAnotherGiftList"/></span>
                    </dsp:a>
                  </div>
                </fieldset>
                </div>
                <!--show paging links -->
                <dsp:include page="/global/gadgets/giftAndWishListPagination.jsp">
                  <dsp:param name="itemList" param="giftlist.giftlistItems"/>
                  <dsp:param name="arraySplitSize" value="${pageSize}"/>
                  <dsp:param name="size" param="size"/>
                  <dsp:param name="start" value="${start}"/>
                  <dsp:param name="top" value="${false}"/>
                  <dsp:param name="giftlistId" param="giftlistId"/>
                </dsp:include>
              </dsp:oparam>
            </dsp:droplet><%-- End Range droplet indices --%>
          
        </dsp:oparam>
      </dsp:droplet>
    </div>

  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/giftlists/giftListShop.jsp#3 $$Change: 635969 $ --%>