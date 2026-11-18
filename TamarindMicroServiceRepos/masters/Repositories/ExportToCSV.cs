using BusinessLogic.Interface;
using Microsoft.Extensions.Options;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Text;
using TamarindAstra.Common;
using TamarindAstraMasters.Interface;
using TamarindAstraReports.Interface;

namespace CommonClass.Repositories
{
    public class ExportToCSV : ICommonService
    {
        public readonly ILevel1Repository _level1;
        public readonly ILevel2Repository _level2;
        public readonly IUploadDocument _uploadDocs;
        public readonly IReport _report;
        
        private readonly string _base64Key;

        private readonly string isEncrypted;
        //private readonly Ixo _xo;

        public ExportToCSV(ILevel1Repository level1, ILevel2Repository level2, IReport report, IOptions<Cryptography> options, IConfiguration config, IUploadDocument uploadDocs)
        {
            _level1 = level1;
            _level2 = level2;
            _uploadDocs =uploadDocs;

            _report = report;
            _base64Key = options.Value.SecretKey;

            isEncrypted = config["AppConfigs:isEncrypted"];        }

        public async Task<ResponseModel> GetMasterForExport(RequestModel request)
        {
            //Company, Employee, Itenerary Description, Vendor, Hotel and Agent
            var response = new ResponseModel();

            //Level 1

            //Level 2
            if (request.MasterFlag == "AgentMaster")
            {
                response = await _level2.AgentMaster(request);
            }
            else if (request.MasterFlag == "CompanyMaster")
            {
                response = await _level2.CompanyMaster(request);
            }
            else if (request.MasterFlag == "EmployeeMaster")
            {
                response = await _level2.EmployeeMaster(request);
            }
            else if (request.MasterFlag == "HotelMaster")
            {
                response = await _level2.HotelMaster(request);
            }
            else if (request.MasterFlag == "ItineraryDescription")
            {
                response = await _level2.ItineraryDescription(request);
            }
            else if (request.MasterFlag == "VendorMaster")
            {
                response = await _level2.VendorMaster(request);
            }
            else if (request.MasterFlag == "LegalEntityMaster")
            {
                response = await _level2.EntityMasterModel(request);
            }
            else if (request.MasterFlag == "CityMaster")
            {
                response = await _level1.CityMaster(request);
            }
            //reports download
            else if (request.MasterFlag == "ReportDownloads")
            {
                response = await _report.ReportDownloads(request);
            }
            else if (request.MasterFlag == "File2FileMapping")
            {
                response = await _report.File2FileMapping(request);
            }
            else if (request.MasterFlag == "HotelRateCard")
            {
                response = await _report.HotelRateCard(request);
            }
            else if (request.MasterFlag == "EmployeeTarget")
            {
                response = await _level2.EmployeeTarget(request);
            }
            else if (request.MasterFlag == "CustomerMaster")
            {
                response = await _level2.CustomerMaster(request);
            }
            else if (request.MasterFlag == "MarketMaster")
            {
                response = await _level1.MarketMaster(request);
            }
            else if (request.MasterFlag == "CountryMaster")
            {
                response = await _level1.CountryMaster(request);
            }
            else if (request.MasterFlag == "StateMaster")
            {
                response = await _level1.StateMaster(request);
            }
            else if (request.MasterFlag == "CityMaster")
            {
                response = await _level1.CityMaster(request);
            }
            else if (request.MasterFlag == "CountryMarketMappingMaster")
            {
                response = await _level1.CountryMarketMappingMaster(request);
            }
            else if (request.MasterFlag == "ClassTypeMaster")
            {
                response = await _level1.ClassTypeMaster(request);
            }
            else if (request.MasterFlag == "ModeOfTravelMaster")
            {
                response = await _level1.ModeOfTravelMaster(request);
            }
            else if (request.MasterFlag == "TransportServiceMaster")
            {
                response = await _level1.TransportServiceMaster(request);
            }
            else if (request.MasterFlag == "GuideServiceMaster")
            {
                response = await _level1.GuideServiceMaster(request);
            }
            else if (request.MasterFlag == "SpecialServiceMaster")
            {
                response = await _level1.SpecialServiceMaster(request);
            }
            else if (request.MasterFlag == "MonumentMaster")
            {
                response = await _level1.MonumentMaster(request);
            }
            else if (request.MasterFlag == "HotelRatingMaster")
            {
                response = await _level1.HotelRatingMaster(request);
            }
            else if (request.MasterFlag == "RoomCategoryMaster")
            {
                response = await _level1.RoomCategoryMaster(request);
            }
            else if (request.MasterFlag == "MealPlanMaster")
            {
                response = await _level1.MealPlanMaster(request);
            }
            else if (request.MasterFlag == "HotelRateTypeMaster")
            {
                response = await _level1.HotelRateTypeMaster(request);
            }
            else if (request.MasterFlag == "RuleGroupMaster")
            {
                response = await _level1.RuleGroupMaster(request);
            }
            else if (request.MasterFlag == "RuleHeadersMaster")
            {
                response = await _level1.RuleHeadersMaster(request);
            }
            else if (request.MasterFlag == "DepartmentMaster")
            {
                response = await _level1.DepartmentMaster(request);
            }
            else if (request.MasterFlag == "DesignationMaster")
            {
                response = await _level1.DesignationMaster(request);
            }
            else if (request.MasterFlag == "VehicleTypeMaster")
            {
                response = await _level1.VehicleTypeMaster(request);
            }
            else if (request.MasterFlag == "GuideInfoMaster")
            {
                response = await _level1.GuideInfoMaster(request);
            }
            else if (request.MasterFlag == "LanguageMaster")
            {
                response = await _level1.LanguageMaster(request);
            }
            else if (request.MasterFlag == "NationalityMaster")
            {
                response = await _level1.NationalityMaster(request);
            }
            else if (request.MasterFlag == "FacilityInformationMaster")
            {
                response = await _level1.FacilityInformationMaster(request);
            }
            else if (request.MasterFlag == "LocationMaster")
            {
                response = await _level1.LocationMaster(request);
            }
            else if (request.MasterFlag == "ZoneMaster")
            {
                response = await _level1.ZoneMaster(request);
            }
            else if (request.MasterFlag == "HeaderMaster")
            {
                response = await _level1.HeaderMaster(request);
            }
            else if (request.MasterFlag == "LandMarksMaster")
            {
                response = await _level1.LandMarksMaster(request);
            }
            else if (request.MasterFlag == "TransferMaster")
            {
                response = await _level1.TransferMaster(request);
            }
            else if (request.MasterFlag == "AgentGroupMaster")
            {
                response = await _level1.AgentGroupMaster(request);
            }
            else if (request.MasterFlag == "HotelPreferredMaster")
            {
                response = await _level1.HotelPreferredMaster(request);
            }
            else if (request.MasterFlag == "SalutationMaster")
            {
                response = await _level1.SalutationMaster(request);
            }
            else if (request.MasterFlag == "YearMaster")
            {
                response = await _level1.YearMaster(request);
            }
            else if (request.MasterFlag == "CurrencyMaster")
            {
                //response = await _level1.CurrencyMaster(request);
                response = await _level1.New_CurrencyMaster(request);
            }
            else if (request.MasterFlag == "CurrencyConversionMaster")
            {
                response = await _level1.CurrencyConversionMaster(request);
            }
            else if (request.MasterFlag == "OtherTaxesMaster")
            {
                response = await _level1.OtherTaxesMaster(request);
            }
            else if (request.MasterFlag == "SACMaster")
            {
                response = await _level1.SACMaster(request);
            }
            else if (request.MasterFlag == "ServiceTaxNewMaster")
            {
                response = await _level1.ServiceTaxNewMaster(request);
            }
            else if (request.MasterFlag == "GSTTypeMaster")
            {
                response = await _level2.GSTTypeMaster(request);
            }
            else if (request.MasterFlag == "TCSRateMaster")
            {
                response = await _level2.TCSRateMaster(request);
            }
            else if (request.MasterFlag == "StateCodeMaster")
            {
                response = await _level2.StateCodeMaster(request);
            }
            else if (request.MasterFlag == "TcsLogicNewMaster")
            {
                response = await _level2.TCSLogicNewMaster(request);
            }
            else if (request.MasterFlag == "GstItcRateMaster")
            {
                response = await _level2.GstItcRateMaster(request);
            }
            else if (request.MasterFlag == "GSTstatusMaster")
            {
                response = await _level2.GSTstatusMaster(request);
            }
            else if (request.MasterFlag == "TaxPercentage")
            {
                response = await _level2.TaxPercentage(request);
            }

            //else if (request.MasterFlag == "GSTMaster")
            //{
            //    response = await _level2.GSTMaster(request);
            //}
            else if (request.MasterFlag == "BankAccountsMaster")
            {
                response = await _level1.BankAccountsMaster(request);
            }
            
            //else if (request.MasterFlag == "GuideMaster")
            //{
            //    response = await _level2.GuideMaster(request);
            //}
            //else if (request.MasterFlag == "VehicleCategoryMaster")
            //{
            //    response = await _level2.VehicleCategoryMaster(request);
            //}
            else if (request.MasterFlag == "XORemarks")
            {
                response = await _level1.XORemarksMaster(request);
            }
            else if (request.MasterFlag == "AgentMarkupMaster")
            {
                response = await _level1.AgentMarkupMaster(request);
            }
            else if (request.MasterFlag == "AirlineCodeMaster")
            {
                response = await _level2.AirlineCodeMaster(request);
            }
            else if (request.MasterFlag == "AirlineServiceTypemaster")
            {
                response = await _level2.AirlineServiceTypemaster(request);
            }
            else if (request.MasterFlag == "InvoiceDescriptionMaster")
            {
                response = await _level2.IDMaster(request);
            }
            else if (request.MasterFlag == "TCSRateConfig")
            {
                response = await _level2.TCSRateConfig(request);
            }
            else if (request.MasterFlag == "ServiceLocationMaster")
            {
                response = await _level2.SLMaster(request);
            }
            else if (request.MasterFlag == "LUTMasterData")
            {
                response = await _level2.LUTMasterData(request);
            }
            //else if (request.MasterFlag == "OpenPeriodMaster")
            //{
            //    response = await _level2.OpenPeriodMaster(request);
            //}
            else if (request.MasterFlag == "AirportMaster")
            {
                response = await _level2.AirportMaster(request);
            }
            else if (request.MasterFlag == "OtherServiceTaxNewMaster")
            {
                response = await _level1.OtherServiceTaxNewMaster(request);
            }
            else if (request.MasterFlag == "LockDateMaster")
            {
                response = await _level2.LockDateMaster(request);
            }
            else if (request.MasterFlag == "LegalTypeMaster")
            {
                response = await _level2.LegalTypeMaster(request);
            }
            else if (request.MasterFlag == "VendorPreferred")
            {
                response = await _level1.VendorPreferred(request);
            }
            else if (request.MasterFlag == "VendorServicesMaster")
            {
                response = await _level2.VSMaster(request);
            }
            else if (request.MasterFlag == "AgentClassificationMaster")
            {
                response = await _level2.ACMaster(request);
            }
            else if (request.MasterFlag == "BizPartnerGroupMaster")
            {
                response = await _level1.BizPartnerGroupMaster(request);
            }
            else if (request.MasterFlag == "ItineraryInclusionsExclusions")
            {
                response = await _level2.ItineraryInclusionsExclusions(request);
            }
            else if (request.MasterFlag == "BusinessTypeMaster")
            {
                response = await _level1.BusinessTypeMaster(request);
            }

            else if (request.MasterFlag == "DocumentTypeMaster")
            {
                response = await _uploadDocs.DocumentTypeMaster(request);
            }

            //else if (request.MasterFlag == "AdvancePaySendRequestModel")
            //{
            //    response = await _xo.AdvancePaySendRequestModel(request);
            //}
            byte[] fileResult;
            if (response != null && !string.IsNullOrEmpty(response.responseText))
            {
                try
                {
                    JObject obj = Cryptography.DecryptionData(response.responseText, _base64Key, isEncrypted);

                    if (obj != null && obj.Count > 0)
                    {
                        var dataList = obj["dataList"]; // Change to "dataList"
                        if (dataList != null && dataList.Type == JTokenType.Array)
                        {
                            try
                            {
                                var cppReportsList = dataList.ToObject<List<Dictionary<string, object>>>();
                                var data = new CommonClass.FileResponseViewModel<FileResponseModel>();
                                if (cppReportsList != null && cppReportsList.Count > 0)
                                {
                                    DataTable dataTable = ToDataTable(cppReportsList);
                                    if (dataTable.Rows.Count == 0)
                                        return CommonFunctions.ProcessFileResult(data, Encoding.UTF8.GetBytes("201"));
                                    fileResult = ExportToCsv(dataTable);
                                    return CommonFunctions.ProcessFileResult(data, fileResult);
                                }
                                else
                                {
                                    return CommonFunctions.ProcessFileResult(data, Encoding.UTF8.GetBytes("201"));
                                    //return CommonFunctions.BlankResponse("201", "No data found in the deserialized list.");
                                }
                            }
                            catch (Exception ex)
                            {
                                return CommonFunctions.CreateErrorResponse(ex, "201", $"Error during deserialization: {ex.Message}");
                            }
                        }
                        else
                        {
                            return CommonFunctions.BlankResponse("201", "dataList is null or not an array.");
                        }
                    }
                    else
                    {
                        return CommonFunctions.BlankResponse("201", "Decrypted object is null or empty.");
                    }
                }
                catch (Exception ex)
                {
                    return CommonFunctions.BlankResponse("201", $"Error during decryption or deserialization: {ex.Message}");
                }
            }
            else
            {
                return CommonFunctions.BlankResponse("201", "Response or responseText is null or empty.");
            }
        }

        public static DataTable ToDataTable(List<Dictionary<string, object>> list)
        {
            var dataTable = new DataTable();

            if (list == null || list.Count == 0)
                return dataTable;

            // Add columns
            foreach (var key in list[0].Keys)
                dataTable.Columns.Add(key);

            // Add rows
            foreach (var dict in list)
            {
                var row = dataTable.NewRow();
                foreach (var kvp in dict)
                    row[kvp.Key] = kvp.Value ?? DBNull.Value;
                dataTable.Rows.Add(row);
            }

            return dataTable;
        }
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
    }
}
