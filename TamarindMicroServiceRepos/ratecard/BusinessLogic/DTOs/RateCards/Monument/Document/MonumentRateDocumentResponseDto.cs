using CommonClass;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument.Document
{
    public class MonumentRateDocumentResponseDto : UploadDocuments
    {
        public string MonumentCardNo { get; set; }
        public string MonumentService { get; set; }
    }
}
