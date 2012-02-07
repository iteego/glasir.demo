<dsp:page>

<dsp:importbean bean="/atg/commerce/promotion/ClosenessQualifierDroplet"/>

<dsp:droplet name="ClosenessQualifierDroplet">
  <dsp:param name="type" value="all"/>
  <dsp:oparam name="output">

    <dsp:getvalueof var="closenessQualifiers" vartype="java.lang.Object" param="closenessQualifiers"/>
    <c:if test="${not empty closenessQualifiers}">
      <span class="atg_store_closenessQualifier">
        <c:forEach var="closenessQualifier" items="${closenessQualifiers}">
          <dsp:param name="qualifier" value="${closenessQualifier}"/>
            <dsp:valueof param="qualifier.name" valueishtml="true"/>
        </c:forEach>
      </span>
    </c:if>
  </dsp:oparam>
</dsp:droplet>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/closenessQualifiers.jsp#2 $$Change: 635969 $--%>
