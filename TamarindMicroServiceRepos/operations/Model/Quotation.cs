using Dapper;
using Newtonsoft.Json;
using NPOI.HPSF;
using System.Data;

//using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;

namespace TamarindAstra_Operations.Model
{
    public class Quotations
    {
        public long? QuotationID { get; set; }
        public string QuotationNo { get; set; }

    }
    public class QuotationMaster : Quotations
    {
        public string JsonText { get; set; }
        public long? EQID { get; set; } // Optional for insert
        public string EnquiryID { get; set; }
        public int Currency { get; set; }
        public bool TaxType { get; set; }

        public string TaxTypeName { get; set; }

        public int? TaxonSale { get; set; }
        public int? ParentID { get; set; }
        public string Disclaimer { get; set; }
        public long? BookingID { get; set; }
        public Guid? CreatedBy { get; set; }
        public Guid? UpdatedBy { get; set; }
        public long? AgentID { get; set; }
        public string AgentStaffName { get; set; }

        public string Action { get; set; } // 'I' or 'U'

        public int YearID { get; set; }
        public string Status { get; set; }
        public int? CustomerID { get; set; }
        public string StatusName { get; set; }

        public string AgentName { get; set; }

        public string CurrencyCode { get; set; }
        // Output parameters (optional to include in input model)

        public long? OutQuotationID { get; set; }

        public int? CompanyID { get; set; }
        public int? CurrencyID { get; set; }

        public DateTime? QuotationToDate { get; set; }

        public DateTime? QuotationFromDate { get; set; }

        public string RateCardMode { get; set; }

        public int PageNumber { get; set; }
        public int? PageSize { get; set; }
        public int? TotalCount { get; set; } // To store the

        public DateTime? QuotationDate { get; set; }

        public decimal? GSTPercentage { get; set; }

        public string? ColourCode { get; set; }
        public string? FileCode { get; set; }
        public string? CustomerName { get; set; }
        public string? GuestName { get; set; }
        public string? XONumber { get; set; }
        public string? InvoiceNo { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public string? QuoteStatus { get; set; }
        public int? QuotationRateCardId { get; set; }
        public int? RateType { get; set; }
        public string VersionSequence { get; set; }
        public string BookingNo { get; set; }
        public string EnquiryNo { get; set; }
        public string FHEName { get; set; }
        public Guid? FHE { get; set; }
        public bool? isArrivalDate { get; set; }
        public int IsSysGenEnquiry { get; set; }
        public Guid? OperationBy { get; set; }
        public string QuotationSequence { get; set; }
        public string BookingSequence { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

    }

    public class SaveQuotationFlag
    {
        public long? QuotationID { get; set; }
        public int? Status { get; set; }
        public Guid? CreatedBy { get; set; }
        public List<RateCardFlagModel> RateCards { get; set; }
        public List<GuideRateCardFlagModel> GuideRateCards { get; set; }
    }

    public class GuideRateCardFlagModel
    {
        public int? QuotationRateCardId { get; set; }

        public bool? ShowValueAddOns { get; set; }

    }

    public class RateCardFlagModel
    {
        public int? QuotationRateCardId { get; set; }
        public bool? ShowAnnouncement { get; set; }
        public bool? ShowTransfers { get; set; }
        public bool? ShowValueAddOns { get; set; }
        public bool? ShowCancellationDays { get; set; }
        public List<QuotationMasterVersionSequenceDetail> VersionSequence { get; set; }
    }


    public class QuotationStatus
    {
        public int StatusID { get; set; }
        public string StatusName { get; set; }
        public int StatusCode { get; set; }
        public string Action { get; set; }
        public string ColourCode { get; set; }

    }

    public class QuotationMasterVersionSequenceDetail
    {
        public int ParentID { get; set; }
        public int ChildID { get; set; }
        public string QuotationNo { get; set; }
        public int QuotationSequence { get; set; }
        public int Status { get; set; }
        public string StatusName { get; set; }

    }


    //public class QuotationMasterVersionSequenceDetailHandler : SqlMapper.TypeHandler<List<QuotationMasterVersionSequenceDetail>>
    //{
    //    public override void SetValue(IDbDataParameter parameter, List<QuotationMasterVersionSequenceDetail> value)
    //    {
    //        parameter.Value = JsonConvert.SerializeObject(value);
    //    }

    //    public override List<QuotationMasterVersionSequenceDetail> Parse(object value)
    //    {
    //        return value == DBNull.Value ? null : JsonConvert.DeserializeObject<List<QuotationMasterVersionSequenceDetail>>((string)value);
    //    }
    //}


    // This class is used to deserialize the List.
    public class JsonTypeHandler<T> : SqlMapper.TypeHandler<T>
    {
        public override void SetValue(IDbDataParameter parameter, T value)
            => parameter.Value = JsonConvert.SerializeObject(value);

        public override T Parse(object value)
            => JsonConvert.DeserializeObject<T>(value.ToString());
    }

    public class QuotationDrafts
    {
        public long ID { get; set; }
        public string JsonText { get; set; }

        public Guid OperationBy { get; set; }
        public long? QuotationID { get; set; }

        public long LogId { get; set; }

        public string Action { get; set; } // 'I' or 'U'

        public bool QuotationDraft { get; set; }

    }

    public class QuotationVersion
    {
        public long? QuotationID { get; set; }
        public string Action { get; set; }
        public string QuotationNo { get; set; }

        public int? QuotationSequence { get; set; }

        public int Status { get; set; }
        public string StatusName { get; set; }


    }


    public class ServiceResult<T>
    {
        public List<T> Data { get; set; } = new List<T>();
        public string returnCode { get; set; }
        public string returnMessage { get; set; }
    }


    public class QuotationServiceResponse
    {
        public ServiceResult<GetGuideRateSearchResponseDto> Guides { get; set; }
        public ServiceResult<GetMonumentRateSearchResponseDto> Monuments { get; set; }
        public ServiceResult<GetSpecialServiceSearchResponseDto> SpecialServices { get; set; }
        public ServiceResult<TransportRateSearchResponseDto> Transports { get; set; }
        public ServiceResult<HotelRateDetailsSearchResponseDto> Hotels { get; set; }
    }
    public class CommissionDetail
    {
        public int OthersRateCardCommissionId { get; set; }
        public int CommissionMasterID { get; set; }
        public string RateType { get; set; }
        public string PaxRange { get; set; }
        public string SellingRate { get; set; }
        //public string AdultSellingRate { get; set; }
        //public string ChildSellingRate { get; set; }
        //public string ConsolidatedSellingRate { get; set; }
        public decimal? ExtHr { get; set; }
        public decimal? ExtKm { get; set; }

        public long? RateCommissionID { get; set; }
        public decimal? TaxPercentage { get; set; }
    }
    public class QuotationService : Quotations
    {
        public int ID { get; set; }
        public int ReferenceRateDetailID { get; set; }
        public int CommissionRefrenceID { get; set; }

        [JsonIgnore]
        public string CommissionJSON { get; set; }
        public string Action { get; set; }
        public int RateType { get; set; }
        public int QuotationID { get; set; }
        public int QuotationHotelRateCommissionId { get; set; }
        public string QuotationNo { get; set; }

        public string RateCardType { get; set; }

        public string Disclaimer { get; set; }

    }

    public class HotelService : QuotationService
    {
        public string CityID { get; set; }
        public string CityName { get; set; }
        public string FromToDate { get; set; }
        public DateTime CheckIn { get; set; }
        public DateTime CheckOut { get; set; }
        public string RoomCategory { get; set; }
        public string DaysOfWeek { get; set; }
        [JsonIgnore]
        public string MealOverviewJSON { get; set; }
        public string ServiceType => "Hotel";

        public List<MealOverview> MealOverviews =>
            !string.IsNullOrEmpty(MealOverviewJSON) ?
            JsonConvert.DeserializeObject<List<MealOverview>>(MealOverviewJSON) :
            new List<MealOverview>();

        public List<HotelCommissionDetail> Commissions =>
            !string.IsNullOrEmpty(CommissionJSON) ?
            JsonConvert.DeserializeObject<List<HotelCommissionDetail>>(CommissionJSON) :
            new List<HotelCommissionDetail>();
    }

    public class MealOverview
    {
        public int HotelRateMealID { get; set; }
        public int? HotelRateDetailID { get; set; }
        public int MealTypeID { get; set; }
        public string MealType { get; set; }
        public decimal? GstPercentage { get; set; }
        public decimal? GstAmount { get; set; }
        public decimal? NetAmountIncludingTax_Org { get; set; }
        public decimal? NetAmountIncludingTax { get; set; }
        public decimal? NetAmountExcludingTax_Org { get; set; }
        public decimal? NetAmountExcludingTax { get; set; }
        public decimal? NetAmountIncludingTax_Con { get; set; }
        public decimal? NetAmountExcludingTax_Con { get; set; }
        public int? MasterCommissionID { get; set; }
        public bool? IsMealDetails { get; set; }
        public bool? DefineAmount { get; set; }
        public int? QuotationHotelRateID { get; set; }
        public decimal? SellingRate { get; set; }
        public int? ReasonMasterId { get; set; }
    }

    public class HotelCommissionDetail
    {
        public int QuotationHotelRateCommId { get; set; }
        public int? RateCommisionID { get; set; }
        public int? QuotationHotelRateID { get; set; }
        public int CommissionMasterID { get; set; }
        public string RateType { get; set; }
        public decimal? TaxPercentage { get; set; }
        public decimal? TaxAmount { get; set; }
        public decimal? GrossAmountIncludingTax_Org { get; set; }
        public decimal? GrossAmountIncludingTax { get; set; }
        public decimal? GrossAmountExcludingTax_Org { get; set; }
        public decimal? GrossAmountExcludingTax { get; set; }
        public decimal? CommisionPercentage { get; set; }
        public bool? IsActive { get; set; }
        public decimal? GrossRate { get; set; }
        public bool? IsMarkup { get; set; }
        public decimal? MarkupValue { get; set; }
        public decimal? SellingRate { get; set; }
        public int? ReasonMasterId { get; set; }
    }
    public class GuideServices : QuotationService
    {
        public string CityID { get; set; }
        public string CityName { get; set; }
        public string FromToDate { get; set; }
        public string ServiceName { get; set; }
        public string LanguageID { get; set; }
        public string Language { get; set; }
        public string PaxRange { get; set; }
        public string SellingRate { get; set; }

        public string ServiceType { get; set; }

        public string GuideService { get; set; }

        public List<CommissionDetail> Commissions =>
        !string.IsNullOrEmpty(CommissionJSON) ?
        JsonConvert.DeserializeObject<List<CommissionDetail>>(CommissionJSON) :
        new List<CommissionDetail>();
    }

    public class MonumentService : QuotationService
    {
        public string CityID { get; set; }
        public string CityName { get; set; }
        public string FromToDate { get; set; }
        public string ServiceName { get; set; }

        public string PaxRange { get; set; }

        //public string AdultSellingRate { get; set; }
        //public string ChildSellingRate { get; set; }

        public string SellingRate { get; set; }
        public string ServiceType { get; set; }
        public int NationalityId { get; set; }
        public string Nationality { get; set; }

        public List<CommissionDetail> Commissions =>
        !string.IsNullOrEmpty(CommissionJSON) ?
        JsonConvert.DeserializeObject<List<CommissionDetail>>(CommissionJSON) :
        new List<CommissionDetail>();

    }
    public class SpecialServiceRateCard : QuotationService
    {
        public string CityID { get; set; }
        public string CityName { get; set; }
        public string FromToDate { get; set; }
        public string ServiceName { get; set; }

        public string PaxRange { get; set; }

        //public string AdultSellingRate { get; set; }
        //public string ChildSellingRate { get; set; }
        //public string ConsolidatedSellingRate { get; set; }
        public string SellingRate { get; set; }

        public string ServiceType { get; set; }
        public int NationalityId { get; set; }
        public string Nationality { get; set; }

        public List<CommissionDetail> Commissions =>
        !string.IsNullOrEmpty(CommissionJSON) ?
        JsonConvert.DeserializeObject<List<CommissionDetail>>(CommissionJSON) :
        new List<CommissionDetail>();
    }
    public class TransportService : QuotationService
    {
        public string CityID { get; set; }
        public string CityName { get; set; }
        public string FromToDate { get; set; }
        public string ServiceName { get; set; }

        public string PaxRange { get; set; }

        public string SellingRate { get; set; }
        public string VehicleType { get; set; }
        public decimal ExtHr { get; set; }
        public decimal ExtKm { get; set; }

        public int VehicleId { get; set; }
        public string ServiceType { get; set; }

        public List<CommissionDetail> Commissions =>
        !string.IsNullOrEmpty(CommissionJSON) ?
        JsonConvert.DeserializeObject<List<CommissionDetail>>(CommissionJSON) :
        new List<CommissionDetail>();

    }

    public class QuotationHotelRateCardMaster
    {
        public long QuoHotelRateID { get; set; }
        public bool? IsSummary { get; set; }
        public string Action { get; set; }
        public long? HotelRateID { get; set; }
        public int? HotelRateDetailID { get; set; }
        public long? QuotationID { get; set; }
        public string Disclaimer { get; set; }
        public Guid? CreatedBy { get; set; }


        public int HotelID { get; set; }
        public string CardNumber { get; set; }
        public DateTime ContractDate { get; set; }
        public string Days { get; set; }
        public int RoomCategoryID { get; set; }
        public int MealPlanID { get; set; }
        public int CurrencyID { get; set; }
        public string CurrencyName { get; set; }
        public string InfoForRemark { get; set; }
        public int StateID { get; set; }
        public bool GstStatus { get; set; }
        public string CityID { get; set; }
        public string Heading { get; set; }
        public string InfoForAgent { get; set; }
        public string InfoForOperation { get; set; }
        public int PaymentTypeID { get; set; }
        public int RateCardModeTypeID { get; set; }
        public int RateTypeID { get; set; }
        public string ValueAddOn { get; set; }

        public DateTime? CheckIn { get; set; }
        public DateTime? CheckOut { get; set; }

        public bool IsActive { get; set; }

        public decimal? SupplementaryAmt { get; set; }
        public bool? IsSupplementaryPer { get; set; }
        public List<QuotationHotelRateCardMaster> DataList { get; set; }
        public List<QuotationHotelRateCommissionDetails> Commissions { get; set; }
        public List<QuotationHotelRateMealPlanMaster> Meals { get; set; }

    }
    public class QuotationHotelRateCommissionDetails
    {

        public long OthersRateCardCommissionID { get; set; }
        public int? QuotationHotelRateCommissionId { get; set; }
        public int QuotationHotelRateID { get; set; }
        public int? CommissionMasterID { get; set; }
        public int? CommMstId { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal CommisionPercentage { get; set; }
        public bool IsMarkup { get; set; }
        public decimal MarkupValue { get; set; }
        public decimal SellingRate { get; set; }
        public int ReasonMasterId { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime UpdatedOn { get; set; }
        public bool IsActive { get; set; }
        public Guid UpdatedBy { get; set; }
        public Guid CreatedBy { get; set; }
        public decimal? GrossRate { get; set; }
        public string? Disclaimer { get; set; }
    }


    public class QuotationHotelRateMealPlanMaster
    {

        public long OthersRateCardMealID { get; set; }
        public long? QuotationHotelRateMealId { get; set; }
        public long HotelRateMealID { get; set; }
        public long HotelRateDetailID { get; set; }
        public int MealTypeID { get; set; }
        public decimal GstPercentage { get; set; }
        public decimal SellingRate { get; set; }
        public int ReasonMasterId { get; set; }
        public decimal GstAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime UpdatedOn { get; set; }
        public int MasterCommissionID { get; set; }
        public Guid UpdatedBy { get; set; }
        public Guid CreatedBy { get; set; }
        public bool IsMealDetails { get; set; }
        public bool DefineAmount { get; set; }
        public int QuotationHotelRateID { get; set; }
        public string? Disclaimer { get; set; }
        public bool? IsSupplementary { get; set; }
        public bool? IsGross { get; set; }
        public decimal? SupplementaryAmt {  get; set; } 
        public bool? IsSupplementaryPer {  get; set; }
        public decimal? GrossRate { get; set; }
    }



    public class CustomRateCard
    {
        // Common fields for all types
        public long? CustomRateCardId { get; set; } // HotelRateID in all types
        public string? Type { get; set; } // Always 'CustomRateCard'

        public int? RateCardModeTypeId { get; set; }// 1=Guide, 2=Monument, 3=Transport, 4=Special Service, 5=Hotel
        public bool? IsActive { get; set; }
        public DateTime? CreatedOn { get; set; }
        public DateTime? UpdatedOn { get; set; }
        public string? CurrencyCode { get; set; } // Currency or CurrencyID
        public string? CityID { get; set; }
        public string? City { get; set; }
        public long? VendorID { get; set; }
        public string? VendorName { get; set; }
        public string? ValidFrom { get; set; }
        public string? ValidTo { get; set; }
        public int? TaxID { get; set; }
        public decimal? TaxPercentage { get; set; }
        public decimal? TaxAmount { get; set; }
        public string? DisplayRate { get; set; } // Could be GrossRate, SellingRate, etc.
        public DateTime? CheckIn { get; set; } // Parameter, not from result set

        // Type 1 (Guide) specific fields
        public long? GuideRateID { get; set; }
        public int? GuideRateDetailID { get; set; }
        public long? GuideRateCommissionID { get; set; }
        public int? GuideServiceID { get; set; }
        public string? GuideService { get; set; }
        public string? CardNumber { get; set; }
        public string? Heading { get; set; }
        public string? ContractDate { get; set; }
        public string? LanguageID { get; set; }
        public string? Language { get; set; }
        public string? PaxRange { get; set; }
        public int? PaxMinimum { get; set; }
        public int? PaxMaximum { get; set; }
        public int? MISSequence { get; set; }
        public string? RateCardType { get; set; }
        public int? RateCardModeTypeID { get; set; }
        public bool? HasRules { get; set; }
        public bool? HasDocument { get; set; }
        public string? GrossRate { get; set; }
        public string? SellingRate { get; set; }
        public decimal? NetAmountIncludingTax { get; set; }
        public decimal? NetAmountExcludingTax { get; set; }
        public decimal? NetAmountExcludingTax_Con { get; set; }
        public decimal? NetAmountIncludingTax_Con { get; set; }
        public string? InfoForOperation { get; set; }
        public string? InfoForAgent { get; set; }
        public string? InfoForRemark { get; set; }
        public string? Notes { get; set; }
        public int? StateID { get; set; }

        // Type 2 (Monument) specific fields

        //public int? MonumentRateID { get; set; }
        public long? MonumentRateID { get; set; }
        public int? MonumentDetailID { get; set; }
        public int? MonumentCommissionDetailID { get; set; }
        public string? MonumentService { get; set; }
        public string? Nationality { get; set; }
        public int? NationalityId { get; set; }
        public string? RateCardModeType { get; set; }
        public string? GSTStatus { get; set; }
        public int? MonumentServiceID { get; set; }
        public int? CommissionMasterID { get; set; }
        public string? GrossRateAdult { get; set; }
        public string? GrossRateChild { get; set; }
        public string? ClosedOn { get; set; }
        public string? RateType { get; set; }
        public string? MonumentRateCommissionDetails { get; set; }
        public List<MonumentRateCommissionDetailSearch> MonumentCommissions { get; set; }


        // Type 3 (Transport) specific fields
        public int? TransportRateDetailID { get; set; }
        public long? TransportRateID { get; set; }
        public string? TransportService { get; set; }
        public int? TransportServiceID { get; set; }
        public string? VehicleType { get; set; }
        public string? TransportRateCommissionDetails { get; set; }
        public List<TransportServiceRateCommissionDetailSearchCR> TransportCommissions { get; set; }

        // Type 4 (Special Service) specific fields
        public long? SpecialServiceRateID { get; set; }
        public int? SpecialServiceRateDetailID { get; set; }
        public int? SpecialServiceRateCommissionID { get; set; }
        public string? SpecialService { get; set; }
        public int? SpecialServiceID { get; set; }
        public string? SpecialRateCommissionDetails { get; set; }
        public List<SpecialServiceRateCommissionDetailSearch> SpecialCommissions { get; set; }

        // Type 5 (Hotel) specific fields
        public long? HotelRateID { get; set; }
        public int? HotelID { get; set; }
        public string? HotelName { get; set; }
        public bool? HotelPreferred { get; set; }
        public int? HotelRateDetailID { get; set; }
        public int? RoomCategoryID { get; set; }
        public string? RoomCategory { get; set; }
        public string? Days { get; set; }
        public string? DaysOfWeek { get; set; }
        public string? MealPlanCode { get; set; }
        public bool? Breakfast { get; set; }
        public bool? Lunch { get; set; }
        public bool? Dinner { get; set; }
        public int? TransferID { get; set; }
        public string? TransferValue { get; set; }
        public int? OfferTypeID { get; set; }
        public decimal? PurchaseRate { get; set; }
        public string? HotelCommissionJSON { get; set; } // JSON
        //public List<CommissionDetail> CommissionDetails { get; set; }
        public List<HotelRateCommissionSearch> CommissionDetails { get; set; }
        public string? MealOverviewJSON { get; set; } // JSON
        public List<MealOverview> MealDetails { get; set; }

        public string? OfferConfigurationJSON { get; set; } // JSON
        public string? HotelAnnouncementsJSON { get; set; } // JSON
        public string? ContactDetailsJSON { get; set; } // JSON
        public string? RulesJSON { get; set; } // JSON
        public string? MarketJSON { get; set; } // JSON
        public string? RateSheetJSON { get; set; } // JSON

        public string? ServiceType { get; set; }
    }
    public class HotelRateCommissionSearch : RateCardBase
    {
        public long RateCommissionID { get; set; }
        public int MasterCommissionID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal GrossAmountIncludingTax_Con { get; set; }
        public decimal GrossAmountExcludingTax_Con { get; set; }
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
        public decimal CommissionPercentage { get; set; }
        public decimal CommissionAmount { get; set; }
        public decimal CommissionAmount_Con { get; set; }
        public long HotelRateDetailID { get; set; }
        public bool IsTax { get; set; }
        public string RateType { get; set; }
    }

    public class SpecialServiceRateCommissionDetailSearch : GetSpecialServiceRateCommissionDetailResponseDto
    {
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
    }
    public class MonumentRateCommissionDetailSearch : MonumentRateCommissionDetailRequestDto
    {
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
    }
    public class TransportServiceRateCommissionDetailSearchCR : TransportRateCommissionDetailResponseDtoCR
    {
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
    }

    public class TransportRateCommissionDetailResponseDtoCR
    {
        public int? TransportCommissionDetailID { get; set; }
        public int? CommissionMasterID { get; set; }
        public string RateType { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public string CommissionType { get; set; }
    }

    public class CommissionDetailCR
    {
        public int? RateCommissionID { get; set; }
        public int? CommissionMasterID { get; set; }
        public string RateType { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal CommissionAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public bool IsTax { get; set; }
        public bool IsActive { get; set; }
    }

    public class MealOverviewCR
    {
        public int? HotelRateMealID { get; set; }
        public int? HotelRateDetailID { get; set; }
        public string MealType { get; set; }
        public decimal GstPercentage { get; set; }
        public decimal GstAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public int? MasterCommissionID { get; set; }
        public bool IsMealDetails { get; set; }
        public bool DefineAmount { get; set; }
    }

}
