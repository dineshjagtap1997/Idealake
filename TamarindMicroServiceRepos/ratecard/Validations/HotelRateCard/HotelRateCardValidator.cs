using FluentValidation;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.Validations.HotelRateCard
{
    public class HotelRateCardValidator : AbstractValidator<HotelRateRequestDto>
    {
        public HotelRateCardValidator()
        {
            RuleFor(x => x.Heading).NotEmpty().WithMessage("Heading is required.");
            RuleFor(x => x.ContractDate).NotEmpty().WithMessage("Contract Date is required.");
            RuleFor(x => x.RateCardModeTypeID).IsInEnum().WithMessage("Invalid RateCardMode.");
        }
    }
}
