<dsp:page>

  <%-- This page renders the Product Listing of the products that have the selected Feature
    -  featureId -  Id of the Feature being browsed.
    -  featurName - Display Name of the Feature being browsed.
  --%>

  <dsp:importbean bean="/atg/store/droplet/ProductsByFeatureRQL"/>

  <div id="atg_store_productList">

    <dsp:getvalueof var="featureId" param="featureId"/>
    <dsp:getvalueof var="featureDisplayName" param="featureName"/>

    <dsp:droplet name="ProductsByFeatureRQL">
      <dsp:param name="queryRQL" value='features INCLUDES ITEM (id = "${featureId}")'/>
      <dsp:oparam name="output">

        <dsp:include page="/global/gadgets/productListRange.jsp">
          <%-- start passing parameters for productListRange --%>
          <fmt:message var="featureDetailProductMessage" key="browse_productList.productMsg"/>
          <fmt:message var="commonLabelSeparator" key="common.labelSeparator"/>
          <dsp:param name="productListHeading" 
            value="${featureDetailProductMessage}${commonLabelSeparator}${featureDisplayName}"/>
          <dsp:param name="productArray" param="items"/>
          <dsp:param name="sortClassName" value="atg_store_filter"/>
          <dsp:param name="productDivName" value="atg_store_prodList"/>
          <%-- end passing parameters for productListRange --%>

          <%-- start passing parameters for productListRangeRow --%>
          <dsp:param name="productTitleClassName" value="atg_store_prodListItem"/>
          <dsp:param name="productImageClassName" value="atg_store_prodListThumb"/>
          <dsp:param name="productDescriptionClassName" value="atg_store_prodListDesc"/>
          <dsp:param name="productPriceClassName" value="atg_store_prodListPrice"/>
          <dsp:param name="productActionsClassName" value="atg_store_prodListDetLink"/>
          <%-- end passing parameters for productListRangeRow --%>
        </dsp:include>
      </dsp:oparam>

      <dsp:oparam name="empty">
        <fmt:message key="browse_productList.noProductFoundMsg"/>
      </dsp:oparam>
    </dsp:droplet>

  </div>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productList.jsp#2 $$Change: 635969 $--%>
