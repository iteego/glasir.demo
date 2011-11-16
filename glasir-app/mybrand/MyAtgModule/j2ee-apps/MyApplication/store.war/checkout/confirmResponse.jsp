<%-- This page includes the gadgets for the final "success" page
     in the checkout process --%>

<dsp:page>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  
  <dsp:getvalueof var="transient" vartype="java.lang.String" bean="Profile.transient"/>
  <c:if test='${transient == "true"}'>
    <c:set var="contentClass" value="atg_store_confirmAndRegister"/>    
    <c:set var="bodyClass" value="Register"/>
  </c:if>
  
  <crs:pageContainer divId="atg_store_cart" index="false" follow="false" bodyClass="atg_store_confirmResponse${bodyClass} atg_store_checkout" contentClass="${contentClass}">
    <jsp:body>
      <div id="atg_store_checkout">
        <fmt:message key="checkout_title.orderPlaced" var="title"/>
        <crs:checkoutContainer showOrderSummary="false"
                               currentStage="success"
                               showProgressIndicator="false"
                               title="${title}">
          <jsp:body>
            <div id="atg_store_checkoutOption" class="atg_store_main">
              
              <%-- Offer registration for anonymous users --%>
              <dsp:droplet name="Compare">
              <dsp:param bean="Profile.securityStatus" name="obj1" converter="number"/>
              <dsp:param bean="PropertyManager.securityStatusBasicAuth" name="obj2" converter="number"/>
                <dsp:oparam name="greaterthan">
                  <dsp:include page="gadgets/confirmResponse.jsp"/>
                </dsp:oparam>
                <dsp:oparam name="lessthan">
                  <dsp:include page="gadgets/confirmAndRegister.jsp"/>
                  <c:set var="anonymous" value="true"/>
                </dsp:oparam>
              </dsp:droplet>
            </div>
            
            <%-- display benefits section outside of "atg_store_main" div for anonymous users --%>
            <c:if test="${anonymous}">
              <dsp:include page="/myaccount/gadgets/benefits.jsp"/>
            </c:if>
          </jsp:body>
         </crs:checkoutContainer>
       </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/confirmResponse.jsp#2 $$Change: 635969 $--%>
