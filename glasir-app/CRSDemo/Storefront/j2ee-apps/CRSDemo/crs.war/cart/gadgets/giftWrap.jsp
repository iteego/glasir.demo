<dsp:page>

  <%--
     This determines if the "gift wrap" or "gift note" option should be displayed on a page and displays them.

     Form Condition:
     - This gadget must be contained inside of a form.
       CartFormHandler must be invoked from a submit 
       button in this form for these fields to be processed
  --%>

  <dsp:importbean bean="/atg/store/droplet/ShowGiftWrap"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/registry/RepositoryTargeters/ProductCatalog/GiftWrapItem"/>
  <dsp:importbean bean="/atg/targeting/TargetingFirst"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
	
  <dsp:getvalueof var="contextroot" vartype="java.lang.String" bean="/OriginatingRequest.contextPath"/>

  <div class="atg_store_giftWrap">
    <h4 class="atg_store_wrapInfo">
      <fmt:message key="cart_giftWrapRenderer.giftWrapDesiredQuestion"/>
    </h4>
    <fieldset>
      <ul class="atg_store_wrapOptions">
        <!-- If specific order types should not get the gift wrap option, the name of the order class type can be
            added here as an condition with no content. -->
        <dsp:droplet name="ShowGiftWrap">
          <dsp:param name="order" bean="ShoppingCart.current"/>
          <dsp:oparam name="true">
      
            <dsp:droplet name="TargetingFirst">
              <dsp:param name="fireViewItemEvent" value="false"/>
              <dsp:param name="targeter" bean="GiftWrapItem"/>
              <dsp:param name="elementName" value="targetedProduct"/>
              <dsp:oparam name="output">
                <dsp:getvalueof var="giftWrapChecked" vartype="java.lang.Boolean" bean="ShoppingCart.current.containsGiftWrap"/>
                <li>
                  <dsp:input type="hidden" bean="CartFormHandler.giftWrapSkuId"
                             paramvalue="targetedProduct.childSkus[0].repositoryId"/>
                  <dsp:input type="hidden" bean="CartFormHandler.giftWrapProductId"
                             paramvalue="targetedProduct.repositoryId"/>
                  <dsp:input  iclass="checkbox" bean="CartFormHandler.giftWrapSelected" type="checkbox" checked="${giftWrapChecked}"
                             name="atg_store_addWrap" onclick="atg.store.util.autoSelectGiftNote()" id="atg_store_addWrap"/>
                 
                  <%-- Get the gift wrap price from the supplied sku --%>
        	        <c:set var="giftWrapPrice">
        	          <dsp:include page="/global/gadgets/priceLookup.jsp">
        	            <dsp:param name="product" param="targetedProduct"/>
        	            <dsp:param name="sku" param="targetedProduct.childSKUs[0]"/>
                   </dsp:include>
                  </c:set>           
                  
                  <%--Display the price of the gift wrapping service in this page --%>           
                  <label for="atg_store_addWrap">
                    <fmt:message key="cart_giftWrapRenderer.addGiftWrap">
                      <fmt:param>
                        ${giftWrapPrice}
                      </fmt:param>
                    </fmt:message>
                  </label>
                  
                  <%-- Popup the gift wrap details page --%>
                  <dsp:a href="${contextroot}/cart/gadgets/giftWrapDetailsPopup.jsp"
                         target="popup">
                    <dsp:param name="giftWrapPrice" value="${giftWrapPrice}"/>
                    <fmt:message key="common.button.detailsText"/>
                  </dsp:a>
                </li>
              </dsp:oparam>
            </dsp:droplet>
      
          </dsp:oparam>
        </dsp:droplet>
        <li>
          <dsp:getvalueof var="giftNotePopulated" vartype="java.lang.Boolean" bean="ShoppingCart.current.containsGiftMessage"/>
          <dsp:getvalueof var="giftNoteShouldBeAdded" vartype="java.lang.Boolean" bean="ShoppingCart.current.shouldAddGiftNote"/>
          <dsp:input iclass="checkbox" type="checkbox" name="atg_store_addNote" id="atg_store_addNote"
                     bean="CartFormHandler.giftNoteSelected" checked="${giftNotePopulated || giftNoteShouldBeAdded}"/>
          <label for="atg_store_addNote"><fmt:message key="cart_giftWrapRenderer.addGiftNote"/></label>
        </li>
      </ul>
    </fieldset>
  </div>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/gadgets/giftWrap.jsp#3 $$Change: 635969 $--%>