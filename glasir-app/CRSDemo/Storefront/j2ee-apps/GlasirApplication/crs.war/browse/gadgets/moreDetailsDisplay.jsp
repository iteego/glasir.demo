<dsp:page>

  <%-- Displays the metadata description of product.

     This page expects the following input parameters
     - product - a product to display 
  --%>

  <div class="atg_store_productMetadataDescription">
    <div id="description">
      <p>
        <dsp:include page="../gadgets/productMetadataDescription.jsp">
          <dsp:param name="product" param="product" />
        </dsp:include>                  
      </p>        
    </div>
    <div id="features">
      <p>
        <dsp:getvalueof var="productFeatures" param="product.features"/>
        <dl>
          <c:forEach var="feature" items="${productFeatures}">
            <dsp:param name="feature" value="${feature}"/>
            <dt>
              <dsp:valueof param="feature.displayName">
                <fmt:message key="browse_moreDetails.highlightNameDefault" />
              </dsp:valueof>
            </dt>
          </c:forEach>
        </dl> 
      </p>
    </div>
    
    <%-- Display the 'Can not giftwrap product' message if needed --%>
    <fmt:message var="giftWrapMessage" key="common.itemGiftWrapIneligible"/>
    <dsp:getvalueof var="childSKUs" vartype="java.util.Collection" param="product.childSKUs"/>
    <c:forEach var="childSku" items="${childSKUs}">
      <dsp:param name="childSku" value="${childSku}"/>
      <dsp:getvalueof var="ifSkuGiftwrappable" vartype="java.lang.Boolean" param="childSku.giftWrapEligible"/>
      <c:if test="${ifSkuGiftwrappable}">
        <c:remove var="giftWrapMessage"/>
      </c:if>
    </c:forEach>
    <c:if test="${not empty giftWrapMessage}">
      <div id="gift_wrap_not_eligible">
        <c:out value="${giftWrapMessage}" escapeXml="false"/>
      </div>
    </c:if>
    
    <dsp:include page="/navigation/gadgets/clickToCallLink.jsp">
      <dsp:param name="pageName" value="productDetail"/>
    </dsp:include>
  </div><%-- atg_store_productMetadataDescription --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/moreDetailsDisplay.jsp#2 $$Change: 635969 $ --%>
