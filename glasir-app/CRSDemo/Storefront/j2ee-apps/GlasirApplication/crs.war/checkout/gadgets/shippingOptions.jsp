<dsp:page>

  <%--  This page displays the shipping options  --%>
  <%--  It takes the following parameters: --%>
  <%--  1. shippingGroup (optional) - shipping group to specify shipping methods for.
  <%--
      Form Condition:
      - This gadget must be contained inside of a form.
        ShippingGroupFormHandler must be invoked from a submit 
        button in this form for fields in this page to be processed
  --%>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/commerce/pricing/AvailableShippingMethods"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart" />
  <dsp:importbean bean="/atg/userprofiling/Profile"/> 
  
  <h2><fmt:message key="checkout_shippingOptions.availableShippingMethods"/></h2>
  
  <dsp:getvalueof var="shippingGroup" param="shippingGroup"/>  
  
  <fieldset class="atg_store_AvailableShippingMethods">
                            
    <ul>
      
      <%-- If shipping group is not passed, get first non-gift shipping group with relationships 
           or first gift shipping group --%>
      <c:if test="${empty shippingGroup}">
        <dsp:getvalueof var="shippingGroup" bean="ShippingGroupFormHandler.firstNonGiftHardgoodShippingGroupWithRels"/>
      </c:if>
      <c:if test="${empty shippingGroup}">
        <dsp:getvalueof var="giftShippingGroups" vartype="java.lang.Object" bean="ShippingGroupFormHandler.giftShippingGroups"/>
        <c:if test="${not empty giftShippingGroups}">
          <dsp:getvalueof var="shippingGroup" value="${giftShippingGroups[0]}"/>
        </c:if>
      </c:if>

      <%-- Get current shipping method defined in the shipping group --%>
      <dsp:getvalueof value="${shippingGroup.shippingMethod}" var="currentMethod"/>

            <%-- Display available methods --%>
      <dsp:droplet name="AvailableShippingMethods">
        <dsp:param name="shippingGroup" value="${shippingGroup}"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="availableShippingMethods" vartype="java.lang.Object" param="availableShippingMethods"/>
          
          <%-- Check if current shipping method defined in the shipping group is
               the one from available shipping methods --%>
          <c:if test="${not empty currentMethod}">
            <c:set var="isCurrentInAvailableMethods" value="false"/>
            <c:forEach var="method" items="${availableShippingMethods}" varStatus="status">
              <c:if test="${currentMethod eq method}">
                <c:set var="isCurrentInAvailableMethods" value="true"/>
              </c:if>
            </c:forEach>
          </c:if>
          <c:if test="${empty currentMethod or not isCurrentInAvailableMethods}">
            <%-- Current method in shipping group is either not defined or is not
                 available for this destination. Get default shipping method from 
                 user profile. --%>
            <dsp:getvalueof bean="Profile.defaultCarrier" var="currentMethod"/>
          </c:if>
          
          <c:forEach var="method" items="${availableShippingMethods}" varStatus="status">
            <dsp:param name="method" value="${method}"/>
            
            <%-- Determine shipping price for the current shipping method --%>
            <dsp:droplet name="/atg/store/pricing/PriceShippingMethod">
              <dsp:param name="shippingGroup" value="${shippingGroup}"/>
              <dsp:param name="shippingMethod" param="method"/>
              <dsp:oparam name="output">
                <dsp:getvalueof var="shippingPrice" param="shippingPrice" />
              </dsp:oparam>
            </dsp:droplet>
            <c:set var="shippingMethod" value="${fn:replace(method, ' ', '')}"/>
            <c:set var="shippingMethodResourceKey" value="checkout_shipping.delivery${shippingMethod}"/>
            <c:set var="shippingMethodContentResourceKey" value="${shippingMethodResourceKey}Content"/>
            <li class="${status.first ? 'first' : ''}${status.last ? 'last' : ''}">
              <c:choose>
                <c:when test="${(currentMethod eq method) or (empty currentMethod and status.first)}">
                  <c:set value="${true}" var="isMethodAlreadyChosen"/>
                </c:when>
                <c:otherwise>
                  <c:set value="${false}" var="isMethodAlreadyChosen"/>
                </c:otherwise>
              </c:choose>
			  
              <dsp:input type="radio" iclass="radio" checked="${isMethodAlreadyChosen}"
                         bean="ShippingGroupFormHandler.shippingMethod" paramvalue="method"
                         id="atg_store_shipping${shippingMethod}"/>
              
              <label for="atg_store_shipping${shippingMethod}">
                <%-- shipping method name --%>
                <span class="atg_store_shippingMethodTitle"><fmt:message key="${shippingMethodResourceKey}"/><fmt:message key="common.labelSeparator"/>
                  <dsp:include page="/global/gadgets/formattedPrice.jsp">
                    <dsp:param name="price" value="${shippingPrice}"/>
                  </dsp:include>
                </span>
                <%-- calculated shipping charge --%>
                
              </label>
            </li>
          </c:forEach>
        </dsp:oparam>
      </dsp:droplet><%-- End Available Shipping Methods Droplet --%>
    </ul>
  </fieldset>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingOptions.jsp#2 $$Change: 635969 $--%>