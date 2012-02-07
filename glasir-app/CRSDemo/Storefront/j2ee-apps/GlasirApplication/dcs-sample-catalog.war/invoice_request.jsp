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

Here we utilize the PaymentGroupDroplet to initialize an InvoiceRequest PaymentGroup.
Anonymous users and those not authorized to use InvoiceRequests should not use this
PaymentGroup type.


<dsp:droplet name="PaymentGroupDroplet">
  <dsp:param name="clear" value="true"/>
  <dsp:param name="initOrderPayment" value="true"/>
  <dsp:param name="paymentGroupTypes" value="invoiceRequest"/>
  <dsp:param name="initPaymentGroups" value="true"/>
  <dsp:oparam name="output">
  <!-- begin output -->
    <dsp:setvalue value="Request Invoice" param="invoiceRequestName"/>
    <dsp:setvalue bean="PaymentGroupFormHandler.listId" paramvalue="order.id"/>
    <dsp:setvalue bean="PaymentGroupFormHandler.paymentGroupId" paramvalue="invoiceRequestName"/>
    <dsp:form action="invoice_request.jsp" method="post">
      <dsp:input bean="PaymentGroupFormHandler.currentList[0].paymentMethod" paramvalue="invoiceRequestName" type="hidden"/><dsp:valueof param="invoiceRequestName"/>
      <dsp:input bean="PaymentGroupFormHandler.currentPaymentGroup.PONumber" type="text" value=""/>
      <dsp:input bean="PaymentGroupFormHandler.ListId" paramvalue="order.id" priority="<%=(int)9%>" type="hidden"/>
      <dsp:input bean="PaymentGroupFormHandler.paymentGroupId" paramvalue="invoiceRequestName" priority="<%=(int)9%>" type="hidden"/>
      <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroupsSuccessURL" type="hidden" value="order_confirmation.jsp"/>
      <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroups" type="submit" value="Continue"/>
    </dsp:form>
  <!-- end output -->
  </dsp:oparam>
</dsp:droplet>

<p>Go <dsp:a href="billing.jsp?init=true">back</dsp:a> to normal billing page.

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/invoice_request.jsp#2 $$Change: 635969 $--%>
