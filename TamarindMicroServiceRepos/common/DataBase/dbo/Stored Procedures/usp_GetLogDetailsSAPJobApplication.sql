-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetLogDetailsSAPJobApplication]
(
@JobName varchar(50),
@Taskflag varchar(50),
--@FromDate INT ,
--@ToDate INT ,
@DataNumber VARCHAR(Max) 

)
AS
BEGIN


    -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       --SET NOCOUNT ON;

       --BEGIN TRAN
       --       BEGIN TRY
             
 if(@JobName = 'Invoice')
  begin
    print 'Invoice'

	if(@Taskflag = 'I')
	begin 
	   
	       select Document_Number_Astra,    
			CONVERT(VarCHAR,InsertedDateTime,103) as 'Changed On' ,U.UserName as 'Changed By',
			TaskFlag               
			FROM [BusinessPartnerFile_Log]  HMA              
			INNER JOIN EmployeeMaster U on HMA.CreatedBy= U.EmpID  
		   where SAPFileName = 'SAPInvoiceJob' 
		   AND Document_Number_Astra IN( SELECT items FROM [SplitCommaToTable](@DataNumber,',')) 
		   order by InsertedDateTime DESC 
		   --AND InsertedDateTime BETWEEN @FromDt AND @ToDate 
		    SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage;  
	end

  end
    if(@JobName = 'XO')
  begin
    print 'XO'

	if(@Taskflag = 'I')
	begin

		   	       select Document_Number_Astra,    
			CONVERT(VarCHAR,InsertedDateTime,103) as 'Changed On' ,U.UserName as 'Changed By',
			TaskFlag               
			FROM [BusinessPartnerFile_Log]  HMA              
			INNER JOIN EmployeeMaster U on HMA.CreatedBy=U.EmpID  
		   where SAPFileName = 'SAPXOJob' 
		    AND Document_Number_Astra IN( SELECT items FROM [SplitCommaToTable](@DataNumber,',')) 
			order by InsertedDateTime DESC 
		   --AND InsertedDateTime BETWEEN @FromDt AND @ToDate 
		    SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage;  


	end

  end
      if(@JobName = 'FileCode')
	  begin
		print 'FileCode'

		if(@Taskflag = 'I')
		begin

		 	       select Document_Number_Astra,    
			CONVERT(VarCHAR,InsertedDateTime,103) as 'Changed On' ,U.UserName as 'Changed By',
			TaskFlag               
			FROM [BusinessPartnerFile_Log]  HMA              
			INNER JOIN EmployeeMaster U on HMA.CreatedBy=U.EmpID  
		   where SAPFileName = 'FileCodeJob' 
		    AND Document_Number_Astra IN( SELECT items FROM [SplitCommaToTable](@DataNumber,','))
			order by InsertedDateTime DESC 
		   --AND InsertedDateTime BETWEEN @FromDt AND @ToDate 
		    SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage;  
 
		end
	 end
	if(@JobName = 'AgentMaster')
	  begin
		print 'AgentMaster'

		if(@Taskflag = 'I')
		begin

	    	       select Document_Number_Astra,    
			CONVERT(VarCHAR,InsertedDateTime,103) as 'Changed On' ,U.UserName as 'Changed By',
			TaskFlag               
			FROM [BusinessPartnerFile_Log]  HMA              
			INNER JOIN EmployeeMaster U on HMA.CreatedBy=U.EmpID  
		   where SAPFileName = 'AgentMasterJob' 
		    AND Document_Number_Astra IN( SELECT items FROM [SplitCommaToTable](@DataNumber,','))  
			order by InsertedDateTime DESC
		  -- AND InsertedDateTime BETWEEN @FromDt AND @ToDate 
		   SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage;  

		end

	  end
  if(@JobName = 'HotelMaster')
  begin
    print 'HotelMaster'

	if(@Taskflag = 'Insert')
	begin
	     	       select Document_Number_Astra,    
			CONVERT(VarCHAR,InsertedDateTime,103) as 'Changed On' ,U.UserName as 'Changed By',
			TaskFlag               
			FROM [BusinessPartnerFile_Log]  HMA              
			INNER JOIN EmployeeMaster U on HMA.CreatedBy=U.EmpID  
		   where SAPFileName = 'HotelMasterJob' 
		    AND Document_Number_Astra IN( SELECT items FROM [SplitCommaToTable](@DataNumber,',')) 
			order by InsertedDateTime DESC
		   --AND InsertedDateTime BETWEEN @FromDt AND @ToDate  
		    SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage;  

	end
	--if(@Taskflag = 'Update')
	--begin


	--     select Document_Number_Astra,SAPFileName, InsertedDateTime, CreatedBy from [BusinessPartnerFile_Log]
	--	   where SAPFileName = 'HotelMasterJobUpdate' AND InsertedDateTime BETWEEN @FromDt AND @ToDate  
   
	--end
  end

  
		if(@JobName = 'XORepost')
	  begin
		print 'XORepost'

		if(@Taskflag = 'I')
		begin

	    	       select [XO Number] AS Document_Number_Astra,    
			CONVERT(VarCHAR,InsertedDateTime,103) as 'Changed On' ,U.UserName as 'Changed By',
			TaskFlag               
			FROM [BusinessPartnerFile_Log]  HMA              
			LEFT JOIN EmployeeMaster U on HMA.CreatedBy=U.EmpID  
		   where SAPFileName = 'XORepostSAPJob' 
		    AND [XO Number] IN( SELECT items FROM [SplitCommaToTable](@DataNumber,','))
		  -- AND InsertedDateTime BETWEEN @FromDt AND @ToDate 
		   SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage;  
		end

	  end

  if(@JobName = 'VendorMaster')
  begin
    print 'VendorMaster'

	if(@Taskflag = 'I')
	begin
	     	       select Document_Number_Astra,    
			CONVERT(VarCHAR,InsertedDateTime,103) as 'Changed On' ,U.UserName as 'Changed By',
			TaskFlag               
			FROM [BusinessPartnerFile_Log]  HMA              
			INNER JOIN EmployeeMaster U on HMA.CreatedBy=U.EmpID  
		   where SAPFileName = 'VendorMasterJob' 
		    AND Document_Number_Astra IN( SELECT items FROM [SplitCommaToTable](@DataNumber,',')) 
			order by InsertedDateTime DESC
		  -- AND InsertedDateTime BETWEEN @FromDt AND @ToDate  
		   SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage;  

	end
	--if(@Taskflag = 'Update')
	--begin
	--     select Document_Number_Astra,SAPFileName, InsertedDateTime, CreatedBy from [BusinessPartnerFile_Log]
	--	   where SAPFileName = 'VendorMasterJobUpdate' AND InsertedDateTime BETWEEN @FromDt AND @ToDate  

			 		    
	--end
  end

		  --DECLARE @pdId int
		  --SET @pdId = SCOPE_IDENTITY()
           
    --          -- if not error, commit the transcation
    --          COMMIT TRANSACTION
    --   END TRY
    --   BEGIN CATCH
    --          -- if error, roll back any chanegs done by any of the sql statements
    --          ROLLBACK TRANSACTION 	 

    --   END CATCH



END
