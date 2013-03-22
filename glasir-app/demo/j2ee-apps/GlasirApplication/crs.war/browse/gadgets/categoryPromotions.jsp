<dsp:page>
<%--
  This gadget displays hero image for the given category and promotional content for this category  
  
  Input parameters:
       
    category - category repository item for which featured promotions are to be displayed
--%>
    <%-- Display the category feature promotion if it exists --%>
    <dsp:getvalueof var="categoryFeature" param="category.feature" />
    <c:if test="${not empty categoryFeature}">
      <dsp:getvalueof var="templateUrl" param="category.feature.template.url" />
      <c:if test="${not empty templateUrl}">
        <dsp:getvalueof var="pageurl" vartype="java.lang.String"
          param="category.feature.template.url">
          <dsp:include page="${pageurl}">
            <dsp:param name="promotionalContent" param="category.feature" />
            <dsp:param name="imageHeight" value="134" />
            <dsp:param name="imageWidth" value="752" />
          </dsp:include>
        </dsp:getvalueof>
      </c:if>
      
    </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/categoryPromotions.jsp#2 $$Change: 635969 $--%>
