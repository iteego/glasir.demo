<dsp:page>

  <%--
      Container page for main category
      This page expects the following parameters :
      - categoryId (required)- repository id of the category being browsed.
      - category - Repository item of the Category being traversed
      - trailSize - Size of the facet trail traversed so far
      - facetTrail - Facet trail traversed so far
      - facetSearchResponse - Facet Search Response Object from ATG-Search Server
  --%>
  <crs:pageContainer bodyClass="category atg_store_leftCol" contentClass="page_apparel" >
    <jsp:attribute name="SEOTagRenderer">
      <dsp:include page="/global/gadgets/metaDetails.jsp" flush="true">
        <dsp:param name="catalogItem" param="category"/>
      </dsp:include>
    </jsp:attribute>
    <jsp:body>

      <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup" />

      <%-- unpack dsp:param --%>
      <dsp:getvalueof var="trailSizeVar" param="trailSize" />
      
      <dsp:include page="/browse/gadgets/itemHeader.jsp">
        <dsp:param name="displayName" param="category.displayName"/>
        <dsp:param name="category" param="category"/>
      </dsp:include>
      
      <div class="atg_store_main">

        <c:choose>
          <c:when test="${not empty param.q_facetTrail}">
            <%@ include file="/browse/gadgets/facetSearchProductsForCategory.jspf"%>
          </c:when>

          <c:otherwise>
            <dsp:include page="/browse/gadgets/featuredProducts.jsp" flush="true">
              <dsp:param name="category" param="category"/>
              <dsp:param name="trailSize" value="${trailSizeVar}"/>
            </dsp:include>
          </c:otherwise>
        </c:choose>

        <dsp:getvalueof var="hideResults" param="hideResults" />
        <dsp:getvalueof var="atgSearchInstalled" bean="/atg/store/StoreConfiguration.atgSearchInstalled"/>

     
      </div>
      <div class="aside">
        <dsp:include page="/browse/gadgets/categoryPanel.jsp" flush="true" />

        <c:if test="${atgSearchInstalled == 'true' }">
          <dsp:include page="/facet/gadgets/facetPanelContainer.jsp" flush="true">
              <dsp:param name="facetTrail" param="facetTrail" />
              <dsp:param name="trailSize" value="${trailSizeVar}" />
              <dsp:param name="facetSearchResponse" param="facetSearchResponse" />
              <dsp:param name="categoryId" param="categoryId" />
          </dsp:include>
        </c:if>

        <%-- Rendering category promotions--%>
       
        <!-- render this promotions only for first level categories -->
        <dsp:include page="/global/gadgets/targetingRandom.jsp" flush="true">
          <dsp:param name="targeter" bean="/atg/registry/Slots/CategoryPromotionContent1"/>
          <dsp:param name="renderer" value="/promo/gadgets/promotionalContentTemplateRenderer.jsp"/>
          <dsp:param name="elementName" value="promotionalContent"/>
        </dsp:include>
       
        <dsp:include page="/global/gadgets/targetingRandom.jsp" flush="true">
          <dsp:param name="targeter" bean="/atg/registry/Slots/CategoryPromotionContent2"/>
          <dsp:param name="renderer" value="/promo/gadgets/promotionalContentTemplateRenderer.jsp"/>
          <dsp:param name="elementName" value="promotionalContent"/>
        </dsp:include>

        <dsp:include page="/navigation/gadgets/clickToCallLink.jsp">
          <dsp:param name="pageName" value="category"/>
        </dsp:include>
      </div>
      <script type="text/javascript">
        dojo.require("dojo.back");
        dojo.back.init();
        dojo.back.setInitialState(new HistoryState(""));
      </script>

    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/categoryDisplay.jsp#2 $$Change: 635969 $--%>