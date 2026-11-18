using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.ComponentModel;
using System.Numerics;

namespace CommonClass
{
    public class ResponseViewModel<T> : StatusModel
    {
        [JsonProperty("token")]
        public string token { get; set; }
        public string collectionName { get; set; }
        public T data { get; set; }
        public List<T> dataList { get; set; }
        public BigInteger count { get; set; }


    }

    public class ResponseMultipleViewModel
    {
        public List<object> ResultSets { get; set; } = new List<object>();
        public int Count { get; set; }
    }

    public class StatusModel
    {
        public string returnCode { get; set; }
        public string returnMessage { get; set; }
        public long? ID { get; set; }
        public string Data { get; set; }
        public string token { get; set; }
        public string EmpCode { get; set; }

        public string XONumber { get; set; }

        public string HotelSAPCode { get; set; }
        public DateTime? LastSavedOn { get; set; }

        public string AgentCode { get; set; }
        public string CustomerCode { get; set; }
    }

    public class ResponseModel
    {
        public ResponseModel()
        {
        }

        public ResponseModel(object RefreshTokenData)
        {
            this.RefreshTokenData = RefreshTokenData;
        }

        public string responseText { get; set; }

        public string Data { get; set; }
        public string returnCode { get; set; }
        public string returnMessage { get; set; }
        public object RefreshTokenData { get; }
        public object MultiTable { get; set; }
        public int RowCount { get; set; }
        public object DataObj { get; set; }
        public string? Error { get; set; }
        public object responseData { get; set; }
        public DateTime? LastSavedOn { get; set; }
        public object FileContent { get; set; }
    }
    public class FileResponseViewModel<T> : StatusModel
    {
        public byte[] data { get; set; }

    }
    public class FileResponseModel
    {
        public byte[] responseText { get; set; } = null;
    }

    public class ApiLog
    {
        public string Id { get; set; } = Guid.NewGuid().ToString();
        public string? Source { get; set; }
        public string? MethodName { get; set; }
        public string? Request { get; set; }
        public string? Response { get; set; }
        public string? RequestTime { get; set; }
        public string? ResponseTime { get; set; }
        public string? Methodtype { get; set; }
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }

    public class ErrorLog
    {
        public string Id { get; set; } = Guid.NewGuid().ToString();
        public string? ErrorScource { get; set; }
        public string? ErrorModule { get; set; }
        public string? ErrorMessage { get; set; }
        public string? ErrorNumber { get; set; }
        public string? ErrorState { get; set; }
        public string? ErrorSeverity { get; set; }
        public string? ErrorLine { get; set; }
        public string? ErrorRequest { get; set; }
        public string? ErrorDescription { get; set; }
        public string? RequestTime { get; set; }
        public string? ResponseTime { get; set; }
        public DateTime ErrorDateTime { get; set; } = DateTime.UtcNow;
    }

    public class ThirdPartyLog
    {
        public string Id { get; set; } = Guid.NewGuid().ToString();
        public string? Request { get; set; }
        public string? RequestTime { get; set; }
        public string? Response { get; set; }
        public string? ResponseTime { get; set; }
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }
    public class RequestModel
    {
        public string RequestText { get; set; }
        public string MasterFlag { get; set; }
    }
    public class UploadDocumentsFormFileEncrypted
    {
        [FromForm]
        public IFormFile Documents { get; set; }

        [FromForm]
        public string EncryptedData { get; set; }
    }
    public class UploadDocuments
    {
        public int? DocumentLinkID { get; set; }
        public string Action { get; set; } // 'I' = Insert, 'U' = Update, 'S' = Select
        public int ParentID { get; set; }
        public int? DocumentID { get; set; }
        public string DocumentIDs { get; set; }
        public string DocumentName { get; set; }
        public string DocMimeType { get; set; }
        public string Documents { get; set; }
        public int UploadedBy { get; set; }

        public DateTime? UploadedOn { get; set; }
        public int ParentTypeID { get; set; }
        public string EmpName { get; set; }
        public string UserName { get; set; }
        public int DocumentTypeId { get; set; }
        public string DocumentType { get; set; }
        public Guid? OperationBy { get; set; }




    }

    public class DocumentTypeMaster
    {
        public int? DocumentTypeId { get; set; }
        public string DocumentType { get; set; }
        public bool IsActive { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime? UpdatedOn { get; set; }
        public string Action { get; set; } // 'I' = Insert, 'U' = Update, 'S' = Select
        public Guid? OperationBy { get; set; }
    }

    public class DocumentTypeMasterExport
    {
        public int? DocumentTypeId { get; set; }
        public string DocumentType { get; set; }
        public bool IsActive { get; set; }

    }
    public class SearchAgentMasterUploadDocuments : UploadDocuments
    {
        public string AgentCode { get; set; }
        public int? AgentID { get; set; }
        public string AgentName { get; set; }



    }

    public class SearchHotelMasterUploadDocuments : UploadDocuments
    {
        public string HotelCode { get; set; }
        public int? HotelID { get; set; }
        public string HotelName { get; set; }



    }

    public class SearchVendorMasterUploadDocuments : UploadDocuments
    {
        public string VendorCode { get; set; }
        public int? VendorID { get; set; }
        public string VendorName { get; set; }



    }
    public class CustomerMasterUploadDocuments : UploadDocuments
    {
        public string CustomerCode { get; set; }
        public int? CustomerID { get; set; }
        public string CustomerName { get; set; }



    }

    public class UploadImage
    {
        public int ID { get; set; }
        public string Action { get; set; } // 'I' = Insert, 'U' = Update, 'S' = Select
        public int ParentID { get; set; }
        public int ParentPageType { get; set; }
        public string ImageName { get; set; }
        public string Image { get; set; }
    }


    public class SearchAgentMasterUploadImage : UploadImage
    {
        public string AgentCode { get; set; }
        public int? AgentID { get; set; }
    }

    public class EmailConfigurations : UploadDocuments
    {
        public int EmailTemplateId { get; set; }
        public int EmailCategory { get; set; }
        public string FromEmailAddress { get; set; }
        public string ToEmailAddress { get; set; }
        public string Subject { get; set; }
        public string EmailBody { get; set; }
        public int OperationBy { get; set; }
        public string Action { get; set; }
        public int? DocumentID { get; set; }
        public DateTime OperationOn { get; set; }
        public string Operation { get; set; }
        public string EmailCategoryText { get; set; }
        public string DocumentName { get; set; }
        public string CCEmailAddress { get; set; }

    }

    public class SmtpSettings
    {
        public string? recipientEmail;

        public string Host { get; set; }
        public int Port { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string SenderEmail { get; set; }
        public string SenderName { get; set; }
        public string RecipientEmail { get; set; }
        public string RegFromMail { get; set; }
    }


    public class EmployeeMasterAllData
    {
        public int EmpID { get; set; }
        public string EmpCode { get; set; } = null;
        public Guid? UserID { get; set; }
        public int? RoleId { get; set; } = 0;
        public int SalutationID { get; set; }
        public string Gender { get; set; }
        public string EmpName { get; set; }
        public string Address { get; set; }
        public string CityIATACode { get; set; }
        public string ResPhoneNo { get; set; }
        public string MobileNo { get; set; }
        public string PersonalEmail { get; set; }
        public int CompanyID { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public DateTime? DateOfRetirement { get; set; }
        public int DesignationID { get; set; }
        public int DepartmentID { get; set; }
        public int ReportHeadID { get; set; }
        public string OffEmail { get; set; }
        public string OffPhone { get; set; }
        public string Pan { get; set; }
        public bool IsActive { get; set; }
        public Guid? OperationBy { get; set; }
        public int? LevelID { get; set; } = 0;
        public bool IsSales { get; set; } = false;
        public string Action { get; set; }
    }


    public class EmployeeMasterRequest
    {
        public string RequestText = "{\"EmpID\":0,\"EmpCode\":\"\",\"UserID\":\"\",\"RoleId\":0,\"SalutationID\":0,\"Gender\":\"\",\"EmpName\":\"\",\"Address\":\"\",\"CityIATACode\":\"\",\"ResPhoneNo\":\"\",\"MobileNo\":\"\",\"PersonalEmail\":\"\",\"CompanyID\":3,\"DateOfBirth\":\"\",\"DateOfJoining\":\"\",\"DateOfRetirement\":\"\",\"DesignationID\":4,\"DepartmentID\":2,\"ReportHeadID\":6,\"OffEmail\":\"\",\"OffPhone\":\"\",\"Pan\":\"\",\"IsActive\":true,\"OperationBy\":\"\",\"LevelID\":3,\"IsSales\":false,\"Action\":\"S\"}";
        public string MasterFlag { get; set; }
    }



    public enum DatabaseObjects
    {
        //level 1 masters

        [Description("CountryMaster")]
        usp_Country_Master,

        [Description("StateMaster")]
        usp_State_Master,

        [Description("CityMaster")]
        usp_City_Master,

        [Description("MarketMaster")]
        usp_Market_Master,

        [Description("CountryMarketMapping")]
        usp_CountryMarketMapping_Master,

        [Description("ClassTypeMaster")]
        usp_ClassType_Master,


        [Description("ModeOfTravelMaster")]
        usp_MOT_Master,

        [Description("TransportServiceMaster")]
        usp_TransportServices_Master,

        [Description("GuideServiceMaster")]
        usp_GuideServices_Master,

        [Description("SpecialServiceMaster")]
        usp_SpecialServices_Master,

        [Description("MonumentMaster")]
        usp_MonumentServices_Master,

        [Description("HotelRatingMaster")]
        usp_HotelRating_Master,

        [Description("RoomCategoryMaster")]
        usp_RoomCategory_Master,

        [Description("MealPlanMaster")]
        usp_MealPlan_Master,

        [Description("HotelRateTypeMaster")]
        usp_Rate_Type_Master,

        [Description("RuleGroupMaster")]
        usp_RuleGroups_Master,

        [Description("RuleHeadersMaster")]
        usp_Rules_Master,

        [Description("DepartmentMaster")]
        usp_Department_Master,

        [Description("DesignationMaster")]
        usp_Designation_Master,

        [Description("VehicleTypeMaster")]
        usp_VehicleTypeMaster,

        [Description("GuideInfoMaster")]
        usp_GuideInfoMaster,

        [Description("LanguageMaster")]
        usp_Language_Master,

        [Description("NationalityMaster")]
        usp_Nationality_Master,

        [Description("FacilityInformationMaster")]
        usp_FacilityInformation_Master,

        [Description("LocationMaster")]
        usp_Location_Master,

        [Description("ZoneMaster")]
        usp_Zone_Master,

        [Description("HeaderMaster")]
        usp_Header_Master,

        [Description("LandMarksMaster")]
        usp_LandMarks_Master,

        [Description("TransferMaster")]
        usp_Transfer_Master,

        [Description("AgentGroupMaster")]
        usp_Agent_Group,

        [Description("HotelPreferredMaster")]
        usp_HotelPreferred_Master,

        [Description("XORemarks")]
        usp_XORemarks_Master,

        [Description("AgentMarkupMaster")]
        usp_ManageAgentMarkup,

        [Description("SalutationMaster")]
        usp_Salutation_master,

        [Description("YearMaster")]
        usp_ManageYearMaster,

        [Description("CurrencyMaster")]
        usp_Currency_Master,

        [Description("CurrencyConversionMaster")]
        usp_CurrencyConversionMaster,

        [Description("OtherTaxesMaster")]
        usp_UpdateOtherTaxes_M,

        [Description("SACMaster")]
        USP_ManageSAC,

        [Description("ServiceTaxNewMaster")]
        usp_ServiceTaxNew,

        [Description("OtherServiceTaxNewMaster")]
        usp_ManageOtherServiceTaxNew,

        [Description("BankMaster")]
        usp_BankMasterDtls_BankMaster,

        [Description("BusinessTypeMaster")]
        usp_ManageBusinessMaster,

        [Description("BankAccountsMaster")]
        usp_Accounts_BankMaster,

        [Description("HotelTypeMaster")]
        usp_ManageHotelTypeMaster,

        [Description("BizPartnerGroupMaster")]
        usp_HotelGroup_Master,

        [Description("BankMasterdetail")]
        usp_GetBankMaster,

        [Description("AgentCategoryMaster")]
        sp_GetAgentCategoryByID,

        [Description("MSMEType")]
        sp_GetMSMETypeMaster,

        [Description("VendorPreferred")]
        usp_VendorPreferred,

        [Description("SelectFiscalVariant")]
        SelectFiscalVariant,

        [Description("GetAgentCategoryMaster")]
        usp_GetAgentCategoryMaster,

        [Description("New_CurrencyMaster")]
        sp_ManageCurrencyMaster,

        [Description("New_CurrencyConversion")]
        usp_InsertUpdate_CurrencyCon,

        [Description("Destination_Master")]
        usp_DestinationMaster,

        //level 2 masters
        [Description("AgentMaster")]
        usp_AgentMaster,

        [Description("PreviousCodeTagging")]
        usp_GetPreviousCodentAgent,

        [Description("AgentContactDetailsTab")]
        USP_InsertUpdateContactLoginDetailsNew,

        [Description("AgentSAPCompCode")]
        USP_InsertUpdateSAPCompCode,

        [Description("VendorContactDetailsTab")]
        usp_InsertContactDetails,

        [Description("SupplyTypeMaster")]
        usp_SupplyTypeMaster,

        [Description("LockDateMaster")]
        usp_LockDateSettings,

        [Description("StateCodeMaster")]
        usp_StateCode_Master,

        [Description("TCSRateMaster")]
        usp_TCSRateMaster,

        [Description("AgentClassificationMaster")]
        usp_Agent_Classification_Master,

        [Description("VendorMaster")]
        usp_VendorMaster,

        [Description("VendorServicesMaster")]
        usp_Vendor_Services_Master,

        [Description("ServiceLocationMaster")]
        usp_ServiceLocation_Master,

        [Description("InvoiceDescriptionMaster")]
        usp_InvoiceDescription_Master,

        [Description("LegalTypeMaster")]
        usp_LegalEntityType_Master,

        [Description("TaxPercentage")]
        usp_GST_Percentage,

        [Description("QuotationServiceTypeMaster")]
        usp_QuotationServiceType_Master,


        [Description("TcsLogicNewMaster")]
        usp_TCSLogicNew_Master,

        //[Description("LegalEntityTypeMaster")]
        //      usp_LegalEntityType_Master,

        [Description("AirlineCodeMaster")]
        usp_AirlineCodemaster,

        [Description("LUTMasterData")]
        USP_LUTMasterData,

        [Description("AirlineServiceTypeMaster")]
        usp_AirlineServiceTypemaster,

        [Description("AirportMaster")]
        usp_AirportMaster,

        [Description("GstItcRateMaster")]
        usp_GstItcRateMaster,

        //[Description("HOTELCODE")]
        //usp_Hotel_Master,


        [Description("HotelMaster")]
        usp_Hotel_Master,

        [Description("HotelRoomCategoryTab")]
        usp_InsertHotelRoomCategory,
        [Description("HotelContactDetailsTab")]
        usp_ContactDetails_Tab_Master,

        [Description("HotelRuleTab")]
        usp_InsertUpdateHotelRule,

        /*  [Description("HotelSAPCompCode")]
                  USP_InsertUpdateSAPCompCode,*/

        [Description("HotelAnnouncement")]
        usp_HotelAnnouncement,

        [Description("CompanyMaster")]
        usp_CompanyMaster,

        [Description("EmployeeMaster")]
        usp_Employee_Master, USP_UnlockUser,

        [Description("GSTPercentageMaster")]
        usp_InsertGST_Percentage,

        [Description("WithholdingTaxMaster")]
        usp_WithholdingTax_Master,

        [Description("PlaceOfSupplyLogic")]
        usp_PlaceOfSupplyLogicMaster,

        [Description("GSTTypeMaster")]
        GSTTypeMaster_proc,

        [Description("TCSRateConfig")]
        usp_TCSRateConfig,

        [Description("ItineraryInclusionsExclusions")]
        USP_ItineraryInclusionsExclusions,

        [Description("EntityMasterModel")]
        usp_EntityMaster,

        [Description("EmployeeTarget")]
        usp_EmployeeTargetNew,

        [Description("GSTstatusMaster")]
        usp_GstStatus,

        [Description("ItineraryDescription")]
        USP_ItineraryDescriptionMaster,
        /*
                    [Description("EntityMaster")]
                    usp_EntityMaster,*/

        [Description("AgentBranchMapping")]
        USP_InsertUpdateAgentBranchMapping,

        [Description("OtherServiceTax")]
        usp_OtherServiceTax_M,

        [Description("Withholding_Tax")]
        usp_GetWithholdingTax,

        [Description("SapCompCode")]
        USP_GETSAPCompCode,

        [Description("SearchAgentLinkedDocuments")]
        usp_SearchAgentMasterUploadDocuments,

        [Description("ItineraryDescDetails")]
        USP_ItineraryDescDetails,

        [Description("InsertUpdateSAPJobsTime")]
        usp_InsertUpdateSAPJobsTime,

        [Description("EnquiryModel")]
        usp_Enquiry,

        [Description("CustomerMaster")]
        usp_CustomerMaster,

        [Description("PackageCodeMaster")]
        USP_InsertPackageCodeMaster,
        [Description("EmailConfigurations")]
        USP_UpdateEmailConfiguration,

        [Description("Enquiryfollowup")]
        usp_FollowUp,
        [Description("UploadDocuments")]
        usp_UploadDocument,

        [Description("refresh")]
        usp_ManageRefreshToken,

        [Description("Lost_Enquiry")]
        usp_Lost_Enquiry,

        [Description("LinkOtherDocument")]
        usp_InsertUpdateLinkedDocuments,
        [Description("ModuleMaster")]
        usp_Modules_Master,

        [Description("PLBMaster")]
        usp_PLBMaster,

        [Description("File2FileMapping")]
        usp_File2FileMapping,

        [Description("UpdateLockUnlockQuotationModel")]
        USP_UpdateDataForLockUnlockQuotation,

        [Description("ReportDownloads")]
        USP_GetReportDownloads,

        [Description("SearchHotelLinkedDocuments")]
        usp_SearchHotelMasterUploadDocuments,

        [Description("UploadImage")]
        usp_GetImages,

        [Description("GREXOViewModel")]
        GetGREXOView,

        [Description("XoData")]
        usp_XO_Data,

        [Description("RoleMaster")]
        usp_Roles_Master,



        [Description("ConfigSettings")]
        usp_ConfigSettingsMaster,

        [Description("ChangeUserPassword")]
        usp_ChangeUser_Password,

        [Description("ExportCPPReports")]
        USP_GetCPPReportData_ACCOM_NEW,

        [Description("HotelInfo")]
        usp_GetSearchHotelInfo,

        [Description("Get_LostReason")]
        GetLostReason,

        [Description("SearchPrintWithTax")]
        USP_GetInvoiceReportNewHorizontalOne,

        [Description("VendorInfo")]
        usp_SearchVendorInfo,

        [Description("SearchManage_Contact")]
        usp_ManageSearchContactDetails,

        [Description("ratecard")]
        CreateOrUpdate_HotelRateCard,

        [Description("RateCardDetail")]
        CreateOrUpdate_HotelRateDetail,

        [Description("GuideRateCard")]
        CreateOrUpdate_GuideRateCard,

        [Description("GuideRateDetail")]
        CreateOrUpdate_GuideRateDetail,

        [Description("MonumentRateCard")]
        CreateOrUpdate_MonumentRateCard,

        [Description("MonumentRateDetail")]
        CreateOrUpdate_MonumentRateDetail,

        [Description("MOTRateCard")]
        CreateOrUpdate_MOTRateMaster,

        [Description("MOTRateDetail")]
        CreateOrUpdate_MOTRateDetail,

        [Description("SpecialServiceRateCard")]
        CreateOrUpdate_SpecialServiceRateCard,

        [Description("SpecialServiceRateDetail")]
        CreateOrUpdate_SpecialServiceRateDetail,

        [Description("TransportRateCard")]
        CreateOrUpdate_TransportRateCard,

        [Description("TransportRateDetail")]
        CreateOrUpdate_TransportRateDetail,

        [Description("ratecard-rule")]
        Usp_CreateOrUpdateRules,


        [Description("QuotationMaster")]
        usp_InsertUpdateQuotation,

        [Description("Update_Quotation")]
        usp_UpdateQuotation,

        [Description("RateCardCancellationPolicy")]
        Usp_CreateOrUpdate_RateCardCancellationPolicy,

        [Description("Quotationguidecreate")]
        InsertUpdateGuideRateMasterCommissionDetails,

        [Description("QuotationMonumentcreate")]
        InsertUpdateMonumentRateMasterCommissionDetails,

        [Description("QuotationTransportcreate")]
        InsertUpdateTransportRateMasterCommissionDetails,

        [Description("QuotationSpecialServicecreate")]
        InsertUpdateSpecialRateMasterCommissionDetails,


        [Description("SearchHotelCity")]
        usp_fetchHotelCity,

        [Description("OthersRateCardCommission")]
        Insert_OthersRateCardCommission,

        //[Description("GetQuotationService")]
        //usp_getQuotationService

        [Description("DeleteRateCard")]
        usp_DeleteRateCard,

        [Description("QuotationHotelcreate")]
        usp_InsertHotelRateCardCommissionMeal,

        [Description("CloneQuotation")]
        InsertCloneVersionforQuotationID,

        [Description("DisplayQuotationDisclaimer")]
        usp_DisplayDisclaimer,


        [Description("QuotationStatus")]
        usp_GetQuotationStatus,

        [Description("QuotationDraft")]
        usp_QuotationDraft,

        //[Description("BookingMaster")]
        [Description("Update_Booking_PrimaryInfo")]

        usp_InsertUpdateBooking_PrimaryInfo,

        [Description("Booking_GuidDayWiseService")]

        usp_GuidDayWiseService,

        [Description("Booking_HotelDayWiseService")]
        usp_HotelDayWiseService,
        [Description("Booking_MonumentDayWiseService")]
        usp_MonumentDayWiseService,
        [Description("Booking_MOTDayWiseService")]
        usp_MOTDayWiseService,
        [Description("Booking_SpecialServiceDayWiseService")]
        usp_SpecialServiceDayWiseService,
        [Description("Booking_TrasportDayWiseService")]
        usp_TransportDayWiseService,

        [Description("UpdateBookingService")]
        UpdateBookingCommissionDetails,

        [Description("ConvertQuotationToBooking")]
        ConvertQuotationToBooking,

        [Description("ConvertCommissionRateTonegotiateRate")]
        ConvertCommissionRateTonegotiateRate,

        [Description("SaveQuotation")]
        usp_SaveQuotation,
        [Description("HotelOfferRateCard")]
        CreateOrUpdate_HotelOffer,

        [Description("InsertXOModel")]
        USP_InsertXO,

        [Description("GetXo")]
        Get_XO_Data,

        [Description("UpdateDayWiseBooking")]
        UpdateDayWiseBooking,

        [Description("DayWiseDataAsync")]
        InsertDayWiseData,

        [Description("UpdateUndoXOModel")]
        Usp_UpdateUndoXO,

        [Description("AdvancePaySendRequestModel")]
        usp_InsertAdvancePaySendRequest,

        [Description("AutoCompleteSearch")]
        usp_AutoCompleteSearch,

        [Description("InvoiceMaster")]
        usp_InsertUpdateInvoice_PrimaryInfo,
        usp_ConvertPerfomaToInvoice,
        USP_InsertBTCCommisionInvoice,

        [Description("InvoiceDetails")]
        usp_InsertUpdateInvoiceDetails,
        [Description("AgentRefVoid")]
        usp_InsertUpdateAgentRefNumberandVoid,

        [Description("XOInstructionModel")]
        USP_InsertOrUpdate_XOInstructions,


        [Description("Addendum")]
        usp_InsertUpdateAddendumWithDetails,
        usp_InsertUpdateAddendum,

        [Description("UpdateBookingFHE")]
        usp_UpdateBookingFHE,


        [Description("AddSubBooking")]
        usp_AddSubBooking,

        [Description("AddCopyBooking")]
        usp_AddCopyBooking,

        [Description("GetDashboardStayTransport")]
        usp_GetDashboardStayTransport,


        [Description("GetDashAgentInvoice")]
        usp_GetDashAgentInvoice,

        [Description("GetDashCommInvoice")]
        usp_GetDashCommInvoice,

        [Description("GetDashPerformaNotConverted")]
        usp_GetDashPerformaNotConverted,

        [Description("DocumentTypeMaster")]
        usp_DocumentType,

        [Description("SendUnlockRequestMail")]
        Get_XO_Unlock_Data,

        [Description("MIS_AgentRoomNight_New")]
        MIS_AgentRoomNight_New

    }
}