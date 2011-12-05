<%--

  If you have a list of something (search results, order items, category names, etc),
  you can use the listClass tag as part of the HTML tag that delineates each item in the list.
  The listClass tag will return a series of CSS class names that can be used by the designer to
  control the look of the list.

  For example, the JSP code might have:

    <tr class="<crs:listClass count="${count}" size="${size}" selected="false"/>">

  Which, for a given element in a list, may end up getting parsed into HTML like:

    <tr class="first odd">

  In this case, it’s part of a <tr> tag, but it’s frequently used in <li> tags as well.

  Inputs into the tag are:

    - count - The current number for the list item being rendered (1 for the first item, 2 for the second item, etc.)
    - size - The overall size of the list
    - selected - A boolean flag indicated if this is a "selected" item.  For example, listClass is used when
                 displaying the list of available languages.  The current selected language is marked as "selected"
    - additionalClasses - These are extra, static CSS classes that will get returned as part of the list.

  The tag will output a list of classes.  Possible classes are:

    - first - returned for the first item in the list
    - odd - returned for odd elements in the list
    - even - returned for even elements in the list
    - last - returned for the last item in the list
    - active - returned if the given item is "selected"

  The "count" and "size" input parameters can be obtained through output parameters in the "ForEach" droplet,
  when using that to iterate through a list.
--%>

<%@ tag body-content="empty" %>
<%@ attribute name="count" required="true" %>
<%@ attribute name="size" required="true" %>
<%@ attribute name="selected" required="true" %>
<%@ attribute name="additionalClasses" required="false" %>
${(count % 2) == 1 ? 'odd' : 'even'}${count == 1 ? ' first' : ''}${count == size ? ' last' : ''}${selected ? ' active' : ''}${empty additionalClasses ? '' : ' '}${empty additionalClasses ? '' : additionalClasses}
<%-- @version $Id$$Change$--%>
