<dsp:page>

  <%-- This gadget renders the template URL of a promotionalContent item.

       Parameters:
        - promotionalContent - The promotionalContent repository item
  --%>
 
  <dsp:getvalueof var="pageurl" idtype="java.lang.String" param="promotionalContent.template.url"/>
  <dsp:include page="${pageurl}">
    <dsp:param name="promotionalContent" param="promotionalContent"/>
  </dsp:include>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/promo/gadgets/promotionalContentTemplateRenderer.jsp#2 $$Change: 635969 $--%>
