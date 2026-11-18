using CommonClass;
using TamarindAstra.Common;
using TamarindAstra.Model.DBModel;
using TamarindAstraMasters.Interface;
//using Microsoft.Identity.Client;

namespace BusinessLogic.isEncrypted
{
    public class Level1Repository : ILevel1Repository
    {
     
       

        #region Country Starts here
        //new 
        public async Task<ResponseModel> CountryMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<CountryMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @IATACode = req.IATACode,
                        @Name = req.Name,
                        @Nationality = req.Nationality,
                        @ISDCode = req.ISDCode,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @PostalCode = req.PostalCode,
                        @Action = req.Action,
                        @NationalityName = req.NationalityName,
                    };

                    var data = new CommonClass.ResponseViewModel<CountryMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Country_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {

                //CommonFunctions.ApiExceptionLogs(CollectionName, request.RequestText, Cryptography.EncryptStringAES(Newtonsoft.Json.JsonConvert.SerializeObject(request), _base64Key), ex.ToString(), ExceptionLogsApiName);
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion country ends here

        #region State starts here
        //new
        public async Task<ResponseModel> StateMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<StateMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @State_ID = req.State_ID,
                        @Country_IATACode = req.Country_IATACode,
                        @Name = req.Name,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @StateCode = req.StateCode,
                        @Compcode = req.Compcode,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<StateMaster>
                    {
                        data = req
                    };
                    string connStr = CommonClass.SharedConfiguration.GetConnectionString();


                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_State_Master", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion state ends here

        #region City starts here
        //new 
        public async Task<ResponseModel> CityMaster(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<CityMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @IATACode = req.IATACode,
                        @Name = req.Name,
                        @StateIATACode = req.StateIATACode,
                        @STDCode = req.STDCode,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @CountryName = req.CountryName,
                        @StateName = req.StateName,
                        @State_ID = req.State_ID,
                        @CityName = req.CityName,
                        // @CityIATACode = req.CityIATACode,
                        @Country_IATACode = req.Country_IATACode
                    };

                    var data = new CommonClass.ResponseViewModel<CityMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_City_Master", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion city ends here

        #region marketmaster starts here
        //new
        public async Task<ResponseModel> MarketMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<MarketMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        ID = req.ID,
                        @Name = req.Name,
                        @IsActive = req.IsActive,
                        @ABRV = req.ABRV,
                        @OperationBy = req.OperationBy,
                        // @ErrMsg = marketMaster.ErrMsg,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<MarketMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Market_Master", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        #endregion marketmaster ends here

        #region countryMarketMapping starts here
        //new
        public async Task<ResponseModel> CountryMarketMappingMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<CountryMarketMappingMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @Country_IATACode = req.Country_IATACode,
                        @CountryName = req.CountryName,
                        @MarketName = req.MarketName,
                        @Market_ID = req.Market_ID,
                        @IsActive = req.IsActive,
                        //@Operation = countrymarketmappingmaster.Operation,
                        @OperationBy = req.OperationBy,
                        //@OperationOn = countrymarketmappingmaster.OperationOn,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<CountryMarketMappingMaster>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_CountryMarketMapping_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion countryMarketMapping ends here

        #region classtype starts here
        //new
        //public async Task<ResponseModel> ClassTypeMaster(RequestModel request)
        //{

        //    try
        //    {
        //        // Decrypt and deserialize the request
        //        var req = CommonFunctions.DecryptAndDeserializeRequest<ClassTypeMaster>(request.RequestText);
        //        logger.Debug("ClassTypeMaster method called");

        //        if (req != null)
        //        {
        //            string connectionString = _config.GetConnectionString("DefaultConnection");
        //            if (string.IsNullOrEmpty(connectionString))
        //                throw new Exception("Connection string not found.");

        //            var parameters = new
        //            {
        //                @ID = req.ID,
        //                @MOT = req.MOT,
        //                @Class = req.Class,
        //                @IsActive = req.IsActive,
        //                @OperationBy = req.OperationBy,
        //                @Action = req.Action
        //            };

        //            // Ensure you are calling the correct stored procedure here
        //            var (statusresponse, ClassTypeMasterResponse) = SqlHelper.LoadDataWithTable<StatusModel, ClassTypeMaster, dynamic>("usp_ClassType_Master", parameters);

        //            if (statusresponse != null)
        //            {
        //                var data = new CommonClass.ResponseViewModel<ClassTypeMaster>();
        //                data.returnCode = statusresponse.returnCode?.ToString();
        //                data.returnMessage = statusresponse.returnMessage;

        //                // Handle specific actions based on the request
        //                if (req.Action.ToLower() == "s")
        //                {
        //                    var dataList = ClassTypeMasterResponse;
        //                    //data.dataList = dataList;
        //                    data.data = data.data; // Assuming 'data' is a property in your ViewModel
        //                    return CommonFunctions.ProcessResult(data);
        //                }
        //            }

        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");
        //    }
        //    catch (Exception ex)
        //    {
        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
        //    }
        //}
        #endregion
        #region
        public async Task<ResponseModel> ClassTypeMaster(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ClassTypeMaster>(request.RequestText);

                if (req != null)
                {


                    //// Validate and parse OperationBy to ensure it's a Guid
                    //if (!Guid.TryParse(req.OperationBy.ToString(), out var operationByGuid))
                    //{
                    //    throw new ArgumentException("Invalid OperationBy GUID format.");
                    //}

                    // Prepare parameters
                    var parameters = new
                    {
                        @ID = req.ID,
                        @MOT = req.MOT,
                        @Class = req.Class,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy, // Pass as GUID
                        @Action = req.Action
                    };

                    // Execute stored procedure
                    var data = new CommonClass.ResponseViewModel<ClassTypeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ClassType_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion classtype ends here

        #region MODEOFTRAVEL STARTS HERE
        //new
        public async Task<ResponseModel> ModeOfTravelMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ModeOfTravelMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @ID = req.ID,
                        @MOT = req.MOT,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<ModeOfTravelMaster>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_MOT_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion MODEOFTRAVEL ENDS HERE

        #region Transportservice starts here
        //new
        public async Task<ResponseModel> TransportServiceMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<TransportServiceMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Code = req.Code,
                        @Name = req.Name,
                        @ModeOfTransport = req.ModeOfTransport,
                        //@ModeOfTransport1 = req.ModeOfTransport1,
                        @ShortDescription = req.ShortDescription,
                        @DetailedDescription = req.DetailedDescription,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        //@OldID = req.OldID,
                        @Action = req.Action,
                        @IsPreferred = req.IsPreferred,
                        @Pickup = req.Pickup,
                        @DropOff = req.DropOff,
                        @TotalDays = req.TotalDays,
                        @IsViceVersa = req.IsViceVersa
                    };

                    var data = new CommonClass.ResponseViewModel<TransportServiceMaster>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_TransportServices_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion transportservice ends here

        #region guide service starts here
        //new
        public async Task<ResponseModel> GuideServiceMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GuideServiceMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Code = req.Code,
                        @Name = req.Name,
                        @ShortDescription = req.ShortDescription,
                        @DetailedDescription = req.DetailedDescription,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @IsPreferred = req.IsPreferred,
                        @Action = req.Action,
                        //        @ErrMsg = GuideServiceMaster.ErrMsg,
                    };

                    var data = new CommonClass.ResponseViewModel<GuideServiceMaster>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GuideServices_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion guide service ends here

        #region special service starts here
        //new
        public async Task<ResponseModel> SpecialServiceMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SpecialServiceMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @Name = req.Name,
                        @ShortDescription = req.ShortDescription,
                        @DetailedDescription = req.DetailedDescription,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @IsPreferred = req.IsPreferred,
                        @Active = req.Active
                    };

                    var data = new CommonClass.ResponseViewModel<SpecialServiceMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_SpecialServices_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion special service ensds here 


        #region monumnet starts here
        //new
        public async Task<ResponseModel> MonumentMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<MonumentMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @ID = req.ID,
                        @Name = req.Name,
                        @StateIATACode = req.StateIATACode,
                        @CityIATACode = req.CityIATACode,
                        @Timing = req.Timing,
                        @ClosedOn = req.ClosedOn,
                        @Holidays = req.Holidays,
                        @Remarks = req.Remarks,
                        @ShortDescription = req.ShortDescription,
                        @DetailedDescription = req.DetailedDescription,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @IsPreferred = req.IsPreferred
                    };


                    var data = new CommonClass.ResponseViewModel<MonumentMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_MonumentServices_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion monumnet ends here


        #region HOTELRATINGMaster starts here
        //new
        public async Task<ResponseModel> HotelRatingMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelRatingMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @Ratings = req.Ratings,
                        @Code = req.Code,
                        @Description = req.Description,
                        @MISSequence = req.MISSequence,
                        @IsActive = req.IsActive,
                        //@Operation = hotelRatingMaster.Operation,
                        @OperationBy = req.OperationBy,
                        //@OperationOn = hotelRatingMaster.OperationOn,
                        // @OldID = hotelRatingMaster.OldID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<HotelRatingMaster>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_HotelRating_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion hotelratingmaster ends here

        #region roomcategorymaster starts here
        //new
        public async Task<ResponseModel> RoomCategoryMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<RoomCategoryMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @Name = req.Name,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @HotelID = req.HotelID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<RoomCategoryMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_RoomCategory_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion roomcategorymaster ends here


        #region MEALPLAN STARTS HERE
        //new
        public async Task<ResponseModel> MealPlanMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<MealPlanMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @ID = req.ID,
                        @Code = req.Code,
                        @Description = req.Description,
                        @Breakfast = req.Breakfast,
                        @Lunch = req.Lunch,
                        @Dinner = req.Dinner,
                        @IsActive = req.IsActive,
                        //  @Operation = mealPlanMaster.Operation,
                        @OperationBy = req.OperationBy,
                        //  @OperationOn = mealPlanMaster.OperationOn,
                        //  @OldID = mealPlanMaster.OldID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<MealPlanMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_MealPlan_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion MEALPLAN ENDS HERE

        #region ratetypemaster starts here
        //new
        public async Task<ResponseModel> HotelRateTypeMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelRateTypeMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Rate_Type_ID = req.Rate_Type_ID,
                        @Rate_Type_Name = req.Rate_Type_Name,
                        @Rate_Type_Code = req.Rate_Type_Code,
                        @Action = req.Action,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<HotelRateTypeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Rate_Type_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ratetypemaster ends here

        #region rulegroup starts here
        //new
        public async Task<ResponseModel> RuleGroupMaster(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<RuleGroupMaster>(request.RequestText);
                

                if (req != null)
                {
                   

                    var parameters = new
                    {
                        @ID = req.ID,
                        @Name = req.Name,
                        @IsActive = req.IsActive,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<RuleGroupMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_RuleGroups_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion rulegroup ends here


        #region ruleheader starts here
        //new
        public async Task<ResponseModel> RuleHeadersMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<RuleHeadersMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @RuleGroupID = req.RuleGroupID,
                        @Header = req.Header,
                        @Description = req.Description,
                        @IsMandatory = req.IsMandatory,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @SequenceNo = req.SequenceNo,
                        @RuleHeaderType = req.RuleHeaderType,
                        // @Active = req.Active,
                        @ID = req.ID,
                        @Action = req.Action

                    };

                    var data = new CommonClass.ResponseViewModel<RuleHeadersMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Rules_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ruleheader ends here

        #region department starts here
        //new
        public async Task<ResponseModel> DepartmentMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<DepartmentMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Dept_Name = req.Dept_Name,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        //@ErrMsg = departmentMaster.ErrMsg,
                        @Action = req.Action,
                        @ID = req.ID
                    };

                    var data = new CommonClass.ResponseViewModel<DepartmentMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Department_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion department ends here

        #region designation starts here
        //new
        public async Task<ResponseModel> DesignationMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<DesignationMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Desg_Name = req.Desg_Name,
                        @IsActive = req.IsActive,
                        @ID = req.ID,
                        @OperationBy = req.OperationBy,
                        // @ErrMsg = designationMaster.ErrMsg,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<DesignationMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Designation_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion designations end here



        #region vehicletypemaster
        //new
        public async Task<ResponseModel> VehicleTypeMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<VehicleTypeMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @VehicleType = req.VehicleType,
                        @MISSequence = req.MISSequence,
                        @IsOnline = req.IsOnline,
                        @DisplayName = req.DisplayName,
                        @VehicleTypeID = req.VehicleTypeID,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        //@ErrMsg = VehicleTypeMaster.ErrMsg,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<VehicleTypeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_VehicleTypeMaster", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion vehicletypemaster ends here


        #region guide starts here
        //new
        public async Task<ResponseModel> GuideInfoMaster(RequestModel request)
        {

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GuideInfoMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Name = req.Name,
                        @Salutation = req.Salutation,
                        @Gender = req.Gender,
                        @State_IATACode = req.State_IATACode,
                        @City_IATACode = req.City_IATACode,
                        @StarRating = req.StarRating,
                        @PhoneNo = req.PhoneNo,
                        @MobileNo = req.MobileNo,
                        @Address = req.Address,
                        @LanguagesID = req.LanguagesID,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Ranking = req.Ranking,
                        @IsDOT = req.IsDOT,
                        @IsState = req.IsState,
                        @IsASI = req.IsASI,
                        @GuideID = req.GuideID,
                        //@ErrMsg = guideInfoMaster.ErrMsg,
                        @Action = req.Action,
                        @Active = req.Active
                    };

                    var data = new CommonClass.ResponseViewModel<GuideInfoMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GuideInfoMaster", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion guide ends here

        #region language starts here
        //new
        public async Task<ResponseModel> LanguageMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<LanguageMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @Language = req.Language,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<LanguageMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Language_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion language eneds here

        #region nationality starts here
        //new
        public async Task<ResponseModel> NationalityMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<NationalityMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Nationality = req.Nationality,
                        @IsActive = req.IsActive,
                        //@Operation = NationalityMaster.Operation,
                        @OperationBy = req.OperationBy,
                        @HeaderInfo_Nationality = req.HeaderInfo_Nationality,
                        //     @ErrMsg = NationalityMaster.ErrMsg,
                        @Action = req.Action,
                        @ID = req.ID
                    };

                    var data = new CommonClass.ResponseViewModel<NationalityMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Nationality_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion nationality ends here

        #region facilityinformation starts here
        //new
        public async Task<ResponseModel> FacilityInformationMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<FacilityInformationMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @FacilityInfoID = req.FacilityInfoID,
                        @InformationName = req.InformationName,
                        @ImageName = req.ImageName,
                        @Image = req.Image,
                        @MISSequenceNo = req.MISSequenceNo,
                        @IsActive = req.IsActive,
                        //  @Operation = req.Operation,
                        @OperationBy = req.OperationBy,
                        // @OperationOn = req.OperationOn,
                        // @OldID = req.OldID,
                        @Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here

                    var data = new CommonClass.ResponseViewModel<FacilityInformationMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_FacilityInformation_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion facilityinformation ends here

        #region location starts here
        //new
        public async Task<ResponseModel> LocationMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<LocationMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @LocationID = req.LocationID,
                        @LocationCode = req.LocationCode,
                        @LocationValue = req.LocationValue,
                        @SequenceNo = req.SequenceNo,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<LocationMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Location_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion location ends here

        #region zone starts here
        //new
        public async Task<ResponseModel> ZoneMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ZoneMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ZoneID = req.ZoneID,
                        @ZoneName = req.ZoneName,
                        @IsActive = req.IsActive,
                        @HeaderInfo_Zone = req.HeaderInfo_Zone,
                        @OperationBy = req.OperationBy,
                        //  @OperationOn = zoneMaster.OperationOn,
                        //  @OldID = zoneMaster.OldID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<ZoneMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Zone_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion zone ends here

        #region header starts here
        //new
        public async Task<ResponseModel> HeaderMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HeaderMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @HeaderID = req.HeaderID,
                        @HeaderCode = req.HeaderCode,
                        @HeaderValue = req.HeaderValue,
                        @SequenceNo = req.SequenceNo,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<HeaderMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Header_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion header ends here

        #region landmarks start here
        //new
        public async Task<ResponseModel> LandMarksMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<LandMarksMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @LandMarkID = req.LandMarkID,
                        @LandMarkName = req.LandMarkName,
                        @IsActive = req.IsActive,
                        // @Operation = req.Operation,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<LandMarksMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_LandMarks_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion landmark ends here

        #region TransferMaster starts here
        //new
        public async Task<ResponseModel> TransferMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<TransferMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @TransferID = req.TransferID,
                        @TransferCode = req.TransferCode,
                        @TransferValue = req.TransferValue,
                        @Sequence = req.Sequence,
                        @IsActive = req.IsActive,
                        //@Operation = transferMaster.Operation,
                        @OperationBy = req.OperationBy,
                        //@OperationOn = transferMaster.OperationOn,
                        //@OldID = transferMaster.OldID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<TransferMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Transfer_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion TransferMaster ends here


        #region agentgroup starts here
        //new
        public async Task<ResponseModel> AgentGroupMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgentGroupMasterodel>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @AgentGroupID = req.AgentGroupID,
                        @AgentGroupCode = req.AgentGroupCode,
                        @AgentGroupName = req.AgentGroupName,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        //@OperationDate = req.OperationDate,
                        //@OldID = req.OldID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<AgentGroupMasterodel>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Agent_Group", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", request.ToString());
            }
        }
        #endregion agentgroup ends here

        #region hotelpreferedmaster starts here
        //new
        public async Task<ResponseModel> HotelPreferredMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelPreferredMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @HotelID = req.HotelID,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo,
                        @IsPreferred = req.IsPreferred,
                        @OperationBy = req.OperationBy,
                        @PreferredHotelID = req.PreferredHotelID,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<HotelPreferredMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_HotelPreferred_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion hotelpreferedmaster ends here


        //added by shubham
        #region added by shubham
        #region XORemarks starts here Working
        //new
        public async Task<ResponseModel> XORemarksMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<XORemarksMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @XOID = req.XOID,
                        @XoRemarks = req.XoRemarks,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<XORemarksMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_XORemarks_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion XORemarks ends here

        #region Agent Markup starts here
        //new
        public async Task<ResponseModel> AgentMarkupMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgentMarkupMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @AgentCategoryID = req.AgentCategoryID,
                        @CodeDescription = req.CodeDescription,
                        @ValidFrom = req.ValidFrom,
                        @ValidTo = req.ValidTo,
                        @Hotel = req.Hotel,
                        @Transport = req.Transport,
                        @Guide = req.Guide,
                        @Monument = req.Monument,
                        @FlightTrain = req.FlightTrain,
                        @SpecialService = req.SpecialService,
                        @Package = req.Package,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @SupplierID = req.SupplierID,
                        @Action = req.Action,
                        @AgentMarkupID = req.AgentMarkupID
                    };
                    var data = new CommonClass.ResponseViewModel<AgentMarkupMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ManageAgentMarkup", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Agent Markup ends here 

        #region Salutation starts here Working
        //new
        public async Task<ResponseModel> SalutationMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SalutationMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @SalutationID = req.SalutationID,
                        @Salutation = req.Salutation,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<SalutationMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Salutation_master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Salutation ends here

        #region Year starts here Working
        //new
        public async Task<ResponseModel> YearMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeNullRequest<YearMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @YearID = req.YearID,
                        @YearCode = req.YearCode,
                        @CompanyID = req.CompanyID,
                        @FromDate = req.FromDate == null ? (DateTime?)null : DateTime.Parse(req.FromDate.ToString()),
                        @ToDate = req.ToDate == null ? (DateTime?)null : DateTime.Parse(req.ToDate.ToString()),
                        @FiscalYear = req.FiscalYear,
                        @IsLocked = req.IsLocked,
                        @Action = req.Action,
                        @EntityID = req.EntityID,
                        @VID = req.VID,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                    };

                    var data = new CommonClass.ResponseViewModel<YearMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ManageYearMaster", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Year ends here

        #region CurrencyMaster starts here Working
        //new
        public async Task<ResponseModel> CurrencyMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<CurrencyMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Code = req.Code,
                        @Name = req.Name,
                        @Symbol = req.Symbol,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<CurrencyMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Currency_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion CurrencyMaster ends here

        #region CurrencyConversionMaster starts here Working
        //new
        public async Task<ResponseModel> CurrencyConversionMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<CurrencyConversionMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @FromCurrency = req.FromCurrency,
                        @ToCurrency = req.ToCurrency,
                        @FromDate = req.FromDate == null ? (DateTime?)null : DateTime.Parse(req.FromDate.ToString()),
                        @ToDate = req.ToDate == null ? (DateTime?)null : DateTime.Parse(req.ToDate.ToString()),
                        @PurchaseRate = req.PurchaseRate,
                        @SalesRate = req.SalesRate,
                        @CostingRate = req.CostingRate,
                        @Action = req.Action,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<CurrencyConversionMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_CurrencyConversionMaster", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion CurrencyConversionMaster ends here 

        #region Export Hotel Info starts here
        #endregion Export Hotel Info ends here

        #region OtherTaxesMaster starts here        
        //new - pending
        public async Task<ResponseModel> OtherTaxesMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<OtherTaxesMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Action = req.Action,
                        @Name = req.Name,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Other_Tax_Id = req.Other_Tax_Id


                    };

                    var data = new CommonClass.ResponseViewModel<OtherTaxesMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_UpdateOtherTaxes_M", parameters);

                    //usp_ManageOtherServiceTaxNew
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion OtherTaxesMaster ends here

        #region SACMaster starts here Working
        //new
        public async Task<ResponseModel> SACMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SACMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @ID = req.ID,
                        @Code = req.Code,
                        @Description = req.Description,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @ForTkt = req.ForTkt,
                        @Action = req.Action
                    };

                    //var data = new CommonClass.ResponseViewModel<SACMaster>
                    //{
                    //    data = req
                    //};
                    //return CommonFunctions.ProcessDBData(data, req.Action, "USP_ManageSAC", parameters);


                    if (req.Action.ToLower() == "ex")
                    {
                        // Manually map GSTTypeMaster to GSTTypeMasterExportModel
                        var exportModel = new SACMasterExportModel
                        {
                            ID = req.ID,
                            Code = req.Code,
                            Description = req.Description,
                            IsActive = req.IsActive,
                            //OperationBy = req.OperationBy,
                            ForTkt = req.ForTkt,
                            Action = req.Action
                        };

                        var data = new CommonClass.ResponseViewModel<SACMasterExportModel>
                        {
                            data = exportModel
                        };

                        return CommonFunctions.ProcessDBData(data, req.Action, "USP_ManageSAC", parameters);
                    }
                    else
                    {
                        var data = new CommonClass.ResponseViewModel<SACMaster>
                        {
                            data = req
                        };

                        return CommonFunctions.ProcessDBData(data, req.Action, "USP_ManageSAC", parameters);
                    }



                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SACMaster ends here

        #region ServiceTaxNewMaster starts here Working
        //new
        public async Task<ResponseModel> ServiceTaxNewMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ServiceTaxNewMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @Tax_ID = req.Tax_ID,
                        @Tax_Desc = req.Tax_Desc,
                        @GSTID = req.GSTID,
                        @IsActive = req.IsActive,
                        @Tax_From_Date = req.Tax_From_Date == null ? (DateTime?)null : DateTime.Parse(req.Tax_From_Date.ToString()),
                        @Tax_To_Date = req.Tax_To_Date == null ? (DateTime?)null : DateTime.Parse(req.Tax_To_Date.ToString()),
                        @OperationBy = req.OperationBy,
                        @GSTType = req.GSTType,
                        @IsCommercial = req.IsCommercial,
                        @SAPCode = req.SAPCode,
                        @Action = req.Action,
                        @Tax_Perc = req.Tax_Perc
                    };

                    var data = new CommonClass.ResponseViewModel<ServiceTaxNewMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ServiceTaxNew", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ServiceTaxNewMaster ends here

        #region Other Service Tax New Master starts here Working
        //new
        public async Task<ResponseModel> OtherServiceTaxNewMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<OtherServiceTaxNewMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Tax_ID = req.Tax_ID,
                        @Tax_Desc = req.Tax_Desc,
                        @Tax_Percentage = req.Tax_Percentage,
                        @IsActive = req.IsActive,
                        @Tax_Category = req.Tax_Category,
                        @Tax_From_Date = req.Tax_From_Date,
                        @Tax_To_Date = req.Tax_To_Date,
                        @OperationBy = req.OperationBy,
                        @Other_Tax_Id = req.Other_Tax_Id,
                        @ST_Tax_ID = req.ST_Tax_ID,
                        @Action = req.Action,
                        @GSTType = req.GSTType,

                        @SAPCode = req.SAPCode,
                        @IsCommercial = req.IsCommercial,
                    };
                    var data = new CommonClass.ResponseViewModel<OtherServiceTaxNewMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ManageOtherServiceTaxNew", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SACMaster ends here

        #region Bank Master starts here        
        //new
        public async Task<ResponseModel> BankMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BankMaster>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @AccountBankMasterID = req.AccountBankMasterID,
                        @Currency = req.Currency,
                        //  @BankAccountDetails = req.BankAccountDetails,
                        @Details = req.Details,
                        @isTTCBankDetails = req.isTTCBankDetails,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @CompanyID = req.CompanyID,
                        @AccountName = req.AccountName,
                        @AccountNo = req.AccountNo,
                        @IsVirtualAccount = req.IsVirtualAccount,
                        @AccountPrefix = req.AccountPrefix,
                        @IsRedDotBankDetails = req.IsRedDotBankDetails,
                        @Action = req.Action,
                        @BankID = req.BankID,
                    };
                    var data = new CommonClass.ResponseViewModel<BankMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_BankMasterDtls_BankMaster", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion  Bank Master ends here

        #endregion ended by shubham
        //ended by shubham

        //added by sarthak

        #region added by sarthak

        #region BusinessType starts here Working        
        //new
        public async Task<ResponseModel> BusinessTypeMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BusinessTypeMaster>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @BussinessModuleID = req.BussinessModuleID,
                        @BusinessModuleName = req.BusinessModuleName,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @IsTTCLogo = req.IsTTCLogo,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<BusinessTypeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ManageBusinessMaster", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion  BusinessType ends here

    
        #region BankAccountsMaster starts here        
        public async Task<ResponseModel> BankAccountsMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BankAccountsMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @AccountBankMasterID = req.AccountBankMasterID,
                        @BankAccountName = req.BankAccountName,
                        @BankAccountDetails = req.BankAccountDetails,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Currency = req.Currency,
                        @LegalEntityId = req.LegalEntityId,
                        @AccountName = req.AccountName,
                        @AccountNumber = req.AccountNumber,
                        @AccountPrefix = req.AccountPrefix,
                        @IsVirtualAccount = req.IsVirtualAccount,
                        @Action = req.Action
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<BankAccountsMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Accounts_BankMaster", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion BankAccountsMaster ends here

        #region hoteltype starts here
        public async Task<ResponseModel> HotelTypeMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelTypeMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @HotelTypeID = req.HotelTypeID,
                        @TypeValue = req.TypeValue,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action

                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<HotelTypeMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ManageHotelTypeMaster", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion hoteltype ends here


        #region bizpartner starts here
        public async Task<ResponseModel> BizPartnerGroupMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BizPartnerGroupMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @HotelGroupID = req.HotelGroupID,
                        @IATACode = req.IATACode,
                        @Name = req.Name,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        // @HotelGroupID = req.HotelGroupID

                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<BizPartnerGroupMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_HotelGroup_Master", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion bizpartner neds here

        public async Task<ResponseModel> BankMasterdetail(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<BankDetails>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {

                        @Action = req.Action,
                        @BankName = req.BankName
                    };

                    // Ensure you are calling the correct stored procedure here
                    var data = new CommonClass.ResponseViewModel<BankDetails>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GetBankMaster", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        // shubham

        #region AgentCategoryMaster start
        public async Task<ResponseModel> AgentCategoryMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<AgentCategoryMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @CategoryID = req.CategoryID,
                        //@CategoryCode = req.CategoryCode,
                        //@CategoryValue = req.CategoryValue,
                        //@IsActive = req.IsActive,
                        //@OperationBy = req.OperationBy,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<AgentCategoryMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "sp_GetAgentCategoryByID", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion AgentCategoryMaster end

        #region MSME Type start
        public async Task<ResponseModel> MSMEType(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<MSMEType>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @MSMETypeID = req.MSMETypeID,
                        //@MSMETypeName = req.MSMETypeName,
                        //@Description = req.Description,
                        //@IsActive = req.IsActive,
                        //@OperationBy = req.OperationBy,
                        @Action = req.Operation
                    };

                    var data = new CommonClass.ResponseViewModel<MSMEType>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Operation, "sp_GetMSMETypeMaster", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion MSME Type end

        #region VendorPreferred start
        public async Task<ResponseModel> VendorPreferred(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeNullRequest<VendorPreferred>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @VendorID = req.VendorID,
                        @ValidFrom = req.ValidFrom == null ? (DateTime?)null : DateTime.Parse(req.ValidFrom.ToString()),
                        @ValidTo = req.ValidTo == null ? (DateTime?)null : DateTime.Parse(req.ValidTo.ToString()),
                        @IsPreferred = req.IsPreferred,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @PreferredVendorID = req.PreferredVendorID,

                    };

                    var data = new CommonClass.ResponseViewModel<VendorPreferred>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_VendorPreferred", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion VendorPreferred


        #region SelectFiscalVariant starts here Working
        //new
        public async Task<ResponseModel> SelectFiscalVariant(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SelectFiscalVariant>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @Action = req.Action
                    };
                    var data = new CommonClass.ResponseViewModel<SelectFiscalVariant>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "SelectFiscalVariant", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion SelectFiscalVariant ends here

        #region GetAgentCategoryMaster starts here Working
        //new
        public async Task<ResponseModel> GetAgentCategoryMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<GetAgentCategoryMaster>(request.RequestText);

                if (req != null)
                {
                    var data = new CommonClass.ResponseViewModel<GetAgentCategoryMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetAgentCategoryMaster", null);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion GetAgentCategoryMaster ends here

        #region New_CurrencyMaster here
        //new
        public async Task<ResponseModel> New_CurrencyMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<New_CurrencyMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @id = req.Id,
                        @CurrencyCode = req.CurrencyCode,
                        @Symbol = req.Symbol,
                        @Effective_Date = req.Effective_Date,
                        @Hedge_perc = req.Hedge_Perc,
                        @IsActive = req.IsActive,
                        @Action = req.Action,
                        @Name = req.Name,
                        @OperationBy = req.OperationBy,
                    };

                    var data = new CommonClass.ResponseViewModel<New_CurrencyMaster>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "sp_ManageCurrencyMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion New_CurrencyMaster ends here

        #region New_CurrencyConversion here
        //new
        /*public async Task<ResponseModel> New_CurrencyConversion(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<New_CurrencyConversion>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @FromCurrencyId = req.FromCurrencyId,
                        @ToCurrencyId = req.ToCurrencyId,
                        @Actual_Value = req.Actual_Value,
                        @Hedge_Perc = req.Hedge_Perc,
                        @EffectiveDate = req.EffectiveDate,
                        @Purchase_Value = req.Purchase_Value,
                        @Sales_Value = req.Sales_Value,
                        @CreatedBy = req.CreatedBy,
                        @UpdatedBy = req.UpdatedBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<New_CurrencyConversion>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_InsertUpdate_CurrencyCon", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }*/

        //LOOP NEW 
        public async Task<List<ResponseModel>> New_CurrencyConversion(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request into a List of requests
                //var reqList = CommonFunctions.DecryptAndDeserializeRequest<List<New_CurrencyConversion>>(request.RequestText);
                List<New_CurrencyConversion> reqList = CommonFunctions.DecryptAndDeserializeRequestList<New_CurrencyConversion>(request.RequestText);

                if (reqList == null || !reqList.Any())
                {
                    return new List<ResponseModel> { CommonFunctions.BlankResponse("201", "Invalid or empty request.") };
                }

                var responses = new List<ResponseModel>();

                foreach (var req in reqList)
                {
                    var parameters = new
                    {
                        @FromCurrencyId = req.FromCurrencyId,
                        @ToCurrencyId = req.ToCurrencyId,
                        @Actual_Value = req.Actual_Value,
                        @Hedge_Perc = req.Hedge_Perc,
                        @EffectiveDate = req.EffectiveDate,
                        @Purchase_Value = req.Purchase_Value,
                        @Sales_Value = req.Sales_Value,
                        @CreatedBy = req.CreatedBy,
                        @UpdatedBy = req.UpdatedBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<New_CurrencyConversion>
                    {
                        data = req
                    };
                    var response = CommonFunctions.ProcessDBData(data, req.Action, "usp_InsertUpdate_CurrencyCon", parameters);

                    responses.Add(response);
                }

                return responses; // Return all responses
            }
            catch (Exception ex)
            {
                return new List<ResponseModel> { CommonFunctions.CreateErrorResponse(ex, "500", "Currency Conversion Failed") };
            }
        }

        #endregion New_CurrencyConversion ends here

        #region Destination_Master here
        //new
        public async Task<ResponseModel> Destination_Master(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<Destination_Master>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @SelectedValues = req.SelectedValues,
                        @Action = req.Action,
                        @Name = req.Name,
                    };

                    var data = new CommonClass.ResponseViewModel<Destination_Master>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_DestinationMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion Destination_Master ends here



        #region ItineraryNotes here
        //new
        public async Task<ResponseModel> ItineraryNotes(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryNotes>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @City_IATACode1 = req.City_IATACode1,
                        @City_IATACode2 = req.City_IATACode2,
                        @Active = req.Active,
                    };

                    var data = new CommonClass.ResponseViewModel<ItineraryNotes>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetItineraryNotes", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ItineraryNotes ends here

        #region ItineraryInclusions here
        //new
        public async Task<ResponseModel> ItineraryInclusions(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryInclusions>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @City_IATACode1 = req.City_IATACode1,
                        @City_IATACode2 = req.City_IATACode2,
                        @Active = req.Active,
                    };

                    var data = new CommonClass.ResponseViewModel<ItineraryInclusions>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetItineraryInclusions", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ItineraryInclusions ends here

        #region ItineraryExclusions here
        //new
        public async Task<ResponseModel> ItineraryExclusions(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<ItineraryExclusions>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @City_IATACode1 = req.City_IATACode1,
                        @City_IATACode2 = req.City_IATACode2,
                        @Active = req.Active,
                    };

                    var data = new CommonClass.ResponseViewModel<ItineraryExclusions>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetItineraryExclusions", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion ItineraryExclusions ends here

        #region fetchHotelCity
        public async Task<ResponseModel> SearchHotelCity(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<SearchHotelCityModel>(request.RequestText);


                if (req != null)
                {

                    var parameters = new
                    {
                        @Name = req.Name,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<SearchHotelCityModel>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_fetchHotelCity", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }


        #endregion fetchHotelCity ends here

        #region xo starts here
        public async Task<ResponseModel> LockFileCodeXoRequestModel(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<LockFileCodeXoRequestModel>(request.RequestText);


                if (req != null)
                {

                    var parameters = new
                    {
                        XOID = req.XOID,
                        BookingID = req.BookingID,
                        YearID = req.YearID,
                    };

                    var data = new CommonClass.ResponseViewModel<LockFileCodeXoRequestModel>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData_WitoutAction(data, "[XO].[USP_Lock_FileCode_Xo]", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion xo ends here

    }
}
#endregion  ends here
