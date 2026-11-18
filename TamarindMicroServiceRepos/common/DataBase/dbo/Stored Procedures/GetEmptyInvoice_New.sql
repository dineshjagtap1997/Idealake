CREATE PROCEDURE [dbo].[GetEmptyInvoice_New]  
AS  
BEGIN  
 --SELECT '200' AS returnCode  
 -- ,'data retrieved' AS returnMessage  
  
 SELECT ID  
  ,Invoice_ID  
  ,Type_Of_Doc  
  ,Invoice_Type  
  ,Invoice_Date  
  ,File_ID  
  ,Qut_ID  
  ,Customer_Name  
  ,Agent_ID  
  ,Curr_ID  
  ,SAC_ID  
  ,StateCode_ID  
  ,Tax_ID  
  ,Invoice_No_Of_Pax  
  ,Invoice_Credit_Note  
  ,Invoice_Exchg_Rate  
  ,Invoice_Curr_Amt  
  ,Invoice_Total  
  ,Reference  
  ,compcode  
  ,YearCode  
  ,ReceivedAmt  
  ,BalAmt  
  ,TaxAmount  
  ,AmtInINR  
  ,MiscAcc  
  ,RefNo  
  ,PreviousYear  
  ,isVoid  
  ,ConvertedInvNo  
  ,CreatedBy  
  ,CreatedDateTime  
  ,LastUpdatedBy  
  ,LastUpdateDateTime  
  ,'' CurrencyName  
  ,'' AgentName  
  ,'' AccCode  
  ,IsDirectPayment  
  ,IsTaxReverseCharge  
  ,flag  
  ,isnull(TaxIDOps, 0) AS TaxIDOps  
  ,IsBillOfSupply  
  ,'' AS CityIATACode  
  ,TCSRateID  
  ,IsPANExists  
  ,PANNo  
  ,IsPassportExist  
  ,IsResident  
  ,TCSValue  
  ,IsTCS_Inv  
  ,IsTCS_Inv1  
  ,ServiceFee_Amt  
  ,IsServFee_Inv  
 FROM Invoice  
 WHERE 1 = 2  
  
 --SELECT ID,Invoice_ID,Invoice_Desc,Invoice_Value,YearCode,CAST(NULL AS INT)RowID,Taxable_Amount,Tax_Amount,flag,SAC,Tax_Per FROM Invoice_Detail_New WHERE 1=2                                              
 SELECT ID  
  ,Invoice_ID  
  ,Invoice_Desc  
  ,Invoice_Value  
  ,YearCode  
  ,CAST(NULL AS INT) RowID  
  ,Taxable_Amount  
  ,Tax_Amount  
  ,flag  
  ,TCSAmount  
  ,SubTotal  
  ,ServiceFee_Amt  
 FROM Invoice_Detail  
 WHERE 1 = 2  
  
 --Party Account                                            
 SELECT id  
  ,TranId  
  ,TranDate  
  ,YearCode  
  ,VoucherNo  
  ,VTypeID  
  ,AcCode  
  ,AcName  
  ,Amount  
  ,Dr_Cr  
  ,RefNo  
  ,RefType  
  ,CustomerName  
  ,Refid  
  ,Billno  
  ,Billdate  
  ,BillAmt  
  ,BalAmt  
  ,BalDr_Cr  
  ,JVID  
  ,BasicAmt  
  ,Curr_id  
  ,ExchangeRate  
  ,ChqDate  
  ,ChqNumber  
  ,Narration  
  ,refDate  
  ,IsVoid  
  ,BalBasic  
  ,SrNo  
 FROM AcTransactions  
 WHERE 1 = 2  
  
 --Sales Register                                            
 SELECT id  
  ,TranId  
  ,TranDate  
  ,YearCode  
  ,VoucherNo  
  ,VTypeID  
  ,AcCode  
  ,AcName  
  ,Amount  
  ,Dr_Cr  
  ,RefNo  
  ,RefType  
  ,CustomerName  
  ,Refid  
  ,Billno  
  ,Billdate  
  ,BillAmt  
  ,BalAmt  
  ,BalDr_Cr  
  ,JVID  
  ,BasicAmt  
  ,Curr_id  
  ,ExchangeRate  
  ,ChqDate  
  ,ChqNumber  
  ,Narration  
  ,refDate  
  ,IsVoid  
  ,BalBasic  
  ,SrNo  
 FROM AcTransactions  
 WHERE 1 = 2  
  
 --Tax  Register                                            
 SELECT id  
  ,TranId  
  ,TranDate  
  ,YearCode  
  ,VoucherNo  
  ,VTypeID  
  ,AcCode  
  ,AcName  
  ,Amount  
  ,Dr_Cr  
  ,RefNo  
  ,RefType  
  ,CustomerName  
  ,Refid  
  ,Billno  
  ,Billdate  
  ,BillAmt  
  ,BalAmt  
  ,BalDr_Cr  
  ,JVID  
  ,BasicAmt  
  ,Curr_id  
  ,ExchangeRate  
  ,ChqDate  
  ,ChqNumber  
  ,Narration  
  ,refDate  
  ,IsVoid  
  ,BalBasic  
  ,SrNo  
 FROM AcTransactions  
 WHERE 1 = 2  
  
 --TCS Rate  Register                                            
 SELECT id  
  ,TranId  
  ,TranDate  
  ,YearCode  
  ,VoucherNo  
  ,VTypeID  
  ,AcCode  
  ,AcName  
  ,Amount  
  ,Dr_Cr  
  ,RefNo  
  ,RefType  
  ,CustomerName  
  ,Refid  
  ,Billno  
  ,Billdate  
  ,BillAmt  
  ,BalAmt  
  ,BalDr_Cr  
  ,JVID  
  ,BasicAmt  
  ,Curr_id  
  ,ExchangeRate  
  ,ChqDate  
  ,ChqNumber  
  ,Narration  
  ,refDate  
  ,IsVoid  
  ,BalBasic  
  ,SrNo  
 FROM AcTransactions  
 WHERE 1 = 2  
  
 -- Upload TCS Documents for PAN Card        
 SELECT *  
 FROM TCS_Documents  
 WHERE 1 = 2  
  
 -- Upload TCS Documents for Passport        
 --SELECT *  
 --FROM TCS_Documents  
 --WHERE 1 = 2  
END