<%--

  The stringSizeClass tag returns CSS class name based on the string's size passed to it. 
  It could be used to assign different font sizes to strings of different length.

  For example, the JSP code might have:
    <h2 class="title <crs:stringSizeClass string='${productName}' mediumBeginIndex='26' longBeginIndex='41'/>">

  Which, for a given header element, may end up getting parsed into HTML like:

    <tr class="title atg_string_long">

  Inputs into the tag are:

    - string - the string which size should be examined
    - mediumBeginIndex (optional) - the starting point from which the string is considered to be of 
                                   medium size. The default value is 26.
    - longBeginIndex (optional) - the starting point from which the string is considered to be of 
                                  long size. The default value is 41.        
    - additionalClasses - These are extra, static CSS classes that will get returned as part of the CSS class.

  The tag will output a CSS class that corresponds to the string size.  Possible classes are:

    - atg_string_medium - for strings of medium size (default values are from 26 to 40 characters)
    - atg_string_long - for strings of long size (default values are from 41 characters)
--%>
<%@include file="/includes/taglibs.jspf"%>
<%@include file="/includes/context.jspf"%>

<%@ tag body-content="empty" %>
<%@ attribute name="string" required="true" %>
<%@ attribute name="mediumBeginIndex" required="false" %>
<%@ attribute name="longBeginIndex" required="false" %>
<%@ attribute name="additionalClasses" required="false" %>
<dsp:page>
  <c:if test="${empty mediumBeginIndex}">
    <c:set var="mediumBeginIndex" value="26"/>
  </c:if>
  <c:if test="${empty longBeginIndex}">
    <c:set var="longBeginIndex" value="41"/>
  </c:if>
  ${(fn:length(string)) >= longBeginIndex ? 'atg_string_long' : ((fn:length(string)) >= mediumBeginIndex ? 'atg_string_medium' : '')}${empty additionalClasses ? '' : ' '+ additionalClasses}  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/WEB-INF/tags/store/stringSizeClass.tag#2 $$Change: 635969 $--%>
