<dsp:page>
  <%-- 
      This gadget gets the inventory availability of a sku.  It assumes it will be called
      multiple times with different skus.  It tracks what the final "Add To Cart" text should
      be given all the skus.  It takes the following input parameters:

      - product - The product item whose inventory is to be checked
      - skuId - The ID of the sku whose inventory is to be checked

      It will set the following request-scoped page variables:

      - availabilityMessage - The prefix for a specific skus availability message (i.e.,
                              "Preorderable until <date>")
      - showNotifyButton - A boolean detailing if the showNotifyButton should be shown.
      - finalAddButtonText - The name that should be displayed on the final "Add To Cart"
                             button ("Add To Cart", "Preorder", etc.)
      - finalAddButtonTitle - The title that should be displayed on the final "Add To Cart"
                              button ("Add To Cart", "Preorder", etc.)
                             
      Note that this button keeps internal state in request variables, so it cannot be
      called in two different blocks in one request expecting it to render a different
      'finalAddButtonText' for each block.

      Form Condition:
      - This gadget must be contained inside of a form.
        CartFormHandler must be invoked from a submit 
        button in this form for fields in this page to be processed
  --%>

  <dsp:importbean bean="/atg/store/droplet/SkuAvailabilityLookup"/>
    
  <%-- Check inventory --%>
  <dsp:droplet name="SkuAvailabilityLookup">
    <dsp:param name="product" param="product"/>
    <dsp:param name="skuId" param="skuId"/>
  
    <dsp:oparam name="available">
      <%-- Item is in stock! --%>
      <fmt:message var="finalAddButtonText" key="common.button.addToCartText" scope="request"/>
      <fmt:message var="finalAddButtonTitle" key="common.button.addToCartTitle" scope="request"/>
      <dsp:getvalueof id="showNotifyButton" idtype="java.lang.Boolean" value="${false}" scope="request"/>
      <dsp:getvalueof id="_multiSkuAvailabilityLookup_finalButtonToShow" idtype="java.lang.String"
                      param="available" scope="request"/>
      <dsp:getvalueof id="availabilityMessage" idtype="java.lang.String" value="" scope="request"/>
    </dsp:oparam>
  
    <dsp:oparam name="preorderable">
      <dsp:getvalueof id="showNotifyButton" idtype="java.lang.Boolean" value="${false}" scope="request"/>
      <c:choose>
        <c:when test="${_multiSkuAvailabilityLookup_finalButtonToShow == 'preorderable'}">
        </c:when>
        <c:when test="${_multiSkuAvailabilityLookup_finalButtonToShow == 'unset'}">
          <dsp:getvalueof id="_multiSkuAvailabilityLookup_finalButtonToShow" idtype="java.lang.String"
                          param="preorderable" scope="request"/>
          <fmt:message var="finalAddButtonText" key="common.button.preorderText" scope="request"/>
          <fmt:message var="finalAddButtonTitle" key="common.button.preorderTitle" scope="request"/>
        </c:when>
        <c:otherwise>
          <dsp:getvalueof id="_multiSkuAvailabilityLookup_finalButtonToShow" idtype="java.lang.String"
                          param="available" scope="request"/>
          <fmt:message var="finalAddButtonText" key="common.button.addToCartText" scope="request"/>
          <fmt:message var="finalAddButtonTitle" key="common.button.addToCartTitle" scope="request"/>
        </c:otherwise>
      </c:choose>

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
      <dsp:getvalueof id="showNotifyButton" idtype="java.lang.Boolean" value="${false}" scope="request"/>
      <c:choose>
        <c:when test="${_multiSkuAvailabilityLookup_finalButtonToShow == 'backorderable'}">
        </c:when>
        <c:when test="${_multiSkuAvailabilityLookup_finalButtonToShow == 'unset'}">
          <dsp:getvalueof id="_multiSkuAvailabilityLookup_finalButtonToShow" idtype="java.lang.String"
                          param="backorderable" scope="request"/>
          <fmt:message var="finalAddButtonText" key="common.button.backorderText" scope="request"/>
          <fmt:message var="finalAddButtonTitle" key="common.button.backorderTitle" scope="request"/>
        </c:when>
        <c:otherwise>
          <dsp:getvalueof id="_multiSkuAvailabilityLookup_finalButtonToShow" idtype="java.lang.String"
                          param="available" scope="request"/>
          <fmt:message var="finalAddButtonText" key="common.button.addToCartText" scope="request"/>
          <fmt:message var="finalAddButtonTitle" key="common.button.addToCartTitle" scope="request"/>
        </c:otherwise>
      </c:choose>

      <dsp:getvalueof var="availabilityDate" param="availabilityDate"/>
      <c:choose>
        <c:when test="${empty availabilityDate}">
          <fmt:message var="availabilityMessage" key="common.backorderable" scope="request"/>
        </c:when>
        <c:otherwise>
          <dsp:getvalueof id="availDateId" idtype="java.util.Date" param="availabilityDate"/>
          <fmt:formatDate var="addToCartDate" value="${availDateId}" dateStyle="short"/>
          <fmt:message var="availabilityMessage" key="common.backorderableUntil" scope="request">
            <fmt:param>
              <span class="date numerical">${addToCartDate}</span>
            </fmt:param>
          </fmt:message>
        </c:otherwise>
      </c:choose>

    </dsp:oparam>
  
    <dsp:oparam name="default">
      <%-- Item is out of stock! --%>
      <dsp:getvalueof id="showNotifyButton" idtype="java.lang.Boolean" value="${true}" scope="request"/>
      <%-- _multiSkuAvailabilityLookup_finalButtonToShow does not change since this item cannot be added
           to the cart --%>
      <fmt:message var="availabilityMessage" key="common.temporarilyOutOfStock" scope="request"/>
      <fmt:message var="addButtonText" key="common.button.emailMeInStockText" scope="request"/>
      <fmt:message var="addButtonTitle" key="common.button.emailMeInStockTitle" scope="request"/>
    </dsp:oparam>
  </dsp:droplet><%-- End Sku Availability Lookup --%>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/multiSkuAvailabilityLookup.jsp#2 $$Change: 635969 $--%>
