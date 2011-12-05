/**
 * Rich Cart Item Widget
 * Represents a single item in the cart.
 */
dojo.provide("atg.store.widget.RichCartSummaryItem");

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");

dojo.declare(
  "atg.store.widget.RichCartSummaryItem", 
  [dijit._Widget, dijit._Templated], {

    // templateString: dojo.cache("dijit", contextPath + "/javascript/widget/template/richCartSummaryItem.html"),
    
    templateString: '<li>  <a href="${data.url}" dojoAttachPoint="imageLink" title="${data.name}" class="atg_store_richCartImage"><img src="${data.imageUrl}" alt="${data.name}"/></a>  <div class="atg_store_richCartItem">    <a href="${data.url}" dojoAttachPoint="titleLink" class="atg_store_richCartItemDescription"><p class="itemName">${data.name}</p>      <ul dojoAttachPoint="pricesContainer"></ul>      <span class="atg_store_availability" dojoAttachPoint="availabilityContainer" style="display:none;"></span>      <dl dojoAttachPoint="propertiesContainer"></dl>    </a>    <a href="${data.url}" class="atg_store_siteName" dojoAttachPoint="siteContainer" style="display:none;"></a>  </div></li>',

    // Define all global variables for the widget.
    data: null,           // Data object for this widget. Will be passed in during widget initialisation

    // Called after creation - setup any extra display elements of the widget
    startup: function() {
      
     // Create dt/dd pair for each detailed item's quantity and price entry and append to prices container
      for (var i=0; i<this.data.prices.length; i++){
        var prop=this.data.prices[i];
        var li=document.createElement('li');
        li.innerHTML=prop.quantity + ' '+ this.i18n.priceSeparator + ' '+ '<span>' + prop.price + '</span>';
        this.pricesContainer.appendChild(li);
      }

      // Create dt/dd pair for each extra item property and append to properties container
      for (var i=0; i<this.data.properties.length; i++){
        var prop=this.data.properties[i];
        var dt=document.createElement('dt');
        var dd=document.createElement('dd');
        dt.innerHTML=prop.name + this.i18n.labelSeparator;
        dd.innerHTML=prop.value;
        this.propertiesContainer.appendChild(dt);
        this.propertiesContainer.appendChild(dd);
      }

      // Show/hide availability message depending on whether it was set
      if (this.data.availability){
        this.availabilityContainer.innerHTML=this.data.availability;
      }
      else{
//        dojo.html.hide(this.availabilityContainer);
        dojo.style(this.availabilityContainer,'display','none');
      }
      
      // Show/hide off site name depending on whether it was set
      if (this.data.siteName) {
        this.siteContainer.innerHTML=this.data.siteName;    	  
        dojo.style(this.siteContainer,'display','');
      }

      // Remove image/title links if linkItem=false
      if (!this.data.linkItem){
        // Just replace the <a> tags with their contents.
        this.imageLink.parentNode.replaceChild(this.imageLink.firstChild, this.imageLink);
        this.titleLink.parentNode.replaceChild(this.titleLink.firstChild, this.titleLink);
      }

    },

    /**
     * Highlight the item
     */
    highlight: function(){
      // var anim = dojo.animateProperty({
      //         node: this.domNode,
      //         duration: this.highlightDuration,
      //         properties: {
      //           backgroundColor: { end: this.highlightColor }
      //         }
      //       });
      //       anim.play();
    },

    /**
     * Scroll this item into view within the rich cart. This function calculates the scroll position
     * so that the node is positioned as close to the center of the cart as possible.
     * If the item is at the start or end of the list, then it will scroll to the top or bottom
     * of the lists, otherwise it attempts to get as close to center as possible
     */
    scrollIntoView: function(){
      var node=this.domNode;
      var parent = node.parentNode; // cart.csContent (element with scroll bars)
      var cart=parent.parentNode;   // cart.domNode

      // Get absolute positions of cart and this item node - calculate absolute centers
      var cartHeight = dojo._getContentBox(cart).h;
      var absCartCenter=dojo._abs(cart).y+Math.ceil(cartHeight/2);
      var nodeHeight = dojo._getContentBox(node).h;
      var absNodeCenter = dojo._abs(node).y+Math.ceil(nodeHeight/2);

      // How much do we need to change the scroll by to get the node into the center?
      var desiredScrollChange=absNodeCenter-absCartCenter;

      // Calculate the desired scrollTop value, taking into account min and max values
      var minScrollTop=0;
      var maxScrollTop=parent.scrollHeight-dojo._getContentBox(parent).h;
      var desiredScrollTop=parent.scrollTop;
      desiredScrollTop+=desiredScrollChange;
      desiredScrollTop = (desiredScrollTop < minScrollTop) ? minScrollTop:desiredScrollTop;
      desiredScrollTop = (desiredScrollTop > maxScrollTop) ? maxScrollTop:desiredScrollTop;

      // Scroll to the new position
      var anim=this.smoothScroll(parent,parent.scrollTop,desiredScrollTop,this.scrollDuration);
      anim.play();
      //dojo.debug("absCartCenter:"+absCartCenter+" absNodeCenter:"+absNodeCenter);
      //dojo.debug("desiredScrollChange: "+desiredScrollChange+" desiredScrollTop: "+desiredScrollTop+" currentScrollTop:"+parent.scrollTop);
    },

    /**
     * Returns an animation object that will perform a smooth scroll to a position
     */
    smoothScroll: function(nodeToScroll,currentScrollTop,desiredScrollTop,duration){

      var anim = new dojo._Animation({
        beforeBegin: function(){
          delete this.curve;
          anim.curve = new dojo._Line(currentScrollTop,desiredScrollTop);
        },
        onAnimate: function(value){
          nodeToScroll.scrollTop=value;
        },
        duration: duration
      }
      );

      return anim; // dojo.lfx.Animation
    }
  }
);
