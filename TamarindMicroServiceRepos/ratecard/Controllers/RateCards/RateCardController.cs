using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.Factory;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Rule;

namespace TamarindAstra.WebApi.RateCards.Controllers.RateCards
{
    [Route("api/rate-cards")]
    [ApiController]
    [ApiExplorerSettings(GroupName = "Rate Cards")]
    public class RateCardsController : BaseController
    {
        public RateCardsController(
            IGetRateCardFactory getRateCardFactory,
            ICreateRateCardFactory createRateCardFactory,
            IUpdateRateCardFactory updateRateCardFactory,
            IRateRuleLogic rateRuleLogic) :
            base(getRateCardFactory, createRateCardFactory, updateRateCardFactory, rateRuleLogic)
        {
        }

        [HttpPost]
        [Route("/{type}/ratecard")]
        public async Task<IActionResult> RateCardAsync(RateCardType type, [FromBody] RequestModel request)
        {
            var resonse = await RateCardFactoryAsync(type, request);
            return Ok(resonse);
        }

        [HttpPost]
        [Route("/{type}/Customratecard")]
        public async Task<IActionResult> CustomRateCardAsync(RateCardType type, [FromBody] RequestModel request)
        {
            var resonse = await CustomRateCardFactoryAsync(type, request);
            return Ok(resonse);
        }

        [HttpPost]
        [Route("/{type}/NegotiateRateCard")]
        public async Task<IActionResult> NegotiateRateCardAsync(RateCardType type, [FromBody] RequestModel request)
        {
            var resonse = await NegotiateRateCardFactoryAsync(type, request);
            return Ok(resonse);
        }

        [HttpPost]
        [Route("/{type}/ratecard-detail")]
        public async Task<IActionResult> RateCardDetailAsync(RateCardType type, [FromBody] RequestModel request)
        {
            var resonse = await RateCardDetailFactoryAsync(type, request);
            return Ok(resonse);
        }
        [HttpPost]
        [Route("/{type}/ratecard-document")]
        public async Task<IActionResult> RateCardDocumentAsync(RateCardType type, [FromBody] RequestModel request)
        {
            var result = await RateCardDocumentFactoryAsync(type, request);
            return Ok(result);
        }
        [HttpPost]
        [Route("/{type}/ratecard-rule")]
        public async Task<IActionResult> RateCardRuleAsync(RateCardType type, [FromBody] RequestModel request)
        {
            var result = await RateRuleFactoryAsync(type, request);
            return Ok(result);
        }
        [HttpPost]
        [Route("/{type}/ratecard-cancellationpolicy")]
        public async Task<IActionResult> RateCardCancellationPolicyAsync(RateCardType type, [FromBody] RequestModel request)
        {
            var result = await RateCancellationPolicyFactoryAsync(type, request);
            return Ok(result);
        }
        [HttpPost]
        [Route("/{type}/ratecard-number")]
        public async Task<IActionResult> GetRateCardNumberAsync(RateCardType type, [FromBody] RequestModel request)
        {
            return Ok(await GetRateCardNumberFactoryAsync(type, request));
        }
        [HttpPost]
        [Route("/{type}/ratecard-heading")]
        public async Task<IActionResult> GetRateCardHeadingAsync(RateCardType type, [FromBody] RequestModel request)
        {
            return Ok(await GetRateCardHeadingFactoryAsync(type, request));
        }
        [HttpPost]
        [Route("/{type}/ratecard-service")]
        public async Task<IActionResult> GetRateCardServiceAsync(RateCardType type, [FromBody] RequestModel request)
        {
            return Ok(await GetRateCardServicesFactoryAsync(type, request));
        }

        [HttpPost]
        [Route("/{type}/ratecard-copy")]
        public async Task<IActionResult> RateCardCopyAsync(RateCardType type, [FromBody] RequestModel request)
        {
            return Ok(await CreateRateCardCopyFactoryAsync(type, request));
        }


        [HttpPost]
        [Route("/{type}/ratecard-search")]
        public async Task<IActionResult> RateCardSearchAsync(RateCardType type, [FromBody] RequestModel request)
        {
            var result = await RateSearchReportFactoryAsync(type, request);
            return Ok(result);
        }

       

    }
}
