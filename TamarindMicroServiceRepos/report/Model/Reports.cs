using System.ComponentModel.DataAnnotations;

namespace TamarindAstraReports.Model
{
    public class Reports
    {
        public class HotelRateCard
        {

            public DateTime RateValidFrom { get; set; }
            public DateTime RateValidTo { get; set; }

            //[Required]
            //public bool FIT { get; set; }

            //public bool? GIT { get; set; }

            //[Required]
            //public int MealPlanID { get; set; }

            //[Required]
            //public int TransferID { get; set; }

            //public decimal? SGL { get; set; }
            //public decimal? DBL { get; set; }
            //public decimal? AdultExtra { get; set; }
            //public decimal? ChildExtra { get; set; }
            //public decimal? Breakfast { get; set; }
            //public decimal? Lunch { get; set; }
            //public decimal? Dinner { get; set; }
            //public bool? ShowOnline { get; set; }
            //public int? MISSequenceNo { get; set; }
            public bool IsActive { get; set; }

            //public DateTime? CreationDate { get; set; }
            //public DateTime? ModificationDate { get; set; }
            //public int? OldID { get; set; }
            //public int? MinNights { get; set; }
            //public int? MaxNights { get; set; }
            //public decimal? SGLCommission { get; set; }
            //public decimal? DBLCommission { get; set; }
            //public bool? ShowOnline_B2C { get; set; }
            //public bool? IsEOB { get; set; }
            //public bool? IsPayStay { get; set; }
            //public bool? Original_ShowOnline { get; set; }
            //public decimal? TaxPerc { get; set; }
            //public decimal? BTCSComm { get; set; }
            //public decimal? BTCDComm { get; set; }
            //public decimal? SGLNett { get; set; }
            //public decimal? DBLNett { get; set; }
            //public DateTime? BookFromDt { get; set; }
            //public DateTime? BookToDt{ get; set; }

            public string Action { get; set; }

            public string CityID { get; set; }
            public string InfoForOperation { get; set; }

            public string Heading { get; set; }

            public string HotelName { get; set; }

            public string CardNumber { get; set; }
            public string Name { get; set; }

        }

        //public class ReportDownloads
        //{
        //    public DateTime dtFromDate { get; set; }

        //    public DateTime dtToDate { get; set; }

        //    public string ReportType { get; set; }

        //    public int YearCode { get; set; }

        //    public string InvoiceId { get; set; }

        //    public string Action { get; set; }
        //    public string InvoicedAgentName { get; set; }

        //    public Guid? OperationBy { get; set; }
        //    public string ReportName { get; set; }


        //}

        public class ReportDownloads
        {
            // Request-related fields
            public int? UserId { get; set; }

            public DateTime ExportDateTime { get; set; }
            public DateTime dtFromDate { get; set; }
            public DateTime dtToDate { get; set; }
            public string ReportType { get; set; }
            public int YearCode { get; set; }
            public string Action { get; set; }
            public Guid? OperationBy { get; set; }
            public string ReportName { get; set; }

            // Invoice Report fields (from USP_GetReportDownloads - IN type)
            public string Invoice_ID { get; set; }
            public string Invoice_date { get; set; }
            public string File_ID { get; set; }
            public string QAgentName { get; set; }
            public string Customer_Name { get; set; }
            public string InvoicedAgentCode { get; set; }
            public string InvoicedAgentName { get; set; }
            public string InvAgentGST { get; set; }
            public string InvAgentPAN { get; set; }
            public string InvAgentStateCode { get; set; }
            public string Curr_id { get; set; }
            public decimal? ROE { get; set; }
            public decimal? BasicAmt { get; set; }
            public decimal? TaxableAmt { get; set; }
            public decimal? TaxRate { get; set; }
            public decimal? IGST { get; set; }
            public decimal? CGST { get; set; }
            public decimal? SGST { get; set; }
            public decimal? UTGST { get; set; }
            public decimal? TCSRate { get; set; }
            public decimal? TCSValue { get; set; }
            public decimal? TotalInvAmt { get; set; }
            public string SAC_Code { get; set; }
            public string Reference { get; set; }
            public string RefPONumber { get; set; }   // maps "Ref/PO Number"
            public string Username { get; set; }
            public string Invoice_Type { get; set; }
            public string BranchGSTIN { get; set; }   // maps "Branch GSTIN"
            public string OriginalInvoiceNo { get; set; }
            public string OriginalInvoiceDate { get; set; }
            public string companyname { get; set; }
            public string BizVertical { get; set; }
            public string Sez { get; set; }
            public string Export { get; set; }
            public string BTCComm { get; set; }
            public string DPComm { get; set; }
            public string ServiceLocation { get; set; }
            public string InvDescription { get; set; }

            // XO Report fields (for reportType = XO/XBTD/XBU/CINR etc.)
            public string Filecode { get; set; }
            public string XO_ID { get; set; }
            public string XO_date { get; set; }
            public string Sapcode { get; set; }
            public string XO_Supplier_Name { get; set; }
            public string XO_Customer_Name { get; set; }
            public decimal? XO_Amt { get; set; }
            public string XO_Arr { get; set; }
            public string XO_Dep { get; set; }
            public string Undo { get; set; }
            public string UndoDate { get; set; }
            public string IsDirectPayment { get; set; }
            public string SupplierChange { get; set; }
            public string SupplierChangeCode { get; set; }
            public string SupplierChangeName { get; set; }
            public string VendorGST { get; set; }
            public string StateCode { get; set; }
            public string FileLocation { get; set; }
            public string FHEName { get; set; }
            public string RefrenceNo { get; set; }

            // IRN Report fields
            public string AckNumber { get; set; }
            public string ACKDate { get; set; }
            public string IRN { get; set; }

            // Addendum Report fields
            public string AddendumDescription { get; set; }
            public decimal? AddendumDetailsAmount { get; set; }
            public decimal? TotalAddendumAmount { get; set; }

            // INR / PI / Other reports – extra fields
            public string QuotNo { get; set; }
            public string QtnDate { get; set; }
            public string TourDate { get; set; }
            public string TourEndDate { get; set; }
            public string Agent { get; set; }
            public string Customer { get; set; }
            public string Company_Name { get; set; }
            public string City { get; set; }
            public string Cancelled { get; set; }
            public string EnquiryNo { get; set; }
            public string Agent_Market { get; set; }
            public string Agent_Address_Country { get; set; }
            public string Agent_Address_State { get; set; }
            public string Agent_Address_City { get; set; }
            public DateTime TravelDate { get; set; }
            public DateTime OperationOn { get; set; }
            public string StatusDescription { get; set; }
            public string Agent_Staff_Name { get; set; }
            public string Remark { get; set; }
            public bool BigBilling { get; set; }
            public string Description { get; set; }
            public string YearID { get; set; }
            public string CompanyName { get; set; }
            public DateTime EnquiryDate { get; set; }
            public int AgentID { get; set; }
            public string AgentName { get; set; }
            public string Xo_id { get; set; }
            public string Curr_ID { get; set; }
            public bool IsBTCComm { get; set; }
            public string CompName { get; set; }
            public string EmpName { get; set; }
            public string BookingNo { get; set; }
            public DateTime QuotationDate { get; set; }
            public string VendorName { get; set; }
            public string CommType { get; set; }
            public DateTime Arr_Date { get; set; }
            public DateTime Dep_Date { get; set; }
            public DateTime XOArrDate { get; set; }
            public DateTime XODepDate { get; set; }
            public DateTime TourStartDate { get; set; }
            public string Code { get; set; }
            public string Branch_GSTIN { get; set; }
        }

        #region GREXOViewModel starts here
        public class GREXOViewModel
        {
            public string FileCode { get; set; }
            public string XONo { get; set; }
            public int VendorID { get; set; }
            public string XO_ID { get; set; }
            public string FHE { get; set; }
            public DateTime? dpXOArr { get; set; }
            public string XO_Customer_Name { get; set; }
            public decimal XO_Amt { get; set; }
            public string Curr_ID { get; set; }
            public bool Undo { get; set; }
            public DateTime? dpXOTo { get; set; }

            public DateTime? UndoDate { get; set; }

            public DateTime? XO_Date { get; set; }
            public int YearCode { get; set; }
            public string VendorName { get; set; }
            public string QuotationNo { get; set; }
            public int ServiceTypeID { get; set; }
            public int QuotationID { get; set; }
            public string SAPVendorName { get; set; }
            public string VendorSAPCode { get; set; }
            public bool isChange { get; set; }
            public string Empname { get; set; }
            public DateTime? SAPUpdatedDattime { get; set; }

        }
        #endregion GREXOViewModel ends here

        #region SearchFileCodeXoNoQuotation starts here
        public class SearchFileCodeXoNoQuotation
        {
            public string FileCode { get; set; }
            public string XoNo { get; set; }
            public string IsLocked { get; set; }
            public string CompID { get; set; }
            public string YearID { get; set; }
            public int QuotationID { get; set; }
            public string XO_ID { get; set; }
            public string XO_Supplier_Name { get; set; }
            public string CompanyName { get; set; }
            public bool IsPayment { get; set; }
        }
        #endregion SearchFileCodeXoNoQuotation ends here

        #region UpdateDataForLockUnlockQuotation starts here
        public class UpdateLockUnlockQuotationModel
        {
            public string FileCode { get; set; }
            public string Var { get; set; }
            public int CompID { get; set; }
            public int YearID { get; set; }

            public string ActionType { get; set; }

            public DateTime? OperationOn { get; set; }

            public Guid? OperationBy { get; set; }

            public string Application { get; set; }
            public string XoNumber { get; set; }
        }
        #endregion UpdateDataForLockUnlockQuotation ends here


        #region File2FileMapping starts here
        public class File2FileMapping
        {
            public int? CompanyID { get; set; }
            public int? YearID1 { get; set; }
            public string YearCode1 { get; set; }
            public string FileCode1 { get; set; }
            public int? YearID2 { get; set; }
            public string YearCode2 { get; set; }
            public string FileCode2 { get; set; }
            public bool? IsActive { get; set; }
            public Guid OperationBy { get; set; }
            public int? ID { get; set; }
            public string Action { get; set; }
            public string CompanyName { get; set; }
            public string Operation { get; set; }
            public DateTime OperationOn { get; set; }
        }
        #endregion File2FileMapping ends here

        #region GetReportTypes starts here
        public class GetReportTypes
        {
            public string Action { get; set; }
            public string ReportTypeValue { get; set; }
            public string ReportTypeName { get; set; }
            public int ID { get; set; }
        }
        #endregion GetReportTypes ends here

        #region XO starts here

        public class XODataModel
        {
            public string FILEID { get; set; }
            public int? YearCode { get; set; }
            public int? CompCode { get; set; }
            public string XO_ID { get; set; }
            public string HotelName { get; set; }
            public string VendorName { get; set; }
            public string Code { get; set; }
            public decimal XoAmount { get; set; }
            public string XODate { get; set; }
            public string? XOUndoDate { get; set; } // Nullable in case it can be null
            public bool IsDirectPayment { get; set; }
            public string FileCode { get; set; }
            public string Action { get; set; }
        }

        #endregion XO ends here

        #region filecode starts here
        public class FileCodes
        {
            public int CompanyID { get; set; }
            public int YearID { get; set; }
            public string FileCode { get; set; }
            public string Action { get; set; }

        }
        #endregion filecode ends here
    }
}
