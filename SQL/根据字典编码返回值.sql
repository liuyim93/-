USE [ogis_guangdong_hzdlrmyy]
GO

--���ݱ����ѯ�ֵ����������/�����/������--
CREATE FUNCTION getDicItemByCode(@infoCode NVARCHAR(500),@typeCode VARCHAR(255),@returnType VARCHAR(255),@splitChar NVARCHAR(50))
RETURNS NVARCHAR(500)
AS
BEGIN	
	--@infoCode ԭ�ֶε�ֵ��ת��ʧ�ܻ᷵��ԭ�ַ���
	--@typeCode �ֵ�ı���
	--@returnType ����ֵ���ͣ�'name'-���ƣ�'out_code'-����룬'out_name'-�����ƣ�Ĭ�Ϸ�������
	--@splitChar �ָ�����Ĭ��'��'
	DECLARE @result NVARCHAR(500)
	DECLARE @srcCode NVARCHAR(500)	
	DECLARE @infoCodeItemCount INT
	SET @srcCode=@infoCode
	SET @result=@infoCode--ת��ʧ�ܣ�����ԭ�ַ���
	IF(ISNULL(@splitChar,'')='')
		SET @splitChar='��'--Ĭ�Ϸָ���
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
			DECLARE testCursor CURSOR--�����α�		
			FOR(SELECT col FROM dbo.FN_SplitSTR(@infoCode,@splitChar))--��ѯ��Ҫ�ļ��Ϸŵ��α���
			OPEN testCursor;--���α�
			FETCH NEXT FROM testCursor INTO @col--��ȡ��һ�����ݣ�����ֵ�ŵ�������
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
					FETCH NEXT FROM testCursor INTO @col--��ȡ��һ������
				END
			CLOSE testCursor--�ر��α�
			DEALLOCATE testCursor--�ͷ��α�
		END
	IF(ISNULL(@result,'-1')='-1')
		SET @result=@infoCode
	RETURN @result	
END
GO
