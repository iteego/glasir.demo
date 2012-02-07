<%--
  This page renders layout for products with single SKU.
  
  Input parameters:
        
--%>
<dsp:page>
  <dsp:include page="gadgets/productLookupForDisplay.jsp">
    <dsp:param name="productId" param="productId" />
    <dsp:param name="categoryId" param="categoryId" />
    <dsp:param name="initialQuantity" param="initialQuantity" />
    <dsp:param name="container" value="/browse/productDetailMultiSkuContainer.jsp" />
    <dsp:param name="categoryNavIds" param="categoryNavIds"/>
    <dsp:param name="categoryNav" param="categoryNav"/>
    <dsp:param name="navAction" param="navAction" />
    <dsp:param name="navCount" param="navCount" />
  </dsp:include>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/productDetailMultiSku.jsp#2 $$Change: 635969 $ --%>