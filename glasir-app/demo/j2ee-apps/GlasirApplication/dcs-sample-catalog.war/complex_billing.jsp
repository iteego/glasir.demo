<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/order/purchase/PaymentGroupDroplet"/>
<dsp:importbean bean="/atg/commerce/order/purchase/PaymentGroupFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/BeanProperty"/>
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


<dsp:droplet name="PaymentGroupDroplet">
  <dsp:param name="initOrderPayment" param="init"/>
  <dsp:param name="clearPaymentInfos" param="init"/>
  <dsp:oparam name="output">
  <dsp:setvalue bean="PaymentGroupFormHandler.listId" paramvalue="order.id"/>
  <!-- begin output -->
     <table border=0 cellpadding=0 cellspacing=0 width=800>
      <tr>
      </tr>
    
      <tr>
        <td width=55></td>
        <td valign="top" width=745>
        <table border=0 cellpadding=4 width=80%>
          <tr><td></td></tr>
          <tr>
            <td colspan=2><span class="big">Billing</span></td>
          </tr>
          <tr><td></td></tr>
          <tr>
            <td colspan=2><b>Split payment by order amount</b><br>
            Order total: <dsp:valueof converter="currency" param="order.priceInfo.total"/><br>
            <span class=help>Enter the amount you wish to move to another payment method and select the new method. The remaining amount will stay on the default payment method. <P>You must save changes before continuing.</span></td>
          </tr>
          <tr valign=top>
            <td>
            <table border=0 cellpadding=4 cellspacing=1>
              <tr valign=top>
                <td colspan=9 align=right>
                </td>
              </tr>
    
              <tr valign=bottom bgcolor="#666666">
                <td colspan=2><span class=smallbw>Amount</span></td>
                <td colspan=2><span class=smallbw>Amt to move &nbsp;</span></td>
                <td colspan=2><span class=smallbw>Payment method</span></td>
                <td colspan=3><span class=smallbw>Save changes</span></td>
    
              </tr>
    
                  <dsp:droplet name="ForEach">
                    <dsp:param bean="PaymentGroupFormHandler.currentList" name="array"/>
                    <dsp:oparam name="output">
                      <!-- begin order line item -->
                      <dsp:form action="complex_billing.jsp" method="post">
                      <tr valign=top>
                        <td><dsp:valueof converter="currency" param="element.amount"/></td>
                        <td>&nbsp;</td>
                        <td>
                        $<dsp:input bean="PaymentGroupFormHandler.currentList[param:index].splitAmount" size="6" value="0.00" type="text"/></td>
                        <td>&nbsp;</td>
                        <td>
                          <dsp:select bean="PaymentGroupFormHandler.currentList[param:index].splitPaymentMethod">
                          <dsp:droplet name="ForEach">
                            <dsp:param name="array" param="paymentGroups"/>
                            <dsp:oparam name="output">
                              <dsp:droplet name="Switch">
                                <dsp:param name="value" param="key"/>
                                <dsp:getvalueof id="nameval3" param="...element.paymentMethod" idtype="java.lang.String">
<dsp:oparam name="<%=nameval3%>">
                                  <dsp:getvalueof id="option264" param="key" idtype="java.lang.String">
<dsp:option selected="<%=true%>" value="<%=option264%>"/>
</dsp:getvalueof><dsp:valueof param="key"/>
                                </dsp:oparam>
</dsp:getvalueof>
                                <dsp:oparam name="default">
                                  <dsp:getvalueof id="option272" param="key" idtype="java.lang.String">
<dsp:option selected="<%=false%>" value="<%=option272%>"/>
</dsp:getvalueof><dsp:valueof param="key"/>
                                </dsp:oparam>
                              </dsp:droplet>
                            </dsp:oparam>
                          </dsp:droplet>
                          </dsp:select>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>
                         <dsp:input bean="PaymentGroupFormHandler.ListId" paramvalue="order.id" priority="<%=(int)9%>" type="hidden"/>
                         <dsp:input bean="PaymentGroupFormHandler.splitPaymentInfosSuccessURL" type="hidden" value="complex_billing.jsp?init=false"/>
                         <dsp:input bean="PaymentGroupFormHandler.splitPaymentInfos" type="submit" value=" Save "/>
                        </td>
                      </tr>
                      </dsp:form>
                      <!-- end order line item -->
                    </dsp:oparam>
                  </dsp:droplet>

      <td colspan=9>
<%-- table with one row with one cell  --%>
      <table border=0 cellpadding=0 cellspacing=0 width=100%>
        <tr bgcolor="#666666">
          <td></td>
        </tr>
      </table>
      </td>
    </tr>
           </table>
          </td>
        </tr>
        <tr>
          <td><br>
            <dsp:form action="complex_billing.jsp" method="post">
            <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroupsSuccessURL" type="hidden" value="order_confirmation.jsp"/>
            <dsp:input bean="PaymentGroupFormHandler.applyPaymentGroups" type="submit" value="Continue"/>
            </dsp:form>
          </td>
       </tr>
     </table>
     </td>
    </tr>
    </table>
    
    </div>
    
  <!-- end output -->
  </dsp:oparam>
</dsp:droplet> <!-- end PaymentGroupDroplet -->

</body>
</html>

</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/complex_billing.jsp#2 $$Change: 635969 $--%>
