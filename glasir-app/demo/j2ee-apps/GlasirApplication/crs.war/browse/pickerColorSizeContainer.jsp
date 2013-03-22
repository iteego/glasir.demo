<dsp:page>

	<dsp:importbean bean="/atg/store/droplet/ColorSizeDroplet"/>
  <dsp:include page="gadgets/noJsPickerLayout.jsp">
    <dsp:param name="product" param="product"/>
    <dsp:param name="categoryId" param="categoryId"/>
    <dsp:param name="skus" param="filteredCollection"/>
  </dsp:include>
  <dsp:droplet name="ColorSizeDroplet">
    <dsp:param name="skus" param="filteredCollection"/>
    <dsp:param name="selectedColor" param="selectedColor"/>
    <dsp:param name="selectedSize" param="selectedSize"/>
    <dsp:oparam name="output">
      <dsp:include page="gadgets/pickerContents.jsp">
        <dsp:param name="productId" param="product.repositoryId"/>
        <dsp:param name="categoryId" param="categoryId"/>
      </dsp:include>
    </dsp:oparam>
  </dsp:droplet><%-- ColorSizeDroplet --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/pickerColorSizeContainer.jsp#2 $$Change: 635969 $--%>
