<dsp:page>

  <%-- This is the common renderer for year-list drop-down options.
       This must be statically included (no dsp:include) in a page to 
       prevent errors from having <dsp:option> tags not inside a <dsp:select> --%>

  <c:choose>
    <c:when test="${selected}">
      <dsp:option value="${year}" selected="selected"><c:out value="${year}"/></dsp:option>
    </c:when>
    <c:otherwise>
      <dsp:option value="${year}"><c:out value="${year}"/></dsp:option>
    </c:otherwise>
  </c:choose>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/yearListRenderer.jsp#2 $$Change: 635969 $--%>
