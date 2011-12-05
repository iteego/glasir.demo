<dsp:page>
  <%-- Page used for determining user's current state.

     Parameters:
     - source
     - productId
     - categoryId
  --%>
  <dsp:importbean bean="/atg/store/profile/SessionBean" />
  <dsp:importbean bean="/atg/dynamo/droplet/Compare" />
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile" />
  <dsp:importbean bean="/atg/userprofiling/PropertyManager" />

  <dsp:droplet name="Compare">
    <dsp:param name="obj1" bean="Profile.securityStatus" />
    <dsp:param name="obj2" bean="PropertyManager.securityStatusCookie" />
    <dsp:oparam name="lessthan">
      <%-- Anonymous User --%>
      <fmt:message var="itemLabel" key="navigation_loginLogout.login" />
      <fmt:message var="itemTitle" key="navigation_personalNavigation.linkTitle">
        <fmt:param value="${itemLabel}"/>
      </fmt:message>
  
      <%-- Redirect user to profile.jsp if they are logging in after resetting their password--%>
      <dsp:getvalueof var="source" param="source"/>
      <c:choose>
        <c:when test="${source == 'resetPassword'}">
          <%-- Redirect to login and reset the SessionBean.values.loginSuccessURL--%>
          <dsp:a page="/myaccount/login.jsp"
                 bean="SessionBean.values.loginSuccessURL"
                 value="" title="${itemTitle}"
                 iclass="atg_store_navLogin">
            ${itemLabel}
          </dsp:a>
        </c:when>

        <c:otherwise>
          <dsp:getvalueof var="OriginatingRequest" vartype="java.lang.String"
                          bean="OriginatingRequest" />
          <c:choose>
            <c:when test="${not empty param.productId || not empty param.categoryId}">
              <dsp:a page="/global/util/loginRedirect.jsp"
                     bean="SessionBean.values.loginSuccessURL"
                     value="${OriginatingRequest.requestURI}?categoryId=${param.categoryId}&productId=${param.productId}"
                     title="${itemTitle}" iclass="atg_store_navLogin">
                ${itemLabel}
              </dsp:a>
            </c:when>
            <c:when test="${not empty giftlistId}">
              <dsp:a page="/global/util/loginRedirect.jsp"
                     bean="SessionBean.values.loginSuccessURL"
                     value="${OriginatingRequest.requestURI}?giftlistId=${param.giftlistId}"
                     title="${itemTitle}" iclass="atg_store_navLogin">
                ${itemLabel}
              </dsp:a>
            </c:when>
            <c:when test="${not empty param.orderId}">
              <dsp:a page="/global/util/loginRedirect.jsp"
                     bean="SessionBean.values.loginSuccessURL"
                     value="${OriginatingRequest.requestURI}?orderId=${param.orderId}"
                     title="${itemTitle}" iclass="atg_store_navLogin">
                ${itemLabel}
              </dsp:a>
            </c:when>
            <c:when test="${not empty param.defaultToProfile}">
              <dsp:a page="/global/util/loginRedirect.jsp"
                     bean="SessionBean.values.loginSuccessURL"
                     value="${OriginatingRequest.contextPath}/myaccount/profile.jsp"
                     title="${itemTitle}" iclass="atg_store_navLogin">
                ${itemLabel}
              </dsp:a>
            </c:when>
            <c:otherwise>
              <dsp:a page="/global/util/loginRedirect.jsp"
                     bean="SessionBean.values.loginSuccessURL"
                     value="${OriginatingRequest.requestURI}"
                     title="${itemTitle}" iclass="atg_store_navLogin">
                ${itemLabel}
              </dsp:a>
            </c:otherwise>
          </c:choose>

        </c:otherwise>
      </c:choose>
    </dsp:oparam>
  
    <dsp:oparam name="default">
      <fmt:message var="itemLabel" key="navigation_loginLogout.logout" />
      <fmt:message var="itemTitle" key="navigation_personalNavigation.linkTitle">
        <fmt:param value="${itemLabel}"/>
      </fmt:message>
      <%-- Recognized User --%>
      <%-- Logged in User --%>
      <dsp:a page="/myaccount/login.jsp"
             bean="B2CProfileFormHandler.logout" value="logout"
             iclass="subNavLink">
        ${itemLabel}
      </dsp:a>
    </dsp:oparam>
  </dsp:droplet>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/loginLogout.jsp#2 $$Change: 635969 $ --%>
