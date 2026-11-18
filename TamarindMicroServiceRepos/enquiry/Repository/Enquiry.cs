using CommonClass;
using Microsoft.Extensions.Options;
using NLog;
using TamarindAstra.Common;
using TamarindAstraEnquiry.Interface;
using TamarindAstraEnquiry.Models;

namespace TamarindAstraEnquiry.Repository
{
    public class Enquiry : IEnquiry
    {

        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        private readonly string isEncrypted;

        public Enquiry(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];
        }

        #region EnquiryModel starts here
        public async Task<ResponseModel> EnquiryModel(RequestModel request)
        {

            try
            {
                var req = CommonFunctions.DecryptAndDeserializeNullRequest<EnquiryModel>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        req.EnquiryID,
                        req.CreatedBy,
                        req.StatusID,
                        req.LatestQuotationID,
                        req.LatestItineraryID,
                        req.B2B_B2C,
                        req.FIT_GIT,
                        req.EnquiryLost,
                        req.Department,
                        req.BizVertical,
                        req.TamSales,
                        req.BigBilling_ImpAgentClient,
                        req.TravelType,
                        req.TravellingFrom,
                        req.TravellingDestinations,
                        @ExpectedTravelStartDate = req.ExpectedTravelStartDate == null ? (DateTime?)null : DateTime.Parse(req.ExpectedTravelStartDate.ToString()),
                        req.ExpectedTravelNights,
                        @ExpectedTravelEndDate = req.ExpectedTravelEndDate == null ? (DateTime?)null : DateTime.Parse(req.ExpectedTravelEndDate.ToString()),
                        req.PAX,
                        req.Adults,
                        req.Children,
                        req.AdditionalNotes,
                        req.PreferredHotelCategory,
                        req.RoomCounts,
                        req.OtherRelatedServices,
                        @Nationality = req.NationalityID,
                        req.Budget,
                        req.AgentID,
                        req.BookersName,
                        req.ClientId,
                        req.Action,
                        req.EQID,
                        req.bigbilling,
                        req.Reference,
                        req.Description,
                        req.PhoneNo,
                        req.Email,
                        @AgentStaffName = req.AgentStaffName,
                        @ReassignTo = req.ReassignTo,
                        @OperationBy = req.OperationBy,
                        @IsDraft = req.IsDraft,
                        @ID = req.EQID,
                        @CompanyID = req.CompanyID,
                        @YearID = req.YearID,
                        @PageNumber = req.PageNumber,
                        @ReassigTonName = req.ReassigTonName,
                        @strLatestQuotationID = req.strLatestQuotationID,
                        @AgentName = req.AgentName,
                        @CustomerName = req.CustomerName,
                        @StatusName = req.StatusName,
                    };
                    var data = new CommonClass.ResponseViewModel<EnquiryModel>
                    {
                        data = req
                    };
                    if (req.Action.ToLower() == "sa")
                        return CommonFunctions.ProcessDBDataPagination(data, req.Action, "usp_Enquiry", parameters);
                    else
                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_Enquiry", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Enquiry Not Found");
            }
        }
        #endregion BankAccountsMaster ends here

        #region EnquiryClient starts here
        public async Task<ResponseModel> EnquiryClient(RequestModel request)
        {

            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<EnquiryClientModel>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {

                        req.ClientId,
                        req.ClientName,
                        req.MobileNumber,
                        req.Reference,
                        req.EmailID,
                        req.Action,
                        req.CreatedBy,
                        req.UpdatedBy,

                    };
                    var data = new CommonClass.ResponseViewModel<EnquiryClientModel>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Client", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Client Not Found");
            }
        }

        #endregion EnquiryClient ends here


        #region EnquiryStatus starts here
        public async Task<ResponseModel> EnquiryStatus(RequestModel request)
        {

            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<EnquiryStatus>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {

                        req.Action,
                    };
                    var data = new CommonClass.ResponseViewModel<EnquiryStatus>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Enquiry_Status", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "EnquiryStatus Not Found");
            }
        }
        #endregion EnquiryStatus starts here

        #region Enquiryfollowup starts here
        public async Task<ResponseModel> Enquiryfollowup(RequestModel request)
        {

            try
            {
                var req = CommonFunctions.DecryptAndDeserializeNullRequest<EnquiryfollowupModel>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @FollowUpDate = req.FollowUpDate == null ? (DateTime?)null : DateTime.Parse(req.FollowUpDate.ToString()),
                        @FollowUpTime = req.FollowUpTime,
                        @FollowUpRemark = req.FollowUpRemark,
                        @RescheduleFollowUp = req.RescheduleFollowUp,
                        @EmpID = req.EmpID,
                        @EnquiryID = req.EnquiryID,
                        @FollowUPID = req.FollowUPID,
                        @Action = req.Action,
                        @EnquiryNID = req.EnquiryNID,
                    };
                    var data = new CommonClass.ResponseViewModel<EnquiryfollowupModel>
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_FollowUp", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "EnquiryStatus Not Found");
            }
        }
        #endregion EnquiryStatus starts here

        #region Get_LostReason starts here
        public async Task<ResponseModel> Get_LostReason(RequestModel request)
        {

            try
            {
                var req = request.RequestText;

                if (req != null)
                {

                    var data = new CommonClass.ResponseViewModel<Get_LostReason>();
                    return CommonFunctions.ProcessDBData_WitoutAction(data, "GetLostReason", null);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "EnquiryStatus Not Found");
            }
        }
        #endregion Get_LostReason starts here

        #region Lost_Enquiry starts here
        public async Task<ResponseModel> Lost_Enquiry(RequestModel request)
        {

            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<lostEnquiry>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @EQID = req.EQID,
                        @LostID = req.LostID,
                        @AgentID = req.AgentID,
                        @Comment = req.Comment,
                        @LostReason = req.LostReason,
                        @Action = req.Action,
                    };

                    var data = new CommonClass.ResponseViewModel<lostEnquiry>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Lost_Enquiry", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "EnquiryStatus Not Found");
            }
        }
        #endregion Lost_Enquiry starts here

    }
}
