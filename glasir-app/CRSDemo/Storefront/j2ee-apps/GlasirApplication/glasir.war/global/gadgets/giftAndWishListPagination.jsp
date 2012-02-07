<dsp:page>

  <%--  This page is a global page for displaying pagination related items and their links
            for GiftLists/WishList pages.
        Parameters:
        -  arraySplitSize - Number of items to show on each page.
        -  start - Index (1 based) of first element to show on this page.
        -  viewAll (optional) - Set to true if viewAll has been requested.
        -  size - Size of the product Listing to be displayed
        -  itemList - the list of items to page
        -  top - true if this is the top set of links, false if it is the bottom set
        -  giftlistId - the id of the gift/wish list being displayed
        -  productId(optional) - id of product added to giftlist. 
  --%>
  
  <dsp:getvalueof id="size" idtype="java.lang.Integer" param="size"/>
  <dsp:getvalueof id="arraySplitSize" idtype="java.lang.Integer" param="arraySplitSize"/>
  <%-- This line is added as weblogic 10.0 converting Integer parameter as Long --%>
  <c:set var="arraySplitSize" value="${arraySplitSize}"/>
  <dsp:getvalueof id="start" idtype="java.lang.String" param="start"/>
  <dsp:getvalueof id="viewAll" param="viewAll"/>
  <dsp:getvalueof id="top" param="top"/>
  <dsp:getvalueof id="itemList" param="itemList"/>
  <dsp:getvalueof id="giftlistId" param="giftlistId"/>
  <dsp:getvalueof id="productId" idtype="java.lang.String" param="productId"/>

<c:if test="${size > arraySplitSize}">
  <crs:pagination size="${size}" arraySplitSize="${arraySplitSize}" start="${start}"
                  viewAll="${viewAll}" top="${top}" itemList="${itemList}">
    <jsp:attribute name="pageLinkRenderer">
      <dsp:a href="${pageContext.request.requestURI}" title="${linkTitle}">
         <dsp:param name="giftlistId" param="giftlistId"/> 
         <c:if test="${!empty productId}">
           <dsp:param name="productId" value="${productId}"/>  
         </c:if>
        <dsp:param name="start" value="${startValue}"/>
        ${linkText}
      </dsp:a>
    </jsp:attribute>
    <jsp:attribute name="viewAllLinkRenderer">
      <dsp:a href="${pageContext.request.requestURI}" title="${linkTitle}"
             iclass="${viewAllLinkClass}">
        <dsp:param name="viewAll" value="true"/>
        <dsp:param name="giftlistId" param="giftlistId"/> 
        <c:if test="${!empty productId}">
          <dsp:param name="productId" value="${productId}"/>  
        </c:if>
        <dsp:param name="howMany" param="size"/>
        ${linkText}
      </dsp:a>
    </jsp:attribute>
  </crs:pagination>
</c:if>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/giftAndWishListPagination.jsp#2 $$Change: 635969 $ --%>
