using CommonClass;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide.Document
{
    public class GuideRateDocumentResponseDto : UploadDocuments
    {
        public string GuideCardNo { get; set; }
        public string GuideService { get; set; }
    }
}
