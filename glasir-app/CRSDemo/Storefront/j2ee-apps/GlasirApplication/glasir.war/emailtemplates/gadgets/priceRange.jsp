<dsp:page>

  <%-- This page expects the following parameters
       - product - the product repository item to display a range of prices for
       - showPriceLabel - boolean indicating if label should be displayed before price
  --%>
  
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/commerce/pricing/PriceRangeDroplet"/>
  
  <dsp:getvalueof var="showPriceLabel" param="showPriceLabel"/>

  
  <%-- Get list price range for product --%>  
  <dsp:droplet name="PriceRangeDroplet">
    <dsp:param name="productId" param="product.repositoryId"/>
    <dsp:param name="salePriceList" bean="Profile.priceList"/>
    <dsp:oparam name="output">
      <dsp:getvalueof var="highestListPrice" vartype="java.lang.Double" param="highestPrice"/>
      <dsp:getvalueof var="lowestListPrice" vartype="java.lang.Double" param="lowestPrice"/>
    </dsp:oparam>
  </dsp:droplet>
  
  <dsp:droplet name="PriceRangeDroplet">
    <dsp:param name="productId" param="product.repositoryId"/>           
    <dsp:oparam name="output">
      <dsp:getvalueof var="highestPrice" vartype="java.lang.Double" param="highestPrice"/>
      <dsp:getvalueof var="lowestPrice" vartype="java.lang.Double" param="lowestPrice"/>
      
      <c:if test="${highestListPrice != highestPrice || lowestListPrice != lowestPrice}">
        <c:set var="showSalePrice" value="true"/>
         <span class="atg_store_newPrice">         
        </c:if>


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

        <c:if test="${showSalePrice}">
          </span>
        <dsp:droplet name="Compare">
          <dsp:param name="obj1" value="${lowestListPrice}" converter="number"/>
          <dsp:param name="obj2" value="${highestListPrice}" converter="number"/>
          <dsp:oparam name="equal">
            <span class="atg_store_oldPrice">
              <fmt:message key="common.price.old"/>
              <span style="text-decoration: line-through;">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${lowestListPrice }"/>
              </dsp:include>
              </span>
            </span>
          </dsp:oparam>
          <dsp:oparam name="default">
            <span class="atg_store_oldPrice">
              <fmt:message key="common.price.old"/>
              <span style="text-decoration: line-through;">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${lowestListPrice }"/>
              </dsp:include> -
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${highestListPrice }"/>
              </dsp:include>
              </span>
            </span>
          </dsp:oparam>
        </dsp:droplet>
       
      </c:if>
      
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/priceRange.jsp#2 $$Change: 635969 $--%>
