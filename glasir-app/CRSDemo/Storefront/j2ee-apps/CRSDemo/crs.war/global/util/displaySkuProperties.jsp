<%--
  Displays a list of SKU properties in form of <DL>/<DT>/<DD> definitions based on the SKU type.
  This page exptects the following parameters:
    1. sku - a SKU repository item, this item holds parameters to be displayed
    2. product - a PRODUCT repository item, this item contains the previous parameter's SKU
    3. displayAvailabilityMessage (optional) - defines whether to display inventory availability message, or not; default is true
--%>
<dsp:page>
  <table>
    <dsp:getvalueof var="skuType" vartype="java.lang.String" param="sku.type"/>
    <c:choose>
      <%-- 
        clothing-sku displays the following properties:
          1. size
          2. color
      --%>
      <c:when test="${skuType == 'clothing-sku'}">
        <dsp:getvalueof var="size" vartype="java.lang.String" param="sku.size"/>
        <dsp:getvalueof var="color" vartype="java.lang.String" param="sku.color"/>
        <c:if test="${not empty size}">
          <tr>
          <td class="itemPropertyLabel">
            <fmt:message key="common.size"/><fmt:message key="common.labelSeparator"/>
          </td>
          <td>
            <c:out value="${size}"/>
          </td>
          </tr>
        </c:if>
        <c:if test="${not empty color}">
        <tr>
          <td class="itemPropertyLabel">
            <fmt:message key="common.color"/><fmt:message key="common.labelSeparator"/>
          </td>
          <td>
            <c:out value="${color}"/>
          </td>
          </tr>
        </c:if>
      </c:when>
      <%-- 
        furntirue-sku displays the following properties:
          1. woodFinish
      --%>
      <c:when test="${skuType == 'furniture-sku'}">
        <dsp:getvalueof var="woodFinish" vartype="java.lang.String" param="sku.woodFinish"/>
        <c:if test="${not empty woodFinish}">
          <tr>
          <td class="itemPropertyLabel">
            <fmt:message key="common.woodFinish"/><fmt:message key="common.labelSeparator"/>
          </td>
          <td>
            <c:out value="${woodFinish}"/>
          </td>
          </tr>
        </c:if>
      </c:when>
    </c:choose>
    <%--
      each sku displays a [SKU ID] - [availability message] pair
    --%>
    <dsp:getvalueof var="displayAvailabilityMessage" vartype="java.lang.Boolean" param="displayAvailabilityMessage"/>
    <c:if test="${empty displayAvailabilityMessage}">
      <c:set var="displayAvailabilityMessage" value="true"/>
    </c:if>
    <tr>
    <td class="itemPropertyLabel">
      <dsp:valueof param="sku.repositoryId"/><c:if test="${displayAvailabilityMessage}"><fmt:message key="common.labelSeparator"/></c:if>
    </td>
    <td>
      <c:if test="${displayAvailabilityMessage}">
        <dsp:include page="/global/gadgets/skuAvailabilityLookup.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="skuId" param="sku.repositoryId"/>
        </dsp:include>
        <c:if test="${not empty availabilityMessage}">
          <c:out value="${availabilityMessage}"/>
        </c:if>
      </c:if>
    </td>
    </tr>
  </table>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/util/displaySkuProperties.jsp#3 $$Change: 635969 $--%>
