using BusinessLogic.Interface;
using CommonClass;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace TamarindAstra.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class Level2Controller : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly ILevel2Repository _level2;
        private readonly ICommonService _iCommon;

        public Level2Controller(IConfiguration config, ILevel2Repository level2, ICommonService iCommon)
        {
            _config = config;
            _level2 = level2;
            _iCommon = iCommon;
        }

        #region AgentMaster starts here

        //[Authorize]
        [HttpPost("AgentMaster")]
        public async Task<ResponseModel> AgentMaster(RequestModel request)
        {
            return await _level2.AgentMaster(request);
        }

        //[Authorize]
        [HttpPost("ExportMasterToCsv")]
        public async Task<ResponseModel> ExportMasterToCsv(RequestModel request)
        {

            return await _iCommon.GetMasterForExport(request);
        }
        
        /* var dataTable = new DataTable();
            try
            {
                dataTable = await _iCommon.GetAgentMasterForExport(request);
                if (dataTable.Rows.Count == 0)
                    return NotFound("No data available for export.");

        var fileResult = ExportToCsv(dataTable);
                return File(fileResult, "text/csv", "AgentMasterExport.csv");
    }
            catch (Exception ex)
            {
                //Logger.LogError(ex, "Error exporting Agent Master to CSV.");
                return StatusCode(500, "An error occurred while exporting data.");
}
*/

        /*// Assuming ExportToCsv method generates a CSV file as byte array.
        private byte[] ExportToCsv(DataTable dataTable)
        {
            StringBuilder sb = new StringBuilder();

            // Adding headers to CSV
            var columnNames = dataTable.Columns.Cast<DataColumn>().Select(col => col.ColumnName);
            sb.AppendLine(string.Join(",", columnNames));

            // Adding rows to CSV
            foreach (DataRow row in dataTable.Rows)
            {
                var fields = row.ItemArray.Select(field => field.ToString().Replace(",", " ")); // Escape commas
                sb.AppendLine(string.Join(",", fields));
            }

            // Return CSV as byte array
            return Encoding.UTF8.GetBytes(sb.ToString());
        }
    */
        /**/

        #endregion AgentMaster ends here

        #region PreviousCodeTagging starts here
        [Authorize]
        [HttpPost("PreviousCodeTagging")]
        public async Task<ResponseModel> PreviousCodeTagging(RequestModel request)
        {
            return await _level2.PreviousCodeTagging(request);
        }
        #endregion PreviousCodeTagging ends here

        #region AGENTCONTACTDETAILS ATRTS HERE
        [Authorize]
        [HttpPost("AgentContactDetailsTab")]
        public async Task<ResponseModel> AgentContactDetailsTab(RequestModel request)
        {
            return await _level2.AgentContactDetailsTab(request);
        }
        #endregion AGENTCONTACTDETAIL ENDS HERE

        #region agentsapcompcode starts here
        [HttpPost("AgentSAPCompCode")]
        public async Task<ResponseModel> AgentSAPCompCode(RequestModel request)
        {
            return await _level2.AgentSAPCompCode(request);
        }
        #endregion agentsapcompcode ends here

        #region State Code Master starts here
        [Authorize]
        [HttpPost("StateCodeMaster")]
        public async Task<ResponseModel> StateCodeMaster(RequestModel request)
        {
            return await _level2.StateCodeMaster(request);
        }
        #endregion State Code Master ends here

        #region lockdate starts here
        [Authorize]
        [HttpPost("LockDateMaster")]
        public async Task<ResponseModel> LockDateMaster(RequestModel request)
        {
            return await _level2.LockDateMaster(request);
        }
        #endregion lockdate ends here
        #region SupplyTypeMaster starts here
        [Authorize]
        [HttpPost("SupplyTypeMaster")]
        public async Task<ResponseModel> SupplyTypeMaster(RequestModel request)
        {
            return await _level2.SupplyTypeMaster(request);
        }
        #endregion SuppTypeID ends here

        #region TCS Rate Master starts here
        [Authorize]
        [HttpPost("TCSRateMaster")]
        public async Task<ResponseModel> TCSRateMaster(RequestModel request)
        {
            return await _level2.TCSRateMaster(request);
        }
        #endregion TCS Rate Master ends here

        #region Agent Classification Master starts here
        [Authorize]
        [HttpPost("AgentClassificationMaster")]
        public async Task<ResponseModel> ACMaster(RequestModel request)
        {
            return await _level2.ACMaster(request);

        }
        #endregion TCS Rate Master ends here}

        #region Vendor Master starts here
      //  [Authorize]
        [HttpPost("VendorMaster")]
        public async Task<ResponseModel> VendorMaster(RequestModel request)
        {
            return await _level2.VendorMaster(request);

        }
        #endregion VendorMaster ends here}

        #region vendorcontactdetaisltab starts here
        [HttpPost("VendorContactDetailsTab")]
        public async Task<ResponseModel> VendorContactDetailsTab(RequestModel request)
        {
            return await _level2.VendorContactDetailsTab(request);

        }
        #endregion vendorcontactdetails tab ends here

        #region Vendor Services Master starts here
        [Authorize]
        [HttpPost("VendorServicesMaster")]
        public async Task<ResponseModel> VSMaster(RequestModel request)
        {
            return await _level2.VSMaster(request);
        }
        #endregion Vendor Services Master ends here}

        #region Service Location Master starts here
        [Authorize]
        [HttpPost("ServiceLocationMaster")]
        public async Task<ResponseModel> SLMaster(RequestModel request)
        {
            return await _level2.SLMaster(request);
        }
        #endregion Service Location Master ends here}

        #region Invoice Description Master starts here
        [Authorize]
        [HttpPost("InvoiceDescriptionMaster")]
        public async Task<ResponseModel> IDMaster(RequestModel request)
        {
            return await _level2.IDMaster(request);
        }
        #endregion Service Location Master ends here}

        #region legaltypemaster starts here
        //[Authorize]
        [HttpPost("LegalTypeMaster")]
        public async Task<ResponseModel> LegalTypeMaster(RequestModel request)
        {
            return await _level2.LegalTypeMaster(request);
        }
        #endregion legaltypemaster ends here

        //#region legaltypemaster starts here
        ////[Authorize]
        //[HttpPost("LegalEntityTypeMaster")]
        //public async Task<ResponseModel> LegalEntityTypeMaster(RequestModel request)
        //{
        //    return await _level2.LegalEntityTypeMaster(request);
        //}
        //#endregion legaltypemaster ends here

        #region TaxPercentage starts here
        [Authorize]
        [HttpPost("TaxPercentage")]
        public async Task<ResponseModel> TaxPercentage(RequestModel request)
        {
            return await _level2.TaxPercentage(request);
        }
        #endregion TaxPercentage ends here

        #region QuotationServiceTypeMaster starts here
       // [Authorize]
        [HttpPost("QuotationServiceTypeMaster")]

        public async Task<ResponseModel> QuotationServiceTypeMaster(RequestModel request)
        {
            return await _level2.QuotationServiceTypeMaster(request);
        }
        #endregion QuotationServiceTypeMaster ends here


        #region TcsLogicNewMaster starts here
        [Authorize]
        [HttpPost("TcsLogicNewMaster")]

        public async Task<ResponseModel> TcsLogicNewMaster(RequestModel request)
        {
            return await _level2.TCSLogicNewMaster(request);
        }
        #endregion TcsLogicNewMaster ends here

        #region AirportMaster starts here
        [Authorize]
        [HttpPost("AirportMaster")]

        public async Task<ResponseModel> AirportMaster(RequestModel request)
        {
            return await _level2.AirportMaster(request);
        }
        #endregion AirportMaster ends here

        #region LUTMasterData starts here
        [Authorize]
        [HttpPost("LUTMasterData")]

        public async Task<ResponseModel> LUTMasterData(RequestModel request)
        {
            return await _level2.LUTMasterData(request);
        }
        #endregion LUTMasterData ends here

        #region AirlineCodeMaster starts here
        [Authorize]
        [HttpPost("AirlineCodeMaster")]

        public async Task<ResponseModel> AirlineCodeMaster(RequestModel request)
        {
            return await _level2.AirlineCodeMaster(request);
        }
        #endregion AirlineCodeMaster ends here

        #region AirlineServiceTypemaster starts here
        [Authorize]
        [HttpPost("AirlineServiceTypemaster")]
        public async Task<ResponseModel> AirlineServiceTypemaster(RequestModel request)
        {
            return await _level2.AirlineServiceTypemaster(request);
        }
        #endregion AirlineServiceTypemaster ends here

        #region GstItcRateMaster starts here
        [Authorize]
        [HttpPost("GstItcRateMaster")]
        public async Task<ResponseModel> GstItcRateMaster(RequestModel request)
        {
            return await _level2.GstItcRateMaster(request);
        }
        #endregion AirlineServiceTypemaster ends here

        #region HotelMaster starts here
        //[Authorize]
        [HttpPost("HotelMaster")]
        public async Task<ResponseModel> HotelMaster(RequestModel request)
        {
            return await _level2.HotelMaster(request);
        }
        #endregion HotelMaster ends here


        #region OtherServiceTax
        [Authorize]
        [HttpPost("OtherServiceTax")]
        public async Task<ResponseModel> OtherServiceTax(RequestModel request)
        {
            return await _level2.OtherServiceTax(request);
        }
        #endregion OtherServiceTax

        #region HotelRoomCategoryTab STARTS HERE
        //[Authorize]
        [HttpPost("HotelRoomCategoryTab")]
        public async Task<ResponseModel> HotelRoomCategoryTab(RequestModel request)
        {
            return await _level2.HotelRoomCategoryTab(request);
        }
        #endregion HotelRoomCategoryTab ENDS HERE

        #region HotelContactDetailsTab STARTS HERE
        [Authorize]
        [HttpPost("HotelContactDetailsTab")]
        public async Task<ResponseModel> HotelContactDetailsTab(RequestModel request)
        {
            return await _level2.HotelContactDetailsTab(request);
        }
        #endregion HotelContactDetailsTab ENDS HERE

        #region hotelrule starts here
        [Authorize]
        [HttpPost("HotelRuleTab")]
        public async Task<ResponseModel> HotelRuleTab(RequestModel request)
        {
            return await _level2.HotelRuleTab(request);
        }
        #endregion hotelrule ends here

        #region HotelSAPCompCode starts here
        [Authorize]
        [HttpPost("HotelSAPCompCode")]
        public async Task<ResponseModel> HotelSAPCompCode(RequestModel request)
        {
            return await _level2.HotelSAPCompCode(request);
        }
        #endregion HotelSAPCompCode ends here

        #region hotelannouncmemnt starts here
        [HttpPost("HotelAnnouncement")]
        public async Task<ResponseModel> HotelAnnouncement(RequestModel request)
        {
            return await _level2.HotelAnnouncement(request);
        }
        #endregion hotelannouncement ends here
        #region CompanyMaster starts here
        [HttpPost("CompanyMaster")]
        public async Task<ResponseModel> CompanyMaster(RequestModel request)
        {

            return await _level2.CompanyMaster(request);
        }
        #endregion CompanyMaster ends here

        //#region legalentitymaster starts here
        //[HttpPost("LegalEntityMaster")]
        //public async Task<ResponseModel> LegalEntityMasterModel(RequestModel request)
        //{
        //    return await _level2.LegalEntityMasterModel(request);
        //}
        //#endregion legalentitmaster ends here
        #region employeemaster starts here
        [Authorize]
        [HttpPost("EmployeeMaster")]
        public async Task<ResponseModel> EmployeeMaster(RequestModel request)
        {
            return await _level2.EmployeeMaster(request);
        }
        #endregion employeemaster ends here

        #region GSTPERCENTAGE STARS HERE
        [Authorize]
        [HttpPost("GSTPercentageMaster")]
        public async Task<ResponseModel> GSTPercentageMaster(RequestModel request)
        {
            return await _level2.GSTPercentageMaster(request);
        }
        #endregion GSTPERCENTAGE ENDS HERE

        #region WithholdingTaxMaster STARS HERE
        [Authorize]
        [HttpPost("WithholdingTaxMaster")]
        public async Task<ResponseModel> WithholdingTaxMaster(RequestModel request)
        {
            return await _level2.WithholdingTaxMaster(request);
        }
        #endregion WithholdingTaxMaster ENDS HERE

        #region PlaceOfSupplyLogicMaster starts here
        [Authorize]
        [HttpPost("PlaceOfSupplyLogic")]
        public async Task<ResponseModel> PlaceOfSupplyLogic(RequestModel request)
        {
            return await _level2.PlaceOfSupplyLogic(request);
        }
        #endregion placeofsupplylogicmaster ends here

        #region GSTTypeMaster starts here
        [Authorize]
        [HttpPost("GSTTypeMaster")]
        public async Task<ResponseModel> GSTTypeMaster(RequestModel request)
        {
            return await _level2.GSTTypeMaster(request);
        }
        #endregion GSTTypeMaster ends here

        #region TCSRateConfig starts here
        [Authorize]
        [HttpPost("TCSRateConfig")]
        public async Task<ResponseModel> TCSRateConfig(RequestModel request)
        {
            return await _level2.TCSRateConfig(request);
        }
        #endregion TCSRateConfig ends here

        #region ItineraryInclusionsExclusions starts here
        [Authorize]
        [HttpPost("ItineraryInclusionsExclusions")]
        public async Task<ResponseModel> ItineraryInclusionsExclusions(RequestModel request)
        {
            return await _level2.ItineraryInclusionsExclusions(request);
        }
        #endregion ItineraryInclusionsExclusions ends here

        #region EmployeeTarget STARTS HERE
        [Authorize]
        [HttpPost("EmployeeTarget")]
        public async Task<ResponseModel> EmployeeTarget(RequestModel request)
        {
            return await _level2.EmployeeTarget(request);
        }
        #endregion EMPLOYEETARGET ENDS HERE

        #region GSTstatusMaster STARTS HERE
        [Authorize]
        [HttpPost("GSTstatusMaster")]
        public async Task<ResponseModel> GSTstatusMaster(RequestModel request)
        {
            return await _level2.GSTstatusMaster(request);
        }
        #endregion GSTstatusMaster ENDS HERE

        #region ItineraryDescription STARTS HERE
        //[Authorize]
        [HttpPost("ItineraryDescription")]
        public async Task<ResponseModel> ItineraryDescription(RequestModel request)
        {
            return await _level2.ItineraryDescription(request);
        }
        #endregion ItineraryDescription ENDS HERE

        #region EntityMasterModel starts here
        [HttpPost("EntityMasterModel")]
        public async Task<ResponseModel> EntityMasterModel(RequestModel request)
        {
            return await _level2.EntityMasterModel(request);
        }
        #endregion EntityMasterModel ends here

        #region AgentBranchMapping starts here
        [HttpPost("AgentBranchMapping")]
        public async Task<ResponseModel> AgentBranchMapping(RequestModel request)
        {
            return await _level2.AgentBranchMapping(request);
        }
        #endregion AgentBranchMapping ends here

        #region Withholding_Tax starts here
        [HttpPost("Withholding_Tax")]
        public async Task<ResponseModel> Withholding_Tax(RequestModel request)
        {
            return await _level2.Withholding_Tax(request);
        }
        #endregion Withholding_Tax ends here


        #region SapCompCode starts here
        [HttpPost("SapCompCode")]
        public async Task<ResponseModel> SapCompCode(RequestModel request)
        {
            return await _level2.SapCompCode(request);
        }
        #endregion SapCompCode ends here

        #region SearchAgentMasterUploadDocuments starts here
        [HttpPost("SearchAgentLinkedDocuments")]
        public async Task<ResponseModel> SearchAgentLinkedDocuments(RequestModel request)
        {
            return await _level2.SearchAgentLinkedDocuments(request);
        }
        #endregion SearchAgentMasterUploadDocuments ends here

        #region SearchAgentMasterUploadDocuments starts here
        [HttpPost("SearchHotelLinkedDocuments")]
        public async Task<ResponseModel> SearchHotelLinkedDocuments(RequestModel request)
        {
            return await _level2.SearchHotelLinkedDocuments(request);
        }
        #endregion SearchAgentMasterUploadDocuments ends here

        #region SearchVendorLinkedDocuments starts here
        [HttpPost("SearchVendorLinkedDocuments")]
        public async Task<ResponseModel> SearchVendorLinkedDocuments(RequestModel request)
        {
            return await _level2.SearchVendorLinkedDocuments(request);
        }
        #endregion SearchVendorLinkedDocuments ends here

        #region CustomerMaster starts here
        [HttpPost("CustomerMaster")]
        public async Task<ResponseModel> CustomerMaster(RequestModel request)
        {
            return await _level2.CustomerMaster(request);
        }
        #endregion CustomerMaster ends here

        #region CustomerUploadDocuments starts here
        [HttpPost("CustomerLinkedDocuments")]
        public async Task<ResponseModel> SearchCustomerLinkedDocuments(RequestModel request)
        {
            return await _level2.CustomerLinkedDocuments(request);
        }
        #endregion SearchAgentMasterUploadDocuments ends here
    }
}