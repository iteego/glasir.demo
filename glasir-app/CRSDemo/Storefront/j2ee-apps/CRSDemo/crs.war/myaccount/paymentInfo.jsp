<dsp:page>
<%-- Outlay page for rendering the user's saved payment information (online credits & credit cards) --%>

  <crs:pageContainer 
      divId="atg_store_paymentInfoIntro" 
      index="false" follow="false"
      bodyClass="atg_store_myAccountPage atg_store_leftCol">    
    <jsp:body>
    <div class="atg_store_nonCatHero">
      <h2 class="title"><fmt:message key="myaccount_paymentInfo.title"/></h2>
    </div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="PAYMENT INFO" />
      </dsp:include>

      <div class="atg_store_main atg_store_myAccount">
      
        <dsp:include page="gadgets/storedCreditCards.jsp"/>
        
      </div>

    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/paymentInfo.jsp#2 $$Change: 635969 $--%>
