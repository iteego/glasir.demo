<dsp:page>

  <%--
      This page updates category last browsed property on profile. If no explicit category ID
      is passed to the gadget then it is updated with top-level category currently viewed. 
      The current top-level category is determined based on the navigation history component.
      
      Parameters: 
      lastBrowsedCategory (optional) - category ID to update profile's last browsed category with
--%>
  <dsp:importbean bean="/atg/commerce/catalog/CatalogNavHistory"/>
  <dsp:importbean bean="/atg/userprofiling/Profile" />
  
  <dsp:getvalueof var="lastBrowsedCategory" param="lastBrowsedCategory"/>
  <c:if test="${empty lastBrowsedCategory}">
    <%-- Get top level category from navigation history component--%>
    <dsp:getvalueof var="navHistory" bean="CatalogNavHistory.navHistory"/>
    <c:if test="${not empty navHistory && fn:length(navHistory) > 1}">
      <dsp:getvalueof var="lastBrowsedCategory" bean="CatalogNavHistory.navHistory[1].repositoryId"/>
    </c:if>     
  </c:if>
  
  <c:if test="${not empty lastBrowsedCategory}">
    <dsp:setvalue bean="Profile.categoryLastBrowsed" value="${lastBrowsedCategory}"/>
  </c:if>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/categoryLastBrowsed.jsp#2 $$Change: 635969 $--%>
