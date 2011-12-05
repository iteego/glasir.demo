<%--
  Displays order items for the given order or shipping group 
  (if we have multiple shipping groups)
 --%>
<dsp:page>

  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />

  <dsp:getvalueof var="commerceItems" param="commerceItems" />
  <dsp:getvalueof var="commerceItemRelationships" param="commerceItemRelationships" />
  <dsp:getvalueof var="hideSiteIndicator" vartype="java.lang.String" param="hideSiteIndicator" />


    <thead>
      <tr>
       <c:if test="${empty hideSiteIndicator or (hideSiteIndicator == 'false')}">
        <th class="site"><fmt:message key="common.site" /></th>
      </c:if>
        <th class="item" colspan="2"><fmt:message key="common.item" /></th>
        <th class="quantity"><fmt:message key="common.qty" /></th>
        <th class="price"><fmt:message key="common.price" /></th>
        <th class="total"><fmt:message key="common.total" /></th>
      </tr>
    </thead>


      <c:choose>
        <c:when test="${commerceItems != null}">
          <c:forEach var="currentItem" items="${commerceItems}" varStatus="status">
            <dsp:param name="currentItem" value="${currentItem}" />
            <dsp:getvalueof var="commerceItemClassType" param="currentItem.commerceItemClassType" />

            <c:if test="${commerceItemClassType != 'giftWrapCommerceItem'}">
              <dsp:include page="/global/gadgets/orderItemsRenderer.jsp">
                <dsp:param name="currentItem" value="${currentItem}" />
                <dsp:param name="count" value="${status.count}" />
                <dsp:param name="size" value="${size}" />
                <dsp:param name="dislpayProductAsLink" param="dislpayProductAsLink" />
              </dsp:include>
            </c:if>

          </c:forEach>
        </c:when>
        <c:otherwise>
          <c:forEach var="commerceItemRelationship" items="${commerceItemRelationships}" varStatus="status">
            <dsp:param name="currentItem" value="${commerceItemRelationship.commerceItem}" />
            <dsp:getvalueof var="commerceItemClassType" param="currentItem.commerceItemClassType" />

            <c:if test="${commerceItemClassType != 'giftWrapCommerceItem'}">
              <%-- Generate price beans for current row (that is for shipping group-commerce item relationship --%>
              <dsp:droplet name="/atg/store/droplet/StorePriceBeansDroplet">
                <dsp:param name="relationship" value="${commerceItemRelationship}" />
                <dsp:oparam name="output">
                  <dsp:include page="/global/gadgets/orderItemsRenderer.jsp">
                    <dsp:param name="currentItem" param="currentItem" />
                    <dsp:param name="count" value="${status.count}" />
                    <dsp:param name="size" value="${size}" />
                    <dsp:param name="dislpayProductAsLink" param="dislpayProductAsLink" />
                  </dsp:include>
                </dsp:oparam>
              </dsp:droplet>
            </c:if>
          </c:forEach>

        </c:otherwise>
      </c:choose>




</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/orderItems.jsp#1 $$Change: 633540 $--%>