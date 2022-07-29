create FUNCTION [dbo].[f_split](@Long_str NVARCHAR(MAX),@split_str NVARCHAR(100))    
RETURNS  @tmp TABLE(        
    ID          inT     IDENTITY PRIMARY KEY,      
    short_str   NVARCHAR(MAX)    
)    
AS   
BEGIN   
    DECLARE @short_str NVARCHAR(MAX),@split_str_length int,@split_str_Position_Begin int
    SET @split_str_length = LEN(@split_str) 
    SET @Long_str=REPLACE(REPLACE(@Long_str,CHAR(10),''),CHAR(13),'')
    IF CHARINDEX(@split_str,@Long_str)=1 
         SET @Long_str=STUFF(@Long_str,1,@split_str_length,'')
    IF CHARINDEX(@split_str,@Long_str)=0
        INSERT INTO @tmp SELECT @Long_str 
    ELSE
        BEGIN
            WHILE 1>0    
                BEGIN   
                    SET @split_str_Position_Begin = CHARINDEX(@split_str,@Long_str)
                    SET @short_str=LEFT(@Long_str,@split_str_Position_Begin-1) 
                    IF @short_str<>'' INSERT INTO @tmp SELECT @short_str  
                    SET @Long_str=STUFF(@Long_str,1,@split_str_Position_Begin+@split_str_length-1,'')
                    SET @split_str_Position_Begin = CHARINDEX(@split_str,@Long_str)
                    IF @split_str_Position_Begin=0 
                    BEGIN
                        IF LTRIM(@Long_str)<>''
                            INSERT INTO @tmp SELECT @Long_str 
                        BREAK
                    END
                END           
        END
    RETURN     
END