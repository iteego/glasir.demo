/**
 * This file contains Javascript utility functions used throughout the store application.
 */

dojo.provide("atg.store.util");
dojo.require("dojo._base.event");

atg.store.util={

  searchReady: false,


  searchFieldBehaviors: function(inputNode, buttonNode){
    // set the default on page load value
    inputNode.inputValue = inputNode.value;
    dojo.connect(inputNode, 'onfocus',
      function(evt){
       evt.target.value = (evt.target.value == evt.target.inputValue)? "" : evt.target.value;
       atg.store.util.searchReady = true;
       dojo.disconnect(preventSubmit);
      });
      
    var preventSubmit = dojo.connect(buttonNode, 'onclick',
      function(evt){
        if(!atg.store.util.searchReady) evt.preventDefault();
      });    
    
    
  },
  

  richButtons: function(spanClass){

    dojo.query('span.'+spanClass).forEach(function(spanButton){
      
      dojo.connect(spanButton, 'onclick',
        function(evt){
          console.debug("EVT: ",evt.target);
          if(evt.target.nodeName == "SPAN"){
            dojo.query("input[type=submit]", evt.target)[0].click();
            dojo.stopEvent(evt);
            evt.cancelBubble=true;
            evt.preventDefault();
          }
        });
        
      });

  },


  // Function to highlight a selected area 
  // based on a radio selection in the scroll address UI gadget
  // Node ID is parent DIV ID, behavior will be applied to all child radio buttons
  initAddressHighlighter: function(nodeID){
    // find the parent node for the address picker
    var addressGroup = dojo.query("#atg_store_savedAddresses")[0];
    // do we have this node, don't apply the behavior
    if(addressGroup){
      // find all the input buttons that happen to have the name address and loop
      console.debug(dojo.query("input[name=address]", addressGroup));
      dojo.query("input[name=address]", addressGroup).forEach(
        // for each elements
        function(radioTag){
          // apply an onlick behavior that runs the which is selected now function
          dojo.connect(radioTag, "onchange", atg.store.util.parseRadioButtons);
        }
      );
      // see which button is pressed now to init the UI
      atg.store.util.parseRadioButtons();
    }
  },
  
  parseRadioButtons: function(){
    // find the parent node for the address picker
    var addressGroup = dojo.query("#atg_store_savedAddresses")[0];
    // find all the input buttons that happen to have the name address and loop
    dojo.query("input[name=address]", addressGroup).forEach(
      // for each element
      function(radioTag){
        // remove the selected state to get a clean slate
        dojo.removeClass(radioTag.parentNode.parentNode.parentNode, "selected"); 
        // if this radio is currently checked
        if(radioTag.checked == true){
          // add the selected classname
          dojo.addClass(radioTag.parentNode.parentNode.parentNode, "selected"); 
        }
      }
    );
  },

  openwindow:function(url,name,iWidth,iHeight) {
  var url;
  var name;
  var iWidth;
  var iHeight;
  var iTop = (window.screen.availHeight-30-iHeight)/2;
  var iLeft = (window.screen.availWidth-10-iWidth)/2;
  var param = 'height='+iHeight+',,innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=yes,resizeable=no,location=no,status=no';
  window.open(url,name,param);
 },

  /** 
   * Used on the cart page to autoselect the giftnote when 
   * a user selects the gift wrap option
   */
  autoSelectGiftNote: function() {    
    if (document.cartform.atg_store_addWrap.checked &&
        !document.cartform.atg_store_addNote.checked) {       
      document.cartform.atg_store_addNote.click();
    }  
  },
  
  /**
   * The email campaign popup.  First check the form fields to 
   * make sure we can submit.
   */ 
  emailSignup: function(URL, theForm) {  
    // need to make sure the required fields are not null
    var openWindow = true;
    
    // check to see if we have an email address at all
    var addressEntered = theForm.atg_store_signUpInput.value;
    if (dojo.trim(addressEntered) === "") {
      openWindow = false;
    }
    
    //if email id is not valid don't open the window
    if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(addressEntered))){
      openWindow = false;
    }
  
    // don't open window if we had a form error
    if (openWindow) {
      document.open(URL,"","scrollbars=yes,toolbar=no,directories=no,menubar=no,resizable=yes,status=yes,width=480,height=500");
    }
  },

  /**
   * Popup Window Handler
   */  

   setUpPopupEnhance: function() {
     
     var popup = function(obj){  
         dojo.stopEvent(obj.evt);
         document.open(obj.evt.currentTarget,"","scrollbars=yes,toolbar=no,directories=no,menubar=no,resizable=yes,status=yes,width="+obj.width+",height="+obj.height);
         return false;
      };
      
     dojo.query("[target=popup]").forEach(
       function(item, index, array){
         console.debug("Adding Popup Trigger Behavior to: ", item);
         dojo.connect(item, 'onclick', null, function(evt){
              popup({evt:evt, height: 500, width: 565 });
            });
          }
     ); 
     
      dojo.query("[target=popupLarge]").forEach(
         function(itemLarge, index, array){
           console.debug("Adding Popup Trigger Behavior to: ", itemLarge);
           dojo.connect(itemLarge, 'onclick', null, function(evt){
               popup({evt:evt, height: 650, width: 565 });
            });
          }
       );
   },
   /**
    * Add return key disabling to all input fields
    */
    
addReturnHandling: function(){
 
  dojo.query('form').forEach(
      function(formNode){
        if(dojo.indexOf(formIdArray, formNode.id)<0){
        dojo.query("*", formNode).forEach(
          function(formElement){
            dojo.connect(formElement, "onkeypress", atg.store.util, "killEnter");
            });
            }
            });
  
  
  /*dojo.query("input[type=text], input[type=submit], input[type=radio], input[type=checkbox], input[type=password], button, select").forEach(
     function(item, index, array){
       console.debug("Adding Enter Disabling Behavior to: ", item);
       dojo.connect(item, "onkeypress", atg.store.util, "killEnter");
     }
   );*/

},   

  /**
   * Return false if the key pressed in the event object is the return key, true otherwise
   */ 
killEnter: function(evt) {
  if(evt.charOrCode == dojo.keys.ENTER) {
    console.debug(evt.target.type);
    if(evt.target.tagName!='TEXTAREA' && evt.target.tagName!='A' && evt.target.type!='submit' && evt.target.type!='reset'){
     evt.preventDefault();
      return false;
      }
  }
  return true;
},

  /**
   * Add numeric validation on keydown to input with the classname "atg_store_numericInput" and id "atg_store_quantityField""
   */

addNumericValidation: function(node){
  
  if(!node){
  dojo.query(".atg_store_numericInput").forEach(
     function(item, index, array){
       console.debug("Adding Numeric Validation Behavior to: ", item);
       dojo.connect(item, "onkeydown", atg.store.util, "isNumeric");
       dojo.connect(item, "onchange", atg.store.util, "checkNumericPaste");
     }
   );
   }
  else {
    dojo.connect(node, "onkeydown", atg.store.util, "isNumeric");
    dojo.connect(node, "onchange", atg.store.util, "checkNumericPaste");
   }

},

  /**
   * Return true if the key pressed in the event object is numeric or a cursor control key
   * such as backspace, cursor left/right etc.; false otherwise
   */

isNumeric: function(evt){
    
  var theEvent = evt || window.event;
  var key = theEvent.keyCode || theEvent.which;
  keystring = String.fromCharCode( key );

  if(evt.altKey || evt.ctrlKey || evt.shiftKey){
      dojo.stopEvent(evt);
  }    
  else {
      if( !(key == dojo.keys.NUMPAD_0 || key == dojo.keys.NUMPAD_1 || key == dojo.keys.NUMPAD_2 || key == dojo.keys.NUMPAD_3 || 
        key == dojo.keys.NUMPAD_4 || key == dojo.keys.NUMPAD_5 || key == dojo.keys.NUMPAD_6 || key == dojo.keys.NUMPAD_7 ||
        key == dojo.keys.NUMPAD_8 || key == dojo.keys.NUMPAD_9 || key == dojo.keys.BACKSPACE || key == dojo.keys.ENTER ||
        key == dojo.keys.ESCAPE || key == dojo.keys.END || key == dojo.keys.HOME ||  key == dojo.keys.DELETE ||
        key == dojo.keys.LEFT_ARROW || key == dojo.keys.RIGHT_ARROW || key == dojo.keys.UP_ARROW || key == dojo.keys.DOWN_ARROW) )
        {
          if(isNaN(keystring)){
            dojo.stopEvent(evt);
           }
        }
    }
},

checkNumericPaste: function(evt){
if(isNaN(evt.target.value) ) {
evt.target.value=""; 
}
},

  /**
   * Update facet trail value
   */
  updateFacetTrail: function(xkeyword){
    var trltxt = dojo.string.trim(document.facetSearch.trailtext.value);
    if(trltxt === "" || trltxt === dojo.string.trim(xkeyword)){
      document.facetSearch.addFacet.value="";
      document.facetSearch.trailtext.value="";
    }
    else{
      document.facetSearch.addFacet.value="SRCH:"+trltxt;
    }
    return true;
  }, 
   
  /**
   * Display block if none 
   */
  toggleOptions: function(divName){
	console.debug("toggleOptions ("+divName+") is called");
	var children = document.getElementById(divName).getElementsByTagName('li');
	console.debug(children.length+ " childrens are found");
	for(var i=0; i<children.length; i++){
	  var displayStyle = children[i].style.display;
	  if (displayStyle == "block"){
		children[i].style.display = "none";
	  }
	  if (displayStyle == "none"){
		children[i].style.display = "block";
	  }
	}
  },
  
   /**
   * Caller function for toggleDIv and compressDiv
   */
  toggleBothDiv: function(idx, totalFacet,optionType){
    
  var animation;
  if(optionType==1){
     atg.store.util.toggleOptions(idx);
     // animation = dojo.fx.wipeIn({node: "lessDiv" + idx, duration: 500});
     //      animation.play();
  }else if(optionType==2){
     // animation = dojo.fx.wipeOut({node: "lessDiv" + idx, duration: 500});
     // animation.play();
     atg.store.util.toggleOptions(idx);         
  }
  },

addTextAreaCounter: function(){

    dojo.query(".textAreaCount").forEach(
       function(item, index, array){
         console.debug("Adding Textarea Counting Behavior to: ", item);
         atg.store.util.textAreaCounter(item);
         dojo.connect(item, "oninput", atg.store.util, "textAreaCounter");
         dojo.connect(item, "onpropertychange", atg.store.util, "textAreaCounter");
       }
     );

},

  /**
   * Text Area character counter
   */
  textAreaCounter: function(evt) {
  var targetNode = "";
    if(evt.type != 'textarea') {
      targetNode=evt.target;
    }
    else {
      targetNode=evt;  
    }
    var maxLimit = dojo.attr(targetNode, "maxlength");
    if(targetNode.value.length > maxLimit) {
      targetNode.value = targetNode.value.substring(0, maxLimit);
    }
    var countSpan=dojo.query("em", targetNode.parentNode)[0];
    countSpan.innerHTML = targetNode.value.length;
  },
  
  /**
   * Disable nodes that have atg_behavior_disableOnClick CSS class applied to them when they are clicked.
   * 
   * Expects the following attributes passed in on the params object
   *   cssClass: CSS class denoting the behavior
   *   defaultDisabledValue: Text value that will be set on the node when clicked and disabled
   *   freezeWidth: boolean signifying whether the width of the nodes should be retained
   * 
   * Any node that the behavior is attached to will be disabled whenever a click event is intercepted. This
   * should help prevent any double submit errors on the server.
   * 
   * A 'disabledValue' attribute may be set on the node itself. This value will override any default 
   * value that is set on this function.
   */
  applyDisableOnClickBehavior: function(params){    
    var elements=dojo.query(params.cssClass);
    console.debug("Applying DisableOnClick behavior to "+elements.length+" nodes with class ["+params.cssClass+"]");
    
    for (var i=0; i<elements.length; i++){
      var node=elements[i];
      console.debug(node);
      
      dojo.event.connect(node,"onclick",function(evt){  
        var node=evt.target;
        if (node.justClicked){
          console.debug("Ignoring click");
          // Node has already been clicked and is being handled, so ignore this click
          evt.preventDefault();
          evt.stopPropagation();
          return false;
        }
        
        console.debug("Disabling node before form submission");
        console.debug(node);
        
        // retain original node width - prevents node from resizing when disabled value text is set on it
        if (params.freezeWidth){
          node.style.width=dojo.html.getBorderBox(node).width+"px";
        }
        
        // Get disabled text from node if set, otherwise use default passed to this function. If default not
        // set, just use the existing value on the button.
        var disabledValue=node.getAttribute("disabledValue");
        var originalValue=(node.nodeName=="INPUT" ? node.value : node.innerHTML);
        if (!disabledValue) { 
          disabledValue=(params.defaultDisabledValue ? params.defaultDisabledValue : originalValue);
        }
        
        if (node.nodeName=="INPUT"){
          // Create hidden form element to copy submit button's value into. Need to do this as disabled elements
          // are not submitted from a form by the browser.
          var replacementNode=document.createElement("INPUT");
          replacementNode.type="hidden";
          replacementNode.name=node.name;
          replacementNode.value=node.value;
          
          // Append this to the parent form
          var formNode=dojo.html.getParentByType(node,"FORM");
          formNode.appendChild(replacementNode);
          
          // Disable the node
          node.value=disabledValue;
          node.name="";
          node.disabled=true;
          
          // Disabling the submit button prevents the form from being submitted in IE, so submit it here
          evt.preventDefault();
          formNode.submit();        
        } 
        else if (node.nodeName=="A"){
          node.innerHTML=disabledValue;
          node.justClicked=true; // Prevent further clicks from causing default behavior
        }
        
        // Continue with normal browser processing of click event
        return true;
      });
    }
  },
  noenter: function() {
    return !(window.event && window.event.keyCode == 13); 
  }
};