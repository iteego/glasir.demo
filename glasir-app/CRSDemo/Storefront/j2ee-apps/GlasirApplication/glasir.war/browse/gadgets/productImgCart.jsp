<dsp:page>

<%-- This page expects the following parameters
     -  product - the product repository item whose thumbnail we display
     -  alternateImage (optional) - the alternate image we display (this trumps  the product thumbnail
                                    image but the product will be used to provide the  necessary link to
                                    the product detail page)
     -  linkImage (optional) - boolean indicating if the image should link (defaults to true)
     -  httpserver (optional) - prepend to all images and image links. this is used by the email templates
                                that share these pages to render images with fully qualified URLs.
     - displayAslink - tells is image should be a link

    Form Condition:
        - In several places this sub-gadget is contained inside of a form, though not mandatorily.
          Currently, CartFormHandler is invoked from a submit button in the form for fields in this 
          page to be processed
--%>

  <dsp:importbean bean="/atg/dynamo/droplet/Cache"/>
 
  <dsp:getvalueof var="productId" vartype="java.lang.String" param="product.repositoryId"/>
  <dsp:getvalueof var="alternateImageId" vartype="java.lang.String" param="alternateImage.repositoryId"/>
  <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="product.template.url"/>
  <dsp:getvalueof var="httpserver" vartype="java.lang.String" param="httpserver"/>
  <dsp:getvalueof var="linkImage" vartype="java.lang.String" param="linkImage"/>
  <dsp:getvalueof var="displayAslink" param="displayAslink"/>
  <dsp:getvalueof var="httplink" vartype="java.lang.String" param="httplink"/>  
  <dsp:getvalueof var="commerceItemId" vartype="java.lang.String" param="commerceItem.id"/>
  <dsp:getvalueof var="productName" vartype="java.lang.String" param="product.displayName"/>
  <c:if test="${empty productName}">
    <c:set var="productName"><dsp:valueof param="commerceItem.productRef.displayName"/></c:set>
  </c:if>
  
  <dsp:getvalueof var="siteId" vartype="java.lang.String" param="siteId"/>

  <dsp:getvalueof var="cache_key" value="bp_fpti_cart_${productId}_${alternateImageId}_${linkImage}_${httpserver}_${siteId}_${displayAslink}"/>

  <c:if test="${not empty commerceItemId}">
    <dsp:getvalueof var="cache_key" value="bp_fpti_cart_${commerceItemId}_${productId}_${alternateImageId}_${linkImage}_${httpserver}_${siteId}_${displayAslink}"/>
  </c:if>
  
  <dsp:droplet name="Cache">
    <dsp:param name="key" value="${cache_key}"/>
    <dsp:oparam name="output">
       
      <dsp:getvalueof var="alternateImageUrl" param="alternateImage.url"/>
      <c:choose>
      <c:when test="${empty alternateImageUrl}">
          <%-- No Alternate Image Passed, use the product's image --%>
          <dsp:getvalueof var="productPromoImageUrl" param="product.promoImage.url"/>
          <c:choose>
          <c:when test="${not empty productPromoImageUrl}">
              <%-- Promo image exists --%>
              <c:choose>
                <c:when test="${linkImage == false}">
                  <img  src="<dsp:valueof param='httpserver'/><dsp:valueof param='product.promoImage.url'/>" alt="${productName}"/>
                </c:when>
                <c:otherwise> 
                  <%-- Link The Image --%>
                  <dsp:getvalueof var="productTemplateUrl" param="product.template.url"/>
                  <c:choose>
                    <c:when test="${not empty productTemplateUrl}">
                      <%-- Product Template is set --%>
                      <c:choose>
                        <c:when test="${displayAslink || empty displayAslink}">
                          <dsp:getvalueof var="url_part1" param="httpserver"/>
                          <dsp:getvalueof var="url_part2" param="product.promoImage.url"/>

                          <c:set var="imgUrl" value="${url_part1}${url_part2}"/>

                          <c:if test="${empty url_part1}">
                            <c:set var="imgUrl" value="${url_part2}"/>
                          </c:if> 

                          <dsp:getvalueof var="imgUrl" value="${imgUrl}"/>

                          <dsp:include page="/global/gadgets/crossSiteLink.jsp">
                            <dsp:param name="item" param="commerceItem"/>
                            <dsp:param name="imgUrl" value="${imgUrl}"/>
                          </dsp:include>
                        </c:when>
                        <c:otherwise>
                          <img src="<dsp:valueof param='httpserver'/><dsp:valueof param='product.promoImage.url'/>"  alt="${productName}"/>
                        </c:otherwise>
                      </c:choose>

                    </c:when>
                    <c:otherwise>
                      <%-- Product Template not set --%>
                      <img src="<dsp:valueof param='httpserver'/><dsp:valueof param='product.promoImage.url'/>"  alt="${productName}"/>
                    </c:otherwise>
                  </c:choose><%-- End is template empty --%>
                </c:otherwise>
              </c:choose><%-- End are we to link the image --%>
            </c:when>
            <c:otherwise>
              <img  height="150" width="150" src="<dsp:valueof param='httpserver'/>/images/unavailable.gif" width="85" height="85" alt="${productName}">
            </c:otherwise>
          </c:choose>
        </c:when>
        <c:otherwise>
          <c:choose>
            <c:when test="${linkImage == 'false'}">
              <img src="<dsp:valueof param='httpserver'/><dsp:valueof param='alternateImage.url'/>" alt="${productName}"/>
            </c:when>
            <c:otherwise> 
              <%-- Link The Image --%>
              <dsp:getvalueof var="templateUrl" param="product.template.url"/>
              <c:choose>
                <c:when test="${not empty templateUrl}">
                  <%-- Product Template is set --%>
                  <dsp:getvalueof var="alternateImageUrl" vartype="java.lang.String" param="alternateImage.url"/>
				  
				  <%-- make sure the httpserver is set before making the image url --%>
				  <c:choose>
                    <c:when test="${empty httpserver}">
                        <dsp:getvalueof var="imageurl" vartype="java.lang.String" value="${alternateImageUrl}"/>
				    </c:when>
                    <c:otherwise>
					    <dsp:getvalueof var="imageurl" vartype="java.lang.String" value="${httpserver}${alternateImageUrl}"/>
				    </c:otherwise>
                  </c:choose>

                  <c:choose>
                    <c:when test="${displayAslink || empty displayAslink}">
                      <dsp:include page="/global/gadgets/crossSiteLink.jsp">
                        <dsp:param name="item" param="commerceItem"/>
                        <dsp:param name="imgUrl" value="${imageurl}"/>
                      </dsp:include>
                    </c:when>
                    <c:otherwise>
                      <dsp:img  src="${imageurl}" alt="${productName}"></dsp:img>
                    </c:otherwise>
                  </c:choose>

                </c:when>
                <c:otherwise>
                  <%-- Product Template not set --%>
                  <img src="<dsp:valueof param='httpserver'/><dsp:valueof param='alternateImage.url'/>" alt="${productName}"/>
                </c:otherwise>
              </c:choose>
              
            </c:otherwise>
          </c:choose><%-- End are we to link the image --%>
          
        </c:otherwise>
      </c:choose><%-- End is empty check on Sku --%>
                  
        
     </dsp:oparam>
   </dsp:droplet><%-- End Cache Droplet --%>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productImgCart.jsp#2 $$Change: 635969 $--%>
