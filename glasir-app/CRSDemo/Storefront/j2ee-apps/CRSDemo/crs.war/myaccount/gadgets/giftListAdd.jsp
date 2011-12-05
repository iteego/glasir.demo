<dsp:page>

  <%-- This page accepts the following input parameters

           -  gadgetTitle - title for either "add" or "edit" giftlist page.This  parameter is passed from either
              giftListHome.jsp or giftListEdit.jsp.

           - giftlistId - giftListId in case of edit giftList action. Passed from giftListEdit.jsp
           - initForm - if true, will initialize Gift list form with previously entered data
  --%>

  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler" var="giftlistFormHandler"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistLookupDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <dsp:getvalueof var="giftlistId" param="giftlistId"/>
  <dsp:getvalueof var="gadgetTitle" param="gadgetTitle"/>
  <dsp:getvalueof var="initForm" param="initForm"/>

  <c:url value="giftListHome.jsp" var="giftListHomeUrl" scope="page">
    <c:param name="selpage">GIFT LISTS</c:param>
  </c:url>

  <div id="atg_store_addGiftList">
    <%--
       we must first make sure the gift list is one that belongs to the user to prevent users from passing
       is a giftlistId that isn't theirs
     --%>
    <dsp:getvalueof var="giftlistId" param="giftlistId"/>
    <c:choose>
      <c:when test="${not empty giftlistId}">
        <dsp:droplet name="GiftlistLookupDroplet">
          <dsp:param name="id" param="giftlistId"/>
          <dsp:oparam name="output">

            <%-- make sure it's the owner trying to look at the list --%>
            <dsp:droplet name="Compare">
              <dsp:param name="obj1" bean="Profile.id"/>
              <dsp:param name="obj2" param="element.owner.id" />
              <dsp:oparam name="equal">
                <%-- set the giftlist in the form to populate the form properties for edit --%>
                <dsp:setvalue bean="GiftlistFormHandler.giftlist" paramvalue="element"/>
              </dsp:oparam>
            </dsp:droplet>

          </dsp:oparam>
        </dsp:droplet>
      </c:when>
      <c:otherwise>
        <dsp:getvalueof var="giftlistFormError" bean="GiftlistFormHandler.formError"/>
        <c:if test="${initForm}">
          <dsp:setvalue bean="GiftlistFormHandler.initializeGiftListForm" value=""/>
        </c:if>
        <c:if test="${!giftlistFormError && !initForm}">
          <dsp:setvalue bean="GiftlistFormHandler.clearForm" value=""/>
        </c:if>
      </c:otherwise>
    </c:choose>

    <%-- Determine which submit button text to display depending on add/edit page --%>
    <c:choose>
      <c:when test="${gadgetTitle=='myaccount_giftListAdd.addGiftList'}">
        <fmt:message  var="saveText" key="myaccount_giftListAdd.saveGiftList"/>
      </c:when>
      <c:otherwise>
        <fmt:message  var="saveText" key="common.button.saveChanges"/>
      </c:otherwise>
    </c:choose>


    <c:if test="${!empty gadgetTitle}">
      <h2><fmt:message key="${gadgetTitle}"/></h2>
    </c:if>

    <fieldset>

      <ul class="atg_store_basicForm">
        <c:choose>
          <c:when test="${not empty giftlistId}">
            <dsp:input bean="GiftlistFormHandler.giftlistId" type="hidden" beanvalue="GiftlistFormHandler.giftlistId"/>
            <dsp:getvalueof id="addAddressSuccessURL" idtype="java.lang.String"
                            value="giftListEdit.jsp?giftlistId=${giftlistId}"/>
          </c:when>
          <c:otherwise>
            <dsp:input bean="GiftlistFormHandler.saveGiftlistSuccessURL" type="hidden" value="${giftListHomeUrl}"/>
            <dsp:input bean="GiftlistFormHandler.saveGiftlistErrorURL" type="hidden" value="${giftListHomeUrl}"/>
            <dsp:getvalueof id="addAddressSuccessURL" idtype="java.lang.String" value="giftListHome.jsp?initForm=true&selpage=GIFT LISTS"/>
          </c:otherwise>
        </c:choose>

        <li>
          <label for="atg_store_giftListAddEventName" class="required">
            <fmt:message key="myaccount_giftListAdd.giftListName"/>
            <span class="required">*</span>
          </label>
          <dsp:input bean="GiftlistFormHandler.eventName" size="27" maxlength="64"
                     name="atg_store_giftListAddEventName" type="text"
                     id="atg_store_giftListAddEventName" required="true" iclass="required"/>
        </li>
        <li class="atg_store_giftListSelectDate">
          <label for="atg_store_giftListAddEventMonth" class="required">
            <fmt:message key="common.date"/>
            <span class="required">*</span>
          </label>
          <dsp:select bean="GiftlistFormHandler.month" id="atg_store_giftListAddEventMonth"
                      name="atg_store_giftListAddEventMonth" required="true" iclass="required">
            <dsp:option value="0"><fmt:message key="common.january"/></dsp:option>
            <dsp:option value="1"><fmt:message key="common.february"/></dsp:option>
            <dsp:option value="2"><fmt:message key="common.march"/></dsp:option>
            <dsp:option value="3"><fmt:message key="common.april"/></dsp:option>
            <dsp:option value="4"><fmt:message key="common.may"/></dsp:option>
            <dsp:option value="5"><fmt:message key="common.june"/></dsp:option>
            <dsp:option value="6"><fmt:message key="common.july"/></dsp:option>
            <dsp:option value="7"><fmt:message key="common.august"/></dsp:option>
            <dsp:option value="8"><fmt:message key="common.september"/></dsp:option>
            <dsp:option value="9"><fmt:message key="common.october"/></dsp:option>
            <dsp:option value="10"><fmt:message key="common.november"/></dsp:option>
            <dsp:option value="11"><fmt:message key="common.december"/></dsp:option>
          </dsp:select>

          <dsp:select bean="GiftlistFormHandler.date" name="atg_store_giftListAddEventDay"
                      id="atg_store_giftListAddEventDay" required="true" iclass="custom_selectday">
            <dsp:option value="1">1</dsp:option>
            <dsp:option value="2">2</dsp:option>
            <dsp:option value="3">3</dsp:option>
            <dsp:option value="4">4</dsp:option>
            <dsp:option value="5">5</dsp:option>
            <dsp:option value="6">6</dsp:option>
            <dsp:option value="7">7</dsp:option>
            <dsp:option value="8">8</dsp:option>
            <dsp:option value="9">9</dsp:option>
            <dsp:option value="10">10</dsp:option>
            <dsp:option value="11">11</dsp:option>
            <dsp:option value="12">12</dsp:option>
            <dsp:option value="13">13</dsp:option>
            <dsp:option value="14">14</dsp:option>
            <dsp:option value="15">15</dsp:option>
            <dsp:option value="16">16</dsp:option>
            <dsp:option value="17">17</dsp:option>
            <dsp:option value="18">18</dsp:option>
            <dsp:option value="19">19</dsp:option>
            <dsp:option value="20">20</dsp:option>
            <dsp:option value="21">21</dsp:option>
            <dsp:option value="22">22</dsp:option>
            <dsp:option value="23">23</dsp:option>
            <dsp:option value="24">24</dsp:option>
            <dsp:option value="25">25</dsp:option>
            <dsp:option value="26">26</dsp:option>
            <dsp:option value="27">27</dsp:option>
            <dsp:option value="28">28</dsp:option>
            <dsp:option value="29">29</dsp:option>
            <dsp:option value="30">30</dsp:option>
            <dsp:option value="31">31</dsp:option>
          </dsp:select>

          <crs:yearList numberOfYears="5"
                        bean="/atg/commerce/gifts/GiftlistFormHandler.year"
                        id="atg_store_giftListAddEventYear"
                        selectRequired="true" yearString="false" iclass="required"/>

        </li>
        <li>
          <label for="atg_store_giftListAddShippingAddress" class="required">
            <fmt:message key="myaccount_giftListAdd.shipTo"/>
            <span class="required">*</span>
          </label>
            <dsp:getvalueof var="defaultShippingAddress" bean="Profile.shippingAddress.repositoryId"/>
            <dsp:getvalueof var="currentGiftlistShippingId" bean="GiftlistFormHandler.shippingAddressId"/>


            <dsp:select bean="GiftlistFormHandler.shippingAddressId" id="atg_store_giftListAddShippingAddress"
                        name="atg_store_giftListAddShippingAddress" required="true" iclass="custom_select">
              <c:if test="${empty defaultShippingAddress and empty currentGiftlistShippingId}">
                <dsp:option value=""><fmt:message key="common.noneSpecified"/></dsp:option>
              </c:if>
              <dsp:getvalueof var="secondaryAddresses" bean="Profile.secondaryAddresses"/>
              <c:forEach var="shippingAddr" items="${secondaryAddresses}">
                <dsp:param name="address" value="${shippingAddr.value}"/>
                <dsp:param name="addressKey" value="${shippingAddr.key}"/>
                <dsp:getvalueof var="addressId" param="address.repositoryId" vartype="java.lang.String"/>
                <c:choose>
                  <c:when test="${not empty currentGiftlistShippingId}">
                    <dsp:option value="${addressId}">
                      <dsp:valueof param="addressKey">
                        <fmt:message key="common.undefined"/>
                      </dsp:valueof>
                    </dsp:option>
                  </c:when>
                  <c:otherwise>
                    <dsp:option value="${addressId}" selected="${addressId eq defaultShippingAddress}">
                      <dsp:valueof param="addressKey">
                        <fmt:message key="common.undefined"/>
                      </dsp:valueof>
                    </dsp:option>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </dsp:select>

            <fmt:message var="addNewAddressText" key="myaccount_giftListAdd.addNewAddress"/>
            <dsp:input type="hidden" bean="GiftlistFormHandler.moveToNewGiftListAddressSuccessURL"
                       value="giftAddressAdd.jsp?showCancel=true&successURL=${addAddressSuccessURL}"/>
            <dsp:input type="submit" bean="GiftlistFormHandler.moveToNewGiftListAddress"
                       value="${addNewAddressText}" iclass="atg_store_giftListAddNewShippingAddress atg_store_textButton"/>
          </li>
          <li>
              <label for="atg_store_giftListAddEventType" class="required">
                <fmt:message key="common.type"/>
                <span class="required">*</span>
              </label>
              <dsp:select bean="GiftlistFormHandler.eventType" id="atg_store_giftListAddEventType"
                          name="atg_store_giftListAddEventType" required="true" iclass="custom_select">
                <dsp:option value=""><fmt:message key="common.select"/></dsp:option>
                          
                <dsp:droplet name="/atg/dynamo/droplet/PossibleValues">
                  <dsp:param name="itemDescriptorName" value="gift-list"/>
                  <dsp:param name="propertyName" value="eventType"/>
                  <dsp:param name="returnValueObjects" value="true"/>
                  <dsp:setvalue param="repository" beanvalue="/atg/commerce/gifts/Giftlists"/>
         
                  <dsp:oparam name="output">
                    <dsp:getvalueof var="eventTypes" vartype="java.lang.Object" param="values"/>
                    <c:forEach var="eventType" items="${eventTypes}">
                      <dsp:param name="eventType" value="${eventType}"/>
                      <dsp:option value="${eventType.settableValue}">
                        ${eventType.label}
                      </dsp:option>
                    </c:forEach>
                  </dsp:oparam>
                </dsp:droplet><%-- End Possible Values --%>
              </dsp:select>
            </li>
            <li>
              <label for="atg_store_giftListAddGiftListStatus" class="required">
                <fmt:message key="myaccount_giftListAdd.privacySetting"/>
                <span class="required">*</span>
              </label>
              <dsp:select bean="GiftlistFormHandler.isPublished" id="atg_store_giftListAddGiftListStatus"
                          name="published" required="true" iclass="custom_select">
                <dsp:option value="true"><fmt:message key="myaccount_giftListAdd.publicAnyoneCanSee"/></dsp:option>
                <dsp:option value="false"><fmt:message key="myaccount_giftListAdd.viewableOnlyByYou"/></dsp:option>
              </dsp:select>
            </li>
          </ul>
          <ul class="atg_store_basicForm">
            <li>
              <label for="atg_store_giftListAddEventDescription">
                <fmt:message key="common.description"/>
                <span class="optional"><fmt:message key="common.optional"/><span>
              </label>
            <dsp:getvalueof var="giftListDescription" bean="GiftlistFormHandler.description"/>
            <dsp:textarea iclass="custom_textarea textAreaCount" cols="27" maxlength="254"
                          bean="GiftlistFormHandler.description" name="atg_store_giftListAddEventDescription"
                          id="atg_store_giftListAddEventDescription"/>
              <span class="charCounter">
                <fmt:message key="common.charactersUsed">
                  <fmt:param>
                    <em>${(not empty giftListDescription)? fn:length(giftListDescription):0}</em>
                  </fmt:param>
                  <fmt:param>
                    <em>254</em>
                  </fmt:param>
                </fmt:message>
              </span>
            </li>

            <li>
              <label for="atg_store_giftListAddSpecialInstructions">
                <fmt:message key="myaccount_giftListAdd.specialInstructions"/>
                   <span class="optional"><fmt:message key="common.optional"/></span>
              </label>
              <dsp:getvalueof var="giftListInstructions" bean="GiftlistFormHandler.instructions"/>
              <dsp:textarea iclass="custom_textarea textAreaCount" cols="27" maxlength="254"
                            bean="GiftlistFormHandler.instructions"
                            name="atg_store_giftListAddSpecialInstructions"
                            id="atg_store_giftListAddSpecialInstructionsId"/>
              <span class="charCounter">
                <fmt:message key="common.charactersUsed">
              <fmt:param>
                <em>${(not empty giftListInstructions)? fn:length(giftListInstructions):0}</em>
              </fmt:param>
              <fmt:param>
                <em>254</em>
              </fmt:param>
            </fmt:message>
          </span>
        </li>
      </ul>
    </fieldset>
    <c:if test="${empty giftlistId}">
      <div class="atg_store_formActions">
        <span class="atg_store_basicButton">
          <dsp:input bean="GiftlistFormHandler.saveGiftlist" type="submit" value="${saveText}" id="atg_store_saveGiftLift"/>
        </span>
      </div>
    </c:if>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/giftListAdd.jsp#2 $$Change: 633752 $--%>
