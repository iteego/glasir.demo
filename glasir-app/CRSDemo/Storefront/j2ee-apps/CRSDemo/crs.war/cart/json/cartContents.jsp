<%@ page contentType="application/json; charset=UTF-8" %>
<dsp:page>
<%--
     This page renders the contents of the cart as JSON data. 
     This is the top-level container page that just sets the appropriate mime type and includes
     the real data-generating page
--%>

  <dsp:include page="cartContentsData.jsp"/>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/json/cartContents.jsp#2 $$Change: 635969 $--%>
