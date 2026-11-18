namespace TamarindAstra_Operations.Model
{
    public class Addendum
    {


        public string Action { get; set; }
        public int AddendumID { get; set; }
        public string AddendumNo { get; set; }
        public DateTime AddendumDate { get; set; }
        public string Currency { get; set; }
        public decimal TotalAmount { get; set; }
        public long InvoiceID { get; set; }
        public DateTime InvoiceDate { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public string YearCode { get; set; }

        public decimal Amount { get; set; }
        public int ID { get; set; }
        public string Description { get; set; }

        public object AddendumJSON { get; set; }

    }

    public class AddendumDetail
    {
        public int ID { get; set; }
        public int AddendumID { get; set; }
        public string Description { get; set; }
        public string InvoiceID { get; set; }
        public string Currency { get; set; }
        public string Amount { get; set; }
        public DateTime CreatedDate { get; set; }
        public string YearCode { get; set; }
        public DateTime UpdatedDate { get; set; }
    }
}
