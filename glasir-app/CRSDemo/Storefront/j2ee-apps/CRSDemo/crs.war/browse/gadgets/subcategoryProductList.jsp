<dsp:page>

  <%-- This page displays the category contents.
       Parameters 
       - category - category repository item whose name should be displayed.
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>

  <dsp:getvalueof  var="trailSize" vartype="int" param="trailSize"/>
  <dsp:getvalueof var="useSearchForSubcategoryProductList" 
        bean="/atg/store/StoreConfiguration.useSearchForSubcategoryProductList"/>

  <c:if test="${useSearchForSubcategoryProductList == 'false'}">
   <div id="atg_store_catSubProdList">

      <%-- Show Form Errors this already adds a table row around error messages --%>
      <dsp:include page="/global/gadgets/errorMessage.jsp">
        <dsp:param name="formhandler" bean="CartFormHandler"/>
      </dsp:include>

      <c:if test="${trailSize==0}">
        <dsp:include page="/global/gadgets/productListRange.jsp">
          <%-- start passing parameters for productListRange --%>
          <dsp:param name="productArray" param="category.childProducts"/>
          <dsp:param name="sortClassName" value="atg_store_filter"/>
          <dsp:param name="productDivName" value="atg_store_prodList"/>
          <dsp:param name="productTitleClassName" value="atg_store_prodListItem"/>
          <dsp:param name="productImageClassName" value="atg_store_prodListThumb"/>
          <dsp:param name="productDescriptionClassName" value="atg_store_prodListDesc"/>
          <dsp:param name="productPriceClassName" value="atg_store_prodListPrice"/>
          <dsp:param name="productActionsClassName" value="atg_store_prodListDetLink"/>
          <dsp:param name="navLinkAction" value="push"/>
          <%-- end passing parameters for productListRangeRow --%>
        </dsp:include>
      </c:if>

   </div>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/subcategoryProductList.jsp#2 $$Change: 635969 $--%>



