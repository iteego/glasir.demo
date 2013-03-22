<dsp:page>

<%-- This page expects the order as parameter and rederers tracking shipping information 
         Like Tracking No, carrierCode, shippingMethod 
        Paramters:
        - order - The order to be rendered
--%>

  <div class="atg_store_orderDetailTracking">
    <h2 class="atg_store_subHeadCustom">
      <fmt:message key="myaccount_orderDetailTracking.shipmentTackingInfo"/><fmt:message key="common.labelSeparator"/>
    </h2>
    <table summary="Shipping Tracking Details Summary" cellspacing="0" cellpadding="0" class="atg_store_trackingTable">
      <thead>
        <tr>
          <th class="atg_store_orderTrackingNumber" scope="col"><fmt:message key="myaccount_orderDetailTracking.trackingNumber"/></th>
          <th class="atg_store_orderType" scope="col"><fmt:message key="common.type"/></th>
          <th class="atg_store_orderMethod" scope="col"><fmt:message key="common.method"/></th>
        </tr>
      </thead>
      <tbody>
  
        <dsp:getvalueof var="trackingInfos" param="order.trackingInfos"/>
        <c:choose>
          <c:when test="${not empty trackingInfos}">
            
            <%-- Display Shipping Tracking Information --%>
            <dsp:getvalueof var="trackingInfos" vartype="java.lang.Object" param="order.trackingInfos"/>
            <c:forEach var="trackingInfo" items="${trackingInfos}">
              <dsp:param name="trackingInfo" value="${trackingInfo}"/>
              <tr>
                <dsp:getvalueof var="url" vartype="java.lang.String" param="trackingInfo.url"/>
                <td class="numerical">
                  <c:choose>
                    <c:when test="${not empty url}">
                      <dsp:a href="${url}" target="_blank" >
                        <dsp:valueof param="trackingInfo.trackingNumber"/>
                      </dsp:a>
                    </c:when>
                    <c:otherwise>
                      <dsp:valueof param="trackingInfo.trackingNumber"/>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td><dsp:valueof param="trackingInfo.carrierCode"/></td>
                <td><dsp:valueof param="trackingInfo.shippingMethod"/></td>
              </tr>
            </c:forEach><%-- End of ForEach Droplet--%>
            
          </c:when>
          <c:otherwise>
            <%--No Shipping tracking Information is Available --%>
            <tr><td><fmt:message key="myaccount_orderDetailTracking.notAvailable"/></td></tr>          
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/orderDetailTracking.jsp#2 $$Change: 635969 $--%>

