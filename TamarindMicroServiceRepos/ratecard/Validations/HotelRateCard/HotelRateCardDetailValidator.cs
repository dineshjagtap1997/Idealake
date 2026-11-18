using FluentValidation;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.Validations.HotelRateCard
{
    public class HotelRateCardDetailValidator : AbstractValidator<HotelRateDetailRequestDto>
    {
        public HotelRateCardDetailValidator()
        {
            RuleFor(x => x.RoomCategoryID).GreaterThan(0).WithMessage("Room category is required.");
            RuleFor(x => x.TransferID).GreaterThan(0).WithMessage("Transfer is required.");
            RuleFor(x => x.MinNights).GreaterThan(0).WithMessage("Minimum nights is required.");
            RuleFor(x => x.MaxNights).GreaterThan(0).WithMessage("Maximum nights is required.");
            RuleFor(x => x.MealPlanID).GreaterThan(0).WithMessage("MIS sequence number is required.");
            RuleFor(x => x.MISSequence).NotEmpty().WithMessage("MIS sequence number is required.");
        }
    }
}
