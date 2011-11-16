<%-- Renders the category/subcategory error page --%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest" />

  <dsp:getvalueof id="categoryId" param="categoryId"/>
  <dsp:getvalueof id="site" param="site"/>
  <dsp:getvalueof id="errorMsg" param="errorMsg"/>
  
  <crs:pageContainer bodyClass="atg_store_pageProductDetail atg_store_productNotAvailable">
   	<jsp:body>
   	
	   	<div class="atg_store_nonCatHero">
	    </div>
      
      <c:choose>
        <%-- Display error from droplet --%>
        <c:when test="${not empty errorMsg}">
          <c:set var="errorMessage" value="${errorMsg}" />
        </c:when>
        <%-- If we have a site specific message display that --%>
        <c:when test="${not empty site && not empty categoryId}">
          <fmt:message var="errorMessage" key="common.categoryNotFoundForSite">
            <fmt:param value="${categoryId}"/>
            <fmt:param value="${site}"/>
          </fmt:message>
        </c:when>
        <%-- If we have a categoryId --%>
        <c:when test="${not empty categoryId}">
          <fmt:message var="errorMessage" key="common.categoryNotFound">
            <fmt:param value="${categoryId}"/>
          </fmt:message>
        </c:when>
        <%-- Display a message without the categoryId --%>
        <c:otherwise>
          <fmt:message var="errorMessage" key="common.categoryIdNotFound"/>
        </c:otherwise>
      </c:choose>
          
      <crs:messageContainer titleText="${errorMessage}">
        <jsp:body>
          <%-- Continue shopping link --%>
          <crs:continueShopping>
            <%-- Use the continueShoppingURL --%>
            <c:choose>
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
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/categoryNotAvailable.jsp#2 $$Change: 633752 $--%>
