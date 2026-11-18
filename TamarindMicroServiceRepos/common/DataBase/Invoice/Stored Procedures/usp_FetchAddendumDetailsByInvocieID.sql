





CREATE PROCEDURE [Invoice].[usp_FetchAddendumDetailsByInvocieID]
(                                                              

@Action VARCHAR(1),
@InvoiceID INT
)                                                              
AS                                                              
BEGIN                                                              

 IF @Action = 'S'  
 BEGIN

SELECT AM.AddendumID,	
AM.AddendumNo,	
AM.AddendumDate,	
AM.Currency,
AM.Amount,	
AM.InvoiceID,
AM.InvoiceDate,	
AM.CreatedDate,		
AM.UpdatedDate,	
AM.UpdatedBy,	
AM.YearCode,

    (
        SELECT 
            AD.ID,
            AD.AddendumID,
            AD.Description,
            AD.InvoiceID,
            AD.Currency,
            AD.Amount,
            AD.CreatedDate,
            AD.YearCode,
            AD.UpdatedDate
        FROM [Invoice].[AddendumDetails] AD
        WHERE AD.AddendumID = AM.AddendumID
        FOR JSON PATH
    ) AS AddendumJson

FROM [Invoice].[Addendum] AM
WHERE AM.InvoiceID = @InvoiceID  

END 

END


