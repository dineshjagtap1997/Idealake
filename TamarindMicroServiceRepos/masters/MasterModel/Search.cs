using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TamarindAstra.Model.DBModel
{
    public class Search_HotelRate
    {
        public int FIT { get; set; }
        public int GIT { get; set; }
        public int Contract { get; set; }
        public int Adhoc { get; set; }
        public int Negotiated { get; set; }
        public int ALL_B2B { get; set; }
        public int Nett_Markedup { get; set; }
        public int Vendor { get; set; }
        public string City { get; set; }
        public int Hotel { get; set; }
        public int RatingFrom { get; set; }
        public int RatingTo { get; set; }
        public int MIS { get; set; }
        public string Currency { get; set; }
        public int Market { get; set; }
        public string AgentCity { get; set; }
        public int AgentCategory { get; set; }
        public string AgentName { get; set; }
        public DateTime ValidFrom { get; set; }
        public DateTime ValidTo { get; set; }
        public int AgentID { get; set; }
        public int CategoryID { get; set; }
        public bool IsDirectPayment { get; set; }
        public bool ISHotelPreferred { get; set; }
        public string HotelChain { get; set; }
        public int HotelId { get; set; }
        public string CityIATACode { get; set; }
        public int RatingFromID { get; set; }
        public int RatingToID { get; set; }
        public int HotelID { get; set; }
        public int HotelRateID { get; set; }
        public string HotelName { get; set; }
        public string InfoForOps { get; set; }
        public string MealPlan { get; set; }
        public decimal Tax_Per { get; set; }
        public string DaysText { get; set; }
        public string MinMax { get; set; }
        public bool FIT_GIT { get; set; }
        public bool ShowOnline { get; set; }
        public bool Breakfast { get; set; }
        public bool Lunch { get; set; }
        public bool Dinner { get; set; }
        public string XORemarks { get; set; }
        public int HotelRateDetailsID { get; set; }
        public int Rating { get; set; }
        public string Transfer { get; set; }
        public string RoomCategory { get; set; }
        public decimal AdultExtra { get; set; }
        public decimal ChildExtra { get; set; }
        public string RateSheet { get; set; }
        public decimal SGL { get; set; }
        public decimal DBL { get; set; }
        public decimal MarkUpSingle { get; set; }
        public decimal MarkUpDouble { get; set; }
        public string CategoryCode { get; set; }
        public string CardNo { get; set; }
        public int MISSequenceNo { get; set; }
        public string RateCardMode { get; set; }
        public bool ISHotelAnnouncement { get; set; }
        public string AnnouncementDetails { get; set; }
        public string ValueAddOn { get; set; }
        public decimal SGLCommission { get; set; }
        public decimal DBLCommission { get; set; }
        public int RateDetailSequence { get; set; }
        public int HotelRatingSequence { get; set; }
        public int HotelRateID1 { get; set; }
        public bool IsEOB { get; set; }
        public bool IsPayStay { get; set; }
        public decimal TaxPerc { get; set; }
        public string OfferText { get; set; }
        public decimal BTCSComm { get; set; }
        public decimal BTCDComm { get; set; }
        public decimal SGLNett { get; set; }
        public decimal DBLNett { get; set; }
        public decimal BTCSCommTIP { get; set; }
        public decimal BTCDCommTIP { get; set; }
        public decimal BTCTIP { get; set; }
        public bool IsBTCComm { get; set; }
    }

    public class Search_HotelRate_Rule
    {
        public string Rule { get; set; }
        public int MISSequenceNo { get; set; }
        public string Description { get; set; }
        public string ApplicableToText { get; set; }
        public int ParentRateTypeID { get; set; }
        public int ParentRateID { get; set; }
    }

    public class Search_Docs
    {
        public int DocumentID { get; set; }
        public string DocumentName { get; set; }
        public string UploadedOn { get; set; }
        public string UserName { get; set; }
        public string Preview { get; set; }
        public int ParentRateTypeID { get; set; }
        public int ParentRateID { get; set; }
    }

    public class Hotel_FactSheet
    {
        public int? HotelID { get; set; }
        public string HotelName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string Rate { get; set; }
        public string PhoneNo { get; set; }
        public string FaxNo { get; set; }
        public int? HeaderID { get; set; }
        public string HeaderValue { get; set; }
        public string Description { get; set; }
        public int? HotelLandMarkID { get; set; }
        public int? LandMarkID { get; set; }
        public string LandMarkName { get; set; }
        public int? ProximityID { get; set; }
        public string LandmarkInfo { get; set; }
        public int? FacilityInfoID { get; set; }
        public string InformationName { get; set; }
        public string ImageName { get; set; }
        public string Image { get; set; }
        public int ParentPageType { get; set; }
        public int ParentID { get; set; }
    }

    public class Search_HotelRate_CancellationData
    {
        public string ValidFrom { get; set; }  
        public string ValidTo { get; set; }   
        public int TSStart { get; set; }
        public int TSEnd { get; set; }
        public int AgentStart { get; set; }
        public int AgentEnd { get; set; }
        public decimal ChargePercent { get; set; }
        public int ChargeNight { get; set; }
        public int BookedNight { get; set; }
        public bool IsActive { get; set; }
        public int BookedMinNights { get; set; }
        public int BookedMaxNights { get; set; }
        public int HotelRateID { get; set; }
    }
    public class RateCardSearchRequest
    {
        public int? Service { get; set; }
        public int? RateCardModeTypeID { get; set; }
        public string DisplayRate { get; set; }
       
        public string CityIata { get; set; }
        public byte? IsVendorOrHotel { get; set; } // 1 for Vendor, 0 for Hotel
        public int? VendorOrHotel { get; set; }
        public DateTime? ValidFrom { get; set; }
        public DateTime? ValidTo { get; set; }

        public int? NationalityID { get; set; } // Nationality of the user

       
        public string Language { get; set; } // Language Code (e.g., EN, FR)

        
        public int? VTypeID { get; set; } // Vehicle Type ID


    }

    public class TransportRateCardSearchResponse
    {
        //public string City { get; set; }
        public string TransportService { get; set; }
        public int VehicleBaseID { get; set; } // Vehicle Base Type
        public string VehicleType { get; set; }
        public string ValidFrom { get; set; } // Stored as string in "dd/MM/yyyy" format
        public string ValidTo { get; set; } // Stored as string in "dd/MM/yyyy" format
        public string Currency { get; set; }
        public string Total { get; set; } // Could be "NA" or a numeric value
        public string VendorOrHotelName { get; set; }
        public string InfoForOps { get; set; }
        public string XORemark { get; set; }
        public string CardNo { get; set; }
        public string RateCardModeType { get; set; } // Contract, Adhoc, Negotiated
        public int TransportRateDetailID { get; set; }
        public int TransportRateID { get; set; }
        public string CityID { get; set; }
        public int ModeOfTransport { get; set; }
        public string RateType { get; set; }
        public int? VendorID { get; set; }
        public int? HotelID { get; set; }
        public int ID { get; set; }
        public bool Arrival { get; set; } // 1 if ModeOfTransport is 1 or 2, otherwise 0
        public bool Departure { get; set; } // 1 if ModeOfTransport is 1, otherwise 0
    }


    public class SpecialServiceRateCardSearchResponse
    {
        public string City { get; set; }
        public string VendorOrHotelName { get; set; }
        public string Nationality { get; set; }
        public string SpecialService { get; set; }
        public string ValidFrom { get; set; } // Formatted as string "DD-MMM-YYYY"
        public string ValidTo { get; set; }   // Formatted as string "DD-MMM-YYYY"
        public string PaxRange { get; set; }  // "MinPax - MaxPax"
        public string Currency { get; set; }
        public string NetAmountIncludingTax { get; set; } // Could be "NA" or a numeric string
        public string NetAmountExcludingTax { get; set; } // Could be "NA" or a numeric string
        public string InfoForOperation { get; set; }
        public string InfoForRemark { get; set; }
        public string RateCardType { get; set; } // Contract, Adhoc, Negotiated
        public string CardNo { get; set; }
        public int RateCardModeTypeID { get; set; }
        public int SpecialServiceID { get; set; }
        public int SpecialServiceRateDetailID { get; set; }
        public int SpecialServiceRateID { get; set; }
        public int? VendorID { get; set; }
        public int? HotelID { get; set; }
        public int MinimumPax { get; set; }
        public int MaximumPax { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
    }

    public class MonumentRateCardSearchResponse
    {
        public string City { get; set; }
        public string Vendor { get; set; }
        public string MonumentService { get; set; }
        public string Nationality { get; set; }
        public string InfoForOperation { get; set; }
        public string InfoForRemark { get; set; }
        public DateTime ValidFrom { get; set; }
        public DateTime ValidTo { get; set; }
        public string CurrencyID { get; set; }
        public string Rate { get; set; } // Could be "NA" or a numeric value
        public string RateCardModeType { get; set; } // Contract, Adhoc, Negotiated
        public string CardNo { get; set; }
        public int RateCardModeTypeID { get; set; }
        public int MonumentRateID { get; set; }
        public int MonumentDetailID { get; set; }
        public string ClosedOn { get; set; }
        public string CityID { get; set; }
        public int MonumentServiceID { get; set; }
        public int NationalityID { get; set; }
        public int VendorID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public string RateType { get; set; }
    }
    public class GuideRateCardSearchResponse
    {
        public string City { get; set; }
        public string Vendor { get; set; }
        public string GuideService { get; set; }
        public DateTime ValidFrom { get; set; }
        public DateTime ValidTo { get; set; }
        public string PaxRange { get; set; } // "PaxFrom - PaxTo"
        public string Language { get; set; }
        public string CurrencyID { get; set; }
        public string Rate { get; set; } // Could be "NA" or a numeric value
        public string InfoForOperation { get; set; }
        public string RateCardType { get; set; } // Contract, Adhoc, Negotiated
        public string CardNo { get; set; }
        public int RateCardModeTypeID { get; set; }
        public int GuideRateID { get; set; }
        public int GuideRateDetailID { get; set; }
        public string CityID { get; set; }
        public string LanguageCode { get; set; }
        public int VendorID { get; set; }
    }

    public class Search_HotelOffer
        {
            public string City { get; set; }
            public string HotelVendorName { get; set; }
            public string HotelGroup { get; set; }
            public string RateHeader { get; set; }
            public string HotelRating { get; set; }
            public string ValidFrom { get; set; }
            public string ValidTo { get; set; }
            public string HotelGroupName { get; set; }
            public string HOMCITY { get; set; }
            public string IsHotelVendor { get; set; }
            public string VendorHotelName { get; set; }
            public string Heading { get; set; }
            public DateTime RateValidFrom { get; set; }
            public DateTime RateValidTo { get; set; }
            public string Rules { get; set; }
            public string InfoForOps { get; set; }
            public int HotelOfferID { get; set; }
            public string IATACode { get; set; }
            public int HotelRatingID { get; set; }
            public bool IsActive { get; set; }
            public string CardNo { get; set; }
            public string RateSheet { get; set; }
            public string MarketName { get; set; }
            public string StayFromTo { get; set; }
            public string BookFromTo { get; set; }
            public string Links { get; set; }
        }

        public class Search_AgentInfo
        {
            public int? AgentID { get; set; }
            public string City_IATACode { get; set; }
            public string StateCode { get; set; }
            public string CountryCode { get; set; }
            public string SelectedData { get; set; }
            public string SelectedValue { get; set; }
            public string EmpID { get; set; }
            public string Page { get; set; }
            public string AgentCode { get; set; }
            public string AgentName { get; set; }
            public int? CategoryID { get; set; }
            public string GroupID { get; set; }
            public int? MarketID { get; set; }
            public string Website { get; set; }
            public string PhoneNo { get; set; }
            public string MobileNo { get; set; }
            public string EmailID { get; set; }
            public string PanNo { get; set; }
            public string ChequeFavouring { get; set; }
            public string Address { get; set; }
            public bool CreditApplicable { get; set; }
            public string CreditCurrencyCode { get; set; }
            public bool IsActive { get; set; }
            public decimal CreditAllowance { get; set; }
            public decimal Threshold { get; set; }
            public string CreditPeriod { get; set; }
            public string OutStandingAmount { get; set; }
            public string StateName { get; set; }
            public bool OnlineExists { get; set; }
            public string UserID { get; set; }
            public string CategoryCode { get; set; }
            public string AddressInfo { get; set; }
            public string Contact { get; set; }
            public string OutStandingAmountWithCurr { get; set; }
            public string CreditInfo { get; set; }
            public string TANNo { get; set; }
            public string GST { get; set; }
            public string TamSalesName { get; set; }
            public string? SalesTaxRegNumber { get; set; }
        

    }

        public class Search_Contact
    {
        public int TypeID { get; set; }
        public int ID { get; set; }
        public int ContactDetailsID { get; set; }
        public int ParentID { get; set; }
        public bool IsPrimaryContact { get; set; }
        public int SalutationID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DesignationOrDepartment { get; set; }
        public string EmailID { get; set; }
        public string OfficeNo { get; set; }
        public string FaxNo { get; set; }
        public string MobileNo { get; set; }
        public string Salutation { get; set; }
        public string DateOfBirth { get; set; }
        public string CityIATACode { get; set; }
        public string CityName { get; set; }
        public bool IsActive { get; set; }
        public bool IsForContracting { get; set; }
        public bool IsAccStatement { get; set; }
        public bool IsB2BLogin { get; set; }
        public bool IsB2CLogin { get; set; }
        public string IATACode { get; set; }
        public string DisplayName { get; set; }
    }

        public class Search_HotelInfo
        {
            public string HotelChain { get; set; }
            public string HotelId { get; set; }
            public string CityIATACode { get; set; }
            public string RatingFromID { get; set; }
            public string RatingToID { get; set; }
            public string HotelCode { get; set; }
            public string HotelName { get; set; }
            public int HotelRatingID { get; set; }
            public string Contacts { get; set; }
            public string ChainIATACode { get; set; }
            public string CityName { get; set; }
            public string Code { get; set; }
            public string Description { get; set; }
            public string Name { get; set; }
            public string Age { get; set; }
            public string CreditDetails { get; set; }
            public string ChqDetails { get; set; }
        }

        public class HotelRoomInfo
        {
        public int HotelRoomCategoryID { get; set; }
        public int HotelID { get; set; }
        public int RoomCategoryID { get; set; }
        public string RoomCategory { get; set; }
        public int NoOfRooms { get; set; }
        public int MaxAdult { get; set; }
        public bool ExtraBedMattress { get; set; }
        public string ExtraBedMattressText { get; set; }
        public string IsInterconnecting { get; set; }
        public int NoOfInterconnectingRoom { get; set; }
        public bool IsActive { get; set; }
    }
        public class Search_VendorInfo
        {
            public string VendorID { get; set; }
            public string CityIATACode { get; set; }
            public string AccountGroup { get; set; }
            public string VendorOnCredit { get; set; }
            public string AccCode { get; set; }
            public string VendorCode { get; set; }
            public string VendorName { get; set; }
            public string AccountGroupName { get; set; }
            public string PhoneNo { get; set; }
            public string MobileNo { get; set; }
            public string FaxNo { get; set; }
            public string EmailID { get; set; }
            public string PanNo { get; set; }
            public string STRegNo { get; set; }
            public string Address { get; set; }
            public string AccountNo { get; set; }
            public string CreateAdvanceAccount { get; set; }
            public string CreditApplicable { get; set; }
            public string CreditCurrencyCode { get; set; }
            public bool IsActive { get; set; }
            public decimal CreditAmount { get; set; }
            public string CreditInfo { get; set; }
            public string ChequeInfo { get; set; }
            public string AddressInfo { get; set; }
            public string Contact { get; set; }
            public bool IsPreferred { get; set; }
        }

        public class Contact_Info
        {

        public int? PageNumber { get; set; } = 0;
        public string ContactName { get; set; }
            public int? ContactDetailsID { get; set; }
            public int? ParentID { get; set; }
            public int? TypeID { get; set; }
            public bool IsPrimaryContact { get; set; }
            public int? SalutationID { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string DesignationOrDepartment { get; set; }
            public string EmailID { get; set; }
            public string Email { get; set; }
            public string OfficeNo { get; set; }
            public string MobileNo { get; set; }
            public string FaxNo { get; set; }
            public string OfficeNoE { get; set; }
            public string MobileNoE { get; set; }
            public string FaxNoE { get; set; }
            public DateTime? DateOfBirth { get; set; } // Nullable DateTime for optional DOB
            public string DateOfBirthE { get; set; } // Optional, if DOB in another format
            public string Type { get; set; }
            public string TypeName { get; set; }
            public string TypeNameE { get; set; }
            public string Address { get; set; }
            public bool IsActive { get; set; }
            public string CityCountry { get; set; }
            public string Salutation { get; set; }
            public string Country_IATACode { get; set; }
        public string CountryCode { get; set; }
        public string StateCode { get; set; }
      
        public string MarketID { get; set; }
            public string MarketName { get; set; }
            public string ContactNameE { get; set; }
            public string CityName { get; set; }
            public string CountryName { get; set; }
            public string CountryCodeAW { get; set; }
            public string CityCodeAW { get; set; }
            public string CityCode { get; set; }
            public bool IsForContracting { get; set; }
            public string CityIATACode { get; set; } = string.Empty;
            public string City_IATACode { get; set; }
            public bool? Active { get; set; }
            public string PhoneNo { get; set; }
            public string Action { get; set; }
        public string StateName { get; set; }
        public string Associated_With { get; set; }
        public string OfficeNumber { get; set; }
        public string MobileNumber { get; set; }
        public bool IsAccStatement { get; set; }
        public string ContactStatus { get; set; }
        public string BizPStatus { get; set; }
        public DateTime? BizPCreationDate { get; set; }
        public int? IsDate { get; set; }
        public DateTime? FromDate { get; set; }
        public string AddressCityCountry { get; set; }
        public string CountryIATACode { get; set; }
        public string AddressCityCountryState { get; set; }
        public int? StateID { get; set; }
        public bool? BizActive { get; set; }
    }


        public class Search_HotelRoomOrAnnouncement
        {
            public string HotelChain { get; set; }
            public int HotelId { get; set; }
            public string CityIATACode { get; set; }
            public int RatingFromID { get; set; }
            public int RatingToID { get; set; }
            public int HotelID { get; set; }
            public string HotelCode { get; set; }
            public string HotelName { get; set; }
            public int HotelRatingID { get; set; }
            public string Contacts { get; set; }
            public string ChainIATACode { get; set; }
            public string CityName { get; set; }
            public string Code { get; set; }
            public string Description { get; set; }
            public string Name { get; set; }
            public string Age { get; set; }
            public string CreditDetails { get; set; }
            public string ChqDetails { get; set; }
        }
        public class Search_PrintInvoiceNew
        {
            public int ID { get; set; }
            public int Invoice_ID { get; set; }
            public string Type_Of_Doc { get; set; }
            public string Invoice_Type { get; set; }
            public DateTime Invoice_Date { get; set; }
            public int File_ID { get; set; }
            public int Qut_ID { get; set; }
            public string Customer_Name { get; set; }
            public int Agent_ID { get; set; }
            public int Curr_ID { get; set; }
            public int SAC_ID { get; set; }
            public int StateCode_ID { get; set; }
            public int Tax_ID { get; set; }
            public int Invoice_No_Of_Pax { get; set; }
            public string Invoice_Credit_Note { get; set; }
            public decimal Invoice_Exchg_Rate { get; set; }
            public decimal Invoice_Curr_Amt { get; set; }
            public decimal Invoice_Total { get; set; }
            public string Reference { get; set; }
            public string CompCode { get; set; }
            public string YearCode { get; set; }
            public decimal ReceivedAmt { get; set; }
            public decimal BalAmt { get; set; }
            public decimal TaxAmount { get; set; }
            public decimal AmtInINR { get; set; }
            public string MiscAcc { get; set; }
            public string RefNo { get; set; }
            public bool PreviousYear { get; set; }
            public bool IsVoid { get; set; }
            public string ConvertedInvNo { get; set; }
            public string CreatedBy { get; set; }
            public DateTime CreatedDateTime { get; set; }
            public string LastUpdatedBy { get; set; }
            public DateTime LastUpdateDateTime { get; set; }
            public string CurrencyName { get; set; }
            public string AgentName { get; set; }
            public string AccCode { get; set; }
            public bool IsDirectPayment { get; set; }
            public bool IsTaxReverseCharge { get; set; }
            public string Flag { get; set; }
            public int TaxIDOps { get; set; }
            public bool IsBillOfSupply { get; set; }
            public string CityIATACode { get; set; }
            public int TCSRateID { get; set; }
            public bool IsPANExists { get; set; }
            public string PANNo { get; set; }
            public bool IsPassportExist { get; set; }
            public bool IsResident { get; set; }
            public decimal TCSValue { get; set; }
            public bool IsTCS_Inv { get; set; }
            public bool IsTCS_Inv1 { get; set; }
            public decimal ServiceFee_Amt { get; set; }
            public bool IsServFee_Inv { get; set; }
        }

        public class Search_PrintInvoice
        {
            public string InvoiceNo { get; set; }
            public string Invoice_ID { get; set; }
            public int ID { get; set; }
            public int Qut_ID { get; set; }
            public string File_ID { get; set; }
            public string Flag { get; set; }
        }

        public class Search_GuideInfo
        {
            public string StateID { get; set; }
            public string CityID { get; set; }
            public string StarRating { get; set; }
            public string Language { get; set; }
            public int GuideID { get; set; }
            public string Name { get; set; }
            public string PhoneNo { get; set; }
            public string Address { get; set; }
            public string City { get; set; }
            public string State { get; set; }
            public string Languages { get; set; }
            public string Ranking { get; set; }
            public bool IsDOT { get; set; }
            public bool IsState { get; set; }
            public bool IsASI { get; set; }
            public string CompareLanguage { get; set; }
        }

        public class Search_PrintCommInvoice
        {

            public int Invoice_ID { get; set; }
            public string CompanyName { get; set; }
            public string Address { get; set; }
            public string CityIATACode { get; set; }
            public string Website { get; set; }
            public string Email { get; set; }
            public string HeadAddress { get; set; }
            public string HeadCompanyName { get; set; }
            public string HeadCityIATACode { get; set; }
            public string Logo { get; set; }
            public string AgentLogo { get; set; }
            public string Phone { get; set; }
            public string Fax { get; set; }
            public string HeadPhone { get; set; }
            public string HeadFax { get; set; }
            public string HeadWebsite { get; set; }
            public string HeadEmail { get; set; }
            public string GSTIN { get; set; }
            public string SAC { get; set; }
            public string PlaceOfSupply { get; set; }
            public bool IsTaxReverseCharge { get; set; }
            public bool IsBillOfSupply { get; set; }
            public string QRCode { get; set; }
            public bool ShowImage { get; set; }
            public string IRN { get; set; }
            public DateTime? ACKDate { get; set; } // Nullable DateTime
            public string ACKNo { get; set; }
            public string VATNo { get; set; }
            public string State { get; set; }
            public string CGSTIN { get; set; }
            public string CIN { get; set; }
            public string PAN { get; set; }
            public string BranchAddress { get; set; }
            public string BankDetails { get; set; }
            public string MSMERegNo { get; set; }
            public bool IsTCS_Inv { get; set; }
            public bool IsTCS_Inv1 { get; set; }
            public string Flag_InvOrTktInv { get; set; }
            public string LUTNumber { get; set; }
            public string EXP { get; set; }
            public string SEZ { get; set; }
            public string AccountName { get; set; }
            public string AccountPrefix { get; set; }
            public int BankID { get; set; }
            public string VirtualAccount { get; set; }
            public string AccountNo { get; set; }
            public bool RedDotPrint { get; set; }
            public string CompanyNameFooter { get; set; }
            public string NotesForInvoice { get; set; }
            public string BTCDPRemark { get; set; }
            public string QuotationID { get; set; }
        }

        public class SearchPrintWithTax
         {
        public int QuotationID { get; set; }

        public string InvoiceID { get; set; }
    }

   

     public class SearchManage_Contact

    {
        public string ContactName { get; set; }
        public string Type { get; set; }
        public string City_IATACode { get; set; }
        public string TypeName { get; set; }
        public bool? Active { get; set; }
        public string PhoneNo { get; set; }
        public int? MarketID { get; set; }
        public int? ContactDetailsID { get; set; }
        public int? ParentID { get; set; }
        public byte? TypeID { get; set; }
        public bool? IsPrimaryContact { get; set; }
        public int? SalutationID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DesignationOrDepartment { get; set; }
        public string EmailID { get; set; }
        public string OfficeNo { get; set; }
        public string MobileNo { get; set; }
        public string FaxNo { get; set; }
        public DateTime? DateofBirth { get; set; }
        public string CityIATACode { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsForContracting { get; set; }
        public string Action { get; set; }
        public bool? BizPStatus { get; set; }
    }

}

