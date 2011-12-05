<dsp:page>
<%--
  Displays small product image if exist. On click displays large image using javascript. 
   
  This page expects the following input parameters:
  product - the product object being displayed
--%>
  <dsp:getvalueof id="product" param="product"/>
  <dsp:getvalueof  id="smallImageURL" idtype="java.lang.String" param="product.smallImage.url" />
  
  <c:if test="${!empty smallImageURL}">
    <dsp:getvalueof var="altText" vartype="java.lang.String" param="product.displayName" />
    <c:set var="altText"><c:out value="${altText}" escapeXml="true"/></c:set>
    <dsp:getvalueof  id="largeImageURL" idtype="java.lang.String" param="product.largeImage.url" />

    <a href="${largeImageURL}" dojoType="dojox.image.Lightbox" title="${altText}">
      <dsp:img src="${smallImageURL}"  alt="${altText}" /> 
    </a>
  
    <div>
      <a class="atg_store_largerImage" href="${largeImageURL}" dojoType="dojox.image.Lightbox" title="${altText}">
        <fmt:message key="browse_productAction.largerImageLink"/>
      </a>
    </div>
  </c:if>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productImage.jsp#2 $$Change: 635969 $ --%>
