/**
 * Rich Cart Widget
 * This widget provides the main rich cart functionality.
 * Created by Jim Barraud, 10/11/06 
 * Reworked by James Wiltshire, 01/17/2007
 *
 * Updated to Dojo 1.0
 */
dojo.provide("atg.store.widget.RichCartSummary");

// dojo.require("dojo.fx");
// dojo.require("dijit._Widget");
// dojo.require("dijit._Templated");
// dojo.require("dijit._Container");

//dojo.require("atg.store.widget.RichCartSummaryItem");

dojo.declare(
  "atg.store.widget.RichCartSummary", 
  [dijit._Widget, dijit._Templated, dijit._Container],
  {
    // Define all global variables for the widget.
    // templateString: dojo.cache("dijit", contextPath + "/javascript/widget/template/richCartSummary.html"),
    
    // dojo.uri.dojoUri(contextPath+"/javascript/widget/template/richCartSummary.html"),
    templateString: '<div id="${id}" class="${id}" dojoAttachPoint="csContainer" style="overflow:hidden;z-index:1;">  <div id="atg_store_richCartHeader">    <a href="javascript:void(0);" class="atg_store_csClose" dojoAttachPoint="csClose" dojoAttachEvent="onclick:hide">      <img width="12" height="11" src="/crsdocroot/images/storefront/btn_close.png" alt="Close"/>    </a>    <h3>${i18n.myCartSummary}</h3><span class="atg_store_richCartCount" dojoAttachPoint="csQuantity">??(10)??</span>  </div>        <ul id="atg_store_csContent" dojoAttachPoint="csContent,containerNode">    <li dojoAttachPoint="csEmptyMessage" class="atg_store_emptyRichCart"><span>${i18n.cartIsEmpty}</span></li>  </ul>    <div id="atg_store_csFooter">      <span class="summary"  dojoAttachPoint="csSubtotalContainer">        ${i18n.your} ${i18n.itemsSubtotal}${i18n.labelSeparator}      </span>      <span class="atg_store_csSubtotal atg_store_viewCartPrice" dojoAttachPoint="csSubtotal">      </span>  </div>    <a class="atg_store_richCartCart" dojoAttachPoint="csFullCheckout" href="${url.checkout}">    ${i18n.viewCart}  </a>      <a href="${url.checkout}" class="atg_store_basicButton atg_store_chevron" dojoAttachPoint="csCheckout">    <span>${i18n.checkout}</span>  </a>    </div>',
    // Widget properties
    triggerWidget: null,  // Reference to trigger widget
    data: null,           // Cart data - should be set with initial widget initialisation properties
    quantityNodeId: null, // DOM ID of the node to contain the cart quantity - i.e. "Show Cart (3)"
    hijackClassName: null,  // CSS class used to signify forms/anchors to hijack 
    highlightColor: null, // Color used to highlight newly added items
    firstPlacementDone: false,
    cartAnimationInProgress: false,
    duration:{
      // Durations in ms of animation elements
      highlight: 3000,
      scroll:500,
      wipe: 280,
      autoHide:5000
    },
    

    /**
     * Initialize the widget
     */
    afterStartup: function(){
      console.debug("Initializing RichCartSummary widget");
      // Load any initial data into the widget
      if (this.data!==null){
        this.setAllCartData(this.data);
      }     

      // Hook up event handling
      var _this=this;
      dojo.connect(window, "onresize", this, "placeCart");
      dojo.connect(window, "onscroll", this, "placeCart");
      dojo.connect(document.body, "onclick", function(evt){
        // If body is clicked and cart is showing, hide it. 
        var type=evt.target.nodeName;
        //Ignore clicks on links or submit buttons as they'll be perfoming an action themselves.
        //if (_this.isShowing && type!="A" && type!="INPUT" && type!="BUTTON"){
          _this.hide();
        //}
      });
      dojo.connect(this.domNode, "onclick", function(evt){
        // Prevent body from handling click within the cart
        evt.stopPropagation(); 
      });
      this.triggerWidget=dijit.byId("richCartTrigger");
      
      if (this.doHijack===true){
        this.hijackAllAddToCartNodes();
      }    
    },

    /*
     * Replace postCreate with startup. postCreate removed from dojo 0.9
     */
    startup: function(){
      console.debug("Startup RichCartSummary widget");
      var _this=this;
      dojo.addOnLoad(function(){
        // Prepare for first show animation - hide the element's domNode and call the
        // hide animation. Set a callback to change the visibility when hide is complete.
        _this.domNode.style.visibility="hidden";
        _this.attachToContainer();
        _this.hide(function(){
          _this.domNode.style.visibility="visible";
        });
      });
      
      this.afterStartup();
    },
    
    /**
     * Set the rich cart to display all of the passed in data. This function will be
     * called whenever the rich cart widget is initialised (i.e. on page load) and
     * also whenever an item has been added to the cart and a JSON XHR response
     * is received containing the new cart contents.
     */
    setAllCartData: function(pData){
      console.debug("Setting all cart data");
//      console.debug(pData);
      this.data=pData;
      this.clearCartItems();
      this.setCartSummaryData();
      if (pData.items){
        // Create CartSummaryItem widget for each line item and add to this parent widget
        for (var i=0; i<pData.items.length; i++){
          this.addCartItem(pData.items[i]);
        }
      }
    },
    
    /**
     * Set the summary data for the cart - this includes the subtotal and item quantity
     */
    setCartSummaryData: function(){      
      // Set the cart quantity total - this is the qty in the 'View Cart (3)' link
      var el;
      if (this.quantityNodeId!==null){
        el=dojo.byId(this.quantityNodeId);
        if (el){
          console.debug("Setting Quantity Value in Rich Cart to: ",this.data.itemsQuantity);
          el.innerHTML = dojo.string.substitute(this.i18n.itemCount, [this.data.itemsQuantity]);
        }
        el = this.csQuantity;
        if (el) {
          el.innerHTML = dojo.string.substitute(this.i18n.itemCount, [this.data.itemsQuantity]);
        }
      }
      
      if (this.data.itemCount===0){
        this.showEmptyCart(true);
      }
      else {
        this.showEmptyCart(false);
        // Set the subtotal amount in the cart
        this.csSubtotal.innerHTML = this.data.subtotal;
      }          
    },
    
    /**
     * Turn on/off certain elements of the cart if it is empty. Display a
     * 'cart is empty' message if it is
     */
    showEmptyCart: function(pEmpty){
      if (pEmpty===true){
        // Cart is empty
        dojo.style(this.csSubtotalContainer,'display','none');
        dojo.style(this.csCheckout,'display','none');
        dojo.style(this.csEmptyMessage,'display','');

      }
      else {
        // Cart is not empty
        dojo.style(this.csSubtotalContainer,'display','');
        dojo.style(this.csCheckout,'display','');
        dojo.style(this.csEmptyMessage,'display','none');
      }
    },
    
    /**
     * Add a line item to the rich cart
     */
    addCartItem: function(data){
      console.debug("Adding a Line Item");
      var lineItem = new atg.store.widget.RichCartSummaryItem( {
        data: data,
        highlightColor: this.highlightColor,
        highlightDuration: this.duration.highlight,
        scrollDuration: this.duration.scroll,
        i18n: this.i18n
      });
      lineItem.startup();
      this.csContent.appendChild(lineItem.domNode);
      this.addChild(lineItem);
    },
    
    /*
     * Clear all items from the cart
     */
    clearCartItems: function(){
      var children = this.getChildren();
      for (var i=0; i<children.length; i++){
        this.removeChild(children[i]);
        children[i].destroy();
      }
    },
        
    /**
     * Toggle display of the cart. This will be called by the CartTrigger widget whenever the
     * show/hide rich cart link is clicked.
     */
    toggleCart: function(){
      if (this.isShowing===true){
        this.hide();
      }
      else {
        this.show();
      }
    },
    
    /**
     * Position the cart at the correct location on screen
     */
    placeCart: function(){
      if (!this.isShowing && this.firstPlacementDone && !this.cartAnimationInProgress){
        return;
      }
      console.debug('placeCart call');
      this.firstPlacementDone=true;
      var node = this.triggerWidget.triggerLink;
      var pos = dojo._abs(node);
      var cartLeft,cartTop,triggerHeight,scrollOffsetHeight;

      // Left position is 228 pixels left of the trigger link
      cartLeft = pos.x - 138;
      cartLeft = (cartLeft > 0) ? cartLeft : 0;
      // Top position is directly under the trigger link
      triggerHeight = dojo._getMarginBox(node.parentNode).h;
      scrollOffsetHeight=dijit.getViewport().t;
      console.debug('scrollOffsetHeight' + scrollOffsetHeight);
      cartTop = pos.y;
      cartTop = (cartTop-scrollOffsetHeight > 0) ? cartTop : scrollOffsetHeight; 

      console.debug("Placing cart @ "+cartLeft+", "+cartTop);
          
      this.domNode.style.left=cartLeft+"px";
      this.domNode.style.top=cartTop+"px";
      this.domNode.style.zIndex="1000";

      
      // If we have a bgIframe for IE6, resize it so it's positioned directly under the cart
      if (this.bgIframe){
        this.bgIframe.size(this.domNode);
      }
    },

    /**
     * Show the Rich Cart
     */
    show: function(callback) {
      console.debug('show cart');
      if (this.isShowing){
        // If we've been passed a callback function, then call it even if we're showing. It's
        // most likely that a new item has been added, and the callback is the highlight
        if (callback){
          callback();
        }
        return;
      }
      
      if (this.cartAnimationInProgress===true){
        return;
      }
      this.cartAnimationInProgress=true;
      this.placeCart();
      var _this=this;

      console.debug('show:node: ' + this.domNode);
      console.debug('show:duration: ' + this.duration.wipe);

      var wipeAnimation=dojo.fx.wipeIn({
              node: this.domNode,
              duration: this.duration.wipe,
              onEnd: function() {
                _this.isShowing = true;
                _this.cartAnimationInProgress=false;

                // IE6 - prevent form elements from shining through cart with hidden bg iframe
                if(dojo.isIE){
                if(dojo.isIE < 6){
                  if(!_this.bgIframe){
                    _this.bgIframe = new dijit.BackgroundIframe();
                    _this.bgIframe.setZIndex(_this.domNode);
                  }
                  _this.bgIframe.size(_this.domNode);
                  _this.bgIframe.show();
                }
                }

                if (callback && dojo.isFunction(callback)){
                  callback();
                }
              }
      });

      console.debug("after wipe animation");

      var fadeAnimation=dojo.fadeIn({
        node: this.domNode,
        properties: {
        opacity: {
            start:0.3,
            end:0.1
        }},
        duration: this.duration.wipe}
        );
      dojo.fx.combine([wipeAnimation,fadeAnimation]).play();
      this.triggerWidget.updateTriggerDisplay();
    },

    /**
     * Hide the Rich Cart
     */
    hide: function(callback){
      if (this.cartAnimationInProgress===true){
        return;
      }

      this.cartAnimationInProgress=true;
      var _this=this;
      console.debug('hide:node: ' + this.domNode);
      console.debug('hide:duration: ' + this.duration.wipe);
      var wipeAnimation=dojo.fx.wipeOut({
              node: this.domNode,
              duration: this.duration.wipe,
              onEnd: function(){
                _this.isShowing = false;
                _this.cartAnimationInProgress=false;
                _this.triggerWidget.updateTriggerDisplay();
                

                // IE6 - Prevent form element shine through - hide hidden iframe
                if(_this.bgIframe){
                  _this.bgIframe.hide();
                  _this.bgIframe.size({left:0, top:0, width:0, height:0});
                }

                if (callback && dojo.isFunction(callback)){
                  callback();
                }
      }});

//      var fadeAnimation=dojo.fadeIn(this.domNode, { start:1, end: 0.8 }, this.duration.wipe);

      var fadeAnimation=dojo.fadeOut({node: this.domNode,
        properties: { 
        opacity: {
            start:1,
            end:0.8
        }},
                                           duration: this.duration.wipe}
      );
      dojo.fx.combine([wipeAnimation,fadeAnimation]).play();
      this.clearAutoHide();
    },
    
    /*
     * Get an array of all items that have been flagged as 'modified. This will
     * usually be just a single item - the item that has just been added to the cart.
     */
    getChangedItemWidgets: function(){
      var changedItems=[];
      var item;
      var children = this.getChildren();
      for (var i=0; i<this.data.items.length; i++){
        item=this.data.items[i];
        if (item.modified===true){
          // Get referene to child widget
          changedItems[changedItems.length] = children[i];
        }
      }
      return changedItems;
    },

    /**
     * Start the auto-hide timer. This will close the rich cart after a short period of
     * time, unless the use mouses over the cart display, in which case the timer
     * will be cancelled so the user can continue to view the contents
     */
    startAutoHide: function(){      
      // Clear any existing auto-hide timer
      if (this.autoHideTimer!==null){
        this.clearAutoHide();
      }
      
      console.debug("Starting auto-hide (in "+this.duration.autoHide+" ms)");
      var _this = this;
      // Auto-hide the rich cart after n ms...
      this.autoHideTimer = setTimeout(dojo.hitch(_this, "hide"), this.duration.autoHide);
      
      // ... unless the user mouses over the cart
      dojo.connect(this.domNode, "onmouseover", this, "clearAutoHide");
    },
      
    /**
     * Clear the auto-hide timer. This will stop the widget from auto-hiding. The user
     * must now click the 'hide rich cart' link/icon to hide the widget 
     */
    clearAutoHide: function(){
      console.debug("Clearing auto-hide");
      clearTimeout(this.autoHideTimer);
      dojo.disconnect(this.domNode, "onmouseover", this, "clearAutoHide");
      this.autoHideTimer=null;        
    },
    
    /**
     * Handle a JSON response following an 'add to cart' form submission
     */
    handleResponse: function(data,node){
      console.debug("RichCart:handleResponse");
      console.debug('RichCart:handleResponse:node ' + node);
      console.debug('RichCart:handleResponse:data ' + data);
      // If we got no data whatsoever, then treat this as a serious error
      if (!data){
        this.handleError();
        return;
      }
      
      // If we got an error back in the data then we need to update the UI to display the errors
      if (data.error){
        console.debug("Received error from server - resubmitting form");
        this.resubmitForm(node);
        return;
      }
      
      // All good, update the UI with new cart data
      this.setAllCartData(data);
      var alreadyShowing=this.isShowing;
      var changedItems=this.getChangedItemWidgets();

      // Show the cart and scroll the first newly added item into view
      var _this=this;
      this.show(function(){
        // Scroll the first newly added item into view
        if (changedItems.length>0){
          changedItems[0].scrollIntoView();
        }
        for (var i=0; i<changedItems.length; i++){
          changedItems[i].highlight();
        }
        _this.enableNode(node);
      });
           
      // Start the auto-hide timer if the cart wasn't already showing. This will also reset the timer
      // if it's already running
      if (!alreadyShowing || this.autoHideTimer!==null){
        this.startAutoHide();
      }
    },
    
    // reset the color size picker
    resetPicker: function(){

      dojo.query(".atg_store_quantity input[type='text']").forEach(
          function(inputElement) {
              console.debug("Resetting quantity field: ", inputElement);
              inputElement.value = "0";
         }
      );
      
    },
    
    /*
     * Connect the cart to all forms and links that have the specified className.
     * The class will be set on any <input type="submit"> and <a> tags that are submitted or clicked
     * to add items to the cart. All of these nodes must be 'hijacked' so that the
     * http request uses XHR so that the rich cart can operate.
     */
    hijackAllAddToCartNodes: function(){
      console.debug("Connecting RichCart to all elements with class ["+this.hijackClassName+"]");
      var _this = this;
      console.debug('class name: ' + this.hijackClassName);
      dojo.query("*."+this.hijackClassName).forEach(function(node) {
        _this.hijackNode(node);
      });
    },
    
    /*
     * Hijack a node. The node should be either a <form> or an <a> node.
     * Hookup the submit to use XHR instead of standard browser request, and 
     * process the returned JSON data with the handleRespones() function
     * 
     */
    hijackNode: function(node){
      console.debug("Hijacking node");
      console.debug(node);
      if (node.isHijacked){
        console.debug("Node is already hijacked - ignoring");
        return;
      }
      node.isHijacked=true;
           
      // Create object with common params for io.bind call
      var _this = this;
//      var _node = node;
      var bindParams={
        headers: { "Accept" : "application/json" },
//        mimetype: "application/json",
        handleAs: "json",
        load: function(data, ioArgs) {
          _this.handleResponse(data,node);
        },
        error: function(data, ioArgs) {
          _this.handleError(data, ioArgs);
        },
        timeout: function(data, ioArgs) {
          _this.handleError(data, ioArgs);
        }
      };
      
      
      if (node.nodeName=="INPUT"){
        dojo.connect(node, "onclick", function(evt){
          evt.cancelBubble=true;
          evt.preventDefault();
          // Get parent form node for this input node
          var formNode=_this.getParentNode(node, "form");
          console.debug('formNode: ' + formNode);
          // Create content object with the name/value pair of the submit button that's been clicked
          // dojo.io.bind doesn't send the value of submit buttons when serializing the form as it 
          // doesn't know which one has been clicked. Server side FormHandlers need this data to
          // invoke the correct formHandler method.
          var content={};
          content[node.name]=node.value;
          
          console.debug("Add to Cart form clicked - submitting form");
//          console.debug(formNode);

          // bug fixed: 154139
          // hide div with error messages
          var errDivs = dojo.query("#atg_store_formValidationError").concat(dojo.query(".atg_store_productDisplay_errorMsg"));

          if(errDivs) {
            console.debug("Hide error elements");
            for (var i = 0; errDivs.length > i; i++) {
              errDivs[i].style.display="none";
            }
          }



          // Add the form node and the submit button name/value to the io.bind params
          dojo._mixin(bindParams,{
            form: formNode,
            content: content
          });
          
          _this.disableNode(node);
          dojo.xhrPost(bindParams);
          return false;
        });
      }
      else if (node.nodeName=="A"){
        dojo.connect(node, "onclick", function(evt){
          console.debug("Add to Cart link clicked");
          evt.preventDefault();
          
          // Ensure it's not a double click
          if (node.currentlyAdding && node.currentlyAdding===true){
            console.debug("This link has already been clicked - ignoring");
            return;
          }
          
          // Add the URL of the clicked link to the io.bind params

          dojo._mixin(bindParams,{
            url: node.href
          });
         
          _this.disableNode(node);
          dojo.xhrGet(bindParams);
          
        });               
      }
      else{
        console.debug("Node is not a form submit or an anchor - ignoring");
      }     
    },
    
    /**
     * Attach this widget's domNode to its containing node
     */
    attachToContainer: function(){
      console.debug("Appending cart domNode to " + this.domNode);
      document.body.appendChild(this.domNode);
    },
    
    /**
     * Function that will be called whenever an error or timeout occurs with an io.bind call
     * Changes the page location to 'url.error'. This is usually set to the standard cart
     * page, so if anything goes wrong with the Rich Cart, we get to fall back to the standard cart.
     */
    handleError: function(data, ioArgs){
      console.debug("RichCartSummary:handleError");
      document.location=this.url.error;
    },
    
    /**
     * Disable a node whilst it is being added to the cart. Used to prevent double clicks resulting
     * in duplicate additions to the cart.
     */
     disableNode: function(node){

       if (node.nodeName=="INPUT"){

         // Store original properties we're about to mess with
         node.originalProps={};
         node.originalProps.width=node.style.width;
         node.originalProps.height=node.style.height;
         // Set values for width and height so element doesn't change size
         node.style.width=dojo._getBorderBox(node).w+"px";

         node.originalProps.value=node.value;
         node.disabled=true;
         node.value=this.i18n.addingToCart;

       }

       else if (node.nodeName=="A"){

         //Edited In Order To Preserve Width During Dynamic InnerHTML Change
         
         // Acquire child span of A
         if (navigator.userAgent.indexOf('MSIE') !=-1){
         var childspan = node.childNodes[0];
         }else{
         var childspan = node.childNodes[1];
         }

         // Store original properties we're about to mess with   
         node.originalProps={};
         node.originalProps.width=childspan.style.width;
         node.originalProps.height=childspan.style.height;
         
         // Get The "span" padding-left
         basepadding = dojo.style(childspan, "paddingLeft");

         // Get the "span" offsetWidth , and subtract the left padding from it.
         basewidth = childspan.offsetWidth - basepadding;

         // Set a fixed width on the "span" element
         childspan.style.width=basewidth+"px";

         // Set values for width and height so element doesn't change size
         node.originalProps.innerHTML=childspan.innerHTML;
         node.currentlyAdding=true;
         childspan.innerHTML=this.i18n.addingToCart;

       }
     },

     /**
      * Re-enable a node that has been disabled by disableNode();
      */
     enableNode: function(node){     
        
       if (node.nodeName=="INPUT"){

         node.disabled=false;
         node.value=node.originalProps.value;

         // Reset size attributes
         node.style.width=node.originalProps.width;
         node.style.height=node.originalProps.height;
         node.originalProps=null;

       }
       else if (node.nodeName=="A"){

         //Acquire child span of A
         if (navigator.userAgent.indexOf('MSIE') !=-1)
          {
          var childspan = node.childNodes[0];
          }
          else {
          var childspan = node.childNodes[1];
          }

         node.currentlyAdding=false;
         childspan.innerHTML=node.originalProps.innerHTML;   

         // Reset size attributes
         childspan.style.width=node.originalProps.width;
         childspan.style.height=node.originalProps.height;
         node.originalProps=null;

       }


     },

    
    /**
     * Resubmit the AddToCart form using a normal HTTP request (non XHR).
     * The Submit button's node should be passed in to signify which button was clicked.
     */
    resubmitForm: function(node){
      // Create hidden form element to copy submit button's value into. Need to do this as disabled elements
      // are not submitted from a form by the browser.
      console.debug("RichCartSummary:resubmit from");
      var replacementNode=document.createElement("input");
      replacementNode.type="hidden";
      replacementNode.name=node.name;
      replacementNode.value=node.value;
      
      // Append this to the parent form
      var formNode=this.getParentNode(node, "FORM");
      formNode.appendChild(replacementNode);
      
      formNode.submit();
    },

    getParentNode: function(/* HTMLElement */node, /* string */type) {
      //  summary
      //  Returns the first ancestor of node with tagName type.
      var _document = dojo.doc;
      var parent = dojo.byId(node);
      type = type.toLowerCase();

      while((parent)&&(parent.nodeName.toLowerCase()!=type)){
        if(parent==(_document["body"]||_document["documentElement"])){
          return null;
        }
        parent = parent.parentNode;
      }
      return parent;  //  HTMLElement
    }
  }
);

