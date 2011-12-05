<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object whose details are shown
       categoryId (optional) - the id of the category the product is viewed from
       container - set to the container to call with the product object
       keySuffix - a unique suffix to add to the key
    --%>
  <dsp:getvalueof id="product" param="product"/>
  <dsp:getvalueof id="categoryId" param="categoryId"/>
  <dsp:getvalueof id="container" param="container"/>
  <dsp:getvalueof id="keySuffix" param="keySuffix"/>
  
  <dsp:importbean bean="/atg/dynamo/droplet/Cache"/>
  <dsp:importbean bean="/atg/repository/seo/BrowserTyperDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  
  <%-- Use the Cache Droplet to provide performance caching --%>
  <dsp:getvalueof var="productId" vartype="java.lang.String" param="product.repositoryId"/>
  <dsp:getvalueof var="storeId" vartype="java.lang.String" bean="Profile.storeId"/>
  <dsp:droplet name="BrowserTyperDroplet">
    <dsp:oparam name="output">
      <dsp:droplet name="Cache">
        <dsp:param name="key" value="bp_pd_${keySuffix}_${productId}_${param.browserType}_${requestLocale.locale}_${storeId}"/>
        <dsp:oparam name="output">
          <dsp:include page="${container}">
            <dsp:param name="product" param="element"/>
            <dsp:param name="categoryId" param="categoryId"/>
          </dsp:include>
        </dsp:oparam>
      </dsp:droplet> <%-- End cache droplet to cache this part of the page --%>
    </dsp:oparam>
  </dsp:droplet> <%-- BrowserTyperDroplet --%>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/cacheProductDisplay.jsp#2 $$Change: 635969 $ --%>
