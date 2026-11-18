CREATE PROCEDURE [dbo].[usp_SearchVendorInfo]
(
  @VendorID INT = NULL,                                               
  @CityIATACode VARCHAR(10) = NULL,                                                                
  @AccountGroup VARCHAR(50) = NULL,                                               
  @VendorOnCredit BIT = 0                            
)
AS                             
BEGIN       
    SELECT VM.VendorID, AccCode, VendorCode, VendorName, AccountGroup,                             
           CASE 
               WHEN AccountGroup = 'L010' THEN 'Sundry Creditors for Transport'                              
               WHEN AccountGroup = 'L011' THEN 'Sundry Creditors for Handling Agent'                              
               WHEN AccountGroup = 'L012' THEN 'Sundry Creditors for Ticketing' 
           END AS AccountGroupName,                             
           AccountGroup, CityIATACode, PhoneNo, MobileNo, FaxNo, EmailID, PanNo, STRegNo,                          
           [Address], AccountNo, CreateAdvanceAccount, CONVERT(VARCHAR(10), CreditApplicable) [CreditApplicable],                             
           CreditCurrencyCode, VM.IsActive, CreditAmount,                       
           CASE WHEN CreditApplicable = 0 THEN 'Applicable : No ' ELSE 'Applicable : Yes ' END +                 
           '<br/>Credit Days : ' + CAST(CreditPeriod AS VARCHAR(50)) +                      
           '<br/>Credit Limit : ' + CONVERT(VARCHAR(20), CONVERT(NUMERIC(18,2), CreditAmount)) +                      
           '<br/>Approved By : ' + CONVERT(VARCHAR(50), VM.CreditApproveBy) AS [CreditInfo],                      
           'Chq Fav : ' + ISNULL(ChequeFavouring, '') + '<br/>Acc No : ' + ISNULL(AccountNo, '') + '<br/>Bank : ' + ISNULL(BankName, '') +             
           '<br/>BranchName : ' + ISNULL(BranchName, '') + '<br/>PAN : ' + ISNULL(PanNo, '') +       
           '<br/>IFSCCode : ' + ISNULL(IFSCCode, '') +       
           '<br/>SWIFTCode : ' + ISNULL(SWIFTCode, '') AS [ChequeInfo],                           
           'City :' + ISNULL(C.Name, '') + '<br/>' +                                             
           'Address :' + ISNULL(VM.[Address], '') AS [AddressInfo],                             
           'Phone :' + ISNULL(REPLACE(VM.PhoneNo, '~', '-'), '') + '<br/>' +                                           
           'Mobile :' + ISNULL(REPLACE(VM.MobileNo, '~', '-'), '') + '<br/>' +                                           
           'Fax :' + ISNULL(REPLACE(VM.FaxNo, '~', '-'), '') + '<br/>' +                
           'Web :' + ISNULL(VM.Website, '') + '<br/>' +                
           'Email :' + ISNULL(VM.EmailID, '') AS Contact,            
           ISNULL(VP.IsPreferred, 0) AS IsPreferred            
    FROM VendorMaster VM                             
    LEFT JOIN City C ON VM.CityIATACode = C.IATACode                              
    LEFT JOIN VendorPreferred VP ON VP.VendorID = VM.VendorID            
    WHERE-- VM.IsActive = 1                            
           (@VendorID IS NULL OR @VendorID = 0 or VM.VendorID = @VendorID)                             
          AND (@CityIATACode IS NULL OR @CityIATACode = '' or VM.CityIATACode = @CityIATACode)                             
          AND (@AccountGroup IS NULL OR @AccountGroup = '' or  VM.AccountGroup LIKE @AccountGroup + '%')                             
          AND (@VendorOnCredit IS NULL OR @VendorOnCredit = 0 or VM.CreditApplicable = @VendorOnCredit)    
END
