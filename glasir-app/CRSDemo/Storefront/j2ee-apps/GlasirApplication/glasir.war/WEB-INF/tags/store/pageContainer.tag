<%--
  Tag that acts as a container for all top level pages, including all relevant
  header, footer and nav elements.
  The body of this tag should include any required gadgets.

  If any of the divId, titleKey or textKey attributes are set, then the
  pageIntro gadget will be included.  If none of these attributes are
  specified, then the pageIntro gadget will not be included.

  This tag accepts the following attributes
  divId (optional) - id for the containing div. Will be passed to the pageIntro
                     gadget.
  copyrightDivId (optional) - id for the containing div. Will be passed to the 
                              copyright gadget. If value is not specified then 
                              default value will be used.
  bodyClass (optional) - class name that will be used in the page's <body> tag.
  contentClass (optional) - class name that will be used for the page's 'content' <div> tag.
  titleKey (optional)- resource bundle key for the title. Will be passed to the
                       pageIntro gadget.
  textKey (optional) - resource bundle key for the intro text. Will be passed
                       to the pageIntro gadget.
  titleString (optional) - Title String  that will be passed to the pageIntro gadget
  textString (optional) - Intro text string that will be passed to the pageIntro gadget
  index (optional) - indexing instruction passed to robot <meta> tag, takes "true|false" 
                     value and specifies whether a page should be indexed by search robots,
                     "true" is default
  follow (optional) - indexing instruction passed to robot <meta> tag, takes "true|false" 
                      value and specifies whether a page should be followed by search robots,
                      "true" is default   

  The tag accepts the following fragments
  navigationAddition - define a fragment that will be included at the end
                       of the left nav gadgets.  If required, use as
                         <jsp:attribute name="leftNavigationAddition">
                           ....
                         </jsp:attribute>
  subNavigation - define a fragment that will be contain sub navigation gadgets.
                  If required, use as
                    <jsp:attribute name="subNavigation">
                      ....
                    </jsp:attribute>
  SEOTagRenderer - define a fragment that will render SEO meta tags.
                  If required, use as
                    <jsp:attribute name="SEOTagRenderer">
                      ....
                    </jsp:attribute>      
                    
  levelNeeded
    string representation of level required for displaying the current page. All levels defined in the
    /atg/store/states/CheckoutProgressStates.checkoutProgressLevels property
    
  redirectURL
    if current page is not allowed, request will be redirected to this URL            
--%>
<%@ include file="/includes/taglibs.jspf" %>
<%@ include file="/includes/context.jspf" %>
<%@ tag language="java" %>
<%@ attribute name="divId" %>
<%@ attribute name="copyrightDivId" %>
<%@ attribute name="bodyClass" %>
<%@ attribute name="contentClass" %>
<%@ attribute name="titleKey" %>
<%@ attribute name="textKey" %>
<%@ attribute name="titleString" %>
<%@ attribute name="textString" %>
<%@ attribute name="index" %>
<%@ attribute name="follow" %>
<%@ attribute name="navigationAddition" fragment="true" %>
<%@ attribute name="subNavigation" fragment="true" %>
<%@ attribute name="SEOTagRenderer" fragment="true"%>
<%@ attribute name="levelNeeded" %>
<%@ attribute name="redirectURL" %>

<%-- Check if displaying of current page is allowed. 
       Do it first thing, cause this page may be got redirected. 
       Catch exceptions, cause redirect throws SkipPageException. --%>
<c:catch var="skipPageException">
  <c:if test="${(not empty levelNeeded) and (not empty redirectURL)}">
    <dsp:getvalueof bean="/atg/store/states/CheckoutProgressStates.currentLevelAsInt" id="currentLevel" idtype="java.lang.Integer"/>
    <dsp:getvalueof bean="/atg/store/states/CheckoutProgressStates.checkoutProgressLevels.${levelNeeded}" id="needed" idtype="java.lang.Integer"/>
    <c:if test="${currentLevel < needed}">
      <c:redirect url="${redirectURL}"/>
    </c:if>
  </c:if>
</c:catch>

<%--
  Specify a default value, if copyrightDivId attribute not set from the page 
  containing this tag.
--%>
<c:if test="${empty copyrightDivId}">
  <c:set var="copyrightDivId" value="atg_store_copyright" />
</c:if>

<jsp:invoke fragment="SEOTagRenderer" var="SEOTagRendererContent"/>

<dsp:include page="/includes/pageStart.jsp">
  <dsp:param name="bodyClass" value="${bodyClass}"/>
  <dsp:param name="index" value="${index}"/>
  <dsp:param name="follow" value="${follow}"/>
  <dsp:param name="SEOTagRendererContent" value="${SEOTagRendererContent}" />
</dsp:include>



      <div id="atg_store_container">
        <ol id="atg_store_accessibility_nav">
          <li><a href="#atg_store_catNav">Skip to navigation</a></li>
          <li><a href="#atg_store_content">Skip to content</a></li>
        </ol>
        
        <hr/>
        <%--
          This section contains Location/Language picker
        --%>
        <div id="atg_store_locale">
          <dsp:include page="/navigation/gadgets/languages.jsp" flush="true"/>
          <dsp:include page="/navigation/gadgets/regions.jsp" flush="true"/>
          <dsp:include page="/navigation/gadgets/sites.jsp" flush="true"/>
        </div>
        <div id="atg_store_main">
          
          <%-- start header gadgets --%>
          
          <div id="atg_store_header">
          
            <div id="atg_store_mainHeader">
            <dsp:include page="/navigation/gadgets/logo.jsp" flush="true"/>
            
            <dsp:include page="/navigation/gadgets/search.jsp" flush="true"/>
            
            <dsp:include page="/navigation/gadgets/welcome.jsp" flush="true"/>
            <div id="atg_store_personalNavArea">
             
            
              <dsp:getvalueof id="repriceOrder" param="repriceOrder"/>
            
              <c:if test="${repriceOrder}">
                <dsp:include page="/global/gadgets/orderReprice.jsp"/>
              </c:if>
            
              <div id="atg_store_navCart">
                 <dsp:include page="/navigation/gadgets/navCart.jsp" flush="true"/>
              </div>
               <dsp:include page="/navigation/gadgets/personalNavigation.jsp" flush="true"/>
            </div>  
          </div>
          
          <div id="atg_store_catNavArea">            
            <ol id="atg_store_catNav">
              <dsp:include page="/navigation/gadgets/catalog.jsp" />
            </ol>
          </div>
 
          <%-- end header --%>

          <%-- Left nav gadgets --%>
          <hr/>
          </div>
          <div id="atg_store_contentContainer">
          <div id="atg_store_content" class="${contentClass}">

          <c:if test="${!empty divId and (!empty titleKey or !empty textKey or !empty titleString or !empty textString)}">
            <dsp:include page="/global/gadgets/pageIntro.jsp" flush="true">
              <dsp:param name="divId" value="${divId}"/>
              <dsp:param name="titleKey" value="${titleKey}"/>
              <dsp:param name="textKey" value="${textKey}"/>
              <dsp:param name="titleString" value="${titleString}"/>
              <dsp:param name="textString" value="${textString}"/>
            </dsp:include>
          </c:if>
    
          <jsp:doBody/>
    
          <jsp:invoke fragment="navigationAddition"/>
          <jsp:invoke fragment="subNavigation"/>
    
          </div> 
          <%-- end content --%>

          <hr/>
        </div> <%--  end main --%>
             
        <%-- start footer gadgets --%>
        <div id="atg_store_footer">
          <dsp:include page="/navigation/gadgets/tertiaryNavigation.jsp" flush="true"/>
          <dsp:include page="/global/gadgets/copyright.jsp" flush="true">
            <dsp:param name="copyrightDivId" value="${copyrightDivId}"/>
          </dsp:include>
        </div>
        <%-- end footer --%>
    
      </div> <%-- container --%>
  </div>


<dsp:include page="/includes/pageEnd.jsp"/>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/main/storefront/j2ee/storefront.war/global/gadgets/pageIntro.jsp#1 $$Change: 524649 $ --%>