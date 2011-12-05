<dsp:page>

  <%--
      This page enables entire pages to be pushed out through publishing.
      It works by querying the product catalog for promtionalContent items
      that contain a linkUrl matching the value of the "page" request parameter,
      then including the promotionalContent.template.url with the promotionalContent
      passed in under the "content" parameter.
  --%>

  <dsp:importbean bean="/atg/dynamo/droplet/RQLQueryRange"/>
  <dsp:droplet name="RQLQueryRange">
    <dsp:param name="repository" value="/atg/commerce/catalog/ProductCatalog"/>
    <dsp:param name="itemDescriptor" value="promotionalContent"/>
    <dsp:param name="queryRQL" value="linkUrl = :link"/>
    <dsp:param name="link" param="page"/>
    <dsp:param name="start" value="1"/>
    <dsp:param name="howMany" value="1"/>
    <dsp:oparam name="output">
      <dsp:getvalueof id="templateurl" idtype="java.lang.String" param="element.template.url">
        <dsp:include page="${templateurl}">
          <dsp:param name="content" param="element"/>
        </dsp:include>
      </dsp:getvalueof>
    </dsp:oparam>
    <dsp:oparam name="empty">
      <jsp:scriplet>
        response.sendError(404);
      </jsp:scriplet>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/content.jsp#2 $$Change: 635969 $--%>
