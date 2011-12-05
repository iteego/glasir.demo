<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest" />
	
  <dsp:getvalueof id="productId" param="productId"/>
  <dsp:getvalueof id="site" param="site"/>
  
  <crs:pageContainer bodyClass="atg_store_pageProductDetail atg_store_productNotAvailable">
   	<jsp:body>
   	
   	<div class="atg_store_nonCatHero">
    </div>
    
    <%-- Determines message to display --%>
    <c:choose>
      <%-- If we have a site specific message display that --%>
      <c:when test="${not empty site && not empty productId}">
        <fmt:message var="errorMessage" key="common.productNotFoundForSite">
          <fmt:param value="${productId}"/>
          <fmt:param value="${site}"/>
        </fmt:message>
      </c:when>
      <%-- If we have a productId --%>
      <c:when test="${not empty productId}">
        <fmt:message var="errorMessage" key="common.productNotFound">
          <fmt:param value="${productId}"/>
        </fmt:message>
      </c:when>
      <%-- Display a message without the productId --%>
      <c:otherwise>
        <fmt:message var="errorMessage" key="common.productIdNotFound"/>
      </c:otherwise>
    </c:choose>    
    
    <crs:messageContainer titleText="${errorMessage}">
      <jsp:body>
        <%-- Continue shopping link --%>
        <crs:continueShopping>
          <c:choose>
            <%-- Use the continueShoppingURL --%>
            <c:when test="${not empty continueShoppingURL}">
              <dsp:a href="${continueShoppingURL}" iclass="atg_store_basicButton">
                <span>
                  <fmt:message key="common.button.continueShoppingText"/>
                </span>
              </dsp:a>
            </c:when>
            <%-- Otherwise just go to the homepage --%>
            <c:otherwise>
              <dsp:a href="${originatingRequest.contextPath}" iclass="atg_store_basicButton">
                <span>
                  <fmt:message key="common.button.continueShoppingText"/>
                </span>
              </dsp:a>
            </c:otherwise>
          </c:choose>
        </crs:continueShopping>
      </jsp:body>
    </crs:messageContainer>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productNotAvailable.jsp#2 $$Change: 633752 $ --%>