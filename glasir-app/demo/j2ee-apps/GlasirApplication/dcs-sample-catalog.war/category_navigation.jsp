<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>


<strong>Category: <dsp:valueof param="category.displayName"/></strong>
<blockquote>
<DL>
<DT>Child Categories:
<dsp:droplet name="/atg/dynamo/droplet/ForEach">
  <dsp:param name="array" param="category.childCategories"/>
  <dsp:param name="elementName" value="childCategory"/>
  <dsp:param name="indexName" value="categoryIndex"/>
  <dsp:oparam name="output">
    <DD><dsp:include page="category_fragment.jsp"></dsp:include>  
  </dsp:oparam>
</dsp:droplet>

<DT>Child Products:
<dsp:droplet name="/atg/dynamo/droplet/ForEach">
  <dsp:param name="array" param="category.childProducts"/>
  <dsp:param name="elementName" value="childProduct"/>
  <dsp:param name="indexName" value="productIndex"/>
  <dsp:oparam name="output">
    <DD><dsp:include page="product_fragment.jsp"></dsp:include>
  </dsp:oparam>
</dsp:droplet>
</DL>
</blockquote>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/category_navigation.jsp#2 $$Change: 635969 $--%>
