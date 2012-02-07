<dsp:page>

  <%-- 
      This gadget renders a "Continue to Billing" button 

      Form Condition:
      - This gadget must be contained inside of a form.
        ShippingGroupFormHandler must be invoked from a submit 
        button in this form for fields in this page to be processed
  --%>

  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  
  <dsp:getvalueof var="single" param="single"/>
    
  <fieldset class="atg_store_checkoutContinue">
    <div class="atg_store_formActions">  
    
    <fmt:message var="continueButtonText" key="common.button.continueText"/>
    <span class="atg_store_basicButton">
      <dsp:input type="submit"  bean="ShippingGroupFormHandler.moveToBilling" value="${continueButtonText}"/>
    </span>
    <dsp:getvalueof var="giftShippingGroups" vartype="java.lang.Object" bean="ShippingGroupFormHandler.giftShippingGroups"/>  
    <c:choose>
       <c:when test="${single == false}">
         <dsp:a href="${pageContext.request.contextPath}/checkout/shippingSingle.jsp">
           <dsp:param name="init" value="true"/>
   
             <fmt:message  key="common.button.singleAddressShipping"/>
    
         </dsp:a>
       </c:when>
      </c:choose>
    </div>
  </fieldset>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/checkoutContinue.jsp#2 $$Change: 635969 $--%>
