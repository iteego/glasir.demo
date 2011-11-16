<dsp:page>
  
  <%--
        This gadget displays gift shipping destination address and
        allows to choose shipping method for it. Used only for one
        when only items from one gift lists are in the shopping cart.
        If shopping cart contains non gift items or gift items from
        different gift lists, multiple shipping page should be used
        to specify shipping details. 
  --%>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/commerce/pricing/AvailableShippingMethods"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  
  <dsp:form id="atg_store_checkoutShippingAddress"
            iclass="atg_store_checkoutOption"
            formid="atg_store_checkoutShippingAddress"
            action="${originatingRequest.contextPath}/checkout/shippingSingle.jsp"
            method="post">
             
    <%-- Include hidden form params --%>
    <dsp:include page="shippingFormParams.jsp" flush="true"/>
    
    <%-- Iterate through gift shipping groups --%>
    <dsp:getvalueof var="giftShippingGroups" vartype="java.lang.Object" bean="ShippingGroupFormHandler.giftShippingGroups"/> 
    <c:if test="${not empty giftShippingGroups}">
      
      <c:forEach var="giftShippingGroup" items="${giftShippingGroups}" varStatus="status">
        <dsp:param name="giftShippingGroup" value="${giftShippingGroup}"/>     
   
        <fieldset class="atg_store_chooseShippingAddresses">
                              
          <h2><fmt:message key="checkout_shippingGifts.giftShippingDestinations"/></h2>
          
          <dsp:param name="shippingAddress" param="giftShippingGroup.shippingAddress"/>
            <%-- Address information --%>
            <div id="atg_store_giftShippingAddress">
               
              <dsp:include page="/global/gadgets/shippingAddressView.jsp" flush="false">
                <dsp:param name="address" param="shippingAddress"/>
              </dsp:include> 
            </div>
          </fieldset>
          
          <%-- Include available shipping methods --%> 
          <dsp:include page="shippingOptions.jsp">
            <dsp:param name="shippingGroup" param="giftShippingGroup"/>
          </dsp:include>  
        </div>        
      </c:forEach>
    </c:if>
    
    <%-- Display submit button --%>
    <fieldset class="atg_store_checkoutContinue">
       
      <fmt:message var="continueButtonText" key="common.button.continueCheckoutText"/>
      <span class="atg_store_basicButton">
        <dsp:input type="submit"  bean="ShippingGroupFormHandler.moveToBilling" value="${continueButtonText}"/>
      </span>
    </fieldset>
  
  </dsp:form>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingGifts.jsp#2 $$Change: 635969 $--%>
