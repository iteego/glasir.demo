<dsp:page>
<%--
  This layout page includes
      -  gadgets/editAddress.jsp for rendering the logic as 
           well as presentation to add the new address 
  Parameters:
      -  successURL - to redirect to , during the success of updation address.
--%>

  <crs:pageContainer divId="atg_store_editAddressIntro"
                     index="false" follow="false" bodyClass="atg_store_myAccountPage atg_store_leftCol">
    <jsp:body>
    <div class="atg_store_nonCatHero"><h2 class="title"><fmt:message key="myaccount_giftAddressAdd.title"/></h2></div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
          <dsp:param name="selpage" value="GIFT LISTS" />
        </dsp:include>
      
      <dsp:getvalueof var="successURL" param="successURL"/>
      <div class="atg_store_main atg_store_myAccount">
        <dsp:include page="/myaccount/gadgets/addressEdit.jsp" flush="true">
          <dsp:param name="successURL" value="${successURL}&selpage=GIFT LISTS"/>
          <dsp:param name="cancelURL" value="../${successURL}"/>
          <dsp:param name="firstLastRequired" value="required"/>
          <dsp:param name="addEditMode" value="add"/>
          <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
        </dsp:include>
      </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/giftAddressAdd.jsp#2 $$Change: 633752 $--%>
