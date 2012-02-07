<dsp:page>

  <%--
      This page expects following parameters - 
      category - category repository item for which featured promotions are to be displayed
      trailSize - 
--%>

  <%-- Check for trailSize parameter. If trailSize=0, render promotions, otherwise not. --%>
  <dsp:getvalueof var="trailSize" param="trailSize" />
  <c:if test="${trailSize == 0}">

    <%-- Display the category feature promotion if it exists --%>
    <dsp:getvalueof var="templateUrl"  param="category.feature.template.url" />
    <c:if test="${not empty templateUrl}">

      <dsp:getvalueof var="pageurl" vartype="java.lang.String"
        param="category.feature.template.url">
        <dsp:include page="${pageurl}">
          <dsp:param name="promotionalContent" param="category.feature" />
        </dsp:include>
      </dsp:getvalueof>

    </c:if>
  </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/categoryFeature.jsp#2 $$Change: 635969 $--%>
