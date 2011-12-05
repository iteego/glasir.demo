<dsp:page>
<%--
  This gadget displays infomation about :
  
    sku name with link to product details page
    size
    color
    quantity
    price
    
  Parameter:
    commerceItem - commerce item (an implementation of atg.commerce.order.CommerceItem interface)
    quantity - quantity of item, integer, optional 
--%>


  
  <%-- link to product details page --%>

  <dsp:getvalueof var="pageurl" vartype="java.lang.String"
                        param="commerceItem.auxiliaryData.productRef.template.url"/>
  <dsp:getvalueof var="displayAslink" param="displayAslink"/> 
  <p class="name">
    <c:choose>
      <c:when test="${not empty pageurl and displayAslink}">
        <dsp:a page="${pageurl}">
          <dsp:valueof param="commerceItem.auxiliaryData.productRef.displayName">
            <fmt:message key="common.noDisplayName"/>
          </dsp:valueof>
          <dsp:param name="productId" param="commerceItem.auxiliaryData.productId"/>
        </dsp:a>
      </c:when>
      <c:otherwise>                      
        <dsp:valueof param="commerceItem.auxiliaryData.productRef.displayName">
          <fmt:message key="common.noDisplayName"/>
        </dsp:valueof>
      </c:otherwise>
    </c:choose>
  </p>
  
  <dsp:include page="/global/util/displaySkuProperties.jsp">
    <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
    <dsp:param name="sku" param="commerceItem.auxiliaryData.catalogRef"/>
    <dsp:param name="displayAvailabilityMessage" value="true"/>
  </dsp:include>
  
</ul>
 
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/shippingProductDetails.jsp#2 $$Change: 635969 $--%>