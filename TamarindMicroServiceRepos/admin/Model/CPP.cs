namespace DataAccess.Model.DBModel
{
    public class AgewiseandHotelwiseRoomNights
    {
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public string ReportType { get; set; }
        public DateTime date { get; set; }
        public string AgentMarket { get; set; }
        public string AgentCountry { get; set; }
        public string AgentCity { get; set; }
        public string AgentName { get; set; }
        public string HotelCity { get; set; }
        public string HotelGroup { get; set; }
        public string HotelName { get; set; }
        public string InfoForOps { get; set; }
        public string XORemark { get; set; }
        public string XOID { get; set; }
        public string RoomCategory { get; set; }
        public string Day { get; set; }
        public int RoomNight1 { get; set; }
        public string Origin { get; set; }
        public string HotelRating { get; set; }
        public string CustomerName { get; set; }
        public int AmtInINR1 { get; set; }
        public string Preferred { get; set; }
        public int QuotationID { get; set; }
        public string CompanyName { get; set; }
        public string UserName { get; set; }
        public string IsCorporate { get; set; }
        public string BusinessType { get; set; }
        public string IsDirectPayment { get; set; }
        public string YearCode { get; set; }
        public int cnt { get; set; }
        public string FileCode { get; set; }
        public string BookingType { get; set; }
        public bool IsChannellBooking { get; set; }
        public int ChannellBookingID { get; set; }
        public string VendorName { get; set; }
        public string XoVendorName { get; set; }
        public DateTime ChkInDate { get; set; }
        public DateTime ChkOutDate { get; set; }
        public string ConfirmationNumber { get; set; }
        public int RoomNight { get; set; }
        public int AmtInINR { get; set; }
     
    }

    public class PLBMaster
    {
        public string Action { get; set; }
        public int? PLBID { get; set; }
        public string CityCode { get; set; }
        public int? HotelID { get; set; }
        public DateTime? ValidFrom { get; set; }
        public DateTime? ValidTo { get; set; }
        public string Target { get; set; }
        public string ValidonRateType { get; set; }
        public string PLBClaim { get; set; }
        public string PLBType { get; set; }
        public string ClaimPeriod { get; set; }
        public bool IsActive { get; set; }

        public string HotelName { get; set; }

        public string CityName { get; set; }
        public int? HotelGroupID { get; set; }

        public string HotelGroupName { get; set; }
        public string IATACode { get; set; }
        public Guid OperationBy { get; set; }


    }

    public class PackageCodeMaster
    {
        public string Action { get; set; }
        public string PkgMktCode { get; set; }
        public int Nights { get; set; }
        public string StateRouteCode { get; set; }
        public string PackageID { get; set; }
        public string ExtnAssignedCode { get; set; }
        public string PackageName { get; set; }
        public string Remarks { get; set; }
        public string PackageCode { get; set; }
        public Guid OperationBy { get; set; }
        public bool IsActive { get; set; }

    }
    public class CPPReport
    {
        public string ReportType { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
    }
}
