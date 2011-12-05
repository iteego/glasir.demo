<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object being displayed
       tabname (optional) - the name of the tab to display
  --%>
  <dsp:importbean bean="/atg/store/droplet/NullPropertiesCheck"/>

  <dsp:getvalueof id="product" param="product"/>
  <dsp:getvalueof var="tabname" param="tabname"/>

  <c:choose>
    <c:when test="${not empty tabname}">
      <%-- Display the requested tab --%>
      <dsp:include page="moreDetailsDisplay.jsp">
        <dsp:param name="product" param="product"/>
        <dsp:param name="tabname" param="tabname"/>
      </dsp:include>
    </c:when>
    <c:otherwise>
      <%-- figure out which tab to display (or if any will be displayed) --%>
      <dsp:droplet name="NullPropertiesCheck">
        <dsp:param name="item" param="product"/>
        <dsp:param name="properties" value="longDescription|features|usageInstructions|productTips"/>

        <dsp:oparam name="all">
          <%-- no Tabs to display --%>
        </dsp:oparam>

        <dsp:oparam name="true">
          <%-- some Tabs have data - display the first one with data --%>
          <dsp:include page="moreDetailsDisplay.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="tabname" param="definedProperties[0]"/>
          </dsp:include>
        </dsp:oparam>

        <dsp:oparam name="false">
          <%-- all Tabs have data - display the first one --%>
          <dsp:include page="moreDetailsDisplay.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="tabname" value="description"/>
          </dsp:include>
        </dsp:oparam>

      </dsp:droplet><%-- End checking if any of the properties are null --%>
    </c:otherwise>
  </c:choose><%-- End Is Empty check on tabname --%>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/moreDetails.jsp#2 $$Change: 635969 $ --%>
