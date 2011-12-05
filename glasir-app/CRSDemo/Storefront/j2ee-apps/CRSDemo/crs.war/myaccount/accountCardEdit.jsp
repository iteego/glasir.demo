<dsp:page>
<%--
  Outlay page for editing User's Saved Credit Card Information 

  This page includes paymentInfoCardAdd.jsp for rendering the logic as well as presentation for the account
  specific payment information details . 

   Parameters:
   - successURL - to redirect to , during the success of updation or creation of new Credit Card Details .
   - cancelURL - to redirect to , during the faliure of updation or creation of new Credit Card Details .
--%>

  <crs:pageContainer divId="atg_store_accountEditCardIntro" index="false" follow="false" bodyClass="atg_store_myAccountPage atg_store_leftCol">
    <jsp:body>
    <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="myaccount_accountCardEdit.title"/>
      </h2>
    </div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="PAYMENT INFO" />
      </dsp:include>

      <div class="atg_store_myAccount atg_store_main">
        <dsp:include page="/myaccount/gadgets/paymentInfoCardAddEdit.jsp">
          <dsp:param name="mode" value="edit" />
          <dsp:param name="successURL" param="successURL"/>
          <dsp:param name="cancelURL" param="cancelURL"/>
        </dsp:include>
      </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/accountCardEdit.jsp#2 $$Change: 635969 $--%>
