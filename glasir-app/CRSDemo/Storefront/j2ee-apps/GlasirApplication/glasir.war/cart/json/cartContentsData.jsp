<dsp:page>

  <%--
    This page renders the contents of the cart as JSON data. 
    It determines if the cart is empty, and renders the appropriate JSP.
  --%>
  <dsp:getvalueof bean="/atg/commerce/ShoppingCart.current.CommerceItemCount" var="itemCount"/>
  <c:choose>
    <c:when test="${itemCount==0}">
      <%-- Cart is empty --%>
      <dsp:include page="cartContentsEmpty.jsp" flush="true"/>
    </c:when>
    <c:otherwise>
      <%-- Cart is not empty - render contents of cart --%>
      <dsp:include page="cartItems.jsp"/>
    </c:otherwise>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/json/cartContentsData.jsp#2 $$Change: 635969 $--%>
