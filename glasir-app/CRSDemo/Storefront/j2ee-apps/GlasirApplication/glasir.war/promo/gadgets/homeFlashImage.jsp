<dsp:page>

  <%-- This page allows a merchant to utilize arbitrary Flash files.
       It displays these properties of the promotionalContent repository item:
       
       promotionalContent.image - the url of the image to display
       promotionalContent.longDescription - The markup containing the embedded Flash. This
         markup must contain the <embed> and/or <object> tags that render the Flash content.

       This page expects the following parameters --
       1. contentStart - content to render before we render the promotional content
       2. promotionalContent - the promotionalContent repository item to display
       3. contentEnd - content to render before we render the promotional content
  --%>
  
  <div id="atg_store_homePageHero">

    <dsp:valueof param="contentStart" valueishtml="true"/>
    
    <dsp:getvalueof id="promoid" idtype="java.lang.String" param="promotionalContent.repositoryId" />
    <dsp:getvalueof id="imageurl" idtype="java.lang.String" param="promotionalContent.image" />
    <dsp:getvalueof id="longDescription" idtype="java.lang.String"    param="promotionalContent.longDescription"/>
    <c:choose>
      <c:when test="${not empty longDescription}">
        <dsp:valueof value="${longDescription}" valueishtml="true"></dsp:valueof>
      </c:when>
      <c:otherwise>
        <c:choose>
          <c:when test="${not imageurl}">
            <%-- Show the image --%>
            <dsp:img src="${imageurl}"/>
          </c:when>
          <c:otherwise>
            <fmt:message key="promo_homeFlashImage.flashAndOrImage"/>
          </c:otherwise>
        </c:choose><%-- End IsEmpty check on Flash --%>
      </c:otherwise>
    </c:choose>
    <dsp:valueof param="contentEnd" valueishtml="true"/>
    
  </div><%--  End Flash Content --%>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/promo/gadgets/homeFlashImage.jsp#2 $$Change: 635969 $--%>
