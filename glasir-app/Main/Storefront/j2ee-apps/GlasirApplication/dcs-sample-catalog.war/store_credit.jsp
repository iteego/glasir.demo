<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/order/purchase/PaymentGroupDroplet"/>
<dsp:importbean bean="/atg/commerce/order/purchase/PaymentGroupFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<body>
<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
<dsp:a href="product_search.jsp">Product Search</dsp:a> - 
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a> - 
<dsp:a href="lists.jsp">My Lists</dsp:a> - 
<dsp:a href="comparison.jsp">Product Comparison</dsp:a> -
<dsp:a href="giftlist_search.jsp">Gift List Search</dsp:a> - 
<dsp:droplet name="/atg/dynamo/droplet/Switch">
  <dsp:param bean="/atg/userprofiling/Profile.transient" name="value"/>
  <dsp:oparam name="false">
    <dsp:a href="logout.jsp">Logout</dsp:a>
  </dsp:oparam>
  <dsp:oparam name="true">
    <dsp:a href="login.jsp">Login</dsp:a> or <dsp:a href="register.jsp">Register</dsp:a>
  </dsp:oparam>
</dsp:droplet>
<BR>
<i>location: <dsp:valueof bean="Profile.currentLocation"/></i><p>

<%-- Check for errors  --%>
<dsp:droplet name="Switch">
  <dsp:param bean="PaymentGroupFormHandler.formError" name="value"/>
  <dsp:oparam name="true">
    <font color=cc0000><STRONG><UL>
      <dsp:droplet name="ErrorMessageForEach">
        <dsp:param bean="PaymentGroupFormHandler.formExceptions" name="exceptions"/>
        <dsp:oparam name="output">
        <LI> <dsp:valueof param="message"/>
        </dsp:oparam>
      </dsp:droplet>
    </UL></STRONG></font>
  </dsp:oparam>
</dsp:droplet>

<p>Here we utilize the PaymentGroupDroplet to initialize CreditCard and StoreCredit
PaymentGroups. CreditCards are initialized based on the Profile property referenced
by PaymentGroupDroplet.creditCardsPropertyName. StoreCredits are initialized based
on the ClaimableManager.getStoreCreditsForProfile method, which querires the
ClaimableRepository. If a user has no StoreCredits in the ClaimableRepository, then
none will appear here. If a user wishes to make a purchase for an amount greater then
that authorized by the StoreCredit, then multiple PaymentGroups should be used.
The PaymentGroupDroplet also initializes one OrderPaymentInfo object to keep the
association between the Order and whichever PaymentGroup the user selects

<p>You can readily add a StoreCredit to the ClaimableRepository by running an XML
operation tag in the component browser at
http://localhost:8830/nucleus/atg/commerce/claimable/ClaimableRepository/

<p>The following xml will create a StoreCredit with an amount remaining of $10,000
for the current user.

<PRE>
  &lt;add-item item-descriptor="StoreCreditClaimable"&gt;
    &lt;set-property name="amount" value="10000"/&gt;
    &lt;set-property name="amountAuthorized" value="0"/&gt;
    &lt;set-property name="amountRemaining" value="10000"/&gt;
    &lt;set-property name="ownerId" value="<dsp:valueof bean="Profile.id"/>"/&gt;
    &lt;set-property name="expirationDate" value="01/01/2010"/&gt;
    &lt;set-property name="issueDate" value="01/01/2001"/&gt;
  &lt;/add-item&gt;
</PRE>


<dsp:droplet name="PaymentGroupDroplet">
  <dsp:param name="clear" value="true"/>
  <dsp:param name="initOrderPayment" value="true"/>
  <dsp:param name="paymentGroupTypes" value="creditCard,storeCredit"/>
  <dsp:param name="initPaymentGroups" value="true"/>
  <dsp:oparam name="output">
  <dsp:setvalue bean="PaymentGroupFormHandler.listId" paramvalue="order.id"/>
  <!-- begin output -->
    <dsp:form action="store_credit.jsp" method="post">
    <dsp:droplet name="ForEach">
      <dsp:param name="array" param="paymentGroups"/>
      <dsp:oparam name="empty">There are no StoreCredits or CreditCards for this user.</dsp:oparam>
      <dsp:oparam name="output">
        <dsp:input bean="PaymentGroupFormHandler.currentList[0].paymentMethod" paramvalue="key" type="radio"/><dsp:valueof param="key"/><br>
      </dsp:oparam>
      <dsp:oparam name="outputEnd">
        <dsp:input bean="PaymentGroupFormHandler.ListId" paramvalue="order.id" priority="<%=(int)9%>" type="hidden"/>
        <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroupsSuccessURL" type="hidden" value="order_confirmation.jsp"/>
        <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroups" type="submit" value="Continue"/>
      </dsp:oparam>
    </dsp:droplet>
    </dsp:form>
  <!-- end output -->
  </dsp:oparam>
</dsp:droplet>

<p>Go <dsp:a href="billing.jsp?init=true">back</dsp:a> to normal billing page.

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/store_credit.jsp#2 $$Change: 635969 $--%>
