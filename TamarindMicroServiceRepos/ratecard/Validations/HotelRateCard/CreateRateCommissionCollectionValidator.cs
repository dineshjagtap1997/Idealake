using FluentValidation;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.Validations.HotelRateCard
{
    public class CreateRateCommissionCollectionValidator : AbstractValidator<List<HotelRateCommissionDetailRequestDto>>
    {
        public CreateRateCommissionCollectionValidator()
        {
            RuleForEach(x => x).SetValidator(new HotelRateCardCommissionValidator());
        }
    }
}
