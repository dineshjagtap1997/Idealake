CREATE PROCEDURE [dbo].[usp_Enquiry] @EnquiryID VARCHAR(255) = NULL          
 ,@CreatedBy VARCHAR(100) = NULL          
 ,@StatusID INT = NULL          
 ,@LatestQuotationID INT = NULL          
 ,@LatestItineraryID INT = NULL          
 ,@B2B_B2C BIT = NULL          
 ,@FIT_GIT BIT = NULL          
 ,@EnquiryLost BIT = NULL          
 ,@Department VARCHAR(100) = NULL          
 ,@BizVertical VARCHAR(100) = NULL          
 ,@TamSales VARCHAR(100) = NULL          
 ,@BigBilling_ImpAgentClient VARCHAR(100) = NULL          
 ,@TravelType VARCHAR(50) = NULL          
 ,@TravellingFrom INT = NULL          
 ,@TravellingDestinations VARCHAR(MAX) = NULL          
 ,@ExpectedTravelStartDate DATE = NULL          
 ,@ExpectedTravelNights INT = NULL          
 ,@ExpectedTravelEndDate DATE = NULL          
 ,@PAX INT = NULL          
 ,@Adults INT = NULL          
 ,@Children INT = NULL          
 ,@AdditionalNotes VARCHAR(255) = NULL          
 ,@PreferredHotelCategory VARCHAR(MAX) = NULL          
 ,@RoomCounts INT = NULL          
 ,@OtherRelatedServices VARCHAR(MAX) = NULL          
 ,@Nationality INT = NULL          
 ,@Budget DECIMAL(10, 2) = NULL          
 ,@AgentID INT = NULL          
 ,@AgentStaffName VARCHAR(MAX) = NULL          
 ,@BookersName VARCHAR(100) = NULL          
 ,@ClientId BIGINT = NULL          
 ,@Action CHAR(2) = NULL          
 ,@EQID INT = NULL          
 ,@bigbilling BIT = 0          
 ,@Description VARCHAR(200) = NULL          
 ,@PhoneNo VARCHAR(30) = NULL          
 ,@Email VARCHAR(200) = NULL          
 ,@Reference VARCHAR(200) = NULL          
 ,@ReassignTo UNIQUEIDENTIFIER = NULL          
 ,@OperationBy UNIQUEIDENTIFIER = NULL          
 ,@IsDraft BIT = 0          
 ,@ID INT OUTPUT          
 ,@IsSysGenEnquiry INT = 0          
 ,@YearID INT = NULL          
 ,@CompanyID INT = NULL          
 ,@PageNumber INT = 1        
 ,@Row_Count INT = 10        
 ,@ReassigTonName nvarchar(500)=null        
 ,@strLatestQuotationID nvarchar(100)=null        
 ,@AgentName nvarchar(100)=null        
 ,@CustomerName nvarchar(100)=null        
 ,@StatusName nvarchar(100)=null        
AS          
BEGIN          
 SET NOCOUNT ON;          
          
 DECLARE @LogID INT;          
          
  DECLARE @CompanyCode NVARCHAR(5) = '';          
 DECLARE @YearCode NVARCHAR(5) = '';          
 DECLARE @Prefix NVARCHAR(20) = '';          
 DECLARE @MaxNumber INT = 0;          
           
          
 -- Fetch CompanyCode          
 IF @CompanyID IS NOT NULL          
  AND @CompanyID > 0          
 BEGIN          
  SELECT           
   @CompanyCode = LEFT(ISNULL(CompCode, ''), 3)          
  FROM           
   CompanyMaster          
  WHERE           
   CompanyID = @CompanyID          
 END          
          
 ---- Fetch YearCode          
 --IF @YearID IS NOT NULL          
 -- AND @YearID > 0          
 --BEGIN          
 -- SELECT @YearCode = ISNULL(YearCode, '')          
 -- FROM YearMaster          
 -- WHERE YearID = @YearID;          
 --END          
          
 --SET @Prefix = (CASE           
 --   WHEN @IsSysGenEnquiry = 0          
 --    THEN 'E'          
 --   ELSE 'SYS'          
 --   END) + @CompanyCode + @YearCode;          
      
  SET @YearCode= RIGHT(YEAR(GETDATE()), 2);      
      
  SET @Prefix = (CASE           
    WHEN @IsSysGenEnquiry = 0          
     THEN 'E'          
    ELSE 'SYS'          
    END) + @CompanyCode + @YearCode;         
          
          
 -- SELECT            
 IF @Action = 'SA'          
 BEGIN          
  BEGIN          
  DECLARE @TotalRecordCount INT = 0        
        
  SELECT @TotalRecordCount=        
  (SELECT COUNT(*) FROM         
   (        
    SELECT         
     DISTINCT        
     E.EQID          
     ,E.EnquiryID          
     ,E.CreatedDateTime          
     ,E.UpdatedDateTime          
     ,E.CreatedBy          
     ,E.UpdatedBy          
     ,E.StatusID          
     ,ES.StatusDescription AS StatusName          
     ,E.LatestQuotationID          
     ,E.LatestItineraryID          
     ,E.B2B_B2C          
     ,E.FIT_GIT               ,E.EnquiryLost          
     ,E.Department          
     ,(          
     SELECT STRING_AGG(D.Dept_Name, ', ')          
     FROM Department D          
     WHERE EXISTS (          
      SELECT 1          
      FROM STRING_SPLIT(E.Department, ',') s          
   WHERE TRY_CAST(s.value AS INT) = D.ID          
      )          
     ) AS DepartmentName          
     ,E.BizVertical          
     ,(          
     SELECT STRING_AGG(BM.BusinessModuleName, ', ')          
     FROM BusinessMaster BM          
     WHERE EXISTS (          
      SELECT 1          
FROM STRING_SPLIT(E.BizVertical, ',') s          
      WHERE TRY_CAST(s.value AS INT) = BM.BussinessModuleID          
      )          
     ) AS BizVerticalName          
     ,E.TamSales          
     ,E.BigBilling_ImpAgentClient          
     ,E.TravelType          
     ,C.ID AS TravellingFrom          
     ,E.TravellingDestinations          
     ,E.ExpectedTravelStartDate          
     ,E.ExpectedTravelNights          
     ,E.ExpectedTravelEndDate          
     ,E.PAX          
     ,E.Adults          
     ,E.Children          
     ,E.AdditionalNotes          
     ,E.PreferredHotelCategory          
     ,E.RoomCounts          
     ,E.OtherRelatedServices          
     ,N.ID AS NationalityID          
     ,E.Budget          
     ,AM.AgentName          
     ,CM.CID AS ClientID          
     ,CM.Fullname AS ClientName          
     ,E.Agent_Staff_Name AS AgentStaffName          
     ,E.BookersName          
     --,E.ClientId          
     ,E.bigbilling          
     ,AM.AgentID          
     ,E.PhoneNo          
     ,E.Email          
     ,E.Description          
     ,E.Reference          
     ,E.ReassignTo          
     ,EM.EmpName AS ReassigTonName         
     ,CASE         
      WHEN QM.STATUS = 2        
       THEN CONCAT (        
         'D-'        
         ,QM.QuotationNo        
         )        
      WHEN QM.STATUS = 0        
       THEN ''        
      ELSE QM.QuotationNo        
     END  as strLatestQuotationID        
    FROM tbl_Enquiry E          
    LEFT JOIN AgentMaster AM ON AM.AgentID = E.AgentID          
    LEFT JOIN Nationality N ON N.ID = E.Nationality          
    LEFT JOIN City C ON C.ID = E.TravellingFrom          
    LEFT JOIN Customer CM ON CM.CID = E.ClientId          
    LEFT JOIN EmployeeMaster EM ON EM.UserID = E.ReassignTo          
    LEFT JOIN tbl_Enquiry_Status ES ON E.StatusId = ES.StatusID          
    LEFT jOIN Quotation.QuotationMaster QM ON E.EQID=QM.EnquiryID        
    WHERE         
    (          
    @EQID IS NULL          
    OR @EQID = 0          
    OR E.EQID = @EQID          
    )          
    AND         
    --(          
    --@AgentID IS NULL          
    --OR @AgentID = 0          
    --OR @AgentID = AM.AgentID          
    --)          
    --AND        
    (          
    @Department IS NULL          
    OR @Department = ''          
    OR EXISTS (          
     SELECT 1          
     FROM STRING_SPLIT(@Department, ',') s          
     WHERE s.value IN (          
     SELECT value          
     FROM STRING_SPLIT(E.Department, ',')          
     )          
     )          
    )          
    AND (          
    @BizVertical IS NULL          
    OR @BizVertical = ''          
    OR EXISTS (          
     SELECT 1          
     FROM STRING_SPLIT(@BizVertical, ',') s          
     WHERE s.value IN (          
     SELECT value          
     FROM STRING_SPLIT(E.BizVertical, ',')          
     )          
     )          
    )          
    AND (          
    @Nationality IS NULL          
    OR @Nationality = 0          
    OR @Nationality = N.ID          
    )          
    --AND (          
    --@ClientId IS NULL          
    --OR @ClientId = 0          
    --OR @ClientId = CM.CID          
    --)          
    --AND E.EnquiryID LIKE '%' + @EnquiryID + '%'          
    AND(isnull(@EnquiryID,'')='' OR E.EnquiryID = @EnquiryID)        
    --AND (          
    --@OperationBy IS NULL          
    --OR E.ReassignTo IN (              -- SELECT UserID          
    -- FROM FN_LoggedInHierarchy(@OperationBy)          
    -- )          
    --)          
    AND((@YearID IS null) or (E.YearID=@YearID) OR (@YearID=0))          
    AND((@CompanyID IS null) or (E.CompanyID=@CompanyID) OR (@CompanyID =0))          
    AND((@OperationBy IS null) or (E.CreatedBy=@OperationBy))        
    AND((@ExpectedTravelStartDate IS NULL) OR (E.ExpectedTravelStartDate=@ExpectedTravelStartDate))        
    --AND((ISNULL(@LatestQuotationID,0)=0) OR (E.LatestQuotationID=@LatestQuotationID))        
    AND((@bigbilling IS null) OR (E.bigbilling=@bigbilling))        
    --AND(ISNULL(@StatusID,0)=0 OR (E.StatusID=@StatusID))        
    AND (ISNULL(@ReassigTonName,'')='' OR (EM.EmpName=@ReassigTonName))        
    --AND (ISNULL(@strLatestQuotationID,'')='' OR (QM.QuotationNo=@strLatestQuotationID))        
    AND (        
     @strLatestQuotationID IS NULL        
     OR @strLatestQuotationID = ''        
     OR (        
      -- Normalize both sides for matching        
      'D-' + CAST(QM.QuotationNo AS NVARCHAR) LIKE '%' + @strLatestQuotationID + '%'        
      OR CAST(QM.QuotationNo AS NVARCHAR) LIKE '%' + @strLatestQuotationID + '%'        
      )        
     )        
    AND (ISNULL(@AgentName,'')='' OR (AM.AgentName=@AgentName))        
    AND (ISNULL(@CustomerName,'')='' OR (CM.Fullname=@CustomerName))        
    AND (      
   ISNULL(@StatusName,'')=''       
   OR (ES.StatusDescription IN (SELECT items from dbo.Split(@StatusName,',')))      
  )        
    AND (          
    @OperationBy IS NULL          
    OR E.ReassignTo IN (          
     SELECT UserID          
     FROM FN_LoggedInHierarchy(@OperationBy)          
     )          
    )          
  ) as a)        
          
          
  SELECT         
   DISTINCT        
   E.EQID          
   ,E.EnquiryID          
   ,E.CreatedDateTime          
   ,E.UpdatedDateTime          
   ,E.CreatedBy          
   ,E.UpdatedBy          
   ,E.StatusID          
   ,ES.StatusDescription AS StatusName          
   ,E.LatestQuotationID          
   ,E.LatestItineraryID          
   ,E.B2B_B2C          
   ,E.FIT_GIT          
   ,E.EnquiryLost          
   ,E.Department          
   ,(          
   SELECT STRING_AGG(D.Dept_Name, ', ')          
   FROM Department D          
   WHERE EXISTS (          
    SELECT 1          
    FROM STRING_SPLIT(E.Department, ',') s          
    WHERE TRY_CAST(s.value AS INT) = D.ID          
    )          
   ) AS DepartmentName          
   ,E.BizVertical          
   ,(          
   SELECT STRING_AGG(BM.BusinessModuleName, ', ')          
   FROM BusinessMaster BM          
   WHERE EXISTS (          
    SELECT 1          
    FROM STRING_SPLIT(E.BizVertical, ',') s          
    WHERE TRY_CAST(s.value AS INT) = BM.BussinessModuleID          
    )          
   ) AS BizVerticalName          
   ,E.TamSales          
   ,E.BigBilling_ImpAgentClient          
   ,E.TravelType          
   ,C.ID AS TravellingFrom          
   ,E.TravellingDestinations          
   ,E.ExpectedTravelStartDate          
   ,E.ExpectedTravelNights          
   ,E.ExpectedTravelEndDate          
   ,E.PAX          
   ,E.Adults          
   ,E.Children          
   ,E.AdditionalNotes          
   ,E.PreferredHotelCategory          
   ,E.RoomCounts          
   ,E.OtherRelatedServices          
   ,N.ID AS NationalityID          
   ,E.Budget          
   ,AM.AgentName          
   ,CM.CID AS ClientID          
   ,CM.Fullname AS ClientName          
   ,E.Agent_Staff_Name AS AgentStaffName          
   ,E.BookersName          
   ,E.ClientId          
   ,E.bigbilling          
   ,AM.AgentID          
   ,E.PhoneNo          
   ,E.Email          
   ,E.Description          
   ,E.Reference          
   ,E.ReassignTo          
   ,EM.EmpName AS ReassigTonName          
   ,CASE         
    WHEN QM.STATUS = 2        
     THEN CONCAT (        
       'D-'        
       ,QM.QuotationNo        
       )        
    WHEN QM.STATUS = 0        
     THEN ''        
    ELSE QM.QuotationNo       
   END  as strLatestQuotationID        
  FROM tbl_Enquiry E          
  LEFT JOIN AgentMaster AM ON AM.AgentID = E.AgentID          
  LEFT JOIN Nationality N ON N.ID = E.Nationality          
  LEFT JOIN City C ON C.ID = E.TravellingFrom          
  LEFT JOIN Customer CM ON CM.CID = E.ClientId          
  LEFT JOIN EmployeeMaster EM ON EM.UserID = E.ReassignTo          
  LEFT JOIN tbl_Enquiry_Status ES ON E.StatusId = ES.StatusID          
  LEFT jOIN Quotation.QuotationMaster QM ON E.LatestQuotationID=QM.QuotationID        
  WHERE         
  (          
  @EQID IS NULL          
  OR @EQID = 0          
  OR E.EQID = @EQID          
  )          
  AND         
  --(          
  --@AgentID IS NULL          
  --OR @AgentID = 0          
  --OR @AgentID = AM.AgentID          
  --)          
  --AND        
  (          
  @Department IS NULL          
  OR @Department = ''          
  OR EXISTS (          
   SELECT 1          
   FROM STRING_SPLIT(@Department, ',') s          
   WHERE s.value IN (          
   SELECT value          
   FROM STRING_SPLIT(E.Department, ',')          
   )          
   )          
  )          
  AND (          
  @BizVertical IS NULL          
  OR @BizVertical = ''          
  OR EXISTS (          
   SELECT 1          
   FROM STRING_SPLIT(@BizVertical, ',') s          
   WHERE s.value IN (          
   SELECT value          
   FROM STRING_SPLIT(E.BizVertical, ',')          
   )          
   )          
  )          
  AND (          
  @Nationality IS NULL          
  OR @Nationality = 0          
  OR @Nationality = N.ID          
  )          
  --AND (          
  --@ClientId IS NULL          
  --OR @ClientId = 0          
  --OR @ClientId = CM.CID          
  --)          
  --AND E.EnquiryID LIKE '%' + @EnquiryID + '%'          
  AND(isnull(@EnquiryID,'')='' OR E.EnquiryID = @EnquiryID)        
  --AND (          
  --@OperationBy IS NULL          
  --OR E.ReassignTo IN (          
  -- SELECT UserID          
  -- FROM FN_LoggedInHierarchy(@OperationBy)          
  -- )          
  --)          
  AND((@YearID IS null) or (E.YearID=@YearID) OR (@YearID=0))          
  AND((@CompanyID IS null) or (E.CompanyID=@CompanyID) OR (@CompanyID =0))          
  AND((@OperationBy IS null) or (E.CreatedBy=@OperationBy))         
  AND((@ExpectedTravelStartDate IS NULL) OR (E.ExpectedTravelStartDate=@ExpectedTravelStartDate))        
  AND((ISNULL(@LatestQuotationID,0)=0) OR (E.LatestQuotationID=@LatestQuotationID))        
  AND((@bigbilling IS NULL) OR (E.bigbilling=@bigbilling))        
  --AND(ISNULL(@StatusID,0)=0 OR (E.StatusID=@StatusID))        
  AND (ISNULL(@ReassigTonName,'')='' OR (EM.EmpName=@ReassigTonName))        
  --AND (ISNULL(@strLatestQuotationID,'')='' OR (QM.QuotationNo=@strLatestQuotationID))        
  AND (        
   @strLatestQuotationID IS NULL        
   OR @strLatestQuotationID = ''        
   OR (        
    -- Normalize both sides for matching        
    'D-' + CAST(QM.QuotationNo AS NVARCHAR) LIKE '%' + @strLatestQuotationID + '%'        
    OR CAST(QM.QuotationNo AS NVARCHAR) LIKE '%' + @strLatestQuotationID + '%'        
    )        
   )        
  AND (ISNULL(@AgentName,'')='' OR (AM.AgentName=@AgentName))        
  AND (ISNULL(@CustomerName,'')='' OR (CM.Fullname=@CustomerName))        
AND (      
  ISNULL(@StatusName,'')=''       
  OR (ES.StatusDescription IN (SELECT items from dbo.Split(@StatusName,',')))      
 )         
  AND (          
  @OperationBy IS NULL          
  OR E.ReassignTo IN (          
   SELECT UserID          
   FROM FN_LoggedInHierarchy(@OperationBy)          
   )          
  )          
  ORDER BY E.EQID DESC        
  OFFSET @PageNumber * @Row_Count ROWS        
  FETCH NEXT @Row_Count ROWS ONLY;        
        
  SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count, '200' AS returnCode, 'Data Found' AS returnMessage;        
  END          
 END          
 ELSE IF @Action='S'        
 BEGIN        
  SELECT         
   DISTINCT        
   E.EQID          
   ,E.EnquiryID          
   ,E.CreatedDateTime          
   ,E.UpdatedDateTime          
   ,E.CreatedBy          
   ,E.UpdatedBy          
   ,E.StatusID          
   ,ES.StatusDescription AS StatusName          
   ,E.LatestQuotationID          
   ,E.LatestItineraryID          
   ,E.B2B_B2C          
   ,E.FIT_GIT          
   ,E.EnquiryLost          
   ,E.Department          
   ,(          
   SELECT STRING_AGG(D.Dept_Name, ', ')          
   FROM Department D          
   WHERE EXISTS (          
    SELECT 1          
    FROM STRING_SPLIT(E.Department, ',') s          
    WHERE TRY_CAST(s.value AS INT) = D.ID          
    )          
   ) AS DepartmentName          
   ,E.BizVertical          
   ,(          
   SELECT STRING_AGG(BM.BusinessModuleName, ', ')          
   FROM BusinessMaster BM          
   WHERE EXISTS (          
    SELECT 1          
    FROM STRING_SPLIT(E.BizVertical, ',') s          
    WHERE TRY_CAST(s.value AS INT) = BM.BussinessModuleID          
    )          
   ) AS BizVerticalName           ,E.TamSales          
   ,E.BigBilling_ImpAgentClient          
   ,E.TravelType          
   ,C.ID AS TravellingFrom          
   ,E.TravellingDestinations          
   ,E.ExpectedTravelStartDate          
   ,E.ExpectedTravelNights          
   ,E.ExpectedTravelEndDate          
   ,E.PAX          
   ,E.Adults          
   ,E.Children          
   ,E.AdditionalNotes          
   ,E.PreferredHotelCategory          
   ,E.RoomCounts          
   ,E.OtherRelatedServices          
   ,N.ID AS NationalityID          
   ,E.Budget          
   ,AM.AgentName          
   ,CM.CID AS ClientID          
   ,CM.Fullname AS ClientName          
   ,E.Agent_Staff_Name AS AgentStaffName          
   ,E.BookersName          
   ,E.ClientId          
   ,E.bigbilling          
   ,AM.AgentID          
   ,E.PhoneNo          
   ,E.Email          
   ,E.Description          
   ,E.Reference          
   ,E.ReassignTo          
   ,EM.EmpName AS ReassigTonName          
  FROM tbl_Enquiry E          
  LEFT JOIN AgentMaster AM ON AM.AgentID = E.AgentID          
  LEFT JOIN Nationality N ON N.ID = E.Nationality          
  LEFT JOIN City C ON C.ID = E.TravellingFrom          
  LEFT JOIN Customer CM ON CM.CID = E.ClientId          
  LEFT JOIN EmployeeMaster EM ON EM.UserID = E.ReassignTo          
  LEFT JOIN tbl_Enquiry_Status ES ON E.StatusId = ES.StatusID          
  WHERE (          
  @EQID IS NULL          
  OR @EQID = 0          
  OR E.EQID = @EQID          
  )          
  AND (          
  @AgentID IS NULL          
  OR @AgentID = 0          
  OR @AgentID = AM.AgentID          
  )          
  AND (          
  @Department IS NULL          
  OR @Department = ''          
  OR EXISTS (          
   SELECT 1          
   FROM STRING_SPLIT(@Department, ',') s          
   WHERE s.value IN (          
   SELECT value          
   FROM STRING_SPLIT(E.Department, ',')          
   )          
   )          
  )          
  AND (          
  @BizVertical IS NULL          
  OR @BizVertical = ''          
  OR EXISTS (          
   SELECT 1          
   FROM STRING_SPLIT(@BizVertical, ',') s          
   WHERE s.value IN (          
   SELECT value          
   FROM STRING_SPLIT(E.BizVertical, ',')          
   )          
   )          
  )          
  AND (          
  @Nationality IS NULL          
  OR @Nationality = 0          
  OR @Nationality = N.ID          
  )          
  AND (          
  @ClientId IS NULL          
  OR @ClientId = 0          
  OR @ClientId = CM.CID          
  )          
  AND E.EnquiryID LIKE '%' + @EnquiryID + '%'          
  AND (          
  @OperationBy IS NULL          
  OR E.ReassignTo IN (          
   SELECT UserID          
   FROM FN_LoggedInHierarchy(@OperationBy)          
   )          
  )          
  AND((@YearID IS null) or (E.YearID=@YearID) OR (@YearID=0))          
  AND((@CompanyID IS null) or (E.CompanyID=@CompanyID) OR (@CompanyID =0))          
  AND((@OperationBy IS null) or (E.CreatedBy=@OperationBy))         
  ORDER BY E.EQID DESC        
 END        
   -- EXPORT            
 ELSE IF @Action = 'EX'     
 BEGIN          
  SELECT E.EnquiryID          
   ,E.CreatedDateTime          
   ,CASE           
    WHEN E.B2B_B2C = 1          
     THEN 'Yes'          
    ELSE 'No'          
    END AS B2B_B2C          
   ,CASE           
    WHEN E.FIT_GIT = 1          
     THEN 'Yes'          
    ELSE 'No'          
    END AS FIT_GIT          
   ,CASE           
    WHEN E.EnquiryLost = 1          
     THEN 'Yes'          
    ELSE 'No'          
    END AS EnquiryLost          
   ,E.LatestQuotationID          
   ,E.LatestItineraryID          
   ,E.BigBilling_ImpAgentClient          
   ,E.TravelType          
   ,E.ExpectedTravelStartDate          
   ,E.ExpectedTravelNights          
   ,E.ExpectedTravelEndDate          
   ,E.PAX          
   ,E.Adults          
   ,E.Children          
   ,E.AdditionalNotes          
   ,E.PreferredHotelCategory          
   ,E.RoomCounts          
   ,E.OtherRelatedServices          
   ,E.Budget          
   ,AM.AgentName          
   ,CM.Fullname AS ClientName          
   ,E.Agent_Staff_Name AS AgentStaffName          
   ,E.BookersName          
   ,CASE           
    WHEN E.bigbilling = 1          
     THEN 'Yes'          
    ELSE 'No'          
    END AS bigbilling          
   ,E.PhoneNo          
   ,E.Email          
   ,E.Description          
   ,E.Reference          
   ,E.ReassignTo          
   ,EM.EmpName AS ReassignToName          
   ,ES.StatusDescription AS StatusName          
  FROM tbl_Enquiry E          
  LEFT JOIN AgentMaster AM ON AM.AgentID = E.AgentID          
  LEFT JOIN Nationality N ON N.ID = E.Nationality          
  LEFT JOIN BusinessMaster BM ON BM.BussinessModuleID = E.BizVertical          
  LEFT JOIN City C ON C.ID = E.TravellingFrom          
  LEFT JOIN Customer CM ON CM.CID = E.ClientId          
  LEFT JOIN EmployeeMaster EM ON EM.UserID = E.ReassignTo          
  LEFT JOIN tbl_Enquiry_Status ES ON E.StatusId = ES.StatusID          
  WHERE (          
    @EQID IS NULL          
    OR @EQID = 0          
    OR E.EQID = @EQID          
    )          
   AND (          
    @AgentID IS NULL          
    OR @AgentID = 0          
    OR @AgentID = AM.AgentID          
    )          
   AND (          
    @Department IS NULL          
    OR @Department = ''          
    OR @Department = E.Department          
    )          
   AND (          
    @BizVertical IS NULL          
    OR @BizVertical = ''          
    OR @BizVertical = E.BizVertical          
    )          
   AND (          
    @Nationality IS NULL          
    OR @Nationality = 0          
    OR @Nationality = N.ID          
    )          
   AND (          
    @ClientId IS NULL          
    OR @ClientId = 0          
    OR @ClientId = CM.CID          
    )          
  ORDER BY E.EQID DESC;          
 END          
   -- FOLLOW UP SECTION            
 ELSE IF @Action = 'F'          
 BEGIN          
  SELECT *          
  FROM TBL_Follow_Up_Section;          
 END          
   -- INSERT DRAFT            
 ELSE IF @Action = 'I'          
  AND @IsDraft = 1          
 BEGIN          
  INSERT INTO tbl_Enquiry (          
   EnquiryID          
   ,CreatedDateTime          
   ,CreatedBy          
   ,StatusID          
   ,LatestQuotationID          
   ,LatestItineraryID          
   ,B2B_B2C          
   ,FIT_GIT          
   ,EnquiryLost          
   ,Department          
   ,BizVertical          
   ,TamSales          
   ,BigBilling_ImpAgentClient          
   ,TravelType          
   ,TravellingFrom          
   ,TravellingDestinations          
   ,ExpectedTravelStartDate          
   ,ExpectedTravelNights          
   ,ExpectedTravelEndDate          
   ,PAX          
   ,Adults          
   ,Children          
   ,AdditionalNotes          
   ,PreferredHotelCategory          
   ,RoomCounts          
   ,OtherRelatedServices          
   ,Nationality          
   ,Budget          
   ,AgentID          
   ,Agent_Staff_Name          
   ,BookersName          
   ,ClientId          
   ,bigbilling          
   ,Reference          
   ,Email          
   ,PhoneNo          
   ,Description          
   ,ReassignTo          
   ,IsDraft          
   ,CompanyID          
   ,YearID          
   )          
  VALUES (          
   @EnquiryID          
   ,GETDATE()          
   ,@OperationBy          
   ,@StatusID          
   ,@LatestQuotationID          
   ,@LatestItineraryID          
   ,ISNULL(@B2B_B2C, 0)          
   ,ISNULL(@FIT_GIT, 0)          
   ,ISNULL(@EnquiryLost, 0)          
   ,@Department          
   ,@BizVertical          
   ,@TamSales          
   ,@BigBilling_ImpAgentClient          
   ,ISNULL(@TravelType, 'PerNighter')          
   ,@TravellingFrom          
   ,@TravellingDestinations          
   ,@ExpectedTravelStartDate          
   ,@ExpectedTravelNights          
   ,@ExpectedTravelEndDate          
   ,@PAX          
   ,@Adults          
   ,@Children          
   ,@AdditionalNotes          
   ,@PreferredHotelCategory          
   ,@RoomCounts          
   ,@OtherRelatedServices          
   ,@Nationality          
   ,@Budget          
   ,@AgentID          
   ,@AgentStaffName          
   ,@BookersName          
   ,@ClientId          
   ,@bigbilling          
   ,@Reference          
   ,@Email          
   ,@PhoneNo          
   ,@Description          
   ,@ReassignTo          
   ,@IsDraft          
   ,@CompanyID          
   ,@YearID          
   );          
          
  SET @LogID = SCOPE_IDENTITY();          
  SET @ID = @LogID;          
          
  SELECT '200' AS returnCode          
   ,'Draft saved successfully.' AS returnMessage          
   ,@LogID AS ID;          
 END          
   -- INSERT NON-DRAFT            
 ELSE IF @Action = 'I'          
  AND @IsDraft = 0          
 BEGIN          
  --SET @EnquiryID = 'ENQ' + RIGHT('00000' + CAST(ISNULL((SELECT ENQID FROM tbl_Counter) + 1, 1) AS VARCHAR(10)), 5);            
  --UPDATE tbl_Counter SET ENQID = CAST(RIGHT(@EnquiryID, 5) AS BIGINT), UpdationDate = GETDATE();            
  SET @EnquiryID = @Prefix + (CASE           
    WHEN @IsSysGenEnquiry = 0          
     THEN RIGHT('000000' + CAST((          
         SELECT ISNULL(ENQID, 0) + 1          
         FROM tbl_Counter          
         ) AS VARCHAR(10)), 6)          
    ELSE RIGHT('000000' + CAST((          
        SELECT ISNULL(ENQSYSID, 0) + 1          
        FROM tbl_Counter          
        ) AS VARCHAR(10)), 6)          
    END)          
          
  IF (@IsSysGenEnquiry = 0)          
  BEGIN          
   UPDATE tbl_Counter          
   SET ENQID = CAST(RIGHT(@EnquiryID, 6) AS BIGINT)          
    ,UpdationDate = GETDATE()          
  END          
  ELSE          
  BEGIN          
   UPDATE tbl_Counter          
   SET ENQSYSID = CAST(RIGHT(@EnquiryID, 6) AS BIGINT)          
    ,UpdationDate = GETDATE()          
  END          
          
  INSERT INTO tbl_Enquiry (          
   EnquiryID          
   ,CreatedDateTime          
   ,CreatedBy          
   ,StatusID          
   ,LatestQuotationID          
   ,LatestItineraryID          
   ,B2B_B2C          
   ,FIT_GIT          
   ,EnquiryLost          
   ,Department          
   ,BizVertical          
   ,TamSales          
   ,BigBilling_ImpAgentClient          
   ,TravelType          
   ,TravellingFrom          
   ,TravellingDestinations          
   ,ExpectedTravelStartDate          
   ,ExpectedTravelNights          
   ,ExpectedTravelEndDate          
   ,PAX          
   ,Adults          
   ,Children          
   ,AdditionalNotes          
   ,PreferredHotelCategory          
   ,RoomCounts          
   ,OtherRelatedServices          
   ,Nationality          
   ,Budget          
   ,AgentID          
   ,Agent_Staff_Name          
   ,BookersName          
   ,ClientId          
   ,bigbilling          
   ,Reference          
   ,Email          
   ,PhoneNo          
   ,Description          
   ,ReassignTo          
   ,IsDraft          
   ,IsSysGenEnquiry          
   ,CompanyID          
   ,YearID          
          
   )          
  VALUES (          
   @EnquiryID          
   ,GETDATE()          
   ,@OperationBy          
   ,@StatusID          
   ,@LatestQuotationID          
   ,@LatestItineraryID          
   ,ISNULL(@B2B_B2C, 0)          
   ,ISNULL(@FIT_GIT, 0)          
   ,ISNULL(@EnquiryLost, 0)          
   ,@Department          
   ,@BizVertical          
   ,@TamSales          
   ,@BigBilling_ImpAgentClient          
   ,ISNULL(@TravelType, 'PerNighter')          
   ,@TravellingFrom          
   ,@TravellingDestinations          
   ,@ExpectedTravelStartDate          
   ,@ExpectedTravelNights          
   ,@ExpectedTravelEndDate          
   ,@PAX          
   ,@Adults          
   ,@Children          
   ,@AdditionalNotes          
   ,@PreferredHotelCategory          
   ,@RoomCounts          
   ,@OtherRelatedServices          
   ,@Nationality          
   ,@Budget          
   ,@AgentID          
   ,@AgentStaffName          
   ,@BookersName          
   ,@ClientId          
   ,@bigbilling          
   ,@Reference          
   ,@Email          
   ,@PhoneNo          
   ,@Description          
   ,@ReassignTo          
   ,@IsDraft          
   ,@IsSysGenEnquiry          
   ,@CompanyID          
   ,@YearID          
          
   );          
          
  SET @LogID = SCOPE_IDENTITY();          
  SET @ID = @LogID;          
          
  SELECT '200' AS returnCode          
   ,@EnquiryID + ' created successfully.' AS returnMessage          
   ,@LogID AS ID;          
 END          
 ELSE IF (          
   @Action = 'U'          
   AND @IsDraft = 0          
   AND @EnquiryID IS NULL          
   )          
 BEGIN          
  --SET @EnquiryID = 'ENQ' + RIGHT('00000' + CAST((          
  --    SELECT ISNULL(ENQID, 0) + 1          
  --    FROM tbl_Counter          
  --    ) AS VARCHAR(10)), 5)      
        
  SET @EnquiryID = @Prefix + ( RIGHT('000000' + CAST((          
        SELECT ISNULL(ENQID, 0) + 1          
        FROM tbl_Counter          
        ) AS VARCHAR(10)), 6)  )      
          
  UPDATE tbl_Counter          
  SET ENQID = CAST(RIGHT(@EnquiryID, 6) AS BIGINT)          
   ,UpdationDate = GETDATE()          
          
  UPDATE [dbo].[tbl_Enquiry]          
  SET [EnquiryID] = @EnquiryID          
   ,[UpdatedDateTime] = GETDATE()          
   ,[UpdatedBy] = GETDATE()          
   ,[StatusID] = ISNULL(@StatusID, [StatusID])          
   ,[LatestQuotationID] = ISNULL(@LatestQuotationID, [LatestQuotationID])          
   ,[LatestItineraryID] = ISNULL(@LatestItineraryID, [LatestItineraryID])          
   ,[B2B_B2C] = ISNULL(@B2B_B2C, [B2B_B2C])          
   ,[FIT_GIT] = ISNULL(@FIT_GIT, [FIT_GIT])          
   ,[EnquiryLost] = ISNULL(@EnquiryLost, [EnquiryLost])          
   ,[Department] = ISNULL(@Department, [Department])          
   ,[BizVertical] = ISNULL(@BizVertical, [BizVertical])          
   ,[TamSales] = ISNULL(@TamSales, [TamSales])          
   ,[BigBilling_ImpAgentClient] = ISNULL(@BigBilling_ImpAgentClient, [BigBilling_ImpAgentClient])          
   ,[TravelType] = ISNULL(@TravelType, [TravelType])          
   ,[TravellingFrom] = @TravellingFrom          
   ,[TravellingDestinations] = ISNULL(@TravellingDestinations, [TravellingDestinations])          
   ,[ExpectedTravelStartDate] = ISNULL(@ExpectedTravelStartDate, [ExpectedTravelStartDate])          
   ,[ExpectedTravelNights] = ISNULL(@ExpectedTravelNights, [ExpectedTravelNights])          
   ,[ExpectedTravelEndDate] = ISNULL(@ExpectedTravelEndDate, [ExpectedTravelEndDate])          
   ,[PAX] = ISNULL(@PAX, [PAX])          
   ,[Adults] = ISNULL(@Adults, [Adults])          
   ,[Children] = ISNULL(@Children, [Children])          
   ,[AdditionalNotes] = ISNULL(@AdditionalNotes, [AdditionalNotes])          
   ,[PreferredHotelCategory] = @PreferredHotelCategory          
   ,[RoomCounts] = ISNULL(@RoomCounts, [RoomCounts])          
   ,[OtherRelatedServices] = @OtherRelatedServices          
   ,[Nationality] = ISNULL(@Nationality, [Nationality])          
   ,[Budget] = ISNULL(@Budget, [Budget])          
   ,[AgentID] = ISNULL(@AgentID, [AgentID])          
   ,[Agent_Staff_Name] = ISNULL(@AgentStaffName, [Agent_Staff_Name])          
   ,[BookersName] = ISNULL(@BookersName, [BookersName])          
   ,[ClientId] = ISNULL(@ClientId, [ClientId])          
   ,[bigbilling] = ISNULL(@bigbilling, bigbilling)          
   ,Reference = @Reference          
   ,Email = @Email          
   ,PhoneNo = @PhoneNo          
   ,Description = @Description          
   ,ReassignTo = @ReassignTo          
   ,IsDraft = @IsDraft          
  WHERE [EQID] = @EQID;          
          
  DECLARE @EQIDU VARCHAR(500)          
          
  SELECT @EQIDU = EnquiryID          
  FROM [tbl_Enquiry]          
  WHERE EQID = @EQID          
          
  SELECT '200' AS returnCode          
   ,+ @EQIDU + 'created successfully.' AS returnMessage          
   ,@EQID AS ID;          
 END -- UPDATE WITOUT DRAFT                            
 ELSE IF (          
   @Action = 'U'          
   AND @IsDraft = 1          
   )          
 BEGIN          
  UPDATE [dbo].[tbl_Enquiry]          
  SET [EnquiryID] = @EnquiryID          
   ,[UpdatedDateTime] = GETDATE()          
   ,[UpdatedBy] = GETDATE()          
   ,[StatusID] = ISNULL(@StatusID, [StatusID])          
   ,          
   --[LatestQuotationID] = ISNULL(@LatestQuotationID, [LatestQuotationID]),                                                                                    
   -- [LatestItineraryID] = ISNULL(@LatestItineraryID, [LatestItineraryID]),                                                                                    
   [B2B_B2C] = ISNULL(@B2B_B2C, [B2B_B2C])          
   ,[FIT_GIT] = ISNULL(@FIT_GIT, [FIT_GIT])          
   ,[EnquiryLost] = ISNULL(@EnquiryLost, [EnquiryLost])          
   ,[Department] = ISNULL(@Department, [Department])          
   ,[BizVertical] = ISNULL(@BizVertical, [BizVertical])          
   ,[TamSales] = ISNULL(@TamSales, [TamSales])          
   ,[BigBilling_ImpAgentClient] = ISNULL(@BigBilling_ImpAgentClient, [BigBilling_ImpAgentClient])          
   ,[TravelType] = ISNULL(@TravelType, [TravelType])          
   ,[TravellingFrom] = @TravellingFrom          
   ,[TravellingDestinations] = ISNULL(@TravellingDestinations, [TravellingDestinations])          
   ,[ExpectedTravelStartDate] = ISNULL(@ExpectedTravelStartDate, [ExpectedTravelStartDate])          
   ,[ExpectedTravelNights] = ISNULL(@ExpectedTravelNights, [ExpectedTravelNights])          
   ,[ExpectedTravelEndDate] = ISNULL(@ExpectedTravelEndDate, [ExpectedTravelEndDate])          
   ,[PAX] = ISNULL(@PAX, [PAX])          
   ,[Adults] = ISNULL(@Adults, [Adults])          
   ,[Children] = ISNULL(@Children, [Children])          
   ,[AdditionalNotes] = ISNULL(@AdditionalNotes, [AdditionalNotes])          
   ,[PreferredHotelCategory] = @PreferredHotelCategory          
   ,[RoomCounts] = ISNULL(@RoomCounts, [RoomCounts])          
   ,[OtherRelatedServices] = @OtherRelatedServices          
   ,[Nationality] = ISNULL(@Nationality, [Nationality])          
   ,[Budget] = ISNULL(@Budget, [Budget])          
   ,[AgentID] = @AgentID          
   ,[Agent_Staff_Name] = @AgentStaffName          
   ,[BookersName] = @BookersName          
   ,[ClientId] = @ClientId          
   ,[bigbilling] = @bigbilling          
   ,Reference = @Reference          
   ,Email = @Email          
   ,PhoneNo = @PhoneNo          
   ,Description = @Description          
   ,ReassignTo = @ReassignTo          
   ,IsDraft = @IsDraft          
  WHERE [EQID] = @EQID;          
          
  SELECT '200' AS returnCode          
   ,' Draft updated successfully.' AS returnMessage          
   ,@EQID AS ID;          
 END          
 ELSE IF (          
   @Action = 'U'          
   AND @IsDraft = 0          
   AND @EnquiryID IS NOT NULL          
   )          
 BEGIN          
  UPDATE [dbo].[tbl_Enquiry]          
  SET [EnquiryID] = @EnquiryID          
   ,[UpdatedDateTime] = GETDATE()          
   ,[UpdatedBy] = GETDATE()          
   ,[StatusID] = ISNULL(@StatusID, [StatusID])          
   ,[LatestQuotationID] = ISNULL(@LatestQuotationID, [LatestQuotationID])          
   ,[LatestItineraryID] = ISNULL(@LatestItineraryID, [LatestItineraryID])          
   ,[B2B_B2C] = ISNULL(@B2B_B2C, [B2B_B2C])          
   ,[FIT_GIT] = ISNULL(@FIT_GIT, [FIT_GIT])          
   ,[EnquiryLost] = ISNULL(@EnquiryLost, [EnquiryLost])          
   ,[Department] = ISNULL(@Department, [Department])          
   ,[BizVertical] = ISNULL(@BizVertical, [BizVertical])          
   ,[TamSales] = ISNULL(@TamSales, [TamSales])          
   ,[BigBilling_ImpAgentClient] = ISNULL(@BigBilling_ImpAgentClient, [BigBilling_ImpAgentClient])          
   ,[TravelType] = ISNULL(@TravelType, [TravelType])          
   ,[TravellingFrom] = @TravellingFrom          
   ,[TravellingDestinations] = ISNULL(@TravellingDestinations, [TravellingDestinations])          
   ,[ExpectedTravelStartDate] = ISNULL(@ExpectedTravelStartDate, [ExpectedTravelStartDate])          
   ,[ExpectedTravelNights] = ISNULL(@ExpectedTravelNights, [ExpectedTravelNights])          
   ,[ExpectedTravelEndDate] = ISNULL(@ExpectedTravelEndDate, [ExpectedTravelEndDate])          
   ,[PAX] = ISNULL(@PAX, [PAX])          
   ,[Adults] = ISNULL(@Adults, [Adults])          
   ,[Children] = ISNULL(@Children, [Children])          
   ,[AdditionalNotes] = ISNULL(@AdditionalNotes, [AdditionalNotes])          
   ,[PreferredHotelCategory] = @PreferredHotelCategory          
   ,[RoomCounts] = ISNULL(@RoomCounts, [RoomCounts])          
   ,[OtherRelatedServices] = @OtherRelatedServices          
   ,[Nationality] = ISNULL(@Nationality, [Nationality])          
   ,[Budget] = ISNULL(@Budget, [Budget])          
   ,[AgentID] = ISNULL(@AgentID, [AgentID])          
   ,[Agent_Staff_Name] = ISNULL(@AgentStaffName, [Agent_Staff_Name])          
   ,[BookersName] = ISNULL(@BookersName, [BookersName])          
   ,[ClientId] = ISNULL(@ClientId, [ClientId])          
   ,[bigbilling] = ISNULL(@bigbilling, bigbilling)          
   ,Reference = @Reference          
   ,Email = @Email          
   ,PhoneNo = @PhoneNo          
   ,Description = @Description          
   ,ReassignTo = @ReassignTo          
   ,IsDraft = @IsDraft          
  WHERE [EQID] = @EQID;          
          
  SELECT '200' AS returnCode          
   ,'Updated successfully.' AS returnMessage          
   ,@EQID AS ID;          
 END -- UPDATE WITOUT DRAFT             
END