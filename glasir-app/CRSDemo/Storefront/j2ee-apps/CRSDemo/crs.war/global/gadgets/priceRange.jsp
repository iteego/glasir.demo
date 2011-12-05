<dsp:page>

  <%-- 
      On this page we want to show both the standard price range and 
      the sale price range (if one exists). To do so, we call the 
      PriceRangeDroplet twice, once for the standard prices and a 
      second time for the sale prices.

      PriceRangeDroplet takes two optional parameters, priceList and 
      salePriceList, that refer to the price lists it should use to 
      calculate the range. PriceRangeDroplet always uses both its 
      priceList and the salePriceList parameters to calculate the 
      lowest and highest prices. If not explicitly specified, priceList 
      defaults to the shopper's priceList profile property and 
      salePriceList defaults to the shopper's salePriceList profile 
      property.
  
      This page expects the following parameters
       - product - the product repository item to display a range of prices for
       - showPriceLabel - boolean indicating if label should be displayed before price
  --%>

  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/commerce/pricing/PriceRangeDroplet"/>
  
  <dsp:getvalueof var="showPriceLabel" param="showPriceLabel"/>

  
  <%-- 
      In the first call to the PriceRangeDroplet, we override the 
      salePriceList parameter with the shopper's standard price list 
      (profile.priceList). In so doing, we force both the priceList 
      and the salePriceList parameters to reference the standard price 
      list. This effectively limits the calculation to take into 
      account only the standard prices. 
  --%>  
  <dsp:droplet name="PriceRangeDroplet">
    <dsp:param name="productId" param="product.repositoryId"/>
    <dsp:param name="salePriceList" bean="Profile.priceList"/>
    <dsp:oparam name="output">
      <%-- The values of the range calculated from the standard pricelist. --%>
      <dsp:getvalueof var="highestListPrice" vartype="java.lang.Double" param="highestPrice"/>
      <dsp:getvalueof var="lowestListPrice" vartype="java.lang.Double" param="lowestPrice"/>
    </dsp:oparam>
  </dsp:droplet>
  
  <%-- 
      For the second call to the droplet, we want to use the sale prices 
      in the calculation, so we don't provide any parameter overrides. 
      This means PriceRangeDroplet uses its defaults, profile.priceList 
      and profile.salePriceList, to calculate the lowest and highest prices. 
  --%>
  <dsp:droplet name="PriceRangeDroplet">
    <dsp:param name="productId" param="product.repositoryId"/>           
    <dsp:oparam name="output">
      <dsp:getvalueof var="highestPrice" vartype="java.lang.Double" param="highestPrice"/>
      <dsp:getvalueof var="lowestPrice" vartype="java.lang.Double" param="lowestPrice"/>
      
      <%-- 
          Compare the values returned during the two calls to the 
          PriceRangeDroplet. If they differ, it means that the sale price 
          list returned a lower value than the standard price list, in 
          which case, the sale price range should be rendered along with 
          the standard price range.
      --%>
      <c:if test="${highestListPrice != highestPrice || lowestListPrice != lowestPrice}">
        <c:set var="showSalePrice" value="true"/>
         <span class="atg_store_newPrice">         
        </c:if>

        <%-- Render the sale price range, if there is one. Otherwise, 
             render the standard price range. --%>
        <dsp:droplet name="Compare">
          <dsp:param name="obj1" param="lowestPrice" converter="number"/>
          <dsp:param name="obj2" param="highestPrice" converter="number"/>
          <dsp:oparam name="equal">
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${lowestPrice }"/>
            </dsp:include>
          </dsp:oparam>
          <dsp:oparam name="default">
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${lowestPrice }"/>
            </dsp:include> -
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="${highestPrice }"/>
            </dsp:include>
          </dsp:oparam>
        </dsp:droplet>

        <%-- If the sale price was rendered, then also render the standard 
             price range. --%>
        <c:if test="${showSalePrice}">
          </span>
        <dsp:droplet name="Compare">
          <dsp:param name="obj1" value="${lowestListPrice}" converter="number"/>
          <dsp:param name="obj2" value="${highestListPrice}" converter="number"/>
          <dsp:oparam name="equal">
            <span class="atg_store_oldPrice">
              <fmt:message key="common.price.old"/>
              <del>
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${lowestListPrice }"/>
              </dsp:include>
              </del>
            </span>
          </dsp:oparam>
          <dsp:oparam name="default">
            <span class="atg_store_oldPrice">
              <fmt:message key="common.price.old"/>
              <del>
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${lowestListPrice }"/>
              </dsp:include> -
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${highestListPrice }"/>
              </dsp:include>
              </del>
            </span>
          </dsp:oparam>
        </dsp:droplet>
       
      </c:if>
      
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/priceRange.jsp#3 $$Change: 635969 $--%>
