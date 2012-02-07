<dsp:page>
 
  <%-- This page displays all the item in a selected giftList.
          It takes the following parameter.
          -  giftlistId - the id of the giftlist to be viewed
          Optional Parameters
          -  start - set to the first index (1 based) to show on the page (defaults to 1)
          -  howMany - used for viewAll to pass in the total number of items in the list
          -  viewAll - set to true of the user wants to see all items on one page
          -  productId - in case we reach this page through productDetailWithPicker page
  --%>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistLookupDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Range"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />

  <div id="atg_store_giftListManage">

    <dsp:getvalueof id="productId" idtype="java.lang.String" param="productId"/>
    <dsp:getvalueof var="giftlistId" vartype="java.lang.String" param="giftlistId"/>
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

    <%-- general url to gift list home --%>
    <c:url value="giftListHome.jsp" var="giftListHomeUrl" scope="page">
      <c:param name="selpage">GIFT LISTS</c:param>
    </c:url>

    <%--this url is for delete action--%>
    <c:url var="path" value="../giftListEdit.jsp">
      <c:param name="selpage">GIFT LISTS</c:param>
    </c:url>
   
    <%--  page url for  viewAll action --%>
    <c:url var="pathViewAll" value="giftListEdit.jsp">
      <c:param name="giftlistId" value="${giftlistId}"/>
      <c:param name="howMany" value="${howMany}"/>
      <c:param name="viewAll" value="true"/>
      <c:param name="selpage" value="GIFT LISTS"/>
    </c:url>

    <%-- page url when viewAll not selected --%>
    <c:url var="pagePath" value="giftListEdit.jsp">
      <c:param name="giftlistId" value="${giftlistId}"/>
      <c:param name="start" value="${start}"/>
      <c:param name="selpage" value="GIFT LISTS"/>
    </c:url>
    
    <%--page url for error conditions--%>
    <c:url var="errorPath" value="giftListEdit.jsp">
      <c:param name="giftlistId" value="${giftlistId}"/>
      <c:param name="start" value="${start}"/>
      <c:param name="selpage" value="GIFT LISTS"/>
    </c:url>

    <!-- ************************* begin display gift list ************************* -->
    <%--to remove a product by calling RemoveItemFromGiftlist form handler--%>
    <dsp:include page="removeFromList.jsp"/>

    <fmt:message var="saveText" key="common.button.saveChanges" />
    <fmt:message var="saveTitle" key="common.button.saveChangesTitle" />
    <fmt:message var="cancelText" key="common.button.cancelText" />
    <fmt:message var="cancelTitle" key="common.button.cancelTitle" />
    <dsp:droplet name="GiftlistLookupDroplet">
      <dsp:param name="id" param="giftlistId"/>
      <dsp:oparam name="output">
        <dsp:setvalue paramvalue="element" param="giftlist"/>
        <%-- make sure it's the owner trying to look at the list --%>
        <dsp:droplet name="Compare">
          <dsp:param name="obj1" bean="Profile.id"/>
          <dsp:param name="obj2" param="giftlist.owner.id" />
          <dsp:oparam name="equal">
            
            <c:url value="giftListHome.jsp" var="giftListHomeUrl" scope="page">
			  <c:param name="selpage">GIFT LISTS</c:param>
		    </c:url>

            <div id="atg_store_giftList">
              <dsp:input bean="GiftlistFormHandler.giftlistId" type="hidden"   
                         paramvalue="giftlistId"/>
              <dsp:input bean="GiftlistFormHandler.updateGiftlistAndItemsSuccessURL"  
                              type="hidden" value="${giftListHomeUrl}"/> 

              <dsp:droplet name="/atg/dynamo/droplet/IsNull">
                <dsp:param name="value" param="viewAll"/>
                <dsp:oparam name="true">
                  <dsp:input bean="GiftlistFormHandler.updateGiftlistAndItemsErrorURL" 
                             type="hidden" value="${errorPath}"/>
                </dsp:oparam>
                <dsp:oparam name="false">
                  <dsp:input bean="GiftlistFormHandler.updateGiftlistAndItemsErrorURL" 
                             type="hidden" value="${errorPath}" />
                </dsp:oparam>
              </dsp:droplet>
               
              <c:choose>
                <c:when test="${!empty productId}">
                  <crs:continueShopping>
                    <dsp:input type="hidden" bean="GiftlistFormHandler.cancelURL"
                               value="${continueShoppingURL}"/>
                  </crs:continueShopping>
               </c:when>
               <c:otherwise>
                 <dsp:input bean="GiftlistFormHandler.cancelURL" type="hidden" 
                            value="${giftListHomeUrl}"/>
                </c:otherwise>
              </c:choose>

              <dsp:droplet name="Range">
                <dsp:param name="array" param="giftlist.giftlistItems"/>
                <dsp:param name="howMany" value="${howMany}"/>
                <dsp:param name="start" value="${start}"/>
                <dsp:oparam name="empty">
                  <crs:messageContainer titleKey="myaccount_giftListManage.noItemsInList"/>
                </dsp:oparam>

                <dsp:oparam name="outputStart">
                  <p><fmt:message var="tableSummary" key="myaccount_giftListManage.tableSummary"/></p>
                  <table summary="${tableSummary}" cellspacing="0" cellpadding="0" id="atg_store_cart">

                    <!--show paging links -->
                    <dsp:include page="/global/gadgets/giftAndWishListPagination.jsp">
                      <dsp:param name="itemList" param="giftlist.giftlistItems"/>
                      <dsp:param name="arraySplitSize" value="${pageSize}"/>
                      <dsp:param name="size" param="size"/>
                      <dsp:param name="start" value="${start}"/>
                      <dsp:param name="top" value="${true}"/>
                      <dsp:param name="giftlistId" param="giftlistId"/>
                      <c:if test="${!empty productId}">
                        <dsp:param name="productId" param="${productId}"/>  
                      </c:if>
                    </dsp:include>
                    <thead>
                      <tr>
                        <dsp:droplet name="SharingSitesDroplet">
                          <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
                          <dsp:param name="excludeInputSite" value="true"/>
                          <dsp:oparam name="output">
                            <th scope="col" class="site"><fmt:message key="common.site"/></th>
                            <c:set var="displaySiteIndicator" value="true"/>
                          </dsp:oparam>
                        </dsp:droplet>                          
                        <th scope="item" class="item"><fmt:message key="common.item"/></th>
                        <th scope="col"></th>
                        <th scope="price" class="price"><fmt:message key="common.price"/></th>
                        <th scope="quantity" class="quantity"><fmt:message key="myaccount_giftListManage.want"/></th>
                        <th scope="remain" class="remain"><fmt:message key="myaccount_giftListManage.need"/></th>
                        <th scope="col"></th>
                      </tr>
                    </thead>
                    <tbody>
                </dsp:oparam>

                <dsp:oparam name="output">
                  <dsp:setvalue param="giftlistitem" paramvalue="element"/>
                  <dsp:param name="count" param="count"/>
                  <dsp:param name="size" param="size"/>
                  <dsp:param name="index" param="index"/>
                  <%--to display the details about the product --%>
                  <dsp:droplet name="/atg/commerce/catalog/ProductLookup">
                    <dsp:param name="id" param="giftlistitem.productId"/>
                    <dsp:oparam name="output">
                      <dsp:include page="manageYourGiftListProductRow.jsp">
                        <dsp:param name="product" param="element"/>
                        <dsp:param name="path" value="${path}"/>
                        <dsp:param name="displaySiteIndicator" value="${displaySiteIndicator}"/>
                      </dsp:include>
                    </dsp:oparam>
                    <dsp:oparam name="wrongCatalog">
                      <%-- Include items from other sites that are shared with current site --%>
                      <dsp:include page="manageYourGiftListProductRow.jsp">
                        <dsp:param name="product" param="element"/>
                        <dsp:param name="path" value="${path}"/>
                        <dsp:param name="displaySiteIndicator" value="${displaySiteIndicator}"/>
                      </dsp:include>
                    </dsp:oparam>
                    <dsp:oparam name="wrongSite">
                      <%-- Include items from other sites that are shared with current site --%>
                      <dsp:include page="manageYourGiftListProductRow.jsp">
                        <dsp:param name="product" param="element"/>
                        <dsp:param name="path" value="${path}"/>
                        <dsp:param name="displaySiteIndicator" value="${displaySiteIndicator}"/>
                      </dsp:include>
                    </dsp:oparam>
                  </dsp:droplet>
                </dsp:oparam>

                <dsp:oparam name="outputEnd">
                    </tbody>
                  </table>
                  <dsp:getvalueof var="giftlistItems" vartype="java.lang.Object" param="giftlist.giftlistItems"/>
                  <c:forEach var="giftlistItem" items="${giftlistItems}">
                    <dsp:param name="giftlistItem" value="${giftlistItem}"/>
                    <input name="<dsp:valueof param="giftlistItem.id"/>" type="hidden" value="<dsp:valueof param="giftlistItem.quantityDesired"/>"/>
                  </c:forEach>
                  
                  <!--show paging links -->
                  <dsp:include page="/global/gadgets/giftAndWishListPagination.jsp">
                    <dsp:param name="itemList" param="giftlist.giftlistItems"/>
                    <dsp:param name="arraySplitSize" value="${pageSize}"/>
                    <dsp:param name="size" param="size"/>
                    <dsp:param name="start" value="${start}"/>
                    <dsp:param name="top" value="${false}"/>
                    <dsp:param name="giftlistId" param="giftlistId"/>
                    <c:if test="${!empty productId}">
                      <dsp:param name="productId" param="${productId}"/>  
                    </c:if>
                  </dsp:include>
                </dsp:oparam>
              </dsp:droplet> <%-- End Range Droplet --%>
            </div>
          </dsp:oparam>
        </dsp:droplet>
        
        <%-- action buttons --%>
        <fieldset class="atg_store_actionItems atg_store_formActions">
          <div class="atg_store_formActionItem">
          <span class="atg_store_basicButton">
            <dsp:input bean="GiftlistFormHandler.updateGiftlistAndItems" type="submit" title="${saveTitle}" 
                       value="${saveText}" name="atg_store_giftListUpdate" id="atg_store_giftListSubmit"/>
          </span>
          </div>
          <c:choose>
            <c:when test="${empty productId}">
              <div class="atg_store_formActionItem">
              <span class="atg_store_basicButton secondary">
                <dsp:input bean="GiftlistFormHandler.cancel" type="submit" title="${cancelTitle}" 
                           value="${cancelText}" id="atg_store_giftListCancel"/>
              </span>
              </div>
            </c:when>
            <c:otherwise>

              <fmt:message key="common.button.continueShoppingText" var="continueShopping"/>
              <span class="atg_store_basicButton secondary">
                <dsp:input bean="GiftlistFormHandler.cancel" type="submit" title="${cancelTitle}" 
                           value="${continueShopping}" id="atg_store_giftListCancel"/>
              </span>
            </c:otherwise>
          </c:choose>
        </fieldset>
      </dsp:oparam>
    </dsp:droplet>
  </div>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/giftListManage.jsp#1 $$Change: 633540 $--%>
