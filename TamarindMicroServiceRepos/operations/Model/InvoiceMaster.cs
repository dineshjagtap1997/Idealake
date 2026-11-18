using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;
using System.ComponentModel.DataAnnotations;



namespace TamarindAstra_Operations.Model
{
    public class InvoiceMaster
    {

        public string Action { get; set; }
        public long ID { get; set; }
        public int InvoiceID { get; set; }

        public string InvoiceNumber { get; set; }
        public int TypeofDoc { get; set; }
        public int InvoiceType { get; set; }
        public DateTime? Invoice_Date { get; set; }
        public string FileCode { get; set; }


        public int QuotationID { get; set; }
        public string GuestName { get; set; }
        public int AgentID { get; set; }
        public int Curr_ID { get; set; }

        public string Currency { get; set; }

        public int Tax_ID { get; set; }
        public int Invoice_No_Of_Pax { get; set; }
        public string Invoice_Credit_Note { get; set; }
        public string Invoice_Exchg_Rate { get; set; }
        public decimal Invoice_Curr_Amt { get; set; }
        public decimal Invoice_Total { get; set; }
        public string Reference { get; set; }
        public int compcode { get; set; }
        public decimal TotalAmount { get; set; }


        public int CompanyID { get; set; }

        public int YearCode { get; set; }
        public decimal ReceivedAmt { get; set; }
        public decimal BalAmt { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal AmtInINR { get; set; }
        public bool MiscAcc { get; set; }
        public string RefNo { get; set; }
        public bool PreviousYear { get; set; }
        public bool isVoid { get; set; }
        public string ConvertedInvNo { get; set; }
        public Guid? CreatedBy { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string LastUpdatedBy { get; set; }
        public DateTime LastUpdateDateTime { get; set; }
        public bool IsDirectPayment { get; set; }
        public string SAC_ID { get; set; }
        public string StateCode_ID { get; set; }
        public bool IsTaxReverseCharge { get; set; }
        public string flag { get; set; }
        public int TaxIDOps { get; set; }
        public string GSTIN { get; set; }
        public int GST_Perc { get; set; }
        public long GSTTypeID { get; set; }
        public long PlaceOfSupplierId { get; set; }

        public string PlaceOfSupplier { get; set; }
        public decimal CGST { get; set; }
        public decimal SGST { get; set; }
        public decimal UTGST { get; set; }
        public decimal IGST { get; set; }
        public decimal Allocate { get; set; }
        public string KindAttn { get; set; }
        public long SAP_StateCode { get; set; }
        public string ParentInvoiceID { get; set; }
        public int SubQuotationRank { get; set; }
        public string CityIATACode { get; set; }
        public decimal TotalTaxAmount { get; set; }
        public string flag_InvOrTktInv { get; set; }
        public bool IsStatewiseflag { get; set; }
        public bool IsBillOfSupply { get; set; }
        public bool IsTcsInvoice { get; set; }
        public DateTime IRNReqDateTime { get; set; }
        public bool IsPANExists { get; set; }
        public bool IsBTCComm { get; set; }
        public int Original_YearID { get; set; }
        public string Original_FileID { get; set; }
        public string Original_QutID { get; set; }
        public int Original_CompID { get; set; }
        public string Commercial_ID { get; set; }
        public int ServiceTypeID { get; set; }
        public int ServiceLocID { get; set; }
        public int TCSRateID { get; set; }
        public string PANNo { get; set; }
        public decimal TCSValue { get; set; }
        public decimal TotalBaseAmt { get; set; }
        public string AgentRefPO { get; set; }
        public string AgentRefPOCreatedBy { get; set; }
        public DateTime AgentRefPOCreatedDateTime { get; set; }
        public string EXPSEZ { get; set; }

        public string InvoiceStatus { get; set; }
        public string IRN { get; set; }

        public string BookingID { get; set; }

        public string Status { get; set; }
        public bool isNonResident { get; set; }
        public bool isTDSDeduction { get; set; }
        public bool IsTaxInvoice { get; set; }

        public string AgentBookerName { get; set; }


        public string CurrencyName { get; set; }

        public string TDS { get; set; }

        public string TANNumber { get; set; }

        public string PanNumber { get; set; }

        public string TAXNumber { get; set; }

        public int TCSTaxID { get; set; }

        public decimal ServiceTaxableAmount { get; set; }

        public string AgentName { get; set; }

        public DateTime FileCodeDate { get; set; }

        public string AgentCountry { get; set; }

        public string XOID { get; set; }

        public string Performa { get; set; }

        public string Invoice { get; set; }

        public decimal SelectedTax { get; set; }
        public decimal BasicValue { get; set; }
        public decimal TaxableAmount { get; set; }
        public decimal TaxValue { get; set; }
        public decimal TotalTaxable_Amount { get; set; }
        public decimal TotalBasicAmount { get; set; }
        public decimal TotalTaxableAmount { get; set; }


        public decimal TotalInvoiceAmount { get; set; }


        public string AddendumJson { get; set; }

        public string AddendumJsonDetails { get; set; }

        public string SACID { get; set; }

        public string Invoice_Desc_ID { get; set; }

        public string AddendumTotalAmount { get; set; }

        public string GroupKey { get; set; }

        public decimal TaxableAmountDetail { get; set; }
        public decimal BasicAmount { get; set; }
        public decimal TCSAmount { get; set; }

        public string VendorName { get; set; }

        public int? VendorID { get; set; }
        public int? InvoiceTaxType { get; set; }

    }

    public class TaxInvoice
    {
        public long? InvoiceDetailID { get; set; }
        public long? Invoice_ID { get; set; }
        public string Invoice_Desc { get; set; }
        public decimal? Invoice_Value { get; set; }
        public int? YearCode { get; set; }
        public decimal? TotalTaxable_Amount { get; set; }
        public decimal? TotalTax_Amount { get; set; }
        public decimal? TotalBasicAmount { get; set; }
        public decimal? SUM_Taxable_Amount { get; set; }

        public decimal? SUM_Tax_Amount { get; set; }
        public decimal? SUM_TotalBaseFare { get; set; }
        public decimal? TCSAmount { get; set; }
        public decimal? TCSAmoSUM_TCSunt { get; set; }
        public string? SAC { get; set; }
        public decimal? Tax_Per { get; set; }
        public decimal? TCSRate { get; set; }
        public string TCS_Per { get; set; }

        public string InvoiceID { get; set; }
        public int? QuotationID { get; set; }
        public string Action { get; set; }
        public int? Type { get; set; }
    }
    public class TaxInvoiceRequest
    {
        public List<InvoiceQuotationPair> Invoices { get; set; }
        public string Action { get; set; }
        public int? Type { get; set; }
    }

    public class InvoiceQuotationPair
    {
        public string InvoiceID { get; set; }
        public int BookingID { get; set; }
    }

    public class OtherServiceTax
    {
        public int? TaxID { get; set; }
        public string TaxCode { get; set; }
        public string TaxDescription { get; set; }
        public decimal? TaxRate { get; set; }
        public string Action { get; set; }
        public Guid? OperationBy { get; set; }

        public int? AgentID { get; set; }
        public int? CompanyID { get; set; }

        public DateTime DATE { get; set; }

        public int? Tax_ID { get; set; }

        public int? GSTType { get; set; }

        public string GSTPercentage { get; set; }


    }

}
