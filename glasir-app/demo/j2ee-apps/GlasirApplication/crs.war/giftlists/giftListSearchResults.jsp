<dsp:page>
  <%--  This layout page includes
          -  giftListSearch gadget
          -  giftListSearchResults gadget
          
        Input parameters:
          resetFormErrors - if 'true', all form errors will be removed from GiftlistSearch form handler 
  --%>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistSearch"/>

  <crs:pageContainer divId="atg_store_giftListIntro" titleKey="" bodyClass="atg_store_giftListSearchResults atg_store_pageGiftList">
    <jsp:body>
      <div id="atg_store_giftListSearch">
      <div class="atg_store_nonCatHero">
      <h2 class="title"><fmt:message key="navigation_personalNavigation.giftList.findGiftlist"/></h2>
    
      <dsp:getvalueof var="resetExceptions" vartype="java.lang.String" param="resetFormErrors"/>
      <c:if test="${resetExceptions == 'true'}">
        <dsp:setvalue bean="/atg/commerce/gifts/GiftlistSearch.resetFormErrors" value="true"/>
      </c:if>
    <div class="atg_store_giftListSearch">
      <dsp:include page="gadgets/giftListSearch.jsp" flush="true" >
        <dsp:param name="errorUrl" value="giftListSearchResults.jsp"/>
      </dsp:include>
    </div>
    </div>
      <span>
        <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
          <dsp:param name="formHandler" bean="GiftlistSearch"/>
          <dsp:param name="submitFieldKey" value="common.button.searchText"/>
        </dsp:include>
      </span>
      <dsp:include page="gadgets/giftListSearchResults.jsp" flush="true" />
    </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-store/Store/main/estore/j2ee/estore/myaccount/giftListSearch.jsp
 $$Change: 635969 $ --%>