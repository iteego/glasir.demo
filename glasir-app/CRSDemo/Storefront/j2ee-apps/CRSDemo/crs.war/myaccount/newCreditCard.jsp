<dsp:page>
<%-- Outlay page for rendering the new credit card page --%>

  <crs:pageContainer 
      divId="atg_store_paymentInfoIntro" 
      index="false" follow="false"
      bodyClass="atg_store_myAccountPage atg_store_leftCol">    
    <jsp:body>
    <div class="atg_store_nonCatHero"><h2 class="title"><fmt:message key="myaccount_newCreditCard.title"/></h2></div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="PAYMENT INFO" />
      </dsp:include>

      <div class="atg_store_main atg_store_myAccount">

        <dsp:include page="gadgets/paymentInfoCardAddEdit.jsp">
          <dsp:param name="mode" value="create" />
        </dsp:include>
        
      </div>

    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/newCreditCard.jsp#2 $$Change: 635969 $--%>
