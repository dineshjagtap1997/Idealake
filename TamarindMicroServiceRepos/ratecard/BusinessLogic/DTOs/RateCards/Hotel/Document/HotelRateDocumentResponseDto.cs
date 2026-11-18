using CommonClass;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.Document
{
    public class HotelRateDocumentResponseDto : UploadDocuments
    {
        public string CardNumber { get; set; }
        public string HotelName { get; set; }
    }
}
