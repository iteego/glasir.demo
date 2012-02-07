<dsp:page>
<%--
  This layout page includes
    1.  gadgets/giftListList.jsp for rendering all gift lists associated with a profile.
    2.  gadgets/giftListAdd.jsp for rendering UI for adding a Gift List.
--%>

  <%-- Import the gift list form handler bean. --%>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>

  <crs:pageContainer divId="atg_store_giftListIntro"
                     index="false" follow="false"
                     bodyClass="atg_store_myAccountPage atg_store_leftCol">
    <jsp:body>
     <div class="atg_store_nonCatHero"><h2 class="title"><fmt:message key="myaccount_giftlist.title"/></h2></div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="GIFT LISTS" />
      </dsp:include>
      <div class="atg_store_main atg_store_myAccount">
        <div class="content">

          <%-- Display any errors that may exist --%>
          <div id="atg_store_formValidationError">
            <%-- The error message should display a 'save gift list' button as we are adding. --%>
            <fmt:message var="saveText" key="myaccount_giftListAdd.saveGiftList" />
            <dsp:include page="gadgets/myAccountErrorMessage.jsp">
              <dsp:param name="formHandler" bean="GiftlistFormHandler" />
              <dsp:param name="submitFieldText" value="${saveText}"/>
            </dsp:include>
          </div>

	        <%-- Include the list of gift lists, this allows editing of a gift list --%>
          <dsp:include page="gadgets/giftListList.jsp" flush="true" />

          <%-- Include the page that allows creating a new gift list --%>
          <dsp:form action="giftListHome.jsp" method="post" formid="atg_store_giftListAddForm">
            <dsp:include page="gadgets/giftListAdd.jsp" flush="true">
              <dsp:param name="gadgetTitle" value="myaccount_giftListAdd.addGiftList" />
            </dsp:include>
          </dsp:form>
        </div>
      </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/giftListHome.jsp#1 $$Change: 633540 $ --%>
