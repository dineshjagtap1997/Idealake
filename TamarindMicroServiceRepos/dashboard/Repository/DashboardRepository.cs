using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using TamarindAstra.Common;
using CommonClass;
using TamarindAstraLoginDashboardReport.Models;
using TamarindAstraLoginDashboardReport.Interface;
using System.Text;
using System.Security.Cryptography;
using NLog;
using static TamarindAstraLoginDashboardReport.Models.DashboardModel;
using System.ComponentModel.Design;
using NPOI.POIFS.Properties;
using Newtonsoft.Json.Linq;
using Microsoft.Extensions.Options;
using static Microsoft.IO.RecyclableMemoryStreamManager;
using static Org.BouncyCastle.Math.EC.ECCurve;
using System.Data;
namespace TamarindAstraLoginDashboardReport.Repository
{
    public class DashboardRepository : IDashboard
    {
        private readonly IDashboard _dashboard;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger();

        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private readonly string isEncrypted;


        public DashboardRepository(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:IsEncrypted"];
        }

        public async Task<ResponseModel> GetTourStartingEnding(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("GetTourStartingEnding method called");

                var parameters = new
                {
                    @Action = req.Action,
                    @BookingID = (object?)null,
                    @QuotationID = (object?)null,
                    @EnquryID = (object?)null,
                    @FileCode = (object?)null,
                    @AgentName = (object?)null,
                    @customerName = (object?)null,
                    @GuestName = (object?)null,
                    @XONumber = (object?)null,
                    @InvoiceNumber = (object?)null,
                    @PageNumber = req.PageNumber,
                    @FromDate = (object?)null,
                    @ToDate = (object?)null,
                    @Status = 3,
                    @FHE = req.FHE,
                    @isArrivalDate = 0,
                    @AgentID = (object?)null,
                    @DateFilterType = req.DateFilterType,
                    @DaysRange = req.DaysRange,
                    @CompanyId = req.CompanyID,
                    @YearId = req.YearID
                };

                var data = new CommonClass.ResponseViewModel<QuotationMaster>();
                return CommonFunctions.ProcessDBDataPagination(data, req.Action, "Booking.usp_BookingDetails", parameters);


                //if (req.Action.ToLower() == "ex")
                //{
                //    // Manually map GSTTypeMaster to GSTTypeMasterExportModel
                //    var exportModel = new TourStartingEndingExportModel
                //    {
                //        Action = req.Action,
                //        BookingID = (object?)null,
                //        QuotationID = (object?)null,
                //        EnquryID = (object?)null,
                //        FileCode = (object?)null,
                //        AgentName = (object?)null,
                //        customerName = (object?)null,
                //        GuestName = (object?)null,
                //        XONumber = (object?)null,
                //        InvoiceNumber = (object?)null,
                //        PageNumber = req.PageNumber,
                //        @FromDate = (object?)null,
                //        @ToDate = (object?)null,
                //        @Status = 3,
                //        @FHE = req.FHE,
                //        @isArrivalDate = 0,
                //        @AgentID = (object?)null,
                //        @DateFilterType = req.DateFilterType,
                //        @DaysRange = req.DaysRange,
                //        @CompanyId = req.CompanyID,
                //        @YearId = req.YearID
                //    };

                //    var data = new CommonClass.ResponseViewModel<SACMasterExportModel>
                //    {
                //        data = exportModel
                //    };

                //    return CommonFunctions.ProcessDBData(data, req.Action, "USP_ManageSAC", parameters);
                //}
                //else
                //{
                //    var data = new CommonClass.ResponseViewModel<SACMaster>
                //    {
                //        data = req
                //    };

                //    return CommonFunctions.ProcessDBData(data, req.Action, "USP_ManageSAC", parameters);
                //}
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " GetQuotationsBasedOnFilter Failed");
            }
        }

        public async Task<ResponseModel> GetAdvancePaymentRequest(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<AdvancePaymentRequest>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @BookingID = (object?)null,
                        @IsDashboard = req.IsDashboard,
                        @DashCompanyId = req.DashCompanyId,
                        @OperationBy = req.OperationBy,
                        @DashYearId = req.DashYearId,
                        @DaysCount = req.DaysCount,
                        @Action = req.Action
                    };
                    var data = new CommonClass.ResponseViewModel<AdvancePaymentRequest>
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

        public async Task<ResponseModel> GetDashboardCount(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Dashboard>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @CompanyId = req.CompanyId,
                        @YearId = req.YearId,
                        @OperationBy = req.OperationBy,
                        @DaysCount = req.DaysCount,
                    };
                    var data = new CommonClass.ResponseViewModel<Dashboard>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Get_Dashboard_Count", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }


        public async Task<ResponseModel> GetDashboardStayTransport(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Dashboard>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @CompanyId = req.CompanyId,
                        @YearId = req.YearId,
                        @OperationBy = req.OperationBy,
                        @DaysCount = req.DaysCount,
                        @PageNumber = req.PageNumber,
                    };
                    

                    var data = new CommonClass.ResponseViewModel<Dashboard>();
                    //return CommonFunctions.ProcessDBData(data, req.Action, "usp_GetDashboardStayTransport", parameters);
                    return CommonFunctions.ProcessDBDataPagination(data, req.Action, "usp_GetDashboardStayTransport", parameters);

                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }
        public async Task<ResponseModel> GetDashAgentInvoice(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Dashboard>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @CompanyId = req.CompanyId,
                        @YearId = req.YearId,
                        @OperationBy = req.OperationBy,
                        @DaysCount = req.DaysCount,
                    };
                    var data = new CommonClass.ResponseViewModel<Dashboard>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GetDashAgentInvoice", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }


        public async Task<ResponseModel> GetDashCommInvoice(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Dashboard>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @CompanyId = req.CompanyId,
                        @YearId = req.YearId,
                        @OperationBy = req.OperationBy,
                        @DaysCount = req.DaysCount,
                    };
                    var data = new CommonClass.ResponseViewModel<Dashboard>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GetDashCommInvoice", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }


        public async Task<ResponseModel> GetDashPerformaNotConverted(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Dashboard>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                        @CompanyId = req.CompanyId,
                        @YearId = req.YearId,
                        @OperationBy = req.OperationBy,
                        @DaysCount = req.DaysCount,
                    };
                    var data = new CommonClass.ResponseViewModel<Dashboard>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GetDashPerformaNotConverted", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Insert XO Failed");
            }
        }


        public async Task<ResponseModel> GetMasterForExport(RequestModel request)
        {
            var response = new ResponseModel();

            // Level 2
            if (request.MasterFlag == "GetTourStartingEnding")
            {
                response = await GetTourStartingEnding(request);
            }

            if (request.MasterFlag == "GetDashboardStayTransport")
            {
                response = await GetDashboardStayTransport(request);
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


                                    // Pick required columns if applicable
                                    List<string> requiredColumns = null;

                                    if (request.MasterFlag == "GetTourStartingEnding")
                                    {
                                        requiredColumns = new List<string>
                                {
                                    "StartDate",
                                     "FHEName",
                                    "GuestName",
                                    "AgentName",
                                    "FileCode"

                                };

                                    }
                                    else if (request.MasterFlag == "GetDashboardStayTransport")
                                    {
                                        requiredColumns = new List<string>
                                {
                                    "StartDate",
                                     "FHEName",
                                    "GuestName",
                                    "CityName",
                                    "HotelName",
                                    "Transport"
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
    }
}
