<dsp:page>

  <%-- This page represents the Email Information form to capture the inputs from the shopper
       Parameters -
       - productId - Repository Id of the Product which is to be emailed
       - categoryId - Repository Id of the Category to which the chosen Product belongs
       - templateUrl - The template to be used as the email content
  --%>

  <dsp:importbean var="originatingRequest" bean="/OriginatingRequest"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/store/catalog/EmailAFriendFormHandler"/>

  <%-- ************************* begin email info form ************************* --%>
  <dsp:form action="${originatingRequest.requestURI}?productId=${param.productId}"
        method="post" name="emailFriend" formid="emailafriendform">

    <dsp:getvalueof var="templateUrlVar" param="templateUrl" />
    <c:if test="${not empty templateUrlVar}">
      <dsp:input bean="EmailAFriendFormHandler.templateUrl" 
            value="${originatingRequest.contextPath}${templateUrlVar}" type="hidden"/>
    </c:if>

    <dsp:input bean="EmailAFriendFormHandler.productId" value="${param.productId}" type="hidden"/>
    <fmt:message key="browse_emailAFriend.defaultSubject" var="defaultSubjectText"/>
    <dsp:input bean="EmailAFriendFormHandler.subject" value="${defaultSubjectText}" type="hidden"/>

    <c:url var="successUrlVar" value="/browse/emailAFriendConfirm.jsp">
      <c:param name="productId" value="${param.productId}"/>
      <c:param name="categoryId" value="${param.categoryId}"/>
    </c:url>
    <dsp:input bean="EmailAFriendFormHandler.successURL" type="hidden" value="${successUrlVar}"/>
    
    <c:url var="errorUrlVar" value="/browse/emailAFriend.jsp">
      <c:param name="productId" value="${param.productId}"/>
      <c:param name="categoryId" value="${param.categoryId}"/>
    </c:url>
    <dsp:input bean="EmailAFriendFormHandler.errorURL" type="hidden" value="${errorUrlVar}"/>

    <dsp:getvalueof var="url" vartype="java.lang.String" param="product.template.url"/>
    <c:choose>
      <c:when test="${not empty url}">
        <%-- Product Template is set --%>
        <c:set var="cancelUrlTarget" value="${originatingRequest.contextPath}${url}"/>
        <dsp:input bean="EmailAFriendFormHandler.cancelURL" type="hidden"
            value="${cancelUrlTarget}?productId=${param.productId}&categoryId=${param.categoryId}"/>
      </c:when>
      <c:otherwise>
        <%-- Product Template not set --%>
        <dsp:input bean="EmailAFriendFormHandler.cancelURL" type="hidden"
          value="${originatingRequest.requestURI}?productId=${param.productId}&categoryId=${param.categoryId}"/>
      </c:otherwise>
    </c:choose>

    <p class="atg_store_pageDescription"><fmt:message key="browse_emailAFriendFormInputs.subtitleText"/></p>

    <%-- Show Form Errors, note this fragment already adds a table row --%>
    <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
      <dsp:param name="formHandler" bean="EmailAFriendFormHandler"/>
      <dsp:param name="submitFieldKey" value="common.button.sendText"/>
    </dsp:include>

    <ul class="atg_store_basicForm atg_store_emailAFriend">
      <li class="atg_store_recipientName">
        <label for="atg_store_emailAFriendRecipientName" class="required">
          <fmt:message key="browse_emailAFriend.recipientName"/>
          <span class="required">*</span>
        </label>
        <dsp:input bean="EmailAFriendFormHandler.recipientName" required="true" type="text"
              id="atg_store_emailAFriendRecipientName" maxlength="100"/>
      </li>
      <li class="atg_store_recipientEmailAddress">
        <label for="atg_store_emailAFriendRecipientEmailAddress" class="required">
          <fmt:message key="browse_emailAFriend.recipientEmail"/>
          <span class="required">*</span>
          
        </label>
        <dsp:input bean="EmailAFriendFormHandler.recipientEmail" required="true" type="text"
            id="atg_store_emailAFriendRecipientEmailAddress" />
      
      </li>

      <dsp:getvalueof var="transient" bean="Profile.transient"/>
      <c:choose>
        <c:when test="${transient == 'true'}">
          <li class="atg_store_senderName">
            <label for="atg_store_emailAFriendSenderName" class="required">
              <fmt:message key="browse_emailAFriend.senderName"/>
           
            <span class="required">*</span></label>
            <dsp:input bean="EmailAFriendFormHandler.senderName" required="true" type="text"
                id="atg_store_emailAFriendSenderName" maxlength="100"/>
          </li>

          <li class="atg_store_senderEmailAddress">
            <label for="atg_store_emailAFriendSenderEmailAddress" class="required">
              <fmt:message key="browse_emailAFriend.senderEmail"/>
              <span class="required">*</span>
              
            </label>
            <dsp:input bean="EmailAFriendFormHandler.senderEmail" required="true" type="text"
                id="atg_store_emailAFriendSenderEmailAddress" />
           
          </li>
        </c:when>
        <c:otherwise>
          <dsp:getvalueof var="formExceptions" bean="EmailAFriendFormHandler.formExceptions"/>
          <c:choose>
            <c:when test="${empty formExceptions}">
              <dsp:getvalueof var="senderFirstName" vartype="java.lang.String" bean="Profile.firstName"/>
              <dsp:getvalueof var="senderLastName" vartype="java.lang.String" bean="Profile.lastName"/>
              <c:set var="senderFullName">
                ${fn:trim(senderFirstName)} ${fn:trim(senderLastName)}
              </c:set>
              <dsp:getvalueof var="senderEmail" vartype="java.lang.String" bean="Profile.email"/>

              <li class="atg_store_senderName">
                <label for="atg_store_emailAFriendSenderName" class="required">
                  <fmt:message key="browse_emailAFriend.senderName"/>
                  <span class="required">*</span>
                </label>
                
                <dsp:input bean="EmailAFriendFormHandler.senderName" required="true"
                    id="atg_store_emailAFriendSenderName"
                    type="text"value="${senderFullName}" maxlength="100"/>
              </li>

              <li class="atg_store_senderEmailAddress">
                <label for="atg_store_emailAFriendSenderEmailAddress" class="required">
                  <fmt:message key="browse_emailAFriend.senderEmail"/>
                  <span class="required">*</span>
                  
                </label>
              <dsp:input bean="EmailAFriendFormHandler.senderEmail" required="true"
                    id="atg_store_emailAFriendSenderEmailAddress"
                    type="text" value="${senderEmail}" />
         
              </li>
            </c:when>
            <c:otherwise>
              <li class="atg_store_senderName">
                <label for="atg_store_emailAFriendSenderName" class="required">
                  <fmt:message key="browse_emailAFriend.senderName"/>
                  <span class="required">*</span>
                </label>
                
              <dsp:input bean="EmailAFriendFormHandler.senderName" required="true" type="text"
                    id="atg_store_emailAFriendSenderName"/>
              </li>
              <li class="atg_store_senderEmailAddress">
                <label for="atg_store_emailAFriendSenderEmailAddress" class="required">
                  <fmt:message key="browse_emailAFriend.senderEmail"/>
                  <span class="required">*</span>
                  <fmt:message key="common.emailExample"/>
                </label>
              <dsp:input bean="EmailAFriendFormHandler.senderEmail" required="true" type="text"
                    id="atg_store_emailAFriendSenderEmailAddress"/>
              </li>
            </c:otherwise>
          </c:choose>
        </c:otherwise>
      </c:choose>

      <li class="atg_store_emailMessage">
        <label for="atg_store_emailAFriendMessage">
          <fmt:message key="common.message"/>
        </label>
  
        <%-- 
          Use oninput (ff, safari, opera) and onpropertychange (ie) to 
          detect when the content of the text area changes 
        --%>
        <dsp:textarea bean="EmailAFriendFormHandler.message" maxlength="200" iclass="textAreaCount" id="atg_store_emailAFriendMessage"/>
              <span class="charCounter">
                <fmt:message key="common.charactersUsed">
                  <fmt:param>
                    <em>0</em>
                  </fmt:param>
                  <fmt:param>
                    <em>200</em>
                  </fmt:param>
                </fmt:message>
              </span>
      </li>

    </ul>

   <%--
    Do we need to specify EmailAFriendFormHandler.storeId within new multisite functionality? 
     
    <dsp:droplet name="/atg/dynamo/droplet/ComponentExists">
      <dsp:param name="path" value="/atg/store/storeconfig/InternationalizationStoreConfigurationContainer"/>
      <dsp:oparam name="true">
        <dsp:input bean="EmailAFriendFormHandler.storeId" beanvalue="Profile.storeId" type="hidden"/>
      </dsp:oparam>
    </dsp:droplet>
   --%>
   
    <div class="atg_store_formFooter">
      
      <div class="atg_store_formKey">
        <span class="required">*</span>
        <span class="required"><fmt:message key="common.requiredFields"/></span>
      </div>
  

    <div class="atg_store_formActions">
      <fmt:message var="sendButton" key="browse_emailAFriend.sendEmail"/>
      <div class="atg_store_formActionItem">
      <span class="atg_store_basicButton tertiary">
        <dsp:input bean="EmailAFriendFormHandler.send" type="submit" name="EmailAFriendFormHandler.send" value="${sendButton}"/>
      </span>
      </div>
      <div class="atg_store_formActionItem">
      <a class="atg_store_basicButton secondary" href="#" onclick="window.close();">
        <span>
          <fmt:message key="common.button.cancelText"/>
        </span>
      </a>
      </div>
    </div>
  </div>

  </dsp:form>
  <%-- ************************* end email info form ************************* --%>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/emailAFriendFormInputs.jsp#2 $$Change: 635969 $--%>
