<%--
     This gadget contains form params that are the same for each gift list and wish list.
--%>
<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>

<dsp:getvalueof var="skuId" vartype="java.lang.String" param="sku.repositoryId"/>
<dsp:getvalueof var="productId" vartype="java.lang.String" param="product.repositoryId"/> 
<dsp:getvalueof var="templateUrl" vartype="java.lang.String" param="product.template.url"/>
<dsp:getvalueof var="categoryId" vartype="java.lang.String" param="categoryId"/>
<dsp:getvalueof var="categoryNavIds" vartype="java.lang.String" param="categoryNavIds"/>
<dsp:getvalueof var="contextPath" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>


<c:url var="errorUrl" scope="page" value="${templateUrl}">
  <c:param name="productId" value="${productId}"/>
  <c:param name="categoryId" value="${categoryId}"/>
  <c:param name="categoryNavIds" value="${categoryNavIds}"/>
</c:url>

<dsp:input type="hidden" bean="GiftlistFormHandler.quantity" value="1"/>
<dsp:input type="hidden" bean="GiftlistFormHandler.productId" value="${productId}"/>
<dsp:input type="hidden" bean="GiftlistFormHandler.addItemToGiftlistErrorURL" value="${errorUrl}"/>
<dsp:input type="hidden" bean="GiftlistFormHandler.addItemToGiftlistLoginURL" value="${contextPath}/global/util/loginRedirect.jsp"/>
<dsp:input type="hidden" bean="GiftlistFormHandler.catalogRefIds" value="${skuId}"/>
  
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/pickerAddToGiftListFormParams.jsp#2 $$Change: 635969 $--%>                     