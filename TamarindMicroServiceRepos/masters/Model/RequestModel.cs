using System.ComponentModel.DataAnnotations;

namespace Zoop.Model
{
    public class PanVerificationRequest
    {
        [Required]
        [StringLength(10)]
        public string PanNumber { get; set; }

        /*[Required]
        public bool Consent { get; set; } = true;

        public string ConsentText { get; set; } = "I consent to PAN verification";*/
    }

    public class GstVerificationRequest
    {
        [Required]
        [StringLength(15)]
        public string GstNumber { get; set; }
/*
        [Required]
        public bool Consent { get; set; } = true;*/
    }

    public class TanVerificationRequest
    {
        [Required]
        [StringLength(10)]
        public string TanNumber { get; set; }

        /*[Required]
        public bool Consent { get; set; } = true;*/
    }

    public class PassportVerificationRequest
    {
        [Required]
        [StringLength(8)]
        public string PassportNumber { get; set; }
/*
        [Required]
        public DateTime ExpiryDate { get; set; }

        [Required]
        public bool Consent { get; set; } = true;*/
    }
}