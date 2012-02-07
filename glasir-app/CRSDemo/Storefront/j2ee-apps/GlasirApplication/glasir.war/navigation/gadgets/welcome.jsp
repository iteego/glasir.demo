<%--
  Page renders welcome info by determining user's state.
--%>
<dsp:page>

  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale"/>
  <dsp:getvalueof var="isTransient" bean="Profile.transient"/>
  <dsp:getvalueof var="origRequest" vartype="java.lang.String" bean="/OriginatingRequest.requestURI" />
  <dsp:getvalueof id="userLocale" vartype="java.lang.String"  bean="RequestLocale.locale"/>
  <%-- unpack selected tab --%>
  <dsp:getvalueof var="activeTab" param="selpage"/>

  <div id="atg_store_logOut">

      <%-- We need this to determine if the current page is the 'profile' page when the user
           logs in as there is no other way to set the 'selpage' param from the login page.
      --%>
      <c:if test="${fn:contains(origRequest,'profile.jsp')}">
        <c:set var="activeTab" value="MY PROFILE"/>
      </c:if>
    
      <c:choose>
        <c:when test="${not isTransient}">
                  <dsp:getvalueof id="firstName" bean="Profile.firstName"/>
          <c:if test="${empty firstName}">
            <fmt:message var="firstName" key="navigation_welcome.firstName"/>
          </c:if>

          <ul>
            <li class="first atg_store_welcomeMessage">
              <span class="atg_store_welcome"><fmt:message key="navigation.welcomeback"/></span>
              <span class="atg_store_loggedInUser">
                <strong>
                  <c:out value="${firstName}"/>
                </strong>
                <dsp:a page="/" title="${logoutTitle}" value="logout" iclass="atg_store_logoutLink">
                  <dsp:property bean="B2CProfileFormHandler.logoutSuccessURL" value="myaccount/login.jsp?locale=${userLocale}"/>
                  <dsp:property bean="B2CProfileFormHandler.logout" value="true"/>
                  <fmt:message key="navigation_welcome.notText"/>
                </dsp:a>                
              </span>
  
            </li>
            <c:choose>
              <c:when test="${activeTab == 'MY PROFILE'}">
                <li class="active">
              </c:when>
              <c:otherwise>
                <li>
              </c:otherwise>
            </c:choose>
              <dsp:a page="/myaccount/profile.jsp" title="${itemTitle}" iclass="atg_store_navAccount">
                  <dsp:param name="selpage" value="MY PROFILE"/>
                  <fmt:message key="navigation.welcome.account"/>
              </dsp:a>
            </li>
            <c:choose>
              <c:when test="${activeTab == 'MY ORDERS'}">
                <li class="active">
              </c:when>
              <c:otherwise>
                <li>
              </c:otherwise>
            </c:choose>
              <dsp:a page="/myaccount/myOrders.jsp" title="${itemTitle}" iclass="atg_store_navAccount">
                <dsp:param name="selpage" value="MY ORDERS"/>
                <fmt:message key="navigation.welcome.orders"/>
              </dsp:a>
            </li>
            <c:choose>
              <c:when test="${activeTab == 'customerService'}">
                <li class="active">
              </c:when>
              <c:otherwise>
                <li>
              </c:otherwise>
            </c:choose>
              <dsp:a page="/company/customerService.jsp">
              <dsp:param name="selpage" value="customerService"/>
                <fmt:message key="navigation.welcome.help"/>
                <dsp:param name="selpage" value="customerService"/>
              </dsp:a>
            </li>
            <li class="last">
              <dsp:a page="/" title="${logoutTitle}">
                <dsp:property bean="B2CProfileFormHandler.logoutSuccessURL" value="myaccount/login.jsp?locale=${userLocale}"/>
                <dsp:property bean="B2CProfileFormHandler.logout" value="true"/>
                <fmt:message key="navigation.welcome.logout"/>
              </dsp:a>
            </li>
         </ul>
          </c:when>
          <c:otherwise>

        <ul>
          <li class="first">
            <span class="atg_store_welcome"><fmt:message key="navigation.welcome"/></span>
          </li>
          <li>
            <dsp:a page="/myaccount/login.jsp" title="${logoutTitle}">
              <fmt:message key="checkout_checkoutProgress.login"/>
              <dsp:param name="loginFromHeader" value="yes"/>
            </dsp:a>
          </li>
          <c:choose>
            <c:when test="${activeTab == 'customerService'}">
              <li class="active">
            </c:when>
            <c:otherwise>
              <li class="last">
            </c:otherwise>
          </c:choose>
          <dsp:a page="/company/customerService.jsp">
            <dsp:param name="selpage" value="customerService"/>
            <fmt:message key="navigation.welcome.help"/>
          </dsp:a>
          </li>
        </ul>
          </c:otherwise>
      </c:choose>

  </div>
    
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/welcome.jsp#2 $$Change: 635969 $ --%>
