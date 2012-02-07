<%--
Tag using the StoreText droplet to perform a look up for a localized text resource message
based on a supplied key attribute writing the resulting message to the page.

Attributes:
  key       Required  The key code to use when looking up the message.
  arg name  Optional  An arbitrary number of tag attributes used when populating any embedded
                        format specifiers in the message text. The actual 'arg name' attribute
                        is not defined; any attribute passed to the tag which is not tied to an
                        explicitly named attribute is added to the dynamic 'argMap' map object
                        with the attribute name/value pairs becoming the map key/entry values.
                        The map is then passed to the StoreText droplet as the 'args' parameter.

Usage:
  <crs:outMessage key={key} [{arg name}={arg value}]/>

Example:
  <crs:getMessage key="common.storeName" var="storeName"/>
  <crs:outMessage key="company_aboutUs.aboutUs" storeName="${storeName}"/>

--%>

<%@include file="/includes/taglibs.jspf"%>
<%@include file="/includes/context.jspf"%>


<%@attribute name="key" required="true"%>

<%@tag dynamic-attributes="argMap"%>


<dsp:importbean bean="/atg/store/droplet/StoreText"/>


<dsp:droplet name="StoreText">
  <dsp:param name="key" value="${key}"/>
  <dsp:param name="args" value="${argMap}"/>

  <dsp:oparam name="output">
    <dsp:getvalueof var="message" param="message"/>
    <c:out value="${message}" escapeXml="false"/>
  </dsp:oparam>
  <dsp:oparam name="error">
    <dsp:getvalueof var="message" param="message"/>
    <c:out value="${message}" escapeXml="false"/>
  </dsp:oparam>
</dsp:droplet>
<%-- @version $Id$$Change$--%>
