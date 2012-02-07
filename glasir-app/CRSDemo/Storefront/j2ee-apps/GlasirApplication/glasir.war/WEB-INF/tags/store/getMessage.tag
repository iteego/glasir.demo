<%--
Tag using the StoreText droplet to perform a look up for a localized text resource message
matching on the supplied key attribute, storing the message in a page scope variable.

Attributes:
  key       Required  The key code to use when looking up the message.
  var       Required  The page parameter name to hold the message text result.
  arg name  Optional  An arbitrary number of tag attributes used when populating any embedded
                        format specifiers in the message text. The actual 'arg name' attribute
                        is not defined; any attribute passed to the tag which is not tied to an
                        explicitly named attribute is added to the dynamic 'argMap' map object
                        with the attribute name/value pairs becoming the map key/entry values.
                        The map is then passed to the StoreText droplet as the 'args' parameter.

Usage:
  <crs:getMessage key={key} var={var} [{arg name}={arg value}]/>

Example:
  <crs:getMessage key="common.storeName" var="storeName"/>
  <crs:outMessage key="company_aboutUs.aboutUs" storeName="${storeName}"/>

--%>

<%@include file="/includes/taglibs.jspf"%>
<%@include file="/includes/context.jspf"%>


<%@attribute name="key" required="true"%>

<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="varAlias" scope="AT_END"%>

<%@tag dynamic-attributes="argMap"%>


<dsp:importbean bean="/atg/store/droplet/StoreText"/>


<dsp:droplet name="StoreText">
  <dsp:param name="key" value="${key}"/>
  <dsp:param name="args" value="${argMap}"/>

  <dsp:oparam name="output">
    <dsp:getvalueof var="message" param="message"/>
    <c:set var="varAlias" value="${message}"/>
  </dsp:oparam>
  <dsp:oparam name="error">
    <dsp:getvalueof var="message" param="message"/>
    <c:set var="varAlias" value="${message}"/>
  </dsp:oparam>
</dsp:droplet>
<%-- @version $Id$$Change$--%>
