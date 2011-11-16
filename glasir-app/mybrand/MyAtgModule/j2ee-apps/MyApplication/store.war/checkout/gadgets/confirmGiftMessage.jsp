<dsp:page>
  <%-- 
      This gadget renders the gift message for review on the order-confirmation page 
  --%>

  <dsp:getvalueof var="order" param="order"/>
  <dsp:getvalueof var="isCurrent" param="isCurrent"/>

  <dsp:getvalueof var="containsGiftMessage" vartype="java.lang.String" param="order.containsGiftMessage"/>
  <dsp:getvalueof var="hideSiteIndicator" vartype="java.lang.Boolean" param="hideSiteIndicator"/>
  
  <c:if test='${containsGiftMessage == "true"}'>
    <tr>
      
      <c:if test="${empty hideSiteIndicator or not hideSiteIndicator}">
        <td class="site">
        </td>
      </c:if>
      
      <td class="image">
        <%-- TODO link to real image for gift message --%>
        <img src="/crsdocroot/images/GN_GiftNote.jpg">
      </td>
      
      <td class="atg_store_confirmGiftMessage item">
        <p class="name"><fmt:message key="checkout_confirmGiftMessage.reviewGiftMessage"/></p>  
        
        <ul>
          <li class="atg_store_messageTo">
            <span class="atg_store_giftNoteLabel"><fmt:message key="common.to"/>:</span>
            <span class="atg_store_giftNoteInfo"><dsp:valueof param="order.specialInstructions.giftMessageTo"/></span>
          </li>
          <li class="atg_store_messageFrom">
            <span class="atg_store_giftNoteLabel"><fmt:message key="common.from"/>:</span>
            <span class="atg_store_giftNoteInfo"><dsp:valueof param="order.specialInstructions.giftMessageFrom"/></span>
          </li>
          <li class="atg_store_giftMessage">
            <span class="atg_store_giftNoteLabel"><fmt:message key="common.text"/>:</span>
            <span class="atg_store_giftNoteInfo"><dsp:valueof param="order.specialInstructions.giftMessage"/></span>
          </li>
        </ul>
        
        <c:if test="${isCurrent}">  
          <fmt:message var="editMessageTitle" key="checkout_confirmGiftMessage.button.editMessageTitle"/>
          <dsp:a page="/checkout/giftMessage.jsp" iclass="atg_store_actionEdit" title="${editMessageTitle}">
            <dsp:param name="editMessage" value="true" />
            <fmt:message key="common.button.editText"/>
          </dsp:a>
        </c:if>    
      </td>
      
      
      <td colspan="2" class="atg_store_quantityPrice price">
        <div class="atg_store_itemQty">
              <span class="quantity">
                1 <fmt:message key="common.atRateOf"/> 
              </span>
              <span class="price"> 
                <p class="price">
                  <span>
                    <fmt:message key="common.free"/>
                  </span>
                </p>
              </span>
    </div>
      </td>
    
      <td class="total">
        <p class="price">
          <fmt:message key="common.equals"/> <fmt:message key="common.free"/>
        </p>
      </td>
    </tr>
  </c:if>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/checkout/gadgets/confirmGiftMessage.jsp#1 $$Change: 633540 $--%>