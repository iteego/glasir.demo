<dsp:page>

  <%--
    This gadget invokes the TargetingForEach droplet, using the slot provided, and including the
    rendering page.

    Parameters:
     - targeter - The targeter (or slot) to be used by the targeting droplet
     - renderer - The JSP page used to render the output
     - elementName - The name of the parameter that the targeting content should be placed into
     - sortProperties (optional) - The properties the droplet should sort by
     - divId (optional) - The id of an enclosing div tag
     - emptyRenderer (optional) - The JSP page used to render if the droplet renders the "empty" oparam
  --%>

  <dsp:importbean bean="/atg/targeting/TargetingForEach"/>

  <dsp:getvalueof var="renderer" vartype="java.lang.String" param="renderer"/>
  <dsp:getvalueof var="emptyRenderer" vartype="java.lang.String" param="emptyRenderer"/>
  <dsp:getvalueof var="divId" vartype="java.lang.String" param="divId"/>

  <dsp:droplet name="TargetingForEach">
    <dsp:param name="targeter" param="targeter"/>
    <dsp:param name="sortProperties" param="sortProperties"/>
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
    <dsp:oparam name="empty">
      <dsp:include page="${emptyRenderer}"/>
    </dsp:oparam>
  </dsp:droplet>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/targetingForEach.jsp#2 $$Change: 635969 $--%>
