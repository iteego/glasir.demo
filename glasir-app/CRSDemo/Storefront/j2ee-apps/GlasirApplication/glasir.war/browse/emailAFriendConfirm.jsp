<dsp:page>

  <%--  This page displays the confirmation message that Email has been send 
        Parameters: 
        productId - ID of the Product regarding which Email is to be sent
        categoryId - ID of the parent category of the Product regarding which Email is to be sent
  --%>

  <crs:popupPageContainer divId="atg_store_emailConfirmIntro" titleKey="browse_emailAFriendConfirm.title">

    <jsp:body>
      <dsp:include page="gadgets/emailAFriendConfirm.jsp">
        <dsp:param name="productId" param="productId"/>
        <dsp:param name="categoryId" param="categoryId"/>
      </dsp:include>
    </jsp:body>

  </crs:popupPageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/emailAFriendConfirm.jsp#2 $$Change: 635969 $--%>
