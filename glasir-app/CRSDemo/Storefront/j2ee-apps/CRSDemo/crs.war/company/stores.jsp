<%--
  This page is the company's "Store Locator" page
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/droplet/StoreLookupDroplet"/>
  <dsp:importbean bean="/atg/store/droplet/StoreSiteFilterDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>

  <crs:pageContainer divId="atg_store_company"
                     bodyClass="atg_store_stores atg_store_leftCol atg_store_company">
    <div class="atg_store_nonCatHero">
      <h2 class="title">
        <fmt:message key="company_stores.title"/>
      </h2>
    </div>
    <div class="atg_store_main">
      <ul class="atg_store_locator">

        <dsp:droplet name="StoreLookupDroplet">
          <dsp:oparam name="output">
            <dsp:droplet name="StoreSiteFilterDroplet">
              <dsp:param name="collection" param="items" />

              <dsp:oparam name="output">
                <dsp:droplet name="ForEach">
                  <dsp:param name="array" param="filteredCollection" />

                  <dsp:oparam name="output">
                    <dsp:setvalue param="storeItem" paramvalue="element"/> 
                    <li>
                      <div class="vcard">
                        <div class="org"><dsp:valueof param="storeItem.storeName"/></div>
                        <div class="adr">
                          <div class="street-address"><dsp:valueof param="storeItem.address1"/></div>

                          <dsp:getvalueof var="storeAddress2" param="storeItem.address2"/>
                          <c:if test="${not empty storeAddress2}">
                            <div class="street-address">${storeAddress2}</div>
                          </c:if>

                          <dsp:getvalueof var="storeAddress3" param="storeItem.address3"/>
                          <c:if test="${not empty storeAddress3}">
                            <div class="street-address">${storeAddress3}</div>
                          </c:if>

                          <dsp:getvalueof var="storeCity" param="storeItem.city"/>
                          <c:if test="${not empty storeCity}">
                            <span class="locality">${storeCity}</span>,
                          </c:if>

                          <dsp:getvalueof var="storeStateAddress" param="storeItem.stateAddress"/>
                          <c:if test="${not empty storeStateAddress}">
                            <span class="region">${storeStateAddress}</span>,
                          </c:if>

                          <dsp:getvalueof var="storePostalCode" param="storeItem.postalCode"/>
                          <c:if test="${not empty storePostalCode}">
                            <span class="postal-code">${storePostalCode}</span>
                          </c:if>

                          <dsp:getvalueof var="storeCountry" param="storeItem.country"/>
                          <c:if test="${not empty storeCountry}">
                            <span class="country-name">${storeCountry}</span>
                          </c:if>
                        </div>

                        <div class="tel">
                          <span class="type"><fmt:message key="common.phone"/></span><fmt:message key="common.labelSeparator"/>
                          <span class="value"><dsp:valueof param="storeItem.phoneNumber"/></span>
                        </div>

                        <dsp:getvalueof var="faxNumber" param="storeItem.faxNumber"/>
                        <c:if test="${not empty faxNumber}">
                          <div class="tel">
                            <span class="type"><fmt:message key="common.fax"/></span><fmt:message key="common.labelSeparator"/>
                            <span class="value"><c:out value="${faxNumber}"/></span>
                          </div>
                        </c:if>

                        <dsp:getvalueof var="email" vartype="java.lang.String" param="storeItem.email"/>
                          <c:if test="${not empty email}">
                            <a class="email" href="mailto:${email}">${email}</a>
                          </c:if>
                      </div>
                    </li>
                  </dsp:oparam>
                </dsp:droplet>
              </dsp:oparam>
            </dsp:droplet>
          </dsp:oparam>
          <dsp:oparam name="empty">
            <fmt:message key="company_stores.noStoresFound"/>
          </dsp:oparam>
        </dsp:droplet>
      </ul>
    </div>

    <div class="atg_store_companyNavigation aside">
      <dsp:include page="/company/gadgets/navigationPanel.jsp"/>
    </div>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/company/stores.jsp#1 $$Change: 633540 $--%>
