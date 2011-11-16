<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object whose details are shown
       categoryId (optional) - the id of the category the product is viewed from
    --%>
  <div class="atg_store_productImageContainer">
    <div class="atg_store_productImage"> 
      <dsp:include page="gadgets/productImage.jsp">
        <dsp:param name="product" param="product"/>
      </dsp:include>
    </div>
  </div>

  <dsp:include page="gadgets/productAsSeenIn.jsp">
    <dsp:param name="product" param="product"/>
  </dsp:include>  

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/productDetailCachedContainer.jsp#2 $$Change: 635969 $ --%>
