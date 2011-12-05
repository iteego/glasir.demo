<dsp:page>

  <dsp:importbean bean="/atg/store/profile/SessionBean"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>

  <%-- unpack selected tab --%>
  <dsp:getvalueof var="activeTab" param="selpage"/>

  <div id="atg_store_personalNav">
    <ul>
      <c:set var="count" value="0"/>

      <%-- HOME LINK --%>
      <c:set var="count" value="${count + 1}"/>
      <%-- To mark the last item properly, set size to count + 1 for all but the
           very last item.  For that one, set size to count. --%>
           
           
       <%-- PROMOTIONS LINK --%>
       <c:choose>
         <c:when test="${activeTab == 'PROMOTIONS'}">
           <li class="active">
         </c:when>
         <c:otherwise>
           <li>
         </c:otherwise>
       </c:choose>
         <fmt:message var="itemLabel" key="navigation_personalNavigation.promotions"/>
         <fmt:message var="itemTitle" key="navigation_personalNavigation.linkTitle">
           <fmt:param value="${itemLabel}"/>
         </fmt:message>
         <dsp:a id="productPromotions" page="/promo/promotions.jsp" title="${itemTitle}"
                iclass="atg_store_navPromotions">
           <dsp:param name="selpage" value="PROMOTIONS"/>
           ${itemLabel}
         </dsp:a>
       </li>     
       
       
       <%-- COMPARISONS LINK --%>
       <c:choose>
         <c:when test="${activeTab == 'COMPARISONS'}">
           <li class="active">
         </c:when>
         <c:otherwise>
           <li>
         </c:otherwise>
       </c:choose>
         <fmt:message var="itemLabel" key="navigation_personalNavigation.comparisons"/>
         <fmt:message var="itemTitle" key="navigation_personalNavigation.linkTitle">
           <fmt:param value="${itemLabel}"/>
         </fmt:message>
         <dsp:a id="productComparisons" page="/browse/productComparisons.jsp" title="${itemTitle}"
                iclass="atg_store_navComparisons">
           <dsp:param name="selpage" value="COMPARISONS"/>
           ${itemLabel}
         </dsp:a>
       </li>     
           
      <%-- GIFT LIST LINK --%>
       <c:choose>
         <c:when test="${activeTab == 'GIFT LISTS'}">
           <li class="atg_store_giftListsNav active">
         </c:when>
         <c:otherwise>
           <li class="atg_store_giftListsNav">
         </c:otherwise>
       </c:choose>      
        <fmt:message var="itemLabel" key="navigation_personalNavigation.giftList"/>
        <a id="giftList" href="#" iclass="atg_store_navGiftList">
          <%--${itemLabel} Replace with change to properties  --%>
          ${itemLabel}
        </a>
        
        <div class="atg_store_giftListMenuContainer">
          <ul class="atg_store_giftListMenu">
            <dsp:droplet name="Compare">
            <dsp:param name="obj1" bean="Profile.securityStatus"/>
            <dsp:param name="obj2" bean="PropertyManager.securityStatusCookie"/>
            <dsp:oparam name="greaterthan">
              <%-- Logged in User --%>
              <c:url value="/myaccount/giftListHome.jsp" var="giftlistHomeUrl" scope="page">
                <c:param name="selpage" value="GIFT LISTS"/>
              </c:url>
            </dsp:oparam>
            <dsp:oparam name="default">
              <%-- Anonymous User --%>
              <%-- Recognized User --%>
              <c:url value="/myaccount/login.jsp?error=giftlistNotLoggedIn" var="giftlistHomeUrl" scope="page"/>
            </dsp:oparam>
          </dsp:droplet>
            <c:url value="/giftlists/giftListSearch.jsp" var="findGiftUrl" scope="page">
              <c:param name="resetFormErrors">true</c:param>
            </c:url>
            <li>
              <dsp:a href="${findGiftUrl}">
                <dsp:param name="selpage" value="GIFT LISTS"/>
                <fmt:message key="navigation_personalNavigation.giftList.findGiftlist"/>
              </dsp:a>
            </li>
            <li>
              <dsp:a href="${giftlistHomeUrl}">
                <dsp:property bean="SessionBean.values.loginSuccessURL" value="giftListHome.jsp"/>
                <dsp:property bean="SessionBean.values.selpage" value="GIFT LISTS"/>
                <fmt:message key="navigation_personalNavigation.giftList.createGiftlist"/>
              </dsp:a>
            </li>
            <li>
              <dsp:a href="${giftlistHomeUrl}">
                <dsp:property bean="SessionBean.values.loginSuccessURL" value="giftListHome.jsp"/>
                <dsp:property bean="SessionBean.values.selpage" value="GIFT LISTS"/>
                <fmt:message key="navigation_personalNavigation.giftList.editGiftlist"/>
              </dsp:a>
            </li>
          </ul>
        </div>
      </li>

      <%-- WISH LISTS LINK --%>
      
      <c:choose>
         <c:when test="${activeTab == 'WISHLIST'}">
           <li class="active">
         </c:when>
         <c:otherwise>
           <li>
         </c:otherwise>
       </c:choose>
        <fmt:message var="itemLabel" key="navigation_personalNavigation.wishList"/>
        <fmt:message var="itemTitle" key="navigation_personalNavigation.linkTitle">
          <fmt:param value="${itemLabel}"/>
        </fmt:message>

        <dsp:droplet name="Compare">
          <dsp:param name="obj1" bean="Profile.securityStatus"/>
          <dsp:param name="obj2" bean="PropertyManager.securityStatusCookie"/>
          <dsp:oparam name="greaterthan">
            <%-- Logged in User --%>
            <dsp:a id="myWishList" page="/myaccount/myWishList.jsp" title="${itemTitle}"
                   iclass="atg_store_navWishList">
              <dsp:param name="selpage" value="WISHLIST"/>
              ${itemLabel}
            </dsp:a>
          </dsp:oparam>
          <dsp:oparam name="default">
            <%-- Anonymous User --%>
            <%-- Recognized User --%>
            <dsp:a id="myWishList" page="/global/util/loginRedirect.jsp?error=wishlistNotLoggedIn"
                   title="${itemTitle}"
                   iclass="atg_store_navWishList">
              <dsp:property bean="SessionBean.values.selpage" value="WISHLIST"/>
              <dsp:property bean="SessionBean.values.loginSuccessURL" value="myWishList.jsp"/>
              ${itemLabel}
            </dsp:a>
          </dsp:oparam>
        </dsp:droplet>

      </li>


    </ul>
  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/personalNavigation.jsp#1 $$Change: 633540 $ --%>
