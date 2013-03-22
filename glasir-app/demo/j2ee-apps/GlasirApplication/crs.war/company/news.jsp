<%--
  This page is the company's "News" page.
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/droplet/StoreText"/>

  <crs:pageContainer divId="atg_store_company"
                     bodyClass="atg_store_news atg_store_leftCol atg_store_company">
    <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="company_news.title"/>
      </h2>
    </div>
    <div class="atg_store_main">
      <crs:getMessage var="storeName" key="common.storeName"/>

      <c:set var="tag" value="news"/>

      <dsp:droplet name="StoreText">
        <dsp:param name="tag" value="${tag}"/>
        <dsp:param name="storeName" value="${storeName}"/>

        <dsp:oparam name="output">
          <dsp:getvalueof var="messages" param="messages"/>

          <c:choose>
            <c:when test="${!empty messages}">
              <c:forEach items="${messages}"
                         var="message">
                <c:out value="${message}" escapeXml="false"/>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <crs:getMessage var="noNews" key="company.news.noNews"/>
              <p><c:out value="${noNews}" escapeXml="false"/></p>
            </c:otherwise>
          </c:choose>
        </dsp:oparam>
      </dsp:droplet>
    </div>

    <div class="atg_store_companyNavigation aside">
      <dsp:include page="/company/gadgets/navigationPanel.jsp"/>
    </div>  
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/news.jsp#2 $$Change: 635969 $--%>
