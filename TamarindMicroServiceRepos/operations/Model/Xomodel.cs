using MimeKit.Encodings;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NPOI.POIFS.Properties;
using NPOI.SS.Formula.Functions;
using System.Globalization;
using System.Text;

namespace TamarindAstra_Operations.Model
{
    public class Xomodel
    {
        //public class InsertXOModel
        //{
        //    public string XO_ID { get; set; }
        //    public string File_ID { get; set; }
        //    public string Book_ID { get; set; }
        //    public string XO_Customer_Name { get; set; }
        //    public DateTime XO_Date { get; set; }
        //    public string XO_Supplier_Name { get; set; }
        //    public decimal XO_Amt { get; set; }
        //    public decimal Trans_Qut_ID { get; set; }
        //    public decimal Rail_Air_Qut_ID { get; set; }
        //    public decimal Entrences_Qut_ID { get; set; }
        //    public decimal Special_Serv_Qut_ID { get; set; }
        //    public decimal Guide_Qut_ID { get; set; }
        //    public int YearCode { get; set; }
        //    public string Accode { get; set; }
        //    public decimal PaymentAmt { get; set; }
        //    public decimal BalAmt { get; set; }
        //    public decimal AmtInINR { get; set; }
        //    public string Curr_ID { get; set; }
        //    public string Xo_Exchg_Rate { get; set; }
        //    public decimal BillReceived { get; set; }
        //    public char XoType { get; set; }
        //    public bool Undo { get; set; }
        //    public DateTime? UndoDate { get; set; }
        //    public DateTime? ROEUpdatedOn { get; set; }
        //    public bool IsCancellationXo { get; set; }
        //    public bool IsDirectPayment { get; set; } = false;
        //    public string HotelCode { get; set; }
        //    public string VendorCode { get; set; }
        //    public string HotelVendorFlag { get; set; }
        //    public bool IsBTCComm { get; set; } = false;
        //    public DateTime? DepartureDate { get; set; }
        //    public DateTime? InsertedDate { get; set; }
        //    public string InsertedBy { get; set; }
        //    public DateTime? UpdatedDate { get; set; }
        //    public string UpdatedBy { get; set; }
        //    public string Action { get; set; }

        //    public bool IsPayment { get; set; } = false;

        //    public long BookingID { get; set; }
        //    public int GroupKey { get; set; }
        //    public string DayWiseID { get; set; }

        //    public decimal Hotel_Qut_ID { get; set; }  // this must match the SP's Qut_ID mapping

        //}

        public class InsertXOModel
        {
            public string XONumber { get; set; }
            public decimal? XO_Amt { get; set; }
            public int YearCode { get; set; }
            public string Accode { get; set; }
            public decimal PaymentAmt { get; set; }
            public decimal AmtInINR { get; set; }
            public decimal BillReceived { get; set; }
            public string CompanyCode { get; set; }
            public string OperationBy { get; set; }
            public string UpdatedBy { get; set; }
            public string BookingID { get; set; }
            public string GroupKey { get; set; }
            public string Action { get; set; }

            public bool IsDirectPayment { get; set; }


            // Accept comma-separated or list
            public string DayWiseID { get; set; }
            [JsonIgnore]
            public List<int> DayWiseIDList => DayWiseID?
                .Split(',', StringSplitOptions.RemoveEmptyEntries)
                .Where(x => int.TryParse(x, out _))
                .Select(int.Parse)
                .ToList();
        }





        //public class GetXo
        //{
        //    public int? BookingID { get; set; }
        //    public string Action { get; set; } = "S";

        //    public string XOType { get; set; }
        //    public string XONumber { get; set; }
        //    public string Supplier { get; set; }
        //    public decimal XOAmount { get; set; }
        //    public string Currency { get; set; }
        //    public decimal GrossRate { get; set; }
        //    public DateTime Checkin { get; set; }
        //    public DateTime Checkout { get; set; }
        //    public bool? IsBTCComm { get; set; }
        //    public int CommInv { get; set; }
        //    public string City { get; set; }
        //    public string XOInstruction { get; set; }
        //    public string GroupKey { get; set; }
        //    public string IDList { get; set; }


        //}
        public class GetXo
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
            public string CommXO { get; set; }

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

            // public string? RequestId { get; set; }

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
            public bool IsXoGen { get; set; }
            public string? RequestId { get; set; }
            public string Bank_Account_Name { get; set; }
            public string Bank_Account_No { get; set; }
            public string Bank_Name { get; set; }
            public string IFSC { get; set; }
            public string SAP_Vendor_Code { get; set; }
            public string File_Handler { get; set; }
            public string SAP_Comp_Code { get; set; }
            public string SAP_XO_BizPlace_Code { get; set; }
            public string Biz_Vertical { get; set; }
            public string Agent_Credit_Status { get; set; }
            public string Supplier_Credit { get; set; }
            public string Name {  get; set; }
            public string MOT { get; set; }
            public string Sectors { get; set; }
        }
        //public class XOUnlockMailRequest
        //{
        //    public string SVCStartDateFormatted { get; set; }  // Add this
        //    public string SVCEndDateFormatted { get; set; }
        //    public string? RequestId { get; set; }

        //    public string From { get; set; }
        //    public string To { get; set; }
        //    public string CC { get; set; }
        //    public string FileCode { get; set; }
        //    public string RequestedBy { get; set; }
        //    public string Reason { get; set; }
        //    public string Responsibility { get; set; }

        //    public DateTime? FileEndDate { get; set; }

        //    public string? Action { get; set; }
        //    public string XOID { get; set; }
        //    public string Currency { get; set; }
        //    public DateTime? SVCStartDate { get; set; }
        //    public DateTime? SVCEndDate { get; set; }
        //    public string Commission { get; set; }
        //    public string XOAmount { get; set; }
        //    public string HotelName { get; set; }
        //    public string Vendor_Name { get; set; }



        //}

        public class XOUnlockMailRequest
        {
            public string? RequestId { get; set; }
            public string From { get; set; }
            public string To { get; set; }
            public string CC { get; set; }
            public string FileCode { get; set; }
            public string RequestedBy { get; set; }
            public string Reason { get; set; }
            public string Responsibility { get; set; }
            public DateTime? FileEndDate { get; set; }
            public string? Action { get; set; }
            public string? XO_ID { get; set; }
            public string Currency { get; set; }
            public string SVCStartDate { get; set; }  // Changed to string
            public string SVCEndDate { get; set; }    // Changed to string
            public string Commission { get; set; }
            public string XOAmount { get; set; }
            public string HotelName { get; set; }
            public string Vendor_Name { get; set; }
        }

        public class EmailModel
        {
            public string From { get; set; }
            public string To { get; set; }
            public string Cc { get; set; }
            public string Subject { get; set; }
            public string Body { get; set; }
        }

        public class XOInstructionModel
        {
            public int? BookingID { get; set; }
            public int XO_InstructionID { get; set; }
            public string File_ID { get; set; }
            public string Customer_Name { get; set; }
            public string? Supplier_Name { get; set; }
            public string XO_ID { get; set; }
            public decimal Qut_ID { get; set; }

            public string? Forign_Exchange { get; set; }
            public string? Meals_Menu_Basis { get; set; }
            public string? XO_Line_Desc { get; set; }
            public string? XO_Instruction { get; set; }
            public string? Confirmed_By { get; set; }

            public DateTime? ArrivalDate { get; set; }
            public DateTime? DepartureDate { get; set; }

            public string? FromCity { get; set; }
            public string? ToCity { get; set; }

            public string? ArrivalBy { get; set; }
            public string? DeptBy { get; set; }

            public string? FromTime { get; set; }
            public string? ToTime { get; set; }

            public int? YearCode { get; set; }
            public DateTime? XO_IssuedOn { get; set; }

            public int? NoOfPax { get; set; }
            public string XoType { get; set; }
            public string XODayWiseID { get; set; }
            public char Action { get; set; }
        }
        public class UpdateUndoXOModel
        {
            public string XOID { get; set; }
            public int YearCode { get; set; }
            public string? XO_UserID { get; set; }
            public DateTime? XOUpdated_Dt { get; set; }
            public DateTime? XO_UNDODt { get; set; }
            public string Action { get; set; } = "U";
        }
        public class AdvancePaySendRequestModel
        {
            public long? ID { get; set; }
            public string AttachmentBase64 { get; set; }
            public string AttachmentName { get; set; }

            public string FileHandler { get; set; }

            public string Filebranch { get; set; }
            public string Hotel_Name { get; set; }

            public string ProfitCentreCode { get; set; }

            public string Request_ID { get; set; }
            public DateTime? Request_Date { get; set; }
            public string Request_Date_Formatted { get; set; }
            public bool? IsBTCComm { get; set; }

            public string Requested_By { get; set; }
            public string SAPCompCode { get; set; }
            public string SAPXOBizPlaceCode { get; set; }
            public string BizVertical { get; set; }
            public string FileCode { get; set; }
            public string GuestName { get; set; }
            public string AgentName { get; set; }
            public string AgentCredit { get; set; }
            public string? XO_ID { get; set; }
            //public string? Check_In { get; set; }
            //public string? Check_Out { get; set; }
            public DateTime? Check_In { get; set; }
            public string Check_In_Formatted { get; set; }
            //   Check_In
            public DateTime? Check_Out { get; set; }
            public string Check_Out_Formatted { get; set; }
            //  Check_Out
            public string XO_Curr { get; set; }
            //  XO_Curr
            //public decimal XO_Amt { get; set; }
            public string GST_Per { get; set; }

            //public decimal TAC_Invoice_Amt { get; set; }
            //public decimal TDS_Amt { get; set; }
            //  public decimal Vendor_Bill_Amt { get; set; }
            //  public decimal Amt_To_be_Released { get; set; }
            public string HotelName { get; set; }
            public string Vendor_Name { get; set; }
            public string PayTo { get; set; }
            public string? Supplier_Credit { get; set; }
            public string Bank_Account_Name { get; set; }
            public string Bank_Account_No { get; set; }
            public string Bank_Name { get; set; }
            public string IFSC { get; set; }
            public string SAP_Vendor_Code { get; set; }
            public string TAC_Invoice_No { get; set; }
            public string Approved_By { get; set; }
            public string Reason_For_Advance { get; set; }
            public string Action { get; set; } = "I"; // default value for insert

            public string? ModeOfPayment { get; set; }

            // public decimal TaxAmount { get; set; }

            public string? AgentPaymentStatus { get; set; }

            public string? AgentPaymentStatus1 { get; set; }

            public decimal? TAC_Invoice_Amt { get; set; }
            //   TAC_Invoice_Amt
            public decimal? TDS_Amt { get; set; }
            //  TDS_Amt
            public decimal? XO_Amt { get; set; }
            // XO_Amt

            public decimal? Vendor_Bill_Amt { get; set; }
            // Vendor_Bill_Amt
            public decimal? Amt_To_be_Released { get; set; }
            //  Amt_To_be_Released
            public decimal? TaxAmount { get; set; }

            public int Unlock_Request_ID { get; set; }
            public string Unlock_Reason { get; set; }
            public string Unlock_Responsibility { get; set; }
            public DateTime FileEndDate { get; set; }
            public string ApproveLink { get; set; }
            public string RejectLink { get; set; }


            public string EmailTo { get; set; }
            public string EmailFrom { get; set; }
            public string EmailCC { get; set; }
            public string OpsRemark { get; set; }
            //[JsonConverter(typeof(AttachmentListConverter))]
            //public List<AttachmentModel> AttachmentUrl { get; set; }
            //public List<string> AttachmentUrl { get; set; }
            public List<AttachmentModel> AttachmentUrl { get; set; }


            // public long? XODayWiseID { get; set; }
            public string XODayWiseID { get; set; }

            public string? Remarks { get; set; }

            public string Curr_Id { get; set; }

            public int AmtPaid { get; set; }

            public string AmtPaid1 { get; set; }


            public int? AgentID { get; set; }

            public decimal? VoucherAmt { get; set; }

            public string ChequeFavouring { get; set; }

            public string XOLocation { get; set; }

            public string XONumber { get; set; }

            public string Link { get; set; }

            //public List<AttachmentModel> Attachments { get; set; }

            public string AgentCreditStatus { get; set; }
            public Guid OperationBy { get; set; }

        }

        public class AttachmentListConverter : JsonConverter<List<AttachmentModel>>
        {
            public override List<AttachmentModel> ReadJson(JsonReader reader, Type objectType, List<AttachmentModel> existingValue, bool hasExistingValue, JsonSerializer serializer)
            {
                var token = JToken.Load(reader);

                if (token.Type == JTokenType.Array)
                {
                    return token.ToObject<List<AttachmentModel>>();
                }

                if (token.Type == JTokenType.String)
                {
                    return new List<AttachmentModel>
            {
                new AttachmentModel { FileName = token.ToString(), Base64Content = "" }
            };
                }

                return new List<AttachmentModel>();
            }

            public override void WriteJson(JsonWriter writer, List<AttachmentModel> value, JsonSerializer serializer)
            {
                serializer.Serialize(writer, value);
            }
        }


        public class AttachmentModel
        {
            internal string? Fileext;

            [JsonProperty("base64")]
            public string Base64Content { get; set; }

            [JsonProperty("filename")]
            public string FileName { get; set; }
            public string? Filename { get; internal set; }
            public string FilePath { get; set; }
            public string ContentType { get; set; }
            public byte[] FileBytes { get; set; }
            public string? Base64 { get; internal set; }
            public string? FileExt { get; internal set; }
        }




        public class QuotationXOAdvPyModel
        {
            public string SAPCompCode { get; set; }
            public string Request_ID { get; set; }
            public string Request_Date { get; set; }
            public string Requested_By { get; set; }
            public string FileHandler { get; set; }
            public string FileCode { get; set; }
            public string Filebranch { get; set; }
            public string XO_ID { get; set; }
            public string Curr_Id { get; set; }
            public string AmtToBeReleased { get; set; }
            public string ModeOfPay { get; set; }
            public string GuestName { get; set; }
            public string AgentName { get; set; }
            public string AgentCredit { get; set; }
            public string HotelName { get; set; }
            public string VendorName { get; set; }
            public string PayTo { get; set; }
            public string HotelVendorCredit { get; set; }
            public string Check_in { get; set; }
            public string Check_out { get; set; }
            public string TACInvNo { get; set; }
            public decimal? TACInvAmt { get; set; }
            public decimal? TDS { get; set; }
            public decimal? VoucherAmt { get; set; }
            public string GSTPercent { get; set; }
            public string GSTAmt { get; set; }
            public string VendorBillAmt { get; set; }
            public bool? IsBTCComm { get; set; }
            public string ChequeFavouring { get; set; }
            public string AccountNo { get; set; }
            public string Bank_Account_Name { get; set; }
            public string BankName { get; set; }
            public string IFSCCode { get; set; }
            public string VendorSAPCode { get; set; }
            public string BizVertical { get; set; }
            public string XOLocation { get; set; }
            public string ApprovedBy { get; set; }
            public string ReasonForadvance { get; set; }
            public string SAPXOBizPlaceCode { get; set; }
            public int Quotationid { get; set; }
            public string Emaildate { get; set; }
            public string Status { get; set; }
            public string AstraEntry { get; set; }
            public DateTime? DepartureDate { get; set; }
            public DateTime? ArrivalDate { get; set; }
            public string PaymentRecd { get; set; }
            public string Remarks { get; set; }
            public string CCChargeDate { get; set; }
            public string CCChargedAmt { get; set; }
            public string CreditApplicable { get; set; }
            public string HotelVendorFlag { get; set; }
            public string HotelCredit { get; set; }
            public string VendorCredit { get; set; }
            public string DOCID { get; set; }

            public string Action { get; set; } = "S";

            public int? CompanyID { get; set; }

            public string XOID { get; set; }

            public string EmailTo { get; set; }
            public string EmailFrom { get; set; }
            public string EmailCC { get; set; }


        }


        #region printxo starts here
        //public class XOReportModel
        //{
        //    public string? XOID { get; set; }
        //    public string CompanyName { get; set; }
        //    public string Address { get; set; }
        //    public string CityIATACode { get; set; }
        //    public string Website { get; set; }
        //    public string Email { get; set; }
        //    public string HeadCompanyName { get; set; }
        //    public string Phone { get; set; }
        //    public string Fax { get; set; }
        //    public string HeadAddress { get; set; }
        //    public string HeadPhone { get; set; }
        //    public string HeadFax { get; set; }
        //    public string HeadWebsite { get; set; }
        //    public string HeadEmail { get; set; }
        //    public string AgentLogo { get; set; }
        //    public bool IsTTCLogo { get; set; }
        //    public string QuotationNo { get; set; }
        //    public string FileCode { get; set; }
        //    public string YearCode { get; set; }
        //    public string InvoiceEmail { get; set; }
        //    public string CorporateIdentityNumber { get; set; }
        //    public string XOFlag { get; set; }
        //    public string CompFlag { get; set; }

        //    public string Action { get; set; }


        //    public string OnePDF { get; set; }  
        //    public string XOType { get; set; }
        //}
        public class XOReportModel
        {
            public string? XOID { get; set; }
            public string CompanyName { get; set; }
            public string Address { get; set; }
            public string CityIATACode { get; set; }
            public string Website { get; set; }
            public string Email { get; set; }
            public string HeadCompanyName { get; set; }
            public string Phone { get; set; }
            public string Fax { get; set; }
            public string HeadAddress { get; set; }
            public string HeadPhone { get; set; }
            public string HeadFax { get; set; }
            public string HeadWebsite { get; set; }
            public string HeadEmail { get; set; }
            public string AgentLogo { get; set; }        // ✅ base64 logo supported
            public bool IsTTCLogo { get; set; }          // ✅ TTC logo toggle
            public string QuotationNo { get; set; }
            public string FileCode { get; set; }
            public string YearCode { get; set; }
            public string InvoiceEmail { get; set; }
            public string CorporateIdentityNumber { get; set; }
            public string XOFlag { get; set; }           // ✅ Vendor / Agent switch
            public string CompFlag { get; set; }
            public string Action { get; set; }

            public string OnePDF { get; set; }           // ✅ Single PDF flag
            public string XOType { get; set; }

            public string PanNumber { get; set; }

            public string MSMERegNo { get; set; }

            public string LUTNumber { get; set; }

            public string ACKNo { get; set; }

            public string IRN { get; set; }

            public DateTime? ACKDate { get; set; }
            public DateTime? VoucherDate { get; set; }

            public string GSTIN { get; set; }

            public string CIN { get; set; }
            public bool IncludeAgentLogo { get; set; }
            public bool IncludeCompanyLogo { get; set; }

            public string Services { get; set; }
            public string Nationality { get; set; }
            public string VehicleCategory { get; set; }
            public string Language { get; set; }
            public string Count { get; set; }
            public string Adult { get; set; }
            public string Child { get; set; }

            public bool IsDirectPayment { get; set; }

        }


        #endregion printxo ends here

        public class AdvancePayApprovalModel
        {
            public string Request_ID { get; set; }
            public string ActionType { get; set; }  // "Approved" or "Rejected"
            public string Approved_By { get; set; }
            public string OpsRemark { get; set; }

            public string Action { get; set; }
        }

    }

}

