<dsp:page>

  <%-- This page expects the following input parameters
       productId - the product id being displayed
       categoryId (optional) - the id of the category the product is viewed from
  --%>
  <div id="atg_store_picker">     
    <dsp:include page="pickerContents.jsp">
      <dsp:param name="productId" param="productId"/>
      <dsp:param name="categoryId" param="categoryId"/>
    </dsp:include>
  </div><%-- atg_store_picker --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/picker.jsp#2 $$Change: 635969 $--%>
