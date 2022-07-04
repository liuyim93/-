//拆分字符串，拆分失败返回空字符串。拆分成功返回指定索引的字符串，索引从1开始。
Function splitItem(ByVal sourceStr As String,ByVal splitStr as String,ByVal index as Integer) as String	
	splitItem=""
	If sourceStr="" Or IsNothing(sourceStr)  Or IsNothing(splitStr) then exit Function
	Dim tempArr()=Split(sourceStr,splitStr)
	if index > tempArr.Length Or index < 1 then exit Function
	splitItem=tempArr(index-1)
END Function

//拆分字符串，拆分失败返回原字符串。拆分成功返回指定索引的字符串，索引从1开始。
Function splitItem(ByVal sourceStr As String,ByVal splitStr as String,ByVal index as Integer) as String	
	splitItem=sourceStr
	If sourceStr="" Or IsNothing(sourceStr)  Or IsNothing(splitStr) then exit Function
	Dim tempArr()=Split(sourceStr,splitStr)
	if index > tempArr.Length Or index < 1 then exit Function
	splitItem=tempArr(index-1)
END Function

//把大段文字拆分成多行
//perLineWordCount 每行显示的字数
//showLineNum 要显示第几行，索引从1开始
Function showTextLine(ByVal sourceStr as String,ByVal perLineWordCount as Integer,ByVal showLineNum as Integer) as String
	showTextLine=sourceStr
	If sourceStr="" Or IsNothing(sourceStr) Or perLineWordCount<0 Or showLineNum<0 then exit Function
	Dim sourceStrLength as String
	sourceStrLength=Len(sourceStr)
	Dim leftStr as String
	leftStr=""
	Dim rightStr as String
	rightStr=sourceStr
	Dim tempNum as Integer
	tempNum=0
	If sourceStrLength < perLineWordCount then exit Function
	showTextLine=""
	For i as Integer = 1 To showLineNum
		leftStr=Left(rightStr,perLineWordCount)
		tempNum=sourceStrLength-(i*perLineWordCount)
		If tempNum < (-1*perLineWordCount) then exit Function
		If tempNum<0 then
			tempNum=perLineWordCount
		end If
		rightStr=Right(rightStr,tempNum)
		Next i
	showTextLine=leftStr
END Function

//把文本转换成数字，转换失败则返回-1
Function getNum(ByVal valueStr As String) as Integer	
	getNum=-1
	If valueStr="" Or IsNothing(valueStr) Or Not(IsNumeric(valueStr)) then exit Function	
	getNum=CInt(valueStr)
END Function

''判断字符串是否包含某个字符串，包含则返回√，否则返回空
Function getCheckContainStr(ByVal valueStr As String,ByVal containStr As String) as String	
	getCheckContainStr=""
	If valueStr="" Or IsNothing(valueStr) Or containStr="" Or IsNothing(containStr) then exit Function
	If valueStr.Contains(containStr) then getCheckContainStr="√"	
END Function

''判断字符串是否等于某个字符串，等于则返回√，否则返回空
Function getCheckEqualStr(ByVal valueStr As String,ByVal containStr As String) as String	
	getCheckEqualStr=""
	If valueStr="" Or IsNothing(valueStr) Or containStr="" Or IsNothing(containStr) then exit Function
	If valueStr=containStr then getCheckEqualStr="√"	
END Function