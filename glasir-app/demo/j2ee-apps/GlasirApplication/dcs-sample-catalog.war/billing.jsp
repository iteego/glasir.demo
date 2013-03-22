<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/ComponentExists"/>
<dsp:importbean bean="/atg/commerce/order/purchase/RepriceOrderDroplet"/>
<dsp:importbean bean="/atg/commerce/order/purchase/PaymentGroupDroplet"/>
<dsp:importbean bean="/atg/commerce/order/purchase/PaymentGroupFormHandler"/>
<dsp:importbean bean="/atg/commerce/order/purchase/CreateCreditCardFormHandler"/>
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
<dsp:droplet name="Switch">
<dsp:param bean="CreateCreditCardFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="ErrorMessageForEach">
      <dsp:param bean="CreateCreditCardFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
	<LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
    </UL></STRONG></font>
</dsp:oparam>
</dsp:droplet>

<!--The PaymentGroupDroplet and PaymentGroupFormHandler are the foundation 
of the billing framework. These can be used in a variety of ways to
determine a user's eligible payment methods and facilitate their application
to an order's line items.-->

<dsp:droplet name="RepriceOrderDroplet">
  <dsp:param name="pricingOp" value="ORDER_TOTAL"/>
</dsp:droplet>

<dsp:droplet name="PaymentGroupDroplet">
  <dsp:param name="clear" param="init"/>
  <dsp:param name="paymentGroupTypes" value="creditCard"/>
  <dsp:param name="initPaymentGroups" param="init"/>
  <dsp:param name="initOrderPayment" value="true"/>
  <dsp:oparam name="output">
  <!-- begin output -->
    <dsp:setvalue bean="PaymentGroupFormHandler.listId" paramvalue="order.id"/>
    <dsp:droplet name="ForEach">
      <dsp:param name="array" param="paymentGroups"/>
      <dsp:oparam name="outputStart">
        <dsp:form action="billing.jsp" method="post">
    <dsp:droplet name="ComponentExists">
      <dsp:param name="path" value="/atg/modules/B2BCommerce"/>
      <dsp:oparam name="true">
        <!-- Since we want to allow anonymous users to be able to checkout, we're not
        going to require approval of anyone. The approval processor that determines this
        validation relies on the Profile.approvalRequired property for this information.
        See /atg/commerce/approval/processor/CheckProfileApprovalRequirements for more information. -->
        <dsp:input bean="Profile.approvalRequired" type="hidden" value="false"/>        
      </dsp:oparam>
    </dsp:droplet>
        <dsp:input bean="PaymentGroupFormHandler.applyDefaultPaymentGroup" type="hidden" value="true"/>
        <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroupsSuccessURL" type="hidden" value="order_confirmation.jsp"/>
        <dsp:input bean="PaymentGroupFormHandler.specifyDefaultPaymentGroupSuccessURL" type="hidden" value="complex_billing.jsp?init=true"/>
        <dsp:droplet name="Switch">
          <dsp:param name="value" param="size"/>
          <dsp:oparam name="0">
            You have not entered any payment information.
          </dsp:oparam>
          <dsp:oparam name="1">
            <b>One PaymentGroup</b><BR>
            <dsp:droplet name="ForEach">
              <dsp:param name="array" param="paymentGroups"/>
              <dsp:oparam name="output">
                <dsp:input bean="PaymentGroupFormHandler.listId" beanvalue="PaymentGroupFormHandler.listId" priority="<%=(int)9%>" type="hidden"/>
                <dsp:input bean="PaymentGroupFormHandler.CurrentList[0].paymentMethod" paramvalue="key" type="hidden"/>
                <dsp:valueof param="key"/> 
                <dsp:valueof param="element.creditCardType"/> 
                <dsp:valueof converter="creditcard" param="element.creditCardNumber"/>
                <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroups" type="submit" value="Bill Entire Order to this CreditCard"/>
              </dsp:oparam>
            </dsp:droplet>
          </dsp:oparam>
          <dsp:oparam name="default">
            <b>One PaymentGroup</b><BR>
            <dsp:droplet name="ForEach">
              <dsp:param name="array" param="paymentGroups"/>
              <dsp:oparam name="output">
                <dsp:input bean="PaymentGroupFormHandler.listId" beanvalue="PaymentGroupFormHandler.listId" priority="<%=(int)9%>" type="hidden"/>
                <dsp:input bean="PaymentGroupFormHandler.CurrentList[0].paymentMethod" paramvalue="key" type="radio"/>
                <dsp:valueof param="key"/> 
                <dsp:valueof param="element.creditCardType"/> 
                <dsp:valueof converter="creditcard" param="element.creditCardNumber"/><br>
              </dsp:oparam>
            </dsp:droplet>
            <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroups" type="submit" value="Bill Entire Order to this CreditCard"/>

            <p><b>Multiple PaymentGroups</b>
            <p>The full order amount begins on the default PaymentGroup. Specific amounts may then be split onto separate PaymentGroups.
            <dsp:droplet name="ForEach">
              <dsp:param name="array" param="paymentGroups"/>
              <dsp:oparam name="output">
                <br><dsp:input bean="PaymentGroupFormHandler.defaultPaymentGroupName" paramvalue="key" type="radio"/>
                <dsp:valueof param="key"/> 
                <dsp:valueof param="element.creditCardType"/> 
                <dsp:valueof converter="creditcard" param="element.creditCardNumber"/>
              </dsp:oparam>
            </dsp:droplet>
            <br><dsp:input bean="PaymentGroupFormHandler.specifyDefaultPaymentGroup" type="submit" value="Make this the default CreditCard"/>
          </dsp:oparam>
        </dsp:droplet>
        </dsp:form>
      </dsp:oparam>
    </dsp:droplet><!-- end ForEach -->
  <!-- end output -->
  </dsp:oparam>
</dsp:droplet><!-- end PaymentGroupDroplet -->

<dsp:a href="store_credit.jsp">StoreCredit PaymentGroup</dsp:a>
This link provides a page where the PaymentGroupDroplet is utilized to initialize
the StoreCredit PaymentGroup. StoreCredits are initialized based
on the ClaimableManager.getStoreCreditsForProfile method, which querires the
ClaimableRepository.<p>

<dsp:a href="invoice_request.jsp">Request Invoice</dsp:a>
This link provides a page where the PaymentGroupDroplet is utilized to initialize
the InvoiceRequest PaymentGroup.<p>

<dsp:include page="credit_card.jsp"></dsp:include>

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/billing.jsp#2 $$Change: 635969 $--%>
