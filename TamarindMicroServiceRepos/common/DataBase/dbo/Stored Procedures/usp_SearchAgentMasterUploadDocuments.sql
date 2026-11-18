         
CREATE PROCEDURE [dbo].[usp_SearchAgentMasterUploadDocuments] 
    @AgentCode varchar(15),
    @AgentID int,
    @DocumentName varchar(100),
    @ParentID int -- New parameter for ParentID
AS  
BEGIN
    SELECT 
        UD.DocumentID,
        DocumentName,
        LD.DocumentLinkID,
        Documents,
        UploadedBy,
        UploadedOn,
        UD.UpdatedBy,
        UD.UpdatedOn,
        AM.AgentCode AS AgentCode,
        AM.AgentName AS AgentName,
        AU.UserName,
        DT.DocumentTypeId,
        DT.DocumentType,
        AU.EmpName
    FROM UploadDocuments UD
    INNER JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID
    LEFT JOIN AgentMaster AM ON AM.AgentID = LD.ParentID
    INNER JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy
    LEFT JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId
    WHERE
        (ISNULL(AM.AgentCode, '') LIKE 
            CASE WHEN @AgentCode IS NOT NULL THEN @AgentCode + '%' ELSE ISNULL(AM.AgentCode, '') END)
    AND (ISNULL(AM.AgentID, '') = 
            CASE WHEN @AgentID IS NOT NULL THEN @AgentID ELSE ISNULL(AM.AgentID, '') END)
    AND (ISNULL(UD.DocumentName, '') LIKE 
            CASE WHEN @DocumentName IS NOT NULL THEN @DocumentName + '%' ELSE ISNULL(UD.DocumentName, '') END)
    AND UD.ParentTypeID = 11
    AND LD.ParentID <> @ParentID  -- Exclude the records with the given ParentID
    ORDER BY UploadedOn DESC
END

	
