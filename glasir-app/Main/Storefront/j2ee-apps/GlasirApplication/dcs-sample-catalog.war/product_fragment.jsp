<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>

<%--
In the following code we switch on the type of product that we are going to display.
If the product is a gift certificate than it is a soft good and must be displayed
with a different page.  The display_softgood_product.jhtml differs from the  
display_product.jhtml in that it allows the page to take in information unique to
soft goods.  This is not the recommeneded approach in a production environment.  Rather,
the preferred mechansim is to use the template property of the product.  Refer to
the Pioneer Cycling store on how to do this.
--%>

<dsp:droplet name="/atg/dynamo/droplet/Switch">
<dsp:param name="value" param="childProduct.displayName"/>

  <dsp:oparam name="Gift Certificate">
    <dsp:a href="display_softgood_product.jsp">
     <dsp:param name="id" param="childProduct.repositoryId"/>
     <dsp:valueof param="childProduct.displayName">ERROR:no product name</dsp:valueof>
    </dsp:a>
  </dsp:oparam>

  <dsp:oparam name="default">

    <%-- If using B2B catalog display part number for each child SKU. --%>
    <dsp:droplet name="ComponentExists">
      <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
      <dsp:oparam name="true">
      <dsp:droplet name="/atg/dynamo/droplet/ForEach">
	<dsp:param name="array" param="childProduct.childSKUs"/>
	<dsp:param name="elementName" value="sku"/>
	<dsp:oparam name="output">
	    <dsp:valueof param="sku.manufacturer_part_number">No part number</dsp:valueof>
	</dsp:oparam>
      </dsp:droplet>
      </dsp:oparam>
    </dsp:droplet>

    <%-- In both B2C and B2C catalogs, display product name --%>
    <dsp:a href="display_product.jsp">
     <dsp:param name="id" param="childProduct.repositoryId"/>
     <dsp:valueof param="childProduct.displayName">ERROR:no product name</dsp:valueof>
    </dsp:a>

    <%-- In B2B catalog we also display product description, since many products may have the same display name --%>
    <dsp:droplet name="ComponentExists">
      <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
      <dsp:oparam name="true">
        <dsp:droplet name="IsEmpty">
	<dsp:param name="value" param="childProduct.description"/>
	<dsp:oparam name="false">&nbsp;-&nbsp;<dsp:valueof param="childProduct.description"/></dsp:oparam>
        </dsp:droplet>
      </dsp:oparam>
    </dsp:droplet>
  </dsp:oparam>
</dsp:droplet>

<BR>

<%--
This example code snippet can be used to link to a template associated with the
product. If this template was used in the context of the Pioneer Cycling 
Store these template hrefs would jump back into the bike store, we do not want that 
for these example pages.  For these pages we have just made a simple template 
that all products will use. 

<dsp:droplet name="/atg/dynamo/droplet/IsNull">
  <dsp:param name="value" param="childProduct.template"/>
  <dsp:oparam name="true">
    <dsp:valueof param="childProduct.displayName">ERROR:no product name</dsp:valueof>
  </dsp:oparam>
  <dsp:oparam name="false">
    <dsp:getvalueof id="a78" param="childProduct.template.url" idtype="java.lang.String">
      <dsp:a href="<%=a78%>">
      <dsp:param name="id" param="childProduct.repositoryId"/>
      <dsp:valueof param="childProduct.displayName">ERROR:no product name</dsp:valueof>
    </dsp:a></dsp:getvalueof>
  </dsp:oparam>
</dsp:droplet>
<BR>
--%>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/product_fragment.jsp#2 $$Change: 635969 $--%>
