<dsp:page>

  <%-- This page displays the confirmatory message to the shopper that the email has been dispatched. 
       Parameters - 
       - productId - Repository Id of the Product which is to be emailed 
       - categoryId - Repository Id of the Category to which the chosen Product belongs
  --%>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale" var="requestLocale"/>
  <dsp:importbean bean="/atg/store/order/purchase/ContinueShoppingFormHandler"/>
  <dsp:importbean bean="/atg/store/catalog/EmailAFriendFormHandler"/>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>

  <div id="atg_store_emailConfirm">

    <dsp:droplet name="ProductLookup">
      <dsp:param name="id" param="productId"/>
      <dsp:oparam name="output">

        <%-- Name a product parameter so we can keep track of things --%>
        <dsp:setvalue param="product" paramvalue="element"/>

        <%-- Show confirmation message --%>
        <h2 class="atg_store_subHeadCustom">
          <fmt:message key="browse_emailAFriendConfirm.messageSent" />
        </h2>

        <dsp:getvalueof var="var_recipientName" vartype="java.lang.String" param="recipientName"/>
        <dsp:getvalueof var="var_recipientEmail" vartype="java.lang.String" param="recipientEmail"/>

        <p>
          <%--
            Email sent confirmation message. Display recipient name and email escaping
            XML specific characters to prevent using them for XSS attacks.
          --%>
          <fmt:message key="browse_emailAFriendConfirm.emailDelivered">
            <fmt:param value="${fn:escapeXml(var_recipientName)}"/>
            <fmt:param value="${fn:escapeXml(var_recipientEmail)}"/>
            <fmt:param>
              <dsp:include page="/browse/gadgets/productName.jsp">
                <dsp:param name="showAsLink" value="false"/>
              </dsp:include>
            </fmt:param>
          </fmt:message>
        </p>

        <fmt:message var="continueButtonText" key="common.closeWindowText"/>
     

          <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="product.template.url"/>
          <c:choose>
            <c:when test="${not empty pageurl}">
              <%-- Product Template is set --%>
              <div class="atg_store_formActions">
              <dsp:a href="#" iclass="atg_store_basicButton" onclick="window.close();">
                <span>${continueButtonText}</span>
              </dsp:a>
              </div>
            </c:when>
            <c:otherwise>
              <%-- Product Template not set --%>
              <dsp:a page="/index.jsp">
                ${continueButtonText}
              </dsp:a>
            </c:otherwise>
          </c:choose>
 

      </dsp:oparam>
      <dsp:oparam name="empty">
        <fmt:message key="common.productNotFound">
          <fmt:param>
            <dsp:valueof param="productId">
              <fmt:message key="common.productIdDefault"/>
            </dsp:valueof>
          </fmt:param>
        </fmt:message>
      </dsp:oparam>
    </dsp:droplet>

  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/emailAFriendConfirm.jsp#2 $$Change: 635969 $--%>
