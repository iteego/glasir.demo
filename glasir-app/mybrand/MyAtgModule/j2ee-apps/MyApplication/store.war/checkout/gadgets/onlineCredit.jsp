<dsp:page>

  <%-- 
      This gadget renders the shopper's online credits as payment options 
  --%>

  <dsp:importbean bean="/atg/commerce/claimable/AvailableStoreCredits"/>  
  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>

  <dsp:droplet name="Compare">
    <dsp:param bean="Profile.securityStatus" name="obj1" converter="number"/>
    <dsp:param bean="PropertyManager.securityStatusBasicAuth" name="obj2" converter="number"/>
    <dsp:oparam name="greaterthan">

      <%-- User has explicitly logged in --%>
          <dsp:droplet name="AvailableStoreCredits">
            <dsp:param name="profile" bean="Profile"/>
            <dsp:oparam name="output">

              <dsp:getvalueof var="onlineCredits" vartype="java.lang.Object" param="storeCredits"/> 
              <c:choose>
                <c:when test="${not empty onlineCredits}">
                  
                      <c:set var="overallAmount" value="0"/>  
                      <c:forEach var="onlineCredit" items="${onlineCredits}" varStatus="onlineCreditStatus">
                        <dsp:setvalue param="storeCredit" value="${onlineCredit}"/>
                        <dsp:getvalueof var="storeCredit" param="storeCredit"/>
                        
                        <c:if test="${not empty storeCredit}">
                          <dsp:getvalueof var="amountRemaining" vartype="java.lang.Double" param="storeCredit.amountAvailable"/>
                          <c:set var="overallAmount" value="${overallAmount + amountRemaining}"/>
                        </c:if>
                      </c:forEach>
                      
                      <c:set var="storeCreditAmount" scope="request" value="${overallAmount}" />
                      
                </c:when>
              </c:choose>

            </dsp:oparam> 
          </dsp:droplet> <%-- OnlineCredits --%>
          
    </dsp:oparam>
  </dsp:droplet><%-- End check user's security status --%>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/onlineCredit.jsp#2 $$Change: 635969 $--%>
