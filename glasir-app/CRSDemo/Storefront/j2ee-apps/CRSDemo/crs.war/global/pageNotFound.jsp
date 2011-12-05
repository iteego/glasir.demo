<dsp:page>
  <%--
    This page is called upon 404 HTTP error - page not found
  --%>
  
  <%--
    Display 404 content on non-publishing instances only!
    Publishing servers have wrong Profile defined,
      that's why there will be a lot of errors in the console when displaying 404 page on such servers. 
  --%>
  <dsp:droplet name="/atg/dynamo/droplet/ComponentExists">
    <%-- /atg/modules/StoreVersioned module is defined in EStore.Versioned, so non-publishing instances will not have this component --%>
    <dsp:param name="path" value="/atg/modules/StoreVersioned"/>
    <dsp:oparam name="false">
      <crs:pageContainer divId="atg_store_pageNotFoundIntro" bodyClass="atg_store_pageNotFound" titleKey="">
        <div class="atg_store_nonCatHero">
          <h2 class="title"><fmt:message key="global_pageNotFound.title"/></h2>
        </div>
        
        <crs:messageContainer id="atg_store_pageNotFound" messageKey="global_pageNotFound.pageNotFoundMsg"/>
      </crs:pageContainer>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/pageNotFound.jsp#1 $$Change: 633540 $--%>