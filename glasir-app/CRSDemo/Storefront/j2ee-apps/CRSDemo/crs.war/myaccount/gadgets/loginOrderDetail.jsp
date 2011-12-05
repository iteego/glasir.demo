<dsp:page>

  <dsp:importbean bean="/atg/dynamo/Configuration" var="config"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/profile/SessionBean"/>  

  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>  

  <dsp:getvalueof var="orderShippedFromAddress" bean="Site.orderShippedFromAddress" />
  <dsp:setvalue param="httpserver" value="http://${config.siteHttpServerName}:${config.siteHttpServerPort}"/>
  <dsp:getvalueof var="message" param="message"/>
  <dsp:getvalueof var="orderId" bean="SessionBean.values.orderId"/>
  
  <c:if test="${empty orderId}">
    <dsp:getvalueof var="orderId" param="orderId"/>
  </c:if>

  <dsp:getvalueof var="orderDetailURL" value="/myaccount/orderDetail.jsp?orderId=${orderId}"/>
  <dsp:setvalue bean="SessionBean.values.loginSuccessURL" value="${orderDetailURL}"/>
  
  <dsp:getvalueof var="isTransient" bean="Profile.transient"/>
  <c:choose>
    <c:when test="${isTransient}">
        <dsp:include page="/myaccount/login.jsp"/>
        <dsp:setvalue bean="SessionBean.values.orderId" value="${orderId}"/>
    </c:when>
    <c:otherwise>
        <dsp:include page="${orderDetailURL}"/>
        <dsp:setvalue bean="SessionBean.values.orderId" value=""/>
    </c:otherwise>
  </c:choose>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/loginOrderDetail.jsp#3 $$Change: 635969 $--%>

