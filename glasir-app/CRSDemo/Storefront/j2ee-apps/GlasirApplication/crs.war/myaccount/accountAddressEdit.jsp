<dsp:page>
<%--
  Outlay page for editing User Saved address 

  This page includes editAddress.jsp for rendering the logic as well as presentation for the account specific address . 

   Parameters:
      - successURL - to redirect to , during the success of updation address .
      - addEditMode - Set to 'edit' when a current address is being modified, otherwise it is assumed
                    a new address is being added.
--%>

  <crs:pageContainer divId="atg_store_accountEditAddressIntro" 
                     index="false" follow="false"
                     bodyClass="atg_store_myAccountPage atg_store_leftCol">    
    <jsp:body>
      <dsp:getvalueof var="addEditMode" param="addEditMode"/>
      <div class="atg_store_nonCatHero">
        <h2 class="title">
          <c:choose>
            <c:when test="${addEditMode == 'edit'}">
              <fmt:message key="myaccount_accountAddressEdit.title"/>
            </c:when>
            <c:otherwise>
              <fmt:message key="myaccount_addressEdit.newAddress"/>          
            </c:otherwise>
          </c:choose>
        </h2>
      </div>
      <dsp:include page="gadgets/myAccountMenu.jsp" flush="true">
        <dsp:param name="selpage" value="ADDRESS BOOK" />
      </dsp:include>

      <div class="atg_store_main atg_store_myAccount">
	    <dsp:include page="/myaccount/gadgets/addressEdit.jsp" flush="true">
	      <dsp:param name="successURL" param="successURL"/>
	      <dsp:param name="firstLastRequired" value="true"/>
	      <dsp:param name="addEditMode" param="addEditMode"/>
	      <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
	    </dsp:include>  
      </div>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/accountAddressEdit.jsp#2 $$Change: 635969 $--%>


