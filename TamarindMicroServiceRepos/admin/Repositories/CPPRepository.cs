

using BusinessLogic.Interface;
using CommonClass;
using DataAccess.Model.DBModel;
using Microsoft.Extensions.Options;
using Newtonsoft.Json.Linq;
using NLog;
using System.Data;
using System.Text;
using TamarindAstra.Common;

namespace BusinessLogic.Repositories
{
    public class CPPRepository : ICPP
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        private readonly string isEncrypted;


        public CPPRepository(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];
        }


        //new
        public async Task<ResponseModel> PLBMaster(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<PLBMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @PLBID = req.PLBID,
                        @CityCode = req.CityCode,
                        @HotelID = req.HotelID,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo,
                        @Target = req.Target,
                        @ValidonRateType = req.ValidonRateType,
                        @PLBClaim = req.PLBClaim,
                        @PLBType = req.PLBType,
                        @ClaimPeriod = req.ClaimPeriod,
                        @HotelGroupID = req.HotelGroupID,
                        @OperationBy = req.OperationBy,
                       @IsActive = req.IsActive,
                        @Action = req.Action
                       
                    };

                    var data = new CommonClass.ResponseViewModel<PLBMaster>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_PLBMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        //new
        public async Task<ResponseModel> AgewiseandHotelwiseRoomNights(RequestModel request)
        {
            var response = new ResponseModel();

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgewiseandHotelwiseRoomNights>(request.RequestText);
                logger.Debug("AgewiseandHotelwiseRoomNights method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @FromDate = req.FromDate,
                        @ToDate = req.ToDate,
                        //@ReportType = req.ReportType,
                        //@YearCode = req.YearCode,
                        //@Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here
                    // var (statusresponse, AgewiseandHotelwiseRoomNightsResponse) = SqlHelper.LoadDataWithTable<StatusModel, AgewiseandHotelwiseRoomNights, dynamic>("MIS_AgentRoomNight_New", parameters);

                    //if (statusresponse != null)
                    //{
                    //    var data = new CommonClass.ResponseViewModel<AgewiseandHotelwiseRoomNights>();
                    //    data.returnCode = statusresponse.returnCode?.ToString();
                    //    data.returnMessage = statusresponse.returnMessage;
                    //    data.dataList = AgewiseandHotelwiseRoomNightsResponse.ToList();
                    //    // Handle specific actions based on the request
                    //    if (req.Action.ToLower() == "s")
                    //    {
                    //        var dataList = AgewiseandHotelwiseRoomNightsResponse;
                    //        //data.dataList = dataList;
                    //        data.data = data.data; // Assuming 'data' is a property in your ViewModel
                    //        return CommonFunctions.ProcessResult(data);
                    //    }
                    //}
                    var data = new CommonClass.ResponseViewModel<AgewiseandHotelwiseRoomNights>();
                    var exportRequest = CommonFunctions.ProcessDBData_WitoutAction(data, "MIS_AgentRoomNight_New", parameters);
                    response = ExportCPPReports(exportRequest).Result;
                    return response;
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        //new
        public async Task<ResponseModel> PackageCodeMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<PackageCodeMaster>(request.RequestText);
                if (req != null)
                {
                    var parameters = new
                    {
                        @PkgMktCode = req.PkgMktCode,
                        @Nights = req.Nights,
                        @StateRouteCode = req.StateRouteCode,
                        @ExtnAssignedCode = req.ExtnAssignedCode,
                        @PackageName = req.PackageName,
                        @Remarks = req.Remarks,
                        @PackageCode = req.PackageCode,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @IsActive = req.IsActive
                    };

                    var data = new CommonClass.ResponseViewModel<PackageCodeMaster>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_InsertPackageCodeMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        //new
        public async Task<ResponseModel> CPPReports(RequestModel request)
        {
            var response = new ResponseModel();

            var dataTable = new DataTable();
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<CPPReport>(request.RequestText);
                if (req != null)
                {
                    var parameters = new
                    {
                        @dtFromdate = req.FromDate,
                        @dtTodate = req.ToDate,
                        @reportType = req.ReportType

                    };

                    var data = new CommonClass.ResponseViewModel<dynamic>();
                    var exportRequest =  CommonFunctions.ProcessDBData_WitoutAction<dynamic>(data, "USP_GetCPPReportData_ACCOM_NEW", parameters);
                     response = ExportCPPReports(exportRequest).Result;
                    //  return CommonFunctions.ProcessDBData_WitoutAction<dynamic>(data, "USP_GetCPPReportData_ACCOM_NEW", parameters);
                    return response;
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> ExportCPPReports(ResponseModel response)
        {
            byte[] fileResult;
            if (response != null && !string.IsNullOrEmpty(response.responseText))
            {
                try
                {
                    JObject obj = Cryptography.DecryptionData(response.responseText, _base64Key, isEncrypted);

                    if (obj != null && obj.Count > 0)
                    {
                        var dataList = obj["dataList"]; // Change to "dataList"
                        if (dataList != null && dataList.Type == JTokenType.Array)
                        {
                            try
                            {
                                var cppReportsList = dataList.ToObject<List<Dictionary<string, object>>>();

                                if (cppReportsList != null && cppReportsList.Count > 0)
                                {
                                    DataTable dataTable = ToDataTable(cppReportsList);
                                    var data = new CommonClass.FileResponseViewModel<FileResponseModel>();
                                    if (dataTable.Rows.Count == 0)
                                        return CommonFunctions.ProcessFileResult(data, Encoding.UTF8.GetBytes("201"));
                                    fileResult = ExportToCsv(dataTable);
                                    return CommonFunctions.ProcessFileResult(data, fileResult);
                                }
                                else
                                {
                                    return CommonFunctions.BlankResponse("201", "No data found in the deserialized list.");
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



    }
}
