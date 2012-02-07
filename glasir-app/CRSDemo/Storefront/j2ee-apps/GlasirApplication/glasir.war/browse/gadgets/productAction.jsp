<dsp:page>

  <%-- This page expects the following input parameters
       product - the product object being displayed
       categoryId (optional) - the id of the category the product is viewed from
       action - the action to display (one of largerImage, moreDetails,
                compare, emailFriend)
  --%>
  <dsp:importbean bean="/atg/store/droplet/NullPropertiesCheck"/>
  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListHandler"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>

  <dsp:getvalueof id="product" param="product"/>
  <dsp:getvalueof id="categoryId" param="categoryId"/>
  <dsp:getvalueof id="action" param="action"/>
  <dsp:getvalueof id="productId" idtype="java.lang.String" param="product.repositoryId"/>

  <c:choose>

    <c:when test="${action == 'compare'}">
      
      <dsp:droplet name="/atg/repository/seo/CatalogItemLink">
        <dsp:param name="item" param="product"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="productUrl" vartype="java.lang.String" param="url"/>
        </dsp:oparam>
      </dsp:droplet>
      
      <c:url var="url" value="${productUrl}">
        <c:param name="productId"><dsp:valueof param="product.repositoryId"/></c:param>
        <c:param name="categoryId"><dsp:valueof param="categoryId"/></c:param>
        <c:param name="categoryNavIds"><dsp:valueof param="categoryNavIds"/></c:param>
        <c:param name="navAction"><dsp:valueof param="navAction"/></c:param>
        <c:param name="navCount"><dsp:valueof param="navCount"/></c:param>
      </c:url>
			
      <fmt:message var="addToComparisonsText" key="browse_productAction.addToComparisonsSubmit"/>
      <dsp:input type="hidden" bean="ProductListHandler.addProductSuccessURL" value="${url}"/>
      <dsp:input type="hidden" bean="ProductListHandler.addProductErrorURL" value="${url}"/>
      <dsp:input type="hidden" bean="ProductListHandler.productId" paramvalue="product.repositoryId"/>
      <dsp:input type="submit" iclass="atg_store_textButton" bean="ProductListHandler.addProduct" value="${addToComparisonsText}" submitvalue="true" />
					
    </c:when>
         
    <c:when test="${action == 'viewComparisons'}">
      <fmt:message var="linkTitle" key="browse_productAction.addToComparisonsSubmit"/>
      <dsp:a page="/browse/productComparisons.jsp" title="${linkTitle}">
        <dsp:param name="selpage" value="COMPARISONS"/>
        <fmt:message  key="browse_productAction.addToComparisonsSubmit"/>
      </dsp:a>
    </c:when>

    <c:when test="${action == 'emailFriend'}">
      
      <dsp:getvalueof id="storeEmailAFriendEnabled" idtype="java.lang.Boolean"
                      bean="/atg/multisite/SiteContext.site.emailAFriendEnabled"/>
      <dsp:getvalueof id="productEmailAFriendEnabled" idtype="java.lang.Boolean"
                      param="product.emailAFriendEnabled"/>
      <c:if test="${storeEmailAFriendEnabled && productEmailAFriendEnabled}">
        <fmt:message var="linkTitle" key="browse_productAction.emailFriendTitle"/>
        <dsp:a page="/browse/emailAFriend.jsp?productId=${productId}&categoryId=${categoryId}"
               title="${linkTitle}" target="popupLarge">
          <fmt:message key="browse_productAction.emailFriendLink"/>
        </dsp:a>
      </c:if>
     
    </c:when>

    <c:otherwise>
      <%-- An invalid action is a programming error, not a runtime data error --%>
      <br />INVALID ACTION FOR productAction.jsp: <c:out value="${action}"/><br />
    </c:otherwise>
  </c:choose> 

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/productAction.jsp#2 $$Change: 635969 $ --%>
