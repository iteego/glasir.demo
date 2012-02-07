/**
 * This file contains Javascript utility functions used for accordion menu operation.
 * All the operation start from function doFacetLoad.
 * Oraginally there are only facets category on the page. Once the user click a facet option under the category, we will replace the 
 * whole category div with the server returning facets data 
  
  Price:
    * 0.00-50.00 (10)
    * 50.00-100.00 (3)
    * 100.00-150.00 (1)
  Color:
    * Black (3)
    * Blue (6)
    * Brown (3)
    * Green (4)
 Feature:
    * Cotton (4)
    * Eco-Friendly (2)
    * Organic (2)
    * Wool (1)
    
    For example, the above is original content of the facet pannel when user visit category page.
      two actions fired when user click 0.00-50.00 (10).
      one is call facetClickAction function to generate  accordion menu.the below is content of facet pannel.
      two is call atg.store.facet.loadData function to generate product list.
 
 Price:
    * 0.00-50.00 
 Color
    * Black (2)
    * Blue (4)
    * Brown (2)
    * Green (2)
    * Grey (1)
 Feature
    * Cotton (4)
    * Eco-Friendly (1)
    * Organic (2)

 */

var wipeOut;
var facetSearchUpdate = "";
var strFacetSource;
var nRedirect = 0;
var currentAnimation;
var okAnimation = 0;
var status = 0;
var hash;
var customEventListenerHandler;
var isHashBeingUpdated = false;
var catNavNotSupported = false;

function setRedirect(nInt) {
  nRedirect = nInt;
}

function getRedirect() {
  return nRedirect;
}

function setFacetTarget(strDivId) {
  facetSearchUpdate = dojo.byId(strDivId);
}

function getFacetTarget() {
  return facetSearchUpdate;
}

function setFacetSource(strPage) {
  strFacetSource = strPage;
}

function getFacetSource() {
  return strFacetSource;
}

function getCategoryHolder() {
  return dojo.byId("facetOptions");
}

function cleanDiv(tarDiv) {
  // clean out divs
  for (i = tarDiv.childNodes.length - 1; i >= 0; i--) {
    tarDiv.removeChild(tarDiv.childNodes[i]);
  }

  tarDiv.innerHTML = "";
}

function buildFacets(objFacetList) {
  // the container div for facet pannel
  var facetOptionsDiv = dojo.byId("facetOptions");
  var id;
  var isNew;

  for (j = 0; j < objFacetList.length; j++) {
    id = objFacetList[j].id;
    var divId = "facetoptions_" + id;
    // find the div container for current facet refineElement   ( facet category)
    var facetSingleOptionDiv = dojo.byId(divId);

    if (facetSingleOptionDiv) {// if this facet category i.e price, color... is already existed in this page then clean its ontent.
      cleanDiv(facetSingleOptionDiv);
      isNew = false;
    } else { // this is a new facet category , create a new div for it. 
      facetSingleOptionDiv = document.createElement("div");
      facetSingleOptionDiv.id = divId;
      isNew = true;
    }

    buildFacetOption(objFacetList[j], facetSingleOptionDiv, objFacetList.length == 1 && location.href.indexOf('subcategory.jsp') > -1);
    facetSingleOptionDiv.style.display = "block";
    if (isNew) {

      facetOptionsDiv.appendChild(facetSingleOptionDiv);
    }
  }
}

/**
 * Build element with link to desect some facet selection
 * @param facetOpton
 * @param facetSingleOptionDiv
 * @param onlyOneFacetChosen need for special parameter, used for rendering page when no facets had been chosen
 */
function buildFacetOption(facetOpton, facetSingleOptionDiv, onlyOneFacetChosen) {
  var facetLabel;
  var facetData;
  var facetName;
  var facetUrl;
  var pageUrl;
  var facetCat;
  var facetCatName;
  var facetValue;
  var addFacet;
  var removeFacet;

  facetName = facetOpton.name;
  facetUrl = facetOpton.urlFacet;
  facetCat = facetOpton.id;
  facetCatName = facetOpton.catName;
  trailSize = facetOpton.trailSize;
  addFacet = facetOpton.addFacet;
  removeFacet = facetOpton.removeFacet;
  facetValue = facetOpton.value;

  var facetUl = document.createElement("ul");
  facetSingleOptionDiv.appendChild(facetUl);
  var facetLi = document.createElement("li");
  facetUl.appendChild(facetLi);

  if (!getRedirect()) {	

    var facetHref = generateNavigationFragmentIdentifier(dojo.byId("qfh_docSort").value, 1, 'false', facetUrl, dojo.byId("catIdSaved").value, 'handleProductsLoad', true);

    facetLi.className = 'remove';
    facetLi.innerHTML = "<a href=\"javascript:facetClickAction('"
        + facetCat + "', '" + facetUrl + "', 0,"
        + trailSize + ",0,'" + facetHref + "', "+ onlyOneFacetChosen + ");\" title='" + removeFacetLabel + "'>" + facetName + "</a>";

  } else {
    facetLi.innerHTML = "<a href=\"" + pageUrl + "\">" + facetName
        + "</a>";
  }

  facetSingleOptionDiv.appendChild(facetUl);
  //show this facet category after rendering it.
  if (dojo.byId("facet_" + facetCat)) {
    dojo.byId("facet_" + facetCat).style.display = "block";
  }
}
function updateCategory(objCategory, categoryCount, category) {

  var catId = objCategory.catid;
  var catName = objCategory.name;

  var catDOMId = "facet_" + catId;

  if (dojo.byId(catDOMId)) {
    // already there

    handleUpdateCategory(objCategory, category);

  } else {
    // not there yet

    handleCreateCategory(objCategory, categoryCount);
  }
  dojo.byId(catDOMId).style.display = "block";
}

function handleUpdateCategory(objCategory, category) {

  var catId = objCategory.catid;
  var catName = objCategory.name;
  var catProp = objCategory.catprop;

  var catDOMId = "facet_" + catId;
  var optDOMId = "facetoptions_" + catId;

  //only have to update options for category

  var curCategory = dojo.byId(catDOMId);

  // clean category
  cleanDiv(curCategory);

  var containerHead = dojo.doc.createElement("h5");
  containerHead.innerHTML = catName;

  curCategory.appendChild(containerHead);
  curCategory.appendChild(buildCategoryOptions(objCategory.options, catId, catName, 0 ,catProp));

  if (objCategory.options.length > 0 && ("facet_" + category) == catDOMId) {
    //curCategory.setAttribute("style", "display:block;");

    curCategory.style.display = "block"; //modify in 11.22 2008 browser incompatablity
    //alert(("facet_"+category));
  }

}

function handleCreateCategory(objCategory, categoryCount) {

  var catId = objCategory.catid;
  var catName = objCategory.name;
  var catProp = objCategory.catprop;

  var catDOMId = "facet_" + catId;

  var curCategoryHolder = getCategoryHolder();

  var container = document.createElement("div");
  container.id = catDOMId;
  container.className = "atg_store_facetsGroup";

  var containerHead = dojo.doc.createElement("h5");
  containerHead.innerHTML = catName + ":";

  container.appendChild(containerHead);

  container.appendChild(buildCategoryOptions(objCategory.options, catId, catName,
      categoryCount, catProp));

  curCategoryHolder.appendChild(container);
}

function buildCategoryOptions(objOptions, strCat, categoryName, categoryCount, categoryProp) {	
  var tarContainer = document.createElement("div");
  var facetContainer;
  var singleFacet;

  tarContainer.id = "facetoptions_" + strCat;
  facetContainer = document.createElement("ul");

  var recShown = 5;
  var recCount = 0;
  if (objOptions.length <= recShown) {
    recShown = objOptions.length;
  }

if (categoryProp == "price") {

	for (var i = 0; i < objOptions.length; i++) {
	    createOption(facetContainer, tarContainer.id, objOptions[i].name,
	        objOptions[i].urlFacet, objOptions[i].urlPage,
	        objOptions[i].qty, strCat, 0, false, categoryCount,
	        objOptions[i].trailSize, categoryName);
	    recCount = recCount + 1;
	  }
	
}

else {

  for (var i = 0; i < recShown; i++) {
    createOption(facetContainer, tarContainer.id, objOptions[i].name,
        objOptions[i].urlFacet, objOptions[i].urlPage,
        objOptions[i].qty, strCat, 0, false, categoryCount,
        objOptions[i].trailSize, categoryName);
    recCount = recCount + 1;
  }

}

if (categoryProp != "price") {

  if (objOptions.length > recCount) {
    /* append more link to the end of the options ul */
    var moreLi = createOption(facetContainer, tarContainer.id, moreLable,
        "", "", "", strCat, 1, false, categoryCount, "", categoryName,"");

    for (var j = recShown; j < objOptions.length; j++) {
      createOption(facetContainer, tarContainer.id, objOptions[j].name,
          objOptions[j].urlFacet, objOptions[j].urlPage,
          objOptions[j].qty, strCat, 0, true, categoryCount,
          objOptions[j].trailSize, categoryName,"none");
    }
    var lessLi = createOption(facetContainer, tarContainer.id, lessLable,
        "", "", "", strCat, 2, false, categoryCount, "", categoryName,"none");

    facetContainer.appendChild(lessLi);
  }

}

  tarContainer.appendChild(facetContainer);  
  return tarContainer
}

function createOption(optionContainer, idx, name, urlFacet, urlPage, qty,
    strCat, optionType, debug, categoryCount, trailSize, categoryName, displayValue) {
  var optName = name;
  var optUrl = urlFacet;
  var optQty = qty;
  var optDisplay = "";
  var title = "";

  var singleFacet = document.createElement("li");

  if (optionType == 2) {
    singleFacet.className = "atg_store_facetLess";
    singleFacet.id = "lessDiv" + idx;
    // singleFacet.setAttribute("style", "display:block");
    singleFacet.style.display = "block"; //modify in 11.22 2008 browser incompatablity
  }

  if (optionType == 1) {
    singleFacet.className = "atg_store_facetMore";
    singleFacet.id = "moreDiv" + idx;
    // singleFacet.setAttribute("style", "display:block");
    singleFacet.style.display = "block"; //modify in 11.22 2008 browser incompatablity
  }

  var tempA_href = "";

  if (optionType == 1 || optionType == 2) {
    tempA_href = "javascript:atg.store.util.toggleBothDiv('" + idx + "', "
        + categoryCount + "," + optionType + ");";
    optDisplay = optName;
  } else if (optionType == 0) {
    optDisplay = optName + " (" + optQty + ")";

    if (!getRedirect()) {
      tempA_href = "javascript:facetClickAction('" + strCat + "','" + optUrl + "',1," + trailSize + "," + qty + ",'"+
                      generateNavigationFragmentIdentifier(dojo.byId("qfh_docSort").value, 1, 'false', optUrl, dojo.byId("catIdSaved").value, 'handleProductsLoad', true) + "'," + false + ");";
    } else {
      tempA_href = pageUrl;
    }
  }

if (optionType == 1 || optionType == 2) {

title = optDisplay;

}

else {

title = filterByLabel + " " + categoryName;	

}
	  
  var tempA = "<a title=\"" + title + " \" href=\"" + tempA_href + "\" >" + optDisplay + "</a>";

  singleFacet.innerHTML = tempA;
  if ( displayValue != null && displayValue != ""){
    singleFacet.style.display = displayValue; 
  }
  optionContainer.appendChild(singleFacet);
  return singleFacet;
}

/**
 * Function for refreshing facet panel + for reloading products
 * @param category
 * @param urlFacet
 * @param action
 * @param trailSize
 * @param qty
 * @param pFragmentIdentifier
 * @param deselectSingleFacetChoice - special param to track situation, when user deselects last facet chosen
 */
function facetClickAction(category, urlFacet, action, trailSize, qty, pFragmentIdentifier, deselectSingleFacetChoice) {
  // action: 1 = add, 0 = remove
  content.trailSize = trailSize;
  content.numResults = qty;

  switch (action) {
    case 0 :
      content.addFacet = ""; // clear gloable content's addFacet to empty.
      currentAnimation = dojo.fx.wipeIn({
            node : "facet_" + category,
            duration : 500
          });
      okAnimation = 1;
      break;

    case 1 :
      content.addFacet = "";
      currentAnimation = dojo.animateProperty({
            node : "facet_" + category,
            duration : 500,
            properties : {
              height : 50
            }
          });
      okAnimation = 0;
      break;
  }

  // reset page number on facet click
  var searchSettings = {
    q_docSort: dojo.byId("qfh_docSort").value,
    q_docSortOrder: dojo.byId("qfh_docSortOrder").value,
    q_pageNum:1,
    viewAll:"false",
    q_pageSize: dojo.byId("qfh_pageSize").value,
    q_question: dojo.byId("questionSaved").value,
    q_facetTrail: urlFacet,
    categoryId: dojo.byId("catIdSaved").value
  };

  dojo.byId("facetTrailSaved").value = urlFacet;

  if (!deselectSingleFacetChoice || catNavNotSupported) {
    setFragmentIdentifier(pFragmentIdentifier);  
    handleProductsLoad(searchSettings, category);
  } else {
    ajaxNavigation(dojo.byId("catIdSaved").value, 1, false, '',
             generateNavigationFragmentIdentifier('', '1', false,'', dojo.byId("catIdSaved").value, 'categoryProducts', false) + '&reloadFPcategory=' + category);
    reloadFacets(searchSettings, category);
  }

}

function buildCategories(objCategoryList, category, objFacets) {
  var i;

  objOut = dojo.byId("facetOptions");

  // iterate through all facets
  for (i = 0; i < objCategoryList.length; i++) {
    var canBeUpdated = true;
    for (j = 0; j < objFacets.length; j++) {
      if (objCategoryList[i].catid == objFacets[j].id) {
        canBeUpdated = false;
        break;
      }
    }
    if (canBeUpdated) {
      updateCategory(objCategoryList[i], objCategoryList.length, category);
    }
  }
}


function handleFacetLoad(objStructure, category) {

  content.facetTrail = objStructure.facetTrail;

  //content.trailSize = objStructure.trailSize;
  //console.dir(objStructure);

  var facetOptionsDiv = dojo.byId("facetOptions");

  for (i = 0; facetOptionsDiv && facetOptionsDiv.innerHTML != ""
      && i < facetOptionsDiv.childNodes.length; i++) {
    
    var obj = facetOptionsDiv.childNodes[i];
    if (obj && obj.style) {
      obj.style.display = "none";
    }
  }

  // load the facets
  // facets here means the facet option that user has clicked on and exist in the facetTrail.
  var objFacets = objStructure.facets;

  buildFacets(objFacets);

  //category here means the facet category. i.e price, color, size... and there are several options under corresponded category.
  // load categories
  var objCategories = objStructure.categories;
  buildCategories(objCategories, category, objFacets);

  var matchingItemsList = '';
  for (i = 0; i < objStructure.products.length; i++) {
    matchingItemsList += objStructure.products[i].repositoryId + ' ';
  }

  hideUnRenderedFacets(objFacets, objCategories);

  if (okAnimation == 1) {
    currentAnimation.play();
    okAnimation = 0;
  }

}

//this function removes facets that is left from the last "facet gadget refresh" but is not included in new set
function hideUnRenderedFacets(objFacets, objCategories) {
    //this check is needee
  var renderedFacetElements = dojo.query("[id^=facet_]");
  for (var i = 0; i < renderedFacetElements.length; i++) {
	var isFacetShouldBeRendered = false;
	var id = renderedFacetElements[i].id.substring(6);
	for(var j = 0; j < objFacets.length; j++) {
      if (id == objFacets[j].id) {
        isFacetShouldBeRendered = true;
      }
	}
    if (!isFacetShouldBeRendered) {
      for(var j = 0; j < objCategories.length; j++) {
        if (id == objCategories[j].catid) {
          isFacetShouldBeRendered = true;
        }
      }
    }
    //do not render facet
    if (!isFacetShouldBeRendered) {
      renderedFacetElements[i].parentNode.removeChild(renderedFacetElements[i]);
    }
  }
}


/**
 * This method render facet panel + loads products.
 * @param searchSettings search settings
 * @param category - facet category
 */
function handleProductsLoad(searchSettings, category) {
  p_url = contextPath + "/browse/gadgets/categoryContents.jsp";
  if (searchSettings.urlParams != undefined) {
      p_url = p_url + '?' + searchSettings.urlParams;
      searchSettings.urlParams = '';
  }
  var bindArgs = {
    url : p_url,
    content : searchSettings,
    error : function(response, ioArgs) {
      ajaxRequestIdentefication(false);
      console.debug("Error: " + response);
    },
    load : function(response, ioArgs) {
      var facetJson = response.substring(response.indexOf('facetJsonStart') + 14, response.indexOf('facetJsonEnd'));
      eval("var objStructure=" + dojo.trim(facetJson));

      handleFacetLoad(objStructure, category);
      atg.store.facet.handleResponse(response,  null);
      ajaxRequestIdentefication(false);
    }
  };
  ajaxRequestIdentefication(true);
  dojo.xhrGet(bindArgs);
}






/*
    ajax request content for pagination element
    pResultsPerPage - or pageSize or howMany - count of products shown per one page
    pCategoryId - category id - used adv search or for category browsing
    pFeatures - feature - used for adv search. one of search options
    pViewAll - view all parameter - indicate request on show all products (user can see page by page or all)
    pSearchInput - search criteria - text being searched
    pPageNum - current page number - used for navigation. Page which products will be shown
  */
function simplePagination(pResultsPerPage, pCategoryId, pFeatures, pViewAll, pSearchInput, pPageNum) {

  if (pViewAll == 'true') {
    p_url = contextPath + '/search/gadgets/searchRequestHandler.jsp?viewAll=true';
    pResultsPerPage = -1;
    pPageNum = -1;
  } else {
    p_url = contextPath + '/search/gadgets/searchRequestHandler.jsp';
  }


  var data = {
    q_pageSize: pResultsPerPage,
    categoryId: pCategoryId,
    features: pFeatures,
    searchInput: pSearchInput,
    q_pageNum: pPageNum,
    preventFormHandlerRedirect: false
  };

  madeAJAXRequest(data, p_url);
}


/**
 * Used for ajax enabldd category navigation.
 * Used by sort and pagination links on the browsing category pages.
 * @param pViewAll view all
 * @param pFragmentIdentifier fragment identifier
 */

function ajaxNavigation(pCategoryId, pPageNum, pViewAll, pDocSort, pFragmentIdentifier) {

  if (pViewAll == 'true') {
    p_url = contextPath + '/browse/gadgets/categoryProducts.jsp?viewAll=true';
  } else {
    p_url = contextPath + '/browse/gadgets/categoryProducts.jsp';
  }

  var data = {
    categoryId: pCategoryId,
    q_pageNum: pPageNum,
    q_docSort:pDocSort
  };
  setFragmentIdentifier(pFragmentIdentifier);
  madeAJAXRequest(data, p_url);

}


function madeAJAXRequest(pData, pUrl) {
  var bindArgs = {
    content: pData,
    url : pUrl,
    error : function(response, ioArgs) {
      ajaxRequestIdentefication(false);
      console.debug("Error: " + response);
    },
    load : function(response, ioArgs) {
      var mainObject=dojo.query("[divId='ajaxRefreshableContent']")[0];
      if(mainObject){
        mainObject.innerHTML=response;
      }
      ajaxRequestIdentefication(false);
    }

  };
  skipPageReload = true;
  ajaxRequestIdentefication(true);
  dojo.xhrGet(bindArgs);

}

/**
 * Function to prepare fragment identifier, which will be used to hold state of the ajax navigation
 * @param docSort
 * @param pageNumber
 * @param isViewAll
 * @param facetUrl
 * @param categoryId
 * @param nsraction shows what loader (jsp) should proceed this parameters.
 * @param isATGSearch - needed to identify - should we use facetTrail (feature of the ATGSearch)
 */
function generateNavigationFragmentIdentifier(docSort, pageNumber, isViewAll, facetUrl, categoryId, nsraction, isATGSearch) {
  var ajaxStateParams = "#q_docSort=" + docSort;
  if (isATGSearch) {
    ajaxStateParams = ajaxStateParams + "&q_docSortOrder=" + dojo.byId("qfh_docSortOrder").value;
  }
  ajaxStateParams = ajaxStateParams + "&q_pageNum=" + pageNumber +
      "&viewAll=" + isViewAll;
  if (isATGSearch) {
    ajaxStateParams = ajaxStateParams + "&q_pageSize=" + dojo.byId("qfh_pageSize").value +
      "&q_question=" + dojo.byId("questionSaved").value;
  }
  ajaxStateParams = ajaxStateParams + "&q_facetTrail=" + facetUrl +
      "&categoryId=" + categoryId +
      "&nsraction=" + nsraction;
  return ajaxStateParams;
}

// ---------------------- dojo.back based history ----------------------------

function HistoryState(state)
{
    this.state = state;
    this.restoreState = function() { 
      if (this.state && this.state != '') {
        ajaxNavigationStateReload(this.state); 
      } else {
        location.reload();
      }
    };
    // back, forward and changeUrl are needed by dojo
    this.back = this.restoreState;
    this.forward = this.restoreState;
    this.changeUrl = this.state;
}


/**
 * This function is used to reload ajax navigation state. Mainly for back button support.
 * Should be called on the pages where ajax enabled facets and navigation is used
 */
function ajaxNavigationStateReload(savedDirectives) {
  if (isFragmentIdentifierSet(savedDirectives)) {         
    var sDirQuestion = extractParam(savedDirectives, 'q_question');
    var sDirFacetTrail = extractParam(savedDirectives, 'q_facetTrail');

    if (sDirQuestion != '' && dojo.byId("questionSaved") != undefined ) {
      dojo.byId("questionSaved").value = sDirQuestion;
    }

    if (sDirFacetTrail != '' && dojo.byId("facetTrailSaved") != undefined ) {
      dojo.byId("facetTrailSaved").value = sDirFacetTrail;
    }

    var action = extractParam(savedDirectives, 'nsraction');

    if (action == 'handleProductsLoad') {
      var searchSettings = {
        urlParams: savedDirectives.substring(1, savedDirectives.length)
      };
      handleProductsLoad(searchSettings, '');
    } else if (action == 'categoryProducts') {
      var pCategoryId = extractParam(savedDirectives, 'categoryId');
      var pPageNum = extractParam(savedDirectives, 'q_pageNum');
      var pViewAll = extractParam(savedDirectives, 'viewAll');
      var pDocSort = extractParam(savedDirectives, 'q_docSort');
      ajaxNavigation(pCategoryId, pPageNum, pViewAll, pDocSort,  savedDirectives);
      if (extractParam(savedDirectives, 'reloadFPcategory') != '') {
        // reset page number on facet click
        var searchSettings = {
          q_docSort: dojo.byId("qfh_docSort").value,
          q_docSortOrder: dojo.byId("qfh_docSortOrder").value,
          q_pageNum:1,
          viewAll:"false",
          q_pageSize: dojo.byId("qfh_pageSize").value,
          q_question: dojo.byId("questionSaved").value,
          q_facetTrail: '',
          categoryId: dojo.byId("catIdSaved").value
        };
        reloadFacets(searchSettings, extractParam(savedDirectives, 'reloadFPcategory'));
      }
    }
  }
}

function isFragmentIdentifierSet(savedDirectives) {
  return (savedDirectives != '' && savedDirectives.indexOf('nsraction') > -1);
}

/**
 * Function is used to extract param from the string
 * @param str
 * @param paramName
 */
function extractParam(str, paramName) {
    var tempStartPos = str.indexOf(paramName);
    if (tempStartPos > -1) {
      tempStartPos = tempStartPos + paramName.length + 1; // 1 for = sign
      var tempEndPos = str.indexOf('&', tempStartPos);
      tempEndPos = (tempEndPos > -1) ? tempEndPos : str.length;
      return str.substring(tempStartPos, tempEndPos);
    } else {
      return '';
    }
}


function setFragmentIdentifier(pFragmentIdentifier) {
  dojo.back.addToHistory(new HistoryState(pFragmentIdentifier));
}

function reloadFacets(searchSettings, category) {
   var bindArgs = {
      url : contextPath + "/atgsearch/gadgets/ajaxSearch.jsp",
      content : searchSettings,
      error : function(response, ioArgs) {
        console.debug("Error: " + response);
      },
      load : function(response, ioArgs) {
        if (response != undefined) {
          eval("var objStructure=" + dojo.trim(response));
          handleFacetLoad(objStructure, category);
        }
      }
    };

    dojo.xhrGet(bindArgs);
}

/**
 *
 * @param showAjaxSpinnerImage boolean identifying should we add ajax spinner image or remove
 */
function ajaxRequestIdentefication(showAjaxSpinnerImage) {

  if (showAjaxSpinnerImage) {
    dojo.query("div[name='transparentLayer']").addClass("active");
    dojo.query("div[name='ajaxSpinner']").addClass("active");
  } else {
    dojo.query("div[name='transparentLayer']").removeClass("active");  
    dojo.query("div[name='ajaxSpinner']").removeClass("active");
  }

}

/**
 * @param checkBoxElement checkbox on checkout page that tells to create or not to create an account
 */
function updateSaveCCoption(checkBoxElement) {
  var sCCInfoBox = dojo.byId('saveCreditCardInfoBox');
  //checkBoxElement.checked == true  - is not redunency
  if (checkBoxElement.checked == true || checkBoxElement.checked == 'true' || checkBoxElement.checked == 'checked' ) {
    sCCInfoBox.style.display = "";
  } else {
    sCCInfoBox.style.display = "none";
  }

}