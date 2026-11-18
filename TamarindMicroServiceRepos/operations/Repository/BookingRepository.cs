using AutoMapper;
using CommonClass;
using Dapper;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using NLog;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra_Operations.Interface;
using TamarindAstra_Operations.Model;

namespace TamarindAstra_Operations.Repository
{
    public class BookingRepository : IBooking
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger();
        private readonly string isEncrypted;

        private readonly IMapper _mapper;

        public BookingRepository(IConfiguration config, IOptions<Cryptography> options, IMapper mapper)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];

            _mapper = mapper;
        }

        public async Task<ResponseModel> GetAllQuotations()
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("GetAllQuotations method called");


                var parameters = new
                {
                    @Action = "S",
                };

                var data = new CommonClass.ResponseViewModel<QuotationMaster>();
                return CommonFunctions.ProcessDBData(data, "S", "usp_BookingDetails", parameters);

            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> GetQuotationsbybookingId(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("GetQuotationsBasedBookingId method called");


                var parameters = new
                {
                    @Action = "U",
                    @BookingId = req.BookingID
                };

                var data = new CommonClass.ResponseViewModel<QuotationMaster>();
                return CommonFunctions.ProcessDBData(data, "U", "usp_BookingDetails", parameters);
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " GetQuotationsBasedBookingId Failed");
            }
        }
        //Get Quotations Details based on filter
        //Get Quotations Details based on filter
        public async Task<ResponseModel> GetQuotationsBasedOnFilter(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("GetQuotationsBasedOnFilter method called");


                var parameters = new
                {
                    @Action = req.Action,
                    @BookingID = req.BookingID,
                    @QuotationID = req.QuotationID,
                    @EnquryID = req.EnquiryID,
                    @FileCode = req.FileCode,
                    @AgentName = req.AgentName,
                    @customerName = req.CustomerName,
                    @GuestName = req.GuestName,
                    @XONumber = req.XONumber,
                    @InvoiceNumber = req.InvoiceNo,
                    @FromDate = req.FromDate,
                    @ToDate = req.ToDate,
                    @Status = req.QuoteStatus,
                    @FHE = req.FHE,
                    @PageNumber = req.PageNumber,
                    @isArrivalDate = req.isArrivalDate,
                    @AgentID = req.AgentID,
                    @BookingNo = req.BookingNo,
                    @CreatedBy= req.CreatedBy,
                    @YearID = req.YearID,
                    @CompanyID = req.CompanyID,
                    @QuotationNo = req.QuotationNo,
                    @EnquiryNo = req.EnquiryNo
                    ,

                };

                var data = new CommonClass.ResponseViewModel<QuotationMaster>();
                //return CommonFunctions.ProcessDBData(data, req.Action, "Booking.usp_BookingDetails", parameters);
                return CommonFunctions.ProcessDBDataPagination(data, req.Action, "Booking.usp_BookingDetails", parameters);


            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " GetQuotationsBasedOnFilter Failed");
            }
        }
        #region Booking_PrimaryInfo

        public async Task<ResponseModel> Get_Booking_PrimaryInfo(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);


            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Get_Booking_PrimaryInfo method called");


                var parameters = new
                {
                    @Action = "S",
                    @ID = req.ID
                };

                var data = new CommonClass.ResponseViewModel<BookingMaster>();
                return CommonFunctions.ProcessDBData(data, "S", "usp_InsertUpdateBooking_PrimaryInfo", parameters);

            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> Insert_Booking_PrimaryInfo(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Insert_Booking_PrimaryInfo method called");


                var parameters = new
                {

                    @Action = req.Action,
                    @ID = req.ID,
                    @QuotationID = req.QuotationID,
                    @StartDate = req.StartDate,
                    @EndDate = req.EndDate,
                    @City = req.City,
                    @Service = req.Service,
                    @Vehical = req.Vehical,
                    @Vendor = req.Vendor,
                    @Currency = req.Currency,
                    @Count = req.Count,
                    @Adult = req.Adult,
                    @Child = req.Child,
                    @Consolidated = req.Consolidated,
                    @Nationality = req.Nationality,
                    @Cost = req.Cost,
                    @Type = req.Type,
                    @Lock = req.Lock,
                    @FileCode = req.FileCode,
                    @GuestName = req.GuestName,
                    @XONumber = req.XONumber,
                    @BookingID = req.BookingID,
                    @Status = req.Status,
                    @FHE = req.FHE,
                    @PaxName = req.PaxName,
                    @MobileNO = req.MobileNO,
                    @PaxEmailID = req.PaxEmailID,
                    @Numberofpax = req.Numberofpax,
                    @BizVirticale = req.BizVirticale,
                    @DepartmentID = req.DepartmentID,
                    @BookingCreationDate = req.BookingCreationDate,
                    @PrePone = req.PrePone,
                    @PrePoneDate = req.PrePoneDate,
                    @AgentInvoiceReq = req.AgentInvoiceReq,
                    @Reason = req.Reason,
                    @PacageCode = req.PacageCode,
                    @PrmSrvcLoc = req.PrmSrvcLoc,
                    @Origin = req.Origin,
                    @OnlineBookingID = req.OnlineBookingID,
                    @FIT = req.FIT,
                    @SupplierTax_B2b = req.SupplierTax_B2b,
                    @SupplierTax_InCluding = req.SupplierTax_InCluding,
                    @MarkupType_Gross = req.MarkupType_Gross,
                    @AgentID = req.AgentID,
                    @MarketID = req.MarketID,
                    @CityIATACode = req.CityIATACode,
                    @BillingAddress = req.BillingAddress,
                    @PANNo = req.PANNo,
                    @GSTNo = req.GSTNo,
                    @TANNo = req.TANNo,
                    @SEZ = req.SEZ,
                    @FreeZone = req.FreeZone,
                    @AgentOnCredit = req.AgentOnCredit,
                    @CreditAmount = req.CreditAmount,
                    @OutStandingAmount = req.OutStandingAmount,
                    @DBL = req.DBL,
                    @EBA = req.EBA,
                    @EBC = req.EBC,
                    @CNB = req.CNB,
                    @SGL = req.SGL,
                    @Twin = req.Twin,
                    @taxID = req.taxID,
                    @UserNote1 = req.UserNote1,
                    @UserNote2 = req.UserNote2,
                    @CreatedBy = req.CreatedBy,
                    @TamSalesrep = req.TamSalesrep,
                    @ReassignTo = req.ReassignTo,
                    @YearID = req.YearID,
                    @CompanyID = req.CompanyID,

                };

                var data = new CommonClass.ResponseViewModel<BookingMaster>();
                _resModel = CommonFunctions.ProcessDBData(data, "I", "usp_InsertUpdateBooking_PrimaryInfo", parameters);
                _resModel.returnCode = data.returnCode;
                _resModel.returnMessage = data.returnMessage;
                return _resModel;

            }

            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " Insert_Booking_PrimaryInfo Failed");
            }
        }

        public async Task<ResponseModel> Update_Booking_PrimaryInfo(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);
            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Update_Booking_PrimaryInfo method called");


                var parameters = new
                {

                    @Action = "U",
                    @ID = req.ID,
                    @QuotationID = req.QuotationID,
                    @StartDate = req.StartDate,
                    @EndDate = req.EndDate,
                    @City = req.City,
                    @Service = req.Service,
                    @Vehical = req.Vehical,
                    @Vendor = req.Vendor,
                    @Currency = req.Currency,
                    @Count = req.Count,
                    @Adult = req.Adult,
                    @Child = req.Child,
                    @Consolidated = req.Consolidated,
                    @Nationality = req.Nationality,
                    @Cost = req.Cost,
                    @Type = req.Type,
                    @Lock = req.Lock,
                    @FileCode = req.FileCode,
                    @GuestName = req.GuestName,
                    @XONumber = req.XONumber,
                    @BookingID = req.BookingID,
                    @Status = req.Status,
                    @FHE = req.FHE,
                    @PaxName = req.PaxName,
                    @MobileNO = req.MobileNO,
                    @PaxEmailID = req.PaxEmailID,
                    @Numberofpax = req.Numberofpax,
                    @BizVirticale = req.BizVirticale,
                    @DepartmentID = req.DepartmentID,
                    @BookingCreationDate = req.BookingCreationDate,
                    @PrePone = req.PrePone,
                    @PrePoneDate = req.PrePoneDate,
                    @AgentInvoiceReq = req.AgentInvoiceReq,
                    @Reason = req.Reason,
                    @PacageCode = req.PacageCode,
                    @PrmSrvcLoc = req.PrmSrvcLoc,
                    @Origin = req.Origin,
                    @OnlineBookingID = req.OnlineBookingID,
                    @FIT = req.FIT,
                    @SupplierTax_B2b = req.SupplierTax_B2b,
                    @SupplierTax_InCluding = req.SupplierTax_InCluding,
                    @MarkupType_Gross = req.MarkupType_Gross,
                    @AgentID = req.AgentID,
                    @MarketID = req.MarketID,
                    @CityIATACode = req.CityIATACode,
                    @BillingAddress = req.BillingAddress,
                    @PANNo = req.PANNo,
                    @GSTNo = req.GSTNo,
                    @TANNo = req.TANNo,
                    @SEZ = req.SEZ,
                    @FreeZone = req.FreeZone,
                    @AgentOnCredit = req.AgentOnCredit,
                    @CreditAmount = req.CreditAmount,
                    @OutStandingAmount = req.OutStandingAmount,
                    @DBL = req.DBL,
                    @EBA = req.EBA,
                    @EBC = req.EBC,
                    @CNB = req.CNB,
                    @SGL = req.SGL,
                    @Twin = req.Twin,
                    @taxID = req.taxID,
                    @UserNote1 = req.UserNote1,
                    @UserNote2 = req.UserNote2,
                    @TamSalesrep = req.TamSalesrep,
                    @CompanyID = req.CompanyID,
                    @YearID = req.YearID,
                };

                var data = new CommonClass.ResponseViewModel<BookingMaster>();
                _resModel = CommonFunctions.ProcessDBData(data, "U", "usp_InsertUpdateBooking_PrimaryInfo", parameters);
                _resModel.returnCode = data.returnCode;
                _resModel.returnMessage = data.returnMessage;
                _resModel.LastSavedOn = data.LastSavedOn;

                return _resModel;
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", " Update_Booking_PrimaryInfo Failed");
            }
        }
        #endregion

        #region Day Wise Services
        public async Task<ResponseModel> Booking_GuidDayWiseService(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<Booking_GuidDayWiseService>(request.RequestText);


            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Booking_GuidDayWiseService method called");


                var parameters = new
                {
                    @CheckIn = req.CheckIn,
                    @CheckOut = req.CheckOut,
                    @Service = req.Service,
                    @BookingID = req.BookingID,
                    @QuotationID = req.QuotationID,
                    @UserID = req.UserID,
                    @RateID = req.RateID,
                    @RateDetailID = req.RateDetailID,
                    @Count = req.Count
                };

                var data = new CommonClass.ResponseViewModel<Booking_GuidDayWiseService>()
                {
                    data = req
                };
                _resModel = CommonFunctions.ProcessDBData(data, "I", "Booking.usp_GuidDayWiseService", parameters);
                _resModel.returnCode = data.returnCode;
                _resModel.returnMessage = data.returnMessage;
                _resModel.LastSavedOn = data.LastSavedOn;
                return _resModel;
            }

            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> Booking_TrasportDayWiseService(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<Booking_TrasportDayWiseService>(request.RequestText);


            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Booking_TrasportDayWiseService method called");


                var parameters = new
                {
                    @CheckIn = req.CheckIn,
                    @CheckOut = req.CheckOut,
                    @Service = req.Service,
                    @BookingID = req.BookingID,
                    @QuotationID = req.@QuotationID,
                    @UserID = req.UserID,
                    @RateID = req.RateID,
                    @RateDetailID = req.RateDetailID,
                    @Count = req.Count
                };

                var data = new CommonClass.ResponseViewModel<Booking_TrasportDayWiseService>()
                {
                    data = req
                };
                _resModel = CommonFunctions.ProcessDBData(data, "I", "Booking.usp_TransportDayWiseService", parameters);
                _resModel.returnCode = data.returnCode;
                _resModel.returnMessage = data.returnMessage;
                _resModel.LastSavedOn = data.LastSavedOn;

                return _resModel;
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> Booking_SpecialServiceDayWiseService(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<Booking_SpecialServiceDayWiseService>(request.RequestText);


            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Booking_SpecialServiceDayWiseService method called");


                var parameters = new
                {
                    @CheckIn = req.CheckIn,
                    @CheckOut = req.CheckOut,
                    @Service = req.Service,
                    @BookingID = req.BookingID,
                    @QuotationID = req.@QuotationID,
                    @Adult = req.Adult,
                    @Child = req.Child,
                    @UserID = req.UserID,
                    @RateID = req.RateID,
                    @RateDetailID = req.RateDetailID,
                    @OlddwID = req.OlddwID,
                    @IsUpdated = req.IsUpdate,
                    @Consolidated = req.Consolidated
                };

                var data = new CommonClass.ResponseViewModel<Booking_SpecialServiceDayWiseService>()
                {
                    data = req
                };
                _resModel = CommonFunctions.ProcessDBData(data, "I", "Booking.usp_SpecialServiceDayWiseService", parameters);
                _resModel.returnCode = data.returnCode;
                _resModel.returnMessage = data.returnMessage;
                _resModel.LastSavedOn = data.LastSavedOn;
                return _resModel;

            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> Booking_MonumentDayWiseService(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<Booking_MonumentDayWiseService>(request.RequestText);


            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Booking_MonumentDayWiseService method called");


                var parameters = new
                {
                    @CheckIn = req.CheckIn,
                    @CheckOut = req.CheckOut,
                    @Service = req.Service,
                    @BookingID = req.BookingID,
                    @QuotationID = req.@QuotationID,
                    @Adult = req.Adult,
                    @Child = req.Child,
                    @UserID = req.UserID,
                    @RateID = req.RateID,
                    @OlddwID = req.OlddwID,
                    @IsUpdated = req.IsUpdate,
                    @RateDetailID = req.RateDetailID
                };

                var data = new CommonClass.ResponseViewModel<Booking_MonumentDayWiseService>()
                {
                    data = req
                };
                _resModel = CommonFunctions.ProcessDBData(data, "I", "Booking.usp_MonumentDayWiseService", parameters);
                _resModel.returnCode = data.returnCode;
                _resModel.returnMessage = data.returnMessage;
                _resModel.LastSavedOn = data.LastSavedOn;

                return _resModel;
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> Booking_MOTDayWiseService(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<Booking_MOTDayWiseService>(request.RequestText);


            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Booking_MOTDayWiseService method called");


                var parameters = new
                {
                    @CheckIn = req.CheckIn,
                    @CheckOut = req.CheckOut,
                    @BookingID = req.BookingID,
                    @QuotationID = req.@QuotationID,
                    @Adult = req.Adult,
                    @Child = req.Child,
                    @UserID = req.UserID,
                    @RateID = req.RateID,
                    @RateDetailID = req.RateDetailID
                };

                var data = new CommonClass.ResponseViewModel<Booking_MOTDayWiseService>()
                {
                    data = req
                };
                _resModel = CommonFunctions.ProcessDBData(data, "I", "Booking.usp_MOTDayWiseService", parameters);
                _resModel.returnCode = data.returnCode;
                _resModel.returnMessage = data.returnMessage;
                _resModel.LastSavedOn = data.LastSavedOn;

                return _resModel;
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        //public async Task<ResponseModel> Booking_HotelDayWiseService(RequestModel request)
        //{
        //    var req = CommonFunctions.DecryptAndDeserializeRequest<Booking_HotelDayWiseService>(request.RequestText);


        //    ResponseModel _resModel = new ResponseModel();
        //    try
        //    {
        //        logger.Debug("Booking_HotelDayWiseService method called");


        //        var parameters = new
        //        {
        //            @CheckIn = req.CheckIn,
        //            @CheckOut = req.CheckOut,
        //            @HotelID = req.HotelID,
        //            @BookingID = req.BookingID,
        //            @QuotationID = req.@QuotationID,
        //            @HotelRateDetailID = req.HotelRateDetailID,
        //            @UserID = req.UserID,
        //            @RateID = req.RateID,
        //            @RateDetailID = req.RateDetailID,
        //            @offerIncluded = req.offerIncluded
        //        };

        //        var data = new CommonClass.ResponseViewModel<Booking_HotelDayWiseService>();
        //        return CommonFunctions.ProcessDBData(data, "I", "Booking.usp_HotelDayWiseService", parameters);

        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
        //    }
        //}
        public async Task<ResponseModel> Booking_HotelDayWiseService(RequestModel request)
        {
            //var reqList = CommonFunctions.DecryptAndDeserializeRequest<List<Booking_HotelDayWiseService>>(request.RequestText);
            string requestText = request.RequestText.Replace(" ", "+");
            string decryptedJson = Cryptography.DecryptStringAES(requestText, _base64Key);

            List<Booking_HotelDayWiseService> reqList;

            // Detect if the decrypted JSON is an array or a single object
            if (decryptedJson.TrimStart().StartsWith("["))
            {
                reqList = JsonConvert.DeserializeObject<List<Booking_HotelDayWiseService>>(decryptedJson);
            }
            else
            {
                var singleObj = JsonConvert.DeserializeObject<Booking_HotelDayWiseService>(decryptedJson);
                reqList = new List<Booking_HotelDayWiseService> { singleObj };
            }

            if (reqList == null || reqList.Count == 0)
                return CommonFunctions.BlankResponse("201", "Empty or invalid request.");

            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("Booking_HotelDayWiseService method called");

                foreach (var req in reqList)
                {
                    var parameters = new
                    {
                        @CheckIn = req.CheckIn,
                        @CheckOut = req.CheckOut,
                        @HotelID = req.HotelID,
                        @BookingID = req.BookingID,
                        @QuotationID = req.QuotationID,
                        @HotelRateDetailID = req.HotelRateDetailID,
                        @UserID = req.UserID,
                        @RateID = req.RateID,
                        @RateDetailID = req.RateDetailID,
                        @offerIncluded = req.offerIncluded,
                        @DBL = req.DBL,
                        @EBA = req.EBA,
                        @EBC = req.EBC,
                        @CNB = req.CNB,
                        @SGL = req.SGL,
                        @Twin = req.Twin,
                        @OlddwID = req.OlddwID,
                        @IsUpdated = req.IsUpdate
                    };


                    var data = new CommonClass.ResponseViewModel<Booking_HotelDayWiseService>();
                    var response = CommonFunctions.ProcessDBData(data, "I", "Booking.usp_HotelDayWiseService", parameters);
                    response.LastSavedOn = data.LastSavedOn;

                }

                return CommonFunctions.BlankResponse("200", " New record added successfully.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Booking Failed");
            }
        }

        #endregion
        public async Task<ResponseModel> BookingMaster(RequestModel request)

        {

            ResponseModel _resModel = new ResponseModel();

            try

            {

                // Decrypt and deserialize the request

                var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);

                logger.Debug("BookingMaster method called");

                if (req != null)

                {

                    var parameters = new

                    {
                        @BookingID = req.BookingID,
                        @Action = req.Action,
                        @PageNumber = req.PageNumber

                        //@QuotationID = req.QuotationID,

                        //@EnquryID = req.EnquiryID,

                        //@FileCode = req.FileCode,

                        //@PaxName = req.PaxName,

                        //@XONumber = req.XONumber,

                        //@InvoiceNumber = req.InvoiceNumber,

                        //@Action = req.Action,

                        //@FromDate = req.BookingFromDate,

                        //@ToDate = req.BookingToDate,

                        //@QuotationNo = req.QuotationNo,

                        //@BookingNo = req.BookingNo,

                        //@AgentID = req.AgentID,

                        //@Status = req.Status,

                        //@CustomerID = req.CustomerID

                    };

                    var data = new CommonClass.ResponseViewModel<BookingMaster>();

                    return CommonFunctions.ProcessDBDataPagination(data, req.Action, "[Booking].[usp_BookingDetails]", parameters);

                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

            }

            catch (Exception ex)

            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");

            }

        }
        private T SafeDeserialize<T>(string json)
        {
            if (string.IsNullOrWhiteSpace(json)) return default;
            try
            {

                return JsonConvert.DeserializeObject<T>(json);
            }
            catch
            {
                return default; // Optionally log this
            }
        }
        public async Task<ResponseModel> FetchBookings(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);
                logger.Debug("FetchQuotationDD method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<BookingMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Booking].[usp_FetchBookingDD]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> GetBookingService(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<BookingService>(request.RequestText);
                logger.Debug("GetBookingService method called");

                if (req == null)
                    return CommonFunctions.BlankResponse("201", "Invalid request parameters");

                var parameters = new
                {
                    @BookingID = req.BookingID,
                    @Action = req.Action,
                };

                // Get data from database
                var result = await SqlHelper.LoadDataWithMultiTablesAsync<GetGuideRateSearchResponseDto, GetMonumentRateSearchResponseDto,
                                TransportRateSearchResponseDto, GetSpecialServiceSearchResponseDto, HotelRateDetailsSearchResponseDto, dynamic>(
                    "[Booking].[usp_GetRateCardSearchReportBooking]",
                    parameters
                );


                // Step 1: Declare the response object
                var responseData = new BookingServiceResponse();

                // Step 2: Bind each dataset separately

                //Guide

                responseData.Guides = new BookingServiceResult<GetGuideRateSearchResponseDto>
                {
                    Data = result.Table1,
                    returnCode = result.Table1.Any() ? "200" : "201",
                    returnMessage = result.Table1.Any() ? "Data found" : "Data Not Found"
                };

                //Monument

                //var MonumentRes = result.Table2
                // .GroupBy(x => x.OthersRateCardMasterID)
                // .Select(group =>
                // {
                //     var first = group.First();

                //     // Map main DTO from the first grouped item
                //     var mappedDto = _mapper.Map<GetMonumentRateSearchResponseDto>(first);

                //     // Map commissions list
                //     mappedDto.Commissions = _mapper.Map<List<MonumentRateCommissionDetailRequestDto>>(
                //         group.Where(c => c.MonumentCommissionDetailID.HasValue).ToList()
                //     );

                //     return mappedDto;
                // })
                // .ToList();

                responseData.Monuments = new BookingServiceResult<GetMonumentRateSearchResponseDto>
                {
                    Data = result.Table2,
                    returnCode = result.Table2.Any() ? "200" : "201",
                    returnMessage = result.Table2.Any() ? "Data found" : "Data Not Found"
                };

                //Transport

                responseData.Transports = new BookingServiceResult<TransportRateSearchResponseDto>
                {
                    Data = result.Table3,
                    returnCode = result.Table3.Any() ? "200" : "201",
                    returnMessage = result.Table3.Any() ? "Data found" : "Data Not Found"
                };


                //Special service


                responseData.SpecialServices = new BookingServiceResult<GetSpecialServiceSearchResponseDto>
                {
                    Data = result.Table4,
                    returnCode = result.Table4.Any() ? "200" : "201",
                    returnMessage = result.Table4.Any() ? "Data found" : "Data Not Found"
                };

                //hOTEL

                var hotelRes = new List<HotelRateDetailsSearchResponseDto>();

                foreach (var row in result.Table5)
                {
                    var dto = new HotelRateDetailsSearchResponseDto
                    {
                        HotelRateID = row.HotelRateID,
                        HotelID = row.HotelID,
                        HotelName = row.HotelName,
                        CityID = row.CityID,
                        HotelRateDetailID = row.HotelRateDetailID,
                        RoomCategoryID = row.RoomCategoryID,
                        RoomCategory = row.RoomCategory,
                        MISSequence = row.MISSequence,
                        Days = row.Days,
                        DaysOfWeek = row.DaysOfWeek,
                        MealPlanCode = row.MealPlanCode,
                        Breakfast = row.Breakfast,
                        Lunch = row.Lunch,
                        Dinner = row.Dinner,
                        HasDocument = row.HasDocument,
                        HasRules = row.HasRules,
                        OfferTypeID = row.OfferTypeID,
                        FromToDate = row.FromToDate,
                        QuotationID = row.QuotationID,
                        QuotationNo = row.QuotationNo,
                        Currency = row.Currency,
                        CityName = row.CityName,
                        BookID = row.BookID,
                        BreakfastGrossRate = row.BreakfastGrossRate,
                        LunchGrossRate = row.LunchGrossRate,
                        DinnerGrossRate = row.DinnerGrossRate,

                        // Manual JSON deserialization
                        Commissions = SafeDeserialize<List<HotelRateCommissionDetailResponseDto>>(row.CommissionJSON),
                        Meals = SafeDeserialize<List<HotelRateMealResponseDto>>(row.MealOverviewJSON),
                        Offers = SafeDeserialize<List<HotelRateOfferConfigurationSearchDto>>(row.OfferConfigurationJSON),

                    };

                    hotelRes.Add(dto);
                }


                responseData.Hotels = new BookingServiceResult<HotelRateDetailsSearchResponseDto>
                {
                    Data = hotelRes,
                    returnCode = hotelRes.Any() ? "200" : "201",
                    returnMessage = hotelRes.Any() ? "Data found" : "Data Not Found"
                };

                var responseViewModel = new ResponseViewModel<BookingServiceResponse>
                {
                    data = responseData,
                    count = result.Table1.Count + result.Table2.Count +
                            result.Table3.Count + result.Table4.Count
                };

                return CommonFunctions.ProcessResult(responseViewModel);
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error retrieving Booking Services");
            }
        }
        public async Task<ResponseModel> AddSubBooking(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<AddSubBooking>(request.RequestText);


            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("AddSubBooking method called");


                var parameters = new
                {
                    @NewCreatedBy = req.NewCreatedBy,
                    @BID = req.BID
                };

                var data = new CommonClass.ResponseViewModel<BookingMaster>();
                return CommonFunctions.ProcessDBData(data, "I", "Booking.usp_AddSubBooking", parameters);

            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> AddCopyBooking(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<AddCopyBooking>(request.RequestText);


            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("AddCopyBooking method called");


                var parameters = new
                {
                    @NewCreatedBy = req.NewCreatedBy,
                    @BID = req.BID
                };

                var data = new CommonClass.ResponseViewModel<BookingMaster>();
                return CommonFunctions.ProcessDBData(data, "I", "Booking.usp_AddCopyBooking", parameters);

            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> UpdateBookingService(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<UpdateBookingService>(request.RequestText);
                logger.Debug("UpdateBookingService method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @BookingID = req.BookingID,
                        @Action = req.Action,
                        @HotelRateCardMasterJSON = req.HotelRateCardMasterJSON,
                        @HotelRateCommissionDetailsJSON = req.HotelRateCommissionDetailsJSON,
                        @HotelRateMealPlanMasterJSON = req.HotelRateMealPlanMasterJSON,
                        @OthersRateCardMasterJSON = req.OthersRateCardMasterJSON
                    };

                    var data = new CommonClass.ResponseViewModel<UpdateBookingService>();
                    return CommonFunctions.ProcessDBData(data, "U", "[Booking].[UpdateBookingCommissionDetails]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> ConvertQuotationToBooking(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);
                logger.Debug("ConvertQuotationToBooking method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @QuotationID = req.QuotationID,
                        @Action = req.Action,
                        @CompanyID = req.CompanyID,
                        @YearID = req.YearID,
                        @OutBookingID = req.@OutBookingID
                    };

                    var data = new CommonClass.ResponseViewModel<BookingMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Booking].[ConvertQuotationToBooking]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        public async Task<ResponseModel> ConvertCommissionRateTonegotiateRate(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ConverCommissionRateToNogotiate>(request.RequestText);
                logger.Debug("ConvertQuotationToBooking method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @dwID = req.dwID,
                        @RateCardID = req.RateCardID
                    };

                    var data = new CommonClass.ResponseViewModel<ConverCommissionRateToNogotiate>();
                    return CommonFunctions.ProcessDBData(data, "U", "[Booking].[ConvertCommissionRateTonegotiateRate]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> GenerateFileCode(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);
                logger.Debug("GenerateFileCode method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @CompanyID = req.CompanyID,
                        @BookingID = req.BookingID
                    };

                    var data = new CommonClass.ResponseViewModel<BookingMaster>();
                    return CommonFunctions.ProcessDBData(data, "S", "[Booking].[GenerateFileCode]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        //generate daywisedata
        public async Task<ResponseModel> DayWiseDataAsync(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);
                logger.Debug("GenerateDayWiseData method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @BookingID = req.BookingID,
                        @Id = req.ID,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    //var data = new CommonClass.ResponseViewModel<BookingMaster>()
                    //{
                    //    data = req
                    //};


                    var data = new CommonClass.ResponseViewModel<BookingMaster>();
                    _resModel = CommonFunctions.ProcessDBData(data, req.Action, "Booking.InsertDayWiseData", parameters);
                    _resModel.returnCode = data.returnCode;
                    _resModel.returnMessage = data.returnMessage;
                    _resModel.LastSavedOn = data.LastSavedOn;

                    return _resModel;
                    //return CommonFunctions.ProcessDBData(data, req.Action, "[Booking].[InsertDayWiseData]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> GetDayWiseServiceData(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<DayWiseBooking>(request.RequestText);
                logger.Debug("GetDayWiseServiceData method called");

                //var responseData = new DayWiseResponseModel();

                if (req != null)
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@BookingID", req.BookingID);
                    parameters.Add("@RateTypeID", req.RateTypeID);

                    //var parameters = new
                    //{
                    //    @BookingID = req.BookingID,
                    //    RateTypeID = req.RateTypeID
                    //};

                    var jsonResult = await SqlHelper.QueryAsync<string, DynamicParameters>("[Booking].[usp_GetDayWiseServiceData]", parameters);
                    string jsonArray = string.Join("", jsonResult);
                    var responseData = JsonConvert.DeserializeObject<List<DayWiseBooking>>(jsonArray);


                    // Handle the CustomRateMasterData deserialization
                    foreach (var item in responseData)
                    {
                        // Ensure that CustomRateMasterData is either an empty list or populated with data
                        if (item.CustomRateMasterData == null)
                        {
                            item.CustomRateMasterData = new List<CustomRateMaster>(); // Initialize as an empty list if null
                        }
                    }


                    //var data = new CommonClass.ResponseViewModel<DayWiseBooking>();
                    //var jsonResult = await SqlHelper.QueryAsync<DayWiseBooking, DynamicParameters>("[Booking].[GetDayWiseServices]", parameters);
                    //switch (req.RateTypeID)
                    //{
                    //    case 1:
                    //        //var GuideRootList = JsonConvert.DeserializeObject<List<RootObject>>(jsonResult);
                    //        //foreach (var item in GuideRootList)
                    //        //{
                    //            responseData.CommissionJSON = JsonConvert.DeserializeObject<List<Commission>>(jsonResult.);
                    //        //}
                    //        break;
                    //    case 2:
                    //        var monumentRootList = JsonConvert.DeserializeObject<List<RootObject>>(jsonResult);
                    //        foreach (var item in monumentRootList)
                    //        {
                    //            responseData.CommissionJSON = JsonConvert.DeserializeObject<List<Commission>>(item.BookingWithCommission);
                    //        }
                    //        break;
                    //    case 3:
                    //        var transportRootList = JsonConvert.DeserializeObject<List<RootObject>>(jsonResult);
                    //        foreach (var item in transportRootList)
                    //        {
                    //            responseData.CommissionJSON = JsonConvert.DeserializeObject<List<Commission>>(item.BookingWithCommission);
                    //        }
                    //        break;
                    //    case 4:
                    //        var SpecialReviceRootList = JsonConvert.DeserializeObject<List<RootObject>>(jsonResult);
                    //        foreach (var item in SpecialReviceRootList)
                    //        {
                    //            responseData.CommissionJSON = JsonConvert.DeserializeObject<List<Commission>>(item.BookingWithCommission);
                    //        }
                    //        break;
                    //    case 5:
                    //        responseData.HotelCommissionJSON = JsonConvert.DeserializeObject<List<HotelDayWiseModel>>(jsonResult);
                    //        break;
                    //}

                    var responseViewModel = new ResponseViewModel<DayWiseBooking>
                    {
                        dataList = responseData,
                        returnCode = responseData != null && responseData.Any() ? "200" : "201",
                        returnMessage = responseData != null && responseData.Any() ? "Data found" : "Data Not Found"
                    };

                    return CommonFunctions.ProcessResult(responseViewModel);
                }
                else
                {
                    var returnCode = "201";
                    var returnMessage = "Data Not Found";
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        //public async Task<ResponseModel> GetDayWiseServiceData(RequestModel request)
        //{
        //    ResponseModel _resModel = new ResponseModel();
        //    try
        //    {
        //        // Decrypt and deserialize the request
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<DayWiseBooking>(request.RequestText);
        //        logger.Debug("GetDayWiseServiceData method called");
        //        BookingWithCommissionModel MonumentResponse = new BookingWithCommissionModel();
        //        BookingWithCommissionModel TransportResponse = new BookingWithCommissionModel();
        //        List<GuideModelDayWiseModel> GuideResponse = new List<GuideModelDayWiseModel>();
        //        DayWiseModel SpecialServiceResponse = new DayWiseModel();
        //        List <HotelDayWiseModel> HotelResponse =new List<HotelDayWiseModel>();
        //        if (req != null)
        //        {
        //            var parameters = new
        //            {
        //                @BookingID = req.BookingID,
        //                @RateTypeID = req.RateTypeID
        //            };

        //            // Get data from database
        //            var jsonResult = (await SqlHelper.LoadJsonDataAsync<string, dynamic>(
        //            "[Booking].[usp_GetDayWiseServiceData]", parameters));


        //            if (req.RateTypeID == 1)
        //            {
        //                GuideResponse = JsonConvert.DeserializeObject<List<GuideModelDayWiseModel>>(jsonResult);
        //            }
        //            else if (req.RateTypeID == 2)
        //            {
        //                var rootList = JsonConvert.DeserializeObject<List<RootObject>>(jsonResult);

        //                foreach (var item in rootList)
        //                {
        //                    MonumentResponse = JsonConvert.DeserializeObject<BookingWithCommissionModel>(item.BookingWithCommission);

        //                }
        //            }
        //            else if (req.RateTypeID == 3)
        //            {
        //                var rootList = JsonConvert.DeserializeObject<List<RootObject>>(jsonResult);

        //                foreach (var item in rootList)
        //                {
        //                    TransportResponse = JsonConvert.DeserializeObject<BookingWithCommissionModel>(item.BookingWithCommission);

        //                }
        //            }
        //            else if (req.RateTypeID == 4)
        //            {
        //                SpecialServiceResponse = JsonConvert.DeserializeObject<DayWiseModel>(jsonResult);
        //            }
        //            else if (req.RateTypeID == 5)
        //            {
        //                HotelResponse = JsonConvert.DeserializeObject<List<HotelDayWiseModel>>(jsonResult);
        //            }

        //            // Step 1: Declare the response object
        //            var responseData = new DayWiseModel();




        //            //responseData.Hotels = new BookingServiceResult<HotelRateDetailsSearchResponseDto>
        //            //{
        //            //    Data = hotelRes,
        //            //    returnCode = hotelRes.Any() ? "200" : "201",
        //            //    returnMessage = hotelRes.Any() ? "Data found" : "Data Not Found"
        //            //};

        //            var responseViewModel = new ResponseViewModel<DayWiseModel>
        //            {
        //                data = responseData,
        //                //count = result.Table1.Count + result.Table2.Count +
        //                //        result.Table3.Count + result.Table4.Count
        //            };

        //            return CommonFunctions.ProcessResult(responseViewModel);


        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
        //    }
        //}

        public async Task<ResponseModel> UpdateDayWiseBooking(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<DayWiseBooking>(request.RequestText);
                logger.Debug("UpdateDayWiseBooking method called");
                if (req != null)
                {
                    DataTable mealTable = new DataTable();
                    //mealTable.Columns.Add("QuotationHotelRateMealId", typeof(long));
                    mealTable.Columns.Add("HotelRateMealID", typeof(long));
                    mealTable.Columns.Add("IsSupplementary", typeof(bool));

                    if (req.MealOverviewJSON != null && req.MealOverviewJSON.Count > 0)
                    {
                        foreach (var Meals in req.MealOverviewJSON)
                        {
                            mealTable.Rows.Add(
                                Meals.HotelRateMealID,
                                Meals.IsSupplementary
                            );
                        }
                    }

                    var parameters = new
                    {
                        @Action = req.Action,
                        @ID = req.ID,
                        @SGL = req.SGL,
                        @Twin = req.Twin,
                        @DBL = req.DBL,
                        @EBA = req.EBA,
                        @EBC = req.EBC,
                        @CNB = req.CNB,
                        @SGL_Rate = req.SGL_Rate,
                        @Twin_Rate = req.Twin_Rate,
                        @DBL_Rate = req.DBL_Rate,
                        @EBA_Rate = req.EBA_Rate,
                        @EBC_Rate = req.EBC_Rate,
                        @CNB_Rate = req.CNB_Rate,
                        @Count = req.Count,
                        @Adult_Count = req.Adult_Count,
                        @Child_Count = req.Child_Count,
                        @Adult_Rate = req.Adult_Rate,
                        @Child_Rate = req.Child_Rate,
                        @TCountRate = req.TCountRate,
                        @Consolidated = req.Consolidated,
                        MealList = mealTable.AsTableValuedParameter("BookingMealPlanTableType")
                    };
                    var data = new CommonClass.ResponseViewModel<DayWiseBooking>()
                    {
                        data = req
                    };
                    _resModel = CommonFunctions.ProcessDBData(data, req.Action, "[Booking].[UpdateDayWiseBooking]", parameters);
                    _resModel.returnCode = data.returnCode;
                    _resModel.returnMessage = data.returnMessage;
                    _resModel.LastSavedOn = data.LastSavedOn;
                    return _resModel;
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> UpdateBookingFHE(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);
                logger.Debug("UpdateBookingFHE method called");

                if (req != null)
                {

                    var parameters = new

                    {
                        @BookingID = req.BookingID,
                        @FHE = req.FHE,
                        @UserID = req.ModifiedBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<BookingMaster>()
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "[Booking].[usp_UpdateBookingFHE]", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }

        }

        public async Task<ResponseModel> GetNegotiateDetailForFileSumm(RequestModel request)
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<BookingMaster>(request.RequestText);

            ResponseModel _resModel = new ResponseModel();
            try
            {
                logger.Debug("GetNegotiateDetailForFileSumm method called");

                if (req != null)
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@Action", req.Action);
                    parameters.Add("@bookingId", req.BookingID);
                    parameters.Add("@CompanyID", req.CompanyID);

                    var jsonResult = await SqlHelper.QueryAsync<string, DynamicParameters>("[Booking].[usp_GetNegotiateDetailForFileSumm]", parameters);
                    string jsonArray = string.Join("", jsonResult);
                    var responseData = JsonConvert.DeserializeObject<List<BookingMaster>>(jsonArray);

                    var responseViewModel = new ResponseViewModel<BookingMaster>
                    {
                        dataList = responseData,
                        returnCode = responseData != null && responseData.Any() ? "200" : "201",
                        returnMessage = responseData != null && responseData.Any() ? "Data found" : "Data Not Found"
                    };
                    return CommonFunctions.ProcessResult(responseViewModel);
                }
                else
                {
                    var returnCode = "201";
                    var returnMessage = "Data Not Found";
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
