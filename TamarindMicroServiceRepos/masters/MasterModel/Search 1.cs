namespace TamarindAstraMasters.MasterModel
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
        public bool IsHotelVendor { get; set; }
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
        public int AgentID { get; set; }
        public string City_IATACode { get; set; }
        public string StateCode { get; set; }
        public string CountryCode { get; set; }
        public string SelectedData { get; set; }
        public string SelectedValue { get; set; }
        public string EmpID { get; set; }
        public string Page { get; set; }
        public string AgentCode { get; set; }
        public string AgentName { get; set; }
        public int CategoryID { get; set; }
        public string GroupID { get; set; }
        public int MarketID { get; set; }
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
        public decimal OutStandingAmount { get; set; }
        public string StateName { get; set; }
        public bool OnlineExists { get; set; }
        public string UserID { get; set; }
        public string CategoryCode { get; set; }
        public string AddressInfo { get; set; }
        public string Contact { get; set; }
        public decimal OutStandingAmountWithCurr { get; set; }
        public string CreditInfo { get; set; }
        public string TANNo { get; set; }
        public string GST { get; set; }
        public string TAMSales { get; set; }

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
        public bool CreditApplicable { get; set; }
        public string CreditCurrencyCode { get; set; }
        public bool IsActive { get; set; }
        public decimal CreditAmount { get; set; }
        public string CreditInfo { get; set; }
        public string ChequeInfo { get; set; }
        public string AddressInfo { get; set; }
        public string Contact { get; set; }
        public bool IsPreferred { get; set; }
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
        public int Invoice_ID { get; set; }
        public int ID { get; set; }
        public int Qut_ID { get; set; }
        public int File_ID { get; set; }
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
    public class Search_OtherRateCard { }

    public class Search_ContactInfo { }

    public class Search_PrintCommInvoice { }

    #region Request Model starts here
    public class RequestModel
    {
        public string RequestText { get; set; }
        public string MasterFlag { get; set; }
    }

    #endregion Request Model ENDs here

    #region Response Model starts here
    public class ResponseModel
    {
        public string responseText { get; set; }
    }
    #endregion Response Model ENDs here
}
