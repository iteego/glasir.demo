<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<%--
This page allows a user to create a new giftlist, or edit an existing one.
--%>

<dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
<dsp:importbean bean="/atg/dynamo/droplet/Switch"/>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<p>
<dsp:a href="index.jsp">Catalog Home</dsp:a> - 
<dsp:a href="product_search.jsp">Product Search</dsp:a> - 
<dsp:a href="shoppingcart.jsp">Shopping Cart</dsp:a> - 
<dsp:a href="lists.jsp">My Lists</dsp:a> - 
<dsp:a href="comparison.jsp">Product Comparison</dsp:a> -
<dsp:a href="giftlist_search.jsp">Gift List Search</dsp:a> - 
<dsp:droplet name="Switch">
  <dsp:param bean="Profile.transient" name="value"/>
  <dsp:oparam name="false">
    <dsp:a href="logout.jsp">Logout</dsp:a>
  </dsp:oparam>
  <dsp:oparam name="true">
    <dsp:a href="login.jsp">Login</dsp:a> or <dsp:a href="register.jsp">Register</dsp:a>
  </dsp:oparam>
</dsp:droplet>
<P>

<!-- Display any errors processing form -->
<dsp:droplet name="/atg/dynamo/droplet/Switch">
<dsp:param bean="GiftlistFormHandler.formError" name="value"/>
<dsp:oparam name="true">
  <font color=cc0000><STRONG><UL>
    <dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
      <dsp:param bean="GiftlistFormHandler.formExceptions" name="exceptions"/>
      <dsp:oparam name="output">
  <LI> <dsp:valueof param="message"/>
      </dsp:oparam>
    </dsp:droplet>
    </UL></STRONG></font>
</dsp:oparam>
</dsp:droplet>

<!-- Look for giftlistid passed into form to do an edit -->
<dsp:droplet name="IsEmpty">
<dsp:param name="value" param="giftlistId"/>
<dsp:oparam name="false">
<strong>Edit giftlist</strong>
  <dsp:droplet name="/atg/commerce/gifts/GiftlistLookupDroplet">
    <dsp:param name="id" param="giftlistId"/>
    <dsp:oparam name="output">
      <dsp:droplet name="IsEmpty">
        <dsp:param name="value" param="element"/>
        <dsp:oparam name="false">
          <dsp:setvalue paramvalue="element" param="giftlist"/>
          <dsp:droplet name="/atg/dynamo/droplet/Switch">
          <dsp:param bean="Profile.id" name="value"/>
          <dsp:getvalueof id="nameval3" param="giftlist.owner.id" idtype="java.lang.String">
	  <dsp:oparam name="<%=nameval3%>">
          <dsp:form action="lists.jsp" method="POST">
            <dsp:input bean="GiftlistFormHandler.giftlistId" paramvalue="giftlistId" type="hidden"/>
            <table cellspacing=0 cellpadding=0 border=0>
            <!-- Setup gutter and make space -->
            <tr>
            <td width=30%><dsp:img height="1" width="100" src="images/d.gif"/><br></td>
            <td>&nbsp;&nbsp;</td>
            <td><dsp:img height="1" width="400" src="images/d.gif"/></td>
            </tr>
  
            <tr valign=top>
            <td width=30%>
            <span class=help>
            Edit your giftlist.
            </span>
            </td>
            <td></td>
            <td>
            <table width=100% cellpadding=0 cellspacing=0 border=0>
            <tr><td class=box-top-store>Gift list properties</td></tr></table>
            <p>
            <b>Event Name</b><br>
            <dsp:input bean="GiftlistFormHandler.eventName" paramvalue="giftlist.eventName" size="40" type="text"/>
            <p>
            <dsp:setvalue bean="GiftlistFormHandler.eventDate" paramvalue="giftlist.eventDate"/>
            <b>Event Date</b>
            <dsp:select bean="GiftlistFormHandler.month">
              <dsp:droplet name="ForEach">
                <dsp:param bean="GiftlistFormHandler.months" name="array"/>
                <dsp:oparam name="output">
                  <dsp:getvalueof id="option205" param="index" idtype="java.lang.Integer">
		  <dsp:option value="<%=option205%>"/>
		  </dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
                </dsp:oparam>
              </dsp:droplet>
            </dsp:select>
            <dsp:select bean="GiftlistFormHandler.date">
            <dsp:droplet name="ForEach">
              <dsp:param bean="GiftlistFormHandler.dates" name="array"/>
              <dsp:oparam name="output">
                <dsp:getvalueof id="option224" param="element" idtype="java.lang.String">
		<dsp:option value="<%=option224%>"/>
		</dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
              </dsp:oparam>
            </dsp:droplet>
            </dsp:select>
            <dsp:select bean="GiftlistFormHandler.year">
            <dsp:droplet name="ForEach">
              <dsp:param bean="GiftlistFormHandler.years" name="array"/>
              <dsp:oparam name="output">
                <dsp:getvalueof id="option243" param="element" idtype="java.lang.String">
		<dsp:option value="<%=option243%>"/>
		</dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
              </dsp:oparam>
              </dsp:droplet>
              </dsp:select>
             <p>
             <b>Event Type</b> 
             <dsp:setvalue bean="GiftlistFormHandler.eventType" paramvalue="giftlist.eventType"/>
             <dsp:select bean="GiftlistFormHandler.eventType">
             <dsp:droplet name="ForEach">
               <dsp:param bean="GiftlistFormHandler.eventTypes" name="array"/>
               <dsp:oparam name="output">
                 <dsp:getvalueof id="option270" param="element" idtype="java.lang.String">
		 <dsp:option value="<%=option270%>"/>
		 </dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
               </dsp:oparam>
               </dsp:droplet>
               </dsp:select><br>

            <p>
            <b>Comments</b><br>
            <dsp:setvalue bean="GiftlistFormHandler.comments" paramvalue="giftlist.comments"/>
            <dsp:textarea bean="GiftlistFormHandler.comments" rows="4" cols="40"></dsp:textarea>
            <p>
            <b>Event Description</b><br>
            <dsp:setvalue bean="GiftlistFormHandler.description" paramvalue="giftlist.description"/>
            <dsp:textarea bean="GiftlistFormHandler.description" rows="4" cols="40"></dsp:textarea>
            <p>
            <b>Extra information or special instructions</b><br>
            <dsp:textarea bean="GiftlistFormHandler.instructions" rows="4" cols="40"></dsp:textarea>
            <p>
            <b>Where should people ship the gifts?</b><p>
            <blockquote>
            <dsp:setvalue bean="GiftlistFormHandler.shippingAddressId" paramvalue="giftlist.shippingAddress.id"/>
            <dsp:input bean="GiftlistFormHandler.isNewAddress" type="radio" checked="<%=true%>" value="false"/>Choose one of your saved shipping destinations.<br>
              <dsp:select bean="GiftlistFormHandler.shippingAddressId">
              <dsp:droplet name="ForEach">
                <dsp:param bean="GiftlistFormHandler.addresses" name="array"/>
                <dsp:oparam name="output">
                  <dsp:getvalueof id="option339" param="key" idtype="java.lang.String">
		  <dsp:option value="<%=option339%>"/>
		  </dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
                </dsp:oparam>
              </dsp:droplet>
              </dsp:select><br>
            <p>
  <dsp:input bean="GiftlistFormHandler.isNewAddress" type="radio" value="true"/>New address below
  <p>
  If you want this address stored in your address book, please give it a nickname<br>
  <dsp:input bean="GiftlistFormHandler.newAddressName" size="40"/><br>
  Name <br><dsp:input bean="GiftlistFormHandler.newAddress.firstName" name="firstName" size="20"/>
  <dsp:input bean="GiftlistFormHandler.newAddress.middleName" name="middleName" size="5"/>
  <dsp:input bean="GiftlistFormHandler.newAddress.lastName" name="lastName" size="20"/><br>
  Street address <br>
  <dsp:input bean="GiftlistFormHandler.newAddress.address1" name="address1" size="40"/><br>
  <dsp:input bean="GiftlistFormHandler.newAddress.address2" name="address2" size="40"/><br>
  City<br>
  <dsp:input bean="GiftlistFormHandler.newAddress.city" name="city" size="15"/><br>
  State<br>
  <dsp:input bean="GiftlistFormHandler.newAddress.state" name="state" size="40"/><br>
  Postal code<br>
  <dsp:input bean="GiftlistFormHandler.newAddress.postalCode" name="postalCode" size="15"/><br>
  Country<br>
  <dsp:input bean="GiftlistFormHandler.newAddress.country" name="country" size="40"/><br>
            </blockquote>

            <p>&nbsp;<br>
            </td>
            </tr>
  
            <tr valign=top>
            <td width=30%>
            <span class=help>
              If you do not make your list public, then
              it will not be shown to people searching for giftlists. You can
              make your list public anytime by editing it.
            </span>

            </td>
            <td></td>
            <td>
            <table width=100% cellpadding=0 cellspacing=0 border=0>
            <tr><td class=box-top-store>Gift list public?</td></tr></table>
            <p>
           
            <dsp:setvalue bean="GiftlistFormHandler.isPublished" paramvalue="giftlist.published"/>
            <dsp:input bean="GiftlistFormHandler.isPublished" type="radio" value="true"/> Make my list public now<br>
            <dsp:input bean="GiftlistFormHandler.isPublished" type="radio" value="false"/> Don't make my list public yet
            <p>&nbsp;<br>
            <dsp:input bean="GiftlistFormHandler.deleteGiftlistSuccessURL" type="hidden" value="./lists.jsp"/>
            <dsp:input bean="GiftlistFormHandler.deleteGiftlistErrorURL" type="hidden" value='<%=new String("./lists_new.jsp?giftlistId=" + request.getParameter("giftlistId"))%>'/>
            <dsp:input bean="GiftlistFormHandler.updateGiftlistSuccessURL" type="hidden" value="./lists.jsp"/>
            <dsp:input bean="GiftlistFormHandler.updateGiftlistErrorURL" type="hidden" value='<%=new String("./lists_new.jsp?giftlistId=" + request.getParameter("giftlistId"))%>'/>
            <dsp:input bean="GiftlistFormHandler.updateGiftlist" name="update" type="submit" value="Save"/>
            or
            <dsp:input bean="GiftlistFormHandler.deleteGiftlist" name="delete" type="submit" value="Delete"/>
            </td>
            </tr>
            </table>
            </dsp:form>
            </dsp:oparam>
	    </dsp:getvalueof>
            <dsp:oparam name="default">
            You do not have permission to access the specified giftlist
            </dsp:oparam>
            </dsp:droplet>
        </dsp:oparam>
        <dsp:oparam name="true">
          <font color=cc0000><STRONG><UL>
          Either no giftlist found or you do not have permission to access it.
          </UL></STRONG></font>
        </dsp:oparam>
      </dsp:droplet>
    </dsp:oparam>
  </dsp:droplet>
</dsp:oparam>
<dsp:oparam name="true">
<!-- creating a new giftlist-->
<span class=storebig>Create new giftlist</span>
<dsp:form action="lists.jsp" method="POST">
<dsp:input bean="GiftlistFormHandler.saveGiftlistSuccessURL" type="hidden" value="./lists.jsp"/>
<dsp:input bean="GiftlistFormHandler.saveGiftlistErrorURL" type="hidden" value="./lists_new.jsp"/>
<table cellspacing=0 cellpadding=0 border=0>
<!-- Setup gutter and make space -->
  <tr>
  <td width=30%><dsp:img height="1" width="100" src="images/d.gif"/><br></td>
  <td>&nbsp;&nbsp;</td>
  <td><dsp:img height="1" width="400" src="images/d.gif"/></td>
  </tr>
  
  <tr valign=top>
  <td width=30%>
  <span class=help>
  Create your giftlist.
  </span>
  </td>
  <td></td>
  <td>
  <table width=100% cellpadding=0 cellspacing=0 border=0>
  <tr><td class=box-top-store>Gift list properties</td></tr></table>
  <p>
  <b>Event Name</b><br>
  <dsp:input bean="GiftlistFormHandler.eventName" size="40" type="text"/>
  <p>
  <b>Event Date</b>
  <dsp:select bean="GiftlistFormHandler.month">
    <dsp:droplet name="ForEach">
      <dsp:param bean="GiftlistFormHandler.months" name="array"/>
      <dsp:oparam name="output">
        <dsp:getvalueof id="option574" param="index" idtype="java.lang.Integer">
	<dsp:option value="<%=option574.toString()%>"/>
	</dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
      </dsp:oparam>
    </dsp:droplet>
  </dsp:select>
  <dsp:select bean="GiftlistFormHandler.date">
  <dsp:droplet name="ForEach">
    <dsp:param bean="GiftlistFormHandler.dates" name="array"/>
    <dsp:oparam name="output">
      <dsp:getvalueof id="option593" param="element" idtype="java.lang.String">
      <dsp:option value="<%=option593%>"/>
      </dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
    </dsp:oparam>
  </dsp:droplet>
  </dsp:select>
  <dsp:select bean="GiftlistFormHandler.year">
  <dsp:droplet name="ForEach">
    <dsp:param bean="GiftlistFormHandler.years" name="array"/>
    <dsp:oparam name="output">
      <dsp:getvalueof id="option612" param="element" idtype="java.lang.String">
      <dsp:option value="<%=option612%>"/>
      </dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
    </dsp:oparam>
    </dsp:droplet>
    </dsp:select>
   <p>
   <b>Event Type</b> 
   <dsp:select bean="GiftlistFormHandler.eventType">
   <dsp:droplet name="ForEach">
     <dsp:param bean="GiftlistFormHandler.eventTypes" name="array"/>
     <dsp:oparam name="output">
       <dsp:getvalueof id="option637" param="element" idtype="java.lang.String">
<dsp:option value="<%=option637%>"/>
</dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
     </dsp:oparam>
     </dsp:droplet>
     </dsp:select><br>

  <p>
  <b>Comments</b><br>
  <dsp:setvalue bean="GiftlistFormHandler.comments" value=""/>
  <dsp:textarea bean="GiftlistFormHandler.comments" rows="4" cols="40"></dsp:textarea>
  <p>
  <b>Event Description</b><br>
  <dsp:setvalue bean="GiftlistFormHandler.description" value=""/>
  <dsp:textarea bean="GiftlistFormHandler.description" rows="4" cols="40"></dsp:textarea>
  <p>
  <b>Extra information or special instructions</b><br>
  <dsp:textarea bean="GiftlistFormHandler.instructions" rows="4" cols="40"></dsp:textarea>
  <p>
  <b>Where should people ship the gifts?</b><p>
  <blockquote>
  <dsp:input bean="GiftlistFormHandler.isNewAddress" type="radio" checked="<%=true%>" value="false"/>Choose one of your saved shipping destinations.<br>
    <dsp:select bean="GiftlistFormHandler.shippingAddressId">
    <dsp:droplet name="ForEach">
      <dsp:param bean="GiftlistFormHandler.addresses" name="array"/>
      <dsp:oparam name="output">
        <dsp:getvalueof id="option705" param="key" idtype="java.lang.String">
<dsp:option value="<%=option705%>"/>
</dsp:getvalueof><dsp:valueof param="element">UNDEFINED</dsp:valueof>
      </dsp:oparam>
    </dsp:droplet>
    </dsp:select><br>
  <p>
  <dsp:input bean="GiftlistFormHandler.isNewAddress" type="radio" value="true"/>New address below
  <p>
  If you want this address stored in your address book, please give it a nickname:<br>
  <dsp:input bean="GiftlistFormHandler.newAddressName" size="40"/><br>
  Name <br><dsp:input bean="GiftlistFormHandler.newAddress.firstName" name="firstName" size="20"/>
  <dsp:input bean="GiftlistFormHandler.newAddress.middleName" name="middleName" size="5"/>
  <dsp:input bean="GiftlistFormHandler.newAddress.lastName" name="lastName" size="20"/><br>
  Street address <br>
  <dsp:input bean="GiftlistFormHandler.newAddress.address1" name="address1" size="40"/><br>
  <dsp:input bean="GiftlistFormHandler.newAddress.address2" name="address2" size="40"/><br>
  City<br>
  <dsp:input bean="GiftlistFormHandler.newAddress.city" name="city" size="15"/><br>
  State<br>
  <dsp:input bean="GiftlistFormHandler.newAddress.state" name="state" size="40"/><br>
  Postal code<br>
  <dsp:input bean="GiftlistFormHandler.newAddress.postalCode" name="postalCode" size="15"/><br>
  Country<br>
  <dsp:input bean="GiftlistFormHandler.newAddress.country" name="country" size="40"/><br>
  </blockquote>

  <p>&nbsp;<br>
  </td>
  </tr>
  
  <tr valign=top>
  <td width=30%>
  <span class=help>
  Decide if you want your list to be public yet. When you make your list public, your friends can
  find your list by searching.
  </span>

  </td>
  <td></td>
  <td>
  <table width=100% cellpadding=0 cellspacing=0 border=0>
  <tr><td class=box-top-store>Gift list public?</td></tr></table>
  <p>

  <dsp:input bean="GiftlistFormHandler.isPublished" name="published" type="radio" value="true"/> Make my list public now<br>
  <dsp:input bean="GiftlistFormHandler.isPublished" name="published" type="radio" checked="<%=true%>" value="false"/> Don't make my list public yet
      
  <p>&nbsp;<br>
      
  <dsp:input bean="GiftlistFormHandler.saveGiftlist" type="submit" value="Save gift list"/>
<br>&nbsp;<br>
  </td>
  </tr>
</dsp:form>

<tr><td colspan=2></td>
<td><dsp:form action="lists.jsp"><input type=submit value="Cancel"></dsp:form></td></tr>
  
</table>


</dsp:oparam>
</dsp:droplet>


</BODY>
</HTML>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/lists_new.jsp#2 $$Change: 635969 $--%>
