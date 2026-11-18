using FluentValidation;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.Validations.HotelRateCard
{
    public class CreateRateValidityCollectionValidator : AbstractValidator<List<HotelRateValidityRequestDto>>
    {
        public CreateRateValidityCollectionValidator()
        {
            RuleForEach(x => x).SetValidator(new HotelRateCardValidityValidator());
        }
    }
}
