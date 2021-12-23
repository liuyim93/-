create FUNCTION [dbo].[getSplitStr](@srcStr nvarchar(max),@splitStr varchar(50),@index int)
RETURNS varchar(500)
BEGIN
DECLARE @resultStr VARCHAR(500);
if(isnull(@srcStr,'')='')
	set @resultStr=@srcStr
if(isnull(@srcStr,'')!='' and charindex(@splitStr,@srcStr)<=0)
	set @resultStr=@srcStr
if(isnull(@srcStr,'')!='' and charindex(@splitStr,@srcStr)>0)
	set @resultStr=(select col from (select row_number() over(order by (select 1)) rownum,col from dbo.FN_SplitSTR(@srcStr,@splitStr))tab where rownum=@index)
return @resultStr
END
