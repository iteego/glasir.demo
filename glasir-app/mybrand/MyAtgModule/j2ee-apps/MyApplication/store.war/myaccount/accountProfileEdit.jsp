<dsp:page>

<%-- 
      Include gadget myAccountMenu to renderer Menu of My Account.
      Include gadget profileMyInfoEdit to edit the details of profile.
--%>

  <crs:pageContainer divId="atg_store_accountEditProfileIntro" 
                     index="false" follow="false"
                     bodyClass="atg_store_myAccountPage atg_store_leftCol">    

    <jsp:body>
    <div class="atg_store_nonCatHero">
      <h2 class="title"><fmt:message key="myaccount_profileMyInfoEdit.title" /></h2>
    </div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="MY PROFILE" />
      </dsp:include>
      <div class="atg_store_main atg_store_myAccount">
        
        <dsp:include page="/myaccount/gadgets/profileMyInfoEdit.jsp" flush="true">
          <dsp:param name="restrictionDroplet" value="/atg/store/droplet/CountryListDroplet"/>
        </dsp:include>
      </div>
    </jsp:body>

  </crs:pageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/accountProfileEdit.jsp#2 $$Change: 635969 $--%>
