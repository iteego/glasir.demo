<%-- This page displays the shipping addresses that user can choose for editing. --%>

<dsp:page>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupContainerService"/>
  
  <crs:pageContainer divId="atg_store_cart"
                     index="false" 
                     follow="false"
                     bodyClass="atg_store_checkoutEditAddresses atg_store_checkout atg_store_rightCol">
    <jsp:body>
      <fmt:message key="checkout_title.checkout" var="title"/>
      <crs:checkoutContainer currentStage="shipping"
                             showOrderSummary="true" 
                             title="${title}">
        <jsp:body>
          
          <div id="atg_store_checkout" class="atg_store_main">
                
            
          
            <!-- ****************** begin saved shipping addresses ****************** -->
         
                    
              <%-- Iterate through all this user's shipping addresses, sorting the array so that the
                   default shipping address is first. --%>
              <dsp:getvalueof var="shippingGroupMap" vartype="java.lang.Object" bean="ShippingGroupContainerService.shippingGroupMap"/>
              <dsp:getvalueof var="defaultShippingNickname" vartype="java.lang.String" bean="ShippingGroupContainerService.defaultShippingGroupName"/>
              <c:choose>
                <c:when test="${empty shippingGroupMap}">
                  <crs:messageContainer
                    titleKey="myaccount_addressBookDefault.noShippingAddress">
                    <jsp:body>
                      <div class="atg_store_formActions">
                        <!-- ****************** Cancel link / Return back to Multiple shipping page  ****************** -->
                        <dsp:a page="/checkout/shippingMultiple.jsp" iclass="atg_store_basicButton secondary">
                          <span><fmt:message key="common.button.cancelText"/></span>
                        </dsp:a>
                      </div>
                    </jsp:body>
                  </crs:messageContainer>
                </c:when>
                <c:otherwise>
                  <%-- display default shipping address first --%>
                  <div id="atg_store_shippingAddresses" class="atg_store_savedAddresses">
                   <h3><fmt:message key="checkout_shippingMultipleDestinations.editAddresses"/></h3>
                   <div id="atg_store_storedAddresses">
                  <dsp:include page="gadgets/shippingGroupDetails.jsp">
                    <dsp:param name="shippingGroup" value="${shippingGroupMap[defaultShippingNickname]}"/>
                    <dsp:param name="shippingAddressNickname" value="${defaultShippingNickname}"/>
                    <dsp:param name="isDefault" value="true"/>
                    <dsp:param name="editShippingAddressSuccessURL" value="/checkout/shippingMultiple.jsp"/>
                    <dsp:param name="removeShippingAddressSuccessURL" value="/checkout/shippingMultiple.jsp?init=true"/>
                  </dsp:include>                
                 
                  
                  <%-- Display the remaining non-default shipping addresses --%>
                  <c:forEach var="shippingGroupMapEntry" items="${shippingGroupMap}">
                    
                    <dsp:getvalueof var="shippingAddressNickname" value="${shippingGroupMapEntry.key}"/>
  
                    <c:if test='${shippingAddressNickname != defaultShippingNickname}'>
                      <dsp:include page="gadgets/shippingGroupDetails.jsp">
                        <dsp:param name="shippingGroup" value="${shippingGroupMapEntry.value}"/>
                        <dsp:param name="shippingAddressNickname" value="${shippingAddressNickname}"/>
                        <dsp:param name="isDefault" value="false"/>
                        <dsp:param name="editShippingAddressSuccessURL" value="/checkout/shippingMultiple.jsp"/>
                        <dsp:param name="removeShippingAddressSuccessURL" value="/checkout/shippingMultiple.jsp?init=true"/>
                      </dsp:include>
                    </c:if><%-- check for non-default shipping address --%>
                      
                  </c:forEach><%-- end loop through shipping addresses --%>
                  </div>
                   </div>
                  <div class="atg_store_formActions">

                    <!-- ****************** Cancel link / Return back to Multiple shipping page  ****************** -->
                    <dsp:a page="/checkout/shippingMultiple.jsp" iclass="atg_store_basicButton secondary">
                      <span><fmt:message key="common.button.cancelText"/></span>
                    </dsp:a>
                  </div>
                </c:otherwise>
              </c:choose>
                   
              <!-- ******************* end saved shipping addresses ******************* -->
            
        
            
          </div>
        </jsp:body>
      </crs:checkoutContainer>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/editShippingAddresses.jsp#1 $$Change: 633540 $--%>
