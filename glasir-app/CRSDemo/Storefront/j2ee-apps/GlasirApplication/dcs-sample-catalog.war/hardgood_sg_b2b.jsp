<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/order/purchase/CreateHardgoodShippingGroupFormHandler"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<hr>
Enter new shipping address for HardgoodShippingGroup

<dsp:form action="hardgood_sg.jsp" method="post">

ShippingGroup NickName:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.hardgoodShippingGroupName" size="30" type="text" value=""/>

<br>First:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.firstName" beanvalue="Profile.firstName" size="30" type="text"/>

Middle:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.middleName" beanvalue="Profile.middleName" size="30" type="text"/>

Last:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.lastName" beanvalue="Profile.lastName" size="30" type="text"/>

<br>Address:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.address1" beanvalue="Profile.defaultShippingAddress.address1" size="30" type="text"/>

Address (line 2):<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.address2" beanvalue="Profile.defaultShippingAddress.address2" size="30" type="text"/>

<br>City:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.city" beanvalue="Profile.defaultShippingAddress.city" size="30" type="text" required="<%=true%>"/>

State:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.state" maxsize="2" beanvalue="Profile.defaultShippingAddress.state" size="2" type="text" required="<%=true%>"/>

Postal Code:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.postalCode" beanvalue="Profile.defaultShippingAddress.postalCode" size="10" type="text" required="<%=true%>"/>

Country:<dsp:input bean="CreateHardgoodShippingGroupFormHandler.HardgoodShippingGroup.ShippingAddress.country" beanvalue="Profile.defaultShippingAddress.country" size="10" type="text"/>

<br>
<dsp:input bean="CreateHardgoodShippingGroupFormHandler.newHardgoodShippingGroupSuccessURL" type="hidden" value="shipping.jsp?init=false"/>
<dsp:input bean="CreateHardgoodShippingGroupFormHandler.newHardgoodShippingGroupErrorURL" type="hidden" value="shipping.jsp?init=false"/>
<dsp:input bean="CreateHardgoodShippingGroupFormHandler.newHardgoodShippingGroup" priority="<%=(int)-10%>" type="submit" value="Create HardgoodShippingGroup"/>

</dsp:form>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/hardgood_sg_b2b.jsp#2 $$Change: 635969 $--%>
