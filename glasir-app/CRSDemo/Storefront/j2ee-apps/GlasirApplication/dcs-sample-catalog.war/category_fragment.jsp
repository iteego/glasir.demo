<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:a href="display_category.jsp">
  <dsp:param name="id" param="childCategory.repositoryId"/>
  <dsp:valueof param="childCategory.displayName">ERROR:no category name</dsp:valueof><br>  
</dsp:a>

<%--

// This example code snippet can be used to link to a template associated with the
// category. If this template was used in the context of the Pioneer Cycling 
// Store these template hrefs would jump back into the bike store, we do not want that 
// for these example pages.For these devtest pages we have just made a simple template 
// that all categories will use. 

<dsp:droplet name="/atg/dynamo/droplet/IsNull">
  <dsp:param name="value" param="childCategory.template"/>
  <dsp:oparam name="true">
      <dsp:valueof param="childCategory.displayName">ERROR:no category name</dsp:valueof>
  </dsp:oparam>
  <dsp:oparam name="false">
    <dsp:getvalueof id="a29" param="childCategory.template.url" idtype="java.lang.String">
<dsp:a href="<%=a29%>">
      <dsp:param name="id" param="childCategory.repositoryId"/>
      <dsp:valueof param="childCategory.displayName">ERROR:no category name</dsp:valueof>
    </dsp:a></dsp:getvalueof>
  </dsp:oparam>
</dsp:droplet>
<br>  

--%>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/category_fragment.jsp#2 $$Change: 635969 $--%>
