namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities
{
    public class AcknowledgedResponse<T>
    {
        public bool IsSuccess { get; set; }
        public T? Data { get; set; }
        public string ValidationError { get; set; }
    }
}
