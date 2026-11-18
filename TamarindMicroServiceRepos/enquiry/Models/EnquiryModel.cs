namespace TamarindAstraEnquiry.Models
{
    public class EnquiryModel
    {
        public string EnquiryID { get; set; }
        public Guid CreatedBy { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public int? StatusID { get; set; }
        public int? LatestQuotationID { get; set; }
        public int? LatestItineraryID { get; set; }
        public bool? B2B_B2C { get; set; }
        public bool? FIT_GIT { get; set; }
        public bool? EnquiryLost { get; set; }
        //public int? Department { get; set; }

        public string Department { get; set; }
        // public int? DepartmentID { get; set; }
        public string? DepartmentID { get; set; }
        //public int? BizVertical { get; set; }
        public string BizVertical { get; set; }

        public string TamSales { get; set; }
        public string BigBilling_ImpAgentClient { get; set; }
        public string TravelType { get; set; }
        public int? TravellingFrom { get; set; }
        public string TravellingDestinations { get; set; }
        public DateTime? ExpectedTravelStartDate { get; set; }
        public int? ExpectedTravelNights { get; set; }
        public DateTime? ExpectedTravelEndDate { get; set; }
        public int? PAX { get; set; }
        public int? Adults { get; set; }
        public int? Children { get; set; }
        public string AdditionalNotes { get; set; }
        public string PreferredHotelCategory { get; set; }
        public int? RoomCounts { get; set; }
        public string OtherRelatedServices { get; set; }
        public int? NationalityID { get; set; }
        public decimal? Budget { get; set; }
        public string AgentName { get; set; }
        public string ClientName { get; set; }
        public int? AgentID { get; set; }
        public string AgentStaffName { get; set; }
        public string BookersName { get; set; }
        public long? ClientId { get; set; }
        public string Action { get; set; }
        public int? EQID { get; set; }
        public bool? bigbilling { get; set; }
        public string Reference { get; set; }
        public string Email { get; set; }
        public string Description { get; set; }
        public string PhoneNo { get; set; }
        public Guid? ReassignTo { get; set; }
        public string ReassigTonName { get; set; }
        public Guid? OperationBy { get; set; }
        public bool? IsDraft { get; set; }
        public string StatusName { get; set; }
        public int? IsSysGenEnquiry { get; set; }
        public int? CompanyID { get; set; }
        public int? YearID { get; set; }
        public int? PageNumber { get; set; }
        public string strLatestQuotationID { get; set; }
        public string CustomerName { get; set; }
    }


    public class EnquiryClientModel
    {
        public string ClientName { get; set; }
        public string MobileNumber { get; set; }
        public string Reference { get; set; }
        public string EmailID { get; set; }
        public string Action { get; set; }
        public int ClientId { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }


    }

    public class EnquiryStatus
    {
        public string Action { get; set; }
        public string StatusDescription { get; set; }
        public string Colourcode { get; set; }
        public int StatusID { get; set; }

    }

    public class EnquiryfollowupModel
    {
        public int FollowUPID { get; set; }
        public Guid? EmpID { get; set; }
        public DateTime? FollowUpDate { get; set; }
        public string FollowUpTime { get; set; }
        public string FollowUpRemark { get; set; }
        public string RescheduleFollowUp { get; set; }
        public string EnquiryID { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedBy { get; set; }
        public string Action { get; set; }
        public string EnquiryNID { get; set; }


    }

    public class Get_LostReason
    {
        public int ID { get; set; }
        public string LostReason { get; set; }
    }

    public class lostEnquiry
    {
        public long EQID { get; set; }
        public long LostID { get; set; }
        public long AgentID { get; set; }
        public string Comment { get; set; } = string.Empty;
        public string LostReason { get; set; } = string.Empty;
        public string Action { get; set; } = string.Empty;
    }

}
