namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Mappers
{
    public interface IAsyncMapper
    {
        Task MapAsync<TSource, TDestination>(TSource source, TDestination destination);
    }
}
