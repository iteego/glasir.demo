<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/commerce/order/purchase/CreateElectronicShippingGroupFormHandler"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<hr>
Enter new email address for ElectronicShippingGroup

<dsp:form action="electronic_sg.jsp" method="post">

ShippingGroup NickName:<dsp:input bean="CreateElectronicShippingGroupFormHandler.electronicShippingGroupName" size="30" type="text"/>
<br>Email Address:<dsp:input bean="CreateElectronicShippingGroupFormHandler.emailAddress" beanvalue="Profile.email" size="30" type="text"/>

<br>
<dsp:input bean="CreateElectronicShippingGroupFormHandler.newElectronicShippingGroupSuccessURL" type="hidden" value="shipping.jsp?init=false"/>
<dsp:input bean="CreateElectronicShippingGroupFormHandler.newElectronicShippingGroupErrorURL" type="hidden" value="shipping.jsp?init=false"/>
<dsp:input bean="CreateElectronicShippingGroupFormHandler.newElectronicShippingGroup" priority="<%=(int)-10%>" type="submit" value="Create ElectronicShippingGroup"/>

</dsp:form>
</body>
</html>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/electronic_sg.jsp#2 $$Change: 635969 $--%>
