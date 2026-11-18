using CommonClass;
using Dapper;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.draw;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;
using NLog;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.Model.DBModel;
using TamarindAstraMasters.Interface;

namespace BusinessLogic.Repositories
{
    public class SearchRepository : ISearch
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        private readonly string isEncrypted;

        public SearchRepository(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];
        }
        #region searchHotelRate starts here
        //new
        public async Task<ResponseModel> Search_HotelRate(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_HotelRate>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @FIT = req.FIT,
                        @GIT = req.GIT,
                        @Contract = req.Contract,
                        @Adhoc = req.Adhoc,
                        @Negotiated = req.Negotiated,
                        @ALL_B2B = req.ALL_B2B,
                        @Nett_Markedup = req.Nett_Markedup,
                        @Vendor = req.Vendor,
                        @City = req.City,
                        @Hotel = req.Hotel,
                        @RatingFrom = req.RatingFrom,
                        @RatingTo = req.RatingTo,
                        @MIS = req.MIS,
                        @Currency = req.Currency,
                        @Market = req.Market,
                        @AgentCity = req.AgentCity,
                        @AgentCategory = req.AgentCategory,
                        @AgentName = req.AgentName,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo,
                        @AgentID = req.AgentID,
                        @CategoryID = req.CategoryID,
                        @IsDirectPayment = req.IsDirectPayment,
                        @ISHotelPreferred = req.ISHotelPreferred
                    };

                    var data = new CommonClass.ResponseViewModel<Search_HotelRate>();
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_SearchHotelRate", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_SearchHotelRate", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion searchHotelRate ends here

        #region Rule starts here
        //new
        public async Task<ResponseModel> Search_HotelRate_Rule(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_HotelRate_Rule>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @ParentRateID = req.ParentRateID,
                        @ParentRateTypeID = req.ParentRateTypeID
                    };

                    var data = new CommonClass.ResponseViewModel<Search_HotelRate_Rule>();
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetRateRuleOnParentRateID", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetRateRuleOnParentRateID", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Rule ends here

        #region searchDocs starts here
        //new
        public async Task<ResponseModel> Search_Docs(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_Docs>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @ParentRateID = req.ParentRateID,
                        @ParentRateTypeID = req.ParentRateTypeID
                    };

                    var data = new CommonClass.ResponseViewModel<Search_Docs>();
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetDocOnParentRateID", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetDocOnParentRateID", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchDocs ends here

        #region searchHotelFactSheet starts here
        //new
        public async Task<ResponseModel> Hotel_FactSheet(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Hotel_FactSheet>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @HotelID = req.HotelID,
                        @ParentID = req.ParentID,
                        @ParentPageType = req.ParentPageType,
                    };

                    var data = new CommonClass.ResponseViewModel<Hotel_FactSheet>();
                    return CommonFunctions.ProcessDBData(data, "s", "usp_GetHotelFactSheet", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion searchHotelFactSheet ends here

        #region Search_HotelRate_CancellationData starts here
        //new
        public async Task<ResponseModel> Search_HotelRate_CancellationData(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_HotelRate_CancellationData>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @HotelRateID = req.HotelRateID,
                    };

                    var data = new CommonClass.ResponseViewModel<Search_HotelRate_CancellationData>();
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetHotelRoomCancellationData", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetHotelRoomCancellationData", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Search_HotelRate_CancellationData ends here

        #region SearchHotelOffer starts here
        //new
        public async Task<ResponseModel> Search_HotelOffer(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_HotelOffer>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @City = req.City,
                        @HotelVendorName = req.HotelVendorName,
                        @HotelGroup = req.HotelGroup,
                        @RateHeader = req.RateHeader,
                        @HotelRating = req.HotelRating,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo
                    };

                    var data = new CommonClass.ResponseViewModel<Search_HotelOffer>();
                    //  return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_SearchHotelOffers", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_SearchHotelOffers", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchHotelOffer ends here

        #region serachOtherRateCard starts here        

        public async Task<ResponseModel> GetGuideRateCardOnSearch(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<RateCardSearchRequest>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Service = req.Service,
                        @RateCardModeTypeID = req.RateCardModeTypeID,
                        @DisplayRate = req.DisplayRate,
                        @Language = req.Language,
                        @CityIata = req.CityIata,
                        @Vendor = req.VendorOrHotel,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo
                    };

                    var data = new CommonClass.ResponseViewModel<GuideRateCardSearchResponse>();
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetGuideRateCardSearch", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        //new
        public async Task<ResponseModel> GetMonumentRateCardOnSearch(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<RateCardSearchRequest>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Service = req.Service,
                        @RateCardModeTypeID = req.RateCardModeTypeID,
                        @DisplayRate = req.DisplayRate,
                        @NationalityID = req.NationalityID,
                        @CityIata = req.CityIata,
                        @Vendor = req.VendorOrHotel,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo
                    };

                    var data = new CommonClass.ResponseViewModel<MonumentRateCardSearchResponse>();
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetMonumentRateCardSearch", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        //new
        public async Task<ResponseModel> GetTransportRateCardOnSearch(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<RateCardSearchRequest>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Service = req.Service,
                        @RateCardModeTypeID = req.RateCardModeTypeID,
                        @DisplayRate = req.DisplayRate,
                        @CityIata = req.CityIata,
                        @IsVendorOrHotel = req.IsVendorOrHotel,
                        @VendorOrHotel = req.VendorOrHotel,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo,
                        @VTypeID = req.VTypeID
                    };

                    var data = new CommonClass.ResponseViewModel<TransportRateCardSearchResponse>();
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetTransportRateCardSearch", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        //new
        public async Task<ResponseModel> GetSpecialServiceRateCardOnSearch(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<RateCardSearchRequest>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Service = req.Service,
                        @RateCardModeTypeID = req.RateCardModeTypeID,
                        @DisplayRate = req.DisplayRate,
                        @NationalityID = req.NationalityID,
                        @CityIata = req.CityIata,
                        @IsVendorOrHotel = req.IsVendorOrHotel,
                        @VendorOrHotel = req.VendorOrHotel,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo
                    };

                    var data = new CommonClass.ResponseViewModel<SpecialServiceRateCardSearchResponse>();
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetSpecialServiceRateCardSearch", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion serachOtherRateCard ends here

        #region SearchAgentInfo starts here
        //new
        public async Task<ResponseModel> Search_AgentInfo(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_AgentInfo>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @AgentID = req.AgentID,
                        @City_IATACode = req.City_IATACode,
                        @StateCode = req.StateCode,
                        @CountryCode = req.CountryCode,
                        @SelectedData = req.SelectedData,
                        @SelectedValue = req.SelectedValue,
                        @EmpID = req.EmpID,
                        @Page = req.Page
                    };

                    var data = new CommonClass.ResponseViewModel<Search_AgentInfo>();
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_SearchAgentInfo_NEW", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_SearchAgentInfo_NEW", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchAgentInfo ends here

        #region Search_Contact starts here
        //new
        public async Task<ResponseModel> Search_Contact(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_Contact>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @ID = req.ID,
                        @TypeID = req.TypeID,
                    };

                    var data = new CommonClass.ResponseViewModel<Search_Contact>();
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetContactOnParentID", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetContactOnParentID", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Search_Contact ends here

        #region SearchHotelInfo starts here
        //new
        public async Task<ResponseModel> Search_HotelInfo(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_HotelInfo>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @HotelChain = req.HotelChain,
                        @HotelId = req.HotelId,
                        @CityIATACode = req.CityIATACode,
                        @RatingFromID = req.RatingFromID,
                        @RatingToID = req.RatingToID
                    };

                    var data = new CommonClass.ResponseViewModel<Search_HotelInfo>();
                    //  return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetSearchHotelInfo", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetSearchHotelInfo", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchHotelInfo ends here

        #region HotelRoomInfo starts here
        //new
        public async Task<ResponseModel> HotelRoomInfo(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelRoomInfo>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @HotelId = req.HotelID,
                    };

                    var data = new CommonClass.ResponseViewModel<HotelRoomInfo>();
                    //   return CommonFunctions.ProcessDBData_WitoutAction(data, "USP_GetRoomCategoryByHotelID", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "USP_GetRoomCategoryByHotelID", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion HotelRoomInfo ends here

        #region SearchVendorInfo starts here
        //new
        public async Task<ResponseModel> Search_VendorInfo(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_VendorInfo>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @VendorID = req.VendorID,
                        @CityIATACode = req.CityIATACode,
                        @AccountGroup = req.AccountGroup,
                        @VendorOnCredit = req.VendorOnCredit
                    };

                    var data = new CommonClass.ResponseViewModel<Search_VendorInfo>();
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_SearchVendorInfo", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_SearchVendorInfo", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchVendorInfo ends here        

        #region SearchContactInfo starts here        
        //new
        //public async Task<ResponseModel> Search_ContactInfo(RequestModel request)
        //{
        //    try
        //    {
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<Contact_Info>(request.RequestText);

        //        if (req != null)
        //        {
        //            var parameters = new
        //            {
        //                @ContactName = req.ContactName,
        //                @Type = req.Type,
        //                @City_IATACode = req.City_IATACode,
        //                @TypeName = req.TypeName,
        //                @EmailID = req.EmailID,
        //                @Active = req.Active,
        //                @PhoneNo = req.PhoneNo,
        //                //@MarketID = req.MarketID,
        //                @Country_IATACode = req.CountryCode,
        //                @State_ID = req.StateID,
        //                //@FromDate = req.FromDate,
        //                //@IsDate = req.IsDate,
        //                @BizActive = req.BizActive

        //            };

        //            var data = new CommonClass.ResponseViewModel<Contact_Info>();
        //            //return CommonFunctions.ProcessDBData(data, "S", "usp_SearchContactInfo_AlbertBackup", parameters);
        //            return CommonFunctions.ProcessDBData(data, "S", "usp_SearchContactInfoMaster", parameters);

        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
        //    }
        //}

        public async Task<ResponseModel> Search_ContactInfo(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Contact_Info>(request.RequestText);

                if (req != null)
                {
                    // Force Row_Count to 10, override anything from frontend
                    int fixedRowCount = 10;

                    var parameters = new DynamicParameters();

                    parameters.Add("@ContactName", req.ContactName);
                    parameters.Add("@Type", req.Type);
                    parameters.Add("@City_IATACode", req.City_IATACode);
                    parameters.Add("@TypeName", req.TypeName);
                    parameters.Add("@EmailID", req.EmailID);
                    parameters.Add("@Active", req.Active);
                    parameters.Add("@PhoneNo", req.PhoneNo);
                    parameters.Add("@Country_IATACode", req.CountryCode);
                    parameters.Add("@State_ID", req.StateID);
                    parameters.Add("@BizActive", req.BizActive);

                    parameters.Add("@PageNumber", req.PageNumber);  // allow frontend to control page number
                    parameters.Add("@Row_Count", fixedRowCount);    // always send 10 rows
                    parameters.Add("@TotalRecordCount", dbType: DbType.Int64, direction: ParameterDirection.Output);

                    var data = new CommonClass.ResponseViewModel<Contact_Info>();

                    return CommonFunctions.ProcessDBDataPagination(data, "S", "usp_SearchContactInfoMaster", parameters);

                 
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Search_ContactInfo Failed");
            }
        }

        #endregion SearchContactInfo ends here

        #region SearchHotelRoomOrAnnouncement starts here
        //new
        public async Task<ResponseModel> Search_HotelRoomOrAnnouncement(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_HotelRoomOrAnnouncement>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @HotelChain = req.HotelChain,
                        @HotelId = req.HotelId,
                        @CityIATACode = req.CityIATACode,
                        @RatingFromID = req.RatingFromID,
                        @RatingToID = req.RatingToID
                    };

                    var data = new CommonClass.ResponseViewModel<Search_HotelRoomOrAnnouncement>();
                    //  return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetSearchHotelInfo", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "usp_GetSearchHotelInfo", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchHotelRoomOrAnnouncement ends here

        #region Search_PrintInvoiceNew starts here
        //new
        public async Task<ResponseModel> Search_PrintInvoiceNew(RequestModel request)
        {
            try
            {
                var req = (request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {

                    };

                    var data = new CommonClass.ResponseViewModel<Search_PrintInvoiceNew>();
                    //  return CommonFunctions.ProcessDBData_WitoutAction(data, "GetEmptyInvoice_New", null);
                    return CommonFunctions.ProcessDBData(data, "S", "GetEmptyInvoice_New", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Search_PrintInvoiceNew ends here

        #region Search_PrintInvoice starts here
        //new
        public async Task<ResponseModel> Search_PrintInvoice(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_PrintInvoice>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @InvoiceNo = req.InvoiceNo,
                    };

                    var data = new CommonClass.ResponseViewModel<Search_PrintInvoice>();
                    //  return CommonFunctions.ProcessDBData_WitoutAction(data, "PrintInvoiceDPBTC_New_ByInvoiceID", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "PrintInvoiceDPBTC_New_ByInvoiceID", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Search_PrintInvoice ends here

        #region Search_GuideInfo starts here
        //new
        public async Task<ResponseModel> Search_GuideInfo(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_GuideInfo>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @StateID = req.StateID,
                        @CityID = req.CityID,
                        @StarRating = req.StarRating,
                        @Language = req.Language
                    };

                    var data = new CommonClass.ResponseViewModel<Search_GuideInfo>();
                    //    return CommonFunctions.ProcessDBData(data,"S", "USP_SearchGuideMaster", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "USP_SearchGuideMaster", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Search_GuideInfo ends here

        #region Search_PrintCommInvoice starts here

        //new
        public async Task<ResponseModel> Search_PrintCommInvoice(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Search_PrintCommInvoice>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @InvoiceID = req.Invoice_ID,
                        @QuotationID = req.QuotationID
                    };

                    var data = new CommonClass.ResponseViewModel<Search_PrintCommInvoice>();
                    // return CommonFunctions.ProcessDBData_WitoutAction(data, "USP_GetInvoiceReportCommInvoiceHorizontalOne", parameters);
                    return CommonFunctions.ProcessDBData(data, "S", "USP_GetInvoiceReportCommInvoiceHorizontalOne", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Search_PrintCommInvoice ends here

        #region SearchManage_Contact starts here
        //new
        public async Task<ResponseModel> SearchManage_Contact(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<SearchManage_Contact>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        ContactName = req.ContactName,
                        Type = req.Type,
                        City_IATACode = req.City_IATACode,
                        TypeName = req.TypeName,
                        Active = req.Active,
                        PhoneNo = req.PhoneNo,
                        MarketID = req.MarketID,
                        ContactDetailsID = req.ContactDetailsID,
                        ParentID = req.ParentID,
                        TypeID = req.TypeID,
                        IsPrimaryContact = req.IsPrimaryContact,
                        SalutationID = req.SalutationID,
                        FirstName = req.FirstName,
                        LastName = req.LastName,
                        DesignationOrDepartment = req.DesignationOrDepartment,
                        EmailID = req.EmailID,
                        OfficeNo = req.OfficeNo,
                        MobileNo = req.MobileNo,
                        FaxNo = req.FaxNo,
                        DateofBirth = req.DateofBirth,
                        CityIATACode = req.CityIATACode,
                        IsActive = req.IsActive,
                        IsForContracting = req.IsForContracting,
                        Action = req.Action,
                        BizPStatus = req.BizPStatus,
                    };

                    var data = new CommonClass.ResponseViewModel<SearchManage_Contact>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ManageSearchContactDetails", parameters);
                    //return CommonFunctions.ProcessDBData(data, "S", "usp_ManageSearchContactDetails", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchManage_Contact ends here

        #region searchprinttax starts here
        public async Task<ResponseModel> SearchPrintWithTax(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<SearchPrintWithTax>(request.RequestText);
                if (req == null)
                return CommonFunctions.BlankResponse("201", "Invalid request");

                var parameters = new { @InvoiceID = req.InvoiceID, @QuotationID = req.QuotationID };
                DataSet ds = await GetInvoiceData(parameters, "USP_GetInvoiceReportNewHorizontalOne");

                if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                    return CommonFunctions.BlankResponse("500", "Data not found.");

                using (var stream = new MemoryStream())
                {
                    Document document = new Document(PageSize.A4, 36, 36, 36, 36);
                    PdfWriter writer = PdfWriter.GetInstance(document, stream);
                    document.Open();

                    BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                    Font headerFont = new Font(bf, 12, Font.NORMAL); // Changed from BOLD to NORMAL
                    Font normalFont = new Font(bf, 10, Font.NORMAL);
                    Font smallFont = new Font(bf, 8, Font.NORMAL);
                    Font boldFont = new Font(bf, 12, Font.BOLD);

                    AddCompanyHeader(document, ds.Tables[0], headerFont, normalFont, boldFont);

                    AddClientSection(document, ds.Tables[0], ds.Tables[1], normalFont);

                    AddInvoiceItemsTable(document, ds.Tables[1], normalFont);

                    AddTaxBreakdown(document, ds.Tables[1], normalFont);

                    AddStructuredBankDetails(document, ds.Tables[0], normalFont);

                    AddStructuredFooter(document, normalFont);

                    AddNotes(document, ds.Tables[0], normalFont);


                    document.Close();
                    byte[] pdfBytes = stream.ToArray();
                    return CommonFunctions.ProcessFileResult(new CommonClass.FileResponseViewModel<FileResponseModel>(), pdfBytes);
                }
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Invalid action");
            }
        }


        private static void AddNotes(Document document, DataTable companyTable, Font normalFont)
        {
            var notes = companyTable.Rows[0]["BTCDPRemark"].ToString().Split('\n'); // Split notes into lines
            foreach (var note in notes)
            {
                document.Add(new Paragraph(note, normalFont));
            }
        }


        private void AddCompanyHeader(Document document, DataTable companyTable, Font headerFont, Font normalFont, Font boldFont)
        {
            var company = companyTable.Rows[0];

            string logoFileName = "Tamarind Tours Logo Small.jpg";
            string logoPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads","Documents", "Images", logoFileName);
            Console.WriteLine("Logo Path: " + logoPath);

            if (File.Exists(logoPath))
            {
                try
                {
                    Image logo = Image.GetInstance(logoPath);
                    logo.ScaleToFit(150f, 60f);
                    logo.Alignment = Element.ALIGN_CENTER;
                    document.Add(logo);
                    document.Add(new Paragraph("\n"));
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Logo load error: " + ex.Message);
                }
            }
            else
            {
                Console.WriteLine("Logo not found at path: " + logoPath);
            }
            // Add the company name
            document.Add(new Paragraph("TAMARIND GLOBAL SERVICES PRIVATE LIMITED", boldFont)
            {
                Alignment = Element.ALIGN_LEFT
            });

            // Add company address
            document.Add(new Paragraph(company["Address"].ToString(), normalFont));
            document.Add(new Paragraph("\n")); // Spacing

            // Add company details in table
            PdfPTable detailsTable = new PdfPTable(2);
            detailsTable.WidthPercentage = 100;
            detailsTable.SetWidths(new float[] { 30, 70 }); // Label:Value width ratio

            AddDetailRow(detailsTable, "PAN:", company["PAN"].ToString(), normalFont);
            AddDetailRow(detailsTable, "GSTIN:", company["GSTIN"].ToString(), normalFont);
            AddDetailRow(detailsTable, "CIN:", company["CIN"].ToString(), normalFont);
            AddDetailRow(detailsTable, "MSMEReg:", company["MSMERegNo"].ToString(), normalFont);
            AddDetailRow(detailsTable, "LUTNo:", company["LUTNumber"].ToString(), normalFont);
            AddDetailRow(detailsTable, "ACKNo:", company["ACKNo"].ToString(), normalFont);
            AddDetailRow(detailsTable, "IRN:", company["IRN"].ToString(), normalFont);
            AddDetailRow(detailsTable, "ACKDate:", company["ACKDate"].ToString(), normalFont);

            document.Add(detailsTable);
            AddDivider(document);
        }



        private void AddDetailRow(PdfPTable table, string label, string value, Font font)
        {
            // Label cell
            PdfPCell labelCell = new PdfPCell(new Paragraph(label, font));
            labelCell.Border = PdfPCell.NO_BORDER;
            labelCell.HorizontalAlignment = Element.ALIGN_LEFT;
            table.AddCell(labelCell);
            // Value cell
            PdfPCell valueCell = new PdfPCell(new Paragraph(value, font));
            valueCell.Border = PdfPCell.NO_BORDER;
            valueCell.HorizontalAlignment = Element.ALIGN_LEFT;
            table.AddCell(valueCell);
        }
        private void AddSignature(PdfPCell signatureCell, string signaturePath)
        {
            if (File.Exists(signaturePath))
            {
                try
                {
                    Image signature = Image.GetInstance(signaturePath);
                    signature.ScaleToFit(100f, 50f);
                    signature.Alignment = Image.ALIGN_RIGHT;
                    signatureCell.AddElement(signature);
                }
                catch (Exception ex)
                {

                    Console.WriteLine($"Error loading signature: {ex.Message}");
                }
            }


            signatureCell.AddElement(new Paragraph("\nAuthorized Signatory",
                FontFactory.GetFont(FontFactory.HELVETICA, 10, Font.BOLD))
            {
                Alignment = Element.ALIGN_RIGHT
            });
        }
      
        private void AddClientSection(Document document, DataTable invoiceTable, DataTable companyTable, Font normalFont)

        {

            var invoice = invoiceTable.Rows[0];

            var company = companyTable.Rows[0];

            PdfPTable boxTable = new PdfPTable(1);

            boxTable.WidthPercentage = 100;

            boxTable.SpacingBefore = 10f;

            PdfPCell boxCell = new PdfPCell();

            boxCell.Border = Rectangle.BOX; 

            boxCell.BorderWidth = 1f;

            boxCell.Padding = 10f; 

            Paragraph clientHeader = new Paragraph("Client:", normalFont);

            boxCell.AddElement(clientHeader);

            boxCell.AddElement(new Paragraph(company["CustomerName"].ToString(), normalFont));

            boxCell.AddElement(new Paragraph(company["AgentAddress"].ToString(), normalFont));

            boxCell.AddElement(new Paragraph($"State Code: {invoice["STATE"]} | GSTIN: {invoice["CGSTIN"]}", normalFont));

            PdfPTable refTable = new PdfPTable(2);

            refTable.WidthPercentage = 100;

            refTable.SetWidths(new float[] { 70, 30 });

            PdfPCell leftCell = new PdfPCell();

            leftCell.Border = PdfPCell.NO_BORDER;

            refTable.AddCell(leftCell);

            PdfPCell rightCell = new PdfPCell();

            rightCell.Border = PdfPCell.NO_BORDER;

            rightCell.HorizontalAlignment = Element.ALIGN_RIGHT;

            rightCell.AddElement(new Phrase($"Booked By: {company["Reference"]}", normalFont));

            rightCell.AddElement(new Phrase($"Your Ref: {company["Reference"]}", normalFont));

            refTable.AddCell(rightCell);

            boxCell.AddElement(refTable);

            boxTable.AddCell(boxCell);

            document.Add(boxTable);

            document.Add(new Paragraph("\n"));

        }

        private void AddInvoiceItemsTable(Document document, DataTable invoiceTable, Font normalFont)
        {
            var invoice = invoiceTable.Rows[0];

            PdfPTable itemsTable = new PdfPTable(8);
            itemsTable.WidthPercentage = 100;
            itemsTable.SetWidths(new float[] { 3f, 1.5f, 1f, 1.5f, 1.5f, 1.5f, 1f, 1.5f });
            itemsTable.SpacingBefore = 10f;

            AddTableHeaderCell(itemsTable, "Description", normalFont);
            AddTableHeaderCell(itemsTable, "HSN/SAC", normalFont);
            AddTableHeaderCell(itemsTable, "Tax %", normalFont);
            AddTableHeaderCell(itemsTable, "Basic Amt", normalFont);
            AddTableHeaderCell(itemsTable, "Taxable Amt", normalFont);
            AddTableHeaderCell(itemsTable, "Tax Amount", normalFont);
            AddTableHeaderCell(itemsTable, "TCS", normalFont);
            AddTableHeaderCell(itemsTable, "Amount", normalFont);

            AddTableCell(itemsTable, invoice["TaxDesc"].ToString(), normalFont, Element.ALIGN_LEFT);
            AddTableCell(itemsTable, invoice["Qut_ID"].ToString(), normalFont, Element.ALIGN_CENTER);
            AddTableCell(itemsTable, invoice["GST_Perc"].ToString() + "%", normalFont, Element.ALIGN_CENTER);
            AddTableCell(itemsTable, invoice["AmtInINR"].ToString(), normalFont, Element.ALIGN_RIGHT);
            AddTableCell(itemsTable, invoice["OtherTaxAmount"].ToString(), normalFont, Element.ALIGN_RIGHT);
            AddTableCell(itemsTable, invoice["TaxAmount"].ToString(), normalFont, Element.ALIGN_RIGHT);
            AddTableCell(itemsTable, invoice["TCSValue"].ToString(), normalFont, Element.ALIGN_RIGHT);
            AddTableCell(itemsTable, invoice["Invoice_Total"].ToString(), normalFont, Element.ALIGN_RIGHT);

            PdfPCell totalCell = new PdfPCell(new Phrase("Total: INR", normalFont));
            totalCell.Colspan = 5;
            totalCell.Border = Rectangle.TOP_BORDER | Rectangle.BOTTOM_BORDER | Rectangle.LEFT_BORDER;
            totalCell.BorderWidth = 0.5f;
            totalCell.Padding = 5f;
            itemsTable.AddCell(totalCell);

            PdfPCell emptyCell1 = new PdfPCell(new Phrase("", normalFont));
            emptyCell1.Border = Rectangle.TOP_BORDER | Rectangle.BOTTOM_BORDER;
            emptyCell1.BorderWidth = 0.5f;
            itemsTable.AddCell(emptyCell1);

            PdfPCell emptyCell2 = new PdfPCell(new Phrase("", normalFont));
            emptyCell2.Border = Rectangle.TOP_BORDER | Rectangle.BOTTOM_BORDER;
            emptyCell2.BorderWidth = 0.5f;
            itemsTable.AddCell(emptyCell2);

            PdfPCell totalAmountCell = new PdfPCell(new Phrase(invoice["Invoice_Total"].ToString(), normalFont));
            totalAmountCell.HorizontalAlignment = Element.ALIGN_RIGHT;
            totalAmountCell.Border = Rectangle.TOP_BORDER | Rectangle.BOTTOM_BORDER | Rectangle.RIGHT_BORDER;
            totalAmountCell.BorderWidth = 0.5f;
            totalAmountCell.Padding = 5f;
            itemsTable.AddCell(totalAmountCell);

            document.Add(itemsTable);

            // Signature table
            PdfPTable signatureTable = new PdfPTable(8);
            signatureTable.WidthPercentage = 100;
            signatureTable.SetWidths(new float[] { 3f, 1.5f, 1f, 1.5f, 1.5f, 1.5f, 1f, 1.5f });

            for (int i = 0; i < 7; i++)
            {
                PdfPCell emptyCell = new PdfPCell(new Phrase("", normalFont));
                emptyCell.Border = PdfPCell.NO_BORDER;
                signatureTable.AddCell(emptyCell);
            }

            PdfPCell signatureCell = new PdfPCell();
            signatureCell.Border = PdfPCell.NO_BORDER;
            signatureCell.HorizontalAlignment = Element.ALIGN_RIGHT;
            signatureCell.PaddingTop = 10f;

            // Load signature image from wwwroot/Uploads/Images
            string signatureFileName = "Signature2.jpg";
            string signaturePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents", "Images", signatureFileName);
            Console.WriteLine("Signature path: " + signaturePath); // debug print

            if (File.Exists(signaturePath))
            {
                try
                {
                    Image signature = Image.GetInstance(signaturePath);
                    signature.ScaleToFit(80f, 40f);
                    signature.Alignment = Image.ALIGN_RIGHT;
                    signatureCell.AddElement(signature);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error loading signature: {ex.Message}");
                }
            }
            else
            {
                Console.WriteLine($"Signature image not found at path: {signaturePath}");
            }

            signatureCell.AddElement(new Paragraph("Authorized Signatory",
                new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL))
            {
                Alignment = Element.ALIGN_RIGHT
            });

            signatureTable.AddCell(signatureCell);
            document.Add(signatureTable);
        }


        private void AddTaxBreakdown(Document document, DataTable invoiceTable, Font normalFont)
        {
            var invoice = invoiceTable.Rows[0];

            PdfPTable taxTable = new PdfPTable(4);
            taxTable.WidthPercentage = 50;
            taxTable.HorizontalAlignment = Element.ALIGN_LEFT;
            taxTable.SpacingBefore = 10f;

            taxTable.SetWidths(new float[] { 1f, 1f, 1f, 1f });

            AddTableCell(taxTable, "UTGST", normalFont, Element.ALIGN_CENTER, true);
            AddTableCell(taxTable, "IGST", normalFont, Element.ALIGN_CENTER, true);
            AddTableCell(taxTable, "CGST", normalFont, Element.ALIGN_CENTER, true);
            AddTableCell(taxTable, "SGST", normalFont, Element.ALIGN_CENTER, true);

            AddTableCell(taxTable, invoice["UTGST"].ToString(), normalFont, Element.ALIGN_CENTER);
            AddTableCell(taxTable, invoice["IGST"].ToString(), normalFont, Element.ALIGN_CENTER);
            AddTableCell(taxTable, invoice["CGST"].ToString(), normalFont, Element.ALIGN_CENTER);
            AddTableCell(taxTable, invoice["SGST"].ToString(), normalFont, Element.ALIGN_CENTER);

            document.Add(taxTable);
        }

        private void AddTableHeaderCell(PdfPTable table, string text, Font font)
        {
            PdfPCell cell = new PdfPCell(new Phrase(text, font));
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.Border = Rectangle.BOX;
            cell.BorderWidth = 0.5f;
            cell.Padding = 5f;
            cell.BackgroundColor = new BaseColor(240, 240, 240); 
            table.AddCell(cell);
        }

        private void AddTableCell(PdfPTable table, string text, Font font, int alignment, bool isHeader = false)
        {
            PdfPCell cell = new PdfPCell(new Phrase(text, font));
            cell.HorizontalAlignment = alignment;
            cell.Border = Rectangle.BOX;
            cell.BorderWidth = 0.5f;
            cell.Padding = 5f;

            if (isHeader)
            {
                cell.BackgroundColor = new BaseColor(240, 240, 240);
            }

            table.AddCell(cell);
        }

        private void AddStructuredBankDetails(Document document, DataTable companyTable, Font normalFont)
        {
            var company = companyTable.Rows[0];
            string bankDetails = company["BankDetails"].ToString();

            var bankDetailsArray = bankDetails.Split('|');
            string ifsc = "", swift = "", bankName = "", bankAddress = "", accountName = "", accountNo = "";

            foreach (var detail in bankDetailsArray)
            {
                if (detail.Contains("IFSC Code")) ifsc = detail.Split(':')[1].Trim();
                else if (detail.Contains("SWIFT Code")) swift = detail.Split(':')[1].Trim();
                else if (detail.Contains("Bank Name")) bankName = detail.Split(':')[1].Trim();
                else if (detail.Contains("Bank Address")) bankAddress = detail.Split(':')[1].Trim();
                else if (detail.Contains("Account Name")) accountName = detail.Split(':')[1].Trim();
                else if (detail.Contains("Account No")) accountNo = detail.Split(':')[1].Trim();
            }

            PdfPTable bankTable = new PdfPTable(2);
            bankTable.WidthPercentage = 100;
            bankTable.SpacingBefore = 10f;
            bankTable.SetWidths(new float[] { 1f, 3f });

            AddBankDetailRow(bankTable, "Account Name:", accountName, normalFont);
            AddBankDetailRow(bankTable, "Account No:", accountNo, normalFont);
            AddBankDetailRow(bankTable, "IFSC Code:", ifsc, normalFont);
            AddBankDetailRow(bankTable, "SWIFT Code:", swift, normalFont);
            AddBankDetailRow(bankTable, "Bank Name:", bankName, normalFont);
            AddBankDetailRow(bankTable, "Bank Address:", bankAddress, normalFont);

            document.Add(new Paragraph("Bank Details:", normalFont));
            document.Add(bankTable);
        }

        private void AddBankDetailRow(PdfPTable table, string label, string value, Font font)
        {
            PdfPCell labelCell = new PdfPCell(new Phrase(label, font));
            labelCell.HorizontalAlignment = Element.ALIGN_LEFT;
            labelCell.Border = Rectangle.LEFT_BORDER | Rectangle.TOP_BORDER | Rectangle.BOTTOM_BORDER;
            labelCell.BorderWidth = 0.5f;
            labelCell.Padding = 5f;
            table.AddCell(labelCell);

            PdfPCell valueCell = new PdfPCell(new Phrase(value, font));
            valueCell.HorizontalAlignment = Element.ALIGN_LEFT;
            valueCell.Border = Rectangle.RIGHT_BORDER | Rectangle.TOP_BORDER | Rectangle.BOTTOM_BORDER;
            valueCell.BorderWidth = 0.5f;
            valueCell.Padding = 5f;
            table.AddCell(valueCell);
        }

        private void AddStructuredFooter(Document document, Font normalFont)
        {
            Paragraph footer = new Paragraph(
                "Tax Payable under RCM: No | Original for Recipient | " +
                "Disputes subject to Mumbai Jurisdiction only | " +
                "This is a computer-generated document and does not require Signature",
                normalFont
            )
            {
                Alignment = Element.ALIGN_CENTER,
                SpacingBefore = 10f
            };

            document.Add(footer);
        }

        private PdfPCell CreateCell(string text, Font font, int alignment = Element.ALIGN_LEFT, int colspan = 1)
        {
            PdfPCell cell = new PdfPCell(new Phrase(text, font));
            cell.HorizontalAlignment = alignment;
            cell.Border = PdfPCell.NO_BORDER;
            cell.Colspan = colspan;
            cell.Padding = 5f;
            return cell;
        }

        private PdfPCell CreateHeaderCell(string text, Font font)
        {
            PdfPCell cell = new PdfPCell(new Phrase(text, font));
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.Padding = 5f;
            return cell;
        }

        private async Task<DataSet> GetInvoiceData(object parameters, string storedProcedure)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(_config.GetConnectionString("DefaultConnection")))
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

        private void AddDivider(Document document)
        {
            document.Add(new Chunk(new LineSeparator(0.5f, 100f, BaseColor.BLACK, Element.ALIGN_CENTER, -1)));
        }
        #endregion Search_PrintCommInvoice ends here
    }
}