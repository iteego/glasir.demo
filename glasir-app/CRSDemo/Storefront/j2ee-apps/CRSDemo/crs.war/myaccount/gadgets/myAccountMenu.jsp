<dsp:page>

  <%--
    This page fragment renders My Account Menu for navigating to profile information,
    payment settings, addresses, wish lists, gift lists and previous orders. 
    
    Parameters:
     - selpage - indicates which menu option is currently selected
  --%>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale"/>
  <dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler"/>  
  
  <%-- unpack selected tab --%>
  <dsp:getvalueof var="activeTab" param="selpage"/>
  <div id="atg_store_myAccountNav" class="aside">
  <ul>
   
    <%-- profile information --%>
    <fmt:message var="linkText" key="myaccount_myAccountMenu.profile"/>
    <c:choose>
      <c:when test="${activeTab == 'MY PROFILE'}">
        <li class="first current">
      </c:when>
      <c:otherwise>
        <li class="first">
      </c:otherwise>
    </c:choose>
          <dsp:a page="../profile.jsp" title="${linkText}">
            <dsp:param name="selpage" value="MY PROFILE"/>
            ${linkText}
          </dsp:a>
        </li>  
    
    <%-- payment info --%>
    <fmt:message var="linkText" key="myaccount_myAccountMenu.paymentInfo"/>
    <c:choose>
     <c:when test="${activeTab == 'PAYMENT INFO'}">
       <li class="current">
     </c:when>
     <c:otherwise>
       <li>
     </c:otherwise>
    </c:choose>
         <dsp:a page="../paymentInfo.jsp" title="${linkText}">${linkText}</dsp:a>
       </li>

    <%-- address book --%>
    <fmt:message var="linkText" key="myaccount_myAccountMenu.addressBook"/>
    <c:choose>
     <c:when test="${activeTab == 'ADDRESS BOOK'}">
       <li class="current">
     </c:when>
     <c:otherwise>
       <li>
     </c:otherwise>
    </c:choose>    
      <dsp:a page="../addressBook.jsp" title="${linkText}">${linkText}</dsp:a>
    </li>
    
    <%-- orders --%>
    <fmt:message var="linkText" key="myaccount_myAccountMenu.myOrders"/>
    <c:choose>
      <c:when test="${activeTab == 'MY ORDERS'}">
        <li class="current">
      </c:when>
      <c:otherwise>
        <li>
      </c:otherwise>
    </c:choose>
       <dsp:a page="../myOrders.jsp" title="${linkText}">
         <dsp:param name="selpage" value="MY ORDERS"/>
         ${linkText}
       </dsp:a>
     </li>
    
    <%-- wish lists --%>
    <fmt:message var="linkText" key="myaccount_myAccountMenu.myWishList"/>
    <c:choose>
     <c:when test="${activeTab == 'WISHLIST'}">
       <li class="current">
     </c:when>
     <c:otherwise>
       <li>
     </c:otherwise>
    </c:choose>
       <dsp:a page="../myWishList.jsp" title="${linkText}">
       <dsp:param name="selpage" value="WISHLIST"/>
       ${linkText}</dsp:a>
     </li>

    <%-- gift lists --%>
    <fmt:message var="linkText" key="myaccount_myAccountMenu.giftLists"/>
    <c:choose>
     <c:when test="${activeTab == 'GIFT LISTS'}">
       <li class="current">
     </c:when>
     <c:otherwise>
       <li>
     </c:otherwise>
    </c:choose>
     <dsp:a page="../giftListHome.jsp" title="${linkText}">
       <dsp:param name="selpage" value="GIFT LISTS"/>
       ${linkText}
     </dsp:a>
   </li>
   
   <%-- Log Out --%>
   <li class="atg_store_myAccountNavLogout">
     <dsp:getvalueof id="userLocale" vartype="java.lang.String"  bean="RequestLocale.locale"/>
     <dsp:a page="/" title="Logout" value="logout" iclass="atg_store_logoutLink">
       <dsp:property bean="B2CProfileFormHandler.logoutSuccessURL" value="myaccount/login.jsp?locale=${userLocale}"/>
       <dsp:property bean="B2CProfileFormHandler.logout" value="true"/>
       <fmt:message key="navigation.welcome.logout"/>
     </dsp:a>
   </li>

  </ul>
  
  <dsp:include page="/navigation/gadgets/clickToCallLink.jsp">
    <dsp:param name="pageName" value="orderHistory"/>
  </dsp:include>
</div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/myAccountMenu.jsp#2 $$Change: 635969 $--%>
