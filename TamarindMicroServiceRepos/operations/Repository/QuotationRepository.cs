//using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;

//using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
//using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
//using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using AutoMapper;
using CommonClass;
using Dapper;
using Microsoft.Extensions.Options;
using MongoDB.Repositories;
using Newtonsoft.Json;
using NLog;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra_Operations.Interface;
using TamarindAstra_Operations.Model;
using static NPOI.HSSF.Util.HSSFColor;

//using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using JsonException = Newtonsoft.Json.JsonException;

namespace TamarindAstra_Operations.Repository
{
    public class QuotationRepository : IQuotation
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        private readonly string isEncrypted;
        private readonly string _connectionString;
        private readonly IMapper _mapper;
        public QuotationRepository(IConfiguration config, IOptions<Cryptography> options, IMapper mapper)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];

            _mapper = mapper;
        }

        #region Quotation Starts here
        new
         public async Task<ResponseModel> QuotationMaster(RequestModel request)

        {

            ResponseModel _resModel = new ResponseModel();

            try

            {

                // Decrypt and deserialize the request

                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationMaster>(request.RequestText);

                logger.Debug("QuotationMaster method called");

                if (req != null)

                {

                    var parameters = new

                    {

                        @QuotationID = req.QuotationID,

                        @Currency = req.Currency,

                        @TaxType = req.TaxType,

                        @TaxonSale = req.TaxonSale,

                        @ParentID = req.ParentID,

                        @Disclaimer = req.Disclaimer,

                        @BookingID = req.BookingID,


                        @YearID = req.YearID,

                        @EQID = req.EQID,

                        @AgentID = req.AgentID,

                        @AgentStaffName = req.AgentStaffName,

                        @Status = req.Status,

                        @QuotationNo = req.QuotationNo,
                        @EnquiryNo = req.EnquiryNo,

                        @OutQuotationID = req.@OutQuotationID,

                        @CompanyID = req.CompanyID,

                        @QuotationFromDate = req.QuotationFromDate,

                        @QuotationToDate = req.QuotationToDate,

                        @RateCardMode = req.RateCardMode,

                        @CustomerID = req.CustomerID,

                        @Action = req.Action,

                        @QuotationDate = req.QuotationDate,

                        @OperationBy = req.OperationBy,

                        @PageNumber = req.PageNumber,
                    };

                    var data = new CommonClass.ResponseViewModel<QuotationMaster>()
                    {
                        data = req
                    };

                    if (req.Action.ToLower() == "f")
                        return CommonFunctions.ProcessDBData(data, req.Action, "[Quotation].[usp_InsertUpdateQuotation]", parameters);
                    else
                        return CommonFunctions.ProcessDBDataPagination(data, req.Action, "[Quotation].[usp_InsertUpdateQuotation]", parameters);
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

            }

            catch (Exception ex)

            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");

            }

        }


        public async Task<ResponseModel> Update_Quotation(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationMaster>(request.RequestText);
                logger.Debug("Update_Quotation method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @QuotationRateCardId = req.QuotationRateCardId,
                        @RateType = req.RateType,
                        @QuotationID = req.QuotationID,
                        @Disclaimer = req.Disclaimer,
                        @CreatedBy = req.CreatedBy,
                    };

                    var data = new CommonClass.ResponseViewModel<QuotationMaster>()
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, "U", "[Quotation].[usp_UpdateQuotation]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> SaveQuotation(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SaveQuotationFlag>(request.RequestText);
                logger.Debug("SaveQuotation method called");

                if (req != null)
                {
                    // Convert RateCards to DataTable for TVP
                    var dtRateCards = new DataTable();
                    dtRateCards.Columns.Add("QuotationRateCardId", typeof(int));
                    dtRateCards.Columns.Add("ShowAnnouncement", typeof(bool));
                    dtRateCards.Columns.Add("ShowTransfers", typeof(bool));
                    dtRateCards.Columns.Add("ShowValueAddOns", typeof(bool));
                    dtRateCards.Columns.Add("ShowCancellationDays", typeof(bool));

                    var dtGuideRateCards = new DataTable();
                    dtGuideRateCards.Columns.Add("QuotationRateCardId", typeof(int));

                    dtGuideRateCards.Columns.Add("ShowValueAddOns", typeof(bool));



                    // Check if RateCards exists and is not null or empty
                    if (req.RateCards != null && req.RateCards.Any())
                    {
                        foreach (var item in req.RateCards)
                        {
                            dtRateCards.Rows.Add(item.QuotationRateCardId, item.ShowAnnouncement, item.ShowTransfers, item.ShowValueAddOns, item.ShowCancellationDays);
                        }
                    }

                    // Check if GuideRateCards exists and is not null or empty
                    if (req.GuideRateCards != null && req.GuideRateCards.Any())
                    {
                        foreach (var item in req.GuideRateCards)
                        {
                            dtGuideRateCards.Rows.Add(item.QuotationRateCardId, item.ShowValueAddOns);
                        }
                    }


                    var parameters = new DynamicParameters();
                    parameters.Add("@QuotationID", req.QuotationID);
                    parameters.Add("@Status", req.Status);
                    parameters.Add("@CreatedBy", req.CreatedBy);
                    parameters.Add("@RateCardUpdates", dtRateCards.AsTableValuedParameter("[Quotation].[RateCardUpdateType]")); // TVP
                    parameters.Add("@GuideRateCardUpdates", dtGuideRateCards.AsTableValuedParameter("[Quotation].[GuideRateCardUpdateType]"));


                    var data = new CommonClass.ResponseViewModel<SaveQuotationFlag>()
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, "U", "[Quotation].[usp_SaveQuotation]", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task<ResponseModel> FetchQuotations(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationMaster>(request.RequestText);
                logger.Debug("FetchQuotationDD method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<QuotationMaster>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Quotation].[usp_FetchQuotationDD]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }




        #endregion Quotation ends here


        #region QuotationGuideCreate


        public async Task<ResponseModel> Quotationguide(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();

            try
            {
                var rootRequest = CommonFunctions.DecryptAndDeserializeRequest<GuideRateList>(request.RequestText);
                logger.Debug("GuideRateMaster method called");

                if (rootRequest?.DataList != null && rootRequest.DataList.Count > 0)
                {
                    foreach (GuideRateSearchRequest req in rootRequest.DataList)
                    {
                        req.Action = rootRequest.Action;

                        var parameters = new
                        {
                            @Action = rootRequest.Action,
                            @GuideRateID = req.GuideRateID,
                            @QuotationID = req.QuotationID,
                            @Markup_IsRate = req.Markup_IsRate,
                            @NetRate = req.NetRate,
                            @SellingRates = req.SellingRates,
                            @GrossRate = req.GrossRate,
                            @GrossRateAdult = req.GrossRateAdult,
                            @GrossRateChild = req.GrossRateChild,
                            @MarkupRate = req.MarkupRate,
                            @Disclaimer = req.Disclaimer,
                            @ReasonID = req.ReasonID,
                            @GuideRateDetailID = req.GuideRateDetailID,
                            @FromDate = req.FromDate,
                            @ToDate = req.ToDate,
                            @QGID = req.QGID,
                            @OthersRateCardCommissionID = req.OthersRateCardCommissionID,
                            @IsSummary = req.IsSummary,
                            @OperationBy = req.OperationBy


                        };

                        var data = new CommonClass.ResponseViewModel<GuideRateSearchRequest>
                        {
                            data = req
                        };

                        // Execute and keep overwriting the response
                        _resModel = CommonFunctions.ProcessDBData(data, rootRequest.Action, "[Quotation].[InsertUpdateGuideRateMasterCommissionDetails]", parameters);
                        _resModel.returnCode = data.returnCode;
                        _resModel.returnMessage = data.returnMessage;
                    }

                    // Return only one (last) result
                    return _resModel;
                }
                else
                {
                    return new ResponseModel
                    {
                        returnCode = "400",
                        returnMessage = "No data found in the request."
                    };
                }
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "GuideReport Save Failed");
            }
        }



        #endregion

        #region QuotationMonumentCreate 



        public async Task<ResponseModel> QuotationMonumentcreate(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();

            try
            {
                var rootRequest = CommonFunctions.DecryptAndDeserializeRequest<MonumentRateList>(request.RequestText);
                logger.Debug("MonumentRateMaster method called");

                if (rootRequest?.DataList != null && rootRequest.DataList.Count > 0)
                {
                    foreach (var req in rootRequest.DataList)
                    {
                        req.Action = rootRequest.Action;

                        // Prepare commission table
                        DataTable commissionTable = new DataTable();
                        commissionTable.Columns.Add("MonumentCommissionDetailID", typeof(long));
                        commissionTable.Columns.Add("MonumentDetailID", typeof(long));
                        commissionTable.Columns.Add("CommissionMasterID", typeof(long));
                        commissionTable.Columns.Add("SellingRates", typeof(decimal));
                        commissionTable.Columns.Add("GrossRate", typeof(decimal));
                        commissionTable.Columns.Add("Markup_IsRate", typeof(bool));
                        commissionTable.Columns.Add("MarkupRate", typeof(decimal));
                        commissionTable.Columns.Add("OthersRateCardCommissionID", typeof(long));

                        commissionTable.Columns.Add("AdultReasonId", typeof(int));
                        commissionTable.Columns.Add("ChildReasonId", typeof(int));


                        if (req.Commissions != null && req.Commissions.Count > 0)
                        {
                            foreach (var commission in req.Commissions)
                            {
                                commissionTable.Rows.Add(
                                    commission.MonumentCommissionDetailID,
                                    commission.MonumentDetailID,
                                    commission.CommissionMasterID,
                                    commission.SellingRates ?? 0,
                                    commission.GrossRate ?? 0,
                                    commission.Markup_IsRate,
                                    commission.MarkupRate,
                                    commission.OthersRateCardCommissionID,
                                    commission.AdultReasonId,
                                    commission.ChildReasonId
                                );
                            }
                        }

                        var parameters = new
                        {
                            Action = rootRequest.Action,
                            RateID = req.MonumentRateID,
                            QuotationID = req.QuotationID,
                            Markup_IsRate = req.Markup_IsRate,
                            NetRate = req.NetRate,
                            SellingRates = req.SellingRates,
                            GrossRate = req.GrossRate,
                            GrossRateAdult = req.GrossRateAdult,
                            GrossRateChild = req.GrossRateChild,
                            MarkupRate = req.MarkupRate,
                            Disclaimer = req.Disclaimer,
                            ReasonID = req.ReasonID,
                            MonumentDetailID = req.MonumentDetailID,
                            CommissionList = commissionTable.AsTableValuedParameter("CommissionTableType"),

                            FromDate = req.FromDate,
                            ToDate = req.ToDate,
                            QMID = req.QMID,
                            @IsSummary = req.IsSummary,
                            @OperationBy = req.OperationBy

                        };

                        var data = new CommonClass.ResponseViewModel<MonumentRateList>
                        {
                            data = rootRequest
                        };

                        // Process and overwrite the final result
                        _resModel = CommonFunctions.ProcessDBData(data, rootRequest.Action, "[Quotation].[InsertUpdateMonumentRateMasterCommissionDetails]", parameters);
                        _resModel.returnCode = data.returnCode;
                        _resModel.returnMessage = data.returnMessage;
                    }

                    return _resModel;
                }

                return new ResponseModel
                {
                    returnCode = "400",
                    returnMessage = "No data found in the request."
                };
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Monument Save Failed");
            }
        }



        #endregion






        public async Task<ResponseModel> QuotationSpecialServicecreate(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();

            try
            {
                var rootRequest = CommonFunctions.DecryptAndDeserializeRequest<SpecialServiceList>(request.RequestText);
                logger.Debug("SpecialServiceSearchcreate method called");

                if (rootRequest?.DataList != null && rootRequest.DataList.Count > 0)
                {
                    foreach (SpecialServiceRequest req in rootRequest.DataList)
                    {
                        var action = rootRequest.Action;

                        // Prepare Commission Table
                        DataTable commissionTable = new DataTable();
                        commissionTable.Columns.Add("SpecialCommissionDetailID", typeof(long));
                        commissionTable.Columns.Add("SpecialDetailID", typeof(long));
                        commissionTable.Columns.Add("CommissionMasterID", typeof(long));
                        commissionTable.Columns.Add("SellingRates", typeof(decimal));
                        commissionTable.Columns.Add("GrossRate", typeof(decimal));
                        commissionTable.Columns.Add("Markup_IsRate", typeof(bool));
                        commissionTable.Columns.Add("MarkupRate", typeof(decimal));
                        commissionTable.Columns.Add("OthersRateCardCommissionID", typeof(long));

                        commissionTable.Columns.Add("AdultReasonId", typeof(int));
                        commissionTable.Columns.Add("ChildReasonId", typeof(int));


                        if (req.Commissions != null)
                        {
                            foreach (var commission in req.Commissions)
                            {
                                commissionTable.Rows.Add(
                                    commission.SpecialServiceRateCommissionID,
                                    commission.SpecialServiceRateDetailID,
                                    commission.CommissionMasterID,
                                    commission.SellingRates,
                                    commission.GrossRate,
                                    commission.Markup_IsRate,
                                    commission.MarkupRate,
                                    commission.OthersRateCardCommissionID,
                                    commission.AdultReasonId,
                                    commission.ChildReasonId
                                );
                            }
                        }

                        var parameters = new
                        {
                            Action = action,
                            SpecialServiceRateID = req.SpecialServiceRateID,
                            QuotationID = req.QuotationID,
                            Markup_IsRate = req.Markup_IsRate,
                            NetRate = req.NetRate,
                            SellingRates = req.SellingRates,
                            GrossRate = req.GrossRate,
                            GrossRateAdult = req.GrossRateAdult,
                            GrossRateChild = req.GrossRateChild,
                            MarkupRate = req.MarkupRate,
                            Disclaimer = req.Disclaimer,
                            ReasonID = req.ReasonID,
                            SpecialServiceRateDetailID = req.SpecialServiceRateDetailID,
                            CommissionList = commissionTable.AsTableValuedParameter("dbo.SpecialCommissionTableType"),
                            FromDate = req.FromDate,
                            ToDate = req.ToDate,
                            QSSMID = req.QSSMID,
                            IsSummary = req.IsSummary,
                            OperationBy = req.OperationBy
                        };

                        var data = new CommonClass.ResponseViewModel<SpecialServiceRequest>
                        {
                            data = req
                        };

                        // Overwrite result in each loop iteration
                        _resModel = CommonFunctions.ProcessDBData(data, action, "[Quotation].[InsertUpdateSpecialRateMasterCommissionDetails]", parameters);
                        _resModel.returnCode = data.returnCode;
                        _resModel.returnMessage = data.returnMessage;
                    }

                    return _resModel;
                }

                return new ResponseModel
                {
                    returnCode = "400",
                    returnMessage = "No special service data found in the request."
                };
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Special Service Save Failed");
            }
        }





        public async Task<ResponseModel> QuotationTransportcreate(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();

            try
            {
                var rootRequest = CommonFunctions.DecryptAndDeserializeRequest<TransportServiceList>(request.RequestText);
                logger.Debug("QuotationTransportcreate method called");

                if (rootRequest != null && rootRequest.DataList != null && rootRequest.DataList.Count > 0)
                {
                    foreach (TransportRateRequest req in rootRequest.DataList)
                    {
                        req.Action = rootRequest.Action;

                        // Prepare commissions table
                        DataTable commissionTable = new DataTable();
                        commissionTable.Columns.Add("TransportCommissionDetailID", typeof(long));
                        commissionTable.Columns.Add("TransportRateDetailID", typeof(long));
                        commissionTable.Columns.Add("CommissionMasterID", typeof(long));
                        commissionTable.Columns.Add("SellingRates", typeof(decimal));
                        commissionTable.Columns.Add("GrossRate", typeof(decimal));
                        commissionTable.Columns.Add("Markup_IsRate", typeof(bool));
                        commissionTable.Columns.Add("MarkupRate", typeof(decimal));
                        commissionTable.Columns.Add("OthersRateCardCommissionID", typeof(long));

                        if (req.Commissions != null)
                        {
                            foreach (var com in req.Commissions)
                            {
                                commissionTable.Rows.Add(
                                    com.TransportCommissionDetailID,
                                    com.TransportRateDetailID,
                                    com.CommissionMasterID,
                                    com.SellingRates,
                                    com.GrossRate,
                                    com.Markup_IsRate,
                                    com.MarkupRate,
                                     com.OthersRateCardCommissionID
                                );
                            }
                        }

                        var parameters = new
                        {
                            Action = rootRequest.Action,
                            TransportRateID = req.TransportRateID,
                            QuotationID = req.QuotationID,
                            Markup_IsRate = req.Markup_IsRate,
                            NetRate = req.NetRate,
                            SellingRates = req.SellingRates,
                            GrossRate = req.GrossRate,
                            GrossRateAdult = (int?)null,
                            GrossRateChild = (int?)null,
                            MarkupRate = req.MarkupRate,
                            Disclaimer = req.Disclaimer,
                            ReasonID = req.ReasonID,
                            TransportRateDetailID = req.TransportRateDetailID,
                            CommissionList = commissionTable.AsTableValuedParameter("dbo.TransportCommissionTableType"),
                            FromDate = req.FromDate,
                            ToDate = req.ToDate,
                            TQTID = req.TQTID,
                            IsSummary = req.IsSummary,
                            OperationBy = req.OperationBy
                        };

                        var data = new CommonClass.ResponseViewModel<TransportServiceList>
                        {
                            data = rootRequest
                        };

                        // Store the last response
                        _resModel = CommonFunctions.ProcessDBData(data, rootRequest.Action, "[Quotation].[InsertUpdateTransportRateMasterCommissionDetails]", parameters);
                        _resModel.returnCode = data.returnCode;
                        _resModel.returnMessage = data.returnMessage;
                    }

                    return _resModel;
                }
                else
                {
                    return new ResponseModel
                    {
                        returnCode = "400",
                        returnMessage = "No data found in the request."
                    };
                }
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Transport Rate Save Failed");
            }
        }




        public async Task<ResponseModel> GetQuotationStatus(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationStatus>(request.RequestText);
                logger.Debug("GetQuotationStatus method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<QuotationStatus>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Quotation].[usp_GetQuotationStatus]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        //     public async Task<ResponseModel> GetQuotationService(RequestModel request)
        //     {
        //         try
        //         {
        //             var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationService>(request.RequestText);
        //             logger.Debug("GetQuotationService method called");

        //             if (req == null)
        //                 return CommonFunctions.BlankResponse("201", "Invalid request parameters");

        //             var parameters = new
        //             {
        //                 @QuotationId = req.QuotationID,
        //                 @Action = req.Action,
        //             };

        //             // Get data from database
        //             var result = await SqlHelper.LoadDataWithMultiTablesAsync<GetGuideRateSearchResponseDto, GetMonumentRateSearchResponseDto,
        //                             TransportRateSearchResponseDto, GetSpecialServiceSearchResponseDto, HotelRateDetailsSearchResponseDto, dynamic>(
        //                 "[Quotations].[usp_GetRateCardSearchReport]",
        //                 parameters
        //             );




        //             // Step 1: Declare the response object
        //             var responseData = new QuotationServiceResponse();

        //             // Step 2: Bind each dataset separately

        //             //Guide

        //             responseData.Guides = new ServiceResult<GetGuideRateSearchResponseDto>
        //             {
        //                 Data = result.Table1,
        //                 returnCode = result.Table1.Any() ? "200" : "201",
        //                 returnMessage = result.Table1.Any() ? "Data found" : "Data Not Found"
        //             };

        //             //Monument

        //             var MonumentRes = result.Table2
        //              .GroupBy(x => x.MonumentDetailID)
        //              .Select(group =>
        //              {
        //                  var first = group.First();

        //                  // Map main DTO from the first grouped item
        //                  var mappedDto = _mapper.Map<GetMonumentRateSearchResponseDto>(first);

        //                  // Map commissions list
        //                  mappedDto.Commissions = _mapper.Map<List<MonumentRateCommissionDetailRequestDto>>(
        //                      group.Where(c => c.MonumentCommissionDetailID.HasValue).ToList()
        //                  );

        //                  return mappedDto;
        //              })
        //              .ToList();



        //             responseData.Monuments = new ServiceResult<GetMonumentRateSearchResponseDto>
        //             {
        //                 Data = MonumentRes,
        //                 returnCode = MonumentRes.Any() ? "200" : "201",
        //                 returnMessage = MonumentRes.Any() ? "Data found" : "Data Not Found"
        //             };

        //             //Transport

        //             var TransportRes = new List<TransportRateSearchResponseDto>();

        //             foreach (var row in result.Table3)
        //             {
        //                 var dto = new TransportRateSearchResponseDto
        //                 {
        //                     TransportRateID = row.TransportRateID,
        //                     RateCardModeType = row.RateCardModeType,
        //                     TransportModeType = row.TransportModeType,
        //                     TaxID = row.TaxID,
        //                     TransportServiceID = row.TransportServiceID,
        //                     HotelID = row.HotelID,
        //                     VendorID = row.VendorID,
        //                     HotelZone = row.HotelZone,
        //                     CityID = row.CityID,
        //                     //CityID2 = row.CityID2,
        //                     CurrencyID = row.CurrencyID,
        //                     StateID = row.StateID,
        //                     GstStatus = row.GstStatus,
        //                     VendorName = row.VendorName,
        //                     City = row.City,
        //                     TransportServiceName = row.TransportServiceName,
        //                     HotelZoneName = row.HotelZoneName,
        //                     VehicleCategoryID = row.VehicleCategoryID,
        //                     VehicleBaseID = row.VehicleBaseID,
        //                     ValidFrom = row.ValidFrom,
        //                     ValidTo = row.ValidTo,
        //                     MISSequence = row.MISSequence,
        //                     VehicleType = row.VehicleType,
        //                     VehicleName = row.VehicleName,
        //                     TransportService = row.TransportService,
        //                     //VehicleBaseType = row.VehicleBaseType,
        //                     //SellingRate = row.SellingRate,
        //                     Language = row.Language,
        //                     TransportRateDetailID = row.TransportRateDetailID,
        //                     Disclaimer = row.Disclaimer,


        //                     //GrossRate = row.GrossRate,

        //                     FromToDate = row.FromToDate,
        //                     QuotationID = row.QuotationID,
        //                     ReasonID = row.ReasonID,
        //                     RateCardModeTypeID = row.RateCardModeTypeID,
        //                     Type = row.Type,

        //                     // Safe JSON deserialization from string to list
        //                     Commissions = SafeDeserialize<List<TransportRateCommissionDetailResponseDto>>(row.TransportRateCommissionDetails),


        //                 };

        //                 TransportRes.Add(dto);
        //             }

        //             responseData.Transports = new ServiceResult<TransportRateSearchResponseDto>
        //             {
        //                 Data = TransportRes,
        //                 returnCode = TransportRes.Any() ? "200" : "201",
        //                 returnMessage = TransportRes.Any() ? "Data found" : "Data Not Found"
        //             };


        //             //Special service

        //             var SSResult = result.Table4
        //.GroupBy(x => x.SpecialServiceRateDetailID)
        //.Select(group =>
        //{
        //    var first = group.First();

        //    var dto = _mapper.Map<GetSpecialServiceSearchResponseDto>(first);
        //    dto.Commissions = group
        //        .Where(c => c.SpecialServiceRateCommissionID.HasValue)
        //        .Select(c => _mapper.Map<GetSpecialServiceRateCommissionDetailResponseDto>(c))
        //        .ToList();

        //    return dto;
        //})
        //.ToList();




        //             responseData.SpecialServices = new ServiceResult<GetSpecialServiceSearchResponseDto>
        //             {
        //                 Data = SSResult,
        //                 returnCode = SSResult.Any() ? "200" : "201",
        //                 returnMessage = SSResult.Any() ? "Data found" : "Data Not Found"
        //             };

        //             //hOTEL

        //             var hotelRes = new List<HotelRateDetailsSearchResponseDto>();

        //             foreach (var row in result.Table5)
        //             {
        //                 var dto = new HotelRateDetailsSearchResponseDto
        //                 {
        //                     QuoHotelRateID = row.QuoHotelRateID,
        //                     HotelRateID = row.HotelRateID,
        //                     HotelID = row.HotelID,
        //                     HotelName = row.HotelName,
        //                     CityID = row.CityID,
        //                     HotelRateDetailID = row.HotelRateDetailID,
        //                     RoomCategoryID = row.RoomCategoryID,
        //                     RoomCategory = row.RoomCategory,
        //                     MISSequence = row.MISSequence,
        //                     Days = row.Days,
        //                     DaysOfWeek = row.DaysOfWeek,
        //                     MealPlanCode = row.MealPlanCode,
        //                     Breakfast = row.Breakfast,
        //                     Lunch = row.Lunch,
        //                     Dinner = row.Dinner,
        //                     HasDocument = row.HasDocument,
        //                     HasRules = row.HasRules,
        //                     OfferTypeID = row.OfferTypeID,
        //                     FromToDate = row.FromToDate,
        //                     QuotationID = row.QuotationID,
        //                     CityName = row.CityName,
        //                     ShowTransfers = row.ShowTransfers,
        //                     ShowAnnouncement = row.ShowAnnouncement,
        //                     ShowValueAddOns = row.ShowValueAddOns,
        //                     ShowCancellationDays = row.ShowCancellationDays,
        //                     TransferValue = row.TransferValue,
        //                     ValueAddOn = row.ValueAddOn,
        //                     Type = row.Type,
        //                     Currency = row.Currency?.ToString(),
        //                     PurchaseRate = row.PurchaseRate != null ? Convert.ToDecimal(row.PurchaseRate) : 0,
        //                     Disclaimer = row.Disclaimer,

        //                     // Manual JSON deserialization
        //                     Commissions = SafeDeserialize<List<HotelRateCommissionDetailResponseDto>>(row.CommissionJSON),
        //                     Meals = SafeDeserialize<List<HotelRateMealResponseDto>>(row.MealOverviewJSON),
        //                     Offers = SafeDeserialize<List<HotelRateOfferConfigurationSearchDto>>(row.OfferConfigurationJSON),
        //                     HotelAnnouncement = SafeDeserialize<List<HotelAnnouncement>>(row.HotelAnnouncementsJSON),

        //                     CancellationPolicy = SafeDeserialize<List<HotelRateCancellationPolicy>>(row.CancellationPolicyJSON),
        //                 };

        //                 hotelRes.Add(dto);
        //             }


        //             responseData.Hotels = new ServiceResult<HotelRateDetailsSearchResponseDto>
        //             {
        //                 Data = hotelRes,
        //                 returnCode = hotelRes.Any() ? "200" : "201",
        //                 returnMessage = hotelRes.Any() ? "Data found" : "Data Not Found"
        //             };

        //             var responseViewModel = new ResponseViewModel<QuotationServiceResponse>
        //             {
        //                 data = responseData,
        //                 count = result.Table1.Count + result.Table2.Count +
        //                         result.Table3.Count + result.Table4.Count
        //             };

        //             return CommonFunctions.ProcessResult(responseViewModel);
        //         }
        //         catch (Exception ex)
        //         {
        //             return CommonFunctions.CreateErrorResponse(ex, "500", "Error retrieving quotation services");
        //         }
        //     }

        public async Task<ResponseModel> GetQuotationServiceWithCustom(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationService>(request.RequestText);
                logger.Debug("GetQuotationService method called");

                if (req == null)
                    return CommonFunctions.BlankResponse("201", "Invalid request parameters");

                var parameters = new
                {
                    @QuotationId = req.QuotationID,
                    @Action = req.Action,
                };

                // Get data from database
                var result = await SqlHelper.LoadDataWithMultiTablesAsync<GetGuideRateSearchResponseDto, GetMonumentRateSearchResponseDto,
                                TransportRateSearchResponseDto, GetSpecialServiceSearchResponseDto, HotelRateDetailsSearchResponseDto, dynamic>(
                    "[Quotations].[usp_GetRateCardSearchReportNew]",
                    parameters
                );






                // Step 1: Declare the response object
                var responseData = new QuotationServiceResponse();

                // Step 2: Bind each dataset separately

                //Guide

                responseData.Guides = new ServiceResult<GetGuideRateSearchResponseDto>
                {
                    Data = result.Table1,
                    returnCode = result.Table1.Any() ? "200" : "201",
                    returnMessage = result.Table1.Any() ? "Data found" : "Data Not Found"
                };


                var MonumentRes = new List<GetMonumentRateSearchResponseDto>();

                foreach (var row in result.Table2)
                {
                    var dto = new GetMonumentRateSearchResponseDto
                    {
                        QMID = row.QMID,
                        MonumentRateID = row.MonumentRateID,
                        MonumentDetailID = row.MonumentDetailID,
                        MonumentCommissionDetailID = row.MonumentCommissionDetailID,
                        CommissionMasterID = row.CommissionMasterID,
                        City = row.City,
                        VendorName = row.VendorName,
                        MonumentService = row.MonumentService,
                        Nationality = row.Nationality,
                        ValidFrom = row.ValidFrom,
                        ValidTo = row.ValidTo,
                        RateCardModeType = row.RateCardModeType,
                        RateCardModeTypeID = row.RateCardModeTypeID,
                        TaxID = row.TaxID,
                        CardNumber = row.CardNumber,
                        Heading = row.Heading,
                        ContractDate = row.ContractDate,
                        CurrencyID = row.CurrencyID,
                        StateID = row.StateID,
                        VendorID = row.VendorID,
                        InfoForOperation = row.InfoForOperation,
                        InfoForAgent = row.InfoForAgent,
                        InfoForRemark = row.InfoForRemark,
                        IsActive = row.IsActive,
                        CreatedOn = row.CreatedOn,
                        UpdatedOn = row.UpdatedOn,

                        CityID = row.CityID,

                        MonumentServiceID = row.MonumentServiceID,
                        NationalityID = row.NationalityID,
                        MISSequence = row.MISSequence,
                        Disclaimer = row.Disclaimer,
                        FromToDate = row.FromToDate,

                        MarkupRate = row.MarkupRate,
                        ReasonID = row.ReasonID,
                        QuotationID = row.QuotationID,
                        Type = row.Type,
                        QuoCurrency = row.QuoCurrency,
                        PurchaseRate = row.PurchaseRate,
                        IsSummary = row.IsSummary,


                        // Safely deserialize JSON string to list of commission details
                        Commissions = SafeDeserialize<List<MonumentRateCommissionDetailRequestDto>>(row.CommissionDetailsJson)
                    };

                    MonumentRes.Add(dto);
                }


                responseData.Monuments = new ServiceResult<GetMonumentRateSearchResponseDto>
                {
                    Data = MonumentRes,
                    returnCode = MonumentRes.Any() ? "200" : "201",
                    returnMessage = MonumentRes.Any() ? "Data found" : "Data Not Found"
                };

                //Transport

                var TransportRes = new List<TransportRateSearchResponseDto>();

                foreach (var row in result.Table3)
                {
                    var dto = new TransportRateSearchResponseDto
                    {
                        TransportRateID = row.TransportRateID,
                        RateCardModeType = row.RateCardModeType,
                        TransportModeType = row.TransportModeType,
                        TaxID = row.TaxID,
                        TransportServiceID = row.TransportServiceID,
                        HotelID = row.HotelID,
                        VendorID = row.VendorID,
                        HotelZone = row.HotelZone,
                        CityID = row.CityID,
                        //CityID2 = row.CityID2,
                        CurrencyID = row.CurrencyID,
                        StateID = row.StateID,
                        GstStatus = row.GstStatus,
                        VendorName = row.VendorName,
                        City = row.City,
                        TransportServiceName = row.TransportServiceName,
                        HotelZoneName = row.HotelZoneName,
                        VehicleCategoryID = row.VehicleCategoryID,
                        VehicleBaseID = row.VehicleBaseID,
                        ValidFrom = row.ValidFrom,
                        ValidTo = row.ValidTo,
                        MISSequence = row.MISSequence,
                        VehicleType = row.VehicleType,
                        VehicleName = row.VehicleName,
                        TransportService = row.TransportService,
                        //VehicleBaseType = row.VehicleBaseType,
                        //SellingRate = row.SellingRate,
                        Language = row.Language,
                        TransportRateDetailID = row.TransportRateDetailID,
                        Disclaimer = row.Disclaimer,



                        //GrossRate = row.GrossRate,

                        FromToDate = row.FromToDate,
                        QuotationID = row.QuotationID,
                        ReasonID = row.ReasonID,
                        RateCardModeTypeID = row.RateCardModeTypeID,
                        Type = row.Type,
                        TQTID = row.TQTID,
                        QuoCurrency = row.QuoCurrency,
                        PurchaseRate = row.PurchaseRate,
                        IsSummary = row.IsSummary,
                        // Safe JSON deserialization from string to list
                        Commissions = SafeDeserialize<List<TransportRateCommissionDetailResponseDto>>(row.TransportRateCommissionDetails),


                    };

                    TransportRes.Add(dto);
                }

                responseData.Transports = new ServiceResult<TransportRateSearchResponseDto>
                {
                    Data = TransportRes,
                    returnCode = TransportRes.Any() ? "200" : "201",
                    returnMessage = TransportRes.Any() ? "Data found" : "Data Not Found"
                };



                var SSResult = new List<GetSpecialServiceSearchResponseDto>();

                foreach (var row in result.Table4)
                {
                    var dto = new GetSpecialServiceSearchResponseDto
                    {
                        QSSMID = row.QSSMID,
                        SpecialServiceRateID = row.SpecialServiceRateID,
                        SpecialServiceRateDetailID = row.SpecialServiceRateDetailID,
                        SpecialServiceRateCommissionID = row.SpecialServiceRateCommissionID,
                        City = row.City,
                        VendorName = row.VendorName,
                        CityID = row.CityID,
                        Nationality = row.Nationality,
                        TransportService = row.TransportService,
                        TaxID = row.TaxID,
                        CommissionMasterID = row.CommissionMasterID,
                        ValidFrom = row.ValidFrom,
                        ValidTo = row.ValidTo,
                        PaxRange = row.PaxRange,
                        Currency = row.Currency,
                        Disclaimer = row.Disclaimer,
                        TaxPercentage = row.TaxPercentage,
                        TaxAmount = row.TaxAmount,

                        GrossRate = row.GrossRate,
                        InfoForOperation = row.InfoForOperation,
                        InfoForRemark = row.InfoForRemark,
                        NationalityID = row.NationalityID,
                        RateCardType = row.RateCardType,
                        CardNumber = row.CardNumber,
                        RateCardModeTypeID = row.RateCardModeTypeID,
                        SpecialServiceID = row.SpecialServiceID,
                        ContractDate = row.ContractDate,
                        CurrencyID = row.CurrencyID,
                        StateID = row.StateID,
                        VendorID = row.VendorID,
                        InfoForAgent = row.InfoForAgent,
                        IsActive = row.IsActive,

                        SpecialService = row.SpecialService,
                        Ratetype = row.Ratetype,
                        HotelID = row.HotelID,
                        MinimumPax = row.MinimumPax,
                        MaximumPax = row.MaximumPax,

                        FromToDate = row.FromToDate,
                        ReasonID = row.ReasonID,
                        QuotationID = row.QuotationID,
                        Type = row.Type,
                        QuoCurrency = row.QuoCurrency,
                        PurchaseRate = row.PurchaseRate,
                        IsSummary = row.IsSummary,

                        // Safely deserialize JSON string to list of commissions
                        Commissions = SafeDeserialize<List<GetSpecialServiceRateCommissionDetailResponseDto>>(row.SpecialServiceRateCommissionDetails)
                    };

                    SSResult.Add(dto);
                }


                responseData.SpecialServices = new ServiceResult<GetSpecialServiceSearchResponseDto>
                {
                    Data = SSResult,
                    returnCode = SSResult.Any() ? "200" : "201",
                    returnMessage = SSResult.Any() ? "Data found" : "Data Not Found"
                };

                //hOTEL

                var hotelRes = new List<HotelRateDetailsSearchResponseDto>();

                foreach (var row in result.Table5)
                {
                    var dto = new HotelRateDetailsSearchResponseDto
                    {
                        QuoHotelRateID = row.QuoHotelRateID,
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
                        DaysNumber = row.DaysNumber,
                        MealPlanCode = row.MealPlanCode,
                        Breakfast = row.Breakfast,
                        Lunch = row.Lunch,
                        Dinner = row.Dinner,
                        HasDocument = row.HasDocument,
                        HasRules = row.HasRules,
                        OfferTypeID = row.OfferTypeID,
                        FromToDate = row.FromToDate,
                        QuotationID = row.QuotationID,
                        CityName = row.CityName,
                        ShowTransfers = row.ShowTransfers,
                        ShowAnnouncement = row.ShowAnnouncement,
                        ShowValueAddOns = row.ShowValueAddOns,
                        ShowCancellationDays = row.ShowCancellationDays,
                        TransferValue = row.TransferValue,
                        ValueAddOn = row.ValueAddOn,
                        Type = row.Type,
                        Currency = row.Currency?.ToString(),
                        PurchaseRate = row.PurchaseRate != null ? Convert.ToDecimal(row.PurchaseRate) : 0,
                        Disclaimer = row.Disclaimer,
                        IsSummary = row.IsSummary,
                        IsSupplementaryPer = row.IsSupplementaryPer,
                        SupplementaryAmt = row.SupplementaryAmt,
                        RateCardModeTypeID = row.RateCardModeTypeID,

                        // Manual JSON deserialization
                        Commissions = SafeDeserialize<List<HotelRateCommissionDetailResponseDto>>(row.CommissionJSON),
                        Meals = SafeDeserialize<List<HotelRateMealResponseDto>>(row.MealOverviewJSON),
                        Offers = SafeDeserialize<List<HotelRateOfferConfigurationSearchDto>>(row.OfferConfigurationJSON),
                        HotelAnnouncement = SafeDeserialize<List<HotelAnnouncement>>(row.HotelAnnouncementsJSON),

                        CancellationPolicy = SafeDeserialize<List<HotelRateCancellationPolicy>>(row.CancellationPolicyJSON),
                    };

                    hotelRes.Add(dto);
                }


                responseData.Hotels = new ServiceResult<HotelRateDetailsSearchResponseDto>
                {
                    Data = hotelRes,
                    returnCode = hotelRes.Any() ? "200" : "201",
                    returnMessage = hotelRes.Any() ? "Data found" : "Data Not Found"
                };

                var responseViewModel = new ResponseViewModel<QuotationServiceResponse>
                {
                    data = responseData,
                    count = result.Table1.Count + result.Table2.Count +
                            result.Table3.Count + result.Table4.Count
                };

                return CommonFunctions.ProcessResult(responseViewModel);
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error retrieving quotation services");
            }
        }
        // Helper method to process CommissionJSON
        private void ProcessCommissions<T>(List<T> services) where T : QuotationService
        {
            foreach (var service in services)
            {
                try
                {
                    // The CommissionJSON is already being mapped to the Commissions property
                    // via the getter in the model classes
                }
                catch (Exception ex)
                {
                    logger.Error($"Error processing commissions for {typeof(T).Name}: {ex.Message}");
                }
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

        private void ProcessHotelCommissions(List<HotelService> hotels)
        {
            foreach (var hotel in hotels)
            {
                try
                {
                    // Processing happens automatically via the MealOverviews and Commissions property getters
                }
                catch (Exception ex)
                {
                    logger.Error($"Error processing hotel commissions: {ex.Message}");
                }
            }
        }
        public async Task<ResponseModel> DeleteRateCard(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationService>(request.RequestText);
                logger.Debug("DeleteRateCard method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @ID = req.ID,
                        @Action = req.Action,
                        @RateType = req.RateType,
                        @QuotationHotelRateCommissionId = req.QuotationHotelRateCommissionId
                    };

                    var data = new CommonClass.ResponseViewModel<QuotationService>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Quotation].[usp_DeleteRateCard]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }





        public async Task<ResponseModel> QuotationHotelcreate(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                var rootRequest = CommonFunctions.DecryptAndDeserializeRequest<QuotationHotelRateCardMaster>(request.RequestText);
                logger.Debug("QuotationHotelcreate method called");

                if (rootRequest?.DataList != null && rootRequest.DataList.Count > 0)
                {
                    foreach (var req in rootRequest.DataList)
                    {
                        req.Action = rootRequest.Action;

                        // Prepare commission table
                        DataTable commissionTable = new DataTable();
                        //commissionTable.Columns.Add("QuotationHotelRateCommissionId", typeof(int));
                        commissionTable.Columns.Add("CommissionMasterID", typeof(long));
                        commissionTable.Columns.Add("CommMstId", typeof(int));
                        commissionTable.Columns.Add("GrossRate", typeof(decimal));
                        commissionTable.Columns.Add("IsMarkup", typeof(bool));
                        commissionTable.Columns.Add("MarkupValue", typeof(decimal));
                        commissionTable.Columns.Add("SellingRate", typeof(decimal));
                        commissionTable.Columns.Add("ReasonMasterId", typeof(int));
                        commissionTable.Columns.Add("Disclaimer", typeof(string));
                        commissionTable.Columns.Add("OthersRateCardCommissionID", typeof(long));


                        DataTable mealTable = new DataTable();
                        //mealTable.Columns.Add("QuotationHotelRateMealId", typeof(long));
                        //mealTable.Columns.Add("MealTypeID", typeof(long));
                        mealTable.Columns.Add("OthersRateCardMealID", typeof(long));

                        mealTable.Columns.Add("MealTypeID", typeof(int));
                        mealTable.Columns.Add("SellingRate", typeof(decimal));
                        mealTable.Columns.Add("ReasonMasterId", typeof(int));
                        mealTable.Columns.Add("Disclaimer", typeof(string));
                        mealTable.Columns.Add("IsSupplementary", typeof(bool));
                        mealTable.Columns.Add("IsGross", typeof(bool));
                        mealTable.Columns.Add("IsSupplementaryPer", typeof(bool));
                        mealTable.Columns.Add("SupplementaryAmt", typeof(decimal));
                        mealTable.Columns.Add("GrossRate", typeof(decimal));

                        if (req.Commissions != null && req.Commissions.Count > 0)
                        {
                            foreach (var commission in req.Commissions)
                            {
                                commissionTable.Rows.Add(
                                    //commission.QuotationHotelRateCommissionId ?? 0,
                                    commission.CommissionMasterID,
                                    commission.CommMstId,
                                    commission.GrossRate ?? 0,
                                    commission.IsMarkup,
                                    commission.MarkupValue,
                                    commission.SellingRate,
                                    commission.ReasonMasterId,
                                    commission.Disclaimer,
                                    commission.OthersRateCardCommissionID
                                );
                            }
                        }


                        if (req.Meals != null && req.Meals.Count > 0)
                        {
                            foreach (var Meals in req.Meals)
                            {
                                mealTable.Rows.Add(
                                    //Meals.QuotationHotelRateMealId ?? 0,
                                    Meals.OthersRateCardMealID,
                                    Meals.MealTypeID,
                                    Meals.SellingRate,
                                    Meals.ReasonMasterId,
                                    Meals.Disclaimer,

                                    Meals.IsSupplementary,
                                    Meals.IsGross,
                                    Meals.IsSupplementaryPer,
                                    Meals.SupplementaryAmt,
                                    Meals.GrossRate
                                );
                            }
                        }

                        var parameters = new
                        {
                            Action = rootRequest.Action,
                            HotelRateID = req.HotelRateID,
                            HotelRateDetailID = req.HotelRateDetailID,
                            QuotationID = req.QuotationID,
                            Disclaimer = req.Disclaimer,
                            CheckIn = req.CheckIn,
                            CheckOut = req.CheckOut,
                            CreatedBy = req.CreatedBy,
                            QuoHotelRateID = req.QuoHotelRateID,
                            IsSummary = req.IsSummary,
                            CommissionList = commissionTable.AsTableValuedParameter("HotelCommissionTableType"),
                            MealList = mealTable.AsTableValuedParameter("HotelMealPlanTableType")
                        };

                        var data = new CommonClass.ResponseViewModel<QuotationHotelRateCardMaster>()
                        {
                            data = rootRequest
                        };
                        //return CommonFunctions.ProcessDBData(data, rootRequest.Action, "[Quotation].[usp_InsertHotelRateCardCommissionMeal]", parameters);

                        _resModel = CommonFunctions.ProcessDBData(data, rootRequest.Action, "[Quotation].[usp_InsertHotelRateCardCommissionMeal]", parameters);
                        _resModel.returnCode = data.returnCode;
                        _resModel.returnMessage = data.returnMessage;


                    }

                    return _resModel;
                }

                return new ResponseModel
                {
                    returnCode = "400",
                    returnMessage = "No data found in the request."
                };
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Monument Save Failed");
            }
        }
        #region Copy Quotation 
        public async Task<ResponseModel> CloneQuotation(RequestModel request)

        {

            ResponseModel _resModel = new ResponseModel();

            try

            {

                // Decrypt and deserialize the request

                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationMaster>(request.RequestText);

                logger.Debug("CopyQuotation method called");

                if (req != null)

                {

                    var parameters = new

                    {

                        @QuotationID = req.QuotationID,

                        @Action = req.Action

                    };

                    var data = new CommonClass.ResponseViewModel<QuotationMaster>();

                    return CommonFunctions.ProcessDBData(data, req.Action, "[Quotation].[InsertCloneVersionforQuotationID]", parameters);

                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

            }

            catch (Exception ex)

            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");

            }

        }

        #endregion Copy

        #region Display Quotation Disclaimer
        public async Task<ResponseModel> DisplayQuotationDisclaimer(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationMaster>(request.RequestText);
                logger.Debug("DisplayQuotationDisclaimer method called");

                if (req != null)
                {
                    var parameters = new
                    {
                        @QuotationRateCardId = req.QuotationRateCardId,
                        @RateType = req.RateType,
                        @QuotationID = req.QuotationID,
                    };

                    var data = new CommonClass.ResponseViewModel<QuotationMaster>();
                    return CommonFunctions.ProcessDBData(data, "S", "[Quotation].[usp_DisplayDisclaimer]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion

        public async Task<ResponseModel> QuotationStatus(RequestModel request)
        {

            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationStatus>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        req.Action,
                    };
                    var data = new CommonClass.ResponseViewModel<QuotationStatus>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "[Quotation].[usp_GetQuotationStatus]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Quotation Not Found");
            }
        }


        public async Task<ResponseModel> QuotationDraft(RequestModel request)
        {

            ResponseModel _resModel = new ResponseModel();

            try

            {

                // Decrypt and deserialize the request

                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationDrafts>(request.RequestText);
                string CollectionName = request.MasterFlag;
                logger.Debug("CopyQuotation method called");

                if (req != null)
                {

                    var parameters = new

                    {

                        @ID = req.QuotationID,
                        @JsonText = req.JsonText,
                        @Action = req.Action,
                        @QuotationDraft = req.QuotationDraft,
                        @OperationBy = req.OperationBy,
                        @LogId = req.LogId

                    };

                    var data = new CommonClass.ResponseViewModel<QuotationDrafts>()
                    {
                        data = req
                    };

                    if (req.Action == "I")
                    {
                        var quotationIdProp = data.data?.GetType().GetProperty("QuotationID");

                        if (quotationIdProp != null)
                        {
                            var quotationIdValue = quotationIdProp.GetValue(data.data);
                            if (quotationIdValue != null)
                            {
                                data.data.ID = Convert.ToInt64(quotationIdValue); // or cast based on your type
                            }
                        }
                        return CommonFunctions.ProcessMongoDBData(data, req.Action, "usp_QuotationDraft", parameters);
                    }
                    if (req.Action == "S")
                    {
                        data.collectionName = CollectionName;
                        //return CommonFunctions.ViewLogs(data, req);

                        MongoHelper mongo = new MongoHelper();


                        var dynamicList = mongo.GetLogsAsync<QuotationDrafts>(CollectionName, parameters)
                            .GetAwaiter()
                            .GetResult();

                        List<QuotationDrafts> typedList = new List<QuotationDrafts>();

                        foreach (var item in dynamicList)
                        {
                            QuotationDrafts typedItem = JsonConvert.DeserializeObject<QuotationDrafts>(JsonConvert.SerializeObject(item));
                            typedList.Add(typedItem);
                        }

                        data.dataList = typedList;

                        return new ResponseModel
                        {
                            returnCode = typedList.Count > 0 ? "200" : "201",
                            returnMessage = typedList.Count > 0 ? "Data Found" : "Data Not Found",
                            DataObj = typedList
                        };
                    }


                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

            }

            catch (Exception ex)

            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");

            }

        }

        #region GetQuotationVersion 
        public async Task<ResponseModel> GetQuotationVersion(RequestModel request)

        {

            ResponseModel _resModel = new ResponseModel();

            try

            {

                // Decrypt and deserialize the request

                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationVersion>(request.RequestText);

                logger.Debug("GetQuotationVersion method called");

                if (req != null)

                {

                    var parameters = new

                    {

                        @QuotationID = req.QuotationID,

                        @Action = req.Action

                    };

                    var data = new CommonClass.ResponseViewModel<QuotationVersion>();

                    return CommonFunctions.ProcessDBData(data, req.Action, "[Quotation].[GetQuoVersion]", parameters);

                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

            }

            catch (Exception ex)

            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong.");

            }

        }



        public async Task<ResponseModel> GetCustomRateCardByIdAndType(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<CustomRateCard>(request.RequestText);
                logger.Debug("GetCustomRateCardByIdAndType method called");

                if (req != null)
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@CustomRateCardId", req.CustomRateCardId);
                    parameters.Add("@RateCardModeTypeId", req.RateCardModeTypeId);
                    parameters.Add("@TaxID", req.TaxID);
                    parameters.Add("@ValidFrom", req.ValidFrom);
                    parameters.Add("@CurrencyCode", req.CurrencyCode);
                    parameters.Add("@CheckIn", req.CheckIn);

                    // Execute the stored procedure
                    var result = await SqlHelper.QueryAsync<dynamic, DynamicParameters>(
                        "[RateCards].[usp_GetCustomRateCardByIdAndType]",
                        parameters
                    );

                    if (result == null || !result.Any())
                        return CommonFunctions.BlankResponse("201", "Data Not Found");

                    var row = result.First();
                    var customRateCard = new CustomRateCard();

                    // Map common properties
                    customRateCard.CustomRateCardId = row.HotelRateID ?? row.CustomRateCardId;
                    customRateCard.Type = row.Type?.ToString();
                    customRateCard.IsActive = row.IsActive as bool?;
                    customRateCard.CreatedOn = row.CreatedOn as DateTime?;
                    customRateCard.UpdatedOn = row.UpdatedOn as DateTime?;
                    customRateCard.CurrencyCode = row.CurrencyCode?.ToString() ?? row.Currency?.ToString() ?? row.CurrencyID?.ToString();
                    customRateCard.CityID = row.CityID?.ToString();
                    customRateCard.City = row.City?.ToString();
                    customRateCard.VendorID = row.VendorID as long?;
                    customRateCard.VendorName = row.VendorName?.ToString();
                    customRateCard.ValidFrom = row.ValidFrom?.ToString();
                    customRateCard.ValidTo = row.ValidTo?.ToString();
                    customRateCard.TaxID = row.TaxID as int?;
                    customRateCard.TaxPercentage = row.TaxPercentage as decimal?;
                    customRateCard.TaxAmount = row.TaxAmount as decimal?;
                    customRateCard.CheckIn = req.CheckIn;
                    customRateCard.ServiceType = row.ServiceType?.ToString();


                    // After the existing mappings, add these:

                    // Guide specific fields (Type 1)
                    customRateCard.GuideRateID = row.GuideRateID as long?;
                    customRateCard.GuideRateDetailID = row.GuideRateDetailID as int?;
                    customRateCard.GuideRateCommissionID = row.GuideRateCommissionID as long?;
                    customRateCard.GuideServiceID = row.GuideServiceID as int?;
                    customRateCard.GuideService = row.GuideService?.ToString();
                    customRateCard.CardNumber = row.CardNumber?.ToString();
                    customRateCard.Heading = row.Heading?.ToString();
                    customRateCard.ContractDate = row.ContractDate?.ToString();
                    customRateCard.LanguageID = row.LanguageID?.ToString();
                    customRateCard.Language = row.Language?.ToString();
                    customRateCard.PaxRange = row.PaxRange?.ToString();
                    customRateCard.PaxMinimum = row.PaxMinimum as int?;
                    customRateCard.PaxMaximum = row.PaxMaximum as int?;
                    customRateCard.MISSequence = row.MISSequence as int?;
                    customRateCard.RateCardType = row.RateCardType?.ToString();
                    customRateCard.RateCardModeTypeID = row.RateCardModeTypeID as int?;
                    customRateCard.HasRules = row.HasRules as bool?;
                    customRateCard.HasDocument = row.HasDocument as bool?;
                    customRateCard.GrossRate = row.GrossRate?.ToString();
                    customRateCard.SellingRate = row.SellingRate?.ToString();
                    customRateCard.NetAmountIncludingTax = row.NetAmountIncludingTax as decimal?;
                    customRateCard.NetAmountExcludingTax = row.NetAmountExcludingTax as decimal?;

                    customRateCard.NetAmountIncludingTax_Con = row.NetAmountIncludingTax_Con as decimal?;
                    customRateCard.NetAmountExcludingTax_Con = row.NetAmountExcludingTax_Con as decimal?;

                    customRateCard.InfoForOperation = row.InfoForOperation?.ToString();
                    customRateCard.InfoForAgent = row.InfoForAgent?.ToString();
                    customRateCard.InfoForRemark = row.InfoForRemark?.ToString();
                    customRateCard.Notes = row.Notes?.ToString();
                    customRateCard.StateID = row.StateID as int?;

                    // Monument specific fields (Type 2)

                    customRateCard.MonumentRateID = row.MonumentRateID as long?;
                    customRateCard.MonumentDetailID = row.MonumentDetailID as int?;
                    customRateCard.MonumentCommissionDetailID = row.MonumentCommissionDetailID as int?;
                    customRateCard.MonumentService = row.MonumentService?.ToString();
                    customRateCard.Nationality = row.Nationality?.ToString();
                    customRateCard.NationalityId = row.NationalityId as int?;
                    customRateCard.RateCardModeType = row.RateCardModeType?.ToString();
                    customRateCard.GSTStatus = row.GSTStatus?.ToString();
                    customRateCard.MonumentServiceID = row.MonumentServiceID as int?;
                    customRateCard.CommissionMasterID = row.CommissionMasterID as int?;
                    customRateCard.GrossRateAdult = row.GrossRateAdult?.ToString();
                    customRateCard.GrossRateChild = row.GrossRateChild?.ToString();
                    customRateCard.ClosedOn = row.ClosedOn?.ToString();
                    customRateCard.RateType = row.RateType?.ToString();

                    // Transport specific fields (Type 3)
                    customRateCard.TransportRateDetailID = row.TransportRateDetailID as int?;
                    customRateCard.TransportRateID = row.TransportRateID as long?;
                    customRateCard.TransportService = row.TransportService?.ToString();
                    customRateCard.TransportServiceID = row.TransportServiceID as int?;
                    customRateCard.VehicleType = row.VehicleType?.ToString();

                    // Special Service specific fields (Type 4)
                    customRateCard.SpecialServiceRateID = row.SpecialServiceRateID as long?;
                    customRateCard.SpecialServiceRateDetailID = row.SpecialServiceRateDetailID as int?;
                    customRateCard.SpecialServiceRateCommissionID = row.SpecialServiceRateCommissionID as int?;
                    customRateCard.SpecialService = row.SpecialService?.ToString();
                    customRateCard.SpecialServiceID = row.SpecialServiceID as int?;

                    // Hotel specific fields (Type 5)
                    customRateCard.HotelRateID = row.HotelRateID;
                    customRateCard.HotelID = row.HotelID as int?;
                    customRateCard.HotelName = row.HotelName?.ToString();
                    customRateCard.HotelPreferred = row.HotelPreferred as bool?;
                    customRateCard.HotelRateDetailID = row.HotelRateDetailID as int?;
                    customRateCard.RoomCategoryID = row.RoomCategoryID as int?;
                    customRateCard.RoomCategory = row.RoomCategory?.ToString();
                    customRateCard.Days = row.Days?.ToString();
                    customRateCard.DaysOfWeek = row.DaysOfWeek?.ToString();
                    customRateCard.MealPlanCode = row.MealPlanCode?.ToString();
                    customRateCard.Breakfast = row.Breakfast as bool?;
                    customRateCard.Lunch = row.Lunch as bool?;
                    customRateCard.Dinner = row.Dinner as bool?;
                    customRateCard.TransferID = row.TransferID as int?;
                    customRateCard.TransferValue = row.TransferValue?.ToString();
                    customRateCard.OfferTypeID = row.OfferTypeID as int?;
                    customRateCard.PurchaseRate = row.PurchaseRate as decimal?;
                    customRateCard.OfferConfigurationJSON = row.OfferConfigurationJSON?.ToString();
                    customRateCard.HotelAnnouncementsJSON = row.HotelAnnouncementsJSON?.ToString();
                    customRateCard.ContactDetailsJSON = row.ContactDetailsJSON?.ToString();
                    customRateCard.RulesJSON = row.RulesJSON?.ToString();
                    customRateCard.MarketJSON = row.MarketJSON?.ToString();
                    customRateCard.RateSheetJSON = row.RateSheetJSON?.ToString();


                    if (row.MonumentRateCommissionDetails != null)
                    {
                        customRateCard.MonumentRateCommissionDetails = row.MonumentRateCommissionDetails.ToString();
                        customRateCard.MonumentCommissions = SafeDeserializeCR<List<MonumentRateCommissionDetailSearch>>(
                            customRateCard.MonumentRateCommissionDetails
                        );
                    }


                    if (row.SpecialRateCommissionDetails != null)
                    {
                        customRateCard.SpecialRateCommissionDetails = row.SpecialRateCommissionDetails.ToString();
                        customRateCard.SpecialCommissions = SafeDeserializeCR<List<SpecialServiceRateCommissionDetailSearch>>(
                            customRateCard.SpecialRateCommissionDetails
                        );
                    }

                    // Handle JSON fields with proper deserialization
                    if (row.TransportRateCommissionDetails != null)
                    {
                        customRateCard.TransportRateCommissionDetails = row.TransportRateCommissionDetails.ToString();
                        customRateCard.TransportCommissions = SafeDeserializeCR<List<TransportServiceRateCommissionDetailSearchCR>>(
                            customRateCard.TransportRateCommissionDetails
                        );
                    }

                    if (row.CommissionJSON != null)
                    {
                        customRateCard.HotelCommissionJSON = row.CommissionJSON.ToString();
                        //customRateCard.CommissionDetails = SafeDeserializeCR<List<CommissionDetail>>(
                        //    customRateCard.HotelCommissionJSON
                        //);
                        customRateCard.CommissionDetails = SafeDeserializeCR<List<HotelRateCommissionSearch>>(
                            customRateCard.HotelCommissionJSON
                        );
                    }

                    if (row.MealOverviewJSON != null)
                    {
                        customRateCard.MealOverviewJSON = row.MealOverviewJSON.ToString();
                        customRateCard.MealDetails = SafeDeserializeCR<List<MealOverview>>(
                            customRateCard.MealOverviewJSON
                        );
                    }
                    // Create response
                    var responseData = new CommonClass.ResponseViewModel<CustomRateCard>
                    {
                        //data = customRateCard,
                        dataList = new List<CustomRateCard> { customRateCard },
                        returnCode = "200",
                        returnMessage = "Data Found"
                    };


                    return CommonFunctions.ProcessResult(responseData);
                }
                return CommonFunctions.BlankResponse("201", "Invalid request");
            }
            catch (Exception ex)
            {
                logger.Error($"Error in GetCustomRateCardByIdAndType: {ex.Message}", ex);
                return CommonFunctions.CreateErrorResponse(ex, "500", "Failed to get rate card");
            }
        }

        private static T SafeDeserializeCR<T>(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
                return default;

            try
            {
                // Remove extra escaping from SQL JSON
                if (json.StartsWith("\"") && json.EndsWith("\""))
                {
                    json = json.Substring(1, json.Length - 2);
                    json = json.Replace("\\\"", "\"");
                }

                return JsonConvert.DeserializeObject<T>(json);
            }
            catch (JsonException)
            {
                return default;
            }
        }
        // Helper method to clean JSON strings from SQL
        private string CleanJsonString(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
                return json;

            // Remove extra escaping that comes from SQL FOR JSON
            if (json.StartsWith("\"") && json.EndsWith("\""))
            {
                json = json.Substring(1, json.Length - 2);
                json = json.Replace("\\\"", "\"");
            }

            return json;
        }

        // Improved JSON deserialization helper
        private T DeserializeJson<T>(object jsonValue) where T : new()
        {
            try
            {
                if (jsonValue == null || jsonValue == DBNull.Value)
                    return new T();

                string jsonString = jsonValue.ToString();

                // Handle double-escaped JSON (common when coming from SQL FOR JSON)
                if (jsonString.StartsWith("\"") && jsonString.EndsWith("\""))
                {
                    jsonString = jsonString.Substring(1, jsonString.Length - 2)
                                         .Replace("\\\"", "\"");
                }

                return JsonConvert.DeserializeObject<T>(jsonString) ?? new T();
            }
            catch (Exception ex)
            {
                logger.Error($"Error deserializing JSON: {ex.Message}");
                return new T();
            }
        }

        #endregion 
    }
}