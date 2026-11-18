using CommonClass;

namespace TamarindAstraMasters.Interface
{
    public interface ILevel1Repository
    {
        // Task<ResponseViewModel<CountryMaster>>CountryMaster(CountryMaster countryMaster);
        Task<ResponseModel> CountryMaster(RequestModel request);
        Task<ResponseModel> StateMaster(RequestModel request);
        Task<ResponseModel> CityMaster(RequestModel request);
        Task<ResponseModel> MarketMaster(RequestModel request);
        Task<ResponseModel> CountryMarketMappingMaster(RequestModel request);
        Task<ResponseModel> ClassTypeMaster(RequestModel request);
        Task<ResponseModel> TransportServiceMaster( RequestModel request);
        Task<ResponseModel> GuideServiceMaster(RequestModel request); 
        Task<ResponseModel> SpecialServiceMaster(RequestModel request); 
        Task<ResponseModel> MonumentMaster(RequestModel request); 
        
        // Task<ResponseViewModel<MonumentMaster>> MonumentMaster( MonumentMaster monumentMaster);
        Task<ResponseModel> HotelRatingMaster(RequestModel request);
        Task<ResponseModel> RoomCategoryMaster(RequestModel request);
        Task<ResponseModel> MealPlanMaster(RequestModel request);
        Task<ResponseModel> HotelRateTypeMaster(RequestModel request);
        Task<ResponseModel> RuleGroupMaster(RequestModel request);
        Task<ResponseModel> RuleHeadersMaster(RequestModel request);
        Task<ResponseModel> DepartmentMaster(RequestModel request);
        Task<ResponseModel> DesignationMaster(RequestModel request);
        Task<ResponseModel> VehicleTypeMaster(RequestModel request);
        //Task<string> VehicleMaster(RequestModel request);
        Task<ResponseModel> GuideInfoMaster(RequestModel request);
        Task<ResponseModel> LanguageMaster(RequestModel request);
        Task<ResponseModel> NationalityMaster(RequestModel request);
        ////Task<ResponseViewModel<ServiceTaxNewMaster>> ServiceTaxNewMaster(ServiceTaxNewMaster serviceTaxNewMaster);
        Task<ResponseModel> FacilityInformationMaster(RequestModel request);
        Task<ResponseModel> LocationMaster(RequestModel request);
        Task<ResponseModel> ZoneMaster(RequestModel request);
        Task<ResponseModel> HeaderMaster(RequestModel request);   
        Task<ResponseModel> LandMarksMaster(RequestModel request);
        Task<ResponseModel> TransferMaster(RequestModel request);
        Task<ResponseModel> HotelPreferredMaster(RequestModel request); 

        //added by shubham
        Task<ResponseModel> XORemarksMaster(RequestModel request);

        Task<ResponseModel>AgentMarkupMaster(RequestModel request);
        //Task<string> DestinationHeaderMaster(RequestModel request);
        //Task<string> DestinationDetailsMaster(RequestModel request);
        Task<ResponseModel> SalutationMaster(RequestModel request);
        Task<ResponseModel> YearMaster(RequestModel request);
        Task<ResponseModel> CurrencyMaster(RequestModel request);
        //Task<ResponseModel>
        //Master(RequestModel request);
        Task<ResponseModel> OtherTaxesMaster(RequestModel request);
        Task<ResponseModel> SACMaster(RequestModel request);
        Task<ResponseModel> ServiceTaxNewMaster(RequestModel request);
        Task<ResponseModel> OtherServiceTaxNewMaster(RequestModel request);
        Task<ResponseModel> BankMaster(RequestModel request);
        Task<ResponseModel> BusinessTypeMaster(RequestModel request);


        Task<ResponseModel>BankAccountsMaster(RequestModel request);
  
        Task<ResponseModel> ModeOfTravelMaster(RequestModel request);
        Task<ResponseModel> CurrencyConversionMaster(RequestModel request);

        Task<ResponseModel> HotelTypeMaster (RequestModel request);

        Task<ResponseModel> BizPartnerGroupMaster(RequestModel request);
        Task<ResponseModel> AgentCategoryMaster(RequestModel request);
        Task<ResponseModel> MSMEType(RequestModel request);
        Task<ResponseModel> AgentGroupMaster(RequestModel request);
        Task<ResponseModel> VendorPreferred(RequestModel request);
        Task<ResponseModel> SelectFiscalVariant(RequestModel request);
        Task<ResponseModel> GetAgentCategoryMaster(RequestModel request);
        Task<ResponseModel> New_CurrencyMaster(RequestModel request);
        Task<List<ResponseModel>> New_CurrencyConversion(RequestModel request);
        Task<ResponseModel> Destination_Master(RequestModel request);
        Task<ResponseModel> ItineraryNotes(RequestModel request);
        Task<ResponseModel> ItineraryInclusions(RequestModel request);
        Task<ResponseModel> ItineraryExclusions(RequestModel request);

        //Task<ResponseModel> AgentCategoryMaster(RequestModel request);
        //Task<ResponseModel> MSMEType(RequestModel request);
        //ended by shubham

        Task<ResponseModel> SearchHotelCity(RequestModel request);
        Task<ResponseModel> BankMasterdetail(RequestModel request);

        Task<ResponseModel> LockFileCodeXoRequestModel(RequestModel request);

    }
}
