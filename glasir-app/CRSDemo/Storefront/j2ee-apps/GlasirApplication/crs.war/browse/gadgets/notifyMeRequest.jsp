<dsp:page>

<%--
  This page accepts the email address of an user to notify as soon as the product is back in stock
--%>

  <dsp:importbean bean="/atg/store/inventory/BackInStockFormHandler"/>
  
  <%-- Optional --%>
  <dsp:getvalueof var="redirectURL" param="redirectURL"/> 
  <%-- Required --%>
  <dsp:getvalueof id="contextroot" idtype="java.lang.String"
                  bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof id="skuId" idtype="java.lang.String" param="skuId" />
  <dsp:getvalueof id="productId" idtype="java.lang.String" param="productId" />

  <%-- Show Form Errors --%>
  <dsp:include page="/global/gadgets/errorMessage.jsp">
    <dsp:param name="formhandler" bean="BackInStockFormHandler"/>
  </dsp:include>

  <dsp:form method="post" action="${contextroot}/browse/notifyMeConfirmPopup.jsp"
            formid="notifyMe" id="atg_store_notifyMeRequestForm">
    <%-- Form properties --%>
    <dsp:input bean="BackInStockFormHandler.catalogRefId" type="hidden"
               paramvalue="skuId"/>
    <dsp:input bean="BackInStockFormHandler.productId" type="hidden"
               paramvalue="productId"/>
              
    <%-- Set the standard URLs --%>
    <dsp:input bean="BackInStockFormHandler.successURL" type="hidden"
               value="${contextroot}/browse/notifyMeConfirmPopup.jsp"/>
    <dsp:input bean="BackInStockFormHandler.errorURL" type="hidden"
               value="${contextroot}/browse/notifyMeRequestPopup.jsp?skuId=${skuId}&productId=${productId}"/>
               
    <%-- Set the noJavascriptSuccessURL --%>  
    <c:if test="${not empty redirectURL}">
      <dsp:input bean="BackInStockFormHandler.noJavascriptSuccessURL" value="${redirectURL}&status=emailSent" 
        type="hidden"/>
      <dsp:input bean="BackInStockFormHandler.noJavascriptErrorURL" value="${redirectURL}&status=unavailable&skuId=${skuId}" 
       type="hidden"/>     
     </c:if>

    <ul class="atg_store_basicForm">
      <li class="atg_store_email">
        <label for="atg_store_emailInput" class="required">
          <fmt:message key="common.emailAddress"/>
          <span><fmt:message key="common.emailExample"/></span>
          <span class="required"><fmt:message key="common.requiredFields"/></span>
        </label>
      
        <dsp:input bean="BackInStockFormHandler.emailAddress" type="text"
                   size="48" beanvalue="/atg/userprofiling/Profile.email" id="atg_store_emailInput"/>
      </li>
    </ul>
    
      
   
   
      <div class="atg_store_formActions">
      <fmt:message var="submitText" key="common.button.submitText"/>
      <fmt:message var="submitTitle" key="common.button.submitTitle"/>
      <span class="atg_store_basicButton tertiary">
      <dsp:input bean="BackInStockFormHandler.notifyMe" type="submit" title="${submitTitle}"
                 value="${submitText}" iclass="atg_store_actionSubmit"/>
                </span>
      </div>

  </dsp:form>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/notifyMeRequest.jsp#2 $$Change: 635969 $ --%>
