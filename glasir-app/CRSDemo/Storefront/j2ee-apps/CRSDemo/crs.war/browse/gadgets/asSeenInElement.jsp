<dsp:page>

<%--
      Renders a single element on the AsSeenIn page
      This page expects the following parameters:
      product - The product to render details for (RepositoryItem)
      hasTemplate - Does this product have a display template? (boolean)
      url - The product URL
--%>

  <dsp:getvalueof param="url" var="url"/>
  <dsp:getvalueof param="hasTemplate" var="hasTemplate"/>

    <dsp:getvalueof param="product.displayName" var="productDisplayName"/>
    <fmt:message key="common.productNameDefault" var="productNameDefault"/>
    <c:set var="productDisplayname" value="${!empty productDisplayName ? productDisplayName : productNameDefault}"/>
    <c:choose>
      <c:when test="${hasTemplate}">
        <span class="atg_store_productTitle">
          <c:out value="${productDisplayName}"/>
        </span>
      </c:when>
      <c:otherwise>
        <span class="atg_store_productTitle">
          <c:out value="${productDisplayName}"/>
        </span>
      </c:otherwise>       
    </c:choose>    
  
  
    <span class="atg_store_featureOrigin">
      <fmt:message key="browse_asSeenIn.featuredIn">
        <fmt:param>
          <dsp:getvalueof param="product.asSeenIn.source" var="asSeenInSource"/>
          <fmt:message key="browse_asSeenIn.defaultInfo" var="asSeenInDefaultInfo"/>
          ${!empty asSeenInSource ? asSeenInSource : asSeenInDefaultInfo}
        </fmt:param>
      </fmt:message>
    </span>
  
    <span class="atg_store_productDescription">
      <dsp:valueof param="product.asSeenIn.description" valueishtml="true">
        <fmt:message key="browse_asSeenIn.defaultMessage" />
      </dsp:valueof>
    </span>
  


</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/asSeenInElement.jsp#1 $$Change: 633540 $--%>
