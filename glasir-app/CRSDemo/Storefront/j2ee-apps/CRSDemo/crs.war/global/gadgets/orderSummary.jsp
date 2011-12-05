<%-- This gadget renders the order summary on the checkout pages --%>

<dsp:page>
  
  <dsp:importbean bean="/atg/dynamo/droplet/Compare" />
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />
  <dsp:importbean bean="/atg/store/order/purchase/CommitOrderFormHandler"/>

  <dsp:getvalueof var="currencyCode" vartype="java.lang.String" param="order.priceInfo.currencyCode" />
  <dsp:getvalueof var="editItems" vartype="java.lang.String" param="editItems" />
  <dsp:getvalueof var="contextRoot" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof var="shippingRatesURL" vartype="java.lang.String" value="${contextRoot}/company/shippingRatesPopup.jsp"/>
  <dsp:getvalueof var="returnPolicyURL" vartype="java.lang.String" value="${contextRoot}/company/returnPolicyPopup.jsp"/>
  <dsp:getvalueof var="isCurrent" param="isCurrent"/>
  
  <dsp:getvalueof var="missingProductId" vartype="java.lang.String" bean="/atg/commerce/order/processor/SetProductRefs.substituteDeletedProductId"/>
<div id="atg_store_shipmentInfoContainer">
  <div class="atg_store_shipmentInfo">

  <%-- Check if order has more then one shipping group --%>
  <c:set var="hardgoodShippingGroups" value="0"/>
  <dsp:getvalueof var="shippingGroups" vartype="java.lang.Object" param="order.shippingGroups"/>
  <c:set var="shippingGroupsSize" value="${fn:length(shippingGroups) }" />
  
  <c:forEach var="shippingGroup" items="${shippingGroups}" varStatus="shippingGroupStatus">
    <dsp:param name="shippingGroup" value="${shippingGroup}"/>              
    <dsp:getvalueof var="shippingGroupClassType" param="shippingGroup.shippingGroupClassType"/>
    <c:set var="itemsSize" value="${fn:length(shippingGroup.commerceItemRelationships)}"/>

    <c:if test='${itemsSize > 0}'>
      <c:if test="${shippingGroupClassType == 'hardgoodShippingGroup'}">
        <c:set var="hardgoodShippingGroups" value="${hardgoodShippingGroups + 1}"/>
        <dsp:param name="hardgoodShippingGroup" value="${shippingGroup}"/>
      </c:if>
    </c:if>
  </c:forEach>

    <%-- Determine if we have more then one shipping group --%>
    <c:choose>
      <c:when test="${empty isCurrent}">
        <%-- display status for non-current orders here --%>
        <dsp:include page="/myaccount/gadgets/orderDetailIntro.jsp" />
      </c:when>
      <c:otherwise>
        <c:if test="${hardgoodShippingGroups == 1}">           
          <dsp:include page="/global/gadgets/orderSingleShippingInfo.jsp">
            <dsp:param name="isCurrent" param="isCurrent"/>
            <dsp:param name="shippingGroup" param="hardgoodShippingGroup"/>
          </dsp:include>
        </c:if>
      </c:otherwise>
    </c:choose>
    
    <dsp:include page="/checkout/gadgets/confirmPaymentOptions.jsp">
      <dsp:param name="isCurrent" param="isCurrent"/>
      <dsp:param name="order" param="order"/>
      <dsp:param name="expressCheckout" param="expressCheckout"/>
    </dsp:include>
     
  </div>
  </div>
  <c:if test="${hardgoodShippingGroups > 0}">           
    <c:choose>
      <%-- Multiple shipping groups --%>
      <c:when test="${hardgoodShippingGroups > 1 || empty isCurrent}">
  <c:forEach var="shippingGroup" items="${shippingGroups}" varStatus="shippingGroupStatus">
    <dsp:param name="shippingGroup" value="${shippingGroup}"/>              
    <dsp:getvalueof var="shippingGroupClassType" param="shippingGroup.shippingGroupClassType"/>
    <c:set var="itemsSize" value="${fn:length(shippingGroup.commerceItemRelationships)}"/>
    
    <c:if test='${itemsSize > 0}'>
      <c:if test="${shippingGroupClassType == 'hardgoodShippingGroup'}">
        <dsp:param name="shippingAddress" param="shippingGroup.shippingAddress"/>
        <div id="atg_store_multishipGroupInfoContainer">
        <div class="atg_store_multishipGroupInfo">
            <dl class="atg_store_groupShippingAddress">
              <dt>
                <fmt:message key="checkout_confirmPaymentOptions.shipTo"/>: 
              </dt>             
              <dd>
                
                <dsp:include page="/global/util/displayAddress.jsp">
                  <dsp:param name="address" param="shippingAddress"/>
                </dsp:include>
                
                <c:if test="${isCurrent}">
                  <dsp:a page="/checkout/shipping.jsp" title="">
                    <span><fmt:message key="common.button.editText" /></span>
                  </dsp:a>
                </c:if>

              </dd>
            </dl>
            
            <dl class="atg_store_groupPaymentMethod">
              <dt>
                <fmt:message key="checkout_confirmPaymentOptions.viaMethod"/>: 
              </dt>
              <dd>
                <dsp:getvalueof var="shippingMethod" param="shippingGroup.shippingMethod"/>
                <span><fmt:message key="common.delivery${fn:replace(shippingMethod, ' ', '')}"/></span>
                <c:if test="${isCurrent}">
                  <dsp:a page="/checkout/shipping.jsp" title="">
                    <fmt:message key="common.button.editText" />
                  </dsp:a>
                </c:if>
              </dd>
            </dl>
          </div>
          </div>
        
        
        
        <table id="atg_store_cart">
        <%-- proceed shipping group --%>
        <dsp:include page="/global/gadgets/orderItems.jsp">
          <dsp:param name="commerceItemRelationships" value="${shippingGroup.commerceItemRelationships}"/>
          <dsp:param name="dislpayProductAsLink" param="dislpayProductAsLink"/>
        </dsp:include>
        </table>
      </c:if>
    </c:if>
  </c:forEach>
      

    
      </c:when>
      <%-- Single shipping group --%>
      <c:otherwise>
      
      <div id="atg_store_cartContainer">
      <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" param="order.commerceItems"/> 
      <c:choose>
        <c:when test="${not empty commerceItems}">
          <dsp:getvalueof id="size" value="${fn:length(commerceItems)}"/>
          <table id="atg_store_cart">
            <dsp:include page="/global/gadgets/orderItems.jsp">
              <dsp:param name="commerceItems" value="${commerceItems}"/>
              <dsp:param name="dislpayProductAsLink" param="dislpayProductAsLink"/>
            </dsp:include>
          </table>
        </c:when>
      </c:choose>

      </div>
      </c:otherwise>
    </c:choose>
    <dsp:include page="/global/gadgets/orderExtras.jsp">
      <dsp:param name="giftWrapItem" param="giftWrapItem"/>
      <dsp:param name="order" param="order"/>
    </dsp:include>
  </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/orderSummary.jsp#1 $$Change: 633540 $--%>
