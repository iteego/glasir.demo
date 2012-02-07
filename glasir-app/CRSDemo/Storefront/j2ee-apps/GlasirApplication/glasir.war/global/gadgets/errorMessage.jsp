<dsp:page>

  <%--
      This page displays any form handler exceptions wrapped in a div.

      Parameters:
      -  formhandler - A formhandler object that may have exceptions
      -  divid (optional) - String to use for the enclosing div id
  --%>
 
  <dsp:getvalueof id="divid" param="divid"/>
  <c:if test="${empty divid}">
    <c:set var="divid" value="atg_store_errorMsg"/>
  </c:if>

  <dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>

  <%-- formhandler Errors --%>
  <dsp:droplet name="ErrorMessageForEach">
    <dsp:param param="formhandler.formExceptions" name="exceptions"/>

    <dsp:oparam name="outputStart">
      <div class="${divid}">
    </dsp:oparam>

    <dsp:oparam name="output">
      <p>
        <dsp:valueof param="message" valueishtml="true"/>
      </p>
    </dsp:oparam>

    <dsp:oparam name="outputEnd">
      </div>
    </dsp:oparam>

  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/errorMessage.jsp#2 $$Change: 635969 $--%>
