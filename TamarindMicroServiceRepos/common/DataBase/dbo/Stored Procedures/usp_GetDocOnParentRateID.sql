CREATE PROCEDURE [dbo].[usp_GetDocOnParentRateID]  --7,2          
(            
 @ParentRateID INT,          
 @ParentRateTypeID TINYINT           
)            
AS              
BEGIN              
 SELECT LD.DocumentID,              
 UD.DocumentName,CONVERT(VARCHAR,UD.UploadedOn,103) as UploadedOn,U.UserName,        
 '<a onclick="javascript:OpenPopup(''../PopupDocs.aspx?Cmd=VD&DocID='+Convert(varchar(50),LD.DocumentID)+''');"        
 style="cursor: pointer; cursor: hand;">Preview</a>' AS Preview        
 FROM LinkedDocuments LD               
 INNER JOIN UploadDocuments UD ON LD.DocumentID=UD.DocumentID                
 INNER JOIN employeemaster U ON U.EmpID=UD.UploadedBy              
 WHERE  (LD.ParentID=@ParentRateID or @ParentRateID is null or @ParentRateID = 0) AND (LD.ParentTypeID=@ParentRateTypeID or @ParentRateTypeID is null or @ParentRateTypeID = 0)
 ORDER BY CAST(UploadedOn AS DATETIME) DESC           
END 