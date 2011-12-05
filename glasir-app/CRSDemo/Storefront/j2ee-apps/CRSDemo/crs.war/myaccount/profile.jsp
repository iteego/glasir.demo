<dsp:page>
  <%--  This layout page includes
        -  gadgets/profileMyInfo.jsp for rendering all general 
           information associated with a profile.

        -  gadgets/profileMyInfoEditLinks.jsp for rendering the links for editing 
           the profile details and changing the password associated with a profile.

        -  gadgets/profileCheckOutPrefs.jsp for rendering all details regarding checkout associated with a profile.
  --%>
  
  <dsp:importbean bean="/atg/store/profile/RegistrationFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  
  <fmt:message var="changePasswordTitle" key="myaccount_profileMyInfoEditLinks.button.changePasswordTitle"/>
  <fmt:message var="changePasswordText" key="myaccount_profileMyInfoEditLinks.button.changePasswordText"/>
  
  <crs:pageContainer 
      divId="atg_store_profileIntro"
      index="false" follow="false"
      bodyClass="atg_store_myAccountPage atg_store_leftCol">    
    <jsp:body>
    <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="myaccount_profile.title" />
      </h2>
    </div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="MY PROFILE" />
      </dsp:include>
      <div class="atg_store_main atg_store_myAccount atg_store_myProfile">
        
        <div class="atg_store_myProfileInfo">
          <dsp:include page="/myaccount/gadgets/profileMyInfo.jsp" flush="true"/>
        </div>
        <div class="atg_store_PasswordDefaultsContainer">
          <div class="atg_store_changePassword">
            <div class="atg_store_formActions">
              <a title="${changePasswordTitle}" 
                 href="profilePasswordEdit.jsp" 
                 class="atg_store_basicButton">
                <span>${changePasswordText}</span>
              </a>
            </div>
          </div>
          
          <dsp:include page="/myaccount/gadgets/profileCheckOutPrefs.jsp" flush="true"/>
        </div>
      </div><%-- content --%>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/profile.jsp#2 $$Change: 635969 $--%>

