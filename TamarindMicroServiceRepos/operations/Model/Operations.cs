namespace TamarindAstra_Operations.Model
{
    public class GetUserMail
    {
        public Guid UserId { get; set; }
    }

    public class Insert_HotelRegistration_Mail
    {
        public Guid UserId { get; set; }
        public int ID { get; set; }
        public string FromEmail { get; set; }
        public string ToEmail { get; set; }
        public string CcEmail { get; set; }
        public string EmailSubject { get; set; }
        public string EmailBody { get; set; }
        public string ReasonForAddingVendor { get; set; }
        public string VendorService { get; set; }
        public string AccountGroupCode { get; set; }
        public string AccountGroupName { get; set; }
        public DateTime CreatedDate { get; set; }
        public Guid CreatedBy { get; set; }
        public Guid OperationBy { get; set; }
    }

    public class VendorRegistration_Mail
    {
        public Guid UserId { get; set; }
        public int ID { get; set; }
        public string FromEmail { get; set; }
        public string ToEmail { get; set; }
        public string CcEmail { get; set; }
        public string EmailSubject { get; set; }
        public string EmailBody { get; set; }
        public string ReasonForAddingVendor { get; set; }
        public string VendorService { get; set; }
        public string AccountGroupCode { get; set; }
        public string AccountGroupName { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public Guid OperationBy { get; set; }
    }

    public class FileSummary
    {
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public Guid OperationBy { get; set; }
        public string reportType { get; set; }
        public int YearCode { get; set; }
        public string FileCode { get; set; }
        public DateTime QuotationDate { get; set; }
        public string FHEName { get; set; }
        public string TamSalesName { get; set; }
        public string AgentName { get; set; }
        public DateTime TourStartDate { get; set; }
        public string SalesDocNumber { get; set; }
        public string SAPBizCode { get; set; }
        public decimal Comm { get; set; }
        public decimal SalesValue { get; set; }
        public decimal ProformaValue { get; set; }
        public int QuotationID { get; set; }
        public int XO_ID { get; set; }
        public decimal XO_Amt { get; set; }
        public DateTime MonthStartDate { get; set; }
        public int EmpID { get; set; }
        public int YearID { get; set; }
        public decimal OpsToplineTarget { get; set; }
        public decimal OpsGOPTarget { get; set; }
        public decimal SalesToplineTarget { get; set; }
        public decimal SalesGOPTarget { get; set; }
    }
    public class FetchItineraryDetails
    {
        public int ItineraryID { get; set; }
        public string? FileCode { get; set; }
        public string? EnquiryID { get; set; }
        public string? Country { get; set; }
        public string? TourDate { get; set; }
        public string? Action { get; set; }
        public int? IsDate { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
    }

    public class ReasonMaster
    {
        public int ID { get; set; }
        public string Reason { get; set; }
        public bool? isActive { get; set; }
        public string? Action { get; set; }
    }


    public class AutoCompleteSearch
    {
        public int ID { get; set; }
        public Guid? UNIQUEID { get; set; }
        public string Name { get; set; }
        public int Status { get; set; }
        public string Action { get; set; }
        public string Filter { get; set; }
        public string ColorCode { get; set; }


    }
}
