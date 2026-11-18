create Procedure [dbo].[USP_InsertItineraryInclusionsExclusions]   
 @Country_IATACode varchar(5),
 @City_IATACode varchar(5),   
 @Type varchar(20),
 @Header varchar(200),
 @Description varchar(MAX),
 @IsActive bit,
 @IsDefault bit,
 @SeqNo varchar(MAX),
 @OperationBy uniqueidentifier,
 @ErrMsg   VARCHAR(50) OUT          
as    
begin    
 Declare @new_identity INT        
	 BEGIN      
	 IF EXISTS (SELECT ID FROM ItineraryInclusionsExclusions WHERE UPPER(Type)=UPPER(@Type) AND (@SeqNo IS NOT NULL AND @SeqNo <> '' AND SeqNo = @SeqNo))
	 BEGIN        
		SET @ErrMsg ='Type and Sequence already exists.'     
	 END 
	 ELSE
		BEGIN
		 INSERT INTO ItineraryInclusionsExclusions     
		 (Country_IATACode,City_IATACode,Type,Header,Description,IsActive,IsDefault,SeqNo,Operation,OperationBy,OperationOn)    
		 VALUES    
		 (@Country_IATACode,@City_IATACode, @Type,@Header,@Description,@IsActive, @IsDefault, @SeqNo,
		 'INSERT',@OperationBy, GETDATE())
     
		  SELECT @new_identity = SCOPE_IDENTITY()          
          
		  EXEC  USP_InsertItineraryInclusionsExclusions_Log @new_identity,@Country_IATACode,@City_IATACode,@Type,@Header,@Description,@IsActive,@IsDefault,@SeqNo,'INSERT', @OperationBy 
		  SET   @ErrMsg = ''          
		END     
	END
END