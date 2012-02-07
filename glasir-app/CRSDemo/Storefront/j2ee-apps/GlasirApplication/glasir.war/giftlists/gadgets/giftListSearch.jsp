<dsp:page>

  <%--
    This gadget contains the logic and UI for taking the inputs from the user 
    for finding  giftlist(s)
  --%>

  <dsp:importbean bean="/atg/commerce/gifts/GiftlistSearch"/>
        
  <%-- Append selpage parameter to success page 'giftListSearchResults.jsp'.
       This will highlight the giftlist link at top of page.
   --%>
  <c:url value="giftListSearchResults.jsp" var="giftSearchResultsUrl" scope="page">
     <c:param name="selpage">GIFT LISTS</c:param>
  </c:url>

  <dsp:getvalueof var="clearSearchFields" vartype="java.lang.Boolean" param="clearForm"/>
  <dsp:form action="../giftListSearch.jsp" 
            method="post"
            formid="searchGiftlist" 
            name="searchGiftlist">
    <fieldset>
      <ul class="atg_store_basicForm atg_store_giftListSearch">
        <dsp:input bean="GiftlistSearch.searchSuccessURL"
                   value="${giftSearchResultsUrl}" type="hidden"/>
        <dsp:input bean="GiftlistSearch.searchErrorURL"
                   paramvalue="errorUrl" type="hidden"/>
        <li>
          <label for="atg_store_firstNameInput">
            <fmt:message key="giftlist_giftListSearch.firstName"/>
          </label>
          <dsp:getvalueof var="firstName" vartype="java.lang.String" bean="GiftlistSearch.propertyValues.firstName"/>
          <dsp:input bean="GiftlistSearch.propertyValues.firstName" type="text" id="atg_store_firstNameInput"
              value="${(not empty clearSearchFields) and clearSearchFields ? '' : firstName}"/>
        </li>
        
        <li>
          <label for="atg_store_lastNameInput">
            <fmt:message key="common.lastName"/>
          </label>
          <dsp:getvalueof var="lastName" vartype="java.lang.String" bean="GiftlistSearch.propertyValues.lastName"/>
          <dsp:input bean="GiftlistSearch.propertyValues.lastName" type="text" id="atg_store_lastNameInput"
              value="${(not empty clearSearchFields) and clearSearchFields ? '' : lastName}"/>
        </li>
        <li><div class="atg_store_formFooter">
          <div class="atg_store_formActions">
            <fmt:message var="searchText" key="common.button.searchText"/>
            <fmt:message var="searchTitle" key="common.button.searchTitle"/>
            <span class="atg_store_basicButton">
              <dsp:input type="submit"  bean="GiftlistSearch.search" iclass="atg_store_actionSubmit"
                         title="${searchTitle}" value="${searchText}" id="atg_store_giftListSearchSubmit"/>
            </span>
          </div>
        </div>
        </li>
      </ul>
    </fieldset>

  </dsp:form>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/giftlists/gadgets/giftListSearch.jsp#2 $$Change: 633752 $ --%>
