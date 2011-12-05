/**
 * Enter Submit Widget
 * This widget provides the enter key form submission 
 * of a specific submit button in a form
 * Created by Jon Sykes, 9/7/10 
 *
 */
dojo.provide("atg.store.widget.enterSubmit");
dojo.require("dojo._base.event");

// dojo.require("dijit._Widget");

dojo.declare(
  "atg.store.widget.enterSubmit", 
  [dijit._Widget],
  {
    
    targetButton: "",
    
    startup: function(){
      dojo.connect(this.domNode, "onkeypress", this , "onEnterKey");
      console.debug("EnterSubmit, convert input field: ", this.domNode);
      console.debug("EnterSubmit, Input to trigger: ", dojo.byId(this.targetButton));
    },
    
    onEnterKey: function(evt){
      if(evt.charOrCode == dojo.keys.ENTER) {
        dojo.stopEvent(evt);
      dojo.byId(this.targetButton).click();
      }
    },    
    
    noCommaNeeded:""

})