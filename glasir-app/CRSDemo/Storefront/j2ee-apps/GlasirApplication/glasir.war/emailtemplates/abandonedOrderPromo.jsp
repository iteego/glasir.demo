<dsp:page>

  <dsp:importbean bean="/atg/store/StoreConfiguration"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/registry/RepositoryTargeters/ProductCatalog/AbandonedOrderPromotion"/>
  <dsp:importbean bean="/atg/targeting/TargetingFirst"/>

  <dsp:getvalueof var="serverName" vartype="java.lang.String" bean="StoreConfiguration.siteHttpServerName"/>
  <dsp:getvalueof var="serverPort" vartype="java.lang.String" bean="StoreConfiguration.siteHttpServerPort"/>
  <dsp:getvalueof var="httpServer" vartype="java.lang.String" value="http://${serverName}:${serverPort}"/>
  <dsp:getvalueof var="serverURL" vartype="java.lang.String" value="${httpServer}/crsdocroot/"/>  
  
  <dsp:getvalueof var="promotionFromAddress" bean="Site.promotionEmailAddress" />

  <fmt:message var="emailSubject" key="emailtemplates_abandonedOrderPromo.subject">
    <fmt:param>
      <dsp:valueof bean="Site.name" />
    </fmt:param>
  </fmt:message>

  <crs:emailPageContainer divId="atg_store_abandonedOrderPromoIntro" 
        messageSubjectString="${emailSubject}"
        messageFromAddressString="${promotionFromAddress}">

    <%-- 
    ----------------------------------------------------------------
    Begin Main Content
    ----------------------------------------------------------------
    --%>

    <table border="0" cellpadding="0" cellspacing="0" width="609" style="font-size:14px;margin-top:0px;margin-bottom:30px">
      <tr>
        <td style="color:#666;font-family:Tahoma,Arial,sans-serif;">
          <fmt:message key="emailtemplates_abandonedOrderPromo.greeting">
            <fmt:param>
              <dsp:valueof bean="Profile.firstName"/>
            </fmt:param>
          </fmt:message>

          <br /><br />
          <fmt:message key="emailtemplates_abandonedOrderPromo.discountOnNextOrder">
            <fmt:param>
              <dsp:valueof bean="Site.name" />
            </fmt:param>
          </fmt:message>
          <br /><br />

          <dsp:droplet name="TargetingFirst">
            <dsp:param name="fireViewItemEvent" value="false"/>
            <dsp:param name="targeter" bean="AbandonedOrderPromotion"/>
            <dsp:oparam name="output">
              <dsp:getvalueof var="promotionBanner" param="element.derivedImage"/>
              <dsp:include page="/emailtemplates/gadgets/emailSiteLinkDisplay.jsp">
                <dsp:param name="path" value="/index.jsp"/>
                <dsp:param name="httpserver" value="${httpServer}"/>
                <dsp:param name="imageUrl" value="${httpServer}${promotionBanner}"/>
              </dsp:include>

            </dsp:oparam>
          </dsp:droplet>

        </td>
      </tr>
    </table>

    <%-- 
    ----------------------------------------------------------------
    End Main Content
    ----------------------------------------------------------------
    --%>

  </crs:emailPageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/abandonedOrderPromo.jsp#1 $$Change: 633540 $--%>