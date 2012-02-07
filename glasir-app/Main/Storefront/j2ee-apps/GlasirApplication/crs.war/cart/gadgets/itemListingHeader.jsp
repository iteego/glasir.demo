<dsp:page>

<%--
  This page displays the headers in the form of item, price, quantity, total for the items in the shopping cart
--%>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet" />

  <table summary="Confirmation details item list" id="atg_store_cart" cellspacing="0" cellpadding="0" border="0">
    <thead>
      <tr>
        <dsp:droplet name="SharingSitesDroplet">
          <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
          <dsp:param name="excludeInputSite" value="true"/>
          <dsp:oparam name="output">
            <th class="site"><fmt:message key="common.site"/></th>
          </dsp:oparam>
        </dsp:droplet>
        <th class="item" colspan="3"><fmt:message key="common.item"/></th>
        <th class="price"><fmt:message key="common.price"/></th>
        <th class="quantity"><fmt:message key="common.qty" /></th>
        <th class="total"><fmt:message key="common.total"/></th>
      </tr>
    </thead>
    <tbody>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/itemListingHeader.jsp#2 $$Change: 635969 $--%>
