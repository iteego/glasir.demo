<dsp:page>

  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>


  <dsp:droplet name="CategoryLookup">
    <dsp:param name="id" value="${param.categoryId}"/>

    <dsp:oparam name="error">
      <dsp:valueof param="errorMsg"/>
    </dsp:oparam>

    <dsp:oparam name="output">     
      <div id="atg_store_catSubProdList">
        <dsp:include page="/global/gadgets/productListRange.jsp">
          <%-- start passing parameters for productListRange --%>
          <dsp:param name="productArray" param="element.childProducts"/>
          <dsp:param name="sortClassName" value="atg_store_filter"/>
          <dsp:param name="productDivName" value="atg_store_prodList"/>
          <dsp:param name="productTitleClassName" value="atg_store_prodListItem"/>
          <dsp:param name="productImageClassName" value="atg_store_prodListThumb"/>
          <dsp:param name="productDescriptionClassName" value="atg_store_prodListDesc"/>
          <dsp:param name="productPriceClassName" value="atg_store_prodListPrice"/>
          <dsp:param name="productActionsClassName" value="atg_store_prodListDetLink"/>
          <dsp:param name="q_pageNum" value="${param.q_pageNum}"/>
          <dsp:param name="categoryNavigation" value="${param.navigation}"/>
          <%-- end passing parameters for productListRangeRow --%>
        </dsp:include>
        </div>
    </dsp:oparam>

    <dsp:oparam name="empty">
      <fmt:message key="common.noCategoryFound"/>
      <dsp:valueof param="categoryId">
        <fmt:message key="common.categoryIdDefault"/>
      </dsp:valueof>
    </dsp:oparam>
  </dsp:droplet>


</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/categoryProducts.jsp#2 $$Change: 635969 $--%>