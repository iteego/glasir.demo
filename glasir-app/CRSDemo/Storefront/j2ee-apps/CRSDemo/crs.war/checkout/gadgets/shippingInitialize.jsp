<%--  This page will initialize the data object needed to organize shipping --%>
<%--  It takes the following parameters: --%>
<%--  1. init - true or false: --%>
<%--  2. oneInfoPerUnit: true or false --%>
<%--  3. initSingleShippingForm:  true or false: --%>
<%--  4. initMultipleShippingForm: true or false: --%>

<dsp:page>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupDroplet"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
    
  <dsp:getvalueof var="init" param="init"/> 
  <c:if test='${init == "true"}'>
    <dsp:droplet name="ShippingGroupDroplet">
      <dsp:param name="createOneInfoPerUnit" param="oneInfoPerUnit"/>
      <dsp:param name="clearShippingInfos" param="init"/>
      <dsp:param name="clearShippingGroups" param="init"/>
      <dsp:param name="shippingGroupTypes" value="hardgoodShippingGroup"/>
      <dsp:param name="initShippingGroups" param="init"/>
      <dsp:param name="initBasedOnOrder" param="init"/>
      <dsp:oparam name="output"/>
    </dsp:droplet>
  </c:if>
  

  <dsp:getvalueof var="initSingleShippingForm" param="initSingleShippingForm"/> 
  <c:if test='${initSingleShippingForm == "true"}'>
    <dsp:setvalue bean="ShippingGroupFormHandler.initSingleShippingForm" value=""/>
  </c:if>

  <dsp:getvalueof var="initMultipleShippingForm" param="initMultipleShippingForm"/> 
  <c:if test='${initMultipleShippingForm == "true"}'>
    <dsp:setvalue bean="ShippingGroupFormHandler.initMultipleShippingForm" value=""/>
  </c:if>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/shippingInitialize.jsp#2 $$Change: 635969 $--%>