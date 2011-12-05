<dsp:page>

  <%-- 
     This gadgets gets the inventory availability of the current item in the cart.  It takes the following
     input parameters:
       - commerceItem - The commerce item

     It will set the following request-scoped page variables:
       - availabilityMessage - The prefix for an availability message (i.e., "Preorderable until")
       - availabilityType - The oparam name returned from the SkuAvailabilityLookup droplet

  --%>

<dsp:importbean bean="/atg/commerce/inventory/InventoryLookup"/>

<dsp:setvalue param="product" paramvalue="commerceItem.auxiliaryData.productRef"/>
<dsp:getvalueof var="stateAsString" param="commerceItem.stateAsString"/>

<c:choose>

  <c:when test="${stateAsString == 'PRE_ORDERED'}">
    <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="preorderable" scope="request"/>
    <dsp:getvalueof var="preorderEndDate" param="product.preorderEndDate"/>
    <c:choose>
      <c:when test="${not empty preorderEndDate}">
        <dsp:getvalueof id="availDateId" idtype="java.util.Date" param="product.preorderEndDate"/>
        <fmt:formatDate var="addToCartDate" value="${availDateId}" dateStyle="short"/>
        <fmt:message var="availabilityMessage" key="common.preorderableUntil" scope="request">
          <fmt:param>
            <span class="date numerical">${addToCartDate}</span>
          </fmt:param>
        </fmt:message>
      </c:when>
      <c:otherwise>
        <fmt:message var="availabilityMessage" key="common.preorderable" scope="request"/>
      </c:otherwise>
    </c:choose>
  </c:when>

  <c:when test="${stateAsString == 'BACK_ORDERED'}">
    <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="backorderable" scope="request"/>
    <dsp:droplet name="InventoryLookup">
      <dsp:param name="itemId" param="commerceItem.catalogRefId"/>
      <dsp:oparam name="output">

        <dsp:getvalueof var="availabilityDate" param="inventoryInfo.availabilityDate"/>
        <c:choose>
          <c:when test="${not empty availabilityDate}">
            <dsp:getvalueof id="availDateId" idtype="java.util.Date"
                            param="inventoryInfo.availabilityDate" scope="request"/>
            <fmt:formatDate var="addToCartDate" value="${availDateId}" dateStyle="short"/>
            <fmt:message var="availabilityMessage" key="common.backorderableUntil" scope="request">
              <fmt:param>
                <span class="date numerical">${addToCartDate}</span>
              </fmt:param>
            </fmt:message>
          </c:when>
          <c:otherwise>
            <fmt:message var="availabilityMessage" key="common.backorderable" scope="request"/>
          </c:otherwise>
        </c:choose>
      </dsp:oparam>
    </dsp:droplet>
  </c:when>

  <%-- Show items is in stock, preorderable and backorderable.  Do not show unavailable items. --%>
  <c:otherwise>
    <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="available" scope="request"/>
    <dsp:getvalueof id="availabilityMessage" idtype="java.lang.String" value="" scope="request"/>
  </c:otherwise>

</c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/itemAvailabilityLookup.jsp#2 $$Change: 635969 $--%>
