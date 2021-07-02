USE [ogis_guangdong_hzdlrmyy]
GO

--根据编码查询字典表，返回名称/外编码/外名称--
CREATE FUNCTION getDicItemByCode(@infoCode NVARCHAR(500),@typeCode VARCHAR(255),@returnType VARCHAR(255),@splitChar NVARCHAR(50))
RETURNS NVARCHAR(500)
AS
BEGIN	
	--@infoCode 原字段的值，转换失败会返回原字符串
	--@typeCode 字典的编码
	--@returnType 返回值类型，'name'-名称，'out_code'-外编码，'out_name'-外名称，默认返回名称
	--@splitChar 分隔符，默认'〓'
	DECLARE @result NVARCHAR(500)
	DECLARE @srcCode NVARCHAR(500)	
	DECLARE @infoCodeItemCount INT
	SET @srcCode=@infoCode
	SET @result=@infoCode--转换失败，返回原字符串
	IF(ISNULL(@splitChar,'')='')
		SET @splitChar='〓'--默认分隔符
	SET @infoCodeItemCount = (SELECT COUNT(1) FROM dbo.FN_SplitSTR(@infoCode,@splitChar))
	IF(@infoCodeItemCount=1)
		BEGIN
		IF(ISNULL(@returnType,'')='' OR ISNULL(@returnType,'')='name')
			BEGIN		
			SET @result=(SELECT info.name FROM dbo.sys_dic_type type
						INNER JOIN dbo.sys_dic_info info ON type.id=info.type_id 
						WHERE type.code=@typeCode AND info.code=@infoCode)
			END
		ELSE 
			BEGIN
			IF(ISNULL(@returnType,'')='out_code')
				BEGIN
				SET @result=(SELECT info.out_code FROM dbo.sys_dic_type type
							INNER JOIN dbo.sys_dic_info info ON type.id=info.type_id 
							WHERE type.code=@typeCode AND info.code=@infoCode)
				END
			ELSE
				BEGIN
				IF(ISNULL(@returnType,'')='out_name')
					BEGIN
					SET @result=(SELECT info.out_name FROM dbo.sys_dic_type type
							INNER JOIN dbo.sys_dic_info info ON type.id=info.type_id 
							WHERE type.code=@typeCode AND info.code=@infoCode)
					END
				END
			END
		END	
	ELSE
		BEGIN
			DECLARE @col VARCHAR(255)
			DECLARE @temp NVARCHAR(255)
			DECLARE @index INT
			SET @index=1
			DECLARE testCursor CURSOR--定义游标		
			FOR(SELECT col FROM dbo.FN_SplitSTR(@infoCode,@splitChar))--查询需要的集合放到游标中
			OPEN testCursor;--打开游标
			FETCH NEXT FROM testCursor INTO @col--读取第一行数据，并把值放到变量中
			WHILE @@FETCH_STATUS =0
				BEGIN					
					SET @temp=dbo.getDicItemByCode(@col,@typeCode,@returnType,@splitChar)
					IF(ISNULL(@temp,'')!='')
						BEGIN
						IF(@index=1)
							BEGIN														
								SET @result=@temp							
								SET @index+=1
							END 
						ELSE
							BEGIN 
								SET @result+=@splitChar+@temp
								SET @index+=1
							END 
						END
					FETCH NEXT FROM testCursor INTO @col--读取下一行数据
				END
			CLOSE testCursor--关闭游标
			DEALLOCATE testCursor--释放游标
		END
	IF(ISNULL(@result,'-1')='-1')
		SET @result=@infoCode
	RETURN @result	
END
GO
