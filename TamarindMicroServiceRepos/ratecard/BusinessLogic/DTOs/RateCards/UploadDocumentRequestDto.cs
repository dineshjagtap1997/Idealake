namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards
{
    public class UploadDocumentRequestDto
    {
        public string Action { get; set; }
        public string CardNumber { get; set; }
        public string GuideCardNo { get; set; }
        public string MonumentCardNo { get; set; }
        public string SpecialServiceCardNo { get; set; }
        public string TransportCardNo { get; set; }
        public int HotelID { get; set; }
        public long MOTRateID { get; set; }
        public string GuideService { get; set; }
        public string SpecialService { get; set; }
        public string MonumentName { get; set; }
        public int TransportServiceID { get; set; }
        public int VendorID { get; set; }
        public string UploadedBy { get; set; }
        public int ParentTypeID { get; set; }
        public int ParentID { get; set; }

        public string DocumentName { get; set; }
    }
}
