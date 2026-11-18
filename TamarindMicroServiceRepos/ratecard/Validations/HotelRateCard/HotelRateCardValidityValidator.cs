using FluentValidation;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.Validations.HotelRateCard
{
    public class HotelRateCardValidityValidator : AbstractValidator<HotelRateValidityRequestDto>
    {
        public HotelRateCardValidityValidator()
        {
            RuleFor(x => x.BookTo)
            .NotEmpty().WithMessage("Book from is required")
            .WithMessage("Book From Date must be a valid date (DD-MM-YYYY).");

            RuleFor(x => x.BookTo)
            .NotEmpty().WithMessage("Book to is required.")
            .WithMessage("Book To Date must be a valid date (DD-MM-YYYY).");
        }

        private bool ParseDate(string date)
        {
            return DateTime.TryParse(date, out _);
        }
    }
}
