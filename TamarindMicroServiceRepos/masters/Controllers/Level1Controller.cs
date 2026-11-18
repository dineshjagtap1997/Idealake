using CommonClass;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TamarindAstraMasters.Interface;

namespace TamarindAstra.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class Level1Controller : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly ILevel1Repository _level1;
        private readonly ILogger<Level1Controller> _logger;


        public Level1Controller(IConfiguration config, ILevel1Repository level1, ILogger<Level1Controller> logger)
        {
            _config = config;
            _level1 = level1;
            _logger = logger;
        }

        #region State starts here
        //[
        //
        //]
        [HttpPost("StateMaster")]
        public async Task<ResponseModel> StateMaster(RequestModel request)
        {
            return await _level1.StateMaster(request);
        }
        #endregion State ends here

        #region City starts here
        [Authorize]
        [HttpPost("CityMaster")]
        //[HttpPost]
        public async Task<ResponseModel> CityMaster(RequestModel request)
        {
            return await _level1.CityMaster(request);
        }
        #endregion City ends here

        #region Country starts here
        [Authorize]
        [HttpPost("CountryMaster")]
        public async Task<ResponseModel> CountryMaster(RequestModel request)
        {
            return await _level1.CountryMaster(request);
        }
        #endregion Country ends here

        #region marketmaster starts here
        [Authorize]
        [HttpPost("MarketMaster")]
        public async Task<ResponseModel> MarketMaster(RequestModel request)
        {
            return await _level1.MarketMaster(request);
        }

        #endregion marketmaster ends here



        #region Department starts here
        [Authorize]
        [HttpPost("DepartmentMaster")]
        public async Task<ResponseModel> DepartmentMaster(RequestModel request)
        {
            return await _level1.DepartmentMaster(request);
        }
        #endregion Department ends here



        #region designation starst here
        [Authorize]
        [HttpPost("DesignationMaster")]
        public async Task<ResponseModel> DesignationMaster(RequestModel request)
        {
            return await _level1.DesignationMaster(request);

        }
        #endregion designation ends here

        #region Vehicletype starts here
        [Authorize]
        [HttpPost("VehicleTypeMaster")]

        public async Task<ResponseModel> VehicleTypeMaster(RequestModel request)
        {
            return await _level1.VehicleTypeMaster(request);

        }

        #endregion vehicletype ends here


        //#region vehicle starts here
        //[HttpPost("VehicleMaster")]

        //public async Task<ActionResult> VehicleMaster(RequestModel request)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }

        //    var result = await _level1.VehicleMaster(request);
        //    return Ok(result);
        //}

        //#endregion vehicle ends here

        #region guideinfomaster starts here
        [Authorize]
        [HttpPost("GuideInfoMaster")]

        public async Task<ResponseModel> GuideInfoMaster(RequestModel request)
        {
            return await _level1.GuideInfoMaster(request);

        }


        #endregion  guideinfomaster ends here

        #region LanguageMaster starts here
        [Authorize]
        [HttpPost("LanguageMaster")]
        public async Task<ResponseModel> LanguageMaster(RequestModel request)
        {
            return await _level1.LanguageMaster(request);
        }
        #endregion LanguageMaster ends here


        #region Nationalitymaster STARTS HERE
        [Authorize]
        [HttpPost("NationalityMaster")]
        public async Task<ResponseModel> NationalityMaster(RequestModel request)
        {
            return await _level1.NationalityMaster(request);
        }

        #endregion Nationalitymaster ends here

        #region Country_Market_Mapping starts here
        [Authorize]
        [HttpPost("CountryMarketMapping")]
        public async Task<ResponseModel> CountryMarketMappingMaster(RequestModel request)
        {
            return await _level1.CountryMarketMappingMaster(request);
        }
        #endregion Country_Market_Mapping ends here

        #region Monument starts here
        [Authorize]
        [HttpPost("MonumentMaster")]
        public async Task<ResponseModel> MonumentMaster(RequestModel request)
        {
            return await _level1.MonumentMaster(request);
        }
        #endregion Monument starts here

        #region ClassType starts here
        [Authorize]
        [HttpPost("ClassTypeMaster")]
        public async Task<ResponseModel> ClassTypeMaster(RequestModel request)
        {
            return await _level1.ClassTypeMaster(request);
        }
        #endregion ClassType starts here


        #region facilityinformation starts here
        [Authorize]
        [HttpPost("FacilityInformationMaster")]
        public async Task<ResponseModel> FacilityInformationMaster(RequestModel request)
        {
            return await _level1.FacilityInformationMaster(request);
        }

        #endregion facilityinformation ends here


        #region locationmaster


        [HttpPost("LocationMaster")]
        public async Task<ResponseModel> LocationMaster(RequestModel request)
        {
            return await _level1.LocationMaster(request);
        }
        #endregion locationmaster

        #region Zonemater starts here
        [Authorize]
        [HttpPost("ZoneMaster")]
        public async Task<ResponseModel> ZoneMaster(RequestModel request)
        {
            return await _level1.ZoneMaster(request);
        }
        #endregion zonemaster ends here

        #region headermaster starts here
        [Authorize]
        [HttpPost("HeaderMaster")]
        public async Task<ResponseModel> HeaderMaster(RequestModel request)
        {
            return await _level1.HeaderMaster(request);

        }
        #endregion headermaster ends here

        #region landmark start here
        [Authorize]
        [HttpPost("landMarksMaster")]
        public async Task<ResponseModel> LandMarksMaster(RequestModel request)
        {
            return await _level1.LandMarksMaster(request);
        }
        #endregion landmark ends here

        #region transfermaster start here
        [Authorize]
        [HttpPost("TransferMaster")]
        public async Task<ResponseModel> TransferMaster(RequestModel request)
        {
            return await _level1.TransferMaster(request);
        }
        #endregion transfermaster ends here

        #region Agentgroup starts here
        [HttpPost("AgentGroupMaster")]
        public async Task<ActionResult> AgentGroupMaster(RequestModel request)
        {
            var data = await _level1.AgentGroupMaster
                (request);
            return Ok(data);
        }
        #endregion agentgroup ends here



        #region XORemarks starts here
        [Authorize]
        [HttpPost("XORemarks")]
        public async Task<ResponseModel> XORemarksMaster(RequestModel request)
        {
            return await _level1.XORemarksMaster(request);

        }
        #endregion XORemarks ends here

        //#region Destination Header starts here
        //[HttpPost("DestinationHeader")]
        //public async Task<ActionResult> DestinationHeaderMaster(RequestModel request)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }

        //    var result = await _level1.DestinationHeaderMaster(request);
        //    return Ok(result);
        //}
        //#endregion Destination Header ends here

        //#region Destination Details starts here
        //[HttpPost("DestinationDetailsMaster")]
        //public async Task<ActionResult> DestinationDetailsMaster(RequestModel request)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }

        //    var result = await _level1.DestinationDetailsMaster(request);
        //    return Ok(result);
        //}
        //#endregion Destination Details ends here

        #region Salutation starts here
        [Authorize]
        [HttpPost("SalutationMaster")]
        public async Task<ResponseModel> SalutationMaster(RequestModel request)
        {
            return await _level1.SalutationMaster(request);

        }
        #endregion Salutation ends here

        #region Year starts here
        //[Authorize]
        [HttpPost("YearMaster")]
        public async Task<ResponseModel> YearMaster(RequestModel request)
        {
            return await _level1.YearMaster(request);

        }
        #endregion Year ends here

        #region CurrencyMaster starts here
        [HttpPost("CurrencyMaster")]
        public async Task<ResponseModel> CurrencyMaster(RequestModel request)
        {
            return await _level1.CurrencyMaster(request);
        }
        #endregion CurrencyMaster ends here

        #region CurrencyConversionMaster starts here
        [HttpPost("CurrencyConversionMaster")]
        public async Task<ResponseModel> CurrencyConversionMaster(RequestModel request)
        {
            return await _level1.CurrencyConversionMaster(request);

        }
        #endregion CurrencyConversionMaster ends here

        #region Other Taxes Master starts here
        [Authorize]
        [HttpPost("OtherTaxesMaster")]
        public async Task<ResponseModel> OtherTaxesMaster(RequestModel request)
        {
            return await _level1.OtherTaxesMaster(request);
        }
        #endregion Other Taxes Master ends here

        #region SACMaster starts here
        [Authorize]
        [HttpPost("SACMaster")]
        public async Task<ResponseModel> SACMaster(RequestModel request)
        {
            return await _level1.SACMaster(request);
        }
        #endregion SACMaster ends here

        #region Service Tax New Master starts here
        [Authorize]
        [HttpPost("ServiceTaxNewMaster")]
        public async Task<ResponseModel> ServiceTaxNewMaster(RequestModel request)
        {
            return await _level1.ServiceTaxNewMaster(request);
        }
        #endregion Service Tax New Master ends here

        #region Other Service Tax New Master starts here
        [Authorize]
        [HttpPost("OtherServiceTaxNewMaster")]
        public async Task<ResponseModel> OtherServiceTaxNewMaster(RequestModel request)
        {
            return await _level1.OtherServiceTaxNewMaster(request);
        }
        #endregion Other Service Tax New Master ends here

        #region BankMaster starts here
        [Authorize]
        [HttpPost("BankMaster")]
        public async Task<ResponseModel> BankMaster(RequestModel request)
        {
            return await _level1.BankMaster(request);
        }
        #endregion BankMaster ends here

        #region BusinessTypeMaster starts here
        [Authorize]
        [HttpPost("BusinessTypeMaster")]
        public async Task<ResponseModel> BusinessTypeMaster(RequestModel request)
        {
            return await _level1.BusinessTypeMaster(request);
        }
        #endregion BusinessTypeMaster ends here

        #region TransportServiceMaster starts here
        [Authorize]
        [HttpPost("TransportServiceMaster")]
        public async Task<ResponseModel> TransportServiceMaster(RequestModel request)
        {
            return await _level1.TransportServiceMaster(request);

        }
        #endregion TransportServiceMaster ends here

        #region GuideServiceMaster starts here
        [Authorize]
        [HttpPost("GuideServiceMaster")]
        public async Task<ResponseModel> GuideServiceMaster(RequestModel request)
        {
            return await _level1.GuideServiceMaster(request);
        }
        #endregion GuideServiceMaster ends here

        #region SpecialServiceMaster starts here
        [Authorize]
        [HttpPost("SpecialServiceMaster")]
        public async Task<ResponseModel> SpecialServiceMaster(RequestModel request)
        {
            return await _level1.SpecialServiceMaster(request);
        }
        #endregion SpecialServiceMaster ends here

        #region HotelRatingMaster starts 
        [Authorize]
        [HttpPost("HotelRatingMaster")]
        public async Task<ResponseModel> HotelRatingMaster(RequestModel request)
        {
            return await _level1.HotelRatingMaster(request);
        }
        #endregion HotelRatingMaster ends here

        #region RoomCategory starts here
        [Authorize]
        [HttpPost("RoomCategoryMaster")]
        public async Task<ResponseModel> RoomCategoryMaster(RequestModel request)
        {
            return await _level1.RoomCategoryMaster(request);
        }
        #endregion RoomCategory starts here

        #region MealPlan starts here
        [Authorize]
        [HttpPost("MealPlanMaster")]
        public async Task<ResponseModel> MealPlanMaster(RequestModel request)
        {
            return await _level1.MealPlanMaster(request);
        }
        #endregion MealPlan starts here

        #region RateTypeMaster starts here
        [Authorize]
        [HttpPost("HotelRateTypeMaster")]
        public async Task<ResponseModel> HotelRateTypeMaster(RequestModel request)
        {
            return await _level1.HotelRateTypeMaster(request);
        }
        #endregion RateTypeMaster ends here

        #region RuleGroupMaster starts here
        [Authorize]
        [HttpPost("RuleGroupMaster")]
        public async Task<ResponseModel> RuleGroupMaster(RequestModel request)
        {
            return await _level1.RuleGroupMaster(request);
        }
        #endregion RuleGroupMaster ends here

        #region AgentMarkupMaster starts here
        //  //[Authorize]
        [HttpPost("AgentMarkupMaster")]
        public async Task<ResponseModel> AgentMarkupMaster(RequestModel request)
        {
            return await _level1.AgentMarkupMaster(request);
        }
        #endregion AgentMarkupMaster ends here

        #region RuleHeadersMaster starts here
        [Authorize]
        [HttpPost("RuleHeadersMaster")]
        public async Task<ResponseModel> RuleHeadersMaster(RequestModel request)
        {
            return await _level1.RuleHeadersMaster(request);
        }
        #endregion RuleHeadersMaster ends here

        #region hotelpreferedmaster starts here
        [Authorize]
        [HttpPost("HotelPreferredMaster")]
        public async Task<ResponseModel> HotelPreferredMaster(RequestModel request)
        {
            return await _level1.HotelPreferredMaster(request);
        }
        #endregion hotelpreferedmaster ends here

        #region BankAccount starts here
        [Authorize]
        [HttpPost("BankAccountsMaster")]
        public async Task<ResponseModel> BankAccountsMaster(RequestModel request)
        {

            return await _level1.BankAccountsMaster(request);
        }
        #endregion BankAccount ends here

        #region ModeofTravel starts here
        [Authorize]
        [HttpPost("ModeOfTravelMaster")]
        public async Task<ResponseModel> ModeOfTravelMaster(RequestModel request)
        {

            return await _level1.ModeOfTravelMaster(request);
        }
        #endregion ModeofTravel ends here

        #region hoteltype starts here
        [Authorize]
        [HttpPost("HotelTypeMaster")]
        public async Task<ResponseModel> HotelTypeMaster(RequestModel request)
        {

            return await _level1.HotelTypeMaster(request);
        }
        #endregion hoteltype ends here

        #region hoteltype starts here
        [Authorize]
        [HttpPost("BizPartnerGroupMaster")]
        public async Task<ResponseModel> BizPartnerGroupMaster(RequestModel request)
        {

            return await _level1.BizPartnerGroupMaster(request);
        }
        #endregion hoteltype ends here

        [HttpPost("BankMasterdetail")]
        public async Task<ResponseModel> BankMasterdetail(RequestModel request)
        {

            return await _level1.BankMasterdetail(request);
        }
        #region AgentCategoryMaster starts here
        [Authorize]
        [HttpPost("AgentCategoryMaster")]
        public async Task<ResponseModel> AgentCategoryMaster(RequestModel request)
        {

            return await _level1.AgentCategoryMaster(request);
        }
        #endregion AgentCategoryMaster ends here

        #region MSMEType starts here
        [Authorize]
        [HttpPost("MSMEType")]
        public async Task<ResponseModel> MSMEType(RequestModel request)
        {

            return await _level1.MSMEType(request);
        }
        #endregion MSMEType ends here

        #region VendorPreferred starts here
        [Authorize]
        [HttpPost("VendorPreferred")]
        public async Task<ResponseModel> VendorPreferred(RequestModel request)
        {

            return await _level1.VendorPreferred(request);
        }
        #endregion VendorPreferred ends here


        //#region AgentCategoryMaster starts here
        //////[Authorize]
        //[HttpPost("AgentCategoryMaster")]
        //public async Task<ResponseModel> AgentCategoryMaster(RequestModel request)
        //{

        //    return await _level1.AgentCategoryMaster(request);
        //}
        //#endregion AgentCategoryMaster ends here

        //#region MSMEType starts here
        //////[Authorize]
        //[HttpPost("MSMEType")]
        //public async Task<ResponseModel> MSMEType(RequestModel request)
        //{

        //    return await _level1.MSMEType(request);
        //}
        //#endregion MSMEType ends here

        #region SelectFiscalVariant starts here
        [Authorize]
        [HttpPost("SelectFiscalVariant")]
        public async Task<ResponseModel> SelectFiscalVariant(RequestModel request)
        {

            return await _level1.SelectFiscalVariant(request);
        }
        #endregion SelectFiscalVariant ends here

        #region GetAgentCategoryMaster starts here
        [Authorize]
        [HttpPost("GetAgentCategoryMaster")]
        public async Task<ResponseModel> GetAgentCategoryMaster(RequestModel request)
        {

            return await _level1.GetAgentCategoryMaster(request);
        }
        #endregion GetAgentCategoryMaster ends here

        #region New_CurrencyMaster starts here
        [Authorize]
        [HttpPost("New_CurrencyMaster")]
        public async Task<ResponseModel> New_CurrencyMaster(RequestModel request)
        {

            return await _level1.New_CurrencyMaster(request);
        }
        #endregion New_CurrencyMaster ends here

        #region New_CurrencyConversion starts here
        [Authorize]
        [HttpPost("New_CurrencyConversion")]
        public async Task<ResponseModel> New_CurrencyConversion(RequestModel request)
        {

            //return await _level1.New_CurrencyConversion(request);
            var responseList = await _level1.New_CurrencyConversion(request);
            return responseList.FirstOrDefault(); // Returns the first response or null if empty

        }
        #endregion New_CurrencyConversion ends here

        #region Destination_Master starts here
        [Authorize]
        [HttpPost("Destination_Master")]
        public async Task<ResponseModel> Destination_Master(RequestModel request)
        {

            return await _level1.Destination_Master(request);
        }
        #endregion Destination_Master ends here



        #region ItineraryNotes starts here
        [Authorize]
        [HttpPost("ItineraryNotes")]
        public async Task<ResponseModel> ItineraryNotes(RequestModel request)
        {

            return await _level1.ItineraryNotes(request);
        }
        #endregion ItineraryNotes ends here

        #region ItineraryInclusions starts here
        [Authorize]
        [HttpPost("ItineraryInclusions")]
        public async Task<ResponseModel> ItineraryInclusions(RequestModel request)
        {

            return await _level1.ItineraryInclusions(request);
        }
        #endregion ItineraryInclusions ends here

        #region ItineraryExclusions starts here
        [Authorize]
        [HttpPost("ItineraryExclusions")]
        public async Task<ResponseModel> ItineraryExclusions(RequestModel request)
        {

            return await _level1.ItineraryExclusions(request);
        }
        #endregion ItineraryExclusions ends here

        [Authorize]
        [HttpPost("SearchHotelCity")]
        public async Task<ResponseModel> SearchHotelCity(RequestModel request)
        {
            return await _level1.SearchHotelCity(request);
        }

       // [Authorize]
        [HttpPost("LockFileCodeXoRequestModel")]
        public async Task<ResponseModel> LockFileCodeXoRequestModel(RequestModel request)
        {
            return await _level1.LockFileCodeXoRequestModel(request);
        }
    }

}
