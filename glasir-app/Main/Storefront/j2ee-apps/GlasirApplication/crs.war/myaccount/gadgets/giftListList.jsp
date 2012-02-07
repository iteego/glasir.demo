<dsp:page>
<%-- this page,for a Profile, displays the giftList list if it exists  --%>


  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/collections/filter/droplet/GiftlistSiteFilterDroplet"/>


  <div id="atg_store_giftListList">
    
    <fmt:message var="giftListSummary" key="common.giftListSummary"/>
    <table summary="${giftListSummary}" cellspacing="0" cellpadding="0" class="atg_store_dataTable">
      <dsp:droplet name="GiftlistSiteFilterDroplet">
        <dsp:param name="collection"  bean="/atg/userprofiling/Profile.giftlists"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="giftlists" param="filteredCollection" />

          <thead>
            <tr>
              <th class="atg_store_giftlistEventName" scope="col"><fmt:message key="common.giftListTitle"/></th>
              <th class="atg_store_giftlistEventType" scope="col"><fmt:message key="common.type"/></th>
              <th class="atg_store_giftlistEventDate" scope="col"><fmt:message key="common.date"/></th>
              <th class="atg_store_giftlistEventItems" scope="col"><fmt:message key="myaccount_giftListAdd.privacySetting"/></th>
              <th class="atg_store_giftlistEventItems" scope="col"></th>
            </tr>
          </thead>
          <tbody>
            <dsp:getvalueof var="size" idtype="int" value="${fn:length(giftlists)}"/>
            <c:forEach var="giftlist" items="${giftlists}" varStatus="giftlistStatus">
              <dsp:getvalueof var="count" idtype="int" value="${giftlistStatus.count}"/>
              <dsp:getvalueof var="index" idtype="int" value="${giftlistStatus.index}"/>
              <dsp:param name="giftlist" value="${giftlist}"/>
                          
              <tr class="<crs:listClass count='${count}' size='${size}' selected='${index == currentSelection}'/>">
                <td class="atg_store_giftListName">
                  <dsp:getvalueof var="eventName" vartype="java.lang.String" param="giftlist.eventName"/>
                  <fmt:message var="viewListTitle" key="myaccount_giftListList.viewListTitle"/>
                  <dsp:a href="../giftListEdit.jsp" title="${viewListTitle}">
                    <dsp:param name="giftlistId" param="giftlist.repositoryId"/>
                    <c:out value="${eventName}"/>
                    <dsp:param name="selpage" value="GIFT LISTS"/>
                  </dsp:a>
                </td>
                <td valign="middle" class="atg_store_giftListType">
                  <dsp:getvalueof var="eventType" param="giftlist.eventType"/>
                  <c:set var="eventTypeResourceKey" value="${fn:replace(eventType, ' ', '')}"/>
                  <c:set var="eventTypeResourceKey" value="giftlist.eventType${eventTypeResourceKey}"/>
                  <fmt:message key="${eventTypeResourceKey}"/>
                </td>
                <td class="date numerical" valign="middle" class="atg_store_giftListDate">
                  <dsp:getvalueof var="eventDate" vartype="java.util.Date" param="giftlist.eventDate"/>
                  <fmt:formatDate value="${eventDate}" dateStyle="short"/>
                </td>            
                <td class="atg_store_giftListPrivacy">
                  <dsp:getvalueof var="isGiftListPublished" param="giftlist.published"/>
                  <c:choose>
                    <c:when test="${isGiftListPublished}">
                      <fmt:message key="myaccount_giftListAdd.public"/>
                    </c:when>
                    <c:otherwise>
                      <fmt:message key="myaccount_giftListAdd.private"/>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td valign="middle" align="right" class="atg_store_giftListEditRemove">
                  <fmt:message var="editTitle" key="myaccount_giftListList.button.editTitle"/>
                  <dsp:a href="../giftListEdit.jsp" title="${editTitle}" iclass="atg_store_giftListEdit">
                    <dsp:param name="giftlistId" param="giftlist.repositoryId"/>
                    <dsp:param name="selpage" value="GIFT LISTS"/>
                    <fmt:message key="common.button.editText"/>
                  </dsp:a>                    
                  
                  <fmt:message var="deleteTitle" key="myaccount_giftListList.button.deleteTitle"/>
                  <dsp:a href="../giftListHome.jsp"
                     value="" title="${deleteTitle}" iclass="atg_store_giftListRemove">
                    <dsp:param name="selpage" value="GIFT LISTS"/>
                    <%-- Load the values into the handler bean --%>
                    <dsp:property bean="GiftlistFormHandler.giftlistId" paramvalue="giftlist.repositoryId" name="gl_rId" />
                    <%-- Now call the method on the form handler bean --%>
                    <dsp:property bean="GiftlistFormHandler.deleteGiftlist" value="" />
                    <fmt:message key="common.button.removeText"/>
                  </dsp:a>
                </td>
              </tr>
            </c:forEach><%--End of ForEach--%>
          </tbody>
        </dsp:oparam>
        <dsp:oparam name="empty">
          <crs:messageContainer
            titleKey="myaccount_giftListList.availableGiftLists"
            messageKey="myaccount_giftListList.accountHaveNoGiftLists"/>
        </dsp:oparam>
      </dsp:droplet>
    </table>
    <%-- atg_store_giftListList --%>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/giftListList.jsp#2 $$Change: 633752 $ --%>

