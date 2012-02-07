<dsp:page>

  <%--
    Layout page for managing a user's saved addresses (their address book).
  --%>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/util/MapToArrayDefaultFirst"/>

  <crs:pageContainer divId="atg_store_accountEditProfileIntro" index="false" follow="false" bodyClass="atg_store_myAccountPage atg_store_leftCol">    
    <jsp:body>
      <div class="atg_store_nonCatHero"><h2 class="title"><fmt:message key="myaccount_addressBook.title"/></h2></div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="ADDRESS BOOK" />
      </dsp:include>
  
      <div class="atg_store_myAccount atg_store_main">
      
        <%-- Display errors if any --%>
        <div id="atg_store_formValidationError">        
          <dsp:include page="/global/gadgets/errorMessage.jsp">
            <dsp:param name="formHandler" bean="B2CProfileFormHandler"/>
            <dsp:param name="divid" value="errorMessage"/>
          </dsp:include>
        </div>

        <!-- ****************** begin saved shipping addresses ****************** -->
        <div id="atg_store_addressBookDefault" class="atg_store_savedAddresses">
          <dsp:getvalueof id="requestURL" idtype="java.lang.String" bean="/OriginatingRequest.requestURI"/>
      
          <%-- Iterate through all this user's shipping addresses, sorting the array so that the
               default shipping address is first. --%>
          <dsp:droplet name="MapToArrayDefaultFirst">
            <dsp:param name="defaultId" bean="Profile.shippingAddress.repositoryId"/>
            <dsp:param name="map" bean="Profile.secondaryAddresses"/>
            <dsp:param name="sortByKeys" value="true"/>
            <dsp:oparam name="output">
              <c:set var="counter" value="0"/>
              <dsp:getvalueof var="sortedArray" vartype="java.lang.Object" param="sortedArray"/>
              <c:choose>
                <c:when test="${empty sortedArray}">
                  <crs:messageContainer titleKey="myaccount_addressBookDefault.noShippingAddress">
                    <jsp:body>
                      <div class="atg_store_formActions">
                        <!-- ****************** Link to Add a New Address page  ****************** -->
                        <dsp:a page="/myaccount/accountAddressEdit.jsp" iclass="atg_store_basicButton">
                          <dsp:param name="successURL" bean="/OriginatingRequest.requestURI"/>
                          <dsp:param name="firstLastRequired" value="true"/>
                          <dsp:param name="addEditMode" value="add"/>
                          <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
                          <span><fmt:message key="myaccount_addressEdit.newAddress"/></span>
                        </dsp:a>
                      </div>
                    </jsp:body>
                  </crs:messageContainer>
                </c:when>
                <c:otherwise>
                  <c:forEach var="shippingAddress" items="${sortedArray}">
                    <dsp:setvalue param="shippingAddress" value="${shippingAddress}"/>
                    <c:if test="${not empty shippingAddress}">
                      <c:set var="count" value="0"/>
                      <dsp:droplet name="Compare">
                        <dsp:param name="obj1" bean="Profile.shippingAddress.repositoryId"/>
                        <dsp:param name="obj2" param="shippingAddress.value.id"/>
                        <dsp:oparam name="equal">
                          <c:set var="isDefault" value="true"/>
                        </dsp:oparam>
                        <dsp:oparam name="default">
                          <c:set var="isDefault" value="false"/>
                        </dsp:oparam>
                      </dsp:droplet>
      
                      <%-- Display Address Details --%>
                      <div class="atg_store_addressGroup${isDefault ? ' atg_store_addressGroupDefault' : ''}">
                        <c:set var="counter" value="${counter + 1}"/>
                        <dl>
                          <%-- Show Default Label if it is the default value --%>
                          <c:choose>
                            <c:when test="${isDefault}">
                              <dt class="atg_store_defaultShippingAddress">
                                <dsp:valueof param="shippingAddress.key"/>
                                <fmt:message var="defaultAddressTitle" key="common.defaultShipping"/>
                                                          
                                <dsp:a page="/myaccount/profileDefaults.jsp" title="${defaultAddressTitle}">
                                  <span>${defaultAddressTitle}</span>
                                </dsp:a>
                                         
                              </dt>             
                            </c:when>
                            <c:otherwise>
                              <dt><dsp:valueof param="shippingAddress.key"/></dt>
                            </c:otherwise>
                          </c:choose>
      
                      
                          <dd>
                            <dsp:include page="/global/util/displayAddress.jsp" flush="false">
                              <dsp:param name="address" param="shippingAddress.value"/>
                              <dsp:param name="private" value="false"/>
                            </dsp:include>
                          </dd>
                        </dl>
      
                        <%-- Display Edit/Remove/MakeDefault Links --%>
                        <ul class="atg_store_storedAddressActions">
                          <fmt:message var="editAddressTitle" key="common.button.editAddressTitle"/>
                          <c:set var="count" value="${count + 1}"/>
                          <li class="<crs:listClass count="${count}" size="2" selected="false"/>">
                            <dsp:a title="${editAddressTitle}"
                                   iclass="atg_store_addressBookDefaultEdit"
                                   bean="B2CProfileFormHandler.editAddress"
                                   page="/myaccount/accountAddressEdit.jsp" paramvalue="shippingAddress.key">
                              <dsp:param name="successURL" bean="/OriginatingRequest.requestURI"/>
                              <dsp:param name="addEditMode" value="edit"/>
                              <span><fmt:message key="common.button.editAddressText"/></span>
                            </dsp:a>
                          </li>
      
                          <fmt:message var="removeAddressTitle" key="myaccount_addressBookDefault.button.removeAddressTitle"/>
                          <c:set var="count" value="${count + 1}"/>
                          <li class="<crs:listClass count="${count}" size="2" selected="false"/>">
                            <dsp:a title="${removeAddressTitle}"
                                   iclass="atg_store_addressBookDefaultRemove"
                                   bean="B2CProfileFormHandler.removeAddress"
                                   href="${requestURL}" paramvalue="shippingAddress.key">
                             <span><fmt:message key="myaccount_addressBookDefault.button.removeAddressText"/></span>
                            </dsp:a>
                          </li>
                          
                        </ul>
                      </div>
                     
                      
                    </c:if>
                  </c:forEach>
                   <div class="atg_store_formActions">

                      <!-- ****************** Link to Add a New Address page  ****************** -->
                      <dsp:a page="/myaccount/accountAddressEdit.jsp" iclass="atg_store_basicButton">
                        <dsp:param name="successURL" bean="/OriginatingRequest.requestURI"/>
                        <dsp:param name="firstLastRequired" value="true"/>
                        <dsp:param name="addEditMode" value="add"/>
                        <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
                        <span><fmt:message key="myaccount_addressEdit.newAddress"/></span>
                      </dsp:a>
                    </div>
                </c:otherwise>
              </c:choose>
            </dsp:oparam>
          </dsp:droplet> <%-- MapToArrayDefaultFirst (sort saved addresses) --%>
      
        <!-- ******************* end saved shipping addresses ******************* -->
        </div>
        
        
      </div> 
    </jsp:body>
  </crs:pageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/addressBook.jsp#1 $$Change: 633540 $--%>
