<dsp:page>

  <%--
      This page renders brief Product details about the Product being emailed
      Parameters - 
      - product - Repository item of the Product being emailed about
  --%>

  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  
  <%-- ************************* begin product description ************************* --%>
  <ul class="atg_store_emailProduct">
    <%-- Show basic information --%>
    <li>
      <div class="atg_store_productImage">
        <dsp:include page="/browse/gadgets/productThumbImg.jsp">
          <dsp:param name="showAsLink" value="false"/>
        </dsp:include>
      </div>
    
      <div class="atg_store_productInfo">
        <div class="atg_store_productTitle">
          <dsp:include page="/browse/gadgets/productName.jsp">
            <dsp:param name="showAsLink" value="false"/>
          </dsp:include>
        </div>
        <div class="atg_store_emailProductPrice">
          <%-- Check the size of the sku array to see how we handle things --%>
          <dsp:getvalueof var="childSKUs" param="product.childSKUs"/>
          <c:set var="totalSKUs" value="${fn:length(childSKUs)}"/>
          <dsp:droplet name="Compare">
            <dsp:param name="obj1" value="${totalSKUs}" converter="number" />
            <dsp:param name="obj2" value="1" converter="number" />
            <dsp:oparam name="equal">
              <%-- Display Price --%>
              <dsp:param name="sku" param="product.childSKUs[0]" />
              <dsp:include page="/global/gadgets/priceLookup.jsp" />
            </dsp:oparam>
            <dsp:oparam name="default">
              <%-- Display Price Range --%>
              <dsp:include page="/global/gadgets/priceRange.jsp" />
            </dsp:oparam>
          </dsp:droplet> <%-- End Compare droplet to see if the product has a single sku --%>
        </div>
        <p>
          <dsp:valueof param="product.longDescription" valueishtml="true"/>
        </p>
      </div>
    </li>
  </ul>
  <%-- ************************* end product description ************************* --%>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/emailAFriendProductDetails.jsp#2 $$Change: 635969 $--%>
