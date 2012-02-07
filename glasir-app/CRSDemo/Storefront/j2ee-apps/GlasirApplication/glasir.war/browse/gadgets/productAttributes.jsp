<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object being displayed
       categoryId (optional) - the id of the category the product is viewed from
       
  --%>
  <dsp:getvalueof id="product" param="product"/>
  <dsp:getvalueof id="categoryId" param="categoryId"/>
    
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  
  <dsp:getvalueof id="product" param="product" />
  <dsp:getvalueof id="categoryId" param="categoryId" /> 
  
  <%-- Display 'As seen in' link if necessary --%>
  <dsp:include page="productAsSeenIn.jsp">
    <dsp:param name="product" param="product"/>
  </dsp:include>
  
  <%-- product metadata description --%>
  <dsp:include page="/browse/gadgets/moreDetails.jsp" flush="true">
    <dsp:param name="product" param="product"/>
  </dsp:include>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productAttributes.jsp#1 $$Change: 633540 $--%>
