<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object being displayed
  --%>
  <dsp:getvalueof id="product" param="product"/>
  
  <dsp:valueof param="product.longDescription" valueishtml="true">
    <fmt:message key="common.longDescriptionDefault"/>
  </dsp:valueof>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productMetadataDescription.jsp#2 $$Change: 635969 $ --%>
