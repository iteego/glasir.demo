<dsp:page>
  <%--  This layout page includes
          -  giftListSearch gadget
          
        Input parameters:
          resetFormErrors - if 'true', all form errors will be removed from GiftlistSearch form handler 
  --%>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistSearch"/>

  <crs:pageContainer divId="atg_store_giftListIntro" titleKey="" bodyClass="atg_store_pageGiftList">
    <jsp:body>
      <div id="atg_store_giftListSearch">
      <div class="atg_store_nonCatHero">
      <h2 class="title"><fmt:message key="navigation_personalNavigation.giftList.findGiftlist"/></h2>
      </div>
    
      <dsp:getvalueof var="resetExceptions" vartype="java.lang.String" param="resetFormErrors"/>
      <c:if test="${resetExceptions == 'true'}">
        <dsp:setvalue bean="/atg/commerce/gifts/GiftlistSearch.resetFormErrors" value="true"/>
      </c:if>
      
      <span>
        <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
          <dsp:param name="formHandler" bean="GiftlistSearch"/>
          <dsp:param name="submitFieldKey" value="common.button.searchText"/>
        </dsp:include>
      </span>
      <div class="atg_store_giftListSearchContainer">
      <h3>
        <fmt:message key="giftlist_giftListSearch.wantToGiveGift"/>
      </h3>
      <dsp:include page="gadgets/giftListSearch.jsp" flush="true" >
        <dsp:param name="errorUrl" value="giftListSearch.jsp"/>
        <dsp:param name="clearForm" value="true"/>
      </dsp:include>
      </div>
    </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-store/Store/main/estore/j2ee/estore/myaccount/giftListSearch.jsp
 $$Change: 633540 $ --%>