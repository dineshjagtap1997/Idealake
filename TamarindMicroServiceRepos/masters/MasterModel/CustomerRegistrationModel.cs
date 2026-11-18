using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations.Schema;

namespace TamarindAstraMasters.MasterModel
{
    public class CustomerRegistrationModel
    {
        public class CustomerRegistration
        {
            public string EmailTo { get; set; }
            public string EmailFrom { get; set; }
            public string EmailCC { get; set; }
            public string OpsRemark { get; set; }
            public int? TamSalesRepId { get; set; }
            public List<AttachmentModel>? AttachmentUrl { get; set; }
            public string Subject { get; set; }
            public int? AgentClassId { get; set; }
            public int? MarketMasterId { get; set; }
            public bool? CreditApplicable { get; set; }
            public decimal? CreditAllowance { get; set; }
            public int? CreditCurrency { get; set; }
            public Guid? OperationBy { get; set; }
            public string Action { get; set; }
            public int? CustRegID { get; set; }
            public string EncryptedCustRegID { get; set; }
            public DateTime? createdDate { get; set; }
            public int? IsMailSent { get; set; }
            public string agentClassification { get; set; }
            public string marketAssigned { get; set; }
            public string tamSalesRep { get; set; }
            public string creditCurrency { get; set; }
            public string createdByName { get; set; }
            public int? RequestID { get; set; }

            public int? CustRegDetID { get; set; }

            public string TradeName { get; set; }
            public string LegalName { get; set; }
            public string BillingAddress { get; set; }
            public string Country { get; set; }
            public string State { get; set; }
            public string CustomState { get; set; }
            public string City { get; set; }
            public string CustomCity { get; set; }
            public string PostalCode { get; set; }
            public string PAN { get; set; }
            public string GST { get; set; }
            public string TAN { get; set; }
            public bool? SEZ_Unit { get; set; }
            public string AccountName { get; set; }
            public string AccountNumber { get; set; }
            public string BankName { get; set; }
            public string IFSC { get; set; }
            public string ContactNumber { get; set; }
            public string EmailID { get; set; }
            public string AgentClassification { get; set; }
            public string MarketAssigned { get; set; }
            public string TamSalesRep { get; set; }

            public DateTime? CreatedDate { get; set; }
            public string CreatedBy { get; set; }
            public string GSTFileName { get; set; }
            public string PANFileName { get; set; }
            public string TANFileName { get; set; }
            public string VAT { get; set; }
            public string VATFileName { get; set; }
            public string RegistrationDeptDetailJSON { get; set; }
            //public List<DeptDetail> ManagementDeptDetailJSON { get; set; }
            //public List<DeptDetail> FinanceDeptDetailJSON { get; set; }

            public string ManagementDeptDetailJSON { get; set; }
            public string FinanceDeptDetailJSON { get; set; }

            [NotMapped]
            public List<DeptDetail> ManagementDeptDetails =>
                string.IsNullOrWhiteSpace(ManagementDeptDetailJSON)
                    ? new List<DeptDetail>()
                    : JsonConvert.DeserializeObject<List<DeptDetail>>(ManagementDeptDetailJSON);

            [NotMapped]
            public List<DeptDetail> FinanceDeptDetails =>
                string.IsNullOrWhiteSpace(FinanceDeptDetailJSON)
                    ? new List<DeptDetail>()
                    : JsonConvert.DeserializeObject<List<DeptDetail>>(FinanceDeptDetailJSON);


        }
        public class DeptDetail
        {
            public int RegDeptID { get; set; }
            public string RegType { get; set; }

            public int RequestID { get; set; }

            public string DeptName { get; set; }

            public string Name { get; set; }

            public string Designation { get; set; }

            public string MCountryCode { get; set; }

            public string MobileNumber { get; set; }

            public string EmailID { get; set; }

            public DateTime createdDate { get; set; }

            public Guid operationBy { get; set; }
        }

        public class AttachmentModel
        {
            internal string Fileext;

            [JsonProperty("base64")]
            public string Base64Content { get; set; }

            [JsonProperty("filename")]
            public string FileName { get; set; }
            public string Filename { get; internal set; }
            public string FilePath { get; set; }
            public string ContentType { get; set; }
            public byte[] FileBytes { get; set; }
            public string Base64 { get; internal set; }
            public string FileExt { get; internal set; }
        }
    }
}
