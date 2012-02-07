<dsp:page>
<%--
  This gadget displays shipping address information as:
  
    first name, middle name, last name
    street
    city
    state
    postal code
    country
    telephone number
    
  Parameter:
    address - shipping address (an instance of atg.core.util.Address) 
--%>  

  <dsp:getvalueof var="shippingAddress" param="shippingAddress"/>
  <dsp:getvalueof var="shippingMethod" param="shippingMethod"/>
  
  <div class="vcard">
       
    <div class="fn">
        <span><dsp:valueof value="${shippingAddress.firstName}"/></span>
        <span><dsp:valueof value="${shippingAddress.middleName}"/></span>
        <span><dsp:valueof value="${shippingAddress.lastName}"/></span>
    </div>  
            
    <div class="adr">

	    <div class="street-address">
	      <dsp:valueof value="${shippingAddress.address1}"/>
	    </div>  
	    
	    <div class="street-address"> 
	      <c:if test="${not empty shippingAddress.address2}">
	        <dsp:valueof value="${shippingAddress.address2}"/>
	      </c:if>
	    </div>
	
	    <span class="locality">
	      <dsp:valueof value="${shippingAddress.city}"/><fmt:message key="common.comma"/>
	    </span>
	    
	    <c:if test="${not empty shippingAddress.state}">
	      <span class="region">
	        <dsp:valueof value="${shippingAddress.state}"/><fmt:message key="common.comma"/>
	      </span>
	    </c:if>
	
	    <span class="postal-code">
	      <dsp:valueof value="${shippingAddress.postalCode}"/>
	    </span>
	    
	    <div class="country-name">
	      <dsp:droplet name="/atg/store/droplet/CountryListDroplet">
	        <dsp:param name="userLocale" bean="/atg/dynamo/servlet/RequestLocale.locale" />
	        <dsp:param name="countryCode" value="${shippingAddress.country}"/>
	           <dsp:oparam name="false">
	           <span class="country-name">
	             <dsp:valueof param="countryDetail.displayName" />
	           </span>
	        </dsp:oparam>
	      </dsp:droplet>               
	    </div>
	    
	  </div>

    <div class="tel">
      <dsp:valueof value="${shippingAddress.phoneNumber}"/>
    </div>
    
    <c:if test="${not empty shippingMethod}">
      <div class="ship_method"><fmt:message key="common.delivery${fn:replace(shippingMethod, ' ', '')}"/></div>
    </c:if>

  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/shippingAddressView.jsp#2 $$Change: 635969 $--%>