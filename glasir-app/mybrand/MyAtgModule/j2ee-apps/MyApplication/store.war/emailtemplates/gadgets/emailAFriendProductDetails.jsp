<dsp:page>

  <%-- 
      This page displays the details related to the product referred 
      This page expects the following parameters  - 
      - product - Product to be featured 
      - productUrl - Url of the Product being emailed
      - isProductUrlEmpty - Boolean indicates whether template is set
  --%>

  <dsp:importbean var="storeConfig" bean="/atg/store/StoreConfiguration"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>

  <dsp:getvalueof var="var_productUrl" param="productUrl"/>
  <dsp:getvalueof var="isProductUrlEmpty" param="isProductUrlEmpty"/>
  <dsp:getvalueof var="productThumbnailImageUrl" param="product.thumbnailImage.url"/>
  <c:set var="httpServer" value="http://${storeConfig.siteHttpServerName}:${storeConfig.siteHttpServerPort}"/>
  <dsp:getvalueof var="serverURL" vartype="java.lang.String" value="${httpServer}/crsdocroot/"/>  

  <table border="0" cellpadding="0" cellspacing="0" style="padding-top:30px;color:#666;font-family:Tahoma,Arial,sans-serif;font-size:14px;">
    <tr>
    <fmt:message var="getDetailsTitleText" key="common.button.viewDetailsTitle"/>
    <fmt:message var="imageAltText" key="emailtemplates_emailAFriend.productImageAltText"/>
    <c:choose>
      <c:when test="${!isProductUrlEmpty}" >
        <td style="padding-right: 10px;">
          <c:choose>
            <c:when test="${not empty productThumbnailImageUrl}">
              <%-- Thumbnail image exists --%> 
              <dsp:a page="${var_productUrl}">
                <img src='<c:out value="${httpServer}" /><dsp:valueof param="product.thumbnailImage.url"/>' title="${getDetailsTitleText}" alt="${imageAltText}"/>
              </dsp:a>
            </c:when>
            <c:otherwise>
              <img src='<c:out value="${httpServer}" />/images/unavailable.gif' alt="${imageAltText}"/>
            </c:otherwise>
          </c:choose><%-- End is Product thumbnail image empty --%>
        </td>
        <td style="vertical-align: top;">
        <div style="margin-bottom: 8px;">
          <dsp:a href="${var_productUrl}" style="color:#0a3d56;font-size:16px;text-decoration:none;font-weight:bold">
            <dsp:valueof param="product.displayName" />
          </dsp:a>
        </div>
      </c:when>
      <c:otherwise>
          <td style="padding-right: 10px">
            <c:choose>
              <c:when test="${not empty productThumbnailImageUrl}">
                <%-- Thumbnail image exists --%> 
                  <img src='<c:out value="${httpServer}" /><dsp:valueof param="product.thumbnailImage.url"/>' title="${getDetailsTitleText}" border="0" alt="${imageAltText}"/>
              </c:when>
              <c:otherwise>
                <img src='<c:out value="${httpServer}" />/images/unavailable.gif' border="0" alt="${imageAltText}">
              </c:otherwise>
            </c:choose><%-- End is Product thumbnail image empty --%>
          </td>
          <td style="vertical-align: top;">
            <div style="color:#0a3d56;font-size:16px;text-decoration:none;font-weight:bold">
              <dsp:valueof param="product.displayName" />
            </div>
      </c:otherwise>
    </c:choose>

      <div style="margin-bottom: 5px;">
      <%-- Check the size of the sku array to see how we handle things --%>
      <dsp:getvalueof var="childSKUs" param="product.childSKUs"/>
      <c:set var="totalSKUs" value="${fn:length(childSKUs)}"/>
      
      <dsp:droplet name="Compare">
        <dsp:param name="obj1" value="${totalSKUs}" converter="number" />
        <dsp:param name="obj2" value="1" converter="number" />
        <dsp:oparam name="equal">
          <%-- Display Price --%>
          <dsp:param name="sku" param="product.childSKUs[0]" />
          <span style="color:orange;font-size:16px;font-weight:bold"><%@ include file="/emailtemplates/gadgets/priceLookup.jsp"%></span>
        </dsp:oparam>
        <dsp:oparam name="default">
          <%-- Display Price Range --%>
          <span style="font-size:16px;font-weight:bold"><%@ include file="/emailtemplates/gadgets/priceRange.jsp"%></span>
        </dsp:oparam>
      </dsp:droplet> 
      <%-- End Compare droplet to see if the product has a single sku --%>
      </div>
    <div style="margin-top:14px;margin-bottom:5px;">
      <dsp:valueof param="product.longDescription" valueishtml="true"></dsp:valueof>
    </div>

    <div style="margin-top:20px">
      <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td><img src="<c:out value="${serverURL}"/>images/email/button_left.png" style="vertical-align:middle;"/></td>
          <td align="center" style="background-color:#A3CAFF;padding-left:8px;padding-right:8px;text-align:center;font-family:Verdana,arial,sans-serif;font-size:12px;font-weight:bold"><a style="color:#FFFFFF;text-decoration:none" href="${var_productUrl}"><fmt:message key="emailtemplates_buttons.viewDetails" /></a></td>
          <td><img src="<c:out value="${serverURL}"/>images/email/button_right.png" style="vertical-align:middle;"/></td>
        </tr>
      </table>
    </div>

    </td>
    </tr>
  </table>

  <br />
  <br />
  <br />
  <br />

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailAFriendProductDetails.jsp#1 $$Change: 633540 $--%>
