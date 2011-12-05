<dsp:page>
  <%--
    Layout page for updating gift list information
    The following input parameters are expected:
    - giftlistId: id of giftList to be edited.
  --%>

  <%-- Import the gift list form handler bean. --%>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>

  <crs:pageContainer divId="atg_store_giftListIntro"
                     index="false" follow="false"
                     bodyClass="atg_store_myAccountPage atg_store_leftCol">
    <jsp:body>
   <div class="atg_store_nonCatHero"> <h2 class="title"><fmt:message key="myaccount_giftListAdd.editGiftList"/></h2></div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="GIFT LISTS" />
      </dsp:include>
      <div class="atg_store_main atg_store_myAccount">

        <%-- Display any errors that may exist --%>
        <div id="atg_store_formValidationError">
          <%-- The error message should display a 'save changes' button as we are editing. --%>
          <fmt:message  var="saveText" key="common.button.saveChanges"/>
          <dsp:include page="gadgets/myAccountErrorMessage.jsp">
            <dsp:param name="formHandler" bean="GiftlistFormHandler" />
            <dsp:param name="submitFieldText" value="${saveText}"/>
          </dsp:include>
        </div>

        <dsp:form formid="giftlist" action="giftListEdit.jsp" method="post">
          <dsp:getvalueof var="giftlistId" idtype="java.lang.String" param="giftlistId"/>
          <dsp:include page="gadgets/giftListAdd.jsp" flush="true" >
            <dsp:param name="giftlistId" param="giftlistId" />
          </dsp:include>

          <dsp:include page="/myaccount/gadgets/giftListManage.jsp" flush="true">
            <dsp:param name="giftlistId" param="giftlistId"/>
          </dsp:include>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/giftListEdit.jsp#1 $$Change: 633540 $ --%>