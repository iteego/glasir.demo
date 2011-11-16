<%-- 
     This page expects the following parameters 
     - commerceItem - the commerce item whose image we should display
     - displayAslink - tells is image should be a link

     Form Condition:
     - This gadget must be contained inside of a form.
       CartFormHandler must be invoked from a submit 
       button in this form for fields in this page to be processed
--%>

<%-- Show the image of the product, if you have the sku image let us show it 
     instead.  If no sku image then select the best product for display of the 
     image.
--%>
<dsp:page>
  <dsp:getvalueof var="linkImage" vartype="java.lang.String" value="true"/>
  <dsp:getvalueof var="imageUrl" param="commerceItem.auxiliaryData.catalogRef.thumbnailImage.url"/>

  <c:choose>
    <c:when test="${not empty imageUrl}">
      <dsp:include page="/browse/gadgets/productImgCart.jsp">
        <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
        <dsp:param name="alternateImage" param="commerceItem.auxiliaryData.catalogRef.thumbnailImage"/>
        <dsp:param name="linkImage" value="${linkImage}"/>
        <dsp:param name="displayAslink" param="displayAslink"/>
      </dsp:include>
    </c:when>
    <c:otherwise>
      <dsp:include page="/browse/gadgets/productImgCart.jsp">
        <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
        <dsp:param name="linkImage" value="${linkImage}"/>
        <dsp:param name="displayAslink" param="displayAslink"/> 
      </dsp:include>
    </c:otherwise>
  </c:choose><%-- End is empty check on the SKU thumbnail image --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/cartItemImg.jsp#2 $$Change: 635969 $--%>
