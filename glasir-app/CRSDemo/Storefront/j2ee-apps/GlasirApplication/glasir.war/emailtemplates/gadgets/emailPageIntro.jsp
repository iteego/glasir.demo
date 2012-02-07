<dsp:page>

  <%-- This page expects the following input parameters:
       1. divId - ID for the containing div
       2. titleKey (optional) - Resource bundle key for the title
       3. textKey (optional) - Resource bundle key for the introduction text
       4. titleString (optional) - Title text passed from the page being displayed
       5. textString (optional) - Introduction text passed from the page being displayed
   
       Text is rendered according to the following rules:
   
       Case 1 Both titleKey and titleString are supplied: 
           Renders the value from the resource bundle.  If the key is not valid or has no associated value,
           the value passed in titleString is rendered.
       Case 2 Only titleKey is supplied:
           Renders the value from the resource bundle. If the key is not valid or empty nothing is displayed.
       Case 3 Only titleString is supplied:
           Renders the value as passed. 

       The same rules apply to textKey and textString if they're supplied.
       If neither textKey or textString is supplied, no introductory text is rendered.
  --%>
  
  <dsp:getvalueof id="divId" param="divId"/>
  <dsp:getvalueof id="titleKey" param="titleKey"/>
  <dsp:getvalueof id="textKey" param="textKey"/>
  <dsp:getvalueof id="titleString" param="titleString"/>
  <dsp:getvalueof id="textString" param="textString"/>
  
  <div id="${divId}">
    <c:set var="titleKeyValue" value=""/>

    <c:if test="${!empty titleKey}">
      <c:set var="missingKeyResult" value="???${titleKey}???"/>
      <fmt:message var="keyValue" key="${titleKey}">
        <fmt:param>
          <dsp:valueof bean="/atg/multisite/Site.name"/>
        </fmt:param>
      </fmt:message>
      <c:if test="${keyValue != missingKeyResult}">
        <c:set var="titleKeyValue" value="${keyValue}"/>
      </c:if>
    </c:if>

    <c:if test="${empty titleKeyValue}">
      <c:set var="titleKeyValue" value="${titleString}"/>
    </c:if>

    <%-- Begin Page Title --%>
    <c:if test="${!empty titleKeyValue}">
      <div style="font-family:Tahoma,Arial,sans-serif;font-size:20px;color:#0a3d56;padding-bottom:30px;">
        ${titleKeyValue}
      </div> 
    </c:if>
    <%-- End Page Title --%>

    <crs:messageWithDefault key="${textKey}" string="${textString}"/>
    <c:if test="${!empty messageText}">
      <%-- Begin Page Message --%>
      <div style="color:#666;font-family:Verdana,Arial,sans-serif;font-size:14px">
          ${messageText}
      </div>
      <%-- End Page Message --%>
    </c:if>
  </div>
    
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailPageIntro.jsp#2 $$Change: 635969 $ --%>
