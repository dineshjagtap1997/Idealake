using BusinessLogic.Interface;
using CommonClass;
using DataAccess.Model.DBModel;
using Microsoft.Extensions.Options;
using MongoDB.Repositories;
using Newtonsoft.Json.Linq;
using System.Data;
using TamarindAstra.Common;
using DataTable = System.Data.DataTable;


namespace BusinessLogic.Repositories
{

    public class Level2Repository : ILevel2Repository
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;

        private readonly string isEncrypted;


        public Level2Repository(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];

        }

        #region AgentMaster starts here

        public async Task<ResponseModel> AgentMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgentMaster>(request.RequestText);

                if (req != null)
                {
                    // Validate and generate new AgentCode if required
                    /*if (string.IsNullOrEmpty(req.AgentCode) || (!Regex.IsMatch(req.AgentCode, @"^DRO\d{7}$") && req.Action.ToLower() != "s"))
                    {
                        if (req.Action.ToLower() == "i" && req.IsAgent == false) // Ensure new code generation happens only when Action is not "s"
                        {
                            req.LeadID = await GenerateLeadID();
                        }
                        else if (req.Action.ToLower() == "i" && req.IsAgent == true)
                        {
                            req.AgentCode = await SqlHelper.GenerateNewAgentCode();
                        }
                    }*/


                    var parameters = new
                    {
                        @AccCode = req.AccCode,
                        @AgentCode = req.AgentCode,
                        @AgentName = req.AgentName,
                        @CategoryID = req.CategoryID,
                        @Miscellaneous = req.Miscellaneous,
                        @GroupID = req.GroupID,
                        @MarketID = req.MarketID,
                        @City_IATACode = req.City_IATACode,
                        @Website = req.Website,
                        @PhoneNo = req.PhoneNo,
                        @MobileNo = req.MobileNo,
                        @FaxNo = req.FaxNo,
                        @EmailID = req.EmailID,
                        @PanNo = req.PanNo,
                        @STRegNo = req.SalesTaxRegNumber,
                        @ChequeFavouring = req.ChequeFavouring,
                        @Address = req.Address,
                        @CreateAdvanceAccount = req.CreateAdvanceAccount,
                        @CreditApplicable = req.CreditApplicable,
                        @CreditCurrencyCode = req.CreditCurrencyCode,
                        @CreditAllowance = req.CreditAllowance,
                        @Threshold = req.Threshold,
                        @CreditPeriod = req.CreditPeriod,
                        @OutStandingAmount = req.OutStandingAmount,
                        @UnlimitedCredit = req.UnlimitedCredit,
                        @IsActive = req.IsActive,
                        @IsOtherBooking = req.IsOtherBooking,
                        @IsCorporate = req.IsCorporate,
                        @OperationBy = req.OperationBy,
                        @IsFromB2BOrAstra = req.IsFromB2BOrAstra,
                        @BankAccountID = req.BankAccountID,
                        @AgentID = req.AgentID,
                        @RelatedEmployeeID = req.RelatedEmployeeID,
                        @HasBranch = req.HasBranch,
                        @StateCodeID = req.StateCodeID,
                        @IsInterBranch = req.IsInterBranch,
                        @IsSEZ = req.IsSEZ,
                        @AddressExist = req.AddressExist,
                        @GSTRequired = req.GSTRequired,
                        @AddressCountry = req.AddressCountry,
                        @AddressState = req.AddressState,
                        @AddressCity = req.AddressCity,
                        @isActiveSAP = req.isActiveSAP,
                        @TANDetails = req.TANDetails,
                        @PreviousCode = req.PreviousCode,
                        @AgentClassification = req.AgentClassification,
                        @Comments = req.Comments,
                        @IsAgentREFPO = req.IsAgentREFPO,
                        @BusinessHeadID = req.BusinessHeadID,
                        @SalesHeadID = req.SalesHeadID,
                        @PostalCode = req.PostalCode,
                        @LegalEntity = req.LegalEntity,
                        @LegalName = req.LegalName,
                        @Virtualaccount = req.Virtualaccount,
                        @Action = req.Action,
                        @PANVERIFICATION = req.PANVERIFICATION,
                        @TANVERIFICATION = req.TANVERIFICATION,
                        @GSTVERIFICATION = req.GSTVERIFICATION,
                        @GSTIN = req.GSTIN,
                        @BeneficiaryName = req.BeneficiaryName,
                        @AccountNumber = req.AccountNumber,
                        @IFSCCode = req.IFSCCode,
                        @SWIFTCode = req.SWIFTCode,
                        @MSMEUanNumber = req.MSMEUanNumber,
                        @IATACode = req.IATACode,
                        @MSMEType = req.MSMEType,
                        @IATOCode = req.IATOCode,
                        @BranchName = req.BranchName,
                        @TamSalesRep = req.TamSalesRep,
                        @TamSalesName = req.TamSalesName,
                        @MarkUpCategory = req.MarkUpCategory,
                        @BankName = req.BankName,
                        @GroupName = req.GroupName,
                        @Contact1 = req.Contact1,
                        @Contact2 = req.Contact2,
                        @IsContact1Mobile = req.IsContact1Mobile,
                        @IsContact2Mobile = req.IsContact2Mobile,
                        @IsAgent = req.IsAgent,
                        @LeadID = req.LeadID,
                        @TaxType = req.TaxType,
                        @UsedInBooking = req.UsedInBooking,
                        @PageNumber = req.PageNumber
                    };

                    var data = new CommonClass.ResponseViewModel<AgentMaster>
                    {
                        data = req
                    };

                    if (req.Action.ToLower() == "sa")
                        return CommonFunctions.ProcessDBDataPagination(data, req.Action, "usp_AgentMaster", parameters);
                    else
                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_AgentMaster", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Agent Master Processing Failed");
            }
        }

        /*private async Task<string> GenerateLeadID()
        {
            string newCode = "AL0000001"; // Default if no records exist

            using (var connection = new SqlConnection(_connectionString))
            {   
                string query = "SELECT MAX(LeadID) FROM AgentMaster WHERE LeadID LIKE 'AL%'";

                var lastCode = await connection.QueryFirstOrDefaultAsync<string>(query);

                if (!string.IsNullOrEmpty(lastCode) && Regex.IsMatch(lastCode, @"^AL\d{7}$"))
                {
                    int lastNumber = int.Parse(lastCode.Substring(3)); // Extract numeric part
                    newCode = $"AL{(lastNumber + 1):D7}"; // Increment and format
                }
            }

            return newCode;
        }*/

        #endregion AgentMaster ends here


        #region PreviousCodeTagging starts 
        //new
        public async Task<ResponseModel> PreviousCodeTagging(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<PreviousCodeTagging>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @IsActive = req.IsActive,
                        @IsVendorAgentHotel=req.IsVendorAgentHotel
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<PreviousCodeTagging>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetPreviousCodentAgent", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion PreviousCodeTagging ends here



        #region AgentContactDetails starts here
        //new
        public async Task<ResponseModel> AgentContactDetailsTab(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgentContactDetailsTab>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @ContactDetailsID = req.ContactDetailsID,
                        @ParentID = req.ParentID,
                        @TypeID = req.TypeID,
                        @IsPrimaryContact = req.IsPrimaryContact,
                        @SalutationID = req.SalutationID,
                        @FirstName = req.FirstName,
                        @DesignationOrDepartment = req.DesignationOrDepartment,
                        @EmailID = req.EmailID,
                        @MobileNo = req.MobileNo,
                        @DateofBirth = req.DateofBirth,
                        @CityIATACode = req.CityIATACode,
                        @IsActive = req.IsActive,
                        @UserID = req.UserID,
                        @Password = req.Password,
                        @IsAdminUser = req.IsAdminUser,
                        @IsEmail = req.IsEmail,
                        @IsAccStatement = req.IsAccStatement,
                        @IsCCtoAdmin = req.IsCCtoAdmin,
                        @IsOnlineBookingAccess = req.IsOnlineBookingAccess,
                        @IsXMLUser = req.IsXMLUser,
                        @IsCC = req.IsCC,
                        @IsB2BLogin = req.IsB2BLogin,
                        @IsB2CLogin = req.IsB2CLogin,
                        @OfficeNo = req.OfficeNo,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<AgentContactDetailsTab>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_InsertUpdateContactLoginDetailsNew", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion AgentContactDetails ends here

        #region AgentSAPCompCode starts here
        //new
        public async Task<ResponseModel> AgentSAPCompCode(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgentSAPCompCode>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @SAPCompCodeID = req.SAPCompCodeID,
                        @ID = req.ID,
                        @ParentId = req.ParentId,
                        @TypeId = req.TypeId,
                        // @SAPCompCodename = req.SAPCompCodename,
                        @BPCode = req.BPCode,
                        @IsActive = req.IsActive,
                        @CreatedBy = req.CreatedBy,
                        @UpdatedBy = req.UpdatedBy,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<AgentSAPCompCode>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_InsertUpdateSAPCompCode", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion AgentSAPCompCode ends here
        /*#region starts here
        public FileContentResult ExportToCsv(System.Data.DataTable dataTable)
        {
            StringBuilder csvBuilder = new StringBuilder();

            // Add column headers
            IEnumerable<string> columnNames = dataTable.Columns.Cast<DataColumn>().Select(col => col.ColumnName);
            csvBuilder.AppendLine(string.Join(",", columnNames));

            // Add rows
            foreach (DataRow row in dataTable.Rows)
            {
                IEnumerable<string> fields = row.ItemArray.Select(field => $"\"{field.ToString().Replace("\"", "\"\"")}\"");
                csvBuilder.AppendLine(string.Join(",", fields));
            }

            byte[] fileBytes = Encoding.UTF8.GetBytes(csvBuilder.ToString());
            return new FileContentResult(fileBytes, "application/csv")
            {
                FileDownloadName = "AgentMaster.csv"
            };
        }
        #endregion*/

        //public async Task<DataTable> GetAgentMasterForExport(RequestModel request)
        //{
        //    var response = await AgentMaster(request);
        //    JObject obj = Cryptography.DecryptionData(response.responseText, _base64Key, isEncrypted);

        //    if (obj != null && obj.Count > 0)
        //    {
        //      var  data = JsonConvert.DeserializeObject<AgentMaster>(obj.ToString());
        //    }
        //    /*if (response != null && response.dataList != null && response.dataList.Count > 0)
        //    {
        //        DataTable dataTable = response.dataList.ToDataTable();
        //        return dataTable;
        //    }*/

        //    return null;
        //} ---shubham





        //public async Task<DataTable> GetAgentMasterForExport()
        //{
        //    string connectionString = _config.GetConnectionString("DefaultConnection");
        //    if (string.IsNullOrEmpty(connectionString))
        //        throw new Exception("Connection string not found.");

        //    using (var connection = new SqlConnection(connectionString))
        //    {
        //        await connection.OpenAsync();

        //        using (var command = new SqlCommand("usp_AgentMaster", connection))
        //        {
        //            command.CommandType = CommandType.StoredProcedure;
        //            command.Parameters.AddWithValue("@Action", "S");

        //            using (var reader = await command.ExecuteReaderAsync())
        //            {
        //                DataTable dataTable = new DataTable();
        //                dataTable.Load(reader);
        //                return dataTable;
        //            }
        //        }
        //    }
        //}---- sarthak

        //chatgpt
        #region starts here
        public async Task<DataTable> GetMasterForExport(RequestModel request)
        {
            // Step 1: Fetch the response using the AgentMaster method.
            var response = await AgentMaster(request);

            if (response != null && !string.IsNullOrEmpty(response.responseText))
            {
                try
                {
                    // Step 3: Decrypt the response data using Cryptography.DecryptionData method.
                    JObject obj = Cryptography.DecryptionData(response.responseText, _base64Key, isEncrypted);

                    // Step 4: Check if the decrypted object is not null and contains data.
                    if (obj != null && obj.Count > 0)
                    {
                        // Assuming 'data' is the property containing the list of AgentMaster objects
                        var data = obj["data"];

                        if (data != null && data.Type == JTokenType.Array)
                        {
                            // Deserialize the array of AgentMaster objects
                            var agentList = data.ToObject<List<AgentMaster>>();

                            if (agentList != null && agentList.Count > 0)
                            {
                                // Step 5: Convert the agent list to a DataTable
                                DataTable dataTable = ToDataTable(agentList);
                                return dataTable;
                            }
                            else
                            {
                                // Handle the case when the list is null or empty
                                Console.WriteLine("No data found in the deserialized list.");
                                return new DataTable(); // Return an empty DataTable or handle as needed
                            }
                        }
                        else
                        {
                            // Handle the case where the 'data' is not an array or is missing
                            Console.WriteLine("'data' is not a valid array or is missing.");
                            return new DataTable(); // Return an empty DataTable or handle as needed
                        }
                    }
                    else
                    {
                        // Handle the case where the decrypted object is null or empty
                        Console.WriteLine("Decrypted object is null or empty.");
                        return new DataTable();
                    }
                }
                catch (Exception ex)
                {
                    // Step 9: Handle any exceptions that occur during decryption or deserialization
                    Console.WriteLine($"Error during decryption or deserialization: {ex.Message}");
                    return new DataTable();
                }
            }
            else
            {
                // Step 10: Handle the case when response or responseText is null or empty
                Console.WriteLine("Response or responseText is null or empty.");
                return new DataTable(); // Return an empty DataTable or handle the error appropriately
            }
        }
        #endregion



        public DataTable ToDataTable(List<AgentMaster> agentList)
        {
            DataTable dataTable = new DataTable();

            // Step 11: Add columns to the DataTable
            dataTable.Columns.Add("AccCode", typeof(string));
            dataTable.Columns.Add("AgentCode", typeof(string));
            dataTable.Columns.Add("AgentName", typeof(string));
            dataTable.Columns.Add("CategoryID", typeof(int));
            dataTable.Columns.Add("Micellaneous", typeof(int));
            dataTable.Columns.Add("GroupID", typeof(string));
            dataTable.Columns.Add("MarketID", typeof(int));
            dataTable.Columns.Add("City_IATACode", typeof(string));
            dataTable.Columns.Add("Website", typeof(string));
            dataTable.Columns.Add("PhoneNo", typeof(string));
            dataTable.Columns.Add("MobileNo", typeof(string));
            dataTable.Columns.Add("FaxNo", typeof(string));
            dataTable.Columns.Add("EmailID", typeof(string));
            dataTable.Columns.Add("PanNo", typeof(string));
            dataTable.Columns.Add("STRegNo", typeof(string));
            dataTable.Columns.Add("ChequeFavouring", typeof(string));
            dataTable.Columns.Add("Address", typeof(string));
            dataTable.Columns.Add("CreateAdvanceAccount", typeof(bool));
            dataTable.Columns.Add("CreditApplicable", typeof(bool));
            dataTable.Columns.Add("CreditCurrencyCode", typeof(string));
            dataTable.Columns.Add("CreditAllowance", typeof(decimal));
            dataTable.Columns.Add("Threshold", typeof(decimal));
            dataTable.Columns.Add("CreditPeriod", typeof(int));
            dataTable.Columns.Add("OutStandingAmount", typeof(decimal));
            dataTable.Columns.Add("UnlimitedCredit", typeof(bool));
            dataTable.Columns.Add("IsActive", typeof(bool));
            dataTable.Columns.Add("IsOtherBooking", typeof(bool));
            dataTable.Columns.Add("IsCorporate", typeof(bool));
            dataTable.Columns.Add("OperationBy", typeof(Guid));
            dataTable.Columns.Add("IsFromB2BOrAstra", typeof(int));
            dataTable.Columns.Add("BankAccountID", typeof(int));
            dataTable.Columns.Add("AgentID", typeof(int));
            dataTable.Columns.Add("RelatedEmployeeID", typeof(int));
            dataTable.Columns.Add("HasBranch", typeof(bool));
            dataTable.Columns.Add("StateCodeID", typeof(string));
            dataTable.Columns.Add("IsInterBranch", typeof(bool));
            dataTable.Columns.Add("IsSEZ", typeof(bool));
            dataTable.Columns.Add("AddressExist", typeof(bool));
            dataTable.Columns.Add("GSTRequired", typeof(bool));
            dataTable.Columns.Add("AddressCountry", typeof(string));
            dataTable.Columns.Add("AddressState", typeof(string));
            dataTable.Columns.Add("AddressCity", typeof(string));
            dataTable.Columns.Add("isActiveSAP", typeof(bool));
            dataTable.Columns.Add("TANDetails", typeof(string));
            dataTable.Columns.Add("PreviousCode", typeof(string));
            dataTable.Columns.Add("AgentClassification", typeof(string));
            dataTable.Columns.Add("Comments", typeof(string));
            dataTable.Columns.Add("IsAgentREFPO", typeof(bool));
            dataTable.Columns.Add("BusinessHeadID", typeof(int));
            dataTable.Columns.Add("SalesHeadID", typeof(int));
            dataTable.Columns.Add("PostalCode", typeof(string));
            dataTable.Columns.Add("LegalEntity", typeof(string));
            dataTable.Columns.Add("LegalName", typeof(string));
            dataTable.Columns.Add("Virtualaccount", typeof(bool));
            dataTable.Columns.Add("Action", typeof(string));
            dataTable.Columns.Add("IsOtherBooing", typeof(bool));

            //    Step 12: Populate the DataTable with data from the agent list
            foreach (var agent in agentList)
            {
                DataRow row = dataTable.NewRow();
                row["AccCode"] = agent.AccCode;
                row["AgentCode"] = agent.AgentCode;
                row["AgentName"] = agent.AgentName;
                row["CategoryID"] = agent.CategoryID;
                row["Micellaneous"] = agent.Miscellaneous;
                row["GroupID"] = agent.GroupID;
                row["MarketID"] = agent.MarketID;
                row["City_IATACode"] = agent.City_IATACode;
                row["Website"] = agent.Website;
                row["PhoneNo"] = agent.PhoneNo;
                row["MobileNo"] = agent.MobileNo;
                row["FaxNo"] = agent.FaxNo;
                row["EmailID"] = agent.EmailID;
                row["PanNo"] = agent.PanNo;
                row["STRegNo"] = agent.STRegNo;
                row["ChequeFavouring"] = agent.ChequeFavouring;
                row["Address"] = agent.Address;
                row["CreateAdvanceAccount"] = agent.CreateAdvanceAccount;
                row["CreditApplicable"] = agent.CreditApplicable;
                row["CreditCurrencyCode"] = agent.CreditCurrencyCode;
                row["CreditAllowance"] = agent.CreditAllowance;
                row["Threshold"] = agent.Threshold;
                row["CreditPeriod"] = agent.CreditPeriod;
                row["OutStandingAmount"] = agent.OutStandingAmount;
                row["UnlimitedCredit"] = agent.UnlimitedCredit;
                row["IsActive"] = agent.IsActive;
                row["IsOtherBooking"] = agent.IsOtherBooking;
                row["IsCorporate"] = agent.IsCorporate;
                row["OperationBy"] = agent.OperationBy;
                row["IsFromB2BOrAstra"] = agent.IsFromB2BOrAstra;
                row["BankAccountID"] = agent.BankAccountID;
                row["AgentID"] = agent.AgentID;
                row["RelatedEmployeeID"] = agent.RelatedEmployeeID;
                row["HasBranch"] = agent.HasBranch;
                row["StateCodeID"] = agent.StateCodeID;
                row["IsInterBranch"] = agent.IsInterBranch;
                row["IsSEZ"] = agent.IsSEZ;
                row["AddressExist"] = agent.AddressExist;
                row["GSTRequired"] = agent.GSTRequired;
                row["AddressCountry"] = agent.AddressCountry;
                row["AddressState"] = agent.AddressState;
                row["AddressCity"] = agent.AddressCity;
                row["isActiveSAP"] = agent.isActiveSAP;
                row["TANDetails"] = agent.TANDetails;
                row["PreviousCode"] = agent.PreviousCode;
                row["AgentClassification"] = agent.AgentClassification;
                row["Comments"] = agent.Comments;
                row["IsAgentREFPO"] = agent.IsAgentREFPO;
                row["BusinessHeadID"] = agent.BusinessHeadID;
                row["SalesHeadID"] = agent.SalesHeadID;
                row["PostalCode"] = agent.PostalCode;
                row["LegalEntity"] = agent.LegalEntity;
                row["LegalName"] = agent.LegalName;
                row["Virtualaccount"] = agent.Virtualaccount;
                row["Action"] = agent.Action;

                dataTable.Rows.Add(row);
            }

            return dataTable;
        }
        #region starts here
        //new
        //public async Task<ResponseModel> VendorMaster(RequestModel request)
        //{

        //    try
        //    {
        //        // Decrypt and deserialize the request
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<VendorMaster>(request.RequestText);

        //        if (req != null)
        //        {

        //            var parameters = new
        //            {
        //                @AccCode = req.AccCode,
        //                @VendorCode = req.VendorCode,
        //                @VendorName = req.VendorName,
        //                @AccountGroup = req.AccountGroup,
        //                @CityIATACode = req.CityIATACode,
        //                @Website = req.Website,
        //                @PhoneNo = req.PhoneNo,
        //                @MobileNo = req.MobileNo,
        //                @FaxNo = req.FaxNo,
        //                @EmailID = req.EmailID,
        //                @PanNo = req.PanNo,
        //                @STRegNo = req.STRegNo,
        //                @ChequeFavouring = req.ChequeFavouring,
        //                @BankName = req.BankName,
        //                @Address = req.Address,
        //                @AccountNo = req.AccountNo,
        //                @CreateAdvanceAccount = req.CreateAdvanceAccount,
        //                @CreditApplicable = req.CreditApplicable,
        //                @CreditPeriod = req.CreditPeriod,
        //                @CreditCurrencyCode = req.CreditCurrencyCode,
        //                @CreditAmount = req.CreditAmount,
        //                @CreditApproveBy = req.CreditApproveBy,
        //                @IsActive = req.IsActive,
        //                @OperationBy = req.OperationBy,
        //                @CreateCommissionAccount = req.CreateCommissionAccount,
        //                @BankAccountID = req.BankAccountID,
        //                @IsXML = req.IsXML,
        //                @IFSCCode = req.IFSCCode,
        //                @SWIFTCode = req.SWIFTCode,
        //                @Comment = req.Comment,
        //                @BranchName = req.BranchName,
        //                @StateCode = req.StateCode,
        //                @GSTRequired = req.GSTRequired,
        //                @IsActiveSAP = req.IsActiveSAP,
        //                @TANDetails = req.TANDetails,
        //                @PreviousCode = req.PreviousCode,
        //                @MSME = req.MSME,
        //                @Deductee = req.Deductee,
        //                @WithHoldigTax = req.WithHoldigTax,
        //                @XOSupplierNameLogic = req.XOSupplierNameLogic,
        //                @IsActiveMSME = req.IsActiveMSME,
        //                @MSMEType = req.MSMEType,
        //                @MSMERegFromDt = req.MSMERegFromDt,
        //                @MSMERegToDt = req.MSMERegToDt,
        //                @PostalCode = req.PostalCode,
        //                @BizPartnerGrp = req.BizPartnerGrp,
        //                @LegalEntity = req.LegalEntity,
        //                @LegalName = req.LegalName,
        //                @IsSEZ = req.IsSEZ,
        //                @MembershipNo = req.MembershipNo,
        //                @NonGSTRegistered = req.NonGSTRegistered,
        //                @IsH = req.IsH,
        //                @IsT = req.IsT,
        //                @IsM = req.IsM,
        //                @IsSS = req.IsSS,
        //                @IsGG = req.IsGG,
        //                @IsMOT = req.IsMOT,
        //                @IsFS = req.IsFS,
        //                @IsChange = req.IsChange,
        //                @XOPrintName = req.XOPrintName,
        //                @Action = req.Action,
        //                @IATOCode = req.IATOCode,
        //                @IATACode = req.IATACode,
        //                @VendorID = req.VendorID,
        //                @PANVERIFICATION = req.PANVERIFICATION,
        //                @TANVERIFICATION = req.TANVERIFICATION,
        //                @GSTVERIFICATION = req.GSTVERIFICATION,
        //                @Country = req.Country,
        //                @State = req.State,
        //                @City = req.City,

        //                @TaxType = req.TaxType,
        //                @Contact1 = req.Contact1,
        //                @Contact2 = req.Contact2,
        //                @Contact1IsMobile = req.Contact1IsMobile,
        //                @Contact2IsMobile = req.Contact2IsMobile,
        //            };

        //            var data = new CommonClass.ResponseViewModel<VendorMaster>
        //            {
        //                data = req
        //            };
        //            return CommonFunctions.ProcessDBData(data, req.Action, "usp_VendorMaster", parameters);

        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
        //    }
        //}


        public async Task<ResponseModel> VendorMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<VendorMaster>(request.RequestText);

                if (req != null)
                {
                    if (req.Action == "USAP" && req.IsSapCompCode == false)
                    {
                        // Check if ChainIATACode is valid before generating hotel code
                        //if (!string.IsNullOrEmpty(req.VendorCode) && req.VendorCode.Length >= 3)
                        //{
                        req.VendorCode = await SqlHelper.GetNewVendorCodeAsync(req.VendorSAPCode);
                        //}
                        //else
                        //{
                        //    // Handle the case where ChainIATACode is invalid
                        //    return CommonFunctions.BlankResponse("201", "Invalid VENDORSAPCode. It must be at least 3 characters long.");
                        //}
                        //   req.IsSapCompCode = true; // Set flag true when action is USAP
                    }
                    //else
                    //{
                    //    req.IsSapCompCode = false; // Or keep existing value for other actions if needed
                    //}
                    var parameters = new
                    {
                        @AccCode = req.AccCode,
                        @VendorCode = req.VendorCode,
                        @VendorName = req.VendorName,
                        @AccountGroup = req.AccountGroup,
                        @CityIATACode = req.CityIATACode,
                        @Website = req.Website,
                        @PhoneNo = req.PhoneNo,
                        @MobileNo = req.MobileNo,
                        @FaxNo = req.FaxNo,
                        @EmailID = req.EmailID,
                        @PanNo = req.PanNo,
                        @STRegNo = req.STRegNo,
                        @ChequeFavouring = req.ChequeFavouring,
                        @BankName = req.BankName,
                        @Address = req.Address,
                        @AccountNo = req.AccountNo,
                        @CreateAdvanceAccount = req.CreateAdvanceAccount,
                        @CreditApplicable = req.CreditApplicable,
                        @CreditPeriod = req.CreditPeriod,
                        @CreditCurrencyCode = req.CreditCurrencyCode,
                        @CreditAmount = req.CreditAmount,
                        @CreditApproveBy = req.CreditApproveBy,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @CreateCommissionAccount = req.CreateCommissionAccount,
                        @BankAccountID = req.BankAccountID,
                        @IsXML = req.IsXML,
                        @IFSCCode = req.IFSCCode,
                        @SWIFTCode = req.SWIFTCode,
                        @Comment = req.Comment,
                        @BranchName = req.BranchName,
                        @StateCode = req.StateCode,
                        @GSTRequired = req.GSTRequired,
                        @IsActiveSAP = req.IsActiveSAP,
                        @TANDetails = req.TANDetails,
                        @PreviousCode = req.PreviousCode,
                        @MSME = req.MSME,
                        @Deductee = req.Deductee,
                        @WithHoldigTax = req.WithHoldigTax,
                        @XOSupplierNameLogic = req.XOSupplierNameLogic,
                        @IsActiveMSME = req.IsActiveMSME,
                        @MSMEType = req.MSMEType,
                        @MSMERegFromDt = req.MSMERegFromDt,
                        @MSMERegToDt = req.MSMERegToDt,
                        @PostalCode = req.PostalCode,
                        @BizPartnerGrp = req.BizPartnerGrp,
                        @LegalEntity = req.LegalEntity,
                        @LegalEntTypeID = req.LegalEntTypeID,
                        @LegalName = req.LegalName,
                        @IsSEZ = req.IsSEZ,
                        @MembershipNo = req.MembershipNo,
                        @NonGSTRegistered = req.NonGSTRegistered,
                        @IsH = req.IsH,
                        @IsT = req.IsT,
                        @IsM = req.IsM,
                        @IsSS = req.IsSS,
                        @IsGG = req.IsGG,
                        @IsMOT = req.IsMOT,
                        @IsFS = req.IsFS,
                        @IsChange = req.IsChange,
                        @XOPrintName = req.XOPrintName,
                        @Action = req.Action,
                        @VendorSAPCode = req.VendorSAPCode,
                        @IATOCode = req.IATOCode,
                        @IATACode = req.IATACode,
                        @VendorID = req.VendorID,
                        @PANVERIFICATION = req.PANVERIFICATION,
                        @TANVERIFICATION = req.TANVERIFICATION,
                        @GSTVERIFICATION = req.GSTVERIFICATION,
                        @Country = req.Country,
                        @State = req.State,
                        @City = req.City,

                        @TaxType = req.TaxType,
                        @Contact1 = req.Contact1,
                        @Contact2 = req.Contact2,
                        @Contact1IsMobile = req.Contact1IsMobile,
                        @Contact2IsMobile = req.Contact2IsMobile,
                        @PageNumber = req.PageNumber,

                    };

                    var data = new CommonClass.ResponseViewModel<VendorMaster>
                    {
                        data = req
                    };
                    if (req.Action.ToLower() == "s")
                    {
                        return CommonFunctions.ProcessDBDataPagination(data, req.Action, "usp_VendorMaster", parameters);
                    }
                    else
                    {

                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_VendorMaster", parameters);
                    }

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion

        #region vendorcontactdetails starts here
        public async Task<ResponseModel> VendorContactDetailsTab(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeNullRequest<VendorContactDetailTab>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @ContactDetailsID = req.ContactDetailsID,
                        @DateofBirth = req.DateofBirth == null ? (DateTime?)null : DateTime.Parse(req.DateofBirth.ToString()),
                        @ParentID = req.ParentID,
                        @TypeID = req.TypeID,
                        @IsPrimaryContact = req.IsPrimaryContact,
                        @SalutationID = req.SalutationID,
                        @FirstName = req.FirstName,
                        @LastName = req.LastName,
                        @DesignationOrDepartment = req.DesignationOrDepartment,
                        @EmailID = req.EmailID,
                        @OfficeNo = req.OfficeNo,
                        @MobileNo = req.MobileNo,
                        @FaxNo = req.FaxNo,
                        @CityIATACode = req.CityIATACode,
                        @IsActive = req.IsActive,
                        @IsAccStatement = req.IsAccStatement,
                        @IsCC = req.IsCC,
                        @IsForContracting = req.IsForContracting,
                        @IsBills = req.IsBills,
                        @CreatedBy = req.CreatedBy,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<VendorContactDetailTab>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_InsertContactDetails", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion vendorcontactdetails end here
        #region supplytypemaster starts here
        //new
        public async Task<ResponseModel> SupplyTypeMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SuppTypeMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Code = req.Code,
                        @Description = req.Description,
                        @LongDescription = req.LongDescription,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @SuppTypeID = req.SuppTypeID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<SuppTypeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_SupplyTypeMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion supplytypemaster ends here

        #region lockdate starts here
        public async Task<ResponseModel> LockDateMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<LockDateMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Year = req.Year,
                        @MonthID = req.MonthID,
                        @LockDate = req.LockDate,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<LockDateMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_LockDateSettings", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion lockdate ends here







        #region statecodemaster starts here
        //new
        public async Task<ResponseModel> StateCodeMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<StateCodeMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @StateCode = req.StateCode,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @IsUnionTerritory = req.IsUnionTerritory,
                        @IsOtherTerritory = req.IsOtherTerritory,
                        @TwoDigitCode = req.TwoDigitCode,
                        @Action = req.Action,
                        @ID = req.ID
                    };

                    var data = new CommonClass.ResponseViewModel<StateCodeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_StateCode_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion statecodemaster emds here




        #region TCSRateMaster starts here
        //new
        public async Task<ResponseModel> TCSRateMaster(RequestModel request)
        {

            try
            {

                var req = CommonFunctions.DecryptAndDeserializeNullRequest<TCSRateMaster>(request.RequestText);

                //                var req = CommonFunctions.DecryptAndDeserializeRequest<TCSRateMaster>(request.RequestText);

                if (req != null)
                {


                    DateTime? validFrom = CommonFunctions.ParseDate(req.ValidFrom.ToString());
                    DateTime? validTo = CommonFunctions.ParseDate(req.ValidTo.ToString());
                    var parameters = new
                    {
                        @ACCode = req.ACCode,
                        @Description = req.Description,
                        @ValidFrom = req.ValidFrom == null ? (DateTime?)null : DateTime.Parse(req.ValidFrom.ToString()),
                        @ValidTo = req.ValidTo == null ? (DateTime?)null : DateTime.Parse(req.ValidTo.ToString()),
                        @TCSRate = req.TCSRate,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        // @CreatedDate = req.CreatedDate,
                        @SAPCode = req.SAPCode,
                        @Action = req.Action,
                        @TCSID = req.TCSID
                    };

                    var data = new CommonClass.ResponseViewModel<TCSRateMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_TCSRateMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        #endregion


        #region ACMaster starts here
        //new
        public async Task<ResponseModel> ACMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgentClassificationMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @Description = req.Description,
                        @IsActive = req.IsActive,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<AgentClassificationMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Agent_Classification_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ACMaster end here
        #region VSMaster starts here
        //new
        public async Task<ResponseModel> VSMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<Vendor_Services_Master>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        Vendor_ID = req.Vendor_ID,
                        Description = req.Description,
                        IsActive = req.IsActive,
                        Action = req.Action,
                        OperationBy = req.OperationBy,
                    };

                    var data = new CommonClass.ResponseViewModel<Vendor_Services_Master>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Vendor_Services_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion VSMaster ends here
        #region SLMaster starts here
        //new
        public async Task<ResponseModel> SLMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<Service_Location_Master>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ServLoc_ID = req.ServLoc_ID,
                        @Description = req.Description,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<Service_Location_Master>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ServiceLocation_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SLMaster ends here
        #region IDMaster start here
        //new
        public async Task<ResponseModel> IDMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<Invoice_Description_Master>(request.RequestText);


                if (req != null)
                {


                    var parameters = new
                    {
                        @InvDesc_ID = req.InvDesc_ID,
                        @Description = req.Description,
                        @SACCode = req.SACCode,
                        @IsComm = req.IsComm,
                        @IsActive = req.IsActive,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<Invoice_Description_Master>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_InvoiceDescription_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion IDMaster end here

        #region LegalTypeMaster starts here
        //new
        public async Task<ResponseModel> LegalTypeMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<LegalEntityTypeMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @LegalEntTypeID = req.LegalEntTypeID,
                        @LegalEntityType = req.LegalEntityType,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<LegalEntityTypeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_LegalEntityType_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion LegalTypeMaster endshere
        #region Taxpercentage starts here

        public async Task<ResponseModel> TaxPercentage(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<TaxPercentage>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @GSTID = req.GSTID,
                        @GSTPercentageValue = req.GSTPercentageValue,
                        @IsActive = req.IsActive,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy,
                        //@Operation = req.Operation,
                        //@CreatedDate = req.CreatedDate,
                        //@UpdatedDate = req.UpdatedDate
                    };

                    //// Ensure you are calling the correct stored procedure here
                    //var data = new CommonClass.ResponseViewModel<TaxPercentage>
                    //{
                    //    data = req
                    //};
                    //return CommonFunctions.ProcessDBData(data, req.Action, "usp_GST_Percentage", parameters);


                    if (req.Action.ToLower() == "ex")
                    {
                        // Manually map GSTTypeMaster to GSTTypeMasterExportModel
                        var exportModel = new TaxPercentageExportModel
                        {
                            GSTID = req.GSTID,
                            GSTPercentageValue = req.GSTPercentageValue,
                            IsActive = req.IsActive
                            // Add more mappings if GSTTypeMasterExportModel has extra properties
                        };

                        var data = new CommonClass.ResponseViewModel<TaxPercentageExportModel>
                        {
                            data = exportModel
                        };

                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_GST_Percentage", parameters);
                    }
                    else
                    {
                        var data = new CommonClass.ResponseViewModel<TaxPercentage>
                        {
                            data = req
                        };

                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_GST_Percentage", parameters);
                    }

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion TaxPercentage endshere

        #region Quotation Service Type
        //new
        public async Task<ResponseModel> QuotationServiceTypeMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<QuotationServiceTypeMaster>(request.RequestText);

                if (req != null)
                {
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    var parameters = new
                    {
                        @QutServ_ID = req.QutServ_ID,
                        @Description = req.Description,
                        @IsActive = req.IsActive,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy,
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<QuotationServiceTypeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_QuotationServiceType_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Quotation Service Type

        #region tcsloginnew starts here
        public async Task<ResponseModel> TCSLogicNewMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<TCSLogicNewMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @BillingTo = req.BillingTo,
                        @FromDate = req.FromDate == null ? (DateTime?)null : DateTime.Parse(req.FromDate.ToString()),
                        @ToDate = req.ToDate == null ? (DateTime?)null : DateTime.Parse(req.ToDate.ToString()),
                        @PANExists = req.PANExists,
                        @AddressOnRecord = req.AddressOnRecord,
                        @AgentMasterCountryIN = req.AgentMasterCountryIN,
                        @NonResident = req.NonResident,
                        @TCSRateID = req.TCSRateID,
                        @BlockDetails = req.BlockDetails,
                        @TANonRecord = req.TANonRecord,
                        @IsActive = req.IsActive,
                        @TDSDeduction = req.TDSDeduction,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        //@OperationBy = rey,
                        @TCSLogicID = req.TCSLogicID,
                        @AgentID = req.AgentID,
                        @InvoiceDate = req.InvoiceDate
                    };

                    var data = new CommonClass.ResponseViewModel<TCSLogicNewMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_TCSLogicNew_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion tcsloginew endshere



        #region LUTMasterdata starts here        
        //new
        public async Task<ResponseModel> LUTMasterData(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<LUTMasterData>(request.RequestText);
                if (req != null)
                {
                    var parameters = new
                    {
                        @LUTNumber = req.LUTNumber,
                        @ValidFrom = req.ValidFrom == null ? (DateTime?)null : DateTime.Parse(req.ValidFrom.ToString()),
                        @ValidTo = req.ValidTo == null ? (DateTime?)null : DateTime.Parse(req.ValidTo.ToString()),
                        @CompanyID = req.CompanyID,
                        @YearCode = req.YearCode,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @ID = req.ID
                    };

                    // Use different model based on action
                    if (req.Action.ToUpper() == "EX") // Handle both "ex" and "EX"
                    {
                        // For Excel export, use the limited field model
                        var excelData = new CommonClass.ResponseViewModel<LUTMasterDataExcel>
                        {
                            data = new LUTMasterDataExcel
                            {
                                ID = req.ID,
                                LUTNumber = req.LUTNumber,
                                ValidFrom = req.ValidFrom,
                                ValidTo = req.ValidTo,
                                IsActive = req.IsActive,
                                CompanyName = req.CompnayName
                            }
                        };
                        return CommonFunctions.ProcessDBData(excelData, req.Action, "USP_LUTMasterData", parameters);
                    }
                    else
                    {
                        // For other actions, use the full model
                        var data = new CommonClass.ResponseViewModel<LUTMasterData>
                        {
                            data = req
                        };
                        return CommonFunctions.ProcessDBData(data, req.Action, "USP_LUTMasterData", parameters);
                    }
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion LUTMasterdata ends here

        #region AirlineCodeMaster starts here        
        //new
        public async Task<ResponseModel> AirlineCodeMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AirlineCodeMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @AirlineCode = req.AirlineCode,
                        @AirlineName = req.AirlineName,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @AirlineID = req.AirlineID
                    };

                    var data = new CommonClass.ResponseViewModel<AirlineCodeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_AirlineCodemaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion AirlineCodeMaster ends here


        #region AirlineServiceTypemaster starts here       
        //new
        public async Task<ResponseModel> AirlineServiceTypemaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AirlineServiceTypemaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @AirlineServiceTypeID = req.AirlineServiceTypeID,
                        @AirlineServiceType = req.AirlineServiceType,
                        @ShortCode = req.ShortCode,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<AirlineServiceTypemaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_AirlineServiceTypemaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion AirlineServiceMaster ends 


        #region AirportMasterr starts here        
        //new
        public async Task<ResponseModel> AirportMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AirportMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @AirportCode = req.AirportCode,
                        @AirportCityName = req.AirportCityName,
                        @AirportName = req.AirportName,
                        @AirportCountry = req.AirportCountry,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @ID = req.ID
                    };

                    var data = new CommonClass.ResponseViewModel<AirportMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_AirportMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion AirportMasterr ends here

        #region gstitc starts here
        //new
        public async Task<ResponseModel> GstItcRateMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GstItcRateMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ITCPercentage = req.ITCPercentage,
                        @RateForSAP = req.RateForSAP,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @TAXID = req.TAXID
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<GstItcRateMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GstItcRateMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion
        #region hotelcode starts here
        /*public async Task<ResponseModel> HOTELCODE(RequestModel request)
        {
            ResponseModel responseModel = new ResponseModel();
            string jsonString = string.Empty;
            var data = new CommonClass.ResponseViewModel<HOTELCODE>();
            HOTELCODE req = null;
            try
            {
                logger.Debug("HOTELCODEmethod called");
                JObject obj = Cryptography.DecryptionData(request.RequestText, _base64Key, isEncrypted);

                if (obj != null && obj.Count > 0)
                {
                    req = JsonConvert.DeserializeObject<HOTELCODE>(obj.ToString());
                }
                if (req != null)
                {
                    //        Database operation
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    string con = _config.GetConnectionString("DefaultConnection");
                    if (con == null) throw new Exception("Connection string not found.");

                    using (var connection = new SqlConnection(con))
                    {
                        await connection.OpenAsync();

                        var result = connection.QueryMultiple("usp_GetMaxNoID", new
                        {
                            @HotelcodeID = req.HotelcodeID,
                            @Action = req.Action

                        }, commandType: CommandType.StoredProcedure);

                        if (result != null)
                        {
                            var token = JwtHelper.GenerateJwtToken(req.Action, _config);
                            if (req.Action.ToLower() == "s")
                            {
                                var dataList = result.Read<HOTELCODE>().ToList();
                                data.dataList = dataList;
                                data.data = data.data;
                                data.token = token;
                            }
                            else
                            {
                                data.dataList = null;
                                data.token = token;
                            }
                            var returnInfo = result.Read().FirstOrDefault();
                            if (returnInfo != null)
                            {
                                data.returnCode = returnInfo.returnCode?.ToString();
                                data.returnMessage = returnInfo.returnMessage;
                            }
                        }
                        else
                        {
                            data.returnMessage = "No data found.";
                            data.returnCode = "201";
                        }
                    }
                }
                jsonString = JsonConvert.SerializeObject(data);

                //   Encrypt the response if needed
                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
                    return responseModel;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Error in HOTELCODE");

                //        Return a generic error response
                var errorResponse = new
                {
                    returnCode = "500",
                    returnMsg = $"Something went wrong! Error: {ex.Message}",
                    token = (string)null,
                    Data = new List<string>()
                };

                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(JsonConvert.SerializeObject(errorResponse), _base64Key);
                    return responseModel;
                }

                responseModel.responseText = JsonConvert.SerializeObject(errorResponse);
                return responseModel;
            }
            return responseModel;

        }*/
        //new
        public async Task<ResponseModel> HOTELCODE(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HOTELCODE>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @HotelcodeID = req.HotelcodeID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<HOTELCODE>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Hotel_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion hotelcode ends here

        #region Hotel Master        
        //new
        //public async Task<ResponseModel> HotelMaster(RequestModel request)
        //{
        //    try
        //    {


        //        // Decrypt and deserialize the request
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<HotelMaster>(request.RequestText);
        //        if (req != null)
        //        {
        //            if (req.Action == "USAP")
        //            {
        //                req.HotelCode = await SqlHelper.GetNewHotelCodeAsync(req.ChainIATACode);
        //            }


        //            var parameters = new
        //            {
        //                @HotelID = req.HotelID,
        //                @AccCode = req.AccCode,
        //                @HotelCode = req.HotelCode,
        //                @HotelName = req.HotelName,
        //                @HotelRatingID = req.HotelRatingID,
        //                @ChainIATACode = req.ChainIATACode,
        //                @ReuseAllocation = req.ReuseAllocation,
        //                @CityIATACode = req.CityIATACode,
        //                @Website = req.Website,
        //                @ZoneID = req.ZoneID,
        //                @PhoneNo = req.PhoneNo,
        //                @MobileNo = req.MobileNo,
        //                @FaxNo = req.FaxNo,
        //                @EmailID = req.EmailID,
        //                @PanNo = req.PanNo,
        //                @STRegNo = req.STRegNo,
        //                @ChequeFavouring = req.ChequeFavouring,
        //                @BankName = req.BankName,
        //                @Address = req.Address,
        //                @AccountNo = req.AccountNo,
        //                @CreateAdvanceAccount = req.CreateAdvanceAccount,
        //                @CreditApplicable = req.CreditApplicable,
        //                @CreditPeriod = req.CreditPeriod,
        //                @CreditCurrencyCode = req.CreditCurrencyCode,
        //                @CreditAmount = req.CreditAmount,
        //                @CreditApproveBy = req.CreditApproveBy,
        //                @InfantFromAge = req.InfantFromAge,
        //                @InfantToAge = req.InfantToAge,
        //                @ChildFromAge = req.ChildFromAge,
        //                @ChildToAge = req.ChildToAge,
        //                @AdultFromAge = req.AdultFromAge,
        //                @AdultToAge = req.AdultToAge,
        //                @IsActive = req.IsActive,
        //                @OperationBy = req.OperationBy,
        //                @Latitude = req.Latitude,
        //                @Longitude = req.Longitude,
        //                @CreateCommissionAccount = req.CreateCommissionAccount,
        //                @BankAccountID = req.BankAccountID,
        //                @HotelTypeID = req.HotelTypeID,
        //                @BranchName = req.BranchName,
        //                @IFSCCode = req.IFSCCode,
        //                @SWIFTCode = req.SWIFTCode,
        //                @Comment = req.Comment,
        //                @StateCode = req.StateCode,
        //                @SupplierID = req.SupplierID,
        //                @CompanyID = req.CompanyID,
        //                @GSTNID = req.GSTNID,
        //                @LegalName = req.LegalName,
        //                @BTCBranchPosting = req.BTCBranchPosting,
        //                @GSTRequired = req.GSTRequired,
        //                @IsActiveSAP = req.IsActiveSAP,
        //                @TANDetails = req.TANDetails,
        //                @PreviousCode = req.PreviousCode,
        //                @MSME = req.MSME,
        //                @Deductee = req.Deductee,
        //                @WithHoldigTax = req.WithHoldigTax,
        //                @RoomCount = req.RoomCount,
        //                @IsActiveMSME = req.IsActiveMSME,
        //                @MSMEType = req.MSMEType,
        //                @MSMERegFromDt = req.MSMERegFromDt,
        //                @MSMERegToDt = req.MSMERegToDt,
        //                @PostalCode = req.PostalCode,
        //                @LegalEntity = req.LegalEntity,
        //                @IsSEZ = req.IsSEZ,
        //                @MembershipNo = req.MembershipNo,
        //                @NonGSTRegistered = req.NonGSTRegistered,
        //                @PayMode = req.PayMode,
        //                @Action = req.Action,
        //                @Country = req.Country,
        //                @State = req.State,
        //                @City = req.City,
        //                @EmailGeneral = req.EmailGeneral,
        //                @EmailFinance = req.EmailFinance,
        //                @Beneficiary_Name = req.Beneficiary_Name,
        //                @Contact1 = req.Contact1,
        //                @Contact2 = req.Contact2,
        //                @Contact1IsMobile = req.Contact1IsMobile,
        //                @Contact2IsMobile = req.Contact2IsMobile,
        //                @HotelChainID = req.HotelChainID,
        //                @PageNumber = req.PageNumber,
        //                @HotelGroupID = req.HotelGroupID,
        //                @TaxType = req.TaxType,
        //                @Tax_Reg_Number = req.Tax_Reg_Number,
        //                @IsSapCompCode = req.IsSapCompCode
        //            };

        //            var data = new CommonClass.ResponseViewModel<HotelMaster>
        //            {
        //                data = req
        //            };


        //            if (req.Action.ToLower() == "s")
        //            {
        //                return CommonFunctions.ProcessDBDataPagination(data, req.Action, "usp_Hotel_Master", parameters);
        //            }
        //            else
        //            {

        //                return CommonFunctions.ProcessDBData(data, req.Action, "usp_Hotel_Master", parameters);
        //            }



        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
        //    }
        //}
        #endregion Hotel Master ends here

        public async Task<ResponseModel> HotelMaster(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelMaster>(request.RequestText);
                if (req != null)
                {
                    if (req.Action == "USAP")
                    {
                        // Check if ChainIATACode is valid before generating hotel code
                        if (!string.IsNullOrEmpty(req.ChainIATACode) && req.ChainIATACode.Length >= 3)
                        {
                            req.HotelCode = await SqlHelper.GetNewHotelCodeAsync(req.ChainIATACode);

                            string CollectionName = "HotelMaster";
                            //return CommonFunctions.ViewLogs(data, req);

                            MongoHelper mongo = new MongoHelper();

                            var Hotelparameters = new

                            {

                                @ID = req.HotelID,
                                @HotelCode = req.HotelCode,
                                @Action = req.Action,
                                @IsHotelCode = req.IsHotelCode

                            };

                            var hoteldata = new CommonClass.ResponseViewModel<HotelMaster>()
                            {
                                data = req
                            };
                            hoteldata.ID = req.HotelID;
                            CommonFunctions.ProcessMongoDBData(hoteldata, req.Action, "usp_Hotel_Master", Hotelparameters);
                        }
                        else
                        {
                            // Handle the case where ChainIATACode is invalid
                            return CommonFunctions.BlankResponse("201", "Invalid ChainIATACode. It must be at least 3 characters long.");
                        }
                        req.IsSapCompCode = true; // Set flag true when action is USAP
                    }
                    else
                    {
                        req.IsSapCompCode = false; // Or keep existing value for other actions if needed
                    }

                    var parameters = new
                    {
                        @HotelID = req.HotelID,
                        @AccCode = req.AccCode,
                        @HotelCode = req.HotelCode,
                        @HotelName = req.HotelName,
                        @HotelRatingID = req.HotelRatingID,
                        @ChainIATACode = req.ChainIATACode,
                        @ReuseAllocation = req.ReuseAllocation,
                        @CityIATACode = req.CityIATACode,
                        @Website = req.Website,
                        @ZoneID = req.ZoneID,
                        @PhoneNo = req.PhoneNo,
                        @MobileNo = req.MobileNo,
                        @FaxNo = req.FaxNo,
                        @EmailID = req.EmailID,
                        @PanNo = req.PanNo,
                        @STRegNo = req.STRegNo,
                        @ChequeFavouring = req.ChequeFavouring,
                        @BankName = req.BankName,
                        @Address = req.Address,
                        @AccountNo = req.AccountNo,
                        @CreateAdvanceAccount = req.CreateAdvanceAccount,
                        @CreditApplicable = req.CreditApplicable,
                        @CreditPeriod = req.CreditPeriod,
                        @CreditCurrencyCode = req.CreditCurrencyCode,
                        @CreditAmount = req.CreditAmount,
                        @CreditApproveBy = req.CreditApproveBy,
                        @InfantFromAge = req.InfantFromAge,
                        @InfantToAge = req.InfantToAge,
                        @ChildFromAge = req.ChildFromAge,
                        @ChildToAge = req.ChildToAge,
                        @AdultFromAge = req.AdultFromAge,
                        @AdultToAge = req.AdultToAge,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Latitude = req.Latitude,
                        @Longitude = req.Longitude,
                        @CreateCommissionAccount = req.CreateCommissionAccount,
                        @BankAccountID = req.BankAccountID,
                        @HotelTypeID = req.HotelTypeID,
                        @BranchName = req.BranchName,
                        @IFSCCode = req.IFSCCode,
                        @SWIFTCode = req.SWIFTCode,
                        @Comment = req.Comment,
                        @StateCode = req.StateCode,
                        @SupplierID = req.SupplierID,
                        @CompanyID = req.CompanyID,
                        @GSTNID = req.GSTNID,
                        @LegalName = req.LegalName,
                        @BTCBranchPosting = req.BTCBranchPosting,
                        @GSTRequired = req.GSTRequired,
                        @IsActiveSAP = req.IsActiveSAP,
                        @TANDetails = req.TANDetails,
                        @PreviousCode = req.PreviousCode,
                        @MSME = req.MSME,
                        @Deductee = req.Deductee,
                        @WithHoldigTax = req.WithHoldigTax,
                        @RoomCount = req.RoomCount,
                        @IsActiveMSME = req.IsActiveMSME,
                        @MSMEType = req.MSMEType,
                        @MSMERegFromDt = req.MSMERegFromDt,
                        @MSMERegToDt = req.MSMERegToDt,
                        @PostalCode = req.PostalCode,
                        @LegalEntity = req.LegalEntity,
                        @IsSEZ = req.IsSEZ,
                        @MembershipNo = req.MembershipNo,
                        @NonGSTRegistered = req.NonGSTRegistered,
                        @PayMode = req.PayMode,
                        @Action = req.Action,
                        @Country = req.Country,
                        @State = req.State,
                        @City = req.City,
                        @EmailGeneral = req.EmailGeneral,
                        @EmailFinance = req.EmailFinance,
                        @Beneficiary_Name = req.Beneficiary_Name,
                        @Contact1 = req.Contact1,
                        @Contact2 = req.Contact2,
                        @Contact1IsMobile = req.Contact1IsMobile,
                        @Contact2IsMobile = req.Contact2IsMobile,
                        @HotelChainID = req.HotelChainID,
                        @PageNumber = req.PageNumber,
                        @HotelGroupID = req.HotelGroupID,
                        @TaxType = req.TaxType,
                        @Tax_Reg_Number = req.Tax_Reg_Number,
                        @IsSapCompCode = req.IsSapCompCode,
                        @HotelSAPCode = req.HotelSAPCode
                    };

                    var data = new CommonClass.ResponseViewModel<HotelMaster>
                    {
                        data = req
                    };

                    if (req.Action.ToLower() == "s")
                    {
                        return CommonFunctions.ProcessDBDataPagination(data, req.Action, "usp_Hotel_Master", parameters);
                    }
                    else
                    {
                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_Hotel_Master", parameters);
                    }
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }



        #region HotelRoomCategoryTab starts here        
        //new
        public async Task<ResponseModel> HotelRoomCategoryTab(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelRoomCategoryTab>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @HotelRoomCategoryID = req.HotelRoomCategoryID,
                        @HotelID = req.HotelID,
                        @RoomCategoryID = req.RoomCategoryID,
                        @NoOfRooms = req.NoOfRooms,
                        @MaxAdult = req.MaxAdult,
                        @ExtraBedMattress = req.ExtraBedMattress,
                        @IsInterconnecting = req.IsInterconnecting,
                        @NoOfInterconnectingRoom = req.NoOfInterconnectingRoom,
                        @IsActive = req.IsActive,
                        @NoOfBedrooms = req.NoOfBedrooms,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<HotelRoomCategoryTab>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_InsertHotelRoomCategory", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion HotelRoomCategoryTab ends here

        #region HotelContactDetailsTab starts here

        //new
        public async Task<ResponseModel> HotelContactDetailsTab(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelContactDetailsTab>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ParentID = req.ParentID,
                        @TypeID = req.TypeID,
                        @IsPrimaryContact = req.IsPrimaryContact,
                        @SalutationID = req.SalutationID,
                        @FirstName = req.FirstName,
                        @LastName = req.LastName,
                        @DesignationOrDepartment = req.DesignationOrDepartment,
                        @EmailID = req.EmailID,
                        @OfficeNo = req.OfficeNo,
                        @MobileNo = req.MobileNo,
                        @FaxNo = req.FaxNo,
                        @DateOfBirth = req.DateOfBirth,
                        @CityIATACode = req.CityIATACode,
                        @InsertedDate = req.InsertedDate,
                        @IsActive = req.IsActive,
                        @IsAccStatement = req.IsAccStatement,
                        @IsCC = req.IsCC,
                        @IsForContracting = req.IsForContracting,
                        @IsBills = req.IsBills,
                        @CreatedBy = req.CreatedBy,
                        @ContactDetailsID = req.ContactDetailsID,
                        @ID = req.ID,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy,
                        @HideNumberEmail = req.HideNumberEmail

                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<HotelContactDetailsTab>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ContactDetails_Tab_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion HotelContactDetailsTab ends here

        #region hotelrule starts here        
        //new
        public async Task<ResponseModel> HotelRuleTab(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelRuleTab>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @HotelRuleID = req.HotelRuleID,
                        @HotelID = req.HotelID,
                        @RuleID = req.RuleID,
                        @MISSequenceNo = req.MISSequenceNo,
                        @ApplicableTo = req.ApplicableTo,
                        @Description = req.Description,
                        @Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<HotelRuleTab>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_InsertUpdateHotelRule", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion hotelrule ends here

        #region HotelSAPCompCode starts here        
        //new
        public async Task<ResponseModel> HotelSAPCompCode(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelSAPCompCode>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @SAPCompCodeID = req.SAPCompCodeID,
                        @ParentId = req.ParentId,
                        @TypeId = req.TypeId,
                        @ID = req.ID,
                        @BPCode = req.BPCode,
                        @IsActive = req.IsActive,
                        @CreatedBy = req.CreatedBy,
                        @UpdatedBy = req.UpdatedBy,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<HotelSAPCompCode>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_InsertUpdateSAPCompCode", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion HotelSAPCompCode ends here

        #region hotelannouncmemnt starts here        
        //new
        public async Task<ResponseModel> HotelAnnouncement(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelAnnouncement>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @AnnouncementID = req.AnnouncementID,
                        @HotelID = req.HotelID,
                        @HeaderID = req.HeaderID,
                        @AnnouncementDetails = req.AnnouncementDetails,
                        @CityID = req.CityID,
                        @ValidTo = req.ValidTo,
                        @Action = req.Action,
                        @ChainIATACode = req.ChainIATACode,
                        @OperationBy = req.OperationBy
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<HotelAnnouncement>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_HotelAnnouncement", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion hotelannouncement ends here
        #region companymaster starts here
        //new
        public async Task<ResponseModel> CompanyMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<CompanyMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @CompanyName = req.CompanyName,
                        @HeadOffice = req.HeadOffice,
                        @PrintHeadOffAddress = req.PrintHeadOffAddress,
                        @Address = req.Address,
                        @CityIATACode = req.CityIATACode,
                        @Phone = req.Phone,
                        @Fax = req.Fax,
                        @Website = req.Website,
                        @Email = req.Email,
                        @PanNo = req.PanNo,
                        @LSTNo = req.LSTNo,
                        @CSTNo = req.CSTNo,
                        @VATNo = req.VATNo,
                        @STNo = req.STNo,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @StateCode = req.StateCode,
                        @SAP_StateCode = req.SAP_StateCode,
                        @SAP_CompanyCode = req.SAP_CompanyCode,
                        @PostalCode = req.PostalCode,
                        @SAP_BusinessPlaceCode = req.SAP_BusinessPlaceCode,
                        @CIN = req.CIN,
                        @MSME_RegNo = req.MSME_RegNo,
                        @RegAddress = req.RegAddress,
                        @BranchAddress = req.BranchAddress,
                        @CompCode = req.CompCode,
                        @CurrencyComp_id = req.CurrencyComp_id,
                        @NotesForInvoice = req.NotesForInvoice,
                        @LegalName = req.LegalName,
                        @EmailIDForXO = req.EmailIDForXO,
                        @TwoDigitStateCode = req.TwoDigitStateCode,
                        @Action = req.Action,
                        @CompanyID = req.CompanyID,
                        //@Active = req.Active,
                        @TEntity_ID = req.TEntity_ID,
                        @Country = req.Country,
                        @salesTaxRegNumber = req.salesTaxRegNumber,
                        @tanNumber = req.tanNumber
                        ,
                        @StateID = req.StateID,
                        @PANVERIFICATION = req.PANVERIFICATION,
                        @TANVERIFICATION = req.TANVERIFICATION,
                        @GSTVERIFICATION = req.GSTVERIFICATION,
                        @TaxType = req.TaxType,
                        @PageNumber = req.PageNumber,

                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<CompanyMaster>
                    {
                        data = req
                    };
                    var distinctData = data.dataList?
                    .GroupBy(c => c.CompanyID)
                    .Select(g => g.First())
                    .ToList();

                    data.dataList = distinctData;

                    if (req.Action.ToLower() == "sa")
                    {
                        return CommonFunctions.ProcessDBDataPagination(data, req.Action, "usp_CompanyMaster", parameters);
                    }
                    else
                    {
                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_CompanyMaster", parameters);
                    }

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion companymaster ends here

        #region employeemaster starst here        
        //new
        public async Task<ResponseModel> EmployeeMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<EmployeeMaster>(request.RequestText);

                if (req != null)
                {
                    if (!string.IsNullOrEmpty(req.CompanyID))
                    {
                        var companyIds = req.CompanyID.Split(',')
                            .Distinct()
                            .ToArray();

                        req.CompanyIDs = string.Join(",", companyIds);
                    }
                    Guid useridN;
                    if (req.Action == "I")
                    {
                        useridN = Guid.NewGuid();

                    }
                    else
                    {
                        useridN = req.UserID;

                    }
                    var parameters = new
                    {
                        @EmpID = req.EmpID,
                        @EmpCode = req.EmpCode,
                        @RoleId = req.RoleId,
                        @userid = useridN,
                        @SalutationID = req.SalutationID,
                        @Gender = req.Gender,
                        @EmpName = req.EmpName,
                        @Address = req.Address,
                        @CityIATACode = req.CityIATACode,
                        @ResPhoneNo = req.ResPhoneNo,
                        @MobileNo = req.MobileNo,
                        @PersonalEmail = req.PersonalEmail,
                        @CompanyID = req.CompanyID,
                        @DateOfBirth = req.DateOfBirth,
                        @DateOfJoining = req.DateOfJoining,
                        @DateOfRetirement = req.DateOfRetirement,
                        @DesignationID = req.DesignationID,
                        @DepartmentID = req.DepartmentID,
                        @ReportHeadID = req.ReportHeadID,
                        @OffEmail = req.OffEmail,
                        @OffPhone = req.OffPhone,
                        @Pan = req.Pan,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @LevelID = req.LevelID,
                        @IsSales = req.IsSales,
                        @Action = req.Action,
                        @IsRemembered = req.IsRemembered
                        ,
                        @Level1UID = req.Level1UID
                        ,
                        @Level2UID = req.Level2UID
                        ,
                        @Level3UID = req.Level3UID
                        ,
                        @CreditNoteApp = req.CreditNoteApp
                        ,
                        @AdvancesApp = req.AdvancesApp
                        ,
                        @UserName = req.UserName,
                        @Password = req.Password,
                        @MarketIDs = req.MarketIDs,
                        @BusinessTypeIDs = req.BusinessTypeIDs,
                        @CompanyIDs = req.CompanyIDs,
                        @YearID = req.YearID,
                        @ViewRights = req.ViewRights,
                        @AsPerAdminRules = req.AsPerAdminRules
                    };
                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<EmployeeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Employee_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion employeemaster ends here

        #region gstpercentmaster starts here
        //new
        public async Task<ResponseModel> GSTPercentageMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GSTPercentageMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @GSTID = req.GSTID,
                        @GSTPercentage = req.GSTPercentage,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                    };

                    // Call the stored procedure
                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<GSTPercentageMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_InsertGST_Percentage", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion gstpercentagemaster ends here

        #region withholdingtax stars here
        //new
        public async Task<ResponseModel> WithholdingTaxMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<WithholdingTaxMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Tax_ID = req.Tax_ID,
                        @Tax_Code = req.Tax_Code,
                        @Description = req.Description,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    // Call the stored procedure
                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<WithholdingTaxMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_WithholdingTax_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion withholdingtaxends here

        #region placeofsupplylogic starts here
        //new
        public async Task<ResponseModel> PlaceOfSupplyLogic(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<PlaceOfSupplyLogic>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @TypeID = req.TypeID,
                        @ServiceID = req.ServiceID,
                        @BuyerLocationID = req.BuyerLocationID,
                        @IsGST = req.IsGST,
                        @IsAddress = req.IsAddress,
                        @ServiceLocID = req.ServiceLocID,
                        @POSID = req.POSID,
                        @POSStateCode = req.POSStateCode,
                        @IsCommercial = req.IsCommercial,
                        @IsActive = req.IsActive,
                        @CreatedBy = req.CreatedBy,
                        @ValidFrom = req.ValidFrom == null ? (DateTime?)null : DateTime.Parse(req.ValidFrom.ToString()),
                        @ValidTo = req.ValidTo == null ? (DateTime?)null : DateTime.Parse(req.ValidTo.ToString()),
                        @Action = req.Action,
                        @ID = req.ID
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<PlaceOfSupplyLogic>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_PlaceOfSupplyLogicMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion placeofsupplylogic ends here

        #region gsttype starts here
        //new
        public async Task<ResponseModel> GSTTypeMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GSTTypeMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @GSTID = req.GSTID,
                        @GstTypename = req.GstTypename,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    //// Ensure you are calling the correct stored procedure here
                    //var data = new CommonClass.ResponseViewModel<GSTTypeMaster>
                    //{
                    //    data = req
                    //};
                    //return CommonFunctions.ProcessDBData(data, req.Action, "GSTTypeMaster_proc", parameters);

                    if (req.Action.ToLower() == "ex")
                    {
                        // Manually map GSTTypeMaster to GSTTypeMasterExportModel
                        var exportModel = new GSTTypeMasterExportModel
                        {
                            GSTID = req.GSTID,
                            GSTTypeName = req.GstTypename,
                            IsActive = req.IsActive
                            // Add more mappings if GSTTypeMasterExportModel has extra properties
                        };

                        var data = new CommonClass.ResponseViewModel<GSTTypeMasterExportModel>
                        {
                            data = exportModel
                        };

                        return CommonFunctions.ProcessDBData(data, req.Action, "GSTTypeMaster_proc", parameters);
                    }
                    else
                    {
                        var data = new CommonClass.ResponseViewModel<GSTTypeMaster>
                        {
                            data = req
                        };

                        return CommonFunctions.ProcessDBData(data, req.Action, "GSTTypeMaster_proc", parameters);
                    }



                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }




        #endregion gstype ends here

        #region tcsrateconfig starts here
        //new
        public async Task<ResponseModel> TCSRateConfig(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<TCSRateConfig>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @BillingTo = req.BillingTo,
                        @FromDate = req.FromDate,
                        @ToDate = req.ToDate,
                        @PANExists = req.PANExists,
                        @AddressonRecord = req.AddressonRecord,
                        @AgentMasterCountryIN = req.AgentMasterCountryIN,
                        @Resident = req.Resident,
                        @TCSRateID = req.TCSRateID,
                        @ViewDetailsID = req.ViewDetailsID,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        //@Updatedby = req.Updatedby,
                        @TCSRateConfigID = req.TCSRateConfigID,
                        @TDSDeduction = req.TDSDeduction
                    };
                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<TCSRateConfig>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_TCSRateConfig", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion tcsrateconfig ends here

        #region ItineraryInclusionsExclusions starts here
        //new
        public async Task<ResponseModel> ItineraryInclusionsExclusions(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryInclusionsExclusions>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @Country_IATACode = req.Country_IATACode,
                        @City_IATACode = req.City_IATACode,
                        @Type = req.Type,
                        @Header = req.Header,
                        @Description = req.Description,
                        @IsActive = req.IsActive,
                        @IsDefault = req.IsDefault,
                        @SeqNo = req.SeqNo,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<ItineraryInclusionsExclusions>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_ItineraryInclusionsExclusions", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ItineraryInclusionsExclusions ends here

        //#region legalentitymaster starts here
        //public async Task<ResponseModel> LegalEntityMastityerModel(RequestModel request)
        //{

        //    try
        //    {
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<LegalEntityMasterModel>(request.RequestText);
        //        if (req != null)
        //        {


        //            var parameters = new
        //            {
        //                @LegalName = req.LegalName,
        //                @RegisteredAddress = req.RegisteredAddress,
        //                @CountryOfRegistration = req.CountryOfRegistration,
        //                @PostalCode = req.PostalCode,
        //                @SAPCompCode = req.SAPCompCode,
        //                @CIN = req.CIN,
        //                @PAN = req.PAN,
        //                @TAN = req.TAN,
        //                @VAT = req.VAT,
        //                @TRN = req.TRN,
        //                @MSMENo = req.MSMENo,
        //                @RegisteredEmail = req.RegisteredEmail,
        //                @TwoCharacterCompCode = req.TwoCharacterCompCode,
        //                @IsActive = req.IsActive,
        //                @OperationBy = req.OperationBy,
        //                @ID = req.ID,
        //                @Action = req.Action,
        //                Fiscal_ID = req.Fiscal_ID,


        //            };

        //            // Ensure you are calling the correct stored procedure here
        //            var data = new CommonClass.ResponseViewModel<LegalEntityMasterModel>();
        //            return CommonFunctions.ProcessDBData(data, req.Action, "usp_EntityMaster", parameters);

        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
        //    }
        //}
        //#endregion legalentitymaster ends here

        #region EmployeeTarget STARTS HERE
        //new
        public async Task<ResponseModel> EmployeeTarget(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<EmployeeTarget>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @EmployeeTargetID = req.EmployeeTargetID,
                        @CompanyID = req.CompanyID,
                        @StaffName = req.StaffName,
                        @YearID = req.YearID,
                        @YearCode = req.YearCode,
                        @Currency = req.Currency,
                        @Type = req.Type,
                        @Apr_Topline = req.Apr_Topline,
                        @Apr_GOP = req.Apr_GOP,
                        @May_Topline = req.May_Topline,
                        @May_GOP = req.May_GOP,
                        @Jun_Topline = req.Jun_Topline,
                        @Jun_GOP = req.Jun_GOP,
                        @Jul_Topline = req.Jul_Topline,
                        @Jul_GOP = req.Jul_GOP,
                        @Aug_Topline = req.Aug_Topline,
                        @Aug_GOP = req.Aug_GOP,
                        @Sep_Topline = req.Sep_Topline,
                        @Sep_GOP = req.Sep_GOP,
                        @Oct_Topline = req.Oct_Topline,
                        @Oct_GOP = req.Oct_GOP,
                        @Nov_Topline = req.Nov_Topline,
                        @Nov_GOP = req.Nov_GOP,
                        @Dec_Topline = req.Dec_Topline,
                        @Dec_GOP = req.Dec_GOP,
                        @Jan_Topline = req.Jan_Topline,
                        @Jan_GOP = req.Jan_GOP,
                        @Feb_Topline = req.Feb_Topline,
                        @Feb_GOP = req.Feb_GOP,
                        @Mar_Topline = req.Mar_Topline,
                        @Mar_GOP = req.Mar_GOP,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @EmpID = req.EmpID
                       
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<EmployeeTarget>
                    {
                        data = req
                    };

                   
                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_EmployeeTargetNew", parameters);
                   

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion EmployeeTarget ENDS HERE

        #region gststatus starts here
        //new
        public async Task<ResponseModel> GSTstatusMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GSTstatusMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @State_ID = req.State_ID,
                        @Status_ID = req.Status_ID,
                        @EffectiveDate = req.EffectiveDate,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<GSTstatusMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GstStatus", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion gststatus ENDS HERE
        #region ItineraryDescription starts here
        //new
        public async Task<ResponseModel> ItineraryDescription(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryDescription>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ItineraryDescID = req.ItineraryDescID,
                        @ItineraryCode = req.ItineraryCode,
                        @Country_IATACode = req.Country_IATACode,
                        @City_IATACode = req.City_IATACode,
                        @City2_IATACode = req.City2_IATACode,
                        @Header = req.Header,
                        @ShortDescription = req.ShortDescription,
                        @DetailDescription = req.DetailDescription,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<ItineraryDescription>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_ItineraryDescriptionMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ItineraryDescription ENDS HERE
        #region entitymaster starts here
        public async Task<ResponseModel> EntityMasterModel(RequestModel request)
        {

            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<EntityMasterModel>(request.RequestText);
                if (req != null)
                {


                    var parameters = new
                    {
                        @LegalName = req.LegalName,
                        @RegisteredAddress = req.RegisteredAddress,
                        @CountryOfRegistration = req.CountryOfRegistration,
                        @PostalCode = req.PostalCode,
                        @SAPCompCode = req.SAPCompCode,
                        @CIN = req.CIN,
                        @PAN = req.PAN,
                        @TAN = req.TAN,
                        @VAT = req.VAT,
                        @TRN = req.TRN,
                        @MSMENo = req.MSMENo,
                        @RegisteredEmail = req.RegisteredEmail,
                        @TwoCharacterCompCode = req.TwoCharacterCompCode,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @ID = req.ID,
                        @Action = req.Action,
                        @Fiscal_ID = req.Fiscal_ID,
                        @TIDS_Code = req.TIDS_Code,
                        @IATA_Code = req.IATA_Code,
                        @IATO_Code = req.IATO_Code,
                        @SalesTaxRegNumber = req.SalesTaxRegNumber,
                        @TaxType = req.TaxType,
                        @PageNumber = req.PageNumber,

                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<EntityMasterModel>
                    {
                        data = req
                    };

                    if (req.Action.ToLower() == "sa")
                    {
                        return CommonFunctions.ProcessDBDataPagination(data, req.Action, "usp_EntityMaster", parameters);
                    }
                    else
                    {
                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_EntityMaster", parameters);
                    }

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion entitymaster ends here

        #region AgentBranchMapping starts 
        //new
        public async Task<ResponseModel> AgentBranchMapping(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgentBranchMapping>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @AgentBranchID = req.AgentBranchID,
                        @AgentID = req.AgentID,
                        @BranchName = req.BranchName,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<AgentBranchMapping>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_InsertUpdateAgentBranchMapping", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion AgentBranchMapping ends here

        #region otherservicetax starts here
        public async Task<ResponseModel> OtherServiceTax(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<OtherServiceTax>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @TaxID = req.TaxID,
                        @TaxCode = req.TaxCode,
                        @TaxDescription = req.TaxDescription,
                        @TaxRate = req.TaxRate,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<OtherServiceTax>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_OtherServiceTax_M", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion otherservicetax ends here

        #region Withholding_Tax starts here
        public async Task<ResponseModel> Withholding_Tax(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<Withholding_Tax>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Active = req.Active,
                    };

                    var data = new CommonClass.ResponseViewModel<Withholding_Tax>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetWithholdingTax", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Withholding_Tax ends here

        #region SapCompCode starts here
        public async Task<ResponseModel> SapCompCode(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SapCompCode>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Action = req.Action,
                        @ID = req.ID,
                    };

                    var data = new CommonClass.ResponseViewModel<SapCompCode>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_GETSAPCompCode", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SapCompCode ends here


        #region SearchAgentLinkedDocuments 
        public async Task<ResponseModel> SearchAgentLinkedDocuments(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SearchAgentMasterUploadDocuments>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @AgentCode = req.AgentCode,
                        @AgentID = req.AgentID,
                        @DocumentName = req.DocumentName,
                        @ParentID = req.ParentID
                    };

                    var data = new CommonClass.ResponseViewModel<SearchAgentMasterUploadDocuments>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, "S", "usp_SearchAgentMasterUploadDocuments", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchAgentMasterUploadDocuments ends here

        #region SearchHotelLinkedDocuments 
        public async Task<ResponseModel> SearchHotelLinkedDocuments(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SearchHotelMasterUploadDocuments>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @HotelCode = req.HotelCode,
                        @HotelID = req.HotelID,
                        @DocumentName = req.DocumentName,
                        @ParentTypeID = req.ParentTypeID,
                        @ParentID = req.ParentID
                    };

                    var data = new CommonClass.ResponseViewModel<SearchHotelMasterUploadDocuments>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, "S", "usp_SearchHotelMasterUploadDocuments", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchHotelLinkedDocuments ends here

        #region SearchVendorLinkedDocuments 
        public async Task<ResponseModel> SearchVendorLinkedDocuments(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SearchVendorMasterUploadDocuments>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @VendorCode = req.VendorCode,
                        @VendorID = req.VendorID,
                        @DocumentName = req.DocumentName,
                        @ParentID = req.ParentID
                    };

                    var data = new CommonClass.ResponseViewModel<SearchVendorMasterUploadDocuments>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, "S", "usp_SearchVendorMasterUploadDocuments", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SearchVendorLinkedDocuments ends here

        #region CustomerLinkedDocuments 
        public async Task<ResponseModel> CustomerLinkedDocuments(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<CustomerMasterUploadDocuments>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @CustomerCode = req.CustomerCode,
                        @CustomerID = req.CustomerID,
                        @DocumentName = req.DocumentName,
                        @ParentID = req.ParentID

                    };

                    var data = new CommonClass.ResponseViewModel<CustomerMasterUploadDocuments>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, "S", "usp_SearchCustomerUploadDocuments", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion CustomerLinkedDocuments ends here


        #region ItineraryDescDetails 
        public async Task<ResponseModel> ItineraryDescDetails(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryDescDetails>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @ItineraryDescID = req.ItineraryDescID,
                        @ServiceType = req.ServiceType,
                        @ServiceID = req.ServiceID,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<ItineraryDescDetails>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_ItineraryDescDetails", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ItineraryDescDetails ends here



        #region EmployeeMarketMapping 
        private async Task<ResponseModel> EmployeeMarketMapping(int EmpID, int MarketID)
        {
            try
            {
                // Decrypt and deserialize the request
                // var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryDescDetails>(request.RequestText);




                if (EmpID != null)
                {

                    var parameters = new
                    {
                        @EmpID = EmpID,
                        @MarketID = MarketID,

                    };

                    var data = new CommonClass.ResponseViewModel<EmployeeMaster>();

                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_InsertEmployeeMarketMap", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion EmployeeMarketMapping ends here


        #region DeletenaddMarketMapping 
        private async Task<ResponseModel> DeletenaddMarketMapping(int EmpID)
        {
            try
            {
                // Decrypt and deserialize the request
                // var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryDescDetails>(request.RequestText);




                if (EmpID != null)
                {

                    var parameters = new
                    {
                        @EmpID = EmpID,

                    };

                    var data = new CommonClass.ResponseViewModel<EmployeeMaster>();

                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_DeleteEmployeeMarketMap", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion EmployeeMarketMapping ends here

        #region EmployeeBusinessType 
        private async Task<ResponseModel> EmployeeBusinessType(int EmpID, int BusinessTypeID)
        {
            try
            {
                // Decrypt and deserialize the request
                // var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryDescDetails>(request.RequestText);




                if (EmpID != null)
                {

                    var parameters = new
                    {
                        @EmpID = EmpID,
                        @BusinessTypeID = BusinessTypeID,

                    };

                    var data = new CommonClass.ResponseViewModel<EmployeeMaster>();

                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_InsertEmployeeBusinessType", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion EmployeeBusinessType ends here

        #region DeleteEmployeeBusinessType 
        private async Task<ResponseModel> DeleteEmployeeBusinessType(int EmpID)
        {
            try
            {
                // Decrypt and deserialize the request
                // var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryDescDetails>(request.RequestText);




                if (EmpID != null)
                {

                    var parameters = new
                    {
                        @EmpID = EmpID,

                    };

                    var data = new CommonClass.ResponseViewModel<EmployeeMaster>();

                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_DeleteEmployeeBusinessType", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion DeleteEmployeeBusinessType ends here

        #region InsertEmployeeCompanyYearMap 
        private async Task<ResponseModel> InsertEmployeeCompanyYearMap(int EmpID, int CompanyID, int YearID, bool ViewRights, bool AsPerAdminRules)
        {
            try
            {
                // Decrypt and deserialize the request
                // var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryDescDetails>(request.RequestText);
                if (EmpID != null)
                {

                    var parameters = new
                    {
                        @EmpID = EmpID,
                        @CompanyID = CompanyID,
                        @YearID = YearID,
                        @ViewRights = ViewRights,
                        @AsPerAdminRules = AsPerAdminRules
                    };

                    var data = new CommonClass.ResponseViewModel<EmployeeMaster>();

                    return CommonFunctions.ProcessDBData_WitoutAction(data, "USP_INSERTEmployeeCompanyYearMap", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion InsertEmployeeCompanyYearMap ends here

        #region UpdateemployeeCompanyYearMap 
        private async Task<ResponseModel> UpdateemployeeCompanyYearMap(int EmpID, int CompanyID, int YearID, bool ViewRights, bool AsPerAdminRules)
        {
            try
            {
                // Decrypt and deserialize the request
                // var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryDescDetails>(request.RequestText);

                if (EmpID != null)
                {

                    var parameters = new
                    {
                        @EmpID = EmpID,
                        @CompanyID = CompanyID,
                        @YearID = YearID,
                        @ViewRights = ViewRights,
                        @AsPerAdminRules = AsPerAdminRules
                    };

                    var data = new CommonClass.ResponseViewModel<EmployeeMaster>();

                    return CommonFunctions.ProcessDBData_WitoutAction(data, "USP_UpdateemployeeCompanyYearMap", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion UpdateemployeeCompanyYearMap ends here

        #region customermaster starts here
        //public async Task<ResponseModel> CustomerMaster(RequestModel request)
        //{
        //    try
        //    {
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<CustomerMaster>(request.RequestText);
        //        if (req != null)
        //        {
        //            var parameters = new
        //            {
        //                @ContactID = req.ContactID,
        //                @IsPrimaryContact = req.IsPrimaryContact,
        //                @PrimaryContactID = req.PrimaryContactID,
        //                @Reference = req.Reference,
        //                @RelationToPrimaryContact = req.RelationToPrimaryContact,
        //                @Gender = req.Gender,
        //                @Name = req.Name,
        //                @Surname = req.Surname,
        //                @Email = req.Email,
        //                @AlternateEmail = req.AlternateEmail,
        //                @Mobile = req.Mobile,
        //                @AlternateMobile = req.AlternateMobile,
        //                @Address = req.Address,
        //                @AddressCountry = req.AddressCountry,
        //                @AddressState = req.AddressState,
        //                @StateCode = req.StateCode,
        //                @AddressCity = req.AddressCity,
        //                @PostalCode = req.PostalCode,
        //                @Nationality = req.Nationality,
        //                @DateOfBirth = req.DateOfBirth,
        //                @PassportNo = req.PassportNo,
        //                @PassportDateOfIssue = req.PassportDateOfIssue,
        //                @PassportPlaceOfIssue = req.PassportPlaceOfIssue,
        //                @PassportDateOfExpiry = req.PassportDateOfExpiry,
        //                @PAN = req.PAN,
        //                @MealPreference = req.MealPreference,
        //                @Allergies = req.Allergies,
        //                @Promotions = req.Promotions ,
        //                @SpecialRequirements = req.SpecialRequirements,
        //                @SeniorCitizen = req.SeniorCitizen,
        //                @Tags = req.Tags,
        //                @CustCategory = req.CustCategory,
        //                @Organization = req.Organization,
        //                @Designation = req.Designation,
        //                @FlightClassPreference = req.FlightClassPreference,
        //                @Action = req.Action
        //            };

        //            var data = new CommonClass.ResponseViewModel<CustomerMaster>();
        //            return CommonFunctions.ProcessDBData(data, req.Action, "ManageContact", parameters);
        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Operation Failed");
        //    }
        //}

        //public async Task<ResponseModel> CustomerMaster(RequestModel request)
        //{
        //    try
        //    {
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<CustomerMaster>(request.RequestText);
        //        if (req != null)
        //        {
        //            var parameters = new
        //            {
        //                @ContactID = req.ContactID,
        //                @IsPrimaryContact = req.IsPrimaryContact,
        //                @PrimaryContactID = req.PrimaryContactID,
        //                @Reference = req.Reference,
        //                @RelationToPrimaryContact = req.RelationToPrimaryContact,
        //                @Gender = req.Gender,
        //                @Name = req.Name,
        //                @Surname = req.Surname,
        //                @Email = req.Email,
        //                @AlternateEmail = req.AlternateEmail,
        //                @Mobile = req.Mobile,
        //                @AlternateMobile = req.AlternateMobile,
        //                @Address = req.Address,
        //                @AddressCountry = req.AddressCountry,
        //                @AddressState = req.AddressState,
        //                @StateCode = req.StateCode,
        //                @AddressCity = req.AddressCity,
        //                @PostalCode = req.PostalCode,
        //                @Nationality = req.Nationality,
        //                @DateOfBirth = req.DateOfBirth,
        //                @PassportNo = req.PassportNo,
        //                @PassportDateOfIssue = req.PassportDateOfIssue,
        //                @PassportPlaceOfIssue = req.PassportPlaceOfIssue,
        //                @PassportDateOfExpiry = req.PassportDateOfExpiry,
        //                @PAN = req.PAN,
        //                @MealPreference = req.MealPreference,
        //                @Allergies = req.Allergies,
        //                @Promotions = req.Promotions,
        //                @SpecialRequirements = req.SpecialRequirements,
        //                @SeniorCitizen = req.SeniorCitizen,
        //                @Tags = req.Tags,
        //                @CustCategory = req.CustCategory,
        //                @Organization = req.Organization,
        //                @Designation = req.Designation,
        //                @FlightClassPreference = req.FlightClassPreference,
        //                @Action = req.Action,
        //                @IsCustomer = req.IsCustomer 
        //            };

        //            var data = new CommonClass.ResponseViewModel<CustomerMaster>();
        //            var result = CommonFunctions.ProcessDBData(data, req.Action, "ManageContact", parameters);
        //            //var req1 = CommonFunctions.DecryptAndDeserializeRequest<CustomerMaster>(result.responseText);

        //            // Check if IsEnquiry is 0 and filter the response
        //            if ((req.IsCustomer ? true : false) == false)
        //            {
        //                if ( req is CustomerMaster customerData)
        //                {
        //                    // Create a new object with only the required fields
        //                    var filteredData = new CustomerMaster
        //                    {
        //                        Name = customerData.Name,
        //                        AddressCity = customerData.AddressCity,
        //                        Email = customerData.Email,
        //                        Mobile = customerData.Mobile
        //                    };
        //                    result.Data = filteredData;
        //                }
        //            }

        //            return result;
        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Operation Failed");
        //    }
        //}

        public async Task<ResponseModel> CustomerMaster(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeNullRequest<CustomerMaster>(request.RequestText);

                if (req == null)
                    return CommonFunctions.BlankResponse("201", "Invalid request.");

                var parameters = new
                {
                    @CustomerCode = req.CustomerCode,
                    @CountryName = req.CountryName,
                    @FullName = req.FullName,
                    @Gender = req.Gender,
                    @Email = req.Email,
                    @Mobile = req.Mobile,
                    @SalesRep = req.SalesRep,
                    @Address = req.Address,
                    @Country = req.Country,
                    @StateID = req.StateID,
                    @StateCode = req.StateCode,
                    @CityID = req.CityID,
                    @PostalCode = req.PostalCode,
                    @NationalityID = req.NationalityID,
                    @DateOfBirth = req.DateOfBirth,
                    @CurrentAge = req.CurrentAge,
                    @PassportNo = req.PassportNo,
                    @FirstName = req.FirstName,
                    @LastName = req.LastName,
                    @PassportDateOfIssue = req.PassportDateOfIssue,
                    @PassportPlaceOfIssue = req.PassportPlaceOfIssue,
                    @PassportDateOfExpiry = req.PassportDateOfExpiry,
                    @PAN = req.PAN,
                    @PANName = req.PANName,
                    @TAN = req.TAN,
                    @MealPlanID = req.MealPlanID,
                    @Allergies = req.Allergies,
                    @SpecialRequirements = req.SpecialRequirements,
                    @SeniorCitizen = req.SeniorCitizen,
                    @Organization = req.Organization,
                    @Designation = req.Designation,
                    @FlightClassPreference = req.FlightClassPreference,
                    @Refererralname = req.Refererralname,
                    @CustomerType = req.CustomerType,
                    @SAPCompCode = req.SAPCompCode,
                    @Action = req.Action,
                    @IsCustomer = req.IsCustomer,
                    @CID = req.CID,
                    @LeadID = req.LeadID,
                    @OperationBy = req.OperationBy
                };

                // Special Handling for Excel Export
                if (req.Action.ToUpper() == "EX")
                {
                    var excelData = new CommonClass.ResponseViewModel<customermasterexcel>
                    {
                        data = new customermasterexcel
                        {
                            CustomerCode = req.CustomerCode,
                            CountryName = req.CountryName,
                            FullName = req.FullName,
                            Gender = req.Gender,
                            Email = req.Email,
                            Mobile = req.Mobile,
                            SalesRep = req.SalesRep,
                            Address = req.Address,
                            Country = req.Country,
                            StateCode = req.StateCode,
                            PostalCode = req.PostalCode,
                            DateOfBirth = req.DateOfBirth,
                            CurrentAge = req.CurrentAge,
                            PassportNo = req.PassportNo,
                            FirstName = req.FirstName,
                            LastName = req.LastName,
                            PassportDateOfIssue = req.PassportDateOfIssue,
                            PassportPlaceOfIssue = req.PassportPlaceOfIssue,
                            PassportDateOfExpiry = req.PassportDateOfExpiry,
                            PAN = req.PAN,
                            PANName = req.PANName,
                            TAN = req.TAN,
                            Allergies = req.Allergies,
                            SpecialRequirements = req.SpecialRequirements,
                            SeniorCitizen = req.SeniorCitizen,
                            Organization = req.Organization,
                            Designation = req.Designation,
                            FlightClassPreference = req.FlightClassPreference,
                            Refererralname = req.Refererralname,
                            CustomerType = req.CustomerType,
                            SAPCompCode = req.SAPCompCode,
                            Action = req.Action
                        }
                    };

                    return CommonFunctions.ProcessDBData(excelData, req.Action, "usp_CustomerMaster", parameters);
                }

                // Handle normal save/update/etc.
                var responseViewModel = new CommonClass.ResponseViewModel<CustomerMaster>
                {
                    data = req
                };

                var result = CommonFunctions.ProcessDBData(responseViewModel, req.Action, "usp_CustomerMaster", parameters);

                // Filter result if not a customer
                if (!req.IsCustomer && req is CustomerMaster customerData)
                {
                    var filteredData = new CustomerMaster
                    {
                        FullName = customerData.FullName,
                        CityID = customerData.CityID,
                        Email = customerData.Email,
                        Mobile = customerData.Mobile
                    };

                    responseViewModel.data = filteredData;
                    result.Data = CommonFunctions.ProcessResult1(responseViewModel);
                }

                return result;
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Operation Failed");
            }
        }



        #endregion



    }
}