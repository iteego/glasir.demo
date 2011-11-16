<dsp:page>

  <dsp:importbean bean="/atg/commerce/order/OrderLookup"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/commerce/order/OrderLookup"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Range"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%-- Set the defaults for page navigation --%>
  <dsp:getvalueof var="pageSize" vartype="java.lang.Object" bean="/atg/multisite/SiteContext.site.defaultPageSize"/>
  <dsp:getvalueof id="howMany" param="howMany"/>
  <dsp:getvalueof id="start" param="start"/>
  <dsp:getvalueof id="viewAll" param="viewAll"/>
  <c:if test="${empty start && !viewAll}">
    <c:set var="start" value="1"/>
  </c:if>

  <c:if test="${empty howMany}">
    <c:set var="howMany" value="${pageSize}"/>
  </c:if>

  <%-- Set the display size for the array subsets --%>
  <dsp:setvalue param="arraySplitSize"  beanvalue="/atg/multisite/SiteContext.site.defaultPageSize"/>

    <dsp:droplet name="OrderLookup">
      <dsp:param name="userId" bean="Profile.id"/>
      <dsp:param name="sortBy" value="submittedDate"/>
      <dsp:param name="state" value="closed"/>
      <dsp:getvalueof id="result" param="result"/>
      <dsp:param name="numOrders" value="-1"/>
      <dsp:oparam name="output">

        <dsp:droplet name="Range">
          <dsp:param name="array" param="result"/>
          <dsp:param name="howMany" value="${howMany}"/>
          <dsp:oparam name="outputStart">
            <fmt:message var="tableSummary" key="myaccount_myOrders.tableSummary" />
            <table class="atg_store_myOrdersTable atg_store_dataTable" border="0" summary="${tableSummary}" cellspacing="0" cellpadding="0">
              <dsp:include page="/global/gadgets/pagination.jsp">
                <dsp:param name="itemList" param="result"/>
                <dsp:param name="arraySplitSize" value="${pageSize}"/>
                <dsp:param name="size" param="size"/>
                <dsp:param name="start" value="${start}"/>
                <dsp:param name="top" value="${true}"/>
              </dsp:include>
 

                <thead>
                  <tr>
                  <th class="site">
                    <fmt:message key="common.site"/>
                  </th>
                  <th scope="col">
                    <fmt:message key="myaccount_myOrders.orderNumber"/>
                  </th>
                  <th>
                    <fmt:message key="common.items"/>
                  </th>
                   <th scope="col">
                      <fmt:message key="common.orderPlaced"/>
                   </th>
                   <th scope="col">
                     <fmt:message key="common.status"/>
                   </th>
                    <th scope="col">
                      
                    </th>
                  </tr>
                </thead>

              <tbody>
            </dsp:oparam>
            <dsp:oparam name="output">
              <dsp:setvalue param="order" paramvalue="element"/>
                
              <dsp:getvalueof id="count" param="count"/>
              <dsp:getvalueof id="size" param="size"/>
              <c:set var="counterloop" value="${counterloop+1}" />
              <c:set var="bgcolor" value="white" />
              <c:set var="alt" value="0" />
              <c:if test="${counterloop % 2 == 0}">
                <c:set var="bgcolor" value="#F2F9D0" />
                <c:set var="alt" value="1" />
              </c:if>
              <tr class="<crs:listClass count="${count}" size="${size}" selected="false"/>">
                
                <td class="site">
                  <dsp:include page="/global/gadgets/siteIndicator.jsp">
                    <dsp:param name="mode" value="icon"/>              
                    <dsp:param name="siteId" param="order.siteId"/>
                  </dsp:include>
                </td>
                 <td class="numerical">
                   <fmt:message var="orderNumberLinkTitle" key="myaccount_myOrders.orderNumberLinkTitle" />
                   <dsp:a iclass="atg_store_myOrdersCancel" page="../orderDetail.jsp" title="${orderNumberLinkTitle}">
                   <dsp:getvalueof var="omsOrderId" param="order.omsOrderId"/>
                   <c:choose>
                     <c:when test="${not empty omsOrderId}">
                       <dsp:valueof param="order.omsOrderId"/>
                     </c:when>
                     <c:otherwise>
                       <dsp:valueof param="order.id"/>
                     </c:otherwise>
                   </c:choose>
                   <dsp:param name="orderId" param="order.id"/>
                   <dsp:param name="selpage" value="MY ORDERS"/>
                  </dsp:a>
                </td>
                <td>
                  <dsp:getvalueof var="totalItems" vartype="java.lang.Long" scope="page" param="order.totalCommerceItemCount"/>
                  <dsp:getvalueof var="containsWrap" vartype="java.lang.Boolean" scope="page" param="order.containsGiftWrap"/>
                  <c:if test="${containsWrap}">
                    <c:set var="totalItems" value="${totalItems - 1}"/>
                  </c:if>
                  <c:out value="${totalItems}"/>
                  <fmt:message key="common.items"/>
                </td>
                <td class="date numerical">
                  <dsp:getvalueof var="submittedDate" vartype="java.util.Date" param="order.submittedDate"/>
                  <fmt:message key="myaccount_myOrders.dateFormat" var="dateFormat" />
                  <fmt:formatDate value="${submittedDate}" pattern="${dateFormat}"/>
                </td>

                 <td class="atg_store_orderState">
                   <dsp:include page="/global/util/orderState.jsp"/>
                 </td>
                 <td align="right">
                     <fmt:message var="viewOrderDetailsTitle" key="common.button.viewDetailsTitle" />
              
                     <dsp:a page="../orderDetail.jsp" title="${viewOrderDetailsTitle}">
                      <dsp:param name="selpage" value="MY ORDERS"/>
                      <dsp:param name="orderId" param="order.id"/>
                      <fmt:message key="common.viewDetails"/>
                    </dsp:a>
                </td>
              </tr>
    
            </dsp:oparam>
            <dsp:oparam name="outputEnd">
                            
              </tbody>
            </table>
    
            <dsp:include page="/global/gadgets/pagination.jsp">
              <dsp:param name="itemList" param="result"/>
              <dsp:param name="arraySplitSize" value="${pageSize}"/>
              <dsp:param name="size" param="size"/>
              <dsp:param name="start" value="${start}"/>
              <dsp:param name="top" value="${true}"/>
            </dsp:include>
      
          </dsp:oparam>
        </dsp:droplet> <%-- Range --%>
      </dsp:oparam>
      <dsp:oparam name="empty">
        <crs:messageContainer optionalClass="atg_store_myOrdersEmpty" titleKey="myaccount_myOrders.noOrders"/>
      </dsp:oparam>
    </dsp:droplet> <%-- OrderLookup --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/myOrders.jsp#2 $$Change: 633752 $--%>
