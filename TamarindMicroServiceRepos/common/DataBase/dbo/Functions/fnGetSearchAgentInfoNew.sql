-- [fnGetSearchAgentInfoNew] 107 , '','','',''                
--ALTER FUNCTION [dbo].[fnGetSearchAgentInfoNew](@AgentID int,@City_IATACode VARCHAR(10),@StateCode INT,@CountryCode Varchar(10),@SelectedData VARCHAR(10),@SelectedValue VARCHAR(10), @EmpID int)                
CREATE FUNCTION [dbo].[fnGetSearchAgentInfoNew] (
	@AgentID INT
	,@City_IATACode VARCHAR(10)
	,@StateCode INT
	,@CountryCode VARCHAR(10)
	,@EmpID INT
	)
RETURNS TABLE
AS
RETURN (
		SELECT DISTINCT A.AgentID
			,A.AgentCode
			,AgentName
			,A.CategoryID
			,GroupID
			,MarketID
			,City_IATACode
			,Website
			,contact1 AS Phoneno
			,A.MobileNo
			,EmailID
			,PanNo
			,ChequeFavouring
			,A.[Address]
			,CreditApplicable
			,CreditCurrencyCode
			,A.IsActive
			,CreditAllowance
			,Threshold
			,CreditPeriod
			,OutStandingAmount
			,
			-- S.Name AS StateName,          
			[OnlineExists]
			,CASE 
				WHEN ISNULL(A.UserID, '') <> ''
					THEN A.[UserID]
				ELSE 'No Login'
				END AS UserID
			,ACM.CategoryCode
			,'City :' + ISNULL(C.Name, '') + '<br/>' +
			--'Market :'+M.Name+'<br/><br/>'+                                          
			'Address :' + ISNULL(A.[Address], '') AS [AddressInfo]
			,'Phone :' + ISNULL(REPLACE(A.contact1, '~', '-'), '') + '<br/>' + 'Mobile :' + ISNULL(REPLACE(A.MobileNo, '~', '-'), '') + '<br/>' + 'Fax :' + ISNULL(REPLACE(A.FaxNo, '~', '-'), '') AS Contact
			,ISNULL(Curr.Symbol, '') + ' ' + CONVERT(VARCHAR(20), CONVERT(NUMERIC(18, 2), A.OutStandingAmount)) AS OutStandingAmountWithCurr
			,A.CreditInfo
			,A.TANNo
			,A.GST
			,A.TamSalesName
			,A.SalesTaxRegNumber
		--,ISNULL(AL.UserID,'')AS UserLogin,                    
		--ISNULL(AL.IsAdminUser,'0') AS  IsAdminUser,ISNULL(AL.AgentLoginID,'0') AS AgentLoginID                          
		FROM (
			SELECT AgentID
				,AgentCode
				,AgentName
				,CategoryID
				,GroupID
				,MarketID
				,AM.AddressCity
				,AM.AddressState
				,AM.AddressCountry
				,City_IATACode
				,Website
				,contact1
				,AM.MobileNo
				,EmailID
				,PanNo
				,AM.STRegNo
				,TANDetails
				,ChequeFavouring
				,AM.[Address]
				,CreditApplicable
				,CreditCurrencyCode
				,AM.IsActive
				,CreditAllowance
				,Threshold
				,CreditPeriod
				,OutStandingAmount
				,FaxNo
				,CASE 
					WHEN EXISTS (
							SELECT AgentLoginID
							FROM AgentLogin
							WHERE AgentID = AM.AgentID
							)
						THEN 1
					ELSE 0
					END AS [OnlineExists]
				,(
					SELECT TOP 1 UserID
					FROM AgentLogin
					WHERE AgentID = AM.AgentID
					) AS [UserID]
				,'Allowance :' + ISNULL(CR.Symbol, '') + ' ' + ISNULL(CONVERT(VARCHAR(20), CONVERT(NUMERIC(18, 2), AM.CreditAllowance)), '0.00') + '<br/>' +
				--'Threshold :'+ISNULL(CR.Symbol,'')  + ' ' +ISNULL(CONVERT(VARCHAR(20),CONVERT(NUMERIC(18,2),AM.Threshold)),'0.00')+'<br/>'+                                        
				'On Credit :' + CASE 
					WHEN CreditApplicable = 0
						THEN 'No'
					ELSE 'Yes'
					END AS CreditInfo
				,TANDetails AS TANNo
				,AM.gstin AS GST
				,
				--EMP.EmpName AS TAMSales           
				am.TamSalesName
				,Am.STRegNo AS SalesTaxRegNumber
			FROM AgentMaster AM
			LEFT JOIN Currency CR ON CR.Code = AM.CreditCurrencyCode
			LEFT JOIN EmployeeMaster EMP ON AM.RelatedEmployeeID = EMP.EmpID
			WHERE AgentID = CASE 
					WHEN @AgentID IS NOT NULL
						THEN @AgentID
					ELSE AgentID
					END
				AND AddressCity = CASE 
					WHEN @City_IATACode IS NOT NULL
						THEN @City_IATACode
					ELSE AddressCity
					END
				AND AddressState = CASE 
					WHEN @StateCode IS NOT NULL
						THEN @StateCode
					ELSE AddressState
					END
				AND AddressCountry = CASE 
					WHEN @CountryCode IS NOT NULL
						THEN @CountryCode
					ELSE AddressCountry
					END
				--AND CategoryID=CASE WHEN @CategoryID IS NOT NULL THEN @CategoryID ELSE CategoryID END                            
				--AND GroupID=CASE WHEN @GroupID IS NOT NULL THEN @GroupID ELSE GroupID END                    
				--AND RelatedEmployeeID=CASE WHEN @EmpID IS NOT NULL THEN @EmpID ELSE RelatedEmployeeID END         
				AND TamSalesrep = CASE 
					WHEN @EmpID IS NOT NULL
						THEN @EmpID
					ELSE TamSalesrep
					END
				--AND AM.STRegNo = CASE WHEN @SELECTEDVALUE = 'GST' THEN @SELECTEDDATA ELSE AM.STRegNo END                
				--AND AM.PANNO = CASE WHEN @SELECTEDVALUE = 'PAN' THEN @SELECTEDDATA ELSE AM.PANNO  END                 
				--AND AM.TANDetails = CASE WHEN @SELECTEDVALUE = 'TAN' THEN @SELECTEDDATA ELSE AM.TANDetails  END                 
				--AND AM.IsActive=1                          
			) A
		LEFT JOIN City C ON A.AddressCity = C.IATACode
		LEFT JOIN [State] S ON S.State_ID = A.AddressState
		LEFT JOIN Country CN ON CN.IATACode = A.AddressCountry
		LEFT JOIN AgentCategoryMaster ACM ON ACM.CategoryID = A.CategoryID
		LEFT JOIN Currency Curr ON Curr.Code = A.CreditCurrencyCode
			--LEFT JOIN AgentLogin AL ON (AL.AgentID = A.AgentID)                             
			--WHERE                             
			--[OnlineExists]=CASE WHEN @OnlineAccess IS NOT NULL THEN @OnlineAccess ELSE [OnlineExists] END                           
			--AND (@LoginID IS NULL                 
			--OR A.AgentID IN (SELECT AgentID FROM AgentLogin WHERE AgentLoginID=@LoginID))                
			--ISNULL(AgentLoginID,'')=CASE WHEN @LoginID IS NOT NULL THEN @LoginID ELSE ISNULL(AgentLoginID,'') END                          
		)