<dsp:page>

  <%--
    This gadget invokes the TargetingRandom droplet, using the slot provided, and including the
    rendering page.

    Parameters:
     - targeter - The targeter (or slot) to be used by the targeting droplet
     - renderer - The JSP page used to render the output
     - elementName - The name of the parameter that the targeting content should be placed into
     - howMany (optional) - The number of elements to show (defaults to 1)
     - divId (optional) - The id of an enclosing div tag
  --%>

  <dsp:importbean bean="/atg/targeting/TargetingRandom"/>

  <dsp:getvalueof var="renderer" vartype="java.lang.String" param="renderer"/>
  <dsp:getvalueof var="howMany" vartype="java.lang.String" param="howMany"/>
  <dsp:getvalueof var="divId" vartype="java.lang.String" param="divId"/>

  <dsp:droplet name="TargetingRandom">
    <dsp:param name="howMany" value="${empty howMany ? 1 : howMany}"/>
    <dsp:param name="targeter" param="targeter"/>
    <dsp:param name="fireViewItemEvent" value="false"/>
    <dsp:param name="elementName" param="elementName"/>
    <dsp:oparam name="outputStart">
      <c:if test="${!empty divId}">
        <div id="${divId}">
      </c:if>
    </dsp:oparam>
    <dsp:oparam name="output">
      <dsp:include page="${renderer}"/>
    </dsp:oparam>
    <dsp:oparam name="outputEnd">
      <c:if test="${!empty divId}">
        </div>
      </c:if>
    </dsp:oparam>
  </dsp:droplet>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/targetingRandom.jsp#2 $$Change: 635969 $--%>
