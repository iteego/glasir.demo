<dsp:page>

  <%-- This gadget renders a featured category through a promotionalContent item

       Parameter:
        - promotionalContent - The promotionalContent repository item
   --%>

  <dsp:importbean var="originatingRequest" bean="/OriginatingRequest"/>

  <li>
    <dl>

      <dsp:getvalueof id="url" idtype="java.lang.String" param="promotionalContent.associatedCategory.template.url"/>
      <dsp:getvalueof id="categoryId" idtype="java.lang.String"
                      param="promotionalContent.associatedCategory.repositoryId"/>
      <dsp:getvalueof id="categoryName" idtype="java.lang.String" param="promotionalContent.associatedCategory.name"/>
      <c:set var="categoryName"><c:out value="${categoryName}" escapeXml="true"/></c:set>
      <dsp:getvalueof id="categoryLinkImage" idtype="java.lang.String" param="promotionalContent.image"/>

      <c:if test="${not empty categoryLinkImage}">

        <dsp:a href="${originatingRequest.contextPath}${url}?categoryId=${categoryId}">
          <dd class="atg_store_productImage">
            <dsp:img src="${categoryLinkImage}" alt="${categoryName}"/>
          </dd>
        </dsp:a>

      </c:if>
    </dl>
  </li>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/promo/gadgets/featuredCategoryRenderer.jsp#2 $$Change: 635969 $--%>
