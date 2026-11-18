using BusinessLogic.Interface;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TamarindAstra.Model.DBModel;
//using TamarindAstra.Model.ViewModel;
using Dapper;
using System.Net;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using DataAccess.Model.DBModel;
//using Microsoft.Azure.Amqp.Framing;
//using DocumentFormat.OpenXml.Drawing.Charts;
//using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using Newtonsoft.Json;
using NLog;
using TamarindAstra.Common;
using Microsoft.Extensions.Options;
using Azure.Core;
//using DocumentFormat.OpenXml.Office2016.Excel;
//using DocumentFormat.OpenXml.Drawing;
using Newtonsoft.Json.Linq;
using static Azure.Core.HttpHeader;
using System.Security.Cryptography.Xml;
using Azure;
//using DocumentFormat.OpenXml.Vml.Spreadsheet;
using Microsoft.Extensions.Logging;
using DataAccess.l.DBModel;
using CommonClass;

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
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<PLBMaster>(request.RequestText);
                logger.Debug("PLBMaster method called");

                if (req != null)
                {
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

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
                        @Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here
                    var (statusresponse, PLBMasterResponse) = SqlHelper.LoadDataWithTable<StatusModel, PLBMaster, dynamic>("usp_PLBMaster", parameters);

                    if (statusresponse != null)
                    {
                        var data = new CommonClass.ResponseViewModel<PLBMaster>();
                        data.returnCode = statusresponse.returnCode?.ToString();
                        data.returnMessage = statusresponse.returnMessage;

                        // Handle specific actions based on the request
                        if (req.Action.ToLower() == "s")
                        {
                            var dataList = PLBMasterResponse;
                            //data.dataList = dataList;
                            data.data = data.data; // Assuming 'data' is a property in your ViewModel
                            return CommonFunctions.ProcessResult(data);
                        }
                    }

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

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgewiseandHotelwiseRoomNights>(request.RequestText);
                logger.Debug("AgewiseandHotelwiseRoomNights method called");

                if (req != null)
                {
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    var parameters = new
                    {
                        @FromDate = req.FromDate,
                        @ToDate = req.ToDate,
                        @ReportType = req.ReportType,
                        @YearCode = req.YearCode,
                        @Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here
                    var (statusresponse, AgewiseandHotelwiseRoomNightsResponse) = SqlHelper.LoadDataWithTable<StatusModel, AgewiseandHotelwiseRoomNights, dynamic>("USP_GetCPPReportData_ACCOM_NEW", parameters);

                    if (statusresponse != null)
                    {
                        var data = new CommonClass.ResponseViewModel<AgewiseandHotelwiseRoomNights>();
                        data.returnCode = statusresponse.returnCode?.ToString();
                        data.returnMessage = statusresponse.returnMessage;

                        // Handle specific actions based on the request
                        if (req.Action.ToLower() == "s")
                        {
                            var dataList = AgewiseandHotelwiseRoomNightsResponse;
                            //data.dataList = dataList;
                            data.data = data.data; // Assuming 'data' is a property in your ViewModel
                            return CommonFunctions.ProcessResult(data);
                        }
                    }

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
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

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
                        @Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here
                    var (statusresponse, PackageCodeMasterResponse) = SqlHelper.LoadDataWithTable<StatusModel, PackageCodeMaster, dynamic>("USP_InsertPackageCodeMaster", parameters);

                    if (statusresponse != null)
                    {
                        var data = new CommonClass.ResponseViewModel<PackageCodeMaster>();
                        data.returnCode = statusresponse.returnCode?.ToString();
                        data.returnMessage = statusresponse.returnMessage;

                        // Handle specific actions based on the request
                        if (req.Action.ToLower() == "s")
                        {
                            var dataList = PackageCodeMasterResponse;
                            //data.dataList = dataList;
                            data.data = data.data; // Assuming 'data' is a property in your ViewModel
                            return CommonFunctions.ProcessResult(data);
                        }
                    }

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

    }
}
