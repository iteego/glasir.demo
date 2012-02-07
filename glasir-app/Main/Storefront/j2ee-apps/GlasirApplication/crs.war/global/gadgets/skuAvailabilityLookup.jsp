<dsp:page>

  <%-- 
     This gadgets gets the inventory availability of the current sku in the cart.  It takes the following
     input parameters:
       - product - The product item whose inventory is to be checked
       - skuId - The ID of the sku whose inventory is to be checked
       - showUnavailable (optional) - Set to true if you want addButtonText set for unavailable items

     It will set the following request-scoped page variables:
       - addButtonText - The name that will be displayed on the "Add To Cart" button ("Add To Cart", "Preorder", etc.)
       - addButtonTitle - The title that will be display with the "Add To Cart" button ("Add To Cart", "Preorder", etc.)
       - availabilityMessage - The prefix for an availability message (i.e., "Preorderable until")
       - availabilityType - The oparam name returned from the SkuAvailabilityLookup droplet

     Form Condition:
     - This gadget must be contained inside of a form.
       CartFormHandler must be invoked from a submit 
       button in this form for fields in this page to be processed
  --%>

<dsp:importbean bean="/atg/store/droplet/SkuAvailabilityLookup"/>

<dsp:droplet name="SkuAvailabilityLookup">
  <dsp:param name="product" param="product"/>
  <dsp:param name="skuId" param="skuId"/>

  <%-- Show items is in stock, preorderable and backorderable.  Do not show unavailable items. --%>
  <dsp:oparam name="available">
    <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="available" scope="request"/>
    <fmt:message var="addButtonText" key="common.button.addToCartText" scope="request"/>
    <fmt:message var="addButtonTitle" key="common.button.addToCartTitle" scope="request"/>
    <fmt:message var="availabilityMessage" key="common.available" scope="request"/>
  </dsp:oparam>

  <dsp:oparam name="preorderable">
    <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="preorderable" scope="request"/>
    <fmt:message var="addButtonText" key="common.button.preorderText" scope="request"/>
    <fmt:message var="addButtonTitle" key="common.button.preorderTitle" scope="request"/>
    <dsp:getvalueof var="availabilityDate" param="availabilityDate"/>
    <c:choose>
      <c:when test="${not empty availabilityDate}">
        <dsp:getvalueof id="availDateId" idtype="java.util.Date" param="availabilityDate"/>
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
  </dsp:oparam>

  <dsp:oparam name="backorderable">
    <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="backorderable" scope="request"/>
    <fmt:message var="addButtonText" key="common.button.backorderText" scope="request"/>
    <fmt:message var="addButtonTitle" key="common.button.backorderTitle" scope="request"/>

    <dsp:getvalueof var="availabilityDate" param="availabilityDate"/>
    <c:choose>
      <c:when test="${not empty availabilityDate}">
        <dsp:getvalueof id="availDateId" idtype="java.util.Date" param="availabilityDate" scope="request"/>
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

  <dsp:oparam name="unavailable">
    <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="unavailable" scope="request"/>
    <fmt:message var="availabilityMessage" key="common.temporarilyOutOfStock" scope="request"/>
    <dsp:getvalueof id="showUnavailable" param="showUnavailable"/>
    <c:choose>
      <c:when test="${!empty showUnavailable && showUnavailable == 'true'}">
        <fmt:message var="addButtonText" key="common.button.emailMeInStockText" scope="request"/>
        <fmt:message var="addButtonTitle" key="common.button.emailMeInStockTitle" scope="request"/>
      </c:when>
      <c:otherwise>
        <dsp:getvalueof id="addButtonText" idtype="java.lang.String" value="" scope="request"/>
        <dsp:getvalueof id="addButtonTitle" idtype="java.lang.String" value="" scope="request"/>
      </c:otherwise>
    </c:choose>
  </dsp:oparam>

</dsp:droplet>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/skuAvailabilityLookup.jsp#2 $$Change: 635969 $--%>
