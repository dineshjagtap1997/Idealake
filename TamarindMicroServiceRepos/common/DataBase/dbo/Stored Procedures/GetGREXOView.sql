-- [GetGREXOView] @VendorID=21,@FileCode='IND09020010',@XONo='TINH26000045'  
 -- Pending  SAPUpdatedCode logic as this is not developed   
CREATE PROCEDURE [dbo].[GetGREXOView] @FileCode NVARCHAR(20) = NULL    
 ,@XONo NVARCHAR(15) = NULL    
 ,@VendorID INT    
 ,@dpXOArr DATETIME=NULL    
 ,@dpXOTo DATETIME  =NULL  
AS    
BEGIN    
     
SELECT DISTINCT x.XO_ID    
  , E.EmpName AS FHE    
  ,TB.FileCode    
  ,replace(convert(VARCHAR(11), XO_Date, 106), ' ', '-') AS XO_Date    
  ,XO_Customer_Name    
  ,x.XO_Amt    
  ,x.Curr_ID    
  ,CASE     
   WHEN Undo = 1    
    THEN 'Yes'    
   END AS Undo    
  ,replace(convert(VARCHAR(11), UndoDate, 106), ' ', '-') AS UndoDate    
  ,X.YearCode    
  ,v.VendorID    
  ,v.VendorName    
  ,q.QuotationNo    
  --,QXM.ServiceTypeID    
  ,q.QuotationID    
 -- ,v1.vendorname AS SAPVendorName    
  ,'' AS VendorSAPCode    
  ,x.isChange    
 -- ,e1.Empname    
  ,replace(convert(VARCHAR(11), SAPUpdatedDattime, 106), ' ', '-') AS SAPUpdatedDattime    
 FROM XO(NOLOCK) x    
 INNER JOIN VendorMaster(NOLOCK) v ON  x.VendorCode = v.VendorCode     
 --INNER JOIN VendorMaster(NOLOCK) v1 ON x.SAPUpdatedCode = v1.VendorSAPCode 
 INNER JOIN Booking.tbl_Booking TB ON TB.ID= X.File_ID
 LEFT JOIN Quotation.QuotationMaster q ON tb.QuotationID = Q.QuotationID    
 INNER JOIN EmployeeMaster e ON TB.FHE = e.UserID    
 --LEFT JOIN EmployeeMaster e1 ON x.SAPUpdatedby = e1.UserID    
 --LEFT JOIN QuotationXOMap QXM ON QXM.QuotationID = q.QuotationID    
  --AND QXM.XOID = x.XO_ID  
  where  v.VendorID = @VendorID    
  AND (    
   x.XO_ID = CASE     
    WHEN @XONo IS NOT NULL    
     THEN @XONo    
    ELSE x.XO_ID    
    END    
   ) 
   --AND  
   -- (    
   --XO_ID LIKE 'T%'    
   --OR XO_ID LIKE 'S%'    
   --OR XO_ID LIKE 'G%'    
   --OR XO_ID LIKE 'M%'    
   --)   
    AND (    
   TB.FileCode = CASE     
    WHEN @FileCode IS NOT NULL    
     THEN @FileCode    
    ELSE TB.FileCode    
    END    
   )  
   OR (TB.FileCode = @FileCode or x.XO_ID = @XONo)  
 --WHERE   
    
   
    
 --and (q.FileCode = @FileCode or x.XO_ID = @XONo)          
 ORDER BY TB.FileCode    
    
    
END