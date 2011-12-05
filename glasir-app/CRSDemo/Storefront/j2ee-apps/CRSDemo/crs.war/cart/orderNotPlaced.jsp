<%-- 
  This page renders the contents of the landing page after a checkout process is cancelled.
--%>

<dsp:page>
  <crs:pageContainer divId="atg_store_cart" titleKey="cart_orderNotPlaced.title" 
                     index="false" follow="false" bodyClass="atg_store_orderNotPlaced">
    <jsp:body>
      <div class="atg_store_nonCatHero">
        <h2 class="title"><fmt:message key="cart_orderNotPlaced.orderNotPlaced" /></h2>  
      </div>
      
      <crs:messageContainer id="atg_store_confirmResponse">
        <jsp:body>
          <p>
            <fmt:message key="cart_orderNotPlaced.tryAgain">
              <fmt:param>
                <dsp:a page="/cart/cart.jsp">
                  <fmt:message key="cart_orderNotPlaced.backToCart" />
                </dsp:a>
              </fmt:param>
            </fmt:message>
          </p>
          <p><fmt:message key="cart_orderNotPlaced.privacyPolicyInfo" /></p>
          <ul>
            <li>
              <dsp:a page="/company/returns.jsp">
                <dsp:param name="selpage" value="returns"/>
                <fmt:message key="common.button.returnPolicyText" />
              </dsp:a>
            </li>
             <li>
               <fmt:message var="privacyPolicyTitle" key="common.button.privacyPolicyTitle" />
                <dsp:a page="/company/privacy.jsp" title="${privacyPolicyTitle}">
                  <dsp:param name="selpage" value="privacy"/>
                  <fmt:message key="common.button.privacyPolicyText" />
                </dsp:a>
              </li>
              <li class="atg_store_shippingPolicyLink">
                <dsp:a page="/company/shipping.jsp">
                  <dsp:param name="selpage" value="shipping"/>
                  <fmt:message key="cart_orderNotPlaced.shippingPolicy"/>
                </dsp:a>
              </li>
                
            <li>
              <dsp:a page="/company/customerService.jsp">
                <dsp:param name="selpage" value="customerService"/>
                <fmt:message key="navigation_tertiaryNavigation.contactUs"/>
              </dsp:a>
            </li>
          </ul>
          
          <div class="atg_store_formActions">
            <dsp:a page="/cart/cart.jsp" iclass="atg_store_basicButton">
              <span><fmt:message key="cart_orderNotPlaced.backToCartButton"/></span>
            </dsp:a>
          </div>
        </jsp:body>
      </crs:messageContainer>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/cart/orderNotPlaced.jsp#1 $$Change: 633540 $--%>
