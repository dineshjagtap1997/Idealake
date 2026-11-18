using CommonClass;
namespace BusinessLogic.Interface
{
    public interface ILevel2Repository
    {
        Task<ResponseModel> AgentMaster(RequestModel request);
        Task<ResponseModel> AgentContactDetailsTab(RequestModel request);
        Task<ResponseModel> AgentSAPCompCode(RequestModel request);
        Task<ResponseModel> LockDateMaster(RequestModel request);
        Task<ResponseModel> StateCodeMaster(RequestModel request);
        Task<ResponseModel> VendorMaster(RequestModel request);
        Task<ResponseModel> VendorContactDetailsTab(RequestModel request);

        Task<ResponseModel> TCSRateMaster(RequestModel request);
        Task<ResponseModel> ACMaster(RequestModel request);
        Task<ResponseModel> VSMaster(RequestModel request);
        Task<ResponseModel> SLMaster(RequestModel request);
        Task<ResponseModel> IDMaster(RequestModel request);
        Task<ResponseModel> LegalTypeMaster(RequestModel request);
        Task<ResponseModel> TaxPercentage(RequestModel request);
        Task<ResponseModel> QuotationServiceTypeMaster(RequestModel request);

        //   Task<ResponseModel> SuppTypeMaster(RequestModel request);

        //Task<ResponseModel> GetAgentMasterForExport(RequestModel request);

        Task<ResponseModel> HOTELCODE(RequestModel request);
        Task<ResponseModel> HotelMaster(RequestModel request);

        Task<ResponseModel> HotelRoomCategoryTab(RequestModel request);

        Task<ResponseModel> HotelContactDetailsTab(RequestModel request);

        Task<ResponseModel> HotelRuleTab(RequestModel request);

        Task<ResponseModel> CompanyMaster(RequestModel request);

        Task<ResponseModel> TCSLogicNewMaster(RequestModel request);

        Task<ResponseModel> PreviousCodeTagging(RequestModel request);

        //Task<ResponseModel> LegalEntityTypeMaster(RequestModel request);

        Task<ResponseModel> LUTMasterData(RequestModel request);

        Task<ResponseModel> AirlineCodeMaster(RequestModel request);

        Task<ResponseModel> AirlineServiceTypemaster(RequestModel request);

        Task<ResponseModel> AirportMaster(RequestModel request);

        Task<ResponseModel> GstItcRateMaster(RequestModel request);

        Task<ResponseModel> EmployeeMaster(RequestModel request);

        Task<ResponseModel> GSTPercentageMaster(RequestModel request);

        Task<ResponseModel> WithholdingTaxMaster(RequestModel request);

        Task<ResponseModel> SupplyTypeMaster(RequestModel request);

        Task<ResponseModel> PlaceOfSupplyLogic(RequestModel request);

        Task<ResponseModel> GSTTypeMaster(RequestModel request);

        Task<ResponseModel> TCSRateConfig(RequestModel request);

        Task<ResponseModel> HotelSAPCompCode(RequestModel request);

        Task<ResponseModel> HotelAnnouncement(RequestModel request);

        //Task<ResponseModel> LegalEntityMasterModel(RequestModel request);
        Task<ResponseModel> ItineraryInclusionsExclusions(RequestModel request);

        Task<ResponseModel> EmployeeTarget(RequestModel request);

        Task<ResponseModel> GSTstatusMaster(RequestModel request);

        Task<ResponseModel> ItineraryDescription(RequestModel request);

        Task<ResponseModel> EntityMasterModel(RequestModel request);

        Task<ResponseModel> AgentBranchMapping(RequestModel request);

        Task<ResponseModel> OtherServiceTax(RequestModel request);
        Task<ResponseModel> Withholding_Tax(RequestModel request);
        Task<ResponseModel> SapCompCode(RequestModel request);
        Task<ResponseModel> SearchAgentLinkedDocuments(RequestModel request);
        Task<ResponseModel> SearchHotelLinkedDocuments(RequestModel request);

        Task<ResponseModel> SearchVendorLinkedDocuments(RequestModel request);

        Task<ResponseModel> CustomerLinkedDocuments(RequestModel request);
        Task<ResponseModel> ItineraryDescDetails(RequestModel request);

        Task<ResponseModel> CustomerMaster(RequestModel request);
        //Task<ResponseModel> GstItcRate(RequestModel request);
        //Task<ResponseModel> GSTMaster(RequestModel request);
        //Task<ResponseModel> BankAccountsMaster(RequestModel request);
        //Task<ResponseModel> TransportServices(RequestModel request);
        //Task<ResponseModel> Monument(RequestModel request);
        //Task<ResponseModel> GuideMaster(RequestModel request);
        //Task<ResponseModel> VehicleCategoryMaster(RequestModel request);
        //Task<ResponseModel> AgentMarkup(RequestModel request);
        //Task<ResponseModel> OpenPeriodMaster(RequestModel request);
        //Task<ResponseModel> ServiceLocationMaster(RequestModel request);
    }
}
