<dsp:page>

  <%-- This page just looks the price up in the list price and sales price price lists
       This page expects the following parameters
       - product - the product repository item whose price to display
       - sku - the sku repository item for the product whose price to display
  --%>
  
  <dsp:importbean bean="/atg/commerce/pricing/priceLists/PriceDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  
  <%-- The first call to price droplet is going to get the price from the profile's list price or 
       the default price list --%>
      
              <dsp:droplet name="PriceDroplet">
                <dsp:param name="product" param="product"/>
                <dsp:param name="sku" param="sku"/>
                <dsp:oparam name="output">
                  <dsp:setvalue param="theListPrice" paramvalue="price"/>
                  <%-- The second call is in case the sale price exists --%>

                  <dsp:getvalueof var="profileSalePriceList" bean="Profile.salePriceList"/>
                  <c:choose>
                    <c:when test="${not empty profileSalePriceList}">
                      <dsp:droplet name="PriceDroplet">
                        <dsp:param name="priceList" bean="Profile.salePriceList"/>
                        <dsp:oparam name="output">
                          <span class="atg_store_newPrice">
                            <dsp:getvalueof var="listPrice" vartype="java.lang.Double" param="price.listPrice"/>
                            <dsp:include page="/global/gadgets/formattedPrice.jsp">
                              <dsp:param name="price" value="${listPrice }"/>
                            </dsp:include>
                          </span>
                          <span class="atg_store_oldPrice">
                            <fmt:message key="common.price.old"/>
                            <dsp:getvalueof var="price" vartype="java.lang.Double" param="theListPrice.listPrice"/>
                            
                            <del>
                              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                                <dsp:param name="price" value="${price }"/>
                              </dsp:include>
                            </del>
                          </span>
                        </dsp:oparam>
                        <dsp:oparam name="empty">
                          <dsp:getvalueof var="price" vartype="java.lang.Double" param="theListPrice.listPrice"/>
                          <dsp:include page="/global/gadgets/formattedPrice.jsp">
                            <dsp:param name="price" value="${price }"/>
                          </dsp:include>
                        </dsp:oparam>
                      </dsp:droplet><%-- End price droplet on sale price --%>
                    </c:when>
                    <c:otherwise>
                      <dsp:getvalueof var="price" vartype="java.lang.Double" param="theListPrice.listPrice"/>
                      <dsp:include page="/global/gadgets/formattedPrice.jsp">
                        <dsp:param name="price" value="${price }"/>
                      </dsp:include>
                    </c:otherwise>
                  </c:choose><%-- End Is Empty Check --%>
                </dsp:oparam>
              </dsp:droplet><%-- End Price Droplet --%>
    </dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/global/gadgets/priceLookup.jsp#2 $$Change: 635969 $--%>
