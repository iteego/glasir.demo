<dsp:page>

  <%-- Gadget for showing user related promotional content as well as global promotional content
       Includes pricePromos.jsp for rendering User specific promotional content
       Includes linkedImageText.jsp for rendering Global promotional content

  Parameter:
   - divId - The divId to be used
   - headerKey (optional) - The key to the resourced used for the header
  --%>

  <dsp:getvalueof var="divId" vartype="java.lang.String" param="divId"/>
  <dsp:getvalueof var="headerKey" vartype="java.lang.String" param="headerKey"/>
  
  <c:set var="counterloop" value="0" />
  <c:set var="numberOfColumns" value="2" />
  <div id="${divId}">

    <dsp:importbean bean="/atg/store/pricing/PromotionFilter"/>
    <dsp:importbean bean="/atg/registry/Slots/CurrentPromotions"/>
    <dsp:importbean bean="/atg/multisite/Site"/>
    <dsp:importbean bean="/atg/targeting/TargetingArray"/>
    <dsp:importbean bean="/atg/targeting/TargetingForEach"/>

    <%-- In order for the class names in the <li> tags to be proper, we first need to see
         how many promotions in the CurrentPromotions targeter --%>
    <dsp:getvalueof var="numTargetedPromos" vartype="java.lang.Integer" value="0"/>
    <dsp:droplet name="TargetingArray">
      <dsp:param name="targeter" bean="CurrentPromotions"/>

      <dsp:oparam name="output">
        <dsp:getvalueof var="numTargetedPromos" vartype="java.lang.Integer" param="size"/>
      </dsp:oparam>
    </dsp:droplet>

    <dsp:getvalueof var="allPromotions" vartype="java.lang.Object" bean="PromotionFilter.siteGroupPromotions"/>
    <c:choose>
      <c:when test="${empty allPromotions}">
        <dsp:getvalueof var="numUserPromos" vartype="java.lang.Integer" value="0"/>
        <dsp:getvalueof var="size" vartype="java.lang.Integer" value="${numTargetedPromos}"/>
      </c:when>
      <c:otherwise>
        <c:set var="numUserPromos" value="${fn:length(allPromotions)}"/>
        <dsp:getvalueof var="size" vartype="java.lang.Integer" value="${numUserPromos + numTargetedPromos}"/>
        <c:if test="${!empty headerKey}">
          <h3><fmt:message key="${headerKey}"/></h3>
        </c:if>
        <ul>
        <c:forEach var="allPromotion" items="${allPromotions}" varStatus="allPromotionStatus">
          <c:set var="counterloop" value="${counterloop+1}" />
          <dsp:getvalueof id="count" value="${allPromotionStatus.count}"/>
          <dsp:param name="allPromotion" value="${allPromotion}"/>
          
          <c:if test="${counterloop % numberOfColumns == 0}">
            <li class="atg_store_promo lastCol">
          </c:if>
          
          <c:if test="${counterloop % numberOfColumns != 0}">
            <li class="atg_store_promo">
          </c:if>

            <dsp:getvalueof var="media" param="allPromotion.media"/>
            <c:if test="${not empty media}">
              <dsp:getvalueof id="promotionDisplayName" idtype="java.lang.String" param="allPromotion.displayName" />
              <c:set var="promotionDisplayName"><c:out value="${promotionDisplayName}" escapeXml="true"/></c:set>
              <%-- Image URL --%>
              <dsp:getvalueof var="imageURL" vartype="String" param="allPromotion.media.large.url"/>
              
              <%-- Current site base URL --%>
              <dsp:getvalueof var="currentSiteId" bean="Site.id" />
              
               <%-- Current site Target Link URL --%>
              <dsp:getvalueof var="targetLinkURL" 
                              vartype="String" 
                              param="allPromotion.media.${currentSiteId}.url"/>
              
              <c:choose>
                <c:when test="${empty targetLinkURL}">
                  
                  <%-- default Target Link URL --%>
                  <dsp:getvalueof var="targetLinkURL" 
                                  vartype="String" 
                                  param="allPromotion.media.targetLink.url"/>
                </c:when>
              </c:choose>
                            
            </c:if>
              
            <c:choose>
              <c:when test="${not empty targetLinkURL}">
                <dsp:a href="${targetLinkURL}">
                  <c:if test="${not empty imageURL}">                
                    <img src="${imageURL}" alt="${promotionDisplayName}" />
                  </c:if>
          
                
                  <dsp:getvalueof id="description" param="allPromotion.description"/>
                  <c:if test="${not empty description}">
              
                    <span class="atg_store_promoCopy">
                     
                        <dsp:valueof value="${description}" valueishtml="true"/>
                   
                    </span>
                   
                  </c:if>
                  </dsp:a>
              </c:when>
              <c:otherwise>
                <c:if test="${not empty imageURL}">                
                  <img src="${imageURL}" alt="${promotionDisplayName}" />
                </c:if>
              
                <dsp:getvalueof id="description" param="allPromotion.description"/>
                <c:if test="${not empty description}">
                  <span class="atg_store_promoCopy">
                    <dsp:valueof value="${description}" valueishtml="true"/>
                  </span>
                </c:if>
              </c:otherwise>
            </c:choose>
          </li>
          <c:if test="${counterloop % numberOfColumns == 0 && count != size}">
        
            <c:set var="counterloop" value="0" />
          </c:if>
        </c:forEach>
      </c:otherwise>
    </c:choose>

    <dsp:droplet name="TargetingForEach">
      <dsp:param name="targeter" bean="CurrentPromotions"/>
      <%--dsp:param name="sortProperties" value="marketingPriority"/--%>

      <dsp:oparam name="outputStart">
        <c:if test="${numUserPromos == 0}">
          <c:if test="${!empty headerKey}">
            <h3><fmt:message key="${headerKey}"/></h3>
          </c:if>
          <ul>
        </c:if>
      </dsp:oparam>
      <dsp:oparam name="output">
        <c:set var="counterloop" value="${counterloop+1}" />
        <dsp:getvalueof var="targetedPromoCount" vartype="java.lang.Integer" param="count"/>
        <dsp:getvalueof var="count" vartype="java.lang.Integer" value="${numUserPromos + targetedPromoCount}"/>
        <c:if test="${counterloop % numberOfColumns == 0}">
          <li class="atg_store_promo lastRow lastCol">
        </c:if>
        
        <c:if test="${counterloop % numberOfColumns != 0}">
          <li class="atg_store_promo lastRow">
        </c:if>

            <dsp:include page="/promo/gadgets/linkedImageText.jsp">
              <dsp:param name="promotionalContent" param="element"/>
            </dsp:include>

        </li>
      
        <c:if test="${counterloop % numberOfColumns == 0 && count != size}">
        
          <c:set var="counterloop" value="0" />
        </c:if>
      </dsp:oparam>
    </dsp:droplet>

  </div>
 
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/promotions.jsp#2 $$Change: 633752 $--%>