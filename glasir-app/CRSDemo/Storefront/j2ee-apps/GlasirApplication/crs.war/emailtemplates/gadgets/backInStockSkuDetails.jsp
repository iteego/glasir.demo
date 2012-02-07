<dsp:page>

  <%-- Note: This page recieves these parameters
       1. httpserver - the address of the httpserver so we can build images
       2. product - the product whose skus are shown
    --%>
    
  <%-- Begin Sku List --%>
  <table border="0" cellpadding="0" cellspacing="0" style="color:#666;font-family:Verdana,arial,sans-serif;font-size:14px">

         <dsp:getvalueof var="skus" vartype="java.lang.Object" param="product.childSKUs"/>
         <dsp:getvalueof var="requestedSkuId" param="skuId"/>
         <c:forEach var="sku" items="${skus}">
         
          <c:if test="${sku.repositoryId == requestedSkuId}">
           <dsp:param name="sku" value="${sku}"/>            
           <dsp:getvalueof var="productName" vartype="java.lang.String" param="product.displayName"/>
           <%-- Begin Sku --%>
           <tr> 
             <td width="10">
               <img src="<dsp:valueof param="httpserver"/>/images/spacer.gif" width="1" >
             </td>
             <dsp:getvalueof var="skuType" vartype="java.lang.String" param="sku.type"/>
             <%-- Check to see if the sku has any images --%>
             <dsp:getvalueof var="skuThumbnailImageUrl" param="sku.thumbnailImage.url"/>
             <dsp:getvalueof var="productUrl" param="productUrl"/>
             <c:choose>
              <c:when test="${skuType == 'clothing-sku'}">
                 <dsp:getvalueof var="color" param="sku.color"/>
                 <dsp:getvalueof var="size" param="sku.size"/>
                 <dsp:getvalueof var="skuUrl" vartype="java.lang.String" 
                    value="${productUrl }&selectedColor=${color}&selectedSize=${size}"/>
              </c:when>
              <c:otherwise>
                <c:set var="skuUrl" value="${productUrl}"/>
              </c:otherwise>
             </c:choose>
           
               <c:if test="${not empty skuThumbnailImageUrl}">
                 <td width="60">
                   <a href="${skuUrl }">
                   <img src="<dsp:valueof param="httpserver"/><dsp:valueof param='sku.thumbnailImage.url'/>" width="60" alt="${productName}">
                   </a>
                 </td>         
               </c:if>
               
             <td width="10"><img src="<dsp:valueof param="httpserver"/>/images/spacer.gif" width="1" height="1"></td>
             <td width="230" style="color:#666;font-family:Verdana,arial,sans-serif;font-size:14px">
               <fmt:message key='common.item'/><fmt:message key='common.numberSymbol'/><fmt:message key='common.labelSeparator'/>
               <dsp:valueof param="sku.repositoryId">
                 <fmt:message key="common.IdDefault"/>
               </dsp:valueof><br />
               <fmt:message key='common.price'/><fmt:message key='common.labelSeparator'/>
               <dsp:include page="/emailtemplates/gadgets/priceLookup.jsp">
                 <dsp:param name="product" param="product"/>
                 <dsp:param name="sku" param="product.childSKUs[0]"/>
               </dsp:include><br />

              <c:if test="${skuType == 'clothing-sku'}">
                 <dsp:getvalueof param="sku.size" var="skuSize"/>
                 <c:if test="${not empty skuSize}">
                   <fmt:message key='common.size'/><fmt:message key='common.labelSeparator'/>
                   <dsp:valueof param="sku.size"/><br />
                 </c:if>
                 
                 <dsp:getvalueof param="sku.color" var="skuColor"/>
                 <c:if test="${not empty skuColor}"> 
                   <fmt:message key='common.color'/><fmt:message key='common.labelSeparator'/>
                   <dsp:valueof param="sku.color"/><br />
                 </c:if>
              </c:if>
             </td> 
             
           </tr>
           <%-- End Sku --%>
           </c:if>
         </c:forEach><%-- End For Each SKU --%>
      
  </table>
 <%-- End Sku List --%>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/backInStockSkuDetails.jsp#1 $$Change: 633540 $--%>
