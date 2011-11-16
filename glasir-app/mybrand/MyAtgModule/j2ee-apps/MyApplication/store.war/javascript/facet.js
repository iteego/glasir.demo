dojo.provide("atg.store.facet");

/*
    Ajax request for product list and pagination
*/

atg.store.facet={
    /*
    AJAX request content for target element
    parameter:
       content: encapsulation data for ajax request,involved url ,and so on
       target: target element object,such as div object
  */

  loadData:function(content,target){
      var _this=this;
    if(!content.url){
      content.url=contextPath+"/browse/category.jsp";
    }
    var bindParam={
      url:content.url,
      content:content,
      load:function(data){
        _this.handleResponse(data,target);
      },
      error:function(err){console.debug("atg.store.facet loadData: ",err);}
    }
    dojo.xhrPost(bindParam);
  },

    /*
    ajax request content for pagination element
    parameter:
       pStartValue: element start position
       pAddFacet: add facet
       pPageNum: current page number
       pTrail: trail
       pTrailSize:t rail size
       pCategoryId: being selected category
       pSelectedHowMany: render element number
       pViewAll:whether view all element
       pFragmentIdentifier: fragment identifier
       pageSize
  */
  loadDataPagination:function(pStartValue, pAddFacet,pPageNum,
                pTrail,pTrailSize,pCategoryId,
                pDocSort,pSelectedHowMany,pViewAll,pSortOrder,pPageSize, pFragmentIdentifier){
    setFragmentIdentifier(pFragmentIdentifier);

    var content={
        start:pStartValue,
        q_docSort:pDocSort,
        addFacet:pAddFacet,
        q_pageNum:pPageNum,
        trail:pTrail,
        trailSize:pTrailSize,
        categoryId:pCategoryId,
        selectedHowMany:pSelectedHowMany,
        viewAll:pViewAll
    };

        var searchSettings = {
          q_docSort: pDocSort,
          q_docSortOrder: pSortOrder,
          q_pageNum:pPageNum,
          viewAll:pViewAll,
          q_pageSize: pPageSize,
          categoryId:pCategoryId,  
          q_question: dojo.byId("questionSaved").value,
          q_facetTrail: dojo.byId("facetTrailSaved").value
        };
    handleProductsLoad(searchSettings, '');
  },

     /*
    handle ajax response, put response data into target element.
    parameter:
       data: response data
       target:target element object,such as div object
  */
  handleResponse:function(data,target){
    if(!target){
      var mainObject=dojo.query("[divId='ajaxRefreshableContent']")[0];
      if (mainObject == null) {
        mainObject=dojo.query(".main")[0]; //first time
      }
      if(mainObject){
         mainObject.innerHTML=data;
      }
    }else{
      target.innerHTML=data;
    }
  
  }
}