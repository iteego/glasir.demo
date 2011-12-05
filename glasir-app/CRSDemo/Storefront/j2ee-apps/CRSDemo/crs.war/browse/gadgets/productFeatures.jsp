
<dsp:page>

<%-- This page generates one row in a product comparison table, with
     each cell containing a list of property values, each value from one
     child item (sku or feature).

     This page expects the following parameters
     - heading - a string to display in the first column
     - childProperty - the name of the product property listing children
     - displayProperty - the name of the child's property to display
--%>

  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>
  <dsp:importbean bean="/atg/store/droplet/ComparisonRowExistsDroplet"/>  
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>

  <dsp:getvalueof var="displayprop" vartype="java.lang.String" param="displayProperty"/>
  <dsp:getvalueof var="childprop" vartype="java.lang.String" param="childProperty"/>

  <dsp:getvalueof var="productListItems" vartype="java.lang.Object" bean="ProductList.items"/>
  <c:if test="${not empty productListItems}">
    <dsp:droplet name="ComparisonRowExistsDroplet">
      <dsp:param name="items" value="${productListItems}"/>
      <dsp:param name="propertyName" param="childProperty"/>
      <dsp:param name="sourceType" value="product"/>
      <dsp:oparam name="output">
        <tr>
          <c:forEach var="productListItem" items="${productListItems}">
            <dsp:param name="entry" value="${productListItem}"/>
            <dsp:getvalueof var="productChildProperties" param="entry.product.${childprop}"/>
            <td class="atg_store_compareFeatures"><strong><dsp:valueof param="heading" valueishtml="true"></dsp:valueof></strong><p>
              <c:if test="${not empty productChildProperties}">
                <%-- Child items exist. If the first child has an empty value, assume all the children have empty values and leave the product's cell empty. --%>
                <dsp:getvalueof var="productDisplayProperties" param="entry.product.${childprop}[0].${displayprop}"/>
                
                <c:if test="${!empty productDisplayProperties}">
                  <dsp:getvalueof var="size" value="${fn:length(productChildProperties)}"/>
                  <c:forEach var="productChildProperty" items="${productChildProperties}" varStatus="productChildPropertyStatus">
                    <dsp:param name="child" value="${productChildProperty}"/>
                    <dsp:getvalueof var="count" value="${productChildPropertyStatus.count}"/>
                    <dsp:droplet name="Compare">
                      <dsp:param name="obj1" value="${count}" converter="number"/>
                      <dsp:param name="obj2" value="${size}" converter="number"/>
                      <dsp:oparam name="lessthan">
                        <dsp:valueof param="child.${displayprop}"></dsp:valueof>,
                      </dsp:oparam>
                      <dsp:oparam name="default">
                        <dsp:valueof param="child.${displayprop}"></dsp:valueof>
                      </dsp:oparam>
                    </dsp:droplet>
                  </c:forEach><%-- End ForEach child item --%>
                </c:if>
              </c:if>
            </p></td>
          </c:forEach><%-- End ForEach product in the comparison list --%>
        </tr>
      </dsp:oparam>
      <dsp:oparam name="empty">
      </dsp:oparam>
    </dsp:droplet>
  
  </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productFeatures.jsp#2 $$Change: 635969 $--%>
