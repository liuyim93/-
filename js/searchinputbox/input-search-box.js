  $(function(){
    $("input[data-search]").on("focus",inputSearchBox.autocomplete);
    $("input[data-search]").on("keyup",inputSearchBox.autocomplete);
    $("input[data-search]").on("keydown",inputSearchBox.setActiveItem);
    $(document).on("click",inputSearchBox.hideAutoCompleteBox);
  });
  /** 可搜索的文本框 */
  const inputSearchBox={
    propName:'data-search',
    data:[],
    itemClass:'highlight_line',
    activeItemClass:'highlight_line_actived',
    autocomplete:function(event){
      const exceptKeys=['ArrowUp','ArrowDown','Enter','Escape'];//不解析这些按键
      if(exceptKeys.filter(t=>t==event.key).length>0){
        return;
      }
      let autoNodeName=$(this).attr(inputSearchBox.propName);
      let datalist=inputSearchBox.data[autoNodeName];
      console.log("autocomplete,datalist",datalist);
      if(!datalist || datalist.length<1){
        console.log("没有可供搜索的数据");
        return;
      }
      const inputNode=$(this);
      const inputNodeName=$(this).attr('name');
      let autoNode=$("#"+autoNodeName);
      if(autoNode.length<1){
          autoNode=$("<div id='"+autoNodeName+"' class='search_text'></div>");
          $(this).parent().append(autoNode);
      }
      console.log("autoNode",autoNode);
      let completeList = [];
      let n = 0;
      let old_value = $(this).val();
      for (let item of datalist) {
        if ((item.user_name && item.user_name.indexOf(old_value) >= 0)
          || (item.user_code && item.user_code.indexOf(old_value)>=0)
          || (item.pinyin && item.pinyin.indexOf(old_value)>=0)
          || (item.pinyin_shouzimu && item.pinyin_shouzimu.indexOf(old_value)>=0)
          ) { // 若匹配项需要以输入的内容开头，用==;否则用>=
          completeList.push(item);
        }
      }
      if (completeList.length <= 0) {
        autoNode.hide();
        return;
      }
      autoNode.empty(); //清空上次的记录
      for (let i in completeList) {
        let wordNode = completeList[i]; //弹出框里的每一条内容
        let wordNodeText=wordNode.user_name;
        let newDivNode = $("<div>");
        newDivNode.attr("id", autoNodeName+"_li_"+i); //设置每个节点的id值
        newDivNode.attr("class",inputSearchBox.itemClass);
        newDivNode.html(wordNodeText).appendTo(autoNode); //追加到弹出框
        //鼠标移入高亮，移开不高亮
        newDivNode.mouseover(function () {
          $(this).addClass(inputSearchBox.activeItemClass);
        });
        newDivNode.mouseout(function () {
          $(this).removeClass(inputSearchBox.activeItemClass);
        });
        //鼠标点击文字上屏
        newDivNode.click(function () {
          autoNode.hide();
          //取出高亮节点的文本内容
          var comText = $(this).text();
          //文本框中的内容变成高亮节点的内容
          inputNode.val(comText);
        });
        //如果返回值有内容就显示出来
        autoNode.show();
      }
    },
    hideAutoCompleteBox:function(event){
      //点击提示框外的任何一个位置会隐藏搜索提示框
      let e=event ?event:window.event;
      let tar=e.srcElement || e.target;
      let inputSearchBoxArr=[];
      $('input['+inputSearchBox.propName+']').each(function(index,item){
        inputSearchBoxArr.push($(item).attr(inputSearchBox.propName));
      });
      if(!$(tar).attr(inputSearchBox.propName)){
        for (let item of inputSearchBoxArr){
          if($('#'+item).is(':visible')){
            $('#'+item).hide();
          }
        }
      }
    },
    setActiveItem:function(event){
      //键盘上下键切换选项，回车赋值
      let autoNodeName=$(this).attr(inputSearchBox.propName);
      console.log(event.key);
      const inputNode=$(this);
      let autoNode=$("#"+autoNodeName);
      if(!autoNode || autoNode.length<1 || !autoNode.is(':visible')){
        return;
      }
      let activedItem=autoNode.find('.'+inputSearchBox.activeItemClass+'');
      if(event.key=='ArrowUp'){
        //上箭头
        if(activedItem.length<1){
          //选中第一行
          autoNode.children('div:first-child').addClass(inputSearchBox.activeItemClass);
        }else{
          let prevItem=activedItem.prev();
          if(prevItem.length>0){
            autoNode.children().removeClass(inputSearchBox.activeItemClass);
            prevItem.addClass(inputSearchBox.activeItemClass);
          }
        }
      }
      if(event.key=='ArrowDown'){
        //下箭头
        if(activedItem.length<1){
          //选中第一行
          autoNode.children('div:first-child').addClass(inputSearchBox.activeItemClass);
        }else{
          let nextItem=activedItem.next();
          if(nextItem.length>0){
            autoNode.children().removeClass(inputSearchBox.activeItemClass);
            nextItem.addClass(inputSearchBox.activeItemClass);
          }
        }
      }
      if(event.key=='Enter'){
        //回车
        if(activedItem.length<1){
          return;
        }
        inputNode.val(activedItem.text());
        autoNode.hide();
      }
      if(event.key=='Escape'){
        //ESC返回键
        autoNode.hide();
      }
    }
  }