<%--
  This page renders available languages. 
--%>
<dsp:page>

  <dsp:importbean bean="/atg/dynamo/droplet/ComponentExists" />
  <dsp:importbean bean="/atg/store/droplet/DisplayLanguagesDroplet" />
  <dsp:importbean bean="/atg/store/profile/SessionBean" />
  <dsp:importbean bean="/atg/multisite/Site"/>
    
  <div id="atg_store_languages">
    <dsp:droplet name="ComponentExists">
      <dsp:param name="path" value="/atg/modules/InternationalStore" />
      <dsp:oparam name="true">
        <dsp:droplet name="DisplayLanguagesDroplet">
          <dsp:param name="languages" bean="Site.languages" />
          <dsp:param name="countryCode" bean="Site.defaultCountry" />
          <dsp:oparam name="output">
            <dsp:getvalueof id="currentSelection" param="currentSelection"/>
            <dsp:getvalueof var="displayLanguages" param="displayLanguages"/>

            <c:if test="${not empty displayLanguages}">
              <h2>
                <fmt:message key="navigation_languages.languagesTitle"/>
                <fmt:message key="common.labelSeparator"/>
              </h2>
              <ul>
                <dsp:getvalueof id="size" value="${fn:length(displayLanguages)}"/>

                <c:forEach var="language" items="${displayLanguages}" varStatus="languageStatus">
                  <c:set var="isSelected" value="${languageStatus.index == currentSelection}"/>
                  
                  <li class="<crs:listClass count="${languageStatus.count}" size="${size}" selected="${isSelected}"/>">
                    <c:choose>
                      <c:when test="${isSelected == 'true'}">
                        <dsp:valueof value="${language.displayLanguage}"/>
                      </c:when>
                      <c:otherwise>
                        <dsp:a href="${language.linkURL}" title="${language.displayLanguage}">${language.displayLanguage}</dsp:a>
                      </c:otherwise>
                    </c:choose>
                  </li>
                </c:forEach>
              </ul>
            </c:if>
          </dsp:oparam>
        </dsp:droplet>
      </dsp:oparam>
    </dsp:droplet>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/languages.jsp#2 $$Change: 635969 $--%>
