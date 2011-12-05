<dsp:page>

  <%-- This page displays the saved credit cards for the user's account. --%>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/util/MapToArrayDefaultFirst"/>

  <dsp:getvalueof id="requestURL" idtype="java.lang.String" bean="/OriginatingRequest.requestURI"/>
  <dsp:getvalueof id="cancelURL" idtype="java.lang.String" bean="/OriginatingRequest.requestURI"/>

  <%-- Iterate through all this user's credit cards, sorting the array so that the
       default credit card is first. --%>
  <dsp:droplet name="MapToArrayDefaultFirst">
    <dsp:param name="defaultId" bean="Profile.defaultCreditCard.repositoryId"/>
    <dsp:param name="sortByKeys" value="true"/>
    <dsp:param name="map" bean="Profile.creditCards"/>
    <dsp:oparam name="output">
     <dsp:getvalueof var="sortedArray" vartype="java.lang.Object" param="sortedArray"/> 
      <c:choose>
        <c:when test="${not empty sortedArray}">
          <div id="atg_store_storedCreditCards">
          <c:forEach var="element" items="${sortedArray}">
              <dsp:setvalue param="creditCard" value="${element}"/>

              <dsp:getvalueof var="creditCard" param="creditCard"/>
              <c:if test="${not empty creditCard}">

                <c:set var="count" value="0"/>
                <c:set var="numberLinks" value="2"/>
                <dsp:droplet name="Compare">
                  <dsp:param name="obj1" bean="Profile.defaultCreditCard.repositoryId"/>
                  <dsp:param name="obj2" param="creditCard.value.id"/>
                  <dsp:oparam name="equal">
                    <c:set var="isDefault" value="true"/>
                  </dsp:oparam>
                  <dsp:oparam name="default">
                    <c:set var="isDefault" value="false"/>
                  </dsp:oparam>
                </dsp:droplet>

                <%-- Display Credit Card Details --%>
                <div class="atg_store_paymentInfoGroup${isDefault ? ' atg_store_paymentInfoGroupDefault' : ''}">
                  <c:set var="counter" value="${counter + 1}"/>
                  <dl>
                    <%-- Show Default Label if it is the default value --%>
                    <c:choose>
                      <c:when test="${isDefault}">
                          <dt class="atg_store_defaultCreditCard">
                            <dsp:valueof param="creditCard.key"/>
                              <dsp:a page="/myaccount/profileDefaults.jsp" title="${defaultAddressTitle}">
                                <span><fmt:message key="common.default"/></span>
                              </dsp:a>
                          </dt>
                      </c:when>
                      <c:otherwise>
                        <dt><dsp:valueof param="creditCard.key"/></dt>
                      </c:otherwise>
                    </c:choose>

                    <%-- Display Credit Card Details --%>
                
                      <dsp:include page="/global/util/displayCreditCard.jsp" flush="false">
                        <dsp:param name="creditCard" param="creditCard.value"/>
                        <dsp:param name="displayCardHolder" value="true"/>
                      </dsp:include>
                  
                  </dl>

                  <ul class="atg_store_storedCreditCardsActions">
                    <%-- Display Edit/Remove/MakeDefault Links --%>
                    <fmt:message var="editCardTitle" key="common.button.editCardTitle"/>
                    <c:set var="count" value="${count + 1}"/>
                    <li class="<crs:listClass count="${count}" size="${numberLinks}" selected="false"/>">
                      <dsp:a bean="B2CProfileFormHandler.editCard" page="../accountCardEdit.jsp"
                           paramvalue="creditCard.key" title="${editCardTitle}">
                        <dsp:param name="successURL" bean="/OriginatingRequest.requestURI"/>
                        <dsp:param name="cancelURL" value="${cancelURL}?preFillValues=false"/>
                        <span><fmt:message key="common.button.editText"/></span>
                      </dsp:a>
                    </li>

                    <fmt:message var="removeCardTitle" key="myaccount_storedCreditCards.removeCardTitle"/>
                    <c:set var="count" value="${count + 1}"/>
                    <li class="<crs:listClass count="${count}" size="${numberLinks}" selected="false"/>">
                      <dsp:a bean="B2CProfileFormHandler.removeCard" href="${requestURL}"
                          paramvalue="creditCard.key" title="${removeCardTitle}">
                       <span><fmt:message key="common.button.removeText"/></span>
                      </dsp:a>
                    </li>
                  </ul>
                </div>
  
              </c:if>
          </c:forEach>
          <dsp:include page="onlineCredits.jsp"/>
          <div class="atg_store_formActions">
            <dsp:a page="../newCreditCard.jsp" iclass="atg_store_basicButton">
              <span><fmt:message key="myaccount_paymentInfoCardAddEdit.addNewCreditCard"/></span>
            </dsp:a>
          </div>
          </div>
        </c:when>
        <c:otherwise>
        
        <crs:messageContainer titleKey="myaccount_storedCreditCards.noStoredCreditCards">
          <jsp:body>
            <dsp:include page="onlineCredits.jsp"/>
            <div class="atg_store_formActions">
              <dsp:a page="../newCreditCard.jsp" iclass="atg_store_basicButton">
                <span><fmt:message key="myaccount_paymentInfoCardAddEdit.addNewCreditCard"/></span>
              </dsp:a>
            </div>
          </jsp:body>   
        </crs:messageContainer>

        </c:otherwise>
      </c:choose>
    </dsp:oparam>
  </dsp:droplet> <%-- MapToArrayDefaultFirst (sort saved credit cards) --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/storedCreditCards.jsp#1 $$Change: 633540 $--%>
