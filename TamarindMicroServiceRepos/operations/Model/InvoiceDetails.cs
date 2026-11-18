namespace TamarindAstra_Operations.Model
{
    public class InvoiceDetails
    {

        public string Action { get; set; }
        public long ID { get; set; }
        public long InvoiceID { get; set; }
        public string Invoice_Desc { get; set; }
        public decimal Invoice_Value { get; set; }
        public int YearCode { get; set; }
        public int flag { get; set; }
        public string SAC { get; set; }
        public decimal Tax_Per { get; set; }
        public long Allocate { get; set; }

        public decimal BasicAmount { get; set; }
        public decimal Taxable_Amount { get; set; }
        public decimal Tax_Amount { get; set; }
        public decimal TotalInvoiceAmount { get; set; }
        public decimal TotalBasicAmount { get; set; }
        public decimal TotalTaxableAmount { get; set; }

        public decimal TotalTax_Amount { get; set; }

        public string StateCode { get; set; }
        public long SACID { get; set; }
        public int Tax_ID { get; set; }
        public decimal CGST { get; set; }
        public decimal SGST { get; set; }
        public decimal UTGST { get; set; }
        public decimal IGST { get; set; }
        public long StateCodeID { get; set; }
        public int InvGenerated { get; set; }
        public string Commercial_ID { get; set; }
        public long Parent_ID { get; set; }
        public decimal TotalTktCost { get; set; }
        public decimal MarkUp { get; set; }
        public decimal TTC_MarkUp { get; set; }
        public decimal BaseFare { get; set; }
        public decimal TotalBaseFare { get; set; }
        public decimal TCSAmount { get; set; }
        public int TCSRateID { get; set; }
        public int Invoice_Desc_ID { get; set; }
        public Guid CreatedBy { get; set; }

        public decimal TCSAmount2 { get; set; }

        public object AddendumJSON { get; set; }


        public decimal TotalAmount { get; set; }
        public decimal SelectedTax { get; set; }
        public decimal BasicValue { get; set; }
        public decimal TaxableAmount { get; set; }
        public decimal TotalTaxAmount { get; set; }
        public decimal TaxValue { get; set; }
        public decimal TotalTaxable_Amount { get; set; }

        public decimal AddendumTotalAmount { get; set; }

        public decimal TaxAmount { get; set; }

        public decimal TaxableAmountDetail { get; set; }
        









    }
    public class ItemDescriptionModel
    {
        public string ItemDescription { get; set; }
        public string TotalAmount { get; set; }
    }
}
