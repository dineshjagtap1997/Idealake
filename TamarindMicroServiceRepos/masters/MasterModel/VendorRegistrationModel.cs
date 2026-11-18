using Newtonsoft.Json;
using static TamarindAstraMasters.MasterModel.CustomerRegistrationModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace TamarindAstraMasters.MasterModel
{
    public class VendorRegistrationModel
    {
        public class VendorRegistration
        {
            public long VendorRegID { get; set; }
            public string EmailTo { get; set; }
            public string EmailFrom { get; set; }
            public string EmailCC { get; set; }
            public string Subject { get; set; }
            public string emailBody { get; set; }
            public string VendorService { get; set; }
            public string AccountGroupCode { get; set; }
            public string AccountGroupName { get; set; }
            public string ReasonForAddingVendor { get; set; }
            public DateTime? createdDate { get; set; }
            public string createdByName { get; set; }
            public int? RequestID { get; set; }
            public Guid? OperationBy { get; set; }
            public int? IsMailSent { get; set; }
            public string EncryptedCustRegID { get; set; }
            public string Action { get; set; }
            public int VendorRegDetID { get; set; }
            public string? VendorName { get; set; }
            public string? LegalName { get; set; }

            public int? LegalEntTypeID { get; set; }

            public string? VendorPostalAddress { get; set; }
            public string? Country { get; set; }
            public string? State { get; set; }
            public string? CustomState { get; set; }
            public string? City { get; set; }
            public string? CustomCity { get; set; }
            public string? PostalCode { get; set; }

            public int? ISDCode { get; set; }
            public string? STDCode { get; set; }
            public string? ContactNumber { get; set; }
            public string? Website { get; set; }
            public string? EmailID { get; set; }


            public string? PAN { get; set; }
            public string? GST { get; set; }
            public string? TAN { get; set; }
            public string? MSMEType { get; set; }
            public string? MSME_No { get; set; }
            public string? UDYAMNo { get; set; }

            public string? AccountName { get; set; }
            public string? AccountNumber { get; set; }
            public string? BankName { get; set; }
            public string? IFSC { get; set; }
            public string? BankBranch { get; set; }

            public string? CancelBankChequeFileName { get; set; }
            public string? GSTFileName { get; set; }
            public string? PANFileName { get; set; }
            public string? TANFileName { get; set; }
            public string? MSMEFileName { get; set; }
            public string? VATFileName { get; set; }

            public string? VAT { get; set; }
            public bool? SEZ_Unit { get; set; }

            public DateTime? CreatedDate { get; set; }
            public string? CreatedBy { get; set; }
            public List<AttachmentModel>? AttachmentUrl { get; set; }

            public string RegistrationDeptDetailJSON { get; set; }

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
