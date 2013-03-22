<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:page>

<dsp:importbean bean="/atg/userprofiling/Profile"/>
<html>
<head>
<title>Set Allow Partial Setting in Profile</title>
</head>

<body>

<h3>Set Allow Partial Setting in Profile</h3>

<dsp:getvalueof id="form18" param="returnURL" idtype="java.lang.String">
<dsp:form action="<%=form18%>" method="post">
Allow partial shipping?<BR>
<dsp:input bean="Profile.allowPartialShipment" type="radio" value="true"/>yes<BR>
<dsp:input bean="Profile.allowPartialShipment" type="radio" value="false"/>no<P>
<input type="submit" value="update">
</dsp:form></dsp:getvalueof>

</body>
</html>


</dsp:page>
<%-- @version $Id: //product/DCS/version/10.0.2/release/DCSSampleCatalog/j2ee-apps/sampleCatalog/web-app/allow_partial.jsp#2 $$Change: 635969 $--%>
