<dsp:page>

  <%--
      This Page Fragment is expecting four parameters:
      (1) formhandlerComponent (Required) - This needs to be a full component Path plus and sub objects.
             e.g. /atg/commerce/order/purchase/ShippingGroupFormHandler.address
      (2) checkForRequiredFields - This puts in hte requiered flag on particular fields. Default is false.
      (3) hideNameFields - This hides the name fields necesary for credit card addresses. Default is false.
      (4) restrictionDroplet - This checks for the various droplets used while choosing the country and state .

      Optional parameters for CSS class names:
      - firstNameClassName
      - lastNameClassName
      - streetAddressClassName
      - streetAddressOptionalClassName
      - localityClassName
      - regionClassName 
      - countryNameClassName
      - postalCodeClassName
      - telephoneClassName

      Form Condition:
      - This gadget must be contained inside of more than one forms.
        Following Formhandlers must be invoked from a submit 
        button in one of the forms for fields in this page to be processed :
        - BillingFormHandler
        - ShippingGroupFormHandler
        - B2CProfileFormHandler
  --%>

  <dsp:importbean bean="/atg/store/order/purchase/BillingFormHandler"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/multisite/SiteContext"/>
  
  <dsp:getvalueof var="formHandlerComponent" param="formhandlerComponent" />
  <dsp:getvalueof var="markRequiredFields" vartype="java.lang.Boolean" param="checkForRequiredFields" />
  <dsp:getvalueof var="hideNameFields" vartype="java.lang.Boolean" param="hideNameFields" />
  <dsp:getvalueof var="preFillValues" vartype="java.lang.Boolean" param="preFillValues" />
  <dsp:getvalueof var="restrictionDroplet" param="restrictionDroplet"/>
  <dsp:getvalueof var="allowDefaultAssignation" vartype="java.lang.Boolean" param="allowDefaultAssignation" />
  
  <dsp:setvalue param="requiredTrueText" value="false" />
  <c:if test="${markRequiredFields == true}">
    <dsp:setvalue param="requiredTrueText" value="true" />
  </c:if>
  <c:if test="${restrictionDroplet == null}">
    <dsp:setvalue param="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/> 
  </c:if>
  <c:if test="${hideNameFields == null}">
    <dsp:setvalue param="hideNameFields" value="false" />
  </c:if>
  <c:if test="${preFillValues == null}">
    <dsp:setvalue param="preFillValues" value="true" />
  </c:if>

  <%-- Set up the class names --%>
  <dsp:getvalueof var="firstNameClassName" vartype="java.lang.String" param="firstNameClassName"/>
  <dsp:getvalueof var="lastNameClassName" vartype="java.lang.String" param="lastNameClassName"/>
  <dsp:getvalueof var="streetAddressClassName" vartype="java.lang.String" param="streetAddressClassName"/>
  <dsp:getvalueof var="streetAddressOptionalClassName" vartype="java.lang.String" param="streetAddressOptionalClassName"/>
  <dsp:getvalueof var="localityClassName" vartype="java.lang.String" param="localityClassName"/>
  <dsp:getvalueof var="regionClassName" vartype="java.lang.String" param="regionClassName"/>
  <dsp:getvalueof var="countryNameClassName" vartype="java.lang.String" param="countryCodeClassName"/>
  <dsp:getvalueof var="postalCodeClassName" vartype="java.lang.String" param="postalCodeClassName"/>
  <dsp:getvalueof var="telephoneClassName" vartype="java.lang.String" param="telephoneClassName"/>

  <c:if test="${firstNameClassName == null}">
    <dsp:getvalueof var="firstNameClassName" vartype="java.lang.String" value="atg_store_firstName"/>
  </c:if>
  <c:if test="${lastNameClassName == null}">
    <dsp:getvalueof var="lastNameClassName" vartype="java.lang.String" value="atg_store_lastName"/>
  </c:if>
  <c:if test="${streetAddressClassName == null}">
    <dsp:getvalueof var="streetAddressClassName" vartype="java.lang.String" value="atg_store_streetAddress"/>
  </c:if>
  <c:if test="${streetAddressOptionalClassName == null}">
    <dsp:getvalueof var="streetAddressOptionalClassName" vartype="java.lang.String"
                    value="atg_store_streetAddressOptional"/>
  </c:if>
  <c:if test="${localityClassName == null}">
    <dsp:getvalueof var="localityClassName" vartype="java.lang.String" value="atg_store_locality"/>
  </c:if>
  <c:if test="${regionClassName == null}">
    <dsp:getvalueof var="regionClassName" vartype="java.lang.String" value="atg_store_region"/>
  </c:if>
  <c:if test="${countryNameClassName == null}">
    <dsp:getvalueof var="countryNameClassName" vartype="java.lang.String" value="atg_store_countryName"/>
  </c:if>
  <c:if test="${postalCodeClassName == null}">
    <dsp:getvalueof var="postalCodeClassName" vartype="java.lang.String" value="atg_store_postalCode"/>
  </c:if>
  <c:if test="${telephoneClassName == null}">
    <dsp:getvalueof var="telephoneClassName" vartype="java.lang.String" value="atg_store_telephone"/>
  </c:if>


  <dsp:getvalueof var="requiredTrueText" param="requiredTrueText" />

  <c:if test="${hideNameFields != true}">
    <li>
      <label for="atg_store_firstNameInput">
        <fmt:message key="common.firstName"/>
        <span class="required">*</span>
      </label>

      <c:choose>
        <c:when test="${empty preFillValues || preFillValues}">
          <dsp:input type="text" bean="${formHandlerComponent}.firstName" maxlength="40" iclass="required" id="atg_store_firstNameInput" required="${requiredTrueText}"/>
        </c:when>
        <c:otherwise>
          <dsp:input type="text" bean="${formHandlerComponent}.firstName" maxlength="40" iclass="required" id="atg_store_firstNameInput" required="${requiredTrueText}" value=""/>
        </c:otherwise>
      </c:choose>
    </li>
    <li>
      <label for="atg_store_lastNameInput">
        <fmt:message key="common.lastName"/>
        <span class="required">*</span>
      </label>

      <c:choose>
        <c:when test="${empty preFillValues || preFillValues}">
          <dsp:input type="text" bean="${formHandlerComponent}.lastName" maxlength="40" iclass="required" id="atg_store_lastNameInput" required="${requiredTrueText}"/>
        </c:when>
        <c:otherwise>
          <dsp:input type="text" bean="${formHandlerComponent}.lastName" maxlength="40" iclass="required" id="atg_store_lastNameInput" required="${requiredTrueText}" value=""/>
        </c:otherwise>
      </c:choose>
    </li>

  </c:if> <%-- Hide Name Fields --%>

  <li>
    <label for="atg_store_streetAddressInput">
      <fmt:message key="common.addressLine1"/>
      <span class="required">*</span>
    </label>

    <c:choose>
      <c:when test="${empty preFillValues || preFillValues}">
        <dsp:input type="text" bean="${formHandlerComponent}.address1" maxlength="50" iclass="required"
                 id="atg_store_streetAddressInput" required="${requiredTrueText}"/>
      </c:when>
      <c:otherwise>
        <dsp:input type="text" bean="${formHandlerComponent}.address1" maxlength="50" iclass="required" id="atg_store_streetAddressInput" required="${requiredTrueText}" value=""/>
      </c:otherwise>
    </c:choose>
    <span class="example"><fmt:message key="common.line1.description"/></span>
  </li>
  <li>
    <label for="atg_store_streetAddressOptionalInput">
      <fmt:message key="common.addressLine2"/>
    </label>
    <c:choose>
      <c:when test="${empty preFillValues || preFillValues}">
        <dsp:input type="text" bean="${formHandlerComponent}.address2" maxlength="50" iclass="text" id="atg_store_streetAddressOptionalInput"/>
      </c:when>
      <c:otherwise>
        <dsp:input type="text" bean="${formHandlerComponent}.address2" maxlength="50" iclass="text"
                   id="atg_store_streetAddressOptionalInput" value="" />
      </c:otherwise>
    </c:choose>
    <span class="example"><fmt:message key="common.line2.description"/> </span>
  </li>
  <li>
    <label for="atg_store_localityInput">
      <fmt:message key="common.city"/>
      <span class="required">*</span>
    </label>
    <c:choose>
      <c:when test="${empty preFillValues || preFillValues}">
        <dsp:input type="text" bean="${formHandlerComponent}.city" maxlength="30" iclass="required"
                 id="atg_store_localityInput" required="${requiredTrueText}"/>
      </c:when>
      <c:otherwise>
        <dsp:input type="text" bean="${formHandlerComponent}.city" maxlength="30" iclass="required"
                 id="atg_store_localityInput" required="${requiredTrueText}" value=""/>
      </c:otherwise>
    </c:choose>


    <c:if test="${!empty preFillValues && !preFillValues}">
      <dsp:setvalue bean="${formHandlerComponent}.country" beanvalue="SiteContext.site.defaultCountry"/>
    </c:if>

  </li>
  
    <dsp:getvalueof var="countryRestrictionDroplet" vartype="java.lang.String" param="restrictionDroplet"/> 
    <dsp:getvalueof var="statePicker" vartype="java.lang.String" value="atg_store_stateSelect" />
    <dsp:getvalueof var="countryPicker" vartype="java.lang.String" value="atg_store_countryNameSelect" />
    <dsp:getvalueof var="countryCode" vartype="java.lang.String" value="${formHandlerComponent}.country"/>
    <li>
      <label for="atg_store_stateSelect">
        <fmt:message key="common.stateOrProvince"/>
        <span class="required">*</span>
      </label>
      <c:choose>
        <c:when test="${empty preFillValues || preFillValues}">
          <dsp:select iclass="custom_select" id="atg_store_stateSelect" bean="${formHandlerComponent}.state">
            <%@include file="/global/util/countryStatePicker.jspf" %>
          </dsp:select>
        </c:when>
        <c:otherwise>
          <dsp:select iclass="custom_select" id="atg_store_stateSelect" bean="${formHandlerComponent}.state" nodefault="true">
            <%@include file="/global/util/countryStatePicker.jspf" %>
          </dsp:select>
        </c:otherwise>
      </c:choose>
    </li>
 
  <li>
    <label for="atg_store_postalCodeInput">
      <fmt:message key="common.zipOrPostalCode"/> 
      <span class="required">*</span>
    </label>
    <c:choose>  
      <c:when test="${empty preFillValues || preFillValues}">
        <dsp:input type="text" bean="${formHandlerComponent}.postalCode" maxlength="10" iclass="required" id="atg_store_postalCodeInput" required="${requiredTrueText}"/>
      </c:when>
      <c:otherwise>
        <dsp:input type="text" bean="${formHandlerComponent}.postalCode" maxlength="10" iclass="required" id="atg_store_postalCodeInput" required="${requiredTrueText}" value=""/>
      </c:otherwise>
    </c:choose>
  </li>

  <li>
     <label for="atg_store_countryNameSelect">
       <fmt:message key="common.country"/>
       <span class="required">*</span>
     </label>
     <c:choose>
       <c:when test="${empty preFillValues || preFillValues}">
           <dsp:select iclass="custom_select" bean="${formHandlerComponent}.country" onchange='populateState(this)' id="atg_store_countryNameSelect" required="${requiredTrueText}">
           <dsp:option value=""><fmt:message key="common.selectCountry"/></dsp:option>
           <%@include file="/global/util/countryListPicker.jspf" %>
         </dsp:select>
       </c:when>
       <c:otherwise>
         <dsp:select iclass="custom_select" bean="${formHandlerComponent}.country" onchange='populateState(this)' id="atg_store_countryNameSelect" required="${requiredTrueText}">
           <dsp:option value=""><fmt:message key="common.selectCountry"/></dsp:option>           
           <%@include file="/global/util/countryListPicker.jspf" %>
         </dsp:select>
       </c:otherwise>
     </c:choose>
   </li>
  
  <c:choose>  
    <c:when test="${allowDefaultAssignation}">
      <li>
    </c:when>
    <c:otherwise>
      <li class="last">
    </c:otherwise>
  </c:choose>

    <label for="atg_store_telephoneInput">
      <fmt:message key="common.phone"/>
      <span class="required">*</span>
    </label>

    <c:choose>
      <c:when test="${empty preFillValues || preFillValues}">
        <dsp:input type="text" bean="${formHandlerComponent}.phoneNumber" iclass="required"
                   id="atg_store_telephoneInput" required="${requiredTrueText}" maxlength="15">
                 </dsp:input>
      </c:when>
      <c:otherwise>
        <dsp:input type="text" bean="${formHandlerComponent}.phoneNumber" iclass="required"
                   id="atg_store_telephoneInput" required="${requiredTrueText}" value="" maxlength="15">
                 </dsp:input>
      </c:otherwise>
    </c:choose>
  </li>

  <c:if test="${allowDefaultAssignation}">
    <li class="last default">
      <dsp:getvalueof var="defaultAddressId" bean="Profile.shippingAddress.repositoryId"/>
      <dsp:getvalueof var="currentAddressId" bean="${formHandlerComponent}.addressId"/>

      <label for="atg_store_addressAddSaveAddressInput">
        <dsp:input type="checkbox" name="useShippingAddressAsDefault" id="atg_store_useShippingAddressAsDefault"
            bean="/atg/userprofiling/B2CProfileFormHandler.useShippingAddressAsDefault" checked="${defaultAddressId == currentAddressId}">
          </dsp:input>
      </label>
      <span><fmt:message key="myaccount_address.default"/></span>
    </li>
  </c:if>

</dsp:page>


<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/addressAddEdit.jsp#3 $$Change: 635969 $--%>
