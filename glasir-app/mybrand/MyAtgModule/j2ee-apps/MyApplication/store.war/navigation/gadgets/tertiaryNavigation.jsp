<%--
  This page appears in the bottom of every page
  and contains links to some top-level pages. 
--%>
<dsp:page>

  <c:set var="count" value="0"/>
  
  <div id="atg_store_tertiaryNavigation">

    <div class="info">

     <ul>
        <%-- 'About Us' link --%>
        <li>
          <fmt:message var="linkText" key="navigation_tertiaryNavigation.aboutUs"/>
          <dsp:a page="/company/aboutUs.jsp" title="${linkText}">
            <dsp:param name="selpage" value="aboutUs"/>
            ${linkText}
          </dsp:a>
        </li>


        <%-- 'Stores' link --%>
        <li>
          <fmt:message var="linkText" key="navigation_tertiaryNavigation.storeLocator"/>
          <dsp:a page="/company/stores.jsp" title="${linkText}">
            <dsp:param name="selpage" value="stores"/>
              ${linkText}
          </dsp:a>
        </li>
        
        <%-- 'Corporate Site' link --%>
        <li>
          <fmt:message var="linkText" key="navigation_tertiaryNavigation.corporateSite"/>
          <dsp:a page="/company/corpSite.jsp" title="${linkText}">
            <dsp:param name="selpage" value="corpSite"/>
            ${linkText}
          </dsp:a>
        </li>
        <%-- 'Careers' link --%>
         <li>
           <fmt:message var="linkText" key="navigation_tertiaryNavigation.careers"/>
           <dsp:a page="/company/employment.jsp" title="${linkText}">
             <dsp:param name="selpage" value="employment"/>
               ${linkText}
           </dsp:a>
         </li>
        <%-- 'News' link --%>
        <li>
          <fmt:message var="linkText" key="navigation_tertiaryNavigation.news"/>
          <dsp:a page="/company/news.jsp" title="${linkText}">
            <dsp:param name="selpage" value="news"/>
            ${linkText}
          </dsp:a>
        </li>
        <%-- 'As Seen In' link --%>
        <li>
          <fmt:message var="linkText" key="common.foot.seen"/>
          <dsp:a page="/browse/asSeenIn.jsp" title="${linkText}">
            <dsp:param name="selpage" value="asSeenIn"/>
              ${linkText}
            </dsp:a>
        </li>
 
        <%-- 'FAQ' link --%>
         <li>
           <fmt:message var="linkText" key="navigation_tertiaryNavigation.faq"/>
           <dsp:a page="/company/faq.jsp" title="${linkText}">
             <dsp:param name="selpage" value="faq"/>
             ${linkText}
           </dsp:a>
         </li>
        <%-- 'Privacy' link --%>
        <li>
          <fmt:message var="linkText" key="navigation_tertiaryNavigation.privacy"/>
          <dsp:a page="/company/privacy.jsp" title="${linkText}">
            <dsp:param name="selpage" value="privacy"/>
            ${linkText}
          </dsp:a>
        </li>      
      
        <%-- 'Terms' link --%>
        <li>
          <fmt:message var="linkText" key="navigation_tertiaryNavigation.terms"/>
          <dsp:a page="/company/terms.jsp" title="${linkText}">
            <dsp:param name="selpage" value="terms"/>
            ${linkText}
          </dsp:a>
        </li>
        
   
        
        
 

        <%-- 'Shipping' link --%>
        <li>
          <fmt:message var="linkText" key="common.foot.shipping"/>
          <dsp:a page="/company/shipping.jsp" title="${linkText}">
            <dsp:param name="selpage" value="shipping"/>
            ${linkText}
          </dsp:a>
        </li>      

        <%-- 'Returns' link --%>
        <li>
          <fmt:message var="linkText" key="common.foot.return"/>
          <dsp:a page="/company/returns.jsp" title="${linkText}">
            <dsp:param name="selpage" value="returns"/>
            ${linkText}
          </dsp:a>
        </li>      

        <%-- 'Contact Us' link --%>
        <li>
          <fmt:message var="linkText" key="navigation_tertiaryNavigation.contactUs"/>
          <dsp:a page="/company/customerService.jsp" title="${linkText}">
            <dsp:param name="selpage" value="customerService"/>
            ${linkText}
          </dsp:a>
        </li>

      </ul>
    </div>



  </div>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/tertiaryNavigation.jsp#1 $$Change: 633540 $ --%>
