using CommonClass;
using Microsoft.Extensions.Options;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Text;
using System.Text.Json;
using TamarindAstra.Common;
using TamarindAstraReports.Interface;
using TamarindAstraReports.Model;
using static TamarindAstraReports.Model.Reports;

namespace BusinessLogic.isEncrypted
{
    public class ReportRepository : IReport
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private readonly string isEncrypted;
        public ReportRepository(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:IsEncrypted"];
        }

        #region HotelRateDetails Starts here
        //new 
        public async Task<ResponseModel> HotelRateCard(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelRateCard>(request.RequestText);
                if (req != null)
                {
                    var parameters = new
                    {
                        @RateValidFrom = req.RateValidFrom,
                        @RateValidTo = req.RateValidTo,
                        @IsActive = req.IsActive,
                        @Action = req.Action,
                    };

                    var responseViewModel = new CommonClass.ResponseViewModel<HotelRateCard>
                    {
                        data = req
                    };

                    var result = CommonFunctions.ProcessDBData(responseViewModel, req.Action, "usp_HotelRateCard_Master", parameters);

                    // If Action is 'S', filter response fields
                    if (req.Action == "S")

                    {
                        if (req is HotelRateCard hotelRateData)
                        {
                            var filteredData = new HotelRateCard
                            {
                                HotelName = hotelRateData.HotelName,
                                Heading = hotelRateData.Heading,
                                InfoForOperation = hotelRateData.InfoForOperation,
                                CityID = hotelRateData.CityID,
                                IsActive = hotelRateData.IsActive,
                                RateValidTo = hotelRateData.RateValidTo,
                                RateValidFrom = hotelRateData.RateValidFrom,
                                CardNumber = hotelRateData.CardNumber,
                                Name = hotelRateData.Name,
                            };

                            responseViewModel.data = filteredData;
                            result.Data = CommonFunctions.ProcessResult1(responseViewModel);
                        }
                    }
                    return result;
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Operation Failed");
            }
        }

        #endregion HotelRateDetails ends here

        #region reportdownload starts here
        public async Task<ResponseModel> ReportDownloads(RequestModel request)
        {
            var response = new ResponseModel();

            var dataTable = new DataTable();
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ReportDownloads>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @dtFromDate = req.dtFromDate,
                        @dtToDate = req.dtToDate,
                        @ReportType = req.ReportType,
                        @YearCode = req.YearCode,
                        @OperationBy = req.OperationBy,
                        @ReportName = req.ReportName,
                        @Action = req.Action
                       
                    };

                    var data = new CommonClass.ResponseViewModel<ReportDownloads>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_GetReportDownloads", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }

        }

        // Method to create DataTable with only specific columns for Invoice Report
        public static DataTable ToInvoiceDataTable(List<Dictionary<string, object>> list)
        {
            var dataTable = new DataTable();

            if (list == null || list.Count == 0)
                return dataTable;

            // Define only the specific columns you want in the Excel export
            var requiredColumns = new List<string>
    {
        "Invoice_ID",
        "Invoice_date",
        "File_ID",
        "QAgentName",
        "Customer_Name",
        "InvoicedAgentCode",
        "InvoicedAgentName",
        "InvAgentGST",
        "InvAgentPAN",
        "InvAgentStateCode",
        "Curr_id",
        "ROE",
        "BasicAmt",
        "TaxableAmt",
        "TaxRate",
        "IGST",
        "CGST",
        "SGST",
        "UTGST",
        "TCSRate",
        "TCSValue",
        "TotalInvAmt",
        "SAC_Code",
        "Reference",
        "Ref/PO Number",
        "Username",
        "Invoice_Type",
        "Branch GSTIN",
        "Original invoice no",
        "Original invoice date",
        "companyname",
        "BizVertical",
        "Sez",
        "Export",
        "BTCComm",
        "DPComm",
        "ServiceLocation",
        "InvDescription"
    };

            // Add only the required columns to DataTable
            foreach (var columnName in requiredColumns)
            {
                dataTable.Columns.Add(columnName);
            }

            // Add rows with smart-matched column data
            foreach (var dict in list)
            {
                var row = dataTable.NewRow();

                foreach (var columnName in requiredColumns)
                {
                    // Try to find a matching key in the dictionary
                    var key = dict.Keys.FirstOrDefault(k =>
                        string.Equals(
                            NormalizeKey(k),
                            NormalizeKey(columnName),
                            StringComparison.OrdinalIgnoreCase
                        )
                    );

                    if (key != null)
                        row[columnName] = dict[key] ?? DBNull.Value;
                    else
                        row[columnName] = DBNull.Value; // Handle missing columns
                }

                dataTable.Rows.Add(row);
            }

            return dataTable;
        }

        // Helper method to normalize keys (removes spaces, slashes, underscores, makes lowercase)

        // Modified GetMasterForExport method
        public async Task<ResponseModel> GetMasterForExport(RequestModel request)
        {
            var response = new ResponseModel();

            // Level 2
            if (request.MasterFlag == "ReportDownloads")
            {
                response = await ReportDownloads(request);
            }

            byte[] fileResult;
            if (response != null && !string.IsNullOrEmpty(response.responseText))
            {
                try
                {
                    JObject obj = Cryptography.DecryptionData(response.responseText, _base64Key, isEncrypted);

                    if (obj != null && obj.Count > 0)
                    {
                        var dataList = obj["dataList"];
                        if (dataList != null && dataList.Type == JTokenType.Array)
                        {
                            try
                            {
                                var reportsList = dataList.ToObject<List<Dictionary<string, object>>>();
                                var data = new CommonClass.FileResponseViewModel<FileResponseModel>();

                                if (reportsList != null && reportsList.Count > 0)
                                {
                                    // Determine report type from request
                                    var reportType = GetReportTypeFromRequest(request);

                                    // Pick required columns if applicable
                                    List<string> requiredColumns = null;

                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "IN")
                                    {
                                        // Strict invoice column set
                                        requiredColumns = new List<string>
                                {
                                    "Invoice_ID",
                                    "Invoice_date",
                                    "File_ID",
                                    "Customer_Name",
                                    "InvoicedAgentCode",
                                    "InvoicedAgentName",
                                    "InvAgentGST",
                                    "InvAgentPAN",
                                    "InvAgentStateCode",
                                    "Curr_id",
                                    "ROE",
                                    "BasicAmt",
                                    "TaxableAmt",
                                    "TaxRate",
                                    "IGST",
                                    "CGST",
                                    "SGST",
                                    "UTGST",
                                    "TCSRate",
                                    "TotalInvAmt",
                                    "SAC_Code",
                                    "Reference",
                                    "Ref/PO Number",
                                    "Username",
                                    "Invoice_Type",
                                    "Branch GSTIN",
                                    "companyname",
                                    "BizVertical",
                                    "Sez",
                                    "BTCComm",
                                    "DPComm",
                                    "ServiceLocation",
                                    "InvDescription"
                                };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "AD")
                                    {
                                        // Strict invoice column set
                                        requiredColumns = new List<string>
                                {
                                    "Invoice_ID",
                                    "Invoice_Date",
                                    "File_ID",
                                    "Agent_ID",
                                    "InvoicedAgentName",
                                    "CompanyName",
                                    "AdLineID",
                                    "CurrencyCode",
                                    "AddendumDetailsAmount",
                                    "TotalAddendumAmount",
                                    "AddendumDescription",

                                };
                                    }

                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "XO")
                                    {
                                        // Strict invoice column set
                                        requiredColumns = new List<string>
                                {
                                    "Filecode",
                                    "Xo_id",
                                    "XO_date",
                                    "Sapcode",
                                    "XO_Supplier_Name",
                                    "Curr_ID",
                                    "XO_Amt",
                                    "Undo",
                                    "UndoDate",
                                    "IsDirectPayment",
                                    "IsBTCComm",
                                    "CompName",
                                    "XO_Customer_Name",
                                    "XO_Arr",
                                    "XO_Dep",
                                    "FHEName",
                                    "RefrenceNo",
                                    "VendorGST",
                                    "StateCode",
                                    "FileLocation"

                                };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "INR")
                                    {
                                        // Strict invoice column set
                                        requiredColumns = new List<string>
                                {
                                    "EmpName",
                                    "ReportingHead",
                                    "BookingNo",
                                    "BookingDate",
                                    "[File Code]",
                                    "Company_Name",
                                    "AgentCity",
                                    "Agent",
                                    "Customer",
                                    "[Arr Date]",
                                    "[Arr Date]",
                                    "Cancelled",

                                };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "XBTD")
                                    {
                                        // Strict invoice column set
                                        requiredColumns = new List<string>
                                {
                                    "Filecode",
                                    "Xo_id",
                                    "XO_date",
                                    "Sapcode",
                                    "XO_Supplier_Name",
                                    "Curr_ID",
                                    "XO_Amt",
                                    "Undo",
                                    "UndoDate",
                                    "IsBTCComm",
                                    "CompName",
                                    "XO_Customer_Name",
                                    "XO_Arr",
                                    "XO_Dep",
                                    "FHEName",
                                    "RefrenceNo",
                                    "VendorGST",
                                    "StateCode",
                                    "FileLocation",

                                };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "CINR")
                                    {
                                        requiredColumns = new List<string>
    {
        "EmpName",
        "BookingNo",
        "QuotationDate",
        "Filecode",
        "CompName",
        "Agent",
        "XO_Customer_Name",
        "VendorName",
        "CommType",
        "Arr_Date",
        "Dep_Date",
        "XO_ID",
        "XOArrDate",
        "XODepDate"
    };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "XBU")
                                    {
                                        requiredColumns = new List<string>
    {
        "UndoDate",
        "Filecode",
        "Xo_id",
        "XO_date",
        "Sapcode",
        "XO_Supplier_Name",
        "Curr_ID",
        "XO_Amt",
        "Undo",
        "IsDirectPayment",
        "IsBTCComm",
        "CompName",
        "XO_Customer_Name",
        "XO_Arr",
        "XO_Dep",
        "FHEName",
        "RefrenceNo",
        "VendorGST",
        "StateCode",
        "FileLocation"
    };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "PI")
                                    {
                                        requiredColumns = new List<string>
    {
        "TourStartDate",
        "TourEndDate",
        "Invoice_ID",
        "Invoice_date",
        "File_ID",
        "Customer_Name",
        "InvoicedAgentCode",
        "InvoicedAgentName",
        "InvAgentGST",
        "InvAgentPAN",
        "InvAgentStateCode",
        "Code",
        "TotalInvAmt",
        "SAC_Code",
        "Reference",
        "Ref/PO Number",
        "Username",
        "Branch_GSTIN",
        "companyname",
        "BizVertical",
        "Sez",
        "InvDescription"
    };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "IID")
                                    {
                                        requiredColumns = new List<string>
    {
        "Invoice_ID",
        "Invoice_date",
        "File_ID",
        "InvoicedAgentCode",
        "InvoicedAgentName",
        "InvAgentGST",
        "InvAgentStateCode",
        "Curr_id",
        "ROE",
        "BasicAmt",
        "TaxableAmt",
        "TaxRate",
        "IGST",
        "CGST",
        "SGST",
        "UTGST",
        "TCSRate",
        "TotalInvAmt",
        "companyname",
        "Sez",
        "AckNumber",
        "ACKDate",
        "IRN",
        "Error Message"
    };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "FD")
                                    {
                                        requiredColumns = new List<string>
    {
        "Primary QID",
        "Quote No",
        "FHE",
        "FileCode",
        "Market",
        "Pax",
        "StartDate",
        "EndDate",
        "Biz Vertical",
        "Guest Nationality",
        "Booking Type",
        "Service Type",
        "Service Location",
        "FIT / GIT",
        "Origin",
        "Agent City",
        "Agent Name",
        "Company Name",
        "Tam Sales Rep"
    };
                                    }
                                    if (!string.IsNullOrEmpty(reportType) && reportType.ToUpper() == "ED")
                                    {
                                        requiredColumns = new List<string>
    {
        "EnquiryNo",
        "EnquiryDate",
        "AgentID",
        "AgentName",
        "Agent_Market",
        "Agent_Address_Country",
        "Agent_Address_State",
        "Agent_Address_City",
        "TravelDate",
        "Description",
        "YearID",
        "CompanyName",
        "OperationOn",
        "StatusDescription",
        "Agent_Staff_Name",
        "Remark",
        "BigBilling",
    };
                                    }







                                    // Build DataTable with smart key matching
                                    var dataTable = ToDataTable(reportsList, requiredColumns);

                                    if (dataTable.Rows.Count == 0)
                                        return CommonFunctions.ProcessFileResult(data, Encoding.UTF8.GetBytes("201"));

                                    fileResult = ExportToCsv(dataTable);
                                    return CommonFunctions.ProcessFileResult(data, fileResult);
                                }
                                else
                                {
                                    return CommonFunctions.ProcessFileResult(data, Encoding.UTF8.GetBytes("201"));
                                }
                            }
                            catch (Exception ex)
                            {
                                return CommonFunctions.CreateErrorResponse(ex, "201", $"Error during deserialization: {ex.Message}");
                            }
                        }
                        else
                        {
                            return CommonFunctions.BlankResponse("201", "dataList is null or not an array.");
                        }
                    }
                    else
                    {
                        return CommonFunctions.BlankResponse("201", "Decrypted object is null or empty.");
                    }
                }
                catch (Exception ex)
                {
                    return CommonFunctions.BlankResponse("201", $"Error during decryption or deserialization: {ex.Message}");
                }
            }
            else
            {
                return CommonFunctions.BlankResponse("201", "Response or responseText is null or empty.");
            }
        }

        // Helper method to determine report type
        private string GetReportTypeFromRequest(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<ReportDownloads>(request.RequestText);
                return req?.ReportType;
            }
            catch
            {
                return null;
            }
        }
        // Helper method to determine report type


        // You can add other report-specific methods here if needed in the future
        // For now, only the Invoice report method is implemented


        //public async Task<ResponseModel> GetMasterForExport(RequestModel request)
        //{
        //    //Company, Employee, Itenerary Description, Vendor, Hotel and Agent
        //    var response = new ResponseModel();

        //    //Level 1

        //    //Level 2
        //    if (request.MasterFlag == "ReportDownloads")
        //    {
        //        response = await ReportDownloads(request);
        //    }


        //    //else if (request.MasterFlag == "AdvancePaySendRequestModel")
        //    //{
        //    //    response = await _xo.AdvancePaySendRequestModel(request);
        //    //}
        //    byte[] fileResult;
        //    if (response != null && !string.IsNullOrEmpty(response.responseText))
        //    {
        //        try
        //        {
        //            JObject obj = Cryptography.DecryptionData(response.responseText, _base64Key, isEncrypted);

        //            if (obj != null && obj.Count > 0)
        //            {
        //                var dataList = obj["dataList"]; // Change to "dataList"
        //                if (dataList != null && dataList.Type == JTokenType.Array)
        //                {
        //                    try
        //                    {
        //                        var cppReportsList = dataList.ToObject<List<Dictionary<string, object>>>();
        //                        var data = new CommonClass.FileResponseViewModel<FileResponseModel>();
        //                        if (cppReportsList != null && cppReportsList.Count > 0)
        //                        {
        //                            DataTable dataTable = ToDataTable(cppReportsList);
        //                            if (dataTable.Rows.Count == 0)
        //                                return CommonFunctions.ProcessFileResult(data, Encoding.UTF8.GetBytes("201"));
        //                            fileResult = ExportToCsv(dataTable);
        //                            return CommonFunctions.ProcessFileResult(data, fileResult);
        //                        }
        //                        else
        //                        {
        //                            return CommonFunctions.ProcessFileResult(data, Encoding.UTF8.GetBytes("201"));
        //                            //return CommonFunctions.BlankResponse("201", "No data found in the deserialized list.");
        //                        }
        //                    }
        //                    catch (Exception ex)
        //                    {
        //                        return CommonFunctions.CreateErrorResponse(ex, "201", $"Error during deserialization: {ex.Message}");
        //                    }
        //                }
        //                else
        //                {
        //                    return CommonFunctions.BlankResponse("201", "dataList is null or not an array.");
        //                }
        //            }
        //            else
        //            {
        //                return CommonFunctions.BlankResponse("201", "Decrypted object is null or empty.");
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            return CommonFunctions.BlankResponse("201", $"Error during decryption or deserialization: {ex.Message}");
        //        }
        //    }
        //    else
        //    {
        //        return CommonFunctions.BlankResponse("201", "Response or responseText is null or empty.");
        //    }
        //}


        //public DataTable ToAdvancePayDataTable(List<ReportDownloads> requestList)
        //{
        //    Console.WriteLine($" Creating DataTable for {requestList?.Count ?? 0} items");

        //    DataTable dataTable = new DataTable();

        //    try
        //    {
        //        // Define columns based on the Excel structure
        //        dataTable.Columns.Add("InvoiceId", typeof(string));
        //        //dataTable.Columns.Add("Request_ID", typeof(string));
        //        //dataTable.Columns.Add("Request_Date", typeof(string));
        //        //dataTable.Columns.Add("Requested_By", typeof(string));
        //        //dataTable.Columns.Add("FileHandler", typeof(string));
        //        //dataTable.Columns.Add("FileCode", typeof(string));
        //        //dataTable.Columns.Add("Filebranch", typeof(string));
        //        //dataTable.Columns.Add("XO_ID", typeof(string));
        //        //dataTable.Columns.Add("Curr_Id", typeof(string));
        //        //dataTable.Columns.Add("AmtToBeReleased", typeof(string));
        //        //dataTable.Columns.Add("ModeOfPay", typeof(string));
        //        //dataTable.Columns.Add("PaymentStatus", typeof(string));
        //        //dataTable.Columns.Add("AmtPaid", typeof(string));
        //        //dataTable.Columns.Add("GuestName", typeof(string));
        //        //dataTable.Columns.Add("AgentID", typeof(string));
        //        //dataTable.Columns.Add("AgentName", typeof(string));
        //        //dataTable.Columns.Add("AgentCredit", typeof(string));
        //        //dataTable.Columns.Add("HotelName", typeof(string));
        //        //dataTable.Columns.Add("VendorName", typeof(string));
        //        //dataTable.Columns.Add("PayTo", typeof(string));
        //        //dataTable.Columns.Add("HotelVendorCredit", typeof(string));
        //        //dataTable.Columns.Add("Check-in", typeof(string));
        //        //dataTable.Columns.Add("Check-out", typeof(string));
        //        //dataTable.Columns.Add("TACInvNo", typeof(string));
        //        //dataTable.Columns.Add("TACInvAmt", typeof(string));
        //        //dataTable.Columns.Add("TDS", typeof(string));
        //        //dataTable.Columns.Add("VoucherAmt", typeof(string));
        //        //dataTable.Columns.Add("GST%", typeof(string));
        //        //dataTable.Columns.Add("GST Amt", typeof(string));
        //        //dataTable.Columns.Add("VendorBillAmt", typeof(string));
        //        //dataTable.Columns.Add("IsBTCComm", typeof(string));
        //        //dataTable.Columns.Add("ChequeFavouring", typeof(string));
        //        //dataTable.Columns.Add("AccountNo", typeof(string));
        //        //dataTable.Columns.Add("Bank_Account_Name", typeof(string));
        //        //dataTable.Columns.Add("BankName", typeof(string));
        //        //dataTable.Columns.Add("IFSCCode", typeof(string));
        //        //dataTable.Columns.Add("VendorSAPCode", typeof(string));
        //        //dataTable.Columns.Add("BizVertical", typeof(string));
        //        //dataTable.Columns.Add("XOLocation", typeof(string));
        //        //dataTable.Columns.Add("ApprovedBy", typeof(string));
        //        //dataTable.Columns.Add("ReasonForadvance", typeof(string));
        //        //dataTable.Columns.Add("SAPXOBizPlaceCode", typeof(string));
        //        //dataTable.Columns.Add("PaymentStatus1", typeof(string));
        //        //dataTable.Columns.Add("AmtPaid1", typeof(string));
        //        //dataTable.Columns.Add("ProfitCentreCode", typeof(string));

        //        Console.WriteLine($" Created DataTable with {dataTable.Columns.Count} columns");

        //        if (requestList == null || requestList.Count == 0)
        //        {
        //            Console.WriteLine(" Request list is null or empty");
        //            return dataTable;
        //        }

        //        int rowCount = 0;
        //        foreach (var item in requestList)
        //        {
        //            try
        //            {
        //                //Console.WriteLine($" Processing item {rowCount + 1}: Request_ID={item?.Request_ID}, FileCode={item?.FileCode}");

        //                DataRow row = dataTable.NewRow();

        //                // Safe assignment with null checking
        //                row["InvoiceId"] = item?.InvoiceId?.ToString() ?? "";
        //                //row["Request_ID"] = item?.Request_ID ?? "";
        //                //row["Request_Date"] = item?.Request_Date;
        //                //row["Requested_By"] = item?.Requested_By ?? "";
        //                //row["FileHandler"] = item?.FileHandler ?? "";
        //                //row["FileCode"] = item?.FileCode ?? "";
        //                //row["Filebranch"] = item?.Filebranch ?? "";
        //                //row["XO_ID"] = item?.XO_ID ?? "";
        //                //row["Curr_Id"] = item?.Curr_Id ?? "";
        //                //row["AmtToBeReleased"] = item?.Amt_To_be_Released?.ToString() ?? "0";
        //                //row["ModeOfPay"] = item?.ModeOfPayment ?? "";
        //                //row["PaymentStatus"] = item?.AgentPaymentStatus?.ToString() ?? "";
        //                //row["AmtPaid"] = item?.AmtPaid.ToString() ?? "0";
        //                //row["GuestName"] = item?.GuestName ?? "";
        //                //row["AgentID"] = item?.AgentID?.ToString() ?? "";
        //                //row["AgentName"] = item?.AgentName ?? "";
        //                //row["AgentCredit"] = item?.AgentCredit ?? "";
        //                //row["HotelName"] = item?.HotelName ?? "";
        //                //row["VendorName"] = item?.Vendor_Name ?? "";
        //                //row["PayTo"] = item?.PayTo ?? "";
        //                //row["HotelVendorCredit"] = item?.Supplier_Credit?.ToString() ?? "";
        //                //row["Check-in"] = item?.Check_In;
        //                //row["Check-out"] = item?.Check_Out;
        //                //row["TACInvNo"] = item?.TAC_Invoice_No ?? "";
        //                //row["TACInvAmt"] = item?.TAC_Invoice_Amt?.ToString() ?? "0";
        //                //row["TDS"] = item?.TDS_Amt?.ToString() ?? "0";

        //                dataTable.Rows.Add(row);
        //                rowCount++;

        //                Console.WriteLine($" Successfully added row {rowCount}");
        //            }
        //            catch (Exception rowEx)
        //            {
        //                Console.WriteLine($" Error processing item {rowCount + 1}: {rowEx.Message}");
        //                // Continue with next item instead of failing completely
        //                continue;
        //            }
        //        }

        //        Console.WriteLine($" DataTable completed with {dataTable.Rows.Count} rows");
        //        return dataTable;
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine($" Error in ToAdvancePayDataTable: {ex.Message}");
        //        Console.WriteLine($"Stack trace: {ex.StackTrace}");

        //        // Return empty DataTable rather than throwing
        //        return new DataTable();
        //    }
        //}
        //public async Task<ResponseModel> GetAdvancePayReqForExport(RequestModel request)
        //{
        //    var response = new ResponseModel();

        //    if (request.MasterFlag == "AdvancePaySendRequestModel")
        //    {
        //        response = await ReportDownloads(request);
        //    }
        //    if (response == null || string.IsNullOrEmpty(response.responseText))
        //    {
        //        return CommonFunctions.BlankResponse("201", "Response or responseText is null or empty.");
        //    }
        //    try
        //    {
        //        string decryptedData = Cryptography.DecryptStringAES(response.responseText, _base64Key);

        //        if (string.IsNullOrWhiteSpace(decryptedData))
        //        {
        //            return CommonFunctions.BlankResponse("201", "Decrypted data is null or empty.");
        //        }

        //        JObject jsonObj = JObject.Parse(decryptedData);

        //        var modelList = new List<ReportDownloads>();

        //        if (jsonObj["dataList"] is JArray dataArray && dataArray.HasValues)
        //        {
        //            modelList = dataArray.ToObject<List<ReportDownloads>>();
        //        }
        //        else if (jsonObj["data"] is JObject singleData && singleData.HasValues)
        //        {
        //            var model = singleData.ToObject<ReportDownloads>();
        //            modelList.Add(model);
        //        }
        //        else
        //        {
        //            return CommonFunctions.BlankResponse("201", "No valid data or dataList found.");
        //        }

        //        var dataTable = ToAdvancePayReqDataTable(modelList);

        //        if (dataTable.Rows.Count == 0)
        //        {
        //            var emptyData = new CommonClass.FileResponseViewModel<FileResponseModel>();
        //            return CommonFunctions.ProcessFileResult(emptyData, Encoding.UTF8.GetBytes("201"));
        //        }

        //        byte[] fileResult = ExportToCsv(dataTable);
        //        var finalData = new CommonClass.FileResponseViewModel<FileResponseModel>();
        //        return CommonFunctions.ProcessFileResult(finalData, fileResult);
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.BlankResponse("201", $"Error during decryption or processing: {ex.Message}");
        //    }
        //}


        //public DataTable ToAdvancePayReqDataTable(List<ReportDownloads> requestList)
        //{
        //    DataTable dataTable = new DataTable();

        //    // Define columns based on the Excel structure
        //    dataTable.Columns.Add("InvoiceId", typeof(DateTime));
        //    dataTable.Columns.Add("RequestID", typeof(string));
        //    dataTable.Columns.Add("FHE", typeof(Guid));
        //    dataTable.Columns.Add("FileCode", typeof(string));
        //    dataTable.Columns.Add("XO", typeof(string));
        //    dataTable.Columns.Add("PayTo", typeof(string));
        //    dataTable.Columns.Add("GuestName", typeof(string));
        //    dataTable.Columns.Add("AgentName", typeof(string));
        //    dataTable.Columns.Add("Status", typeof(string));

        //    foreach (var item in requestList)
        //    {
        //        DataRow row = dataTable.NewRow();
        //        row["Request_Date"] = item.InvoiceId ?? (object)DBNull.Value;

        //        //row["RequestID"] = item.RequestId;
        //        //row["FHE"] = item.FHE;
        //        //row["FileCode"] = item.FileCode;
        //        //row["XO"] = item.XO;
        //        //row["PayTo"] = item.PayTo;
        //        //row["GuestName"] = item.GuestName;
        //        //row["AgentName"] = item.AgentName;
        //        //row["Status"] = item.Status;

        //        dataTable.Rows.Add(row);
        //    }

        //    return dataTable;
        //}

        public static DataTable ToDataTable(List<Dictionary<string, object>> list, List<string> requiredColumns = null)
        {
            var dataTable = new DataTable();

            if (list == null || list.Count == 0)
                return dataTable;

            // If requiredColumns not provided, take all keys from the first row
            if (requiredColumns == null || requiredColumns.Count == 0)
            {
                requiredColumns = list[0].Keys.ToList();
            }

            // Add only required columns
            foreach (var columnName in requiredColumns)
            {
                dataTable.Columns.Add(columnName);
            }

            // Add rows
            foreach (var dict in list)
            {
                var row = dataTable.NewRow();

                foreach (var columnName in requiredColumns)
                {
                    // Try to find a matching key in the dictionary (smart matching)
                    var key = dict.Keys.FirstOrDefault(k =>
                        string.Equals(
                            NormalizeKey(k),
                            NormalizeKey(columnName),
                            StringComparison.OrdinalIgnoreCase
                        )
                    );

                    if (key != null)
                        row[columnName] = dict[key] ?? DBNull.Value;
                    else
                        row[columnName] = DBNull.Value;
                }

                dataTable.Rows.Add(row);
            }

            return dataTable;
        }

        // 🔑 Shared normalizer (can be reused everywhere)
        private static string NormalizeKey(string key)
        {
            if (string.IsNullOrEmpty(key)) return string.Empty;
            return key.Replace(" ", "")
                      .Replace("/", "")
                      //.Replace("_", "")
                      .ToLowerInvariant();
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
        #endregion ReportDownloads ends here
        #region xodata starts here 

        public async Task<ResponseModel> XODataModel(RequestModel request)

        {

            ResponseModel _resModel = new ResponseModel();

            try

            {

                // Decrypt and deserialize the request

                var req = CommonFunctions.DecryptAndDeserializeRequest<XODataModel>(request.RequestText);

                if (req != null)

                {

                    var parameters = new

                    {

                        @FILEID = req.FILEID,

                        @YearCode = req.YearCode,

                        @CompCode = req.CompCode,
                        @Action = req.Action,

                    };

                    var data = new CommonClass.ResponseViewModel<XODataModel>();

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_XO_Data", parameters);
                    //Changes
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_XO_Data", parameters);

                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

            }

            catch (Exception ex)

            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");

            }

        }

        #endregion xodata ends here

        #region GREXOViewModel starts here
        public async Task<ResponseModel> GREXOViewModel(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GREXOViewModel>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @FileCode = req.FileCode,
                        @XONo = req.XONo,
                        @VendorID = req.VendorID,
                        @dpXOArr = req.dpXOArr,
                        @dpXOTo = req.dpXOTo,
                    };

                    var data = new CommonClass.ResponseViewModel<GREXOViewModel>();
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "GetGREXOView", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion GREXOViewModel ends here

        #region SearchFileCodeXoNoQuotation starts here
        public async Task<ResponseModel> SearchFileCodeXoNoQuotation(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SearchFileCodeXoNoQuotation>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @FileCode = req.FileCode,
                        @XoNo = req.XoNo,
                        @IsLocked = req.IsLocked,
                        @CompID = req.CompID,
                        @YearID = req.YearID
                    };

                    var data = new CommonClass.ResponseViewModel<SearchFileCodeXoNoQuotation>();
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "USP_SearchFileCode_XoNo_Quotation", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchFileCodeXoNoQuotation ends here

        #region UpdateLockUnlockQuotationModel starts here
        public async Task<ResponseModel> UpdateLockUnlockQuotationModel(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<UpdateLockUnlockQuotationModel>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @FileCode = req.FileCode,
                        @Var = req.Var,
                        @CompID = req.CompID,
                        @YearID = req.YearID,
                        @OperationBy = req.OperationBy,
                        @XoNumber = req.XoNumber
                    };

                    var data = new CommonClass.ResponseViewModel<UpdateLockUnlockQuotationModel>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, "U", "USP_UpdateDataForLockUnlockQuotation", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion UpdateLockUnlockQuotationModel ends here


        #region File2FileMapping starts here
        public async Task<ResponseModel> File2FileMapping(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<File2FileMapping>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @CompanyID = req.CompanyID,
                        @YearID1 = req.YearID1,
                        @YearCode1 = req.YearCode1,
                        @FileCode1 = req.FileCode1,
                        @YearID2 = req.YearID2,
                        @YearCode2 = req.YearCode2,
                        @FileCode2 = req.FileCode2,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @ID = req.ID,
                        @Action = req.Action

                    };

                    var data = new CommonClass.ResponseViewModel<File2FileMapping>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_File2FileMapping", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion File2FileMapping ends here

        #region GetReportTypes starts here
        public async Task<ResponseModel> GetReportTypes(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GetReportTypes>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<GetReportTypes>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "GetReportTypes", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion GetReportTypes ends here

        #region filecode starts here

        public async Task<ResponseModel> FileCode(RequestModel request)

        {

            ResponseModel _resModel = new ResponseModel();

            try

            {

                // Decrypt and deserialize the request

                var req = CommonFunctions.DecryptAndDeserializeRequest<FileCodes>(request.RequestText);

                if (req != null)

                {

                    var parameters = new

                    {

                        @CompanyID = req.CompanyID,

                        @YearID = req.YearID,

                        @FileCode = req.FileCode,

                        @Action = req.Action,

                    };

                    var data = new CommonClass.ResponseViewModel<FileCodes>();

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GetFileCode", parameters);

                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

            }

            catch (Exception ex)

            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");

            }

        }

        #endregion filecode ends here


    }
}
