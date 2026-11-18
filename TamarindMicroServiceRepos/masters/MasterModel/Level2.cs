using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace DataAccess.Model.DBModel
{
    #region Hotel Master Started
    public class HotelMaster
    {
        public long HotelID { get; set; }

        public string AccCode { get; set; }

        public string HotelCode { get; set; }
        public string HotelName { get; set; }
        public int HotelRatingID { get; set; }
        public string ChainIATACode { get; set; }
        public bool ReuseAllocation { get; set; }
        public string CityIATACode { get; set; }
        public string Website { get; set; }
        public int? ZoneID { get; set; }
        public string PhoneNo { get; set; }
        public string MobileNo { get; set; }
        public string FaxNo { get; set; }
        public string EmailID { get; set; }
        public string PanNo { get; set; }
        public string STRegNo { get; set; }
        public string ChequeFavouring { get; set; }
        public string BankName { get; set; }
        public string Address { get; set; }
        public string AccountNo { get; set; }
        public bool CreateAdvanceAccount { get; set; }
        public bool CreditApplicable { get; set; }
        public int CreditPeriod { get; set; }
        public string CreditCurrencyCode { get; set; }
        public decimal CreditAmount { get; set; }
        public string CreditApproveBy { get; set; }
        public int InfantFromAge { get; set; }
        public int InfantToAge { get; set; }
        public int ChildFromAge { get; set; }
        public int ChildToAge { get; set; }
        public int AdultFromAge { get; set; }
        public int AdultToAge { get; set; }
        public bool? IsActive { get; set; }
        public Guid? OperationBy { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public bool CreateCommissionAccount { get; set; }
        public int? BankAccountID { get; set; }
        public int? HotelTypeID { get; set; }
        public string BranchName { get; set; }
        public string IFSCCode { get; set; }
        public string SWIFTCode { get; set; }
        public string Comment { get; set; }
        public string StateCode { get; set; }
        public string SupplierID { get; set; }
        public int CompanyID { get; set; }
        public string GSTNID { get; set; }
        public string LegalName { get; set; }
        public int BTCBranchPosting { get; set; }
        public bool GSTRequired { get; set; }
        public bool IsActiveSAP { get; set; }
        public string TANDetails { get; set; }
        public string PreviousCode { get; set; }
        public string MSME { get; set; }
        public string Deductee { get; set; }
        public string WithHoldigTax { get; set; }
        public string RoomCount { get; set; }
        public bool IsActiveMSME { get; set; }
        public string MSMEType { get; set; }
        public DateTime? MSMERegFromDt { get; set; }
        public DateTime? MSMERegToDt { get; set; }
        public string PostalCode { get; set; }
        public int? LegalEntity { get; set; }
        public bool IsSEZ { get; set; }
        public string MembershipNo { get; set; }
        public bool NonGSTRegistered { get; set; }
        public bool? PayMode { get; set; }
        public string Action { get; set; }

        public string returnCode { get; set; } = string.Empty;
        public string returnMessage { get; set; } = string.Empty;

        public string Country { get; set; }

        public string State { get; set; }

        public string City { get; set; }
        public string EmailGeneral { get; set; }
        public string EmailFinance { get; set; }


        public int State_IATACode { get; set; }
        public string Beneficiary_Name { get; set; }
        public string CountryName { get; set; }
        public string StateName { get; set; }
        public string Contact1 { get; set; }
        public string Contact2 { get; set; }
        public int HotelChainID { get; set; }
        public string HotelGroupName { get; set; }
        public string SAPCode { get; set; }
        public bool Contact1IsMobile { get; set; }
        public bool Contact2IsMobile { get; set; }
        public int PageNumber { get; set; }
        public int HotelGroupID { get; set; }
        public string TaxType { get; set; }

        public string Tax_Reg_Number { get; set; }
        public bool IsSapCompCode { get; set; } = false;

        public bool IsHotelCode { get; set; } = true;
        public string? HotelSAPCode { get; set; }

    }
    #endregion Hotel Master END

    #region HOTELCODE STARTS HERE

    public class HOTELCODE
    {
        public int HotelcodeID { get; set; }

        public string Action { get; set; }
    }
    #endregion HOTELCODE ENDS HERE
    #region HotelRoomCategoryTab starts here
    public class HotelRoomCategoryTab
    {
        public int HotelRoomCategoryID { get; set; }
        public int HotelID { get; set; }
        public int RoomCategoryID { get; set; }
        public int? NoOfRooms { get; set; }
        public int? MaxAdult { get; set; }
        public int ExtraBedMattress { get; set; }
        public byte IsInterconnecting { get; set; }
        public short? NoOfInterconnectingRoom { get; set; }
        public bool IsActive { get; set; }
        public int? NoOfBedrooms { get; set; } // Nullable field
        public string Action { get; set; }
        public string RoomCategory { get; set; }
        public Guid? OperationBy { get; set; }
    }
    #endregion HotelRoomCategoryTab ends here

    #region contactdetail starts here
    public class HotelContactDetailsTab
    {
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
        public DateTime? DateOfBirth { get; set; }
        public string CityIATACode { get; set; }
        public DateTime? InsertedDate { get; set; }
        public bool IsActive { get; set; }
        public bool? IsAccStatement { get; set; }
        public bool? IsCC { get; set; }
        public bool? IsForContracting { get; set; }
        public bool? IsBills { get; set; }
        public Guid? CreatedBy { get; set; }
        public Guid? OperationBy { get; set; }
        public int? ContactDetailsID { get; set; }
        public int? ID { get; set; }
        public string Action { get; set; }
        public string CityName { get; set; }
        public bool HideNumberEmail { get; set; }
    }

    #endregion contactdetail ends here

    #region hotelrule starts here
    public class HotelRuleTab
    {
        public int? HotelRuleID { get; set; }
        public int HotelID { get; set; }
        public int RuleID { get; set; }
        public int MISSequenceNo { get; set; }
        public int ApplicableTo { get; set; }
        public string Description { get; set; }

        public string Action { get; set; }
    }

    #endregion hotelrule ends here

    #region  hotelsapcompcode starts HERE
    public class HotelSAPCompCode
    {
        public int SAPCompCodeID { get; set; }
        public long ParentId { get; set; }
        public int TypeId { get; set; }
        public string SAPCompCodename { get; set; }
        public string BPCode { get; set; }
        public bool IsActive { get; set; }
        public Guid CreatedBy { get; set; }
        public Guid UpdatedBy { get; set; }
        public Guid? OperationBy { get; set; }

        public string Action { get; set; }
        public int ID { get; set; }
    }

    #endregion hotelsapcompcode ends here

    #region hotelannouncement starts here
    public class HotelAnnouncement
    {
        public int AnnouncementID { get; set; } = 0;
        public long HotelID { get; set; }
        public int HeaderID { get; set; }
        public string AnnouncementDetails { get; set; }
        public DateTime? ValidTo { get; set; } = null;
        public string Action { get; set; }
        public string CityID { get; set; }

        public string ChainIATACode { get; set; }
        public Guid? OperationBy { get; set; }
    }

    #endregion hotelannouncement ends here

    #region CompanyMaster starts here 
    public class CompanyMaster
    {
        public int? PageNumber { get; set; }
        public string CompanyName { get; set; }
        public bool HeadOffice { get; set; }
        public bool PrintHeadOffAddress { get; set; }
        public string Address { get; set; }
        public string CityIATACode { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string Website { get; set; }
        public string Email { get; set; }
        public string PanNo { get; set; }
        public string LSTNo { get; set; }
        public string CSTNo { get; set; }
        public string VATNo { get; set; }
        public string STNo { get; set; }
        public bool? IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public int? StateCode { get; set; }
        public string SAP_StateCode { get; set; }
        public string SAP_CompanyCode { get; set; }
        public string PostalCode { get; set; }
        public string SAP_BusinessPlaceCode { get; set; }
        public string CIN { get; set; }
        public string MSME_RegNo { get; set; }
        public string RegAddress { get; set; }
        public string BranchAddress { get; set; }
        public string CompCode { get; set; }
        public string CurrencyComp_id { get; set; }
        public string NotesForInvoice { get; set; }
        public string LegalName { get; set; }
        public string EmailIDForXO { get; set; }
        public string TwoDigitStateCode { get; set; }
        public string Action { get; set; }
        public int? CompanyID { get; set; }
        public bool Active { get; set; }
        public int? TEntity_ID { get; set; }
        public string Country { get; set; }
        public string salesTaxRegNumber { get; set; }
        public string tanNumber { get; set; }
        public string Country_Name { get; set; }
        public string Country_IATACode { get; set; }
        public int? StateID { get; set; }
        public string PANVERIFICATION { get; set; }
        public string TANVERIFICATION { get; set; }
        public string GSTVERIFICATION { get; set; }
        public string CityName { get; set; }
        public string TaxType { get; set; }
        public string StateCodeName { get; set; }
        public string CurrencyName { get; set; }
        public string TaxRegistrationNumberTRN { get; set; }
        public string RecordIsActive { get; set; }
        public string StateName { get; set; }
        public string? City { get; set; }
    }

    #endregion CompanyMaster ENDs here

    #region AgentMaster starts here
    public class AgentMaster
    {
        public string AccCode { get; set; }
        public string AgentCode { get; set; }
        public string AgentName { get; set; }
        public string BranchName { get; set; }
        public string BankName { get; set; }
        public string AccountNumber { get; set; }
        public string IFSCCode { get; set; }
        public string SWIFTCode { get; set; }
        public string MSMEUanNumber { get; set; }
        public string IATACode { get; set; }
        public string Contact1 { get; set; }
        public string Contact2 { get; set; }
        public string MSMEType { get; set; }
        public string MarkUpCategory { get; set; }
        public string IATOCode { get; set; }
        public int? CategoryID { get; set; }
        public int? Miscellaneous { get; set; }
        public int? GroupID { get; set; }
        public int? MarketID { get; set; }
        public string City_IATACode { get; set; }
        public string Website { get; set; }
        public string PhoneNo { get; set; }
        public string MobileNo { get; set; }
        public string FaxNo { get; set; }
        public string EmailID { get; set; }
        public string PanNo { get; set; }
        public string? STRegNo { get; set; }
        public string ChequeFavouring { get; set; }
        public string Address { get; set; }
        public bool CreateAdvanceAccount { get; set; }
        public bool CreditApplicable { get; set; }
        public string CreditCurrencyCode { get; set; }
        public decimal CreditAllowance { get; set; }
        public decimal Threshold { get; set; }
        public int? CreditPeriod { get; set; }
        public decimal OutStandingAmount { get; set; }
        public bool UnlimitedCredit { get; set; }
        public bool? IsActive { get; set; }
        public bool IsOtherBooking { get; set; }
        public bool IsCorporate { get; set; }
        public Guid OperationBy { get; set; }
        public int? IsFromB2BOrAstra { get; set; }
        public int? BankAccountID { get; set; }
        public int? AgentID { get; set; }
        public int? RelatedEmployeeID { get; set; }
        public bool HasBranch { get; set; }
        public int StateCodeID { get; set; }
        public bool IsInterBranch { get; set; }
        public bool IsSEZ { get; set; }
        public bool AddressExist { get; set; }
        public bool GSTRequired { get; set; }
        public string AddressCountry { get; set; }
        public string AddressState { get; set; }
        public string AddressCity { get; set; }
        public bool isActiveSAP { get; set; }
        public string TANDetails { get; set; }
        public string PreviousCode { get; set; }
        public int? AgentClassification { get; set; }
        public string Comments { get; set; }
        public bool IsAgentREFPO { get; set; }
        public int? BusinessHeadID { get; set; }
        public int? SalesHeadID { get; set; }
        public string PostalCode { get; set; }
        public int? LegalEntity { get; set; }
        public string LegalName { get; set; }
        public bool Virtualaccount { get; set; }
        public string Action { get; set; }
        public bool IsOtherBooing { get; set; }
        public string Country_IATACode { get; set; }
        public string CategoryCode { get; set; }
        public string CountryName { get; set; }
        public string CityName { get; set; }
        public string GSTIN { get; set; }
        public string Market { get; set; }
        public string OperationOn1 { get; set; }
        public string ISCreditApplicable { get; set; }
        public string BankAccountName { get; set; }
        public string IsCorporate_Y { get; set; }
        public int TamSalesRep { get; set; }
        public bool IsBranch { get; set; }
        public int? CompanyCode { get; set; }
        public string Operation { get; set; }
        public DateTime OperationOn { get; set; }
        public string StateName { get; set; }
        public string PANVERIFICATION { get; set; }
        public string TANVERIFICATION { get; set; }
        public string GSTVERIFICATION { get; set; }
        public string BeneficiaryName { get; set; }
        public string GroupName { get; set; }
        public string AgentGroupName { get; set; }
        public string TamSalesName { get; set; }
        public bool IsContact1Mobile { get; set; }
        public bool IsContact2Mobile { get; set; }
        public bool IsAgent { get; set; }
        public string LeadID { get; set; }
        public string? TaxType { get; set; }
        public string? SalesTaxRegNumber { get; set; }
        public bool UsedInBooking { get; set; }

        public int? PageNumber { get; set; }

        public string HasAgent { get; set; }
        public string IsCreateAdvanceAccount { get; set; }
        public string IsCreditApplicable { get; set; }

        public string IsUnlimitedCredit { get; set; }
        public string Active { get; set; }
        public string Branch { get; set; }
        public string HasSEZ { get; set; }
        public string HasActiveSAP { get; set; }

        public string HasIsAgentREFPO { get; set; }
        public string IsVirtualaccount { get; set; }
        public string HasInterBranch { get; set; }

        public string SEZ_No { get; set; }
        public string Free_Zone { get; set; }
        public string Agent_On_Credit { get; set; }
        public decimal CreditAmount { get; set; }

        public string BizGroupName { get; set; }
    }
    #endregion AgentMaster ends here

    #region agentcontactdetails starts here
    public class AgentContactDetailsTab
    {
        public int ContactDetailsID { get; set; }
        public int ParentID { get; set; }
        public byte TypeID { get; set; }
        public bool IsPrimaryContact { get; set; }
        public int SalutationID { get; set; }
        public string FirstName { get; set; }
        public string DesignationOrDepartment { get; set; }
        public string EmailID { get; set; }
        public string MobileNo { get; set; }
        public DateTime DateofBirth { get; set; }
        public string CityIATACode { get; set; }
        public bool IsActive { get; set; }
        public string UserID { get; set; }
        public string Password { get; set; }
        public bool IsAdminUser { get; set; }
        public bool IsEmail { get; set; }
        public bool IsAccStatement { get; set; }
        public bool IsCCtoAdmin { get; set; }
        public bool IsOnlineBookingAccess { get; set; }
        public bool IsXMLUser { get; set; }
        public bool IsCC { get; set; }
        public bool IsB2BLogin { get; set; }
        public bool IsB2CLogin { get; set; }
        public string Action { get; set; }
        public string OfficeNo { get; set; }
        public Guid? OperationBy { get; set; }
    }
    #endregion agentcontactdetails ends here

    #region agentsapcompcode starts here
    public class AgentSAPCompCode
    {
        public long SAPCompCodeID { get; set; }
        public long ParentId { get; set; }
        public long ID { get; set; }
        public int TypeId { get; set; }
        public string SAPCompCodename { get; set; }

        public string BPCode { get; set; }
        public bool IsActive { get; set; }
        public Guid CreatedBy { get; set; }
        public Guid UpdatedBy { get; set; }
        public Guid OperationBy { get; set; }
        public string Action { get; set; }
    }

    #endregion agentsapcompcode ends here

    #region State Code Master starts here
    public class StateCodeMaster
    {
        public int ID { get; set; }
        public string StateCode { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public bool IsUnionTerritory { get; set; }
        public bool IsOtherTerritory { get; set; }

        //[JsonProperty("2DigitCode")]
        public string TwoDigitCode { get; set; }

        public string Action { get; set; }
    }
    #endregion State Code Master ends here

    #region lockdate starts here

    public class LockDateMaster
    {
        public string Year { get; set; }
        public int MonthID { get; set; }
        public int LockDate { get; set; }
        public Guid OperationBy { get; set; }
        public string Action { get; set; }
    }

    #endregion lockdate ends here

    #region TCS Rate Master starts here
    public class TCSRateMaster
    {
        public int TCSID { get; set; }
        public string ACCode { get; set; }
        public string Description { get; set; }
        public DateTime? ValidFrom { get; set; }
        public DateTime? ValidTo { get; set; }
        public decimal TCSRate { get; set; }
        public bool IsActive { get; set; }
        public Guid CreatedBy { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime CreatedDate { get; set; }

        public string SAPCode { get; set; }
        public string Action { get; set; }
    }
    #endregion TCS Rate Master ends here

    #region Agent Classification Master starts here
    public class AgentClassificationMaster
    {
        public int ID { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public string Action { get; set; }
    }
    #endregion Agent Classification Master ends here

    #region Vendor Services Master starts here
    public class Vendor_Services_Master
    {
        public int Vendor_ID { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string Action { get; set; }
    }
    #endregion Vendor Services Master ends here

    #region Service Location starts here
    public class Service_Location_Master
    {
        public int ServLoc_ID { get; set; }
        public int Code { get; set; }
        public int SuppTypeID { get; set; }
        public string Description { get; set; }
        public string LongDescription { get; set; }
        public bool IsActive { get; set; }
        public string Action { get; set; }
        public Guid OperationBy { get; set; }
    }
    #endregion Service Location ends here

    #region Invoice Description Master starts here
    public class Invoice_Description_Master
    {
        public int InvDesc_ID { get; set; }
        public string Description { get; set; }
        public int SACCode { get; set; }
        public bool IsComm { get; set; }
        public bool IsActive { get; set; }
        public int SACID { get; set; }
        public string SACDescription { get; set; }
        public string Action { get; set; }
        public Guid OperationBy { get; set; }
    }
    #endregion Invoice Description Master ends here

    #region legaltype starst here

    public class LegalTypeMaster
    {
        public string LegalEntityType { get; set; }
        public bool IsActive { get; set; }
        public Guid CreatedBy { get; set; }
        public string Action { get; set; }
        public Guid? UpdatedBy { get; set; }
        public int? LegalEntTypeID { get; set; }
        public bool? Active { get; set; }
    }



    #endregion legaltype ends here


    #region Tax Percentage starts here

    public class TaxPercentage
    {
        public int GSTID { get; set; }
        public decimal GSTPercentageValue { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public string Operation { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string Action { get; set; }
        public decimal GSTPercentage { get; set; }
        //public string GSTPercentageText { get; set; }
    }

    public class TaxPercentageExportModel
    {
        public int? GSTID { get; set; }
        public decimal? GSTPercentageValue { get; set; }
        public bool? IsActive { get; set; }

    }



    #endregion Tax Percentage ends here
}

public class QuotationServiceTypeMaster
{
    public int? QutServ_ID { get; set; } // Optional for insert actions
    public string Description { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; } // 'I', 'U', 'S'

}

#region Request Model starts here 
//public class RequestModel
//{
//    public string RequestText { get; set; }
//    public string MasterFlag { get; set; }
//}

#endregion Request Model ENDs here

#region Response Model starts here
//public class ResponseModel
//{
//    public string responseText { get; set; }
//}
#endregion Response Model ENDs here

#region supplytype master starts here
public class SuppTypeMaster
{
    public string Code { get; set; }
    public string Description { get; set; }
    public string LongDescription { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
    public long SuppTypeID { get; set; }
}

#endregion supplytype master ends here   

#region tcsloginnew starts here
public class TCSLogicNewMaster
{
    public string BillingTo { get; set; }
    public DateTime? FromDate { get; set; }
    public DateTime? ToDate { get; set; }
    public bool? PANExists { get; set; }
    public bool? AddressOnRecord { get; set; }
    public bool? AgentMasterCountryIN { get; set; }
    public bool? NonResident { get; set; }
    public long TCSRateID { get; set; }
    // public int TCSRate { get; set; }
    public string BlockDetails { get; set; }
    public bool? TANonRecord { get; set; }
    public bool? IsActive { get; set; }
    public bool? TDSDeduction { get; set; }
    public Guid CreatedBy { get; set; }
    public Guid OperationBy { get; set; }

    public string Action { get; set; }
    //public bool Active { get; set; }
    public Guid UpdatedBy { get; set; }
    public int TCSLogicID { get; set; }

    public int? AgentID { get; set; }
    public DateTime? InvoiceDate { get; set; }
    public string BlockdetailsName { get; set; }

    public decimal TCSRate { get; set; } // ✅ Accepts 5 and 5.5


}

#endregion tcsloginnew ends here

# region LegalEntityType starts here
public class LegalEntityTypeMaster
{
    public string LegalEntityType { get; set; } // Represents @LegalEntityType
    public bool IsActive { get; set; } // Represents @IsActive
    public Guid CreatedBy { get; set; } // Represents @CreatedBy
    public Guid OperationBy { get; set; } // Represents @CreatedBy
    public string Action { get; set; } = string.Empty; // Represents @Action
    public int? LegalEntTypeID { get; set; } // Represents @LegalEntTypeID
}
#endregion LegalEntityType ends here

#region LUTMasterData starts here
public class LUTMasterData
{
    public string LUTNumber { get; set; }
    public DateTime? ValidFrom { get; set; }
    public DateTime? ValidTo { get; set; }
    public long? CompanyID { get; set; }
    public long? YearCode { get; set; }
    public bool IsActive { get; set; }
    public Guid? OperationBy { get; set; }
    public string Action { get; set; }
    public string CompnayName { get; set; }
    public int? ID { get; set; }

}


public class LUTMasterDataExcel
{
    public int? ID { get; set; }
    public string LUTNumber { get; set; }
    public DateTime? ValidFrom { get; set; }
    public DateTime? ValidTo { get; set; }
    public bool IsActive { get; set; }
    public string CompanyName { get; set; } // Corrected spelling for Excel export
}
#endregion LUTMasterData ends here

#region AirlineCodeMaster starts here
public class AirlineCodeMaster
{
    public string AirlineCode { get; set; }
    public string AirlineName { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
    public int AirlineID { get; set; }

}
#endregion AirlineCodeMaster ends here

#region AirlineServiceTypemaster starts here
public class AirlineServiceTypemaster
{
    public long AirlineServiceTypeID { get; set; }
    public string AirlineServiceType { get; set; }
    public string ShortCode { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
}
#endregion AirlineServiceTypemaster ends here


#region AirportMaster starts here
public class AirportMaster
{
    public string AirportCode { get; set; }
    public string AirportCityName { get; set; }
    public string AirportName { get; set; }
    public string AirportCountry { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
    public string Airport_Code { get; set; }
    public string Airport_City_Name { get; set; }
    public string Airport_Name { get; set; }
    public string Airport_Country { get; set; }
    public int? ID { get; set; }
}

#endregion AirportMaster ends here


#region employeemaster starts here
public class EmployeeMaster
{
    public int EmpID { get; set; }
    public string EmpCode { get; set; }
    public Guid UserID { get; set; }
    public int? RoleId { get; set; }
    public int SalutationID { get; set; }
    public string Gender { get; set; }
    public string EmpName { get; set; }
    public string Address { get; set; }
    public string Desg_Name { get; set; }
    public string Dept_Name { get; set; }
    public string Country { get; set; }
    public string City { get; set; }
    public string CityIATACode { get; set; }
    public string ResPhoneNo { get; set; }
    public string MobileNo { get; set; }
    public string PersonalEmail { get; set; }
    public string? CompanyID { get; set; } = string.Empty;
    public string CompanyIDs { get; set; }
    public int? CompanyID1 { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public DateTime? DateOfJoining { get; set; }
    public DateTime? DateOfRetirement { get; set; }
    public int? DesignationID { get; set; }
    public string DepartmentID { get; set; }
    public int? ReportHeadID { get; set; }
    public string OffEmail { get; set; }
    public string OffPhone { get; set; }
    public string Pan { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public int? LevelID { get; set; }
    public bool? IsSales { get; set; } = false;
    public string Action { get; set; } = string.Empty;
    public bool IsRemembered { get; set; }
    public int? Level1UID { get; set; }
    public int? Level3UID { get; set; }
    public int? Level2UID { get; set; }
    public int? CreditNoteApp { get; set; }
    public int? AdvancesApp { get; set; }
    public string UserName { get; set; }
    public string Password { get; set; }
    public string? MarketID { get; set; } = string.Empty;
    public string? MarketIDs { get; set; }
    public string? BusinessTypeID { get; set; } = string.Empty;
    public string? BusinessTypeIDs { get; set; }
    public bool ViewRights { get; set; }
    public int YearID { get; set; }
    public bool AsPerAdminRules { get; set; }

    public string AdvancesAppName { get; set; }

    public string CreditNoteAppName { get; set; }

}

#endregion employeemater ends here

#region gstitcmaster starts here
public class GstItcRateMaster
{
    public decimal ITCPercentage { get; set; }
    public decimal RateForSAP { get; set; }
    public bool IsActive { get; set; }
    public Guid CreatedBy { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
    public int? TAXID { get; set; }
}

#endregion gstitcratemaster ends here
#region vendormaster starts here
public class VendorMaster
{
    public string AccCode { get; set; }
    public string VendorCode { get; set; }
    public string VendorName { get; set; }
    public string AccountGroup { get; set; }
    public string CityIATACode { get; set; }
    public string Website { get; set; }
    public string PhoneNo { get; set; }
    public string MobileNo { get; set; }
    public string FaxNo { get; set; }
    public string EmailID { get; set; }
    public string PanNo { get; set; }
    public string STRegNo { get; set; }
    public string ChequeFavouring { get; set; }
    public string BankName { get; set; }
    public string Address { get; set; }
    public string AccountNo { get; set; }
    public bool CreateAdvanceAccount { get; set; }
    public bool? CreditApplicable { get; set; }
    public int? CreditPeriod { get; set; }
    public string CreditCurrencyCode { get; set; }
    public decimal? CreditAmount { get; set; }
    public string CreditApproveBy { get; set; }
    public bool? IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public bool CreateCommissionAccount { get; set; }
    public int? BankAccountID { get; set; }
    public bool IsXML { get; set; }
    public string IFSCCode { get; set; }
    public string SWIFTCode { get; set; }
    public string Comment { get; set; }
    public string BranchName { get; set; }
    public int StateCode { get; set; }
    public bool GSTRequired { get; set; }
    public bool IsActiveSAP { get; set; }
    public string TANDetails { get; set; }
    public string PreviousCode { get; set; }
    public string MSME { get; set; }
    public string Deductee { get; set; }
    public string WithHoldigTax { get; set; }
    public bool XOSupplierNameLogic { get; set; }
    public bool IsActiveMSME { get; set; }
    public string MSMEType { get; set; }
    public DateTime? MSMERegFromDt { get; set; }
    public DateTime? MSMERegToDt { get; set; }
    public string PostalCode { get; set; }
    public string BizPartnerGrp { get; set; }
    public string LegalEntity { get; set; }
    public string LegalName { get; set; }
    public bool IsSEZ { get; set; }
    public string MembershipNo { get; set; }
    public bool NonGSTRegistered { get; set; }
    public bool IsH { get; set; }
    public bool IsT { get; set; }
    public bool IsM { get; set; }
    public bool IsSS { get; set; }
    public bool IsGG { get; set; }
    public bool IsMOT { get; set; }
    public bool IsFS { get; set; }
    public bool IsChange { get; set; }
    public string XOPrintName { get; set; }
    public string Action { get; set; }
    public string Country { get; set; }
    public string StateName { get; set; }

    // Output parameters
    public int VendorID { get; set; }
    public string Operation { get; set; }
    public string VendorSAPCode { get; set; }
    public string IATACode { get; set; }
    public string IATOCode { get; set; }
    public string LegalEntityType { get; set; }
    public int LegalEntTypeID { get; set; }


    public string CountryName { get; set; }

    public string CityName { get; set; }

    public string StateId { get; set; }

    public DateTime OperationOn { get; set; }
    public string PANVERIFICATION { get; set; }
    public string TANVERIFICATION { get; set; }
    public string GSTVERIFICATION { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string TaxType { get; set; }
    public string Contact1 { get; set; }
    public string Contact2 { get; set; }
    public bool Contact1IsMobile { get; set; }
    public bool Contact2IsMobile { get; set; }
    public string BizPartnerGrpName { get; set; }

    public int? PageNumber { get; set; }

    public bool IsSapCompCode { get; set; } = false;


}

#endregion vendormaster ends here

#region vendorcontactdetailtab starts here
public class VendorContactDetailTab
{
    public int? ContactDetailsID { get; set; }
    public DateTime? DateofBirth { get; set; }
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
    public string CityIATACode { get; set; }
    public string CityName { get; set; }
    public bool? IsActive { get; set; }
    public bool? IsAccStatement { get; set; }
    public bool? IsCC { get; set; } = false;
    public bool? IsForContracting { get; set; } = false;
    public bool? IsBills { get; set; } = false;
    public Guid? CreatedBy { get; set; }
    public Guid? OperationBy { get; set; }
    public string Action { get; set; }
}
#endregion vendorcontactdetailstab ends here
#region gstpercentagemaster starts here
public class GSTPercentageMaster
{
    public int? GSTID { get; set; }
    public decimal GSTPercentage { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
}
#endregion gstpercentagemaster ends here

#region WithholdingTax starts here
public class WithholdingTaxMaster
{
    public int? Tax_ID { get; set; }
    public string Tax_Code { get; set; }
    public string Description { get; set; }
    public bool? IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
}
#endregion WithholdingTax ends here

#region PlaceOfSupplyLogic starts here
public class PlaceOfSupplyLogic
{
    public int? ID { get; set; } // Nullable for update scenarios
    public int TypeID { get; set; }
    public int ServiceID { get; set; }
    public int BuyerLocationID { get; set; }
    public bool IsGST { get; set; }
    public int IsAddress { get; set; }
    public int ServiceLocID { get; set; }
    public int POSID { get; set; }
    public int POSStateCode { get; set; }
    public bool IsCommercial { get; set; }
    public bool IsActive { get; set; }
    public Guid CreatedBy { get; set; }
    public DateTime? ValidFrom { get; set; }
    public DateTime? ValidTo { get; set; }
    public string Action { get; set; }
}
#endregion PlaceOfSupplyLogic ends here

#region GstType starts here
public class GSTTypeMaster
{
    public int? GSTID { get; set; }
    public string GstTypename { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }

    public string Action { get; set; }
}

public class GSTTypeMasterExportModel
{
    public int? GSTID { get; set; }
    public string GSTTypeName { get; set; }
    public bool IsActive { get; set; }
}

#endregion GstType ends here

#region TCSRateConfig starts here
public class TCSRateConfig
{
    public string BillingTo { get; set; }
    public string FromDate { get; set; }
    public string ToDate { get; set; }
    public bool PANExists { get; set; }
    public bool AddressonRecord { get; set; }
    public bool AgentMasterCountryIN { get; set; }
    public bool Resident { get; set; }
    public long TCSRateID { get; set; }
    public int ViewDetailsID { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
    public Guid? Updatedby { get; set; }
    public int? TCSRateConfigID { get; set; }
    public bool TDSDeduction { get; set; }
    public decimal TCSRate { get; set; }
}

#endregion TCSRateConfig ends here

#region lockdate starts here

public class LockDateMaster
{
    public string Year { get; set; }
    public int MonthID { get; set; }
    public int LockDate { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
    public string MonthName { get; set; }
    public int LockTillDate { get; set; }
}

#endregion lockdate ends here

#region itienaryinclusionexclusion starts here
public class ItineraryInclusionsExclusions
{
    public int ID { get; set; }
    public string Country_IATACode { get; set; }
    public string City_IATACode { get; set; }
    public string Type { get; set; }
    public string Header { get; set; }
    public string Description { get; set; }
    public bool? IsActive { get; set; }
    public bool? IsDefault { get; set; }
    public string SeqNo { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
    public string CountryName { get; set; }
    public string CityName { get; set; }
}

#endregion itienaryinclusionexclusion ends here

#region legalentity starts here
public class LegalEntityMasterModel
{
    public string LegalName { get; set; }
    public string RegisteredAddress { get; set; }
    public string CountryOfRegistration { get; set; }
    public string CountryName { get; set; }
    public string CountryIATACode { get; set; }
    public string PostalCode { get; set; }
    public string SAPCompCode { get; set; }
    public string CIN { get; set; }
    public string PAN { get; set; }
    public string TAN { get; set; }
    public string VAT { get; set; }
    public string TRN { get; set; }
    public string MSMENo { get; set; }
    public string RegisteredEmail { get; set; }
    public string TwoCharacterCompCode { get; set; }
    public bool IsActive { get; set; }
    public int OperationBy { get; set; }
    public int ID { get; set; }
    public string Action { get; set; } = "";
    public int Fiscal_ID { get; set; }
    public string TIDS_Code { get; set; }
    public string IATA_Code { get; set; }
    public string IATO_Code { get; set; }
}
#endregion legalentity ends here

#region EMPLOYEEMASTER STARTS HERE
public class EmployeeTarget
{
    public int? EmployeeTargetID { get; set; }
    public int? EmpID { get; set; }
    public int? CompanyID { get; set; }
    public string StaffName { get; set; }
    public int? YearID { get; set; }
    public string YearCode { get; set; }
    public string Currency { get; set; }
    public int? CurrencyID { get; set; }
    public string Type { get; set; }
    public decimal Apr_Topline { get; set; }
    public decimal Apr_GOP { get; set; }
    public decimal May_Topline { get; set; }
    public decimal May_GOP { get; set; }
    public decimal Jun_Topline { get; set; }
    public decimal Jun_GOP { get; set; }
    public decimal Jul_Topline { get; set; }
    public decimal Jul_GOP { get; set; }
    public decimal Aug_Topline { get; set; }
    public decimal Aug_GOP { get; set; }
    public decimal Sep_Topline { get; set; }
    public decimal Sep_GOP { get; set; }
    public decimal Oct_Topline { get; set; }
    public decimal Oct_GOP { get; set; }
    public decimal Nov_Topline { get; set; }
    public decimal Nov_GOP { get; set; }
    public decimal Dec_Topline { get; set; }
    public decimal Dec_GOP { get; set; }
    public decimal Jan_Topline { get; set; }
    public decimal Jan_GOP { get; set; }
    public decimal Feb_Topline { get; set; }
    public decimal Feb_GOP { get; set; }
    public decimal Mar_Topline { get; set; }
    public decimal Mar_GOP { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }
    public int? ID { get; set; }
    public string CurrencyCode { get; set; }
    public string Operation { get; set; }
    public DateTime? OperationOn { get; set; }
    public string UpdatedBy { get; set; }
    public DateTime? UpdatedOn { get; set; }
    public string Department { get; set; }
    public string EmpCode { get; set; }
    public int? SalutationID { get; set; }
    public string Gender { get; set; }
    public string EmpName { get; set; }
    public string Address { get; set; }
    public string CityIATACode { get; set; }
    public string ResPhoneNo { get; set; }
    public string MobileNo { get; set; }
    public string PersonalEmail { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public DateTime? DateOfJoining { get; set; }
    public DateTime? DateOfRetirement { get; set; }
    public int? DesignationID { get; set; }
    public int? DepartmentID { get; set; }
    public int? ReportHeadID { get; set; }
    public string OffEmail { get; set; }
    public string OffPhone { get; set; }
    public string Pan { get; set; }
    public bool IsActive { get; set; }
    public int? OldID { get; set; }
    public int? LevelID { get; set; }
    public bool IsSales { get; set; }
    public string UserName { get; set; }
    public string Password { get; set; }
    public bool IsLockedOut { get; set; }
    public DateTime? CreateDate { get; set; }
    public DateTime? LastLoginDate { get; set; }
    public int? FailedPasswordAttemptCount { get; set; }
    public int? RoleId { get; set; }
    public bool IsRemembered { get; set; }
    public int? UserID { get; set; }
    public long? FiscalYear { get; set; }
  
}

#endregion EMPLOYEEMASTER ENDS HERE

#region gststatus starts here
public class GSTstatusMaster
{
    public int State_ID { get; set; }
    public string State { get; set; }
    public int Status_ID { get; set; }
    public string Status { get; set; }
    public string EffectiveDate { get; set; }
    public Guid OperationBy { get; set; }

    public string Action { get; set; }
    public int? ID { get; set; }

    public string Status_ID_2 { get; set; }
}
#endregion gststatus ends here

#region ItineraryDescription STARTS HERE
public class ItineraryDescription
{
    public int ItineraryDescID { get; set; }
    public string ItineraryCode { get; set; }
    public string Country_IATACode { get; set; }
    public string CountryName { get; set; }
    public string City2_IATACode { get; set; }
    public string City2Name { get; set; }
    public string City_IATACode { get; set; }
    public string CityName { get; set; }
    public string Header { get; set; }
    public string ShortDescription { get; set; }
    public string DetailDescription { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public string Action { get; set; }

}
#endregion ItineraryDescription ENDS HERE

#region entitymaster starts here 
public class EntityMasterModel
{
    public string LegalName { get; set; }
    public string RegisteredAddress { get; set; }
    public string CountryOfRegistration { get; set; }
    public string CountryName { get; set; }
    public string PostalCode { get; set; }
    public string SAPCompCode { get; set; }
    public string CIN { get; set; }
    public string PAN { get; set; }
    public string TAN { get; set; }
    public string VAT { get; set; }
    public string TRN { get; set; }
    public string MSMENo { get; set; }
    public string RegisteredEmail { get; set; }
    public string TwoCharacterCompCode { get; set; }
    public bool IsActive { get; set; }
    public Guid OperationBy { get; set; }
    public int ID { get; set; }
    public string Action { get; set; } = "";
    public int Fiscal_ID { get; set; }
    public string TIDS_Code { get; set; }
    public string IATA_Code { get; set; }
    public string IATO_Code { get; set; }
    public string TaxType { get; set; }
    public string SalesTaxRegNumber { get; set; }

    public int? PageNumber { get; set; }

}
#endregion entitymaster ends here

#region agentbranchmapping starts here
public class AgentBranchMapping
{
    public int AgentBranchID { get; set; }
    public string AgentID { get; set; }
    public string BranchName { get; set; }
    public string Action { get; set; }
    public Guid? OperationBy { get; set; }
}

#endregion agentbranchmapping ends here

#region PreviousCodeTagging starts here
public class PreviousCodeTagging
{
    public int AgentID { get; set; }
    public string AgentCode { get; set; }
    public bool IsActive { get; set; }
    public int IsVendorAgentHotel { get; set; }
}

#endregion PreviousCodeTagging ends here

#region otherstervictax starts here
public class OtherServiceTax
{
    public int? TaxID { get; set; }
    public string TaxCode { get; set; }
    public string TaxDescription { get; set; }
    public decimal? TaxRate { get; set; }
    public string Action { get; set; }
    public Guid? OperationBy { get; set; }
}

#endregion otherservicetax ends here

#region Withholding_Tax starts here
public class Withholding_Tax
{
    public bool Active { get; set; }
    public int Tax_ID { get; set; }
    public string Tax_Code { get; set; }
    public string Description { get; set; }
    public bool IsActive { get; set; }
    public string Operation { get; set; }
    public Guid CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; }
    public Guid UpdatedBy { get; set; }
    public DateTime UpdatedOn { get; set; }
}
#endregion Withholding_Tax starts here


#region SapCompCode Started
public class SapCompCode
{
    public string SAPCompCode { get; set; }
    public int ID { get; set; }
    public string Action { get; set; }
    public bool IsActive { get; set; }


}
#endregion SapCompCode END



public class ItineraryDescDetails
{
    public int ItineraryDescID { get; set; }
    public int ServiceType { get; set; }
    public int ServiceID { get; set; }
    public string Action { get; set; }


}

//public class CustomerMaster
//{
//    public int LeadID { get; set; } //

//    public string CustomerCode { get; set; }//
//    public int? ContactID { get; set; }

//    public string FullName { get; set; }//
//    public string IsPrimaryContact { get; set; }
//    public int? PrimaryContactID { get; set; }
//    public string Reference { get; set; }
//    public string RelationToPrimaryContact { get; set; }
//    public string Gender { get; set; }//
//    public string Surname { get; set; }
//    public string Email { get; set; }//
//    public string AlternateEmail { get; set; }
//    public string Mobile { get; set; }//
//    public string AlternateMobile { get; set; }
//    public string Address { get; set; }//
//    public string Country { get; set; }//
//    public int StateID { get; set; }//
//    public string StateCode { get; set; }//
//    public string CityID { get; set; }//
//    public string PostalCode { get; set; }//
//    public int NationalityID { get; set; }//
//    public DateTime? DateOfBirth { get; set; }//
//    public string PassportNo { get; set; }//
//    public string FirstName { get; set; }
//    public string LastName { get; set; }
//    public DateTime? PassportDateOfIssue { get; set; }
//    public string PassportPlaceOfIssue { get; set; }
//    public DateTime? PassportDateOfExpiry { get; set; }
//    public string PAN { get; set; }
//    public string PANName { get; set; }
//    public string TAN { get; set; }
//    public int MealPlanID { get; set; }
//    public string Allergies { get; set; }
//    //public bool? Promotions { get; set; } = true;
//    public string SpecialRequirements { get; set; }
//    public string SeniorCitizen { get; set; }
//    public string Tags { get; set; }
//    public string CustomerCategory { get; set; }
//    public string Organization { get; set; }
//    public string Designation { get; set; }

//    public int TamSalesRep { get; set; }

//    public string FlightClassPreference { get; set; }
//    public bool IsCustomer { get; set; }
//    public string Action { get; set; }
//}

public class customermasterexcel
{
    public string CountryName { get; set; }

    public string? LeadID { get; set; }

    //[Required]
    public string? CustomerCode { get; set; }

    [Required(ErrorMessage = "Full Name is required.")]
    public string FullName { get; set; }

    [Required(ErrorMessage = "Gender is required.")]
    [RegularExpression("^(M|F|X)$", ErrorMessage = "Gender must be 'M', 'F' or 'X'.")]
    public string Gender { get; set; }

    [Required(ErrorMessage = "Email ID is required.")]
    [EmailAddress]
    public string Email { get; set; }

    [Required(ErrorMessage = "Mobile No. is required.")]
    public string Mobile { get; set; }

    public int? SalesRep { get; set; }

    [Required(ErrorMessage = "Address is required.")]
    public string Address { get; set; }

    //[Required(ErrorMessage = "Country is required.")]
    public string Country { get; set; }

    //[Required(ErrorMessage = "State is required.")]

    //[Required(ErrorMessage = "City is required.")]

    public string StateCode { get; set; }

    [Required(ErrorMessage = "Postal Code is required.")]
    public string PostalCode { get; set; }

    [DataType(DataType.Date)]
    public DateTime? DateOfBirth { get; set; }

    /*public int? CurrentAge
    {
        get
        {
            if (DateOfBirth.HasValue)
            {
                var today = DateTime.Today;
                int age = today.Year - DateOfBirth.Value.Year;
                if (DateOfBirth.Value.Date > today.AddYears(-age)) age--;
                return age;
            }
            return null;
        }
    }*/

    public int? CurrentAge { get; set; }

    public string PassportNo { get; set; }

    public string FirstName { get; set; }
    public string LastName { get; set; }

    [DataType(DataType.Date)]
    public DateTime? PassportDateOfIssue { get; set; }
    public string PassportPlaceOfIssue { get; set; }

    [DataType(DataType.Date)]
    public DateTime? PassportDateOfExpiry { get; set; }


    public string PAN { get; set; }
    public string PANName { get; set; }
    public string TAN { get; set; }

    //[Required(ErrorMessage = "Meal Preference is required.")]
    //[RegularExpression("^(Veg|Non-Veg|Vegan|Jain)$", ErrorMessage = "Meal Preference must be Veg, Non-Veg, Vegan or Jain.")]
    public int? MealPlanID { get; set; }

    public string Allergies { get; set; }
    public string SpecialRequirements { get; set; }

    [Required(ErrorMessage = "Senior Citizen flag is required.")]
    [RegularExpression("^(Y|N)$", ErrorMessage = "Senior Citizen must be 'Y' or 'N'.")]
    public string SeniorCitizen { get; set; }
    public string Organization { get; set; }
    public string Designation { get; set; }

    public string FlightClassPreference { get; set; }
    public string Refererralname { get; set; }

    // Customer Type (HNI or Retail)
    [Required(ErrorMessage = "Customer Type is required.")]
    [RegularExpression("^(HNI|Retail)$", ErrorMessage = "Customer Type must be HNI or Retail.")]
    public string CustomerType { get; set; }

    public int? SaleRep { get; set; }

    public string PassportDoc { get; set; }  // Mandatory if PassportNo is given
    public string PANDoc { get; set; }       // Mandatory if PAN is given
    public string TANDoc { get; set; }       // Mandatory if TAN is given

    public string SAPCompCode { get; set; }

    public string Action { get; set; }
    public string CityName { get; set; }
    public bool IsCustomer { get; set; }

    public string StateName { get; set; }
}

public class CustomerMaster
{
    //[Required]
    public string CountryName { get; set; }

    public string? LeadID { get; set; }

    //[Required]
    public string? CustomerCode { get; set; }

    [Required(ErrorMessage = "Full Name is required.")]
    public string FullName { get; set; }

    [Required(ErrorMessage = "Gender is required.")]
    [RegularExpression("^(M|F|X)$", ErrorMessage = "Gender must be 'M', 'F' or 'X'.")]
    public string Gender { get; set; }

    [Required(ErrorMessage = "Email ID is required.")]
    [EmailAddress]
    public string Email { get; set; }

    [Required(ErrorMessage = "Mobile No. is required.")]
    public string Mobile { get; set; }

    public int? SalesRep { get; set; }

    [Required(ErrorMessage = "Address is required.")]
    public string Address { get; set; }

    //[Required(ErrorMessage = "Country is required.")]
    public string Country { get; set; }

    //[Required(ErrorMessage = "State is required.")]
    public int StateID { get; set; }

    //[Required(ErrorMessage = "City is required.")]
    public string CityID { get; set; }

    public string StateCode { get; set; }

    [Required(ErrorMessage = "Postal Code is required.")]
    public string PostalCode { get; set; }

    [Required(ErrorMessage = "Nationality is required.")]
    public int? NationalityID { get; set; }

    [DataType(DataType.Date)]
    public DateTime? DateOfBirth { get; set; }

    /*public int? CurrentAge
    {
        get
        {
            if (DateOfBirth.HasValue)
            {
                var today = DateTime.Today;
                int age = today.Year - DateOfBirth.Value.Year;
                if (DateOfBirth.Value.Date > today.AddYears(-age)) age--;
                return age;
            }
            return null;
        }
    }*/

    public int? CurrentAge { get; set; }

    public string PassportNo { get; set; }

    public string FirstName { get; set; }
    public string LastName { get; set; }

    [DataType(DataType.Date)]
    public DateTime? PassportDateOfIssue { get; set; }
    public string PassportPlaceOfIssue { get; set; }

    [DataType(DataType.Date)]
    public DateTime? PassportDateOfExpiry { get; set; }


    public string PAN { get; set; }
    public string PANName { get; set; }
    public string TAN { get; set; }

    //[Required(ErrorMessage = "Meal Preference is required.")]
    //[RegularExpression("^(Veg|Non-Veg|Vegan|Jain)$", ErrorMessage = "Meal Preference must be Veg, Non-Veg, Vegan or Jain.")]
    public int? MealPlanID { get; set; }

    public string Allergies { get; set; }
    public string SpecialRequirements { get; set; }

    [Required(ErrorMessage = "Senior Citizen flag is required.")]
    [RegularExpression("^(Y|N)$", ErrorMessage = "Senior Citizen must be 'Y' or 'N'.")]
    public string SeniorCitizen { get; set; }
    public string Organization { get; set; }
    public string Designation { get; set; }

    public string FlightClassPreference { get; set; }
    public string Refererralname { get; set; }

    // Customer Type (HNI or Retail)
    [Required(ErrorMessage = "Customer Type is required.")]
    [RegularExpression("^(HNI|Retail)$", ErrorMessage = "Customer Type must be HNI or Retail.")]
    public string CustomerType { get; set; }

    public int? SaleRep { get; set; }

    public string PassportDoc { get; set; }  // Mandatory if PassportNo is given
    public string PANDoc { get; set; }       // Mandatory if PAN is given
    public string TANDoc { get; set; }       // Mandatory if TAN is given

    public string SAPCompCode { get; set; }

    public string Action { get; set; }
    public string CityName { get; set; }
    public bool IsCustomer { get; set; }
    public int CID { get; set; }
    public Guid? OperationBy { get; set; }
    public int? ID { get; set; }
    public string StateName { get; set; }
    public int? State_ID { get; set; }
    public string CityIATACode { get; set; }
    public string CountryIATACode { get; set; }
    public int? MealPlanId { get; set; }
    public long? StateCodeID { get; set; }
}