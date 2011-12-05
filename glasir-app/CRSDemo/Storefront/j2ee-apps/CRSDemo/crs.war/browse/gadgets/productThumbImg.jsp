<dsp:page>

<%-- This page expects the following parameters
     -  product - the product repository item whose thumbnail we display
     -  alternateImage (optional) - the alternate image we display (this trumps  the product thumbnail
                                    image but the product will be used to provide the  necessary link to
                                    the product detail page)
     -  linkImage (optional) - boolean indicating if the image should link (defaults to true)
     -  httpserver (optional) - prepend to all images and image links. this is used by the email templates
                                that share these pages to render images with fully qualified URLs.
     - categoryNavIds - ':' separated list representing the category navigation trail
     - categoryNav - Determines if breadcrumbs are updated to reflect category navigation trail on click through
     - navLinkAction (optional) - type of breadcrumb navigation to use for product detail links. 
                                Valid values are push, pop, or jump. Default is jump.
     - showAsLink (optional) - specifies if product thumbnail image should be displayed as link 
                               (if possible), 'true' by default
    Form Condition:
        - In several places this sub-gadget is contained inside of a form, though not mandatorily.
          Currently, CartFormHandler is invoked from a submit button in the form for fields in this 
          page to be processed
--%>

  <dsp:importbean var="originatingRequest" bean="/OriginatingRequest"/>
 
  <dsp:getvalueof var="displayName" vartype="java.lang.String" param="product.displayName"/>
  <c:set var="displayName"><c:out value="${displayName}" escapeXml="true"/></c:set>
  <dsp:getvalueof var="httpserver" vartype="java.lang.String" param="httpserver"/>

  <dsp:getvalueof var="linkImage" vartype="java.lang.String" param="linkImage"/>
  <dsp:getvalueof var="showAsLink" vartype="java.lang.String" param="showAsLink"/>

  <dsp:getvalueof var="imageUrl" vartype="java.lang.String" param="alternateImage.url"/>
  <c:if test="${empty imageUrl}">
    <%-- No Alternate Image Passed, use the product's image --%>
    <dsp:getvalueof var="imageUrl" param="product.thumbnailImage.url"/>
  </c:if>
  
  <c:choose>
    <c:when test="${empty imageUrl}">
      <img src="${httpserver}/images/unavailable.gif" alt="${displayName}"/>
    </c:when>
    <c:otherwise>
      <c:choose>
        <c:when test="${(showAsLink == 'false') or (linkImage == 'false')}">
          <c:set var="productUrl" value=""/>
        </c:when>
        <c:otherwise>
          <dsp:include page="/global/gadgets/productLinkGenerator.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="navLinkAction" param="navLinkAction"/>
            <dsp:param name="categoryNavIds" param="categoryNavIds"/>
            <dsp:param name="categoryNav" param="categoryNav"/>
            <dsp:param name="siteId" param="siteId"/>
          </dsp:include>
        </c:otherwise>
      </c:choose>
      
      <c:choose>
        <c:when test="${empty productUrl}">
          <img src="${httpserver}${imageUrl}" border="0" alt="${displayName}"/>
        </c:when>
        <c:otherwise>
          <a href="${httpserver}${productUrl}" title="${displayName}">
            <img src="${httpserver}${imageUrl}" border="0" alt="${displayName}"/>
          </a>
        </c:otherwise>
      </c:choose>
    </c:otherwise>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productThumbImg.jsp#2 $$Change: 635969 $--%>
