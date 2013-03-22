<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/order/purchase/CreateCreditCardFormHandler"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>

<hr>
<p>Enter new CreditCard information

<dsp:form action="credit_card.jsp" method="post">

<br>CreditCard NickName:<dsp:input bean="CreateCreditCardFormHandler.creditCardName" size="30" type="text" value=""/>
<br>CreditCardNumber:<dsp:input bean="CreateCreditCardFormHandler.creditCard.CreditCardNumber" maxsize="20" size="20" type="text" value="4111111111111111"/>
<br>CreditCardType:
<dsp:select bean="CreateCreditCardFormHandler.creditCard.creditCardType" required="<%=true%>">
<dsp:option value="Visa"/>Visa
<dsp:option value="MasterCard"/>Master Card
<dsp:option value="American Express"/>American Express
</dsp:select>

<br>ExpirationMonth: <dsp:select bean="CreateCreditCardFormHandler.creditCard.ExpirationMonth">
<dsp:option value="1"/>January
<dsp:option value="2"/>February
<dsp:option value="3"/>March
<dsp:option value="4"/>April
<dsp:option value="5"/>May
<dsp:option value="6"/>June
<dsp:option value="7"/>July
<dsp:option value="8"/>August
<dsp:option value="9"/>September
<dsp:option value="10"/>October
<dsp:option value="11"/>November
<dsp:option value="12"/>December
</dsp:select>

<br>expirationYear:Year: <dsp:select bean="CreateCreditCardFormHandler.creditCard.expirationYear">
<dsp:option value="2005"/>2005
<dsp:option value="2006"/>2006
<dsp:option value="2007"/>2007
<dsp:option value="2008"/>2008
<dsp:option value="2009"/>2009
<dsp:option value="2010"/>2010
<dsp:option value="2011"/>2011
<dsp:option value="2012"/>2012
</dsp:select>


<br>FirstName:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.firstName" beanvalue="Profile.firstName" size="30" type="text"/>
<br>MiddleName:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.middleName" beanvalue="Profile.middleName" size="30" type="text"/>
<br>LastName:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.lastName" beanvalue="Profile.lastName" size="30" type="text"/>
<br>EmailAddress:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.email" beanvalue="Profile.email" size="30" type="text"/>
<br>PhoneNumber:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.phoneNumber" beanvalue="Profile.daytimeTelephoneNumber" size="30" type="text"/>
<dsp:droplet name="ComponentExists">
  <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
  <dsp:oparam name="true">
<br>Address:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.address1" beanvalue="Profile.defaultBillingAddress.address1" size="30" type="text"/>
<br>Address (line 2):<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.address2" beanvalue="Profile.defaultBillingAddress.address2" size="30" type="text"/>
<br>City:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.city" beanvalue="Profile.defaultBillingAddress.city" size="30" type="text"/>
<br>State:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.state" beanvalue="Profile.defaultBillingAddress.state" size="30" type="text"/>
<br>PostalCode:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.postalCode" beanvalue="Profile.defaultBillingAddress.postalCode" size="30" type="text"/>
<br>Country:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.country" beanvalue="Profile.defaultBillingAddress.country" size="30" type="text"/>
  </dsp:oparam>
  <dsp:oparam name="false">
<br>Address:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.address1" beanvalue="Profile.billingAddress.address1" size="30" type="text"/>
<br>Address (line 2):<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.address2" beanvalue="Profile.billingAddress.address2" size="30" type="text"/>
<br>City:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.city" beanvalue="Profile.billingAddress.city" size="30" type="text"/>
<br>State:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.state" beanvalue="Profile.billingAddress.state" size="30" type="text"/>
<br>PostalCode:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.postalCode" beanvalue="Profile.billingAddress.postalCode" size="30" type="text"/>
<br>Country:<dsp:input bean="CreateCreditCardFormHandler.creditCard.billingAddress.country" beanvalue="Profile.billingAddress.country" size="30" type="text"/>
  </dsp:oparam>
</dsp:droplet>
<br><dsp:input bean="CreateCreditCardFormHandler.copyToProfile" type="checkbox"/> Check to add card to profile
<br>

<dsp:input bean="CreateCreditCardFormHandler.newCreditCardSuccessURL" type="hidden" value="billing.jsp?init=false"/>
<dsp:input bean="CreateCreditCardFormHandler.newCreditCardErrorURL" type="hidden" value="credit_card.jsp"/>
<dsp:input bean="CreateCreditCardFormHandler.newCreditCard" type="submit" value="Enter Credit Card"/>

</dsp:form>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/credit_card.jsp#2 $$Change: 635969 $--%>
