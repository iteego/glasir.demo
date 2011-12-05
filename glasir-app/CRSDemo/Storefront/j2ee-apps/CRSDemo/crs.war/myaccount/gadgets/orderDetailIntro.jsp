<dsp:page>

<%-- 
  This page renders details of order No and Time of placed 
  
  Parameters:
    order - The order to be rendered
--%>

  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>

    <dl class="atg_store_groupOrderInfo">
      <%-- Display the status of the order Like SUBMITTED,INCOMPLETE etc --%>
      <dt>
        <fmt:message key="common.status"/><fmt:message key="common.labelSeparator"/>
      </dt>
      <dd> 
        <dsp:include page="/global/util/orderState.jsp">
          <dsp:param name="order" param="order"/>
        </dsp:include>
      </dd>

      <dt>
        <fmt:message key="myaccount_orderDetail.placedOn"/><fmt:message key="common.labelSeparator"/>
      </dt>
      <dd class="atg_store_orderDate"> 
        <dsp:getvalueof var="submittedDate" vartype="java.util.Date" param="order.submittedDate"/>
        <fmt:message var="dateFormat" key="myaccount_myOrders.dateFormat"/>
        <fmt:formatDate value="${submittedDate}" pattern="${dateFormat}" />
      </dd>
      
      <dt>
        <fmt:message key="myaccount_orderDetail.orderedOn"/><fmt:message key="common.labelSeparator"/>
      </dt>
      <dd>
        <%-- site information --%>
        <dsp:droplet name="GetSiteDroplet">
          <dsp:param name="siteId" param="order.siteId"/>
          <dsp:oparam name="output">
            <dsp:valueof param="site.name"/>
          </dsp:oparam>
        </dsp:droplet>
      </dd>
    </dl>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/myaccount/gadgets/orderDetailIntro.jsp#1 $$Change: 633540 $--%>
