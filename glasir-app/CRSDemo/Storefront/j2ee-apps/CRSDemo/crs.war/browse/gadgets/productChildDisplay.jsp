<dsp:page>

<%-- 
     This page generates one row in a product comparison table, with
     each cell containing a list of property values, each value from one
     child item (sku or feature). The set of property values from all the
     children are filtered to eliminate duplicates and establish the order.

     This page expects the following parameters
     - heading - a string to display in the first column
     - childProperty - the name of the product property listing children
     - displayProperty - the name of the child's property to display
     - filter - an optional component to filter and/or sort values
--%>

  <dsp:importbean bean="/atg/store/droplet/PropertyValueCollection"/>
  <dsp:importbean bean="/atg/store/droplet/ComparisonRowExistsDroplet"/>
  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>

  
  <dsp:getvalueof var="properties" vartype="java.util.Map" param="properties"/>
  <dsp:getvalueof var="items" vartype="java.lang.Object" bean="ProductList.items"/>

  <c:if test="${not empty items}">
    <c:forEach var="property" items="${properties}">
      <tr>
        <dsp:droplet name="ComparisonRowExistsDroplet">
          <dsp:param name="items" value="${items}"/>
          <dsp:param name="propertyName" value="${property.key}"/>
          <dsp:param name="sourceType" value="sku"/>
          <dsp:oparam name="output">
            <c:forEach var="item" items="${items}">
              <dsp:param name="entry" value="${item}"/>
              <td>
                <strong><fmt:message key="${property.value}"/><fmt:message key="common.labelSeparator"/></strong>
                <p>
                  <dsp:getvalueof var="filterName" bean="/atg/commerce/catalog/CatalogTools.propertyToFilterMap.${property.key}"/>
                  <dsp:getvalueof var="filter" bean="${filterName}"/>
                  <dsp:param name="entry" value="${item}"/>
                  <dsp:droplet name="PropertyValueCollection">
                    <dsp:param name="items" param="entry.product.childSKUs"/>
                    <dsp:param name="propertyName" value="${property.key}"/>
                    <dsp:param name="filter" value="${filter}"/>
                    <dsp:oparam name="output">

                      <dsp:getvalueof var="values" vartype="java.lang.Object" param="values"/>
                      <c:if test="${not empty values}">
                          <c:forEach var="value" items="${values}" varStatus="valueStatus">
                            <c:out value="${value}"/>
                            <c:if test="${valueStatus.count < fn:length(values)}">/</c:if>
                          </c:forEach>
                      </c:if>

                    </dsp:oparam>
                  </dsp:droplet>
                </p>
              </td>
            </c:forEach>
          </dsp:oparam>
          <dsp:oparam name="empty">
          </dsp:oparam>
        </dsp:droplet>
      </tr>
    </c:forEach><%-- End ForEach product in the comparison list --%>
  </c:if>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productChildDisplay.jsp#2 $$Change: 635969 $--%>
