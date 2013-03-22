<dsp:page>

  <%-- This page expects the following input parameters
       productId - the id of the product whose details are shown
       picker - set the attribute picker which will be rendered
       categoryId (optional) - the id of the category the product is viewed from
       tabname (optional) - the name of a more details tab to display
       initialQuantity (optional) - sets the initial quantity to preset in the form
       categoryNavIds (optional) - ':' separated list representing the category navigation trail
       categoryNav (optional) - Determines if breadcrumbs are updated to reflect category navigation trail on click through
       navAction (optional) - type of breadcrumb navigation used to reach this page for tracking. 
                                Valid values are push, pop, or jump. Default is jump.
       navCount (optional) - current navigation count used to track for the use of the back button
    --%>
    
  <dsp:include page="gadgets/productLookupForDisplay.jsp">
    <dsp:param name="productId" param="productId" />
    <dsp:param name="picker" param="picker" />
    <dsp:param name="categoryId" param="categoryId" />
    <dsp:param name="tabname" param="tabname" />
    <dsp:param name="initialQuantity" param="initialQuantity" />
    <dsp:param name="container" value="/browse/productDetailDisplay.jsp" />
    <dsp:param name="categoryNavIds" param="categoryNavIds"/>
    <dsp:param name="categoryNav" param="categoryNav"/>
    <dsp:param name="navAction" param="navAction" />
    <dsp:param name="navCount" param="navCount" />
  </dsp:include>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/productDetail.jsp#2 $$Change: 635969 $ --%>
