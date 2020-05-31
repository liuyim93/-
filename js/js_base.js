toDBC:function(str){
    	//全角字符转半角
    	var temp="";
		for(var i=0;i<str.length;i++){
			if(str.charCodeAt(i)==12288){
				//全角空格为12288，半角空格为32
				temp+=String.fromCharCode(32);
			}else if(str.charCodeAt(i)>65248 && str.charCodeAt(i)< 65375){
				temp+=String.fromCharCode(str.charCodeAt(i)-65248);
			}else{
				temp+=str.charAt(i);
			}
		}
		return temp;		
    },
toSBC:function(str){
    	//半角字符转全角
    	//全角空格为12288，半角空格为32
		// 其他字符半角(33-126)与全角(65281-65374)的对应关系是：均相差65248
		var temp="";
		for(var i=0;i<str.length;i++){
			if(str.charCodeAt(i)==32){
				temp+=String.fromCharCode(12288);
			}else if(str.charCodeAt(i)<127){
				temp+=String.fromCharCode(str.charCodeAt(i)+65248);
			}else {
				temp+=str.charAt(i);
			}
		}
		return temp;
    }