using CommonClass;
using Microsoft.Extensions.Options;
using NLog;
using TamarindAstra.Common;
using TamarindAstra_Operations.Interface;
using TamarindAstra_Operations.Model;


namespace TamarindAstra_Operations.Repository
{
    public class OperationsRepository : IOperations
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        private readonly string isEncrypted;
        public OperationsRepository(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];
        }

        #region GetUserMail Starts here
        //new 
        public async Task<ResponseModel> GetUserMail(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GetUserMail>(request.RequestText);
                logger.Debug("CountryMaster method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @userid = req.UserId
                    };

                    var data = new CommonClass.ResponseViewModel<GetUserMail>();
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetUserMail", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion GetUserMail ends here

        #region Insert_HotelRegistration_Mail Starts here
        //new 
        public async Task<ResponseModel> Insert_HotelRegistration_Mail(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<Insert_HotelRegistration_Mail>(request.RequestText);
                logger.Debug("CountryMaster method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @FromEmail = req.FromEmail,
                        @ToEmail = req.ToEmail,
                        @CCEmail = req.CcEmail,
                        @EmailSubject = req.EmailSubject,
                        @EmailBody = req.EmailBody,
                        @OperationBy = req.OperationBy,
                        @id = req.ID
                    };

                    var data = new CommonClass.ResponseViewModel<Insert_HotelRegistration_Mail>();
                    return CommonFunctions.ProcessDBData(data, "", "usp_Insert_HotelRegistration_Mail", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion Insert_HotelRegistration_Mail ends here

        #region VendorRegistration_Mail Starts here
        //new 
        public async Task<ResponseModel> VendorRegistration_Mail(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<VendorRegistration_Mail>(request.RequestText);
                logger.Debug("CountryMaster method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @FromEmail = req.FromEmail,
                        @ToEmail = req.ToEmail,
                        @CCEmail = req.CcEmail,
                        @EmailSubject = req.EmailSubject,
                        @EmailBody = req.EmailBody,
                        @OperationBy = req.OperationBy,
                        @id = req.ID,
                        @ReasonForAddingVendor = req.ReasonForAddingVendor,
                        @VendorService = req.VendorService,
                        @AccountGroupCode = req.AccountGroupCode,
                        @AccountGroupName = req.AccountGroupName
                    };

                    var data = new CommonClass.ResponseViewModel<VendorRegistration_Mail>();
                    return CommonFunctions.ProcessDBData(data, "", "usp_Insert_VendorRegistration_Mail", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion VendorRegistration_Mail ends here

        #region FileSummary Starts here
        //new 
        public async Task<ResponseModel> FileSummary(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<FileSummary>(request.RequestText);
                logger.Debug("CountryMaster method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @dtFromdate = req.FromDate,
                        @dtTodate = req.ToDate,
                        @reportType = req.reportType,
                        @YearCode = req.YearCode,
                        @OperationBy = req.OperationBy,
                    };

                    var data = new CommonClass.ResponseViewModel<FileSummary>();
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "FileSummary_DetailsTransaction", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion FileSummary ends here

        #region FetchItineraryDetails Starts here
        //new 
        public async Task<ResponseModel> FetchItineraryDetails(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<FetchItineraryDetails>(request.RequestText);
                logger.Debug("CountryMaster method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @ItineraryID = req.ItineraryID,
                        @FileCode = req.FileCode,
                        @EnquiryID = req.EnquiryID,
                        @Country = req.Country,
                        @TourDate = req.TourDate,
                        @IsDate = req.IsDate,
                        @IsActive = req.IsActive,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<FetchItineraryDetails>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_FetchItineraryDetails", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion FetchItineraryDetails ends here

        public async Task<ResponseModel> FetchReasonMaster(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<ReasonMaster>(request.RequestText);
                logger.Debug("FetchReasonMaster method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                    };
                    var data = new CommonClass.ResponseViewModel<ReasonMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "Quotation.usp_FetchReasonMasterDD", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> usp_AutoCompleteSearch(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<AutoCompleteSearch>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("usp_AutoCompleteSearch method called");


                var parameters = new
                {
                    @Action = req.Action,
                    @Filter = req.Filter
                };

                var data = new CommonClass.ResponseViewModel<AutoCompleteSearch>();
                return CommonFunctions.ProcessDBData(data, "S", "usp_AutoCompleteSearch", parameters);
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " usp_AutoCompleteSearch Failed");
            }
        }

    }
}