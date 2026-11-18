using FluentValidation;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.Validations.HotelRateCard
{
    public class HotelRateCardCommissionValidator : AbstractValidator<HotelRateCommissionDetailRequestDto>
    {
        public HotelRateCardCommissionValidator() {

            RuleFor(x => x.TaxPercentage).GreaterThan(0).WithMessage("Tax percentage must be greater than zero.");
            RuleFor(x => x.TaxAmount).GreaterThan(0).WithMessage("Tax amount must be greater than zero.");
            RuleFor(x => x.GrossAmountExcludingTax).GreaterThan(0).WithMessage("Gross excluding tax amount must be greater than zero.");
            RuleFor(x => x.GrossAmountIncludingTax).GreaterThan(0).WithMessage("Gross including tax amount must be greater than zero.");

            RuleFor(x => x.CommissionPercentage).GreaterThan(0).WithMessage("Commission percentage must be greater than zero.");
            RuleFor(x => x.NetAmountIncludingTax).GreaterThan(0).WithMessage("Net amount including tax must be greater than zero.");
            RuleFor(x => x.NetAmountExcludingTax).GreaterThan(0).WithMessage("Net amount excluding tax must be greater than zero.");
        }
    }
}
