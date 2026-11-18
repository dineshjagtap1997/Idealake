using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;
using System.ComponentModel.DataAnnotations;


namespace TamarindAstra_Operations.Model
{
    public class Booking
    {
        public long BookingID { get; set; }
        public long? QuotationID { get; set; }
        public string QuotationNo { get; set; }
        public string BookingNo { get; set; }

    }
    public class BookingMaster : Booking
    {
        [Key]
        public int ID { get; set; }
        public string JsonText { get; set; }
        public long? EQID { get; set; } // Optional for insert
        public string EnquiryID { get; set; }
        public string Currency { get; set; }
        public bool TaxType { get; set; }
        public string FileCode { get; set; }
        public string GuestName { get; set; }
        public string XONumber { get; set; }
        public string InvoiceNumber { get; set; }
        public string FHEName { get; set; }


        public string TaxTypeName { get; set; }

        public int? TaxonSale { get; set; }
        public int? ParentID { get; set; }
        public string Disclaimer { get; set; }
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

        public long? OutBookingID { get; set; }

        public int? CompanyID { get; set; }
        public int? CurrencyID { get; set; }

        public DateTime? BookingToDate { get; set; }

        public DateTime? BookingFromDate { get; set; }

        public string RateCardMode { get; set; }

        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
        public int? TotalCount { get; set; } // To store the

        public DateTime? BookingDate { get; set; }

        public decimal? GSTPercentage { get; set; }

        public string ColourCode { get; set; }
        //public string? FHE { get; set; }
        public Guid? FHE { get; set; }


        public string BookingID { get; set; }
        public string PaxName { get; set; }
        public string MobileNO { get; set; }
        public string PaxEmailID { get; set; }
        public int Numberofpax { get; set; }
        public string BizVirticale { get; set; }
        public string? DepartmentID { get; set; }
        public DateTime? BookingCreationDate { get; set; }
        public bool? PrePone { get; set; }
        public DateTime? PrePoneDate { get; set; }
        public bool? AgentInvoiceReq { get; set; }
        public string Reason { get; set; }
        public string PacageCode { get; set; }
        public string PrmSrvcLoc { get; set; }
        public string Origin { get; set; }
        public string OnlineBookingID { get; set; }
        public bool? FIT { get; set; }
        public bool? SupplierTax_B2b { get; set; }
        public bool? SupplierTax_InCluding { get; set; }
        public bool? MarkupType_Gross { get; set; }
        public string? MarketID { get; set; }
        public string CityIATACode { get; set; }
        public string BillingAddress { get; set; }
        public string PANNo { get; set; }
        public string GSTNo { get; set; }
        public string TANNo { get; set; }
        public string SEZ { get; set; }
        public bool? FreeZone { get; set; }
        public bool? AgentOnCredit { get; set; }
        public decimal? CreditAmount { get; set; }
        public decimal? OutStandingAmount { get; set; }
        public int? DBL { get; set; }
        public int? EBA { get; set; }
        public int? EBC { get; set; }
        public int? CNB { get; set; }
        public int? SGL { get; set; }
        public int? Twin { get; set; }
        public int? TaxID { get; set; }
        public string UserNote1 { get; set; }
        public string UserNote2 { get; set; }
        public DateTime? CreatedOn { get; set; }
        public Guid? ModifiedBy { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public DateTime? LastSaved { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int? taxID { get; set; }
        public string? City { get; set; }
        public int? Service { get; set; }
        public int? Vehical { get; set; }
        public int? Vendor { get; set; }
        public int? Count { get; set; }
        public int? Adult { get; set; }
        public int? Child { get; set; }
        public long? Consolidated { get; set; }
        public int? Nationality { get; set; }
        public int? Cost { get; set; }
        public string? Type { get; set; }
        public bool? Lock { get; set; }


        public string? OperationBy { get; set; }
        public int? CountOfVehicles { get; set; }
        public int? CountOfGuide { get; set; }
        public int? CountOfChild { get; set; }
        public int? CountOfAdults { get; set; }
        public DateTime? DayWiseDate { get; set; }
        public string? ServiceName { get; set; }
        public string? HotelName { get; set; }
        public string? RoomCategory { get; set; }
        public string? RateType { get; set; }
        public string? MealPlan { get; set; }

        public string? Breakfast { get; set; }
        public string? Lunch { get; set; }
        public string? Dinner { get; set; }
        public string? TransportServive { get; set; }
        public string? VehicleType { get; set; }
        public int? CountOfVehicle { get; set; }
        public string? GuideService { get; set; }
        public string? SpecialSerivice { get; set; }
        public string? VendorInfo { get; set; }
        public string? NationalityInfo { get; set; }
        public decimal? GrossRate { get; set; }


        public int? TamSalesrep { get; set; }
        public string PrmSrvcLocName { get; set; }
        public string EnquiryNo { get; set; }
        public string QuotationNo { get; set; }
        public Guid? ReassignTo { get; set; }
        public String? TaxOnSales { get; set; }
        public string VersionSequence { get; set; }
        public int? IsSysGenEnquiry { get; set; }

        public int BookingSequence { get; set; }
        public bool IsInvoiceGen { get; set; }
        public string AgentCityIATACode { get; set; }
        public List<NegoDocJson> strNegoDoc { get; set; }
        public List<CreditNote> CreditNoteJson { get; set; }
        public decimal? Revenue {  get; set; }
        public decimal? Expense { get; set; }
    }
    public class NegoDocJson
    {
        public int? DocumentID { get; set; }
        public string DocumentName { get; set; }
        public string DocMimeType { get; set; }
        public string Documents { get; set; }
        public string DocumentType { get; set; }
    }
    public class CreditNote
    {
        public string CreditNoteNo { get; set; }
        public string CreditNoteDate { get; set; }
        public string Currency { get; set; }
        public string Amount { get; set; }
    }
    public class BookingStatus
    {
        public int StatusID { get; set; }
        public string StatusName { get; set; }
        public int StatusCode { get; set; }
        public string Action { get; set; }
        public string ColourCode { get; set; }

    }
    public class BookingServiceResult<T>
    {
        public List<T> Data { get; set; } = new List<T>();
        public string returnCode { get; set; }
        public string returnMessage { get; set; }
    }


    public class BookingServiceResponse
    {
        public BookingServiceResult<GetGuideRateSearchResponseDto> Guides { get; set; }
        public BookingServiceResult<GetMonumentRateSearchResponseDto> Monuments { get; set; }
        public BookingServiceResult<GetSpecialServiceSearchResponseDto> SpecialServices { get; set; }
        public BookingServiceResult<TransportRateSearchResponseDto> Transports { get; set; }
        public BookingServiceResult<HotelRateDetailsSearchResponseDto> Hotels { get; set; }
    }
    public class BookingCommissionDetail
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
    }
    public class BookingService : Booking
    {
        public int ID { get; set; }
        public int ReferenceRateDetailID { get; set; }
        public int CommissionRefrenceID { get; set; }

        [JsonIgnore]
        public string CommissionJSON { get; set; }
        public string Action { get; set; }
        public int RateType { get; set; }
        public int BookingID { get; set; }
        public string BookingNo { get; set; }

        public string RateCardType { get; set; }

        public string Disclaimer { get; set; }

    }

    public class BookingHotelService : BookingService
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

        public List<BookingMealOverview> MealOverviews =>
            !string.IsNullOrEmpty(MealOverviewJSON) ?
            JsonConvert.DeserializeObject<List<BookingMealOverview>>(MealOverviewJSON) :
            new List<BookingMealOverview>();

        public List<BookingHotelCommissionDetail> Commissions =>
            !string.IsNullOrEmpty(CommissionJSON) ?
            JsonConvert.DeserializeObject<List<BookingHotelCommissionDetail>>(CommissionJSON) :
            new List<BookingHotelCommissionDetail>();
    }

    public class BookingMealOverview
    {
        public int HotelRateMealID { get; set; }
        public int MealTypeID { get; set; }
        public string MealType { get; set; }
        public decimal? GstPercentage { get; set; }
        public decimal? GstAmount { get; set; }
        public decimal? NetAmountIncludingTax_Org { get; set; }
        public decimal? NetAmountIncludingTax { get; set; }
        public decimal? NetAmountExcludingTax_Org { get; set; }
        public decimal? NetAmountExcludingTax { get; set; }
        public int? MasterCommissionID { get; set; }
        public bool? IsMealDetails { get; set; }
        public bool? DefineAmount { get; set; }
        public int? BookingHotelRateID { get; set; }
        public decimal? SellingRate { get; set; }
        public int? ReasonMasterId { get; set; }
    }

    public class BookingHotelCommissionDetail
    {
        public int BookingHotelRateCommId { get; set; }
        public int? RateCommisionID { get; set; }
        public int? BookingHotelRateID { get; set; }
        public int CommissionMasterID { get; set; }
        public string RateType { get; set; }
        public decimal? TaxPercentage { get; set; }
        public decimal? TaxAmount { get; set; }
        public decimal? GrossAmountIncludingTax_Org { get; set; }
        public decimal? GrossAmountIncludingTax { get; set; }
        public decimal? NetAmountIncludingTax { get; set; }
        public decimal? NetAmountExcludingTax { get; set; }
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
    public class BookingGuideServices : BookingService
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

        public List<BookingCommissionDetail> Commissions =>
        !string.IsNullOrEmpty(CommissionJSON) ?
        JsonConvert.DeserializeObject<List<BookingCommissionDetail>>(CommissionJSON) :
        new List<BookingCommissionDetail>();
    }

    public class BookingMonumentService : BookingService
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

        public List<BookingCommissionDetail> Commissions =>
        !string.IsNullOrEmpty(CommissionJSON) ?
        JsonConvert.DeserializeObject<List<BookingCommissionDetail>>(CommissionJSON) :
        new List<BookingCommissionDetail>();

    }
    public class BookingSpecialServiceRateCard : BookingService
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

        public List<BookingCommissionDetail> Commissions =>
        !string.IsNullOrEmpty(CommissionJSON) ?
        JsonConvert.DeserializeObject<List<BookingCommissionDetail>>(CommissionJSON) :
        new List<BookingCommissionDetail>();
    }
    public class BookingTransportService : BookingService
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

        public List<BookingCommissionDetail> Commissions =>
        !string.IsNullOrEmpty(CommissionJSON) ?
        JsonConvert.DeserializeObject<List<BookingCommissionDetail>>(CommissionJSON) :
        new List<BookingCommissionDetail>();

    }


    public class Booking_GuidDayWiseService
    {
        public DateTime CheckIn { get; set; }
        public DateTime CheckOut { get; set; }
        public int? Service { get; set; }
        public int? BookingID { get; set; }
        public int? QuotationID { get; set; }
        public Guid? UserID { get; set; }

        public int? RateID { get; set; }
        public string RateDetailID { get; set; }
        public int? Count { get; set; }


    }

    public class Booking_TrasportDayWiseService
    {
        public DateTime CheckIn { get; set; }
        public DateTime CheckOut { get; set; }
        public int? Service { get; set; }
        public int? BookingID { get; set; }
        public int? QuotationID { get; set; }
        public Guid? UserID { get; set; }
        public int? RateID { get; set; }
        public string RateDetailID { get; set; }
        public int? Count { get; set; }

    }

    public class Booking_SpecialServiceDayWiseService
    {
        public DateTime CheckIn { get; set; }

        public DateTime CheckOut { get; set; }

        public int? Adult { get; set; }

        public int? Child { get; set; }

        public int? Service { get; set; }

        public int? BookingID { get; set; }

        public int? QuotationID { get; set; }
        public Guid? UserID { get; set; }

        public int? RateID { get; set; }
        public string RateDetailID { get; set; }
        public int? Consolidated { get; set; }
        public int? IsUpdate { get; set; }
        public int? OlddwID { get; set; }

    }

    public class Booking_HotelDayWiseService
    {
        public DateTime CheckIn { get; set; }

        public DateTime CheckOut { get; set; }

        public int HotelID { get; set; }

        public int? BookingID { get; set; }

        public int? QuotationID { get; set; }
        public int? HotelRateDetailID { get; set; }
        public Guid? UserID { get; set; }

        public int RateID { get; set; }
        public string RateDetailID { get; set; }
        public bool offerIncluded { get; set; }
        public int? DBL { get; set; }
        public int? EBA { get; set; }
        public int? EBC { get; set; }
        public int? CNB { get; set; }
        public int? SGL { get; set; }
        public int? Twin { get; set; }
        public int? IsUpdate { get; set; }
        public int? OlddwID { get; set; }

    }

    public class Booking_MonumentDayWiseService
    {
        public DateTime CheckIn { get; set; }

        public DateTime CheckOut { get; set; }

        public int? Adult { get; set; }

        public int? Child { get; set; }

        public int? Service { get; set; }

        public int? BookingID { get; set; }

        public int? QuotationID { get; set; }
        public Guid? UserID { get; set; }

        public int? RateID { get; set; }
        public string RateDetailID { get; set; }
        public int? IsUpdate { get; set; }
        public int? OlddwID { get; set; }

    }
    public class Booking_MOTDayWiseService
    {
        public DateTime CheckIn { get; set; }

        public DateTime CheckOut { get; set; }

        public int? Adult { get; set; }

        public int? Child { get; set; }

        public int? Service { get; set; }

        public int? BookingID { get; set; }

        public int? QuotationID { get; set; }
        public Guid? UserID { get; set; }

        public int? RateID { get; set; }
        public string RateDetailID { get; set; }

    }


    public class BookingHotelRateCardMaster
    {
        public string Action { get; set; }
        public long? HotelRateID { get; set; }
        public int? HotelRateDetailID { get; set; }
        public string BookingID { get; set; }
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
        public List<BookingHotelRateCardMaster> DataList { get; set; }
        public List<BookingHotelRateCommissionDetails> Commissions { get; set; }
        public List<BookingHotelRateMealPlanMaster> Meals { get; set; }

    }
    public class BookingHotelRateCommissionDetails
    {
        public int? BookingHotelRateCommissionId { get; set; }
        public int BookingHotelRateID { get; set; }
        public int CommissionMasterID { get; set; }
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
    }


    public class BookingHotelRateMealPlanMaster
    {
        public long? BookingHotelRateMealId { get; set; }
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
        public int BookingHotelRateID { get; set; }
        public string MealType { get; set; }

        public bool? IsSupplementary { get; set; }
        public bool? IsGross { get; set; }

    }

    public class BookingOfferCommission
    {
        public long OfferCommissionID { get; set; }
        public long OfferConfigurationID { get; set; }
        public int MasterCommissionID { get; set; }
        public decimal Discount { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal PaidNightAmountExcludingTax { get; set; }
        public decimal PaidNightAmountIncludingTax { get; set; }
        public decimal FreeNightAmountExcludingTax { get; set; }
        public decimal FreeNightAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public bool IsActive { get; set; }

        public string RateType { get; set; }
    }

    public class UpdateBookingService
    {
        public long BookingID { get; set; }
        public string Action { get; set; }
        public string HotelRateCardMasterJSON { get; set; }
        public string HotelRateCommissionDetailsJSON { get; set; }
        public string HotelRateMealPlanMasterJSON { get; set; }
        public string OthersRateCardMasterJSON { get; set; }
    }

    public class ConverCommissionRateToNogotiate
    {
        public int dwID { get; set; }
        public int RateCardID { get; set; }

    }

    public class AddSubBooking
    {
        public int BID { get; set; }
        public Guid? NewCreatedBy { get; set; }

    }

    public class AddCopyBooking
    {
        public int BID { get; set; }
        public Guid? NewCreatedBy { get; set; }

    }
    public class DayWiseBooking
    {
        public long ID { get; set; }
        public long? QuotationID { get; set; }
        public DateTime? DayWiseDate { get; set; }
        public string City { get; set; }
        public int? ServiceID { get; set; }
        public string ServiceName { get; set; }
        public int? Guide { get; set; }
        public string Language { get; set; }
        public int? Vehical { get; set; }
        public int? Vendor { get; set; }
        public string Currency { get; set; }
        public int? Count { get; set; }
        public int? Adult { get; set; }
        public int? Child { get; set; }
        public long? Consolidated { get; set; }
        public int? Nationality { get; set; }
        public int? TotalCost { get; set; }
        public int? ServiceType { get; set; }
        public bool? IsLock { get; set; }
        public string RateCardStatus { get; set; }
        public long? BookingID { get; set; }
        public int? RateTypeID { get; set; }
        public string HotelName { get; set; }
        public string RoomCategory { get; set; }
        public string RateType { get; set; }
        public string MealPlan { get; set; }
        public bool? Breakfast { get; set; }
        public bool? Lunch { get; set; }
        public bool? Dinner { get; set; }
        public string TransportServive { get; set; }
        public string VehicleType { get; set; }
        public int? CountOfVehicle { get; set; }
        public string GuideService { get; set; }
        public string SpecialSerivice { get; set; }
        public string VendorInfo { get; set; }
        public string NationalityInfo { get; set; }
        public int? DBL { get; set; }
        public int? EBA { get; set; }
        public int? EBC { get; set; }
        public int? CNB { get; set; }
        public int? SGL { get; set; }
        public int? Twin { get; set; }
        public bool? IsActive { get; set; }
        public Guid? CreatedBy { get; set; }
        public DateTime? CreatedOn { get; set; }
        public Guid? ModifiedBy { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public int? GroupKey { get; set; }
        public decimal? GrossRate { get; set; }
        public int? RateID { get; set; }
        public int? RateDetailID { get; set; }
        public decimal? DBL_Rate { get; set; }
        public decimal? EBA_Rate { get; set; }
        public decimal? EBC_Rate { get; set; }
        public decimal? CNB_Rate { get; set; }
        public decimal? SGL_Rate { get; set; }

        public decimal?  SGL_TaxPercentage { get; set; }
     public decimal?  DBL_TaxPercentage { get; set; }
     public decimal?  EBA_TaxPercentage { get; set; }
        public decimal?  EBC_TaxPercentage { get; set; }
        public decimal?  CNB_TaxPercentage { get; set; }
        public decimal? Twin_Rate { get; set; }
        public decimal? Adult_Rate { get; set; }
        public decimal? Child_Rate { get; set; }
        public string Action { get; set; }
        public int? Adult_Count { get; set; }
        public int? Child_Count { get; set; }
        public int? TCountRate { get; set; }
        public bool? XoLock { get; set; }
        public int? MinimumPax { get; set; }
        public int? MaximumPax { get; set; }
        public decimal? TaxAmount { get; set; }
        public int? TaxID { get; set; }
        public List<Commission> CommissionJSON { get; set; }
        public List<HotelDayWiseModel> HotelCommissionJSON { get; set; }
        public List<BookingHotelRateMealPlanMaster> MealOverviewJSON { get; set; }
        public List<BookingOfferCommission> OfferCommission { get; set; }
        public string? Commission { get; set; }
        public string? RCTypeFlag { get; set; }
        public bool? IsOkXO { get; set; }
        public string? CityName { get; set; }
        public int? HotelID { get; set; }
        public int? RoomCatID { get; set; }
        public int? MealPlanID { get; set; }
        public int? TravelModeTypeID { get; set; }
        public int? RCTypeFlagID { get; set; }
        public int? VehicleCategoryID { get; set; }
        public int? ClassTypeID { get; set; }
        public string? VehicleCategoryName { get; set; }
        public string? Class { get; set; }
        public string? Sectors { get; set; }
        public string? MOTNameORNumber { get; set; }
        public string? MOT { get; set; }
        public bool IsXoGen { get; set; }

        public List<CustomRateMaster> CustomRateMasterData { get; set; } = new();
        public string XONumber { get; set; }
        public string CardNumber { get; set; }

    }


}

