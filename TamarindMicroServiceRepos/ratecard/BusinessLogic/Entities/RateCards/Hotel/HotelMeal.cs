namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel
{
    public class HotelMeal : RateCardBase
    {
        public bool IsMealDetails { get; set; }
        public bool DefinedAmount { get; set; }
        public string MealType { get; set; }
        public decimal GstPercentage { get; set; }
        public decimal GstAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
    }
}
