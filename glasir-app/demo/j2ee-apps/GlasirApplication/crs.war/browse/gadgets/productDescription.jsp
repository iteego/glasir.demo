<dsp:page>

<%-- This page generates one row in a product comparison table, with
     each cell containing a product property value.

     This page expects the following parameters
     - heading - a string to display in the first column
     - displayProperty - the name of the product property to display
--%>

  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductList"/>

  <dsp:getvalueof var="displayprop" vartype="java.lang.String" param="displayProperty">
  <dsp:getvalueof var="items" vartype="java.lang.Object" bean="ProductList.items"/>
  <c:if test="${not empty items}">
     <tr valign="top">
      <c:forEach var="item" items="${items}">
        <dsp:param name="item" value="${item}"/>
        <td>
          <dsp:valueof param="heading" valueishtml="true"></dsp:valueof>
          <dsp:valueof param="item.product.${displayprop}"/>
        </td>
      </c:forEach>
    </tr>
  </c:if>
  </dsp:getvalueof>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productDescription.jsp#2 $$Change: 635969 $--%>
