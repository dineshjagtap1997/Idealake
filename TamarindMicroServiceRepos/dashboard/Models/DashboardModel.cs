using NLog;

namespace TamarindAstraLoginDashboardReport.Models
{
    public class DashboardModel
    {
        public class Quotations
        {
            public long? QuotationID { get; set; }
            public string QuotationNo { get; set; }

        }
        public class QuotationMaster : Quotations
        {
            public string JsonText { get; set; }
            public long? EQID { get; set; } // Optional for insert
            public string EnquiryID { get; set; }
            public int Currency { get; set; }
            public bool TaxType { get; set; }

            public string TaxTypeName { get; set; }

            public int? TaxonSale { get; set; }
            public int? ParentID { get; set; }
            public string Disclaimer { get; set; }
            public long? BookingID { get; set; }
            public Guid? CreatedBy { get; set; }
            public Guid? UpdatedBy { get; set; }
            public long? AgentID { get; set; }
            public string AgentStaffName { get; set; }

            public string Action { get; set; } // 'I' or 'U'

            public int YearID { get; set; }
            public string Status { get; set; }
            public int? CustomerID { get; set; }
            public string StatusName { get; set; }

            public string AgentName { get; set; }

            public string CurrencyCode { get; set; }
            // Output parameters (optional to include in input model)

            public long? OutQuotationID { get; set; }

            public int? CompanyID { get; set; }
            public int? CurrencyID { get; set; }

            public DateTime? QuotationToDate { get; set; }

            public DateTime? QuotationFromDate { get; set; }

            public string RateCardMode { get; set; }

            public int PageNumber { get; set; }
            public int? PageSize { get; set; }
            public int? TotalCount { get; set; } // To store the
            public DateTime? QuotationDate { get; set; }
            public decimal? GSTPercentage { get; set; }
            public string? ColourCode { get; set; }
            public string? FileCode { get; set; }
            public string? CustomerName { get; set; }
            public string? GuestName { get; set; }
            public string? XONumber { get; set; }
            public string? InvoiceNo { get; set; }
            public DateTime? FromDate { get; set; }
            public DateTime? ToDate { get; set; }
            public string? QuoteStatus { get; set; }
            public int? QuotationRateCardId { get; set; }
            public int? RateType { get; set; }
            public string VersionSequence { get; set; }
            public string BookingNo { get; set; }
            public Guid? FHE { get; set; }
            public bool? isArrivalDate { get; set; }
            public int IsSysGenEnquiry { get; set; }
            public Guid? OperationBy { get; set; }
            public string DateFilterType { get; set; }
            public int? DaysRange { get; set; }
            public int? CompanyId { get; set; }
            public int? YearId { get; set; }
            public DateTime? StartDate { get; set; }
            public DateTime? EndDate { get; set; }
            public string FHEName { get; set; }
        }
        public class AdvancePaymentRequest
        {
            public int? BookingID { get; set; }
            public string Action { get; set; } = "S";

            public string XOType { get; set; }
            public string XONumber { get; set; }
            public string Supplier { get; set; }

            //public decimal? XOAmount { get; set; }
            public string XOAmount { get; set; }
            public string Currency { get; set; }
            public decimal? GrossRate { get; set; }

            public DateTime? Checkin { get; set; }
            public DateTime? Checkout { get; set; }

            public bool? IsBTCComm { get; set; }
            public string CommInv { get; set; }

            public string City { get; set; }
            public string XOInstruction { get; set; }
            public string GroupKey { get; set; }

            public string AdvanceXOID { get; set; }

            public string IDList { get; set; } // will come from SQL string_agg

            public string? GuestNamePayTo { get; set; }
            public string? HotelVendorCredit { get; set; }
            public string? AgentPaymentStatus { get; set; }
            public string? TACInvoiceNo { get; set; }
            public string? ApprovedBy { get; set; }
            public string? VendorName { get; set; }
            public decimal? TACInvoiceAmount { get; set; }
            public string? ReasonForAdvance { get; set; }
            public string? ModeOfPayment { get; set; }
            public decimal? VendorAmount { get; set; }
            public decimal? TaxPercentage { get; set; }
            public decimal? TaxValue { get; set; }

            public decimal? TDSPercentage { get; set; } // or TDS2Percent
            public string? CompName { get; set; }
            public string? YearCode { get; set; }
            public string? File_ID { get; set; }
            public int XoLock { get; set; }

            public string FileCode { get; set; }

            public int? RequestId { get; set; }

            public string? RequestedBy { get; set; }

            public string? Reason { get; set; }

            public string? Responsibility { get; set; }

            public DateTime? FileEndDate { get; set; }

            public string ApproveLink { get; set; }

            public string RejectLink { get; set; }

            public string? StatusName { get; set; }
            public DateTime? Request_Date { get; set; }
            public Guid? FHE { get; set; }
            public string XO { get; set; }
            public string GuestName { get; set; }
            public string AgentName { get; set; }
            public string Status { get; set; }
            public string PayTo { get; set; }
            public int? IsDashboard { get; set; }
            public int? DashCompanyId { get; set; }
            public Guid? OperationBy { get; set; }
            public int? DashYearId { get; set; }
            public int? DaysCount { get; set; }

            public string LOC { get; set; }

        }
        public class Dashboard
        {
            public int? PageNumber { get; set; }
            public string Action { get; set; }
            public int? CompanyId { get; set; }
            public int? YearId { get; set; }
            public Guid? OperationBy { get; set; }
            public int? DaysCount { get; set; }

            public int? ToursStartingCount { get; set; }
            public int? ToursEndingCount { get; set; }
            public int? EnqPendingToAction { get; set; }
            public int? EnqQuoted { get; set; }
            public int? AdvPayReqApprovalPending { get; set; }
            public int? FollowUpsPendingForAction { get; set; }
            public int? FollowUpsForToday { get; set; }
            public int? DailyStayTransport { get; set; }
            public int? AgentInvoice { get; set; }
            public int? CommInvoice { get; set; }
            public int? PerformaNotConverted { get; set; }
            public DateTime? StartDate { get; set; }
            public DateTime? EndDate { get; set; }
            public Guid? FHE { get; set; }
            public string? GuestName { get; set; }

            public string? CityName { get; set; }
            public string? HotelName { get; set; }
            public string? Transport { get; set; }
            public string BookingID { get; set; }
            public string FileCode { get; set; }
            public string AgentName { get; set; }
            public string CustomerName { get; set; }
            public string XONumber { get; set; }
            public string SupplierName { get; set; }
            public DateTime? ArrivalDate { get; set; }
            public DateTime? DepartureDate { get; set; }
            public string CommType { get; set; }

            public DateTime? Invoice_Date { get; set; }
            public string InvoiceNumber { get; set; }
            public decimal? Amount { get; set; }

            public string FHEName { get; set; }

        }

        public class TourStartingEndingExportModel
        {
            public DateTime? StartDate { get; set; }
            public string? GuestName { get; set; }
            public string FHEName { get; set; }
            public string? FileCode { get; set; }
            public string AgentName { get; set; }
        }
    }
}
