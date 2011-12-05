/**
 * Rich Cart Trigger Widget
 * This widget provides the 'show rich cart' / 'hide rich cart' icon/link that is used
 * to display the Rich Cart.
 */
dojo.provide("atg.store.widget.RichCartTrigger");

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");

dojo.declare(
  "atg.store.widget.RichCartTrigger", 
  [dijit._Widget, dijit._Templated],
  {
    // Define all global variables for the widget.
    // templateString: dojo.cache("dijit", contextPath + "/javascript/widget/template/richCartTrigger.html"),
    templateString: '<a href="javascript:void(0);" class="atg_store_richCartButton" dojoAttachEvent="onclick:toggleCart" dojoAttachPoint="triggerLink" title="${i18n.showCart}">  <span id="atg_store_cartQty"></span></a>',

    id: "richCartTrigger",
    containerNodeId: null,            // DOM ID of the node to create the widget within
    cartWidget: null,                 // Reference to the rich cart widget
    cartOpenCssClass: "richCartOpen",  // CSS class that is appended to trigger DOM node when cart showing
    
    /**
     * Initialize the widget
     */
    startup: function(){     
      var _this=this;
      console.debug('RichCartTrigger:startup');
      console.debug(this.i18n);
      _this.attachToContainer();
    },
    
    /**
     * Toggle the display of the rich cart
     */
    toggleCart: function(){
      console.debug("Toggling rich cart");
      this.cartWidget.toggleCart();  
      this.updateTriggerDisplay();    
    },
    
    /**
     * Set the display state of the trigger widget.
     * Toggle trigger image/text "Show Cart" <--> "Hide Cart"
     */
    updateTriggerDisplay: function(){
      console.debug("updateTriggerDisplay");
      if (this.cartWidget===null){
         return;
      }
      
      var openOrOpening=(
        (this.cartWidget.isShowing && !this.cartWidget.cartAnimationInProgress)||
        (!this.cartWidget.isShowing && this.cartWidget.cartAnimationInProgress));

      if (openOrOpening){
        console.debug(" Cart is open (or opening animation is in progress)");
        // Cart is open (or opening animation is in progress)
        //dojo.byId("atg_store_viewCart").innerHTML=this.i18n.hideCart;
        //this.triggerLink.title=this.i18n.hideCart;
        console.debug('add class: ' + this.cartOpenCssClass + ' to ' + this.domNode);
        dojo.addClass(this.domNode,this.cartOpenCssClass);
        console.debug('after style adding');

      }
      else {
        // Cart is closed (or closing animation is in progress)
        console.debug("  Cart is closed (or closing animation is in progress)");
        //dojo.byId("atg_store_viewCart").innerHTML=this.i18n.showCart;
        //this.triggerLink.title=this.i18n.showCart;
        console.debug('remove class: ' + this.cartOpenCssClass + ' from ' + this.domNode);
        dojo.removeClass(this.domNode,this.cartOpenCssClass,false);
        console.debug('after style removing');
      }
    },
    
    /**
     * Attach this widget's domNode to its containing node
     */
    attachToContainer: function(){
      console.debug("Appending trigger domNode to " + this.domNode);
      dojo.byId(this.containerNodeId).appendChild(this.domNode);
    }
  }
);
