<dsp:page>

<%--
  This gadget displays the results from giftlist search.
--%>

  <dsp:importbean bean="/atg/commerce/gifts/GiftlistSearch"/>

  <div id="atg_store_giftListSearchResults">
    <fmt:message var="giftListSummary" key="common.giftListSummary"/>    
    <dsp:getvalueof var="giftlistSearchResults" vartype="java.lang.Object" bean="GiftlistSearch.searchResults"/>

    <table class="atg_store_dataTable" summary="${giftListSummary}" cellspacing="0" cellpadding="0">
    
    <%-- Check for empty search results --%>
      <c:choose>
        <c:when test="${empty giftlistSearchResults || fn:length(giftlistSearchResults) == 0 }">
          <c:set var="noResults" value = "true"/>
        </c:when>
        <c:otherwise>
          <%-- Filter out invalid gift lists --%>
          <dsp:droplet name="/atg/store/droplet/GiftListFilterDroplet">
            <dsp:param name="collection" value="${giftlistSearchResults}"/>
            <dsp:oparam name="output">
              <dsp:getvalueof var="filteredGiftlistSearchResults" param="filteredCollection"/>
              <dsp:getvalueof var="size" vartype="java.lang.Integer" value="${fn:length(filteredGiftlistSearchResults)}"/>
              <%-- Check for empty filtered collection --%>
              <c:choose>
                <c:when test="${empty filteredGiftlistSearchResults || size == 0 }">
                  <c:set var="noResults" value = "true"/>
                </c:when>
                <c:otherwise>
              
                  <thead>
                    <tr>
                      <th scope="col" class="atg_store_event"><fmt:message key="giftlists_giftListSearchResults.recipient"/></th>
                      <th scope="col" class="atg_store_eventDescription"><fmt:message key="common.giftListTitle"/></th>
                      <th scope="col" class="atg_store_eventType"><fmt:message key="common.type"/></th>
                      <th scope="col" class="atg_store_date"><fmt:message key="common.date"/></th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="searchResult" items="${filteredGiftlistSearchResults}" varStatus="searchResultStatus">
                      <dsp:param name="giftlist" value="${searchResult}"/>
                      <dsp:getvalueof var="count" idtype="int" value="${searchResultStatus.count}"/>
                      <dsp:getvalueof var="index" idtype="int" value="${searchResultStatus.index}"/>
                      <tr class="<crs:listClass count='${count}' size='${size}' selected='false'/>">
                        <td class="atg_store_recipient">
                        
                          <%-- Display Recipient's name as linkt to gift list --%>
                          <dsp:getvalueof id="occassion" param="giftlist.eventName"/>
                          <dsp:a href="../giftListShop.jsp" title="${occassion}">
                            <dsp:param name="giftlistId" param="giftlist.repositoryId"/>
                            <span class="fn n">
                              <span class="given-name">
                                <dsp:valueof param="giftlist.owner.firstName"/>
                              </span>
                              <span class="additional-name">
                                <dsp:valueof param="giftlist.owner.middleName"/>
                              </span>
                              <span class="family-name">
                                <dsp:valueof param="giftlist.owner.lastName"/>
                              </span>
                            </span>
                            <dsp:param name="selpage" value="GIFT LISTS"/>
                          </dsp:a>
                        </td>
                        <td class="atg_store_eventDescription">
                          <dl>
                            <dt>
                              <dsp:valueof param="giftlist.eventName"/>
                            </dt>
                            <dd>
                              <dsp:valueof param="giftlist.description"/>
                            </dd>
                          </dl>
                        </td>
                        <td class="atg_store_eventType">
                          <dsp:getvalueof var="eventType" param="giftlist.eventType"/>
                          <c:set var="eventTypeResourceKey" value="${fn:replace(eventType, ' ', '')}"/>
                          <c:set var="eventTypeResourceKey" value="giftlist.eventType${eventTypeResourceKey}"/>
                          <fmt:message key="${eventTypeResourceKey}"/>
                        </td>
                        <td class="atg_store_date">
                          <dsp:getvalueof var="eventDate" vartype="java.util.Date" param="giftlist.eventDate"/>
                          <fmt:formatDate value="${eventDate}" dateStyle="short" />
                        </td>
                      </tr>
                    </c:forEach><%---end of ForEach--%>

                  </tbody>
                  
                </c:otherwise>
              </c:choose><%-- end of check for empty filtered results --%>
            </dsp:oparam>
          </dsp:droplet><%-- end of GiftListFilterDroplet--%>
        </c:otherwise>
      </c:choose><%---end of check for empty search results--%>
      </table>
 
 
      <c:if test="${noResults}">
        <crs:messageContainer titleKey="giftlists_giftListSearchResults.noMatchOfGift" />
       </c:if>
    
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/giftlists/gadgets/giftListSearchResults.jsp#2 $$Change: 633752 $ --%>
