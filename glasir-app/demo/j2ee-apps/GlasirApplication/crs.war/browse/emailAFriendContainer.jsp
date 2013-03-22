<dsp:page>

  <%--
      Container page for Email A Friend
      Parameters - 
      - product - Repository item of the Product being browsed
      - productId - Repository Id of the Product being browsed
      - categoryId - Repository Id of the Category to which the Product being browsed belongs
      - templateUrl - The template to be used as the email content
  --%>

  <%-- unpack dsp:param --%>
  <dsp:getvalueof var="productIdVar" param="productId" />
  <dsp:getvalueof var="categoryIdVar" param="categoryId" />
  <dsp:getvalueof var="templateUrlVar" param="templateUrl" />

  <dsp:include page="/browse/gadgets/emailAFriendProductDetails.jsp" flush="true">
    <dsp:param name="product" param="product" />
  </dsp:include>

  <dsp:include page="/browse/gadgets/emailAFriendFormInputs.jsp" flush="true">
    <dsp:param name="product" param="product" />
    <dsp:param name="productId" value="${productIdVar}" />
    <dsp:param name="categoryId" value="${categoryIdVar}" />
    <dsp:param name="templateUrl" value="${templateUrlVar}" />
  </dsp:include>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/emailAFriendContainer.jsp#2 $$Change: 635969 $--%>



