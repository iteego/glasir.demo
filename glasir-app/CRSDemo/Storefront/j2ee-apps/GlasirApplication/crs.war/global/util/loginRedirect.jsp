<dsp:page>
<%-- The reason this page is needed is that if you try to set a bean in an
     anchor tag whose target page is a restricted page, the AccessControlServlet
     intervenes before the bean property set method is called --%>

<HTML>
    <META HTTP-EQUIV=Refresh CONTENT="0; URL=../../myaccount/login.jsp?error=${fn:escapeXml(param['error'])}">
</HTML>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/util/loginRedirect.jsp#2 $$Change: 635969 $--%>
