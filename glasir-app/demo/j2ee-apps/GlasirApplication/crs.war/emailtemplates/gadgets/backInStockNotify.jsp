<dsp:page>

  <%-- This page expects the following parameters
       1. productId - the id of the product thats back in stock
    --%>

  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>
  <dsp:importbean bean="/atg/store/StoreConfiguration"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>

  <%-- Set email template parameters --%>
  <dsp:setvalue param="mailingName" value="BackInStockNotify"/>

  <dsp:getvalueof var="serverName" vartype="java.lang.String" bean="StoreConfiguration.siteHttpServerName"/>
  <dsp:getvalueof var="serverPort" vartype="java.lang.String" bean="StoreConfiguration.siteHttpServerPort"/>
  <dsp:getvalueof var="httpServer" vartype="java.lang.String" value="http://${serverName}:${serverPort}"/>

  <dsp:droplet name="ProductLookup">
    <dsp:param name="id" param="productId"/>
    <dsp:oparam name="output">          
      <%-- Name a product parameter so we can keep track of things --%>
      <dsp:setvalue param="product" paramvalue="element"/>
      <dsp:getvalueof var="productId" param="productId"/>
      <dsp:getvalueof var="categoryId" param="product.parentCategory.repositoryId"/>
      <dsp:getvalueof var="productName" vartype="java.lang.String" param="product.displayName"/>
      
      <%-- Get cross site link for product template --%>
      <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
        <dsp:param name="product" param="product"/>
        <dsp:param name="siteId" bean="/atg/multisite/Site.id"/>
        <dsp:param name="queryParams" value="productId=${productId}&categoryId=${categoryId}"/>
      </dsp:include>
          
      <dsp:getvalueof var="productUrl" value="${httpServer}${siteLinkUrl}"/>
      <dsp:getvalueof var="serverURL" vartype="java.lang.String" value="${httpServer}/crsdocroot/"/>

<%-- 
----------------------------------------------------------------
Begin Main Content
----------------------------------------------------------------
--%>

      <table border="0" cellpadding="0" cellspacing="0" width="100%" style="color:#666;font-family:Tahoma,Arial,sans-serif;">
      <%-- Begin Product Details --%>
      <tr>
        <td style="padding-top:30px;">
        <table border="0" cellpadding="0" cellspacing="0" style="color:#666;font-family:Verdana,Arial,sans-serif;font-size:14px">
          <tr>
            <td valign="top" style="width:250px;padding-left:16px;padding-right:16px">                     
              <dsp:getvalueof var="productSmallImageUrl" param="product.smallImage.url"/>
              <c:if test="${not empty productSmallImageUrl}">
                <a href="${productUrl}">
                <img src="<c:out value="${httpServer}"/><dsp:valueof param='product.smallImage.url'/>" width="250" border="0" alt="${productName}"><br />
                </a>
              </c:if>
            </td>
            <td valign="top" style="width:400px;padding-left:20px">
              <div style="margin-bottom:8px">
                <a href="${productUrl}" style="color:#0a3d56;font-size:16px;text-decoration:none;font-weight:bold">
                  <dsp:valueof param="product.displayName">
                    <fmt:message key="common.productNameDefault"/>
                  </dsp:valueof>
                </a>
              </div>
              
              <%-- Begin Product SKU Details --%>
              <dsp:include page="backInStockSkuDetails.jsp">
                <dsp:param name="product" param="product"/>
                <dsp:param name="productUrl" value="${productUrl }"/>                
                <dsp:param name="httpserver" value="${httpServer}"/>
              </dsp:include>
              <%-- End Product SKU Details --%>
              
              <div style="margin-top:8px;line-height:20px">
              <dsp:getvalueof var="longDescription" param="product.longDescription"/>
              <c:if test="${not empty longDescription}">
                <dsp:valueof param="product.longDescription" valueishtml="true">
                  <fmt:message key="common.longDescriptionDefault" />
                </dsp:valueof>
              </c:if>
              </div>
              
              <div style="margin-top:20px">
                <table border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><img src="<c:out value="${serverURL}"/>images/email/button_left.png" style="vertical-align:middle;"/></td>
                    <td align="center" style="background-color:#A3CAFF;padding-left:8px;padding-right:8px;text-align:center;font-family:Verdana,arial,sans-serif;font-size:12px;font-weight:bold">
                     
                      <dsp:include page="/emailtemplates/gadgets/emailSiteLink.jsp">
                        <dsp:param name="path" value="/cart/cart.jsp"/>
                        <dsp:param name="httpserver" value="${httpServer}"/>
                      </dsp:include>
                      
                      <%-- Add 'dcs_action' parameter with 'additemtocart' value to notify
                           the CommerceCommandServlet to add the specified item to cart. --%>
                      <c:url var="addToCartUrl" value="${siteLinkUrl}" >
                        <c:param name="dcs_action" value="additemtocart"/>
                        <c:param name="url_catalog_ref_id" ><dsp:valueof param="skuId" /></c:param>
                        <c:param name="url_product_id" ><dsp:valueof param="productId" /></c:param>
                        <c:param name="url_quantity" value="1"/>
                      </c:url> 
                      
                      <dsp:a  style="color:#FFFFFF;text-decoration:none" href="${addToCartUrl}">
                        <fmt:message key="emailtemplates_buttons.addToCart" />
                      </dsp:a>
               
                    </td>
                    <td><img src="<c:out value="${serverURL}"/>images/email/button_right.png" style="vertical-align:middle;"/></td>
                  </tr>
                </table>
              </div>
            </td>
          </tr>
        </table>
        </td> 
      </tr>
      <%-- End Product Details --%>
    </table>
     
   </dsp:oparam>
  </dsp:droplet>

<%-- 
----------------------------------------------------------------
End Main Content
----------------------------------------------------------------
--%>


</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/backInStockNotify.jsp#1 $$Change: 633540 $--%>
