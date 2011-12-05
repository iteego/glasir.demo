<dsp:page>

  <%-- This page is used to render a stored address. The NickName of the address is not displayed here-in. 
       If required, it must be rendered just before a include to this JSP 
    
  This page expects the following input parameters
       - address - A ContactInfo Repository Item to display
       - private - If true, we will hide the details of the address.value
  --%>



  <%-- Condition to determine the CountryCode so that Country-specific Address formats can be rendered --%>
  <%-- Currently only default has been included for US Address formats. --%>
  <%-- The condition is used as a place holder for future extensibility when multiple countries will be supported --%>

  <dsp:getvalueof var="addressValue" param="address.country"/>
  <c:choose>
    <c:when test='${addressValue == ""}'/>
    <c:otherwise>
      <%-- U.S. Address format --%> 
      <div class="vcard">     
        <div class="fn">
            <span><dsp:valueof param="address.firstName"/></span>
            <span><dsp:valueof param="address.middleName"/></span>
            <span><dsp:valueof param="address.lastName"/></span>
        </div>  

          <div class="adr">
            <dsp:getvalueof var="private" param="private"/>
            <c:choose>
              <c:when test="${private == 'true'}">
                <%-- Do Not Display Address Details since it is private --%>
              </c:when>
              <c:otherwise>
                <div class="street-address">
                  <dsp:valueof param="address.address1"/>
                </div>  
                <div class="street-address"> 
                  <dsp:getvalueof var="address2" param="address.address2"/>
                  <c:if test="${not empty address2}">
                    <dsp:valueof param="address.address2"/>
                  </c:if>
                </div>
              </c:otherwise>
            </c:choose>
            
            <span class="locality"><dsp:valueof param="address.city"/><fmt:message key="common.comma"/></span>
            <dsp:getvalueof var="state" param="address.state"/>
            <c:if test="${not empty state}">
              <span class="region"><dsp:valueof param="address.state"/></span>
            </c:if>

            <span class="postal-code"><dsp:valueof param="address.postalCode"/></span>
            <div class="country-name">
              <dsp:droplet name="/atg/store/droplet/CountryListDroplet">
                <dsp:param name="userLocale" bean="/atg/dynamo/servlet/RequestLocale.locale" />
                <dsp:param name="countryCode" param="address.country"/>
                   <dsp:oparam name="false">
                   <span class="country-name"><dsp:valueof param="countryDetail.displayName" /></span>
                </dsp:oparam>
              </dsp:droplet>               
            </div>
          </div>

          <div class="tel"><dsp:valueof param="address.phoneNumber"/></div>

          <%-- Commenting since our original Storefront Address formats did not AIM ID --%>
          <%-- 
          <dsp:a class="url" href="aim:goim?screenname=abcABC123.com">[[AIM]]</dsp:a>
          --%>

      </div>       
    </c:otherwise>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/util/displayAddress.jsp#2 $$Change: 635969 $--%>
