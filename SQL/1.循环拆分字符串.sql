/**FN_SplitSTR**/
/** 循环截取法分割字符串，默认返回数据表 */
IF exists (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FN_SplitSTR]') and xtype in (N'FN', N'IF', N'TF'))
BEGIN
  DROP FUNCTION [dbo].[FN_SplitSTR]
END
GO

--循环拆分字符串
CREATE FUNCTION FN_SplitSTR(
 @s   NVARCHAR(MAX),   --待分拆的字符串
 @split NVARCHAR(10)     --数据分隔符
)RETURNS @re TABLE(col NVARCHAR(100))
AS
BEGIN
 DECLARE @splitlen INT;
 SET @splitlen=LEN(@split+'a')-2;
 SET @s = REPLACE(REPLACE(@s,'[',''),']','');
 
 WHILE CHARINDEX(@split,@s)>0
 BEGIN
  INSERT @re VALUES(LEFT(@s,CHARINDEX(@split,@s)-1));
  SET @s=STUFF(@s,1,CHARINDEX(@split,@s)+@splitlen,'');
 END
 INSERT @re VALUES(@s);
 RETURN
END
GO