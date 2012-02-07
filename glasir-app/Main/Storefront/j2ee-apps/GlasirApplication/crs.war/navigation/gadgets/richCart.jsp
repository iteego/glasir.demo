<dsp:page>
<c:url value="/cart/cart.jsp" var="cartUrl"/>

<%-- Hook up the rich cart initialisation to the page load --%>
<script type="text/javascript">
  dojo.addOnLoad(function(){
    
    <%-- Create cart trigger widget --%>
    var triggerWidget=new atg.store.widget.RichCartTrigger({
      id:"richCartTrigger",
      containerNodeId:"atg_store_richcart",
      cartOpenCssClass: "richCartOpen",
      i18n: {cartImg: '', 
             showCart: '<fmt:message key="navigation_richCart.showCart"/>', 
             hideCart:'<fmt:message key="navigation_richCart.hideCart"/>'
             }
    });
    <%-- Creat the rich cart widget itself --%>
    var richCartWidget=new atg.store.widget.RichCartSummary({
      id:"atg_store_richCart",
      containerNodeId:"atg_store_richcart",
      quantityNodeId:"atg_store_cartQty",
      hijackClassName:"atg_behavior_addItemToCart",
      doHijack:${empty noRichCartFormHijacking},
      data: <dsp:include page="/cart/json/cartContentsData.jsp"/>,
      i18n: <dsp:include page="/cart/json/cartSummaryI18n.jsp"/>,
      url:{
        checkout: "${cartUrl}",
        error: "${cartUrl}"
      },
      duration:{
        // Durations in ms of animation elements
        highlight: 3000,
        scroll: 700,
        wipe: 280,
        autoHide: 5000
      },
      highlightColor: "#ffff99"
    });
    
    <%-- Set reference to cart widget on trigger widget --%>
    <%--
         When a widget is created declaratively, its startup() method is called automatically.
         When it is created programmatically, it is the responsibility of the developer to call
         startup after any children have been added so that you can avoid resizing children
         more than is necessary.
    --%>
    triggerWidget.startup();
    richCartWidget.startup();
    triggerWidget.cartWidget=richCartWidget;
    });    
</script>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/navigation/gadgets/richCart.jsp#2 $$Change: 635969 $--%>
