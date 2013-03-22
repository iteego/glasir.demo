<dsp:page>

  <%-- This page renderers details of Online Credit 
       Parameters:
 --%>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/claimable/AvailableStoreCredits"/>

      <dsp:droplet name="AvailableStoreCredits">
        <dsp:param name="profile" bean="Profile"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="onlineCredits" vartype="java.lang.Object" param="storeCredits"/>
          <div id="atg_store_onlineCredits">
            <fmt:message key="myaccount_onlineCredits.savedOnlineCredits"/>
              
            <c:set var="overallAmount" value="0"/>  
            <c:forEach var="onlineCredit" items="${onlineCredits}" varStatus="onlineCreditStatus">
              <dsp:setvalue param="storeCredit" value="${onlineCredit}"/>
              <dsp:getvalueof var="storeCredit" param="storeCredit"/>
              
              <c:if test="${not empty storeCredit}">
                <dsp:getvalueof var="amountRemaining" vartype="java.lang.Double" param="storeCredit.amountAvailable"/>
                <c:set var="overallAmount" value="${overallAmount + amountRemaining}"/>
              </c:if>
            </c:forEach>
            
            <span class="atg_store_onlineCreditTotal">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                 <dsp:param name="price" value="${overallAmount }"/>
               </dsp:include>
            </span>
            
          </div>
        </dsp:oparam>
      </dsp:droplet> 
   
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/onlineCredits.jsp#2 $$Change: 635969 $--%>
