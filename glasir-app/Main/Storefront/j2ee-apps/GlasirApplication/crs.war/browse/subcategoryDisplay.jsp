<dsp:page>

  <%--
      Container page for sub-category
      This page expects the following parameters :
      - category - Repository item of the Category being traversed
      - trailSize - Size of the facet trail traversed so far
      - facetTrail - Facet trail traversed so far
  --%>

  <%-- unpack dsp:param --%>
  <dsp:getvalueof var="trailSizeVar" param="trailSize" />
  
  <crs:pageContainer divId="page_apparel" contentClass="atg_store_subCategoryIntro"
                     bodyClass="category atg_store_leftCol">
    <jsp:attribute name="SEOTagRenderer">
      <dsp:include page="/global/gadgets/metaDetails.jsp" flush="true">
        <dsp:param name="catalogItem" param="category"/>     
      </dsp:include>
    </jsp:attribute>                        

    <jsp:body>

      <dsp:include page="/browse/gadgets/itemHeader.jsp">
        <dsp:param name="displayName" param="category.displayName"/>
        <dsp:param name="category" param="category"/>
        <dsp:param name="categoryNavIds" param="categoryNavIds"/> 
      </dsp:include>

      <div class="atg_store_main">
  
        <%-- Displays hero image --%>


        <dsp:include page="/browse/gadgets/featuredProducts.jsp" flush="true">
          <dsp:param name="category" param="category" />
          <dsp:param name="trailSize" value="${trailSizeVar}" />
        </dsp:include>  
        <div id="ajaxContainer">
        <div divId="ajaxRefreshableContent">

          <c:choose>
          <c:when test="${not empty param.q_facetTrail}">
            <%@ include file="/browse/gadgets/facetSearchProductsForCategory.jspf"%>
          </c:when>

          <c:otherwise>
            <dsp:include page="/browse/gadgets/subcategoryProductList.jsp"
                        flush="true">
            <dsp:param name="trailSize" value="${trailSizeVar}" />
            <dsp:param name="category" param="category" />
          </dsp:include>
          </c:otherwise>
        </c:choose>

          </div>
          <div name="transparentLayer" id="transparentLayer"></div>
          <div name="ajaxSpinner" id="ajaxSpinner"></div>
        </div>
      </div>
      <div class="aside">
          
        <%-- Left hand panel with links to subcategories --%>
        <dsp:include page="/browse/gadgets/categoryPanel.jsp" flush="true" />
                  
        <dsp:getvalueof var="atgSearchInstalled" bean="/atg/store/StoreConfiguration.atgSearchInstalled"/>
        <c:if test="${atgSearchInstalled == 'true'}">        
          <dsp:include page="/facet/gadgets/facetPanelContainer.jsp" flush="true">
            <dsp:param name="facetTrail" param="facetTrail" />
            <dsp:param name="trailSize" value="${trailSizeVar}" />
            <dsp:param name="categoryId" param="categoryId" />
          </dsp:include>
        </c:if>
      
        <%-- Rendering category promotions--%>
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
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/subcategoryDisplay.jsp#2 $$Change: 635969 $--%>



