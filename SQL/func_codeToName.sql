create FUNCTION [dbo].[func_codeToName]
( @str AS NVARCHAR(1000),@splitstr AS NVARCHAR(1000),@dicType AS NVARCHAR(100)
)
RETURNS NVARCHAR(2000)-- nvarchar
AS
BEGIN
DECLARE @def NVARCHAR(2000);

IF ISNULL(@str, '')!=''
	BEGIN
		SELECT @def = STUFF((   
		SELECT @splitstr+dicinfo.name FROM sys_dic_type dicType LEFT JOIN sys_dic_info dicInfo ON dicType.id=dicInfo.type_id WHERE dicInfo.code IN (SELECT short_str FROM dbo.f_split(@str,ISNULL(@splitstr, ''))) AND dicType.code=@dicType 
		FOR XML PATH('')) ,1 ,1 ,'');
	END
ELSE
	BEGIN
		SET @def='';
	END
	RETURN @def
END