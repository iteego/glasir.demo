<dsp:page>

<%-- 

  Some may wonder why this page does not use an include fragment to include the display of 
  promotional content.  Ideally we would like to include the images on the homepage as 
  individual fragments to keep maintenance down.  Unfortunately the home page display 
  consists of individual image fragments that must butt together.  
  
  When the build task is performed this task strips 
  whitespace from the page.  This works great and shows up fine in browsers like Mozilla.  
  Unfortunately IE does some odd formatting based on newlines and return characters that is 
  quite visible with this page when using includes.  So to solve that problem this page is a 
  stand-alone page that does not include each image as a fragment specifically for the homepage 
  to allow for the correct formatting on IE.
  
  In addition we use JSP comment tags to butt the tags together after pagecompile

--%>
  <dsp:importbean bean="/atg/dynamo/droplet/Cache"/>
  <dsp:importbean bean="/atg/registry/Slots/HomeTheme"/>
  <dsp:importbean bean="/atg/targeting/TargetingRandom"/>
  <dsp:importbean bean="/atg/targeting/TargetingForEach"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean var="requestLocale" bean="/atg/dynamo/servlet/RequestLocale" />

  <div id="atg_store_homePageHero">
    <%-- Home Theme slot --%>
    <dsp:droplet name="TargetingRandom">
      <dsp:param name="targeter" bean="HomeTheme"/>
      <dsp:oparam name="output">
        <dsp:setvalue param="promotionalContent" paramvalue="element"/>
        <dsp:getvalueof var="promoId" param="promotionalContent.repositoryId"/>
        <dsp:getvalueof var="currentSiteId" bean="Site.id"/>
        <dsp:droplet name="Cache">
          <dsp:param name="key" value="bp_prhm_${promoId}_${currentSiteId}_${requestLocale.locale.language}"/>
          <dsp:oparam name="output">

            <%-- Check to see if we have a template --%>
            <dsp:getvalueof id="pageurl" idtype="java.lang.String" param="promotionalContent.template.url"/>
            <c:if test="${not empty pageurl}">
              <dsp:include page="${pageurl}">
                <dsp:param name="promotionalContent" param="promotionalContent"/>
                <dsp:param name="omitTooltip" value="true"/>
              </dsp:include>
            </c:if>
          </dsp:oparam>
        </dsp:droplet><%-- End Cache Droplet --%>
      </dsp:oparam>
    </dsp:droplet><%-- End Home Theme Slot --%>
    <%-- Home personalized promotional items --%>
    <dsp:include page="/navigation/gadgets/homePromotionalItems.jsp" flush="true" />
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/homePromotions.jsp#3 $$Change: 635969 $--%>
