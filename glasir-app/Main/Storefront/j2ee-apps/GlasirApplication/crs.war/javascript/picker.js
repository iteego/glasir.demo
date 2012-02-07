/**
 * Color/Size picker implementation.
 * Dojo version: 1.0
 */

dojo.provide("atg.store.picker");
dojo.require("dojo.parser");

atg.store.picker={ 

/**
 * Adds the item to Cart 
 */
  addtoCart : function (){
    
    if (!this.checkAddtoCartAvailable()){
      // if product's color/size is not selected do nothing
      // just show corresponding message
      dojo.byId('promptSelectDIV').style.display='block';
      dojo.byId('promptSelectDIV2').style.display='none';
      dojo.byId('promptSelectDIV3').style.display='none';
      return;
    }
    //post addToCart form to richCart widget
    dijit.byId("atg_store_richCart").postForm("addToCart");
    
  },

/**
 * Check the status of addToCart form
 *
 * @return  true: if item can be added to the cart
 *     false: if not
 */
  checkAddtoCartAvailable: function(){ 
    var addtocartform = dojo.byId("addToCart");
    var selectedSku =  addtocartform.elements["/atg/store/order/purchase/CartFormHandler.items[0].catalogRefId"].value;    
   
    if( !selectedSku){  
      return false;
      console.debug("checkAddtoCartAvailable: SKU not available");
    }

    return true;
  },
  
/**
 * Called when a user clicks on a color, it changes selected color
 * to the passed one
 * @param color: which color is selected
 */
  clickColor: function(color){
    console.debug('selected color is ' + color);
    var formId = "colorsizerefreshform";
    var form = dojo.byId(formId);
    var currentColor = form.elements.selectedColor.value;

    //if the color is not changing, don't do anything
    if(currentColor == color){
      return;
    }

    //set the new selected color in the refresh form and submit it
    form.elements.selectedColor.value = color;
    var picker=atg.store.picker;
    picker.setQuantity(formId);
    picker.setGiftlistId(formId);
    picker.submitRefreshForm(formId);  
  },  


/**
 * Called when a user clicks on a size, it changes selected size 
 * in the refresh form to the passed one
 * @param size: which size is selected
 */
  clickSize: function(size){
    console.debug('selected size is ' + size);
    var formId = "colorsizerefreshform";
    var form = dojo.byId(formId);

    //if the user clicks the size that's already selected, don't do anything
    var currentSize = form.elements.selectedSize.value;
    if(currentSize === size){
      return;
    }

    //set the new selected size in the refresh form and submit it
    form.elements.selectedSize.value = size;
    var picker=atg.store.picker;
    picker.setQuantity(formId);
    picker.setGiftlistId(formId);
    picker.submitRefreshForm(formId);       
  },

/**
 * Called when a user clicks on a wood finish, it changes selected wood finish
 * to the passed one
 * @param color: which wood finish is selected
 */
  clickWoodFinish: function(woodFinish){
    console.debug('selected wood finish is ' + woodFinish);
    var formId = "woodfinishrefreshform";
    var form = dojo.byId(formId);
    var currentWoodFinish = form.elements.selectedWoodFinish.value;

    //if the wood finish is not changing, don't do anything
    if(currentWoodFinish == woodFinish){
      return;
    }

    //set the new selected wood finish in the refresh form and submit it
    form.elements.selectedWoodFinish.value = woodFinish;
    var picker=atg.store.picker;
    picker.setQuantity(formId);
    picker.setGiftlistId(formId);
    picker.submitRefreshForm(formId);  
  },
/**
 * Gets the quantity from the addToCart form and sets the refresh form quantity.
 * We do this so we can preserve the quantity between refreshes.
 */
  setQuantity: function(formId)
  {
    var currentQuantity = dojo.query(".atg_store_numericInput")[0].value;
    var refreshform = dojo.byId(formId);
    refreshform.elements.savedquantity.value = currentQuantity;
  },
  
 
/**
 * Gets the gift list id from the addToGiftList form and sets the refreshform savedgiftlist
 * parameter.
 * We do this so we can preserve the gift list selection between refreshes
 */
  setGiftlistId: function(formId) {
    var addToGiftListForm = dojo.byId("addToGiftList");
    if(!addToGiftListForm){
      return;  
    }
    
    var currentGiftList = addToGiftListForm.elements["/atg/commerce/gifts/GiftlistFormHandler.giftlistId"].value;
    var refreshform = dojo.byId(formId);
    refreshform.elements.savedgiftlist.value = currentGiftList; 
  },
  
   
/**
 * Resets the color and size selected and submits the refresh form
 */
  resetPicker: function(formId){
    var form = dojo.byId(formId);
    //reset the new selected size and color in the refresh form and submit it
    form.elements.selectedSize.value = "";
    form.elements.selectedColor.value = "";

    var picker=atg.store.picker;
    picker.setQuantity(formId);
    picker.setGiftlistId(formId);
    picker.submitRefreshForm(formId);  
  },

/**
 * Submits the refresh form. 
 */  
  submitRefreshForm: function(formId){

    dojo.xhrGet({
    
      //url: "http://localhost:8080/store/browse/gadgets/pickerContents.jsp",
      load: function(data){
        var divColorPicker = dojo.byId("picker_contents");
        //data = data.replace(/<form\s*[^>]*>|<\/form>/g,"");
        divColorPicker.innerHTML = data;
        var richCartWidget = dijit.byId('atg_store_richCart'); 
        if (richCartWidget.doHijack) {
          richCartWidget.hijackAllAddToCartNodes();
          var targetNode = dojo.query(".atg_store_numericInput")[0];
          atg.store.util.addNumericValidation(targetNode);
        }
        // just check that we don't need any popuplaunchers on the new code
        atg.store.util.setUpPopupEnhance();
        dojo.parser.parse(divColorPicker);
        dojo.query("*", divColorPicker).forEach(
          function(formElement){
            dojo.connect(formElement, "onkeypress", atg.store.util, "killEnter");  
            });
      },
      form:  formId
    });
    
  },
  
/**
 * Submits the addToFavorites form. 
 */  
  submitAddToFavoritesForm : function(){


    if(!this.checkGiftListSubmitAvailable("addToFavorites", "/atg/commerce/gifts/GiftlistFormHandler.catalogRefIds")){
     // display message that user should select product's color 
     // and size before adding it to favorites list
     dojo.byId('promptSelectDIV2').style.display='block';
     dojo.byId('promptSelectDIV').style.display='none';
     dojo.byId('promptSelectDIV3').style.display='none';
     
     // close the popup
     dojo.byId("atg_picker_moreActionsButton").className = "more";
     
     return;
    }
    //console.debug(dojo.byId("atg_store_addToFavorites"));
    //alert(dojo.byId("addToFavorites").nodeName);
    dojo.byId("atg_store_addToFavorites").click();
    // Nasty work around for an IE6 form submission bug that sometimes it just won't go the first time round.
    if(dojo.isIE && dojo.isIE < 7){
        setTimeout("atg.store.picker.submitAddToFavoritesForm()", 500);
    }
    
  },

/**
 * Submits the addToGiftList form. 
 */   
  submitGiftListForm : function(giftList){

    if(!this.checkGiftListSubmitAvailable("addToGiftList", 
                                           "/atg/commerce/gifts/GiftlistFormHandler.catalogRefIds")){
     // display message that user should select product's color 
     // and size before adding it to gift list
     dojo.byId('promptSelectDIV3').style.display='block';
     dojo.byId('promptSelectDIV').style.display='none';
     dojo.byId('promptSelectDIV2').style.display='none';
     
     
     return;
    }
    
    // set form's giftListId to the one that is clicked by user
    this.setGiftlistIdOnGiftListForm(giftList);
    // set quantity on gift list form
    this.setQuantityOnGiftlistForm();
    // submit form
    dojo.byId("atg_store_addToGiftSubmit").click();
  }, 
  
 
/**
 * Checks if  addToGiftList or addToFavorites form is ready for submit
 * @param giftListForm: form id
 * @param giftListRefIdElement: id of form's element that contains  SKU id 
 *                              that is going to be added    
 * @return true: if can be submitted
 *          false: if not 
 */
  checkGiftListSubmitAvailable : function(giftListForm, giftListRefIdElement ){
    var selectedSku = dojo.byId(giftListForm).elements[giftListRefIdElement].value;
    if(!selectedSku){
      return false;
    }    
    return true;
  },
  
 /**
  * Used to set quantity of items to add to gift list. Quantity value is taken
  * from addToCart form.
  */
  setQuantityOnGiftlistForm: function() {
    // get quantity from addToCart form
    var currentQuantity = dojo.byId("atg_store_quantityField").value;
    var addtogiftlistform = dojo.byId("addToGiftList");
    //set the quantity in the add to gift list form
    addtogiftlistform.elements.giftListAddQuantity.value = currentQuantity;
  },
  
/**
 * Used to set giftListId selected by user in addToGiftList from.
 */
  setGiftlistIdOnGiftListForm: function(giftListId) {
    var addToGiftListForm = dojo.byId("addToGiftList");
    if(!addToGiftListForm){
      return;  
    }
    
    addToGiftListForm.elements["/atg/commerce/gifts/GiftlistFormHandler.giftlistId"].value = giftListId;   
  }    
};