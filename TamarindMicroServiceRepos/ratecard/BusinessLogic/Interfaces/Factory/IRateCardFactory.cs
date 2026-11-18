using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.Factory
{
    public interface ICreateRateCardFactory
    {
        ICreateRateCardLogic Create(RateCardType type);
    }
    public interface IGetRateCardFactory
    {
        IGetRateCardLogic Create(RateCardType type);
    }
    public interface IUpdateRateCardFactory
    {
        IUpdateRateCardLogic Create(RateCardType type);
    }
}
