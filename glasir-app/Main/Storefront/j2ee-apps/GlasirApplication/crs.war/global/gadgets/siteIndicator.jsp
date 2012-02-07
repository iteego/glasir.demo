<%--
  This gadget can be used to display an appropriate visual site indicator based on the supplied parameters.

  Input parameters are:
    mode (required) 
     The display mode for the site indicator, valid values are:
       name - the site indicator is the site name
       icon - the site indicator is the icon configured on the site
      
    siteId (optional)
      The site id value that will be used in preference when obtaining the site details for the indicator
      and in constructing the cross site link. If not present the site id associated with the product item 
      will be used if available, otherwise the site id of the current site will be used.

    product (optional)
      A product repository item used together with the site id to obtain the site details for the indicator
      and in constructing the cross site link.

    path (optional)
      Used to customize the url generated via SiteLinkDroplet. Ignored if 'asLink' is false (see below).

    queryParams (optional)
      Query parameters to incorporate into URL, used in conjunction with 'path' to customize the  
      url generated via SiteLinkDroplet. Ignored if 'asLink' is false (see below).

    asLink (optional) 
      Boolean flag specifying if site indicator is to be rendered as a link. Default is false.

    absoluteResourcePath (optional) 
      Boolean flag indicating if the full absolute server path to a resource such as icon image is 
      to be used. Default is false.
      For example, if 'absoluteResourcePath == true' the resource path will be of the form
        http://localhost:8080/crsdocroot/images/storefront/atgStore_logo_small.png
      otherwise the resource path will be of the form
        /crsdocroot/images/storefront/atgStore_logo_small.png
      This flag can be used, for example, in email generation where the site indicator in the email message
      will need the full resource path.

    displayCurrentSite (optional) 
      Boolean flag specifying if indicator should be displayed for the current site. Default is true.
      This can be used to turn off the site indicator display if for example the site id associated 
      with a product is the current site.

  Example usage:
    Some basic examples demonstrating how this gadget can be used are listed below.
    These examples are for illustration purposes only and do not represent existing workable CRS code.

    The following code snippet displays the icon image configured for the site with id 'storeSiteUS'. 
    If no site id parameter is specified then the icon image for the current site will be rendered.
      <dsp:include page="/global/gadgets/siteIndicator.jsp">
        <dsp:param name="mode" value="icon"/>              
        <dsp:param name="siteId" value="storeSiteUS"/>
      </dsp:include>

    This code example can be used to display the site indicator as the site name associated with the  
    site with id 'storeSiteUS', backed by an appropriate url based on the site and product.
      <dsp:include page="/global/gadgets/siteIndicator.jsp">
        <dsp:param name="mode" value="name"/>              
        <dsp:param name="siteId" value="storeSiteUS"/>
        <dsp:param name="product" param="productRef"/>
        <dsp:param name="asLink" value="true"/>
      </dsp:include>

    The code excerpt below can be used to display a site indicator for the site with the specified site id,
    backed by a customized url constructed from the appropriate context root for the site and the supplied
    page reference and parameters. Refer to SiteLinkDroplet javadoc for more information on constructing
    customized urls from the 'path' and 'queryParams'.
       <dsp:include page="/global/gadgets/siteIndicator.jsp">
        <dsp:param name="mode" value="icon"/>              
        <dsp:param name="siteId" value="storeSiteUS"/>
        <dsp:param name="asLink" value="true"/>
        <dsp:param name="path" value="/myaccount/orderDetail.jsp"/>
        <dsp:param name="queryParams" value="selpage='MY ORDERS'&orderId=xco30012"/>
      </dsp:include>

    The resulting url would be of the form:
      http://localhost:8080/crs/storeus/myaccount/orderDetail.jsp?selpage='MY ORDERS'&orderId=xco30012    

 --%>

<dsp:page>
  <dsp:importbean bean="/atg/multisite/Site" />
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet" />
  <dsp:importbean bean="/atg/commerce/multisite/SiteIdForCatalogItem"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />
  <dsp:importbean bean="/atg/store/StoreConfiguration" />


  <%--
    Obtain the page parameter values, if necessary setting any default values for any optional parameters.
  --%>
  <dsp:getvalueof var="mode" param="mode"/>
  <dsp:getvalueof var="siteId" param="siteId"/>
  <dsp:getvalueof var="product" param="product"/>
  <dsp:getvalueof var="path" param="path"/>
  <dsp:getvalueof var="queryParams" param="queryParams"/>

  <dsp:getvalueof var="asLink" param="asLink"/>
  <c:if test="${empty asLink}">
    <dsp:getvalueof var="asLink" value="false"/>
  </c:if>

  <dsp:getvalueof var="absoluteResourcePath" param="absoluteResourcePath"/>
  <c:if test="${empty absoluteResourcePath}">
    <dsp:getvalueof var="absoluteResourcePath" value="false"/>
  </c:if>

  <dsp:getvalueof var="displayCurrentSite" param="displayCurrentSite"/>
  <c:if test="${empty displayCurrentSite}">
    <dsp:getvalueof var="displayCurrentSite" value="true"/>
  </c:if>

  <dsp:getvalueof var="currentSiteId" bean="Site.id"/>


  <%--
    Determine the appropriate site id to use.
    If there is no specified site id or product, the site id for the current site is used.
    If there is a product but no site id then find most appropriate site id for the product.
    Otherwise a site id has been specified and we use this in preference.
  --%>
  <c:choose>
    <c:when test="${empty siteId && empty product}">
      <dsp:getvalueof var="siteId" value="${currentSiteId}"/>
    </c:when>
    <c:when test="${empty siteId && !empty product}">
      <dsp:droplet name="SiteIdForCatalogItem">
        <dsp:param name="item" value="${product}"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="siteId" param="siteId"/>
        </dsp:oparam>
      </dsp:droplet>
    </c:when>
    <c:otherwise>
      <%-- A 'siteId' page parameter was received, so for clarity obtain this value again. --%>
      <dsp:getvalueof var="siteId" param="siteId"/>
    </c:otherwise>
  </c:choose>

  <%--
    Only display the site indicator if the site id is not the current site or if 
    we are forcing this to be displayed.
  --%>
  <c:if test="${(siteId != currentSiteId) || displayCurrentSite}">
    <%--
      Retrieve the site details (name, icon) for the site with this site id.
    --%>
    <dsp:droplet name="GetSiteDroplet">
      <dsp:param name="siteId" value="${siteId}"/>
      <dsp:oparam name="output">
        <dsp:getvalueof var="siteName" param="site.name"/>
        <dsp:getvalueof var="siteIcon" param="site.siteIcon"/>
      </dsp:oparam>
    </dsp:droplet>

  
    <%--
      Construct the appropriate cross site link if the site indicator is to be backed by a link reference.
    --%>
    <dsp:getvalueof var="linkUrl" value=""/>
    <c:if test="${asLink}">
      <c:choose>
        <c:when test="${!empty product}">
          <%-- Obtain the cross site link for the site id and product.
               If a custom url has been supplied then use that as a basis for generating the link,
               otherwise generate the most appropriate link based on the site id and product. --%>
          <c:choose>
            <c:when test="${!empty path}">
              <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
                <dsp:param name="siteId" value="${siteId}"/>
                <dsp:param name="product" value="${product}"/>
                <dsp:param name="customUrl" value="${path}"/>
                <dsp:param name="queryParams" value="${queryParams}"/>
              </dsp:include>

              <dsp:getvalueof var="linkUrl" value="${siteLinkUrl}"/>
            </c:when>
            <c:otherwise>
              <dsp:include page="/global/gadgets/productLinkGenerator.jsp">
                <dsp:param name="siteId" value="${siteId}"/>
                <dsp:param name="product" value="${product}"/>
              </dsp:include>

              <dsp:getvalueof var="linkUrl" value="${productUrl}"/>
           </c:otherwise>
          </c:choose>
        </c:when>
        <c:otherwise>
          <%-- Obtain the link to the site with the specified site id.
               Simply link to the site's home page if no custom url has been supplied. --%>
          <c:if test="${empty path}">
            <dsp:getvalueof var="path" value="/"/>
          </c:if>

          <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
            <dsp:param name="siteId" value="${siteId}"/>
            <dsp:param name="customUrl" value="${path}"/>
            <dsp:param name="queryParams" value="${queryParams}"/>
          </dsp:include>

          <dsp:getvalueof var="linkUrl" value="${siteLinkUrl}"/>
        </c:otherwise>
      </c:choose>
    </c:if>

 
    <%--
      If required construct the full absolute server path for resources.
    --%>
    <dsp:getvalueof var="httpServer" value=""/>
    <c:if test="${absoluteResourcePath}">
      <dsp:getvalueof var="serverName" bean="StoreConfiguration.siteHttpServerName" />
      <dsp:getvalueof var="serverPort" bean="StoreConfiguration.siteHttpServerPort" />
      <dsp:getvalueof var="httpServer" value="http://${serverName}:${serverPort}" />
    </c:if>


    <%--
      Display the site indicator either as the site icon or the site name according to the 'mode' parameter value.
      The site indicator will be rendered backed with a link reference if 'asLink' is true.
    --%>
    <c:choose>
      <c:when test="${mode == 'icon'}">
        <%-- Display the icon configured on the site as the site indicator.
             'httpServer' will be populated only if 'absoluteResourcePath' is true; otherwise it will be empty string. --%>
        <c:choose>
          <c:when test="${asLink}">
            <dsp:a href="${linkUrl}">
              <dsp:img src="${httpServer}${siteIcon}"/>
            </dsp:a>
          </c:when>
          <c:otherwise>
            <dsp:img src="${httpServer}${siteIcon}"/>
          </c:otherwise>
        </c:choose>
      </c:when>
      <c:when test="${mode == 'name'}">
        <%-- Display the site name as the site indicator. --%>
        <fmt:message key="siteindicator.prefix" var="sitePrefix"/>
        <span class="siteIndicator">
          <c:choose>
            <c:when test="${asLink}">
              <dsp:a href="${linkUrl}">
                <span><dsp:valueof value="${sitePrefix}"/></span>
                <c:out value="${siteName}"/>
              </dsp:a>
            </c:when>
            <c:otherwise>
              <span><dsp:valueof value="${sitePrefix}"/></span>
              <c:out value="${siteName}"/>
            </c:otherwise>
          </c:choose>
        </span>
      </c:when>
      <c:otherwise>
        <%-- Fail silently as we have an invalid display mode. --%>
      </c:otherwise>
    </c:choose>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/siteIndicator.jsp#1 $$Change: 633540 $--%>