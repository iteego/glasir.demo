<dsp:page>

  <%--  This page presents the Email Information form to the Shopper 
        Parameters: 
        productId - ID of the Product regarding which Email is to be sent
        categoryId - ID of the parent category of the Product regarding which Email is to be sent
  --%>

  <crs:popupPageContainer divId="atg_store_emailAFriendIntro" titleKey="browse_emailAFriend.title">

    <jsp:body>
      <dsp:include page="/browse/gadgets/emailAFriend.jsp">
        <dsp:param name="productId" param="productId"/>
        <dsp:param name="categoryId" param="categoryId"/>
        <dsp:param name="container" value="/browse/emailAFriendContainer.jsp"/>
        <dsp:param name="templateUrl" value="/emailtemplates/emailAFriend.jsp"/>
      </dsp:include>
    </jsp:body>

  </crs:popupPageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/emailAFriend.jsp#2 $$Change: 635969 $--%>
