<dsp:page>

<%-- This page expects the following parameters
     - product - the product repository item to display
     - categoryId - the repository ID of the product's category
     - showAsLink - specifies if product promo image should be displayed as link (if possible),
                    true by default
--%>

  <dsp:getvalueof var="altParam" param="alt"/>
  <c:set var="altParam"><c:out value="${altParam}" escapeXml="true"/></c:set>
  <dsp:getvalueof id="pageurl" idtype="java.lang.String" param="product.template.url"/>
  <dsp:getvalueof id="imageurl" idtype="java.lang.String" param="product.promoImage.url"/>
  
  <%-- Set showAsLink to true if it's not provided --%>
  <dsp:getvalueof var="showAsLink" param="showAsLink"/>
  <c:if test="${empty showAsLink }">
    <c:set var="showAsLink" value="true"/>
  </c:if>
  
  <c:choose>
    <c:when test="${not empty imageurl}">
      <%-- Promo image exists --%>
      <c:choose>
        <c:when test="${not empty pageurl && showAsLink}">
        <%-- Product Template is set --%>
        
          <%-- Get browser-specific URL for product --%>
          <dsp:droplet name="/atg/repository/seo/CatalogItemLink">
          <dsp:param name="item" param="product"/>
          <dsp:oparam name="output">
            <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="url"/>
          </dsp:oparam>
          </dsp:droplet>
 
          <dsp:a page="${pageurl}">
            <dsp:param name="productId" param="product.repositoryId"/>
            <dsp:param name="categoryId" param="categoryId"/>
            <dsp:img src="${imageurl}" alt="${altParam}"></dsp:img>
          </dsp:a>
        </c:when>
        <c:otherwise>
        <%-- Product Template not set --%>
          <dsp:img src="${imageurl}" alt="${altParam}"></dsp:img>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
      <fmt:message key="browse_productComparisons.noPromoImage"/>
    </c:otherwise>
  </c:choose> <%-- End is Promo image empty --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productPromoImg.jsp#2 $$Change: 635969 $--%>
