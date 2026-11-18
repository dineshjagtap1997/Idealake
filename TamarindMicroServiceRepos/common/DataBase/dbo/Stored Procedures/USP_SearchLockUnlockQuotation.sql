    
CREATE PROCEDURE [dbo].[USP_SearchLockUnlockQuotation] --'1','2012-07-05','2012-07-05',null,1,18      
@ISLocked VARCHAR(10)=null,      
@FromDate DATETIME=null,      
@ToDate DATETIME=null,      
@FileCode VARCHAR(50)=null,      
@CompID VARCHAR(10),      
@YearID VARCHAR(10)      
AS      
BEGIN      
SELECT AM.AgentName,QuotationNo,FileCode,CustomerName,      
 CASE WHEN Q.Origin=1 THEN 'Offline' ELSE 'Online'END AS [Source],      
convert(VARCHAR(55),TravelDateFrom,106) AS 'TravelDateFrom',convert(VARCHAR(55),TravelDateTo,106) AS 'TravelDateTo',    
 CASE WHEN Q.RateCategory=1 THEN 'FIT'                                                    
 WHEN Q.RateCategory=2 THEN 'GIT'                                                    
 WHEN Q.RateCategory=3 THEN 'BOTH' END AS 'RateCategoryT'          
,U.UserName as FHE,QuotationID ,CASE WHEN IsLocked=1 THEN 'Lock' ELSE 'Unlock' END AS 'LockUnlock',    
CASE WHEN IsLocked=1 THEN convert(VARCHAR(55),LockedDate,106)  ELSE '--' END AS 'LockedDate'    
FROM Quotation Q      
 LEFT JOIN AgentMaster AM ON AM.AgentID=Q.AgentID                                         
 INNER Join aspnet_Users U ON Q.OperationBy = U.UserId      
WHERE       
IsLocked=(CASE WHEN @ISLocked IS NOT NULL then @ISLocked ELSE IsLocked END)      
 AND      
convert(VARCHAR,TravelDateTo,112) BETWEEN CASE WHEN isnull(@FromDate,'') <> '' THEN convert(VARCHAR,@FromDate,112) ELSE TravelDateTo END AND      
CASE WHEN isnull(@ToDate,'') <> '' THEN convert(VARCHAR,@ToDate,112) ELSE TravelDateTo END       
AND FileCode=CASE WHEN isnull(@FileCode,'') <> '' THEN @FileCode ELSE FileCode END      
AND IsLocked IS NOT NULL AND FileCode IS NOT NULL      
AND CompanyID=@CompID AND YearID=@YearID      
END