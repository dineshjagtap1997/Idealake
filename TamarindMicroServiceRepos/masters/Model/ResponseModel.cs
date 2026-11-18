namespace Zoop.Model
{
    public class VerificationResponse<T>
    {
        public bool Success { get; }
        public string VerificationStatus { get; } // "Valid/Invalid/Expired"
        public string Message { get; }
        public T Data { get; }
        public DateTime Timestamp { get; } = DateTime.UtcNow;
        public List<string> Errors { get; } = new();

        public VerificationResponse(bool success, string status, string message, T data)
        {
            Success = success;
            VerificationStatus = status;
            Message = message;
            Data = data;
        }
    }

    public class PanVerificationResult
    {
        public string Number { get; set; }
        public string Status { get; set; }
        public string FullName { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public bool success { get; set; }

    }

    public class GstVerificationResult
    {
        public string Number { get; set; }
        public bool success { get; set; }
        public string BusinessName { get; set; }
        public string Status { get; set; }
        public Address BusinessAddress { get; set; }
    }

    public class TanVerificationResult
    {
        public string Number { get; set; }
        public string HolderName { get; set; }
        public string Status { get; set; }
        public bool success { get; set; }
    }

    public class PassportVerificationResult
    {
        public string Number { get; set; }
        public string FullName { get; set; }
        public DateTime? DateOfIssue { get; set; }
        public DateTime? ExpiryDate { get; set; }
        public string Status { get; set; }
        public bool success { get; set; }
    }

    public class Address
    {
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
    }
}