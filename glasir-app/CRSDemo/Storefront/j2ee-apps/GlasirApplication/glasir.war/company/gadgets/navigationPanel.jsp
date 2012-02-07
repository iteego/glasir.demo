<dsp:page>
  <%--
    This page renders navigation links to ancillary pages related to
    company policies, help and contact information. 
  --%>
  <dsp:getvalueof var="selectedPage" param="selpage"/>
  <ul>
    <%-- 'About Us' link --%>
    <li ${(selectedPage == 'aboutUs')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.aboutUs"/>
      <dsp:a page="/company/aboutUs.jsp" title="${linkText}">
        <dsp:param name="selpage" value="aboutUs"/>
        ${linkText}
      </dsp:a>
    </li>
     <%-- 'Stores' link --%>
    <li ${(selectedPage == 'stores')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.storeLocator"/>
      <dsp:a page="/company/stores.jsp" title="${linkText}">
        <dsp:param name="selpage" value="stores"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'Corporate Site' link --%>
    <li ${(selectedPage == 'corpSite')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.corporateSite"/>
      <dsp:a page="/company/corpSite.jsp" title="${linkText}">
        <dsp:param name="selpage" value="corpSite"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'Employment' link --%>
    <li ${(selectedPage == 'employment')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.careers"/>
      <dsp:a page="/company/employment.jsp" title="${linkText}">
        <dsp:param name="selpage" value="employment"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'News' link --%>
    <li ${(selectedPage == 'news')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.news"/>
      <dsp:a page="/company/news.jsp" title="${linkText}">
        <dsp:param name="selpage" value="news"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'As Seen In' link --%>
    <li ${(selectedPage == 'asSeenIn')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_quickLinks.asSeenIn"/>
      <dsp:a page="/browse/asSeenIn.jsp" title="${linkText}">
        <dsp:param name="selpage" value="asSeenIn"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'FAQ' link --%>
    <li ${(selectedPage == 'faq')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.faq"/>
      <dsp:a page="/company/faq.jsp" title="${linkText}">
        <dsp:param name="selpage" value="faq"/>
        ${linkText}
      </dsp:a>
    </li>    
    <%-- 'Privacy Policy' link --%>
    <li ${(selectedPage == 'privacy')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.privacy"/>
      <dsp:a page="/company/privacy.jsp" title="${linkText}">
        <dsp:param name="selpage" value="privacy"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'Terms & Conditions' link --%>
    <li ${(selectedPage == 'terms')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.terms"/>
      <dsp:a page="/company/terms.jsp" title="${linkText}">
        <dsp:param name="selpage" value="terms"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'Shipping Rates' link --%>
    <li ${(selectedPage == 'shipping')?'class="current"':''}>
      <fmt:message var="linkText" key="common.foot.shipping"/>
      <dsp:a page="/company/shipping.jsp" title="${linkText}">
        <dsp:param name="selpage" value="shipping"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'Return Policy' link --%>
    <li ${(selectedPage == 'returns')?'class="current"':''}>
      <fmt:message var="linkText" key="common.foot.return"/>
      <dsp:a page="/company/returns.jsp" title="${linkText}">
        <dsp:param name="selpage" value="returns"/>
        ${linkText}
      </dsp:a>
    </li>
    <%-- 'Contact Us' link --%>
    <li ${(selectedPage == 'customerService')?'class="current"':''}>
      <fmt:message var="linkText" key="navigation_tertiaryNavigation.contactUs"/>
      <dsp:a page="/company/customerService.jsp" title="${linkText}">
        <dsp:param name="selpage" value="customerService"/>
        ${linkText}
      </dsp:a>
    </li>
  </ul>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/gadgets/navigationPanel.jsp#2 $$Change: 635969 $--%>