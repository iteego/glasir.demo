<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object being displayed
  --%>
  <dsp:getvalueof id="product" param="product"/>
  
  <div id="atg_store_productMetadataName">
    <p class="atg_store_productName">
      <dsp:valueof param="product.description">
        <fmt:message key="browse_productMetadata.descriptionDefault"/>
      </dsp:valueof>
    </p>
  </div>
    
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productMetadataName.jsp#2 $$Change: 635969 $ --%>
