using CommonClass;
using iTextSharp.text;
using iTextSharp.text.pdf;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using TamarindAstra.Common;
using TamarindAstra_Operations.Interface;
using static TamarindAstra_Operations.Model.Xomodel;

namespace TamarindAstra_Operations.Repository
{

    public class xomodelrepositorycs : Ixo
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private readonly string isEncrypted;
        private readonly XoPdfGenerate _pdfGenerate;

        public xomodelrepositorycs(IConfiguration config, IOptions<Cryptography> options, XoPdfGenerate pdfGenerate)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];
            _pdfGenerate = pdfGenerate;
        }

        #region insertxo starts here

        public async Task<ResponseModel> InsertXOModel(RequestModel request)
        {
            try
            {
                var reqList = CommonFunctions.DecryptAndDeserialize<InsertXOModel>(request.RequestText);

                if (reqList != null && reqList.Any())
                {
                    foreach (var req in reqList)
                    {
                        var parameters = new
                        {
                            XO_Amt = req.XO_Amt,
                            YearCode = req.YearCode,
                            Accode = req.Accode,
                            PaymentAmt = req.PaymentAmt,
                            AmtInINR = req.AmtInINR,
                            BillReceived = req.BillReceived,
                            CompanyCode = req.CompanyCode?.ToString(),
                            OperationBy = req.OperationBy,
                            UpdatedBy = req.UpdatedBy,
                            DayWiseID = req.DayWiseID,
                            BookingID = long.TryParse(req.BookingID, out var bid) ? bid : 0,
                            GroupKey = int.TryParse(req.GroupKey, out var gk) ? gk : 0,
                            Action = req.Action
                        };

                        var data = new CommonClass.ResponseViewModel<InsertXOModel>
                        {
                            data = req
                        };

                        var result = CommonFunctions.ProcessDBData(data, req.Action, "USP_InsertXO", parameters);
                        result.returnCode = data.returnCode;
                        result.returnMessage = data.returnMessage;
                        result.LastSavedOn = data.LastSavedOn;
                    }

                    return CommonFunctions.BlankResponse("200", "XO Insert processed successfully.");
                }

                return CommonFunctions.BlankResponse("201", "No valid data found.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }

        #endregion insertxo ends here

        #region getxo starts here
        public async Task<ResponseModel> GetXo(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<GetXo>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @BookingID = req.BookingID,
                        @IsDashboard = req.IsDashboard,
                        @DashCompanyId = req.DashCompanyId,
                        @OperationBy = req.OperationBy,
                        @DashYearId = req.DashYearId,
                        @DaysCount = req.DaysCount,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<GetXo>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "[XO].[Get_XO_Data]", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }

        public async Task<ResponseModel> UpdateUndoXOModel(RequestModel request)
        {
            try
            {
                var reqList = CommonFunctions.DecryptAndDeserialize<UpdateUndoXOModel>(request.RequestText);

                if (reqList == null || !reqList.Any())
                    return CommonFunctions.BlankResponse("201", "Empty or invalid request.");

                foreach (var req in reqList)
                {
                    var parameters = new
                    {
                        req.XOID,
                        req.YearCode,
                        req.XO_UserID,
                        req.XOUpdated_Dt,
                        req.XO_UNDODt,
                        req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<UpdateUndoXOModel> { data = req };
                    var result = CommonFunctions.ProcessDBData(data, req.Action, "Usp_UpdateUndoXO", parameters);

                    result.returnCode = data.returnCode;
                    result.returnMessage = data.returnMessage;
                    result.LastSavedOn = data.LastSavedOn;

                    if (result == null || result.returnCode != "200")
                        return result;
                }

                return CommonFunctions.BlankResponse("200", "All records processed successfully.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Update XO Failed");
            }
        }

        #endregion getxo ends here

        #region xounlockmail request starts here
        public async Task<ResponseModel> xounlockmail(RequestModel request)
        {
            try
            {
                var reqList = CommonFunctions.DecryptAndDeserialize<XOUnlockMailRequest>(request.RequestText);

                var req = reqList.FirstOrDefault();
                if (req == null)
                    return CommonFunctions.BlankResponse("201", "Invalid request");

                var parameters = new
                {
                    req.RequestId,
                    req.FileCode,
                    req.RequestedBy,
                    req.Reason,
                    req.Responsibility,
                    req.FileEndDate
                };

                var data = new CommonClass.ResponseViewModel<XOUnlockMailRequest> { data = req };
                var result = CommonFunctions.ProcessDBData(data, "S", "[XO].[Get_XO_Unlock_Data]", parameters);
                if (result == null || result.returnCode != "200")

                    await SendAdvancePayEmail(new RequestModel { RequestText = request.RequestText }, includeUnlockSection: true, includeAdvancePaySection: false);

                return CommonFunctions.BlankResponse("200", "xolock Pay request submitted and email sent.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "xolock Pay submission failed.");
            }
        }

        #endregion xounlockmail ends here

        #region xoinstruction starts here
        public async Task<ResponseModel> XOInstruction(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<XOInstructionModel>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @BookingID = req.BookingID,
                        @Action = req.Action,
                        @XODayWiseID = req.XODayWiseID
                    };

                    var data = new CommonClass.ResponseViewModel<XOInstructionModel>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action.ToString(), "[XO].[Get_XO_Instructions]", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }

        public async Task<ResponseModel> XOInstructionModel(RequestModel request)
        {
            try
            {
                // Use shared decryption and deserialization method
                var reqList = CommonFunctions.DecryptAndDeserialize<XOInstructionModel>(
                    request.RequestText,
                    tokenId: _base64Key,
                    isEncrypted: isEncrypted
                );

                if (reqList == null || !reqList.Any())
                    return CommonFunctions.BlankResponse("201", "Empty or invalid request.");

                foreach (var req in reqList)
                {
                    var parameters = new
                    {
                        XO_InstructionID = req.XO_InstructionID,
                        File_ID = req.File_ID,
                        Customer_Name = req.Customer_Name,
                        Supplier_Name = req.Supplier_Name,
                        XO_ID = req.XO_ID,
                        Qut_ID = req.Qut_ID,
                        Forign_Exchange = req.Forign_Exchange,
                        Meals_Menu_Basis = req.Meals_Menu_Basis,
                        XO_Line_Desc = req.XO_Line_Desc,
                        XO_Instruction = req.XO_Instruction,
                        Confirmed_By = req.Confirmed_By,
                        ArrivalDate = req.ArrivalDate,
                        DepartureDate = req.DepartureDate,
                        FromCity = req.FromCity,
                        ToCity = req.ToCity,
                        ArrivalBy = req.ArrivalBy,
                        DeptBy = req.DeptBy,
                        FromTime = req.FromTime,
                        ToTime = req.ToTime,
                        YearCode = req.YearCode,
                        XO_IssuedOn = req.XO_IssuedOn,
                        NoOfPax = req.NoOfPax,
                        Action = req.Action,
                        XODayWiseID = req.XODayWiseID
                    };

                    var data = new CommonClass.ResponseViewModel<XOInstructionModel>
                    {
                        data = req
                    };

                    var result = CommonFunctions.ProcessDBData(data, req.Action.ToString(), "[XO].[USP_InsertOrUpdate_XOInstructions]", parameters);
                    result.returnCode = data.returnCode;
                    result.returnMessage = data.returnMessage;
                    result.LastSavedOn = data.LastSavedOn;

                    if (result == null || result.returnCode != "200")
                        return result;
                }

                return CommonFunctions.BlankResponse("200", "XO Instruction saved successfully");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }
        #endregion xoinstruction ends here

        #region ADVANCEPAY INSERT STARTS HERE

        public async Task<ResponseModel> AdvancePaySendRequestModel(RequestModel request)
        {
            try
            {
                var reqList = CommonFunctions.DecryptAndDeserialize<AdvancePaySendRequestModel>(request.RequestText);

                var req = reqList.FirstOrDefault();

                if (req == null)
                    return CommonFunctions.BlankResponse("201", "Invalid request");

                decimal gstPer = 0;
                if (!string.IsNullOrEmpty(req.GST_Per))
                {
                    decimal.TryParse(req.GST_Per.Replace("%", ""), out gstPer);
                }
                req.OpsRemark ??= string.Empty;
                req.XO_Amt = req.XO_Amt ?? 0;
                req.GST_Per = gstPer.ToString();
                req.TAC_Invoice_Amt = req.TAC_Invoice_Amt ?? 0;
                req.TDS_Amt = req.TDS_Amt ?? 0;
                req.Vendor_Bill_Amt = req.Vendor_Bill_Amt ?? 0;
                req.Amt_To_be_Released = req.Amt_To_be_Released ?? 0;
                req.TaxAmount = req.TaxAmount ?? 0;

                var parameters = new
                {
                    req.Request_ID,
                    req.Requested_By,
                    req.SAPCompCode,
                    req.SAPXOBizPlaceCode,
                    req.BizVertical,
                    req.FileCode,
                    req.GuestName,
                    req.AgentName,
                    req.XO_ID,
                    req.Check_In,
                    req.Check_Out,
                    req.XO_Curr,
                    XO_Amt = req.XO_Amt ?? 0,
                    GST_Per = gstPer,
                    TAC_Invoice_Amt = req.TAC_Invoice_Amt ?? 0,
                    TDS_Amt = req.TDS_Amt ?? 0,
                    Vendor_Bill_Amt = req.Vendor_Bill_Amt ?? 0,
                    Amt_To_be_Released = req.Amt_To_be_Released ?? 0,
                    req.HotelName,
                    req.AgentCredit,
                    req.Vendor_Name,
                    req.PayTo,
                    req.Supplier_Credit,
                    req.Bank_Account_Name,
                    req.Bank_Account_No,
                    req.Bank_Name,
                    req.IFSC,
                    req.SAP_Vendor_Code,
                    req.TAC_Invoice_No,
                    req.Approved_By,
                    req.Reason_For_Advance,
                    Action = req.Action ?? "I",
                    req.ModeOfPayment,
                    TaxAmount = req.TaxAmount ?? 0,
                    req.AgentPaymentStatus,
                    req.XODayWiseID,
                };

                var data = new CommonClass.ResponseViewModel<AdvancePaySendRequestModel> { data = req };
                var result = CommonFunctions.ProcessDBData(data, req.Action ?? "I", "usp_InsertAdvancePaySendRequest", parameters);

                result.returnCode = data.returnCode;
                result.returnMessage = data.returnMessage;
                result.LastSavedOn = data.LastSavedOn;
                if (result == null || result.returnCode != "200")
                {
                    return CommonFunctions.CreateErrorResponse(null, "500", "Failed to process Advance Pay request.");
                }

                return result;
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Advance Pay submission failed.");
            }
        }

        public async Task<ResponseModel> GetMasterForExport(RequestModel request)
        {
            try
            {
                Console.WriteLine($" GetMasterForExport called with MasterFlag: {request.MasterFlag}");

                var response = new ResponseModel();

                if (request.MasterFlag == "AdvancePaySendRequestModel")
                {
                    // This should NOT call AdvancePaySendRequestModel again, 
                    // as we're passing the already processed data
                    Console.WriteLine(" Processing AdvancePaySendRequestModel for export");
                }

                // The request.RequestText should contain the data to be exported
                if (string.IsNullOrEmpty(request.RequestText))
                {
                    Console.WriteLine(" RequestText is null or empty in GetMasterForExport");
                    return CommonFunctions.BlankResponse("201", "RequestText is null or empty.");
                }

                try
                {
                    // Decrypt the data that was passed to this method
                    string decryptedData = null;

                    // Try to decrypt first
                    try
                    {
                        decryptedData = Cryptography.DecryptStringAES(request.RequestText, _base64Key);
                        Console.WriteLine(" Successfully decrypted data for export");
                    }
                    catch (Exception decEx)
                    {
                        Console.WriteLine($" Decryption failed, using raw data: {decEx.Message}");
                        decryptedData = request.RequestText;
                    }

                    if (string.IsNullOrWhiteSpace(decryptedData))
                    {
                        Console.WriteLine(" Decrypted data is null or empty");
                        return CommonFunctions.BlankResponse("201", "Decrypted data is null or empty.");
                    }

                    Console.WriteLine($" Parsing JSON data. Length: {decryptedData.Length}");
                    JObject jsonObj = JObject.Parse(decryptedData);

                    var modelList = new List<AdvancePaySendRequestModel>();

                    // Parse the data structure
                    if (jsonObj["dataList"] is JArray dataArray && dataArray.HasValues)
                    {
                        modelList = dataArray.ToObject<List<AdvancePaySendRequestModel>>();
                        Console.WriteLine($" Found {modelList.Count} items in dataList");
                    }
                    else if (jsonObj["data"] is JObject singleData && singleData.HasValues)
                    {
                        var model = singleData.ToObject<AdvancePaySendRequestModel>();
                        modelList.Add(model);
                        Console.WriteLine(" Found 1 item in data object");
                    }
                    else if (jsonObj["data"] is JArray dataArrayAlt && dataArrayAlt.HasValues)
                    {
                        modelList = dataArrayAlt.ToObject<List<AdvancePaySendRequestModel>>();
                        Console.WriteLine($" Found {modelList.Count} items in data array");
                    }
                    else
                    {
                        Console.WriteLine(" No valid data structure found in JSON");
                        Console.WriteLine($" JSON structure: {jsonObj.ToString()}");
                        return CommonFunctions.BlankResponse("201", "No valid data or dataList found.");
                    }

                    if (modelList == null || modelList.Count == 0)
                    {
                        Console.WriteLine(" Model list is empty after parsing");
                        return CommonFunctions.BlankResponse("201", "No data found to export.");
                    }

                    Console.WriteLine($" Creating DataTable from {modelList.Count} items");
                    var dataTable = ToAdvancePayDataTable(modelList);

                    if (dataTable.Rows.Count == 0)
                    {
                        Console.WriteLine(" DataTable has no rows");
                        var emptyData = new CommonClass.FileResponseViewModel<FileResponseModel>();
                        return CommonFunctions.ProcessFileResult(emptyData, null);
                    }

                    Console.WriteLine($" DataTable created with {dataTable.Rows.Count} rows and {dataTable.Columns.Count} columns");

                    byte[] fileResult = ExportToCsv(dataTable);
                    Console.WriteLine($" CSV generated. Size: {fileResult.Length} bytes");

                    var finalData = new CommonClass.FileResponseViewModel<FileResponseModel>();
                    var result = CommonFunctions.ProcessFileResult(finalData, fileResult);

                    Console.WriteLine($" Export completed successfully. Return code: {result.returnCode}");
                    return result;
                }
                catch (JsonException jsonEx)
                {
                    Console.WriteLine($" JSON parsing error: {jsonEx.Message}");
                    return CommonFunctions.BlankResponse("201", $"JSON parsing error: {jsonEx.Message}");
                }
                catch (Exception parseEx)
                {
                    Console.WriteLine($" Data parsing error: {parseEx.Message}");
                    return CommonFunctions.BlankResponse("201", $"Error during data parsing: {parseEx.Message}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($" General error in GetMasterForExport: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                return CommonFunctions.BlankResponse("201", $"Error during export processing: {ex.Message}");
            }
        }

        public DataTable ToAdvancePayDataTable(List<AdvancePaySendRequestModel> requestList)
        {
            Console.WriteLine($" Creating DataTable for {requestList?.Count ?? 0} items");

            DataTable dataTable = new DataTable();

            try
            {
                // Define columns based on the Excel structure
                dataTable.Columns.Add("SAPCompCode", typeof(string));            
                dataTable.Columns.Add("Request_ID", typeof(string));
                dataTable.Columns.Add("Request_Date", typeof(string));
                dataTable.Columns.Add("Requested_By", typeof(string));
                dataTable.Columns.Add("FileHandler", typeof(string));
                dataTable.Columns.Add("FileCode", typeof(string));
                dataTable.Columns.Add("Filebranch", typeof(string));
                dataTable.Columns.Add("XO_ID", typeof(string));
                dataTable.Columns.Add("Curr_Id", typeof(string));
                dataTable.Columns.Add("AmtToBeReleased", typeof(string));       
                dataTable.Columns.Add("ModeOfPay", typeof(string));
                dataTable.Columns.Add("PaymentStatus", typeof(string));         
                dataTable.Columns.Add("AmtPaid", typeof(string));               
                dataTable.Columns.Add("GuestName", typeof(string));
                dataTable.Columns.Add("AgentID", typeof(string));               
                dataTable.Columns.Add("AgentName", typeof(string));
                dataTable.Columns.Add("AgentCredit", typeof(string));
                dataTable.Columns.Add("HotelName", typeof(string));
                dataTable.Columns.Add("VendorName", typeof(string));
                dataTable.Columns.Add("PayTo", typeof(string));
                dataTable.Columns.Add("HotelVendorCredit", typeof(string));     
                dataTable.Columns.Add("Check-in", typeof(string));
                dataTable.Columns.Add("Check-out", typeof(string));
                dataTable.Columns.Add("TACInvNo", typeof(string));
                dataTable.Columns.Add("TACInvAmt", typeof(string));             
                dataTable.Columns.Add("TDS", typeof(string));                   
                dataTable.Columns.Add("VoucherAmt", typeof(string));            
                dataTable.Columns.Add("GST%", typeof(string));                  
                dataTable.Columns.Add("GST Amt", typeof(string));               
                dataTable.Columns.Add("VendorBillAmt", typeof(string));         
                dataTable.Columns.Add("IsBTCComm", typeof(string));             
                dataTable.Columns.Add("ChequeFavouring", typeof(string));
                dataTable.Columns.Add("AccountNo", typeof(string));
                dataTable.Columns.Add("Bank_Account_Name", typeof(string));
                dataTable.Columns.Add("BankName", typeof(string));
                dataTable.Columns.Add("IFSCCode", typeof(string));
                dataTable.Columns.Add("VendorSAPCode", typeof(string));
                dataTable.Columns.Add("BizVertical", typeof(string));
                dataTable.Columns.Add("XOLocation", typeof(string));
                dataTable.Columns.Add("ApprovedBy", typeof(string));
                dataTable.Columns.Add("ReasonForadvance", typeof(string));
                dataTable.Columns.Add("SAPXOBizPlaceCode", typeof(string));     
                dataTable.Columns.Add("PaymentStatus1", typeof(string));        
                dataTable.Columns.Add("AmtPaid1", typeof(string));              
                dataTable.Columns.Add("ProfitCentreCode", typeof(string));      

                Console.WriteLine($" Created DataTable with {dataTable.Columns.Count} columns");

                if (requestList == null || requestList.Count == 0)
                {
                    Console.WriteLine(" Request list is null or empty");
                    return dataTable;
                }

                int rowCount = 0;
                foreach (var item in requestList)
                {
                    try
                    {
                        Console.WriteLine($" Processing item {rowCount + 1}: Request_ID={item?.Request_ID}, FileCode={item?.FileCode}");

                        DataRow row = dataTable.NewRow();

                        // Safe assignment with null checking
                        row["SAPCompCode"] = item?.SAPCompCode?.ToString() ?? "";
                        row["Request_ID"] = item?.Request_ID ?? "";
                        row["Request_Date"] = item?.Request_Date;
                        row["Requested_By"] = item?.Requested_By ?? "";
                        row["FileHandler"] = item?.FileHandler ?? "";
                        row["FileCode"] = item?.FileCode ?? "";
                        row["Filebranch"] = item?.Filebranch ?? "";
                        row["XO_ID"] = item?.XO_ID ?? "";
                        row["Curr_Id"] = item?.Curr_Id ?? "";
                        row["AmtToBeReleased"] = item?.Amt_To_be_Released?.ToString() ?? "0";
                        row["ModeOfPay"] = item?.ModeOfPayment ?? "";
                        row["PaymentStatus"] = item?.AgentPaymentStatus?.ToString() ?? "";
                        row["AmtPaid"] = item?.AmtPaid.ToString() ?? "0";
                        row["GuestName"] = item?.GuestName ?? "";
                        row["AgentID"] = item?.AgentID?.ToString() ?? "";
                        row["AgentName"] = item?.AgentName ?? "";
                        row["AgentCredit"] = item?.AgentCredit ?? "";
                        row["HotelName"] = item?.HotelName ?? "";
                        row["VendorName"] = item?.Vendor_Name ?? "";
                        row["PayTo"] = item?.PayTo ?? "";
                        row["HotelVendorCredit"] = item?.Supplier_Credit?.ToString() ?? "";
                        row["Check-in"] = item?.Check_In  ;
                        row["Check-out"] = item?.Check_Out  ;
                        row["TACInvNo"] = item?.TAC_Invoice_No ?? "";
                        row["TACInvAmt"] = item?.TAC_Invoice_Amt?.ToString() ?? "0";
                        row["TDS"] = item?.TDS_Amt?.ToString() ?? "0";
                        row["VoucherAmt"] = item?.VoucherAmt?.ToString() ?? "0";

                        // Safe GST% parsing
                        string gstPercent = "0";
                        try
                        {
                            if (!string.IsNullOrEmpty(item?.GST_Per))
                            {
                                string cleanGst = item.GST_Per.Replace("%", "").Trim();
                                if (int.TryParse(cleanGst, out int gstValue))
                                {
                                    gstPercent = gstValue.ToString();
                                }
                            }
                        }
                        catch (Exception gstEx)
                        {
                            Console.WriteLine($" GST parsing error for item {rowCount + 1}: {gstEx.Message}");
                        }
                        row["GST%"] = gstPercent;

                        row["GST Amt"] = item?.TaxAmount?.ToString() ?? "0";
                        row["VendorBillAmt"] = item?.Vendor_Bill_Amt?.ToString() ?? "0";
                        row["IsBTCComm"] = item?.IsBTCComm?.ToString() ?? "false";
                        row["ChequeFavouring"] = item?.ChequeFavouring ?? "";
                        row["AccountNo"] = item?.Bank_Account_No ?? "";
                        row["Bank_Account_Name"] = item?.Bank_Account_Name ?? "";
                        row["BankName"] = item?.Bank_Name ?? "";
                        row["IFSCCode"] = item?.IFSC ?? "";
                        row["VendorSAPCode"] = item?.SAP_Vendor_Code ?? "";
                        row["BizVertical"] = item?.BizVertical ?? "";
                        row["XOLocation"] = item?.XOLocation ?? "";
                        row["ApprovedBy"] = item?.Approved_By ?? "";
                        row["ReasonForadvance"] = item?.Reason_For_Advance ?? "";
                        row["SAPXOBizPlaceCode"] = item?.SAPXOBizPlaceCode?.ToString() ?? "";
                        row["PaymentStatus1"] = item?.AgentPaymentStatus1?.ToString() ?? "";
                        row["AmtPaid1"] = item?.AmtPaid1?.ToString() ?? "";
                        row["ProfitCentreCode"] = item?.ProfitCentreCode?.ToString() ?? "";

                        dataTable.Rows.Add(row);
                        rowCount++;

                        Console.WriteLine($" Successfully added row {rowCount}");
                    }
                    catch (Exception rowEx)
                    {
                        Console.WriteLine($" Error processing item {rowCount + 1}: {rowEx.Message}");
                        // Continue with next item instead of failing completely
                        continue;
                    }
                }

                Console.WriteLine($" DataTable completed with {dataTable.Rows.Count} rows");
                return dataTable;
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Error in ToAdvancePayDataTable: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");

                // Return empty DataTable rather than throwing
                return new DataTable();
            }
        }
        public async Task<ResponseModel> GetAdvancePayReqForExport(RequestModel request)
        {
            var response = new ResponseModel();

            if (request.MasterFlag == "AdvancePaySendRequestModel")
            {
                response = await GetXo(request);
            }
            if (response == null || string.IsNullOrEmpty(response.responseText))
            {
                return CommonFunctions.BlankResponse("201", "Response or responseText is null or empty.");
            }
            try
            {
                string decryptedData = Cryptography.DecryptStringAES(response.responseText, _base64Key);

                if (string.IsNullOrWhiteSpace(decryptedData))
                {
                    return CommonFunctions.BlankResponse("201", "Decrypted data is null or empty.");
                }

                JObject jsonObj = JObject.Parse(decryptedData);

                var modelList = new List<GetXo>();

                if (jsonObj["dataList"] is JArray dataArray && dataArray.HasValues)
                {
                    modelList = dataArray.ToObject<List<GetXo>>();
                }
                else if (jsonObj["data"] is JObject singleData && singleData.HasValues)
                {
                    var model = singleData.ToObject<GetXo>();
                    modelList.Add(model);
                }
                else
                {
                    return CommonFunctions.BlankResponse("201", "No valid data or dataList found.");
                }

                var dataTable = ToAdvancePayReqDataTable(modelList);

                if (dataTable.Rows.Count == 0)
                {
                    var emptyData = new CommonClass.FileResponseViewModel<FileResponseModel>();
                    return CommonFunctions.ProcessFileResult(emptyData, Encoding.UTF8.GetBytes("201"));
                }

                byte[] fileResult = ExportToCsv(dataTable);
                var finalData = new CommonClass.FileResponseViewModel<FileResponseModel>();
                return CommonFunctions.ProcessFileResult(finalData, fileResult);
            }
            catch (Exception ex)
            {
                return CommonFunctions.BlankResponse("201", $"Error during decryption or processing: {ex.Message}");
            }
        }


        public DataTable ToAdvancePayReqDataTable(List<GetXo> requestList)
        {
            DataTable dataTable = new DataTable();

            // Define columns based on the Excel structure
            dataTable.Columns.Add("Request_Date", typeof(DateTime));
            dataTable.Columns.Add("RequestID", typeof(string));
            dataTable.Columns.Add("FHE", typeof(Guid));
            dataTable.Columns.Add("FileCode", typeof(string));
            dataTable.Columns.Add("XO", typeof(string));
            dataTable.Columns.Add("PayTo", typeof(string));
            dataTable.Columns.Add("GuestName", typeof(string));
            dataTable.Columns.Add("AgentName", typeof(string));
            dataTable.Columns.Add("Status", typeof(string));

            foreach (var item in requestList)
            {
                DataRow row = dataTable.NewRow();
                row["Request_Date"] = item.Request_Date ?? (object)DBNull.Value;

                row["RequestID"] = item.RequestId;
                row["FHE"] = item.FHE;
                row["FileCode"] = item.FileCode;
                row["XO"] = item.XO;
                row["PayTo"] = item.PayTo;
                row["GuestName"] = item.GuestName;
                row["AgentName"] = item.AgentName;
                row["Status"] = item.Status;

                dataTable.Rows.Add(row);
            }

            return dataTable;
        }

        public static DataTable ToDataTable(List<Dictionary<string, object>> list)
        {
            var dataTable = new DataTable();

            if (list == null || list.Count == 0)
                return dataTable;

            // Add columns
            foreach (var key in list[0].Keys)
                dataTable.Columns.Add(key);

            // Add rows
            foreach (var dict in list)
            {
                var row = dataTable.NewRow();
                foreach (var kvp in dict)
                    row[kvp.Key] = kvp.Value ?? DBNull.Value;
                dataTable.Rows.Add(row);
            }

            return dataTable;
        }
        private byte[] ExportToCsv(DataTable dataTable)
        {
            StringBuilder sb = new StringBuilder();

            // Adding headers to CSV
            var columnNames = dataTable.Columns.Cast<DataColumn>().Select(col => col.ColumnName);
            sb.AppendLine(string.Join(",", columnNames));

            // Adding rows to CSV
            foreach (DataRow row in dataTable.Rows)
            {
                var fields = row.ItemArray.Select(field => field.ToString().Replace(",", " ")); // Escape commas
                sb.AppendLine(string.Join(",", fields));
            }

            // Return CSV as byte array
            return Encoding.UTF8.GetBytes(sb.ToString());
        }
        
        #region sendadvanceemeial starts here
        
        private bool IsValidBase64(string base64)
        {
            if (string.IsNullOrWhiteSpace(base64))
                return false;

            Span<byte> buffer = new Span<byte>(new byte[base64.Length]);
            return Convert.TryFromBase64String(base64, buffer, out _);
        }

        private async Task<(string fileUrl, string filePath)> SaveEmailAttachment(string base64Data, string fileName, string attachmentUrl)
        {
            try
            {
                string baseUrl = SharedConfiguration.GetUploadsBaseUrl();
                string rootFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "EmailAttachments");

                if (!Directory.Exists(rootFolder))
                    Directory.CreateDirectory(rootFolder);

                string uniqueFileName = $"{Guid.NewGuid()}_{fileName}";
                string filePath = Path.Combine(rootFolder, uniqueFileName);
                byte[] fileBytes;

                if (!string.IsNullOrWhiteSpace(base64Data) && IsValidBase64(base64Data))
                {
                    // Handle base64
                    fileBytes = Convert.FromBase64String(base64Data);
                }
                else if (!string.IsNullOrWhiteSpace(attachmentUrl) && IsValidBase64(attachmentUrl))
                {
                    // AttachmentUrl is actually base64 (misnamed), so treat it as base64 too
                    fileBytes = Convert.FromBase64String(attachmentUrl);
                }
                else if (!string.IsNullOrWhiteSpace(attachmentUrl) && Uri.IsWellFormedUriString(attachmentUrl, UriKind.Absolute))
                {
                    // Handle valid web URL
                    using (HttpClient client = new HttpClient())
                    {
                        fileBytes = await client.GetByteArrayAsync(attachmentUrl);
                    }
                }
                else
                {
                    throw new ArgumentException("Invalid attachment format.");
                }

                await File.WriteAllBytesAsync(filePath, fileBytes);
                string fileUrl = $"{baseUrl}/EmailAttachments/{uniqueFileName}";
                return (fileUrl, filePath);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error saving attachment: {ex.Message}");
                return (null, null);
            }
        }

        #endregion ADVANCEPAY ENDS HERE

        #region QuotationXOAdvPyModel starts here
        public async Task<ResponseModel> QuotationXOAdvPyModel(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationXOAdvPyModel>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        FileCode = req.FileCode,
                        CompanyID = req.CompanyID,
                        XOID = req.XOID,
                        Quotationid = req.Quotationid,
                        Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<QuotationXOAdvPyModel>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action.ToString(), "usp_GetQuotation_XOByFileCode_AdvPy", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Get Quotation XO AdvPay Failed");
            }
        }
        #endregion QuotationXOAdvPyModel ends here


        public async Task<ResponseModel> XOReportModel(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<XOReportModel>(request.RequestText);
                if (req == null) return CommonFunctions.BlankResponse("201", "Invalid request");

                var xoIds = (req.XOID ?? "").Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                             .Select(s => s.Trim())
                                             .ToList();

                var spName = "[XO].[USP_GetXOReport]";

                var pdfs = new List<byte[]>();

                foreach (var id in xoIds)
                {
                    var ds = await GetInvoiceData(new
                    {
                        XOID = id,
                        YearCode = req.YearCode,
                        Action = req.Action ?? "S",
                        PrintFor = req.XOFlag ?? "AGENT",
                        IncludeCompanyLogo = req.IncludeCompanyLogo ? 1 : 0,
                        IncludeAgentLogo = req.IncludeAgentLogo ? 1 : 0
                    }, spName);

                    if (ds.Tables.Count >= 2 && ds.Tables[0].Rows.Count > 0)
                    {
                        var pdfBytes = _pdfGenerate.GenerateXOReportPDF(req, ds);
                        pdfs.Add(pdfBytes);
                    }
                }

                if (pdfs.Count == 0)
                    return CommonFunctions.BlankResponse("500", "No data found");

                if (req.OnePDF == "X" && pdfs.Count > 1)
                {
                    byte[] zipBytes;
                    using (var ms = new MemoryStream())
                    {
                        using (var archive = new System.IO.Compression.ZipArchive(ms, System.IO.Compression.ZipArchiveMode.Create, true))
                        {
                            int counter = 1;
                            foreach (var pdfBytes in pdfs)
                            {
                                var entry = archive.CreateEntry($"Document_{xoIds[counter - 1]}.pdf");
                                using (var entryStream = entry.Open())
                                {
                                    entryStream.Write(pdfBytes, 0, pdfBytes.Length);
                                }
                                counter++;
                            }
                        }
                        zipBytes = ms.ToArray();
                    }

                    // Return ZIP as single byte array
                    return CommonFunctions.ProcessFileResult(
                        new CommonClass.FileResponseViewModel<FileResponseModel>(),
                        zipBytes
                    );
                }
                else if (req.OnePDF == "Y" || (req.OnePDF == "X" && pdfs.Count == 1))
                {
                    var merged = _pdfGenerate.MergePDFs(pdfs);
                    return CommonFunctions.ProcessFileResult(new CommonClass.FileResponseViewModel<FileResponseModel>(), merged);
                }

                return CommonFunctions.BlankResponse("400", "Invalid PDF generation option");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Get Quotation XO AdvPay Failed");
            }
        }


        public async Task SendAdvancePayEmail(RequestModel request, bool includeUnlockSection, bool includeAdvancePaySection, bool advancepayapprovereject = false)
        {
            var _smtpSettings = SharedConfiguration.GetSmtpSettings();
            try
            {
                if (request == null || string.IsNullOrEmpty(request.RequestText))
                    throw new ArgumentNullException("Request is null or empty.");

                Console.WriteLine(" Starting SendAdvancePayEmail process");

                string subject = string.Empty;
                string to = string.Empty;
                string cc = string.Empty;
                var advancePayModel = new AdvancePaySendRequestModel();
                var getXoModel = new XOUnlockMailRequest();

                if (includeAdvancePaySection)
                    advancePayModel = CommonFunctions.DecryptAndDeserializeNullRequest<AdvancePaySendRequestModel>(request.RequestText);
                else if (includeUnlockSection)
                    getXoModel = CommonFunctions.DecryptAndDeserializeNullRequest<XOUnlockMailRequest>(request.RequestText);

                StringBuilder bodyBuilder = new StringBuilder();
                StringBuilder bodyBuilder_withoutApprovalLink = new StringBuilder();
                bodyBuilder.Append("<html><body style='font-family: Arial, sans-serif;'>");

                // Store Excel data as byte array for auto-generation
                byte[] autoExcelBytes = null;
                string autoExcelFileName = null;

                if (includeAdvancePaySection)
                {
                    Console.WriteLine($" Processing advance pay section for FileCode: {advancePayModel.FileCode}");

                    to = advancePayModel.EmailTo;
                    cc = advancePayModel.EmailCC;
                    subject = $"FileCode: {advancePayModel.FileCode ?? "N/A"} - Advance Pay Request";

                    string XO_ID = advancePayModel.XO_ID ?? "N/A";
                    string rawEmailData = $"{advancePayModel.EmailFrom}|{advancePayModel.EmailTo}|{advancePayModel.EmailCC}|{advancePayModel.ID}";
                    string encryptedData = Convert.ToBase64String(Encoding.UTF8.GetBytes(rawEmailData));

                    string approveBaseUrl = SharedConfiguration.GetAdvancePayApproveUrl();
                    string rejectBaseUrl = SharedConfiguration.GetAdvancePayRejectUrl();
                    string approveLink = $"{approveBaseUrl}{HttpUtility.UrlEncode(XO_ID)}?data={HttpUtility.UrlEncode(encryptedData)}";
                    string rejectLink = $"{rejectBaseUrl}{HttpUtility.UrlEncode(XO_ID)}?data={HttpUtility.UrlEncode(encryptedData)}";

                    // UPDATE DATABASE
                    advancePayModel.Action = "U";
                    var parameters = new
                    {
                        advancePayModel.ID,
                        advancePayModel.EmailTo,
                        advancePayModel.EmailFrom,
                        advancePayModel.EmailCC,
                        advancePayModel.Action,
                        Status = advancePayModel.AgentPaymentStatus
                    };

                    var data = new CommonClass.ResponseViewModel<AdvancePaySendRequestModel> { data = advancePayModel };
                    var result = CommonFunctions.ProcessDBData_WitoutAction(data, "[dbo].[usp_InsertAdvancePaySendRequest]", parameters);
                    var wrapper = CommonFunctions.SmartDecryptAndDeserialize<ResponseViewModel<AdvancePaySendRequestModel>>(result.responseText);
                    var emailmodel = wrapper?.dataList;

                    Console.WriteLine($"Database operation completed. Return code: {result.returnCode}");

                    // Auto-generate Excel logic (keeping existing code)
                    try
                    {
                        Console.WriteLine(" Starting automatic Excel generation from database data");

                        var excelRequest = new RequestModel
                        {
                            MasterFlag = "AdvancePaySendRequestModel",
                            RequestText = result.responseText
                        };

                        Console.WriteLine($" Calling GetMasterForExport with data length: {result.responseText?.Length ?? 0}");
                        var excelResponse = await GetMasterForExport(excelRequest);

                        if (excelResponse != null && excelResponse.returnCode == "200")
                        {
                            Console.WriteLine(" Automatic Excel generation successful");
                            autoExcelBytes = CommonFunctions.ExtractFileFromResponse(excelResponse);

                            if (autoExcelBytes == null || autoExcelBytes.Length == 0)
                            {
                                Console.WriteLine(" Primary Excel extraction failed, trying alternative methods");

                                if (excelResponse.FileContent != null && excelResponse.FileContent is byte[] directBytes)
                                {
                                    autoExcelBytes = directBytes;
                                    Console.WriteLine($" Excel extracted from FileContent. Size: {autoExcelBytes.Length} bytes");
                                }
                                else if (!string.IsNullOrEmpty(excelResponse.responseText))
                                {
                                    try
                                    {
                                        autoExcelBytes = Convert.FromBase64String(excelResponse.responseText);
                                        Console.WriteLine($" Excel extracted from base64 responseText. Size: {autoExcelBytes.Length} bytes");
                                    }
                                    catch (Exception b64Ex)
                                    {
                                        Console.WriteLine($" Base64 conversion failed: {b64Ex.Message}");
                                        autoExcelBytes = Encoding.UTF8.GetBytes(excelResponse.responseText);
                                        Console.WriteLine($" Excel created from UTF8 responseText. Size: {autoExcelBytes.Length} bytes");
                                    }
                                }
                            }

                            if (autoExcelBytes != null && autoExcelBytes.Length > 0)
                            {
                                autoExcelFileName = $"AdvancePayDetails_{advancePayModel.FileCode ?? "N_A"}_{DateTime.Now:yyyyMMdd_HHmmss}.csv";
                                Console.WriteLine($" Auto-generated Excel prepared successfully. Filename: {autoExcelFileName}, Size: {autoExcelBytes.Length} bytes");
                            }
                        }
                    }
                    catch (Exception excelEx)
                    {
                        Console.WriteLine($" Automatic Excel generation exception: {excelEx.Message}");
                    }

                    // Build email body
                    bodyBuilder.Append("<h3>Advance Pay Request Details</h3>");
                    bodyBuilder.Append("<table border='1' cellpadding='6' cellspacing='0' style='border-collapse: collapse; width: 100%;'>");

                    void AddRow(string label, string value)
                    {
                        bodyBuilder.AppendFormat("<tr><th align='left' style='background-color:#f0f0f0;'>{0}</th><td>{1}</td></tr>",
                            label,
                            string.IsNullOrWhiteSpace(value) ? "N/A" : value);
                    }

                    if (emailmodel != null && emailmodel.Count > 0)
                    {
                        AddRow("Request_ID", emailmodel[0].Request_ID);
                        AddRow("Request Date", emailmodel[0].Request_Date_Formatted);
                        AddRow("Requested by", advancePayModel.Requested_By);
                        AddRow("File Handler", emailmodel[0].FileHandler);
                        AddRow("SAP Comp Code", emailmodel[0].SAPCompCode?.ToString());
                        AddRow("SAP XO BizPlace Code", emailmodel[0].SAPXOBizPlaceCode?.ToString());
                        AddRow("Biz Vertical", emailmodel[0].BizVertical);
                        AddRow("File Code", emailmodel[0].FileCode);
                        AddRow("Guest Name", emailmodel[0].GuestName);
                        AddRow("Agent Name", emailmodel[0].AgentName);
                        AddRow("Agent Credit Status", emailmodel[0].AgentCreditStatus);
                        AddRow("XO_ID", emailmodel[0].XO_ID);
                        AddRow("Check-In", emailmodel[0].Check_In_Formatted);
                        AddRow("Check-Out", emailmodel[0].Check_Out_Formatted);
                        AddRow("XO_Curr", emailmodel[0].XO_Curr);
                        AddRow("XO_Amt", emailmodel[0].XO_Amt?.ToString("N2"));
                        AddRow("GST %", advancePayModel.GST_Per ?? "N/A");
                        AddRow("GST Amt", advancePayModel.TaxAmount?.ToString("N2"));
                        AddRow("TAC Invoice Amt", emailmodel[0].TAC_Invoice_Amt?.ToString("N2"));
                        AddRow("TDS Amt", emailmodel[0].TDS_Amt?.ToString("N2"));
                        AddRow("Vendor Bill Amt", emailmodel[0].Vendor_Bill_Amt?.ToString("N2"));
                        AddRow("Amt To Be Released", emailmodel[0].Amt_To_be_Released?.ToString("N2"));
                        AddRow("Hotel Name", emailmodel[0].HotelName);
                        AddRow("Vendor Name", emailmodel[0].Vendor_Name);
                        AddRow("Pay To", emailmodel[0].PayTo);
                        AddRow("Supplier Credit", emailmodel[0].Supplier_Credit?.ToString());
                        AddRow("Bank Account Name", emailmodel[0].Bank_Account_Name);
                        AddRow("Bank Account No", emailmodel[0].Bank_Account_No);
                        AddRow("Bank Name", emailmodel[0].Bank_Name);
                        AddRow("IFSC", emailmodel[0].IFSC);
                        AddRow("SAP Vendor Code", emailmodel[0].SAP_Vendor_Code);
                        AddRow("TAC Invoice No", emailmodel[0].TAC_Invoice_No);
                        AddRow("Approved By", emailmodel[0].Approved_By);
                        AddRow("Reason For Advance", emailmodel[0].Reason_For_Advance);

                        if (advancepayapprovereject)
                        {
                            AddRow("Status", emailmodel[0].AgentPaymentStatus);
                            AddRow("Remarks", emailmodel[0].Remarks);
                        }
                    }

                    bodyBuilder.Append("</table><br/>");

                    if (!advancepayapprovereject)
                    {
                        bodyBuilder_withoutApprovalLink.Append(bodyBuilder);
                        if (!string.IsNullOrWhiteSpace(advancePayModel.Link))
                        {
                            bodyBuilder.Append("<h4>Payment Link:</h4>");
                            bodyBuilder.AppendFormat("<p><a href='{0}' target='_blank'>{0}</a></p>", advancePayModel.Link);
                        }

                        //                        bodyBuilder.Append("<br/><p>");
                        //                        bodyBuilder.AppendFormat(@"
                        //<table border='0' cellspacing='0' cellpadding='0' style='display:inline-block; margin-right:10px;'>
                        //<tr><td align='center' bgcolor='#28a745' style='border-radius:5px;'>
                        //<a href='{0}' target='_blank' style='font-size:18px; color:#fff; text-decoration:none; padding:14px 25px; display:inline-block;'>Approve</a>
                        //</td></tr></table>", approveLink);

                        //                        bodyBuilder.AppendFormat(@"
                        //<table border='0' cellspacing='0' cellpadding='0' style='display:inline-block;'>
                        //<tr><td align='center' bgcolor='#dc3545' style='border-radius:5px;'>
                        //<a href='{0}' target='_blank' style='font-size:18px; color:#fff; text-decoration:none; padding:14px 25px; display:inline-block;'>Reject</a>
                        //</td></tr></table>", rejectLink);
                        //                        bodyBuilder.Append("</p>");
                        // Approve button (Green)
                        bodyBuilder.Append("<br/><p>");
                        bodyBuilder.AppendFormat(@"<table border='0' cellspacing='0' cellpadding='0' style='display:inline-block; margin-right:10px;'>
                        <tr>
                        <td align='center' bgcolor='#28a745' style='border-radius:5px;'>
                        <a href='{0}' target='_blank' style='font-size:18px; color:#fff; 
                        text-decoration:none; padding:14px 25px; display:inline-block;'>Approve</a>
            </td>
        </tr>
    </table>", approveLink);

                        // Reject button (Red)
                        bodyBuilder.AppendFormat(@"
    <table border='0' cellspacing='0' cellpadding='0' style='display:inline-block;'>
        <tr>
            <td align='center' bgcolor='#dc3545' style='border-radius:5px;'>
                <a href='{0}' target='_blank' style='font-size:18px; color:#fff; 
                   text-decoration:none; padding:14px 25px; display:inline-block;'>Reject</a>
            </td>
        </tr>
    </table>", rejectLink);

                        bodyBuilder.Append("</p>");
                    }
                }

                // Handle unlock section (keeping existing code)
                if (includeUnlockSection)
                {
                    to = getXoModel.To;
                    cc = getXoModel.CC;
                    getXoModel.Action = "S";
                    var parameters = new
                    {
                        getXoModel.FileCode,
                        getXoModel.RequestedBy,
                        getXoModel.Reason,
                        getXoModel.Responsibility,
                        getXoModel.Action
                    };

                    var data = new CommonClass.ResponseViewModel<XOUnlockMailRequest> { data = getXoModel };
                    var result = CommonFunctions.ProcessDBData_WitoutAction(data, "[XO].[Get_XO_Unlock_Data]", parameters);
                    var wrapper = CommonFunctions.SmartDecryptAndDeserialize<ResponseViewModel<XOUnlockMailRequest>>(result.responseText);
                    var emailmodel = wrapper?.dataList;

                    subject = "File Unlock Request: " + (getXoModel.FileCode ?? "N/A");

                    bodyBuilder.Append("<h3>File Unlock Request</h3>");
                    bodyBuilder.Append("<table border='1' cellpadding='5' cellspacing='0' style='border-collapse: collapse; width:100%;'>");

                    if (emailmodel != null && emailmodel.Count > 0)
                    {
                        bodyBuilder.AppendFormat("<tr><th align='left'>File Code</th><td>{0}</td></tr>", getXoModel.FileCode ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>XOID</th><td>{0}</td></tr>", emailmodel[0]?.XO_ID ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>Requested By</th><td>{0}</td></tr>", getXoModel.RequestedBy ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>Reason</th><td>{0}</td></tr>", getXoModel.Reason ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>Responsibility</th><td>{0}</td></tr>", getXoModel.Responsibility ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>Currency</th><td>{0}</td></tr>", emailmodel[0].Currency ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>XOAmount</th><td>{0}</td></tr>", emailmodel[0].XOAmount ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>HotelName</th><td>{0}</td></tr>", emailmodel[0].HotelName ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>Vendor_Name</th><td>{0}</td></tr>", emailmodel[0].Vendor_Name ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>Commission</th><td>{0}</td></tr>", emailmodel[0].Commission ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>SVCStartDate</th><td>{0}</td></tr>", emailmodel[0].SVCStartDate ?? "N/A");
                        bodyBuilder.AppendFormat("<tr><th align='left'>SVCEndDate</th><td>{0}</td></tr>", emailmodel[0].SVCEndDate ?? "N/A");
                    }
                    bodyBuilder.Append("</table><br/>");
                }

                bodyBuilder.Append("</body></html>");
                bodyBuilder_withoutApprovalLink.Append("</body></html>");

                // 🔥 SEND EMAIL WITH DYNAMIC SENDER
                using (MailMessage mail = new MailMessage())
                {
                    // 🔥 SOLUTION: Use authenticated sender but set Reply-To and display name
                    string senderEmail = _smtpSettings.SenderEmail; // Keep authenticated sender
                    string senderName = _smtpSettings.SenderName;   // Default fallback
                    string replyToEmail = null;

                    if (includeAdvancePaySection && !string.IsNullOrWhiteSpace(advancePayModel.EmailFrom))
                    {
                        replyToEmail = advancePayModel.EmailFrom; // Set as Reply-To
                        senderName = $"{ExtractNameFromEmail(advancePayModel.EmailFrom)}"; // Custom display name
                        Console.WriteLine($" Using Reply-To from request data: {replyToEmail}, Display: {senderName}");
                    }
                    else if (includeUnlockSection && !string.IsNullOrWhiteSpace(getXoModel.From))
                    {
                        replyToEmail = getXoModel.From;
                        senderName = $"{ExtractNameFromEmail(getXoModel.From)} (via Tamarind Global)";
                        Console.WriteLine($" Using Reply-To from unlock request: {replyToEmail}, Display: {senderName}");
                    }

                    Console.WriteLine($" Final sender email: {senderEmail}, display name: {senderName}");

                    // Use authenticated sender email but custom display name
                    mail.From = new MailAddress(replyToEmail, senderName);

                    // Set Reply-To so recipients can reply to the actual user
                    if (!string.IsNullOrWhiteSpace(replyToEmail))
                    {
                        mail.ReplyToList.Add(new MailAddress(replyToEmail));
                        Console.WriteLine($" Reply-To set to: {replyToEmail}");
                    }

                    if (!string.IsNullOrWhiteSpace(to))
                    {
                        foreach (var address in to.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            mail.To.Add(address.Trim());
                        }
                    }

                    if ((includeAdvancePaySection && advancepayapprovereject == true) || includeUnlockSection)
                    {
                        if (!string.IsNullOrWhiteSpace(cc))
                        {
                            foreach (var address in cc.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries))
                            {
                                mail.CC.Add(address.Trim());
                            }
                        }
                    }

                    if (includeUnlockSection && !string.IsNullOrWhiteSpace(getXoModel.From))
                    {
                        mail.ReplyToList.Add(getXoModel.From.Trim());
                    }

                    mail.Subject = subject;
                    mail.Body = bodyBuilder.ToString();
                    mail.IsBodyHtml = true;

                    int attachmentCount = 0;

                    // Auto-generated Excel attachment logic (keeping existing code)
                    if (includeAdvancePaySection && autoExcelBytes != null && autoExcelBytes.Length > 0 && !string.IsNullOrEmpty(autoExcelFileName))
                    {
                        try
                        {
                            var excelStream = new MemoryStream(autoExcelBytes);
                            excelStream.Position = 0;
                            var excelAttachment = new Attachment(excelStream, autoExcelFileName, "text/csv");
                            mail.Attachments.Add(excelAttachment);
                            attachmentCount++;
                            Console.WriteLine($" Auto-generated Excel attached: {autoExcelFileName}");
                        }
                        catch (Exception attachEx)
                        {
                            Console.WriteLine($"Failed to attach auto-generated Excel: {attachEx.Message}");
                        }
                    }

                    // Manual attachments logic (keeping existing code)
                    if (includeAdvancePaySection && advancePayModel.AttachmentUrl != null && advancePayModel.AttachmentUrl.Any())
                    {
                        int remainingSlots = 5 - attachmentCount;
                        int manualFilesAttached = 0;

                        Console.WriteLine($" Processing manual attachments. Remaining slots: {remainingSlots}");

                        foreach (var attachment in advancePayModel.AttachmentUrl.Take(remainingSlots))
                        {
                            try
                            {
                                bool attached = false;

                                if (!string.IsNullOrWhiteSpace(attachment.Base64 ?? attachment.Base64Content) &&
                                    !string.IsNullOrWhiteSpace(attachment.Filename ?? attachment.FileName))
                                {
                                    try
                                    {
                                        string base64Data = attachment.Base64 ?? attachment.Base64Content;
                                        string fileName = attachment.Filename ?? attachment.FileName;
                                        string fileExt = attachment.Fileext ?? attachment.FileExt ?? "application/octet-stream";

                                        byte[] fileBytes = Convert.FromBase64String(base64Data);
                                        var stream = new MemoryStream(fileBytes);
                                        stream.Position = 0;
                                        var mailAttachment = new Attachment(stream, fileName, fileExt);
                                        mail.Attachments.Add(mailAttachment);
                                        attached = true;
                                        manualFilesAttached++;
                                        Console.WriteLine($" Manual attachment added (Base64): {fileName}");
                                    }
                                    catch (Exception base64Ex)
                                    {
                                        Console.WriteLine($"Failed to process Base64 attachment {attachment.Filename ?? attachment.FileName}: {base64Ex.Message}");
                                    }
                                }

                                if (!attached && !string.IsNullOrWhiteSpace(attachment.FilePath) && File.Exists(attachment.FilePath))
                                {
                                    try
                                    {
                                        var fileAttachment = new Attachment(attachment.FilePath);
                                        mail.Attachments.Add(fileAttachment);
                                        attached = true;
                                        manualFilesAttached++;
                                        Console.WriteLine($" Manual attachment added (FilePath): {attachment.FilePath}");
                                    }
                                    catch (Exception fileEx)
                                    {
                                        Console.WriteLine($"Failed to attach file {attachment.FilePath}: {fileEx.Message}");
                                    }
                                }
                            }
                            catch (Exception attachEx)
                            {
                                Console.WriteLine($"Failed to attach manual file: {attachEx.Message}");
                            }
                        }

                        Console.WriteLine($" Total manual files attached: {manualFilesAttached}");
                        Console.WriteLine($" Total attachments: {attachmentCount + manualFilesAttached}");
                    }

                    // Send the email
                    using (SmtpClient smtp = new SmtpClient(_smtpSettings.Host, _smtpSettings.Port))
                    {
                        smtp.Credentials = new NetworkCredential(_smtpSettings.UserName, _smtpSettings.Password);
                        smtp.EnableSsl = true;
                        await smtp.SendMailAsync(mail);
                        Console.WriteLine($" Email sent successfully to {to}");
                    }

                    // Send CC email without approval links (keeping existing logic)
                    if ((includeAdvancePaySection && advancepayapprovereject == false))
                    {
                        if (!string.IsNullOrWhiteSpace(cc))
                        {
                            foreach (var address in cc.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries))
                            {
                                mail.To.Add(address.Trim());
                            }
                            mail.Body = bodyBuilder_withoutApprovalLink.ToString();

                            using (SmtpClient smtp = new SmtpClient(_smtpSettings.Host, _smtpSettings.Port))
                            {
                                smtp.Credentials = new NetworkCredential(_smtpSettings.UserName, _smtpSettings.Password);
                                smtp.EnableSsl = true;
                                await smtp.SendMailAsync(mail);
                                Console.WriteLine($" CC Email sent successfully to {cc}");
                            }
                        }
                    }
                }

                Console.WriteLine(" SendAdvancePayEmail process completed successfully");
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Email sending failed: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                throw new Exception("Failed to send email.", ex);
            }
        }

        // Helper method to extract name from email address
        private string ExtractNameFromEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return "Tamarind Global Services";

            try
            {
                string localPart = email.Split('@')[0];
                // Convert email prefix to display name (e.g., "clintd" -> "Clintd")
                return char.ToUpper(localPart[0]) + localPart.Substring(1).ToLower();
            }
            catch
            {
                return "Tamarind Global Services";
            }
        }
        private byte[] MergePDFs(List<byte[]> pdfFiles)
        {
            using (MemoryStream output = new MemoryStream())
            {
                Document document = new Document();
                PdfCopy copy = new PdfCopy(document, output);
                document.Open();

                foreach (var file in pdfFiles)
                {
                    using (PdfReader reader = new PdfReader(file))
                    {
                        for (int i = 1; i <= reader.NumberOfPages; i++)
                        {
                            copy.AddPage(copy.GetImportedPage(reader, i));
                        }
                    }
                }

                document.Close();
                return output.ToArray();
            }
        }
        private byte[] GenerateXOReportPDF(XOReportModel req, DataSet ds)
        {
            using (var stream = new MemoryStream())
            {
                var document = new Document(PageSize.A4, 36, 36, 36, 36);
                PdfWriter.GetInstance(document, stream);
                document.Open();

                BaseFont baseFont = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, false);
                Font normal = new Font(baseFont, 10);
                Font bold = new Font(baseFont, 10, Font.BOLD);
                Font small = new Font(baseFont, 8);
                Font light = new Font(baseFont, 8, Font.NORMAL, BaseColor.DARK_GRAY);

                DataRow company = ds.Tables[0].Rows[0];
                DataTable voucherTable = ds.Tables[1];
                DataRow voucher = voucherTable.Rows[0];

                AddHeader(document, req, company, bold, normal);
                AddGSTAndInstructions(document, company, normal, bold);
                AddHotelInfo(document, voucher, normal, bold);
                AddVoucherInfo(document, voucher, normal, bold);
                AddBookingTable(document, voucherTable, normal, bold);
                AddRemarksAndSpecialInstructions(document, req, voucher, bold, normal);
                AddAuthorizationSection(document, voucher, normal, bold);
                AddFooter(document, company, light);

                document.Close();
                return stream.ToArray();
            }
        }

        private void AddHeader(Document doc, XOReportModel req, DataRow company, Font bold, Font normal)
        {
            PdfPTable table = new PdfPTable(2) { WidthPercentage = 100 };
            table.SetWidths(new float[] { 75, 25 });

            // Left
            PdfPCell left = new PdfPCell { Border = Rectangle.NO_BORDER };
            left.AddElement(new Paragraph("TAMARIND GLOBAL SERVICES PRIVATE LIMITED", bold));
            left.AddElement(new Paragraph("Billing Address: " + (company["Address"]?.ToString() ?? ""), normal));
            table.AddCell(left);

            // Right logo (toggle)
            PdfPCell right = new PdfPCell { Border = Rectangle.NO_BORDER, HorizontalAlignment = Element.ALIGN_RIGHT };
            if (req.IncludeCompanyLogo)
            {
                // If your SP returns base64 in company["CompanyLogoImage"], use that; 
                // else fallback to file as before
                var logoObj = company.Table.Columns.Contains("CompanyLogoImage") ? company["CompanyLogoImage"] : null;
                Image logo = null;

                if (logoObj != null && logoObj != DBNull.Value)
                {
                    try
                    {
                        byte[] bytes = Convert.FromBase64String(logoObj.ToString());
                        logo = Image.GetInstance(bytes);
                    }
                    catch { /* ignore base64 decode issues */ }
                }

                if (logo == null)
                {
                    string logoPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents", "Images", "Tamarind Tours Logo Small.jpg");
                    if (File.Exists(logoPath))
                        logo = Image.GetInstance(logoPath);
                }

                if (logo != null)
                {
                    logo.ScaleToFit(100f, 50f);
                    logo.Alignment = Image.ALIGN_RIGHT;
                    right.AddElement(logo);
                }
            }
            table.AddCell(right);

            doc.Add(table);
            doc.Add(Chunk.NEWLINE);
        }

        private void AddGSTAndInstructions(Document doc, DataRow company, Font normal, Font bold)
        {
            doc.Add(new Paragraph("GSTIN: " + (company["GSTIN"]?.ToString() ?? ""), normal));
            var instr = new Paragraph(
                "PLEASE EMAIL YOUR TAX INVOICE TO: bills@tamarindglobal.com\n" +
                "PLEASE ENSURE THAT THE GST NUMBER AND BILLING ADDRESS MENTIONED ON THIS VOUCHER IS DISPLAYED ON\nYOUR TAX INVOICE. THIS REQUIREMENT IS MANDATORY!",
                new Font(normal.BaseFont, 9, Font.BOLD, new BaseColor(80, 80, 80))
            );
            instr.SpacingBefore = 10f;
            instr.SpacingAfter = 10f;
            doc.Add(instr);
        }

        private void AddHotelInfo(Document doc, DataRow v, Font normal, Font bold)
        {
            Paragraph para = new Paragraph();
            para.Add(new Chunk("The Duty Manager,\n", normal));
            para.Add(new Chunk((v["SupplierName"]?.ToString() ?? "") + "\n", new Font(normal.BaseFont, 10, Font.BOLD)));
            para.Add(new Chunk(v["SupplierAddress"]?.ToString() ?? "", normal));
            para.SpacingAfter = 15f;
            doc.Add(para);
        }

        private static string SafeStr(object o) => o == null || o == DBNull.Value ? "" : o.ToString();

        private static string AsDateText(object o)
        {
            if (o == null || o == DBNull.Value) return "";
            // Already sent from SP as dd-MMM-yyyy (CONVERT 106 gives dd mon yyyy)
            // normalize to dd-MMM-yyyy
            DateTime dt;
            if (DateTime.TryParse(o.ToString(), out dt))
                return dt.ToString("dd-MMM-yyyy");
            return o.ToString();
        }

        private void AddVoucherInfo(Document doc, DataRow v, Font normal, Font bold)
        {
            PdfPTable table = new PdfPTable(4) { WidthPercentage = 100 };
            table.SetWidths(new float[] { 20, 30, 20, 30 });

            // Date / Voucher No
            AddVoucherInfoRow(table, "Date:", AsDateText(v["VoucherDate"]), "Voucher No:", SafeStr(v["VoucherNo"]), normal);

            // File No / No. of Guests
            AddVoucherInfoRow(table, "File No:", SafeStr(v["FileNo"]), "No. of Guests:", SafeStr(v["NoOfGuests"]), normal);

            // Membership No / Contact No. (hotel contact as per your data)
            AddVoucherInfoRow(table, "Membership No:", SafeStr(v["MembershipNo"]), "Contact No.:", SafeStr(v["HotelPhone"]), normal);

            // Fax removed
            // Confirmed By
            AddVoucherInfoRow(table, "", "", "Confirmed By:", SafeStr(v["ConfirmedBy"]), normal);

            // Guest Name (label changed)
            table.AddCell(new PdfPCell(new Phrase("Guest Name:", normal)) { Border = Rectangle.NO_BORDER });
            table.AddCell(new PdfPCell(new Phrase(SafeStr(v["GuestName"]), bold)) { Border = Rectangle.NO_BORDER, Colspan = 3 });

            doc.Add(table);
            doc.Add(Chunk.NEWLINE);
        }

        private void AddVoucherInfoRow(PdfPTable table, string label1, string value1, string label2, string value2, Font font)
        {
            table.AddCell(new PdfPCell(new Phrase(label1, font)) { Border = Rectangle.NO_BORDER });
            table.AddCell(new PdfPCell(new Phrase(value1, font)) { Border = Rectangle.NO_BORDER });
            table.AddCell(new PdfPCell(new Phrase(label2, font)) { Border = Rectangle.NO_BORDER });
            table.AddCell(new PdfPCell(new Phrase(value2, font)) { Border = Rectangle.NO_BORDER });
        }

        private void AddBookingTable(Document doc, DataTable data, Font normal, Font bold)
        {
            if (data == null || data.Rows.Count == 0) return;

            string currentXOType = "";
            PdfPTable table = null;

            foreach (DataRow row in data.Rows)
            {
                string xoType = SafeStr(row["XoType"]);

                if (xoType != currentXOType)
                {
                    if (table != null)
                    {
                        doc.Add(table);
                        doc.Add(new Paragraph(" ", normal) { SpacingAfter = 5f });
                    }

                    currentXOType = xoType;
                    table = CreateTableForXOType(xoType, bold);
                }

                if (table != null)
                    AddDataRowToTable(table, row, xoType, normal);
            }

            if (table != null)
            {
                doc.Add(table);
                doc.Add(Chunk.NEWLINE);
            }
        }

        private PdfPTable CreateTableForXOType(string xoType, Font bold)
        {
            var cfg = xoType switch
            {
                "H" => new
                {
                    Headers = new[] { "Check In", "Check Out", "Room Type", "Sgl","Twin", "Dbl", "CNB", "EBA", "EBC", "Plan" },
                    Widths = new float[] { 12, 12, 15, 8, 8, 8, 8, 8, 8, 13 }
                },
                "G" => new
                {
                    Headers = new[] { "Date", "Guide Service", "Language", "Guides" },
                    Widths = new float[] { 15, 55, 15, 15 }
                },
                "S" => new
                {
                    Headers = new[] { "Date", "Special Service", "Adult", "Child", "Unit" },
                    Widths = new float[] { 15, 45, 15, 15, 10 }
                },
                "M" => new
                {
                    Headers = new[] { "Date", "Monument Service", "Nationality", "Adult", "Child" },
                    Widths = new float[] { 15, 45, 15, 12.5f, 12.5f }
                },
                "T" => new
                {
                    Headers = new[] { "Date", "Transport Service", "Vehicle Type", "Vehicles" },
                    Widths = new float[] { 15, 50, 20, 15 }
                },
                _ => null
            };

            if (cfg == null) return null;

            var table = new PdfPTable(cfg.Headers.Length) { WidthPercentage = 100 };
            table.SetWidths(cfg.Widths);
            foreach (var h in cfg.Headers) table.AddCell(CreateSubHeaderCell(h, bold));
            return table;
        }

        private PdfPCell CreateSubHeaderCell(string text, Font font)
        {
            return new PdfPCell(new Phrase(text, font))
            {
                BackgroundColor = new BaseColor(240, 240, 240),
                Padding = 5,
                HorizontalAlignment = Element.ALIGN_CENTER,
                MinimumHeight = 25f
            };
        }

        private void AddDataRowToTable(PdfPTable table, DataRow r, string xoType, Font normal)
        {
            string Val(string col)
            {
                var v = SafeStr(r[col]);
                if (string.IsNullOrWhiteSpace(v) || v == "0") return "--";
                return v;
            }

            switch (xoType)
            {
                case "H":
                    table.AddCell(new PdfPCell(new Phrase(AsDateText(r["CheckIn"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(AsDateText(r["CheckOut"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["RoomType"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(Val("Sgl"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("Twin"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("Dbl"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("CNB"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("EBA"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("EBC"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["Plan"]), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    break;

                case "G":
                    table.AddCell(new PdfPCell(new Phrase(AsDateText(r["CheckIn"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["Services"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["Language"]), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("Count"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    break;

                case "S":
                    table.AddCell(new PdfPCell(new Phrase(AsDateText(r["CheckIn"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["Services"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(Val("Adult"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("Child"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("Count"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    break;

                case "M":
                    table.AddCell(new PdfPCell(new Phrase(AsDateText(r["CheckIn"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["Services"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["Nationality"]), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("Adult"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("Child"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    break;

                case "T":
                    table.AddCell(new PdfPCell(new Phrase(AsDateText(r["CheckIn"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["Services"]), normal)));
                    table.AddCell(new PdfPCell(new Phrase(SafeStr(r["VehicleCategory"]), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(Val("Count"), normal)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    break;
            }

            // Optional: add inline remark per row if you have a column like "Remark"
            if (r.Table.Columns.Contains("Remark") && !string.IsNullOrWhiteSpace(SafeStr(r["Remark"])))
            {
                PdfPCell remarkCell = new PdfPCell(new Phrase("Remark: " + SafeStr(r["Remark"]), normal))
                {
                    Colspan = table.NumberOfColumns,
                    PaddingLeft = 5f,
                    PaddingTop = 2f,
                    PaddingBottom = 2f,
                    BackgroundColor = new BaseColor(250, 250, 250)
                };
                table.AddCell(remarkCell);
            }
        }

        private void AddRemarksAndSpecialInstructions(Document doc, XOReportModel req, DataRow v, Font bold, Font normal)
        {
            // Section title
            doc.Add(new Paragraph("Remarks / Special Instructions", bold) { SpacingBefore = 10f, SpacingAfter = 4f });

            string vendorRemarks = SafeStr(v["XoRemarks"]);
            string special = SafeStr(v["SpecialInstruction"]);

            // If print-for is vendor, ensure XO remarks appear. If not vendor, you can still show both safely.
            string combined = "";
            if (!string.IsNullOrWhiteSpace(vendorRemarks)) combined += vendorRemarks.Trim();
            if (!string.IsNullOrWhiteSpace(special))
            {
                if (!string.IsNullOrEmpty(combined)) combined += Environment.NewLine;
                combined += special.Trim();
            }
            if (string.IsNullOrWhiteSpace(combined))
                combined = "—";

            PdfPTable box = new PdfPTable(1) { WidthPercentage = 100 };
            box.AddCell(new PdfPCell(new Phrase(combined, normal))
            {
                Padding = 8f,
                Border = Rectangle.BOX,
                MinimumHeight = 30f
            });
            doc.Add(box);
            doc.Add(Chunk.NEWLINE);
        }

        private void AddAuthorizationSection(Document doc, DataRow v, Font normal, Font bold)
        {
                PdfPTable table = new PdfPTable(7) { WidthPercentage = 100 };
                table.SetWidths(new float[] { 10, 20, 10, 20, 10, 10, 20 });

            // Headers
            table.AddCell(CreateAuthCell("Arrival", true, bold));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("Departure", true, bold));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("Authorised Signatory", true, bold, Element.ALIGN_RIGHT));

            // Dates only (time not required)
            table.AddCell(CreateAuthCell("Date :", false, normal));
            table.AddCell(CreateAuthCell(AsDateText(v["ArrivalDate"]), false, normal));
            table.AddCell(CreateAuthCell("Date :", false, normal));
            table.AddCell(CreateAuthCell(AsDateText(v["DepartureDate"]), false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("", false, normal));

            table.AddCell(CreateAuthCell("From :", false, normal));
            table.AddCell(CreateAuthCell(SafeStr(v["ArrivalFrom"]), false, normal));
            table.AddCell(CreateAuthCell("To   :", false, normal));
            table.AddCell(CreateAuthCell(SafeStr(v["DepartureTo"]), false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("", false, normal));

            // No 'By' or 'Time' rows since time isn't required

            table.AddCell(CreateAuthCell("By   :", false, normal));
            table.AddCell(CreateAuthCell(SafeStr(v["ArrivalBy"]), false, normal));
            table.AddCell(CreateAuthCell("By   :", false, normal));
            table.AddCell(CreateAuthCell(SafeStr(v["DepartureBy"]), false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell(SafeStr(v["FileHandlerName"]), false, normal, Element.ALIGN_RIGHT));

            // File handler line under Authorised Signatory (right column)
            table.AddCell(CreateAuthCell("Time :", false, normal));
            table.AddCell(CreateAuthCell(SafeStr(v["FromTime"]), false, normal));
            table.AddCell(CreateAuthCell("Time :", false, normal));
            table.AddCell(CreateAuthCell(SafeStr(v["ToTime"]), false, normal));
            table.AddCell(CreateAuthCell("", false, normal));
            table.AddCell(CreateAuthCell("Mobile No :", false, normal));
            table.AddCell(CreateAuthCell(SafeStr(v["FileHandlerMobile"]), false, normal, Element.ALIGN_RIGHT));
            doc.Add(table);
        }

        private PdfPCell CreateAuthCell(string text, bool isBold, Font baseFont, int align = Element.ALIGN_LEFT)
        {
            var f = isBold ? new Font(baseFont.BaseFont, 9, Font.BOLD) : new Font(baseFont.BaseFont, 9);
            return new PdfPCell(new Phrase(text, f))
            {
                Border = Rectangle.NO_BORDER,
                PaddingBottom = 4f,
                HorizontalAlignment = align,
                MinimumHeight = 18f
            };
        }

        private void AddFooter(Document doc, DataRow company, Font font)
        {
            var p = new Paragraph(
                "This is a computer generated document and does not require Signature. Corporate Identity Number: " + (company["CorporateIdentityNumber"]?.ToString() ?? ""),
                font
            )
            { Alignment = Element.ALIGN_CENTER, SpacingBefore = 20f };
            doc.Add(p);
        }



        private async Task<DataSet> GetInvoiceData(object parameters, string storedProcedure)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(SharedConfiguration.GetConnectionString()))
            {
                await conn.OpenAsync();
                using (SqlCommand cmd = new SqlCommand(storedProcedure, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    var props = parameters.GetType().GetProperties();
                    foreach (var prop in props)
                    {
                        cmd.Parameters.AddWithValue($"@{prop.Name}", prop.GetValue(parameters));
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }


        #region UPDATE STARTS HERE
        public async Task<ResponseModel> UpdateAdvancePaySendRequestModel(RequestModel request)
        {
            try
            {
                var reqList = CommonFunctions.DecryptAndDeserialize<AdvancePaySendRequestModel>(request.RequestText);

                var req = reqList.FirstOrDefault();
                if (req == null)
                    return CommonFunctions.BlankResponse("201", "Invalid request");

                decimal gstPer = 0;
                if (!string.IsNullOrEmpty(req.GST_Per))
                {
                    decimal.TryParse(req.GST_Per.Replace("%", ""), out gstPer);
                }

                var parameters = new
                {
                    req.Request_ID,
                    req.Requested_By,
                    req.SAPCompCode,
                    req.SAPXOBizPlaceCode,
                    req.BizVertical,
                    req.FileCode,
                    req.GuestName,
                    req.AgentName,
                    req.AgentCredit,
                    req.XO_ID,
                    req.Check_In,
                    req.Check_Out,
                    req.XO_Curr,
                    XO_Amt = req.XO_Amt ?? 0,
                    GST_Per = gstPer,
                    TAC_Invoice_Amt = req.TAC_Invoice_Amt ?? 0,
                    TDS_Amt = req.TDS_Amt ?? 0,
                    Vendor_Bill_Amt = req.Vendor_Bill_Amt ?? 0,
                    Amt_To_be_Released = req.Amt_To_be_Released ?? 0,
                    req.HotelName,
                    req.Vendor_Name,
                    req.PayTo,
                    req.Supplier_Credit,
                    req.Bank_Account_Name,
                    req.Bank_Account_No,
                    req.Bank_Name,
                    req.IFSC,
                    req.SAP_Vendor_Code,
                    req.TAC_Invoice_No,
                    req.Approved_By,
                    req.Reason_For_Advance,
                    Status = req.AgentPaymentStatus,
                    Action = req.Action ?? "U",
                    req.ModeOfPayment,
                    TaxAmount = req.TaxAmount ?? 0,
                    req.AgentPaymentStatus,
                    req.XODayWiseID,
                    req.Remarks,
                    req.EmailFrom,
                    req.EmailTo,
                    req.EmailCC,
                    req.ID
                };

                bool advancepayapprovereject = true;
                var data = new CommonClass.ResponseViewModel<AdvancePaySendRequestModel> { data = req };
                var result = CommonFunctions.ProcessDBData(data, req.Action ?? "U", "usp_InsertAdvancePaySendRequest", parameters);

                if (result == null || result.returnCode != "200")

                    await SendAdvancePayEmail(new RequestModel { RequestText = request.RequestText }, includeUnlockSection: false, includeAdvancePaySection: true, advancepayapprovereject=true);

                return CommonFunctions.BlankResponse("200", "Advance Pay request submitted and email sent.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Advance Pay submission failed.");
            }
        }

        #endregion UPDATE ENDS HERE

        public async Task<ResponseModel> GetAdvancePayDataByFileCode(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AdvancePaySendRequestModel>(request.RequestText);

                if (req != null && !string.IsNullOrWhiteSpace(req.FileCode))
                {
                    // Prepare parameters for stored procedure
                    var parameters = new
                    {
                        FileCode = req.FileCode,
                        Action = "S"
                    };

                    // Prepare the data model for response
                    var data = new CommonClass.ResponseViewModel<AdvancePaySendRequestModel>
                    {
                        data = req
                    };

                    // Call common function to handle DB execution and response
                    return CommonFunctions.ProcessDBData(data, "S", "usp_InsertAdvancePaySendRequest", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Invalid request: FileCode missing.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Failed to fetch Advance Pay data.");
            }
        }

    }
}
#endregion
 