using CommonClass;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport.Document
{
    public class TransportDocumentResponseDto : UploadDocuments
    {
        public string Service { get; set; }
        public int VendorID { get; set; }

        public string VendorName { get; set; }

    }
}
