using Microsoft.AspNetCore.Mvc;
using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstraMasters.Interface;

[ApiController]
[Route("api/[controller]")]
public class SearchController : ControllerBase
{
    private readonly IConfiguration _config;
    private readonly ISearch _Search;
    private readonly ILogger<SearchController> _logger;

    public SearchController(IConfiguration config, ISearch Search, ILogger<SearchController> logger)
    {
        _config = config;
        _Search = Search;
        _logger = logger;
    }

    #region SearchHotelRate starts here
    //[Authorize]
    [HttpPost("HotelRate")]
    public async Task<ResponseModel> Search_HotelRate(RequestModel request)
    {
        return await _Search.Search_HotelRate(request);
    }
    #endregion SearchHotelRate ends here

    #region Search_HotelRate_Rule starts here
    //[Authorize]
    [HttpPost("Search_HotelRate_Rule")]
    public async Task<ResponseModel> Search_HotelRate_Rule(RequestModel request)
    {
        return await _Search.Search_HotelRate_Rule(request);
    }
    #endregion Search_HotelRate_Rule ends here

    #region Search_Docs starts here
    //[Authorize]
    [HttpPost("Search_Docs")]
    public async Task<ResponseModel> Search_Docs(RequestModel request)
    {
        return await _Search.Search_Docs(request);
    }
    #endregion Search_Docs ends here

    #region Hotel_FactSheet starts here
    //[Authorize]
    [HttpPost("Hotel_FactSheet")]
    public async Task<ResponseModel> Hotel_FactSheet(RequestModel request)
    {
        return await _Search.Hotel_FactSheet(request);
    }
    #endregion Hotel_FactSheet ends here

    #region Search_HotelRate_CancellationData starts here
    //[Authorize]
    [HttpPost("Search_HotelRate_CancellationData")]
    public async Task<ResponseModel> Search_HotelRate_CancellationData(RequestModel request)
    {
        return await _Search.Search_HotelRate_CancellationData(request);
    }
    #endregion Search_HotelRate_CancellationData ends here

    #region Search_OtherRateCard starts here
    /*//[Authorize]
    [HttpPost("OtherRateCard")]
    public async Task<ResponseModel> Search_OtherRateCard(RequestModel request)
    {
        return await _Search.Search_OtherRateCard(request);
    }*/
    #endregion Search_OtherRateCard ends here

    #region GetGuideRateCardOnSearch starts here
    //[Authorize]
    [HttpPost("GuideRateCard")]
    public async Task<ResponseModel> GetGuideRateCardOnSearch(RequestModel request)
    {
        return await _Search.GetGuideRateCardOnSearch(request);
    }
    #endregion GetGuideRateCardOnSearch ends here

    #region GetMonumentRateCardOnSearch starts here
    //[Authorize]
    [HttpPost("MonumentRateCard")]
    public async Task<ResponseModel> GetMonumentRateCardOnSearch(RequestModel request)
    {
        return await _Search.GetMonumentRateCardOnSearch(request);
    }
    #endregion GetMonumentRateCardOnSearch ends here

    #region GetTransportRateCardOnSearch starts here
    //[Authorize]
    [HttpPost("TransportRateCard")]
    public async Task<ResponseModel> GetTransportRateCardOnSearch(RequestModel request)
    {
        return await _Search.GetTransportRateCardOnSearch(request);
    }
    #endregion GetTransportRateCardOnSearch ends here

    #region GetSpecialServiceRateCardOnSearch starts here
    //[Authorize]
    [HttpPost("SpecialServiceRateCard")]
    public async Task<ResponseModel> GetSpecialServiceRateCardOnSearch(RequestModel request)
    {
        return await _Search.GetSpecialServiceRateCardOnSearch(request);
    }
    #endregion GetSpecialServiceRateCardOnSearch ends here

    #region Search_HotelOffer starts here
    //[Authorize]
    [HttpPost("HotelOffer")]
    public async Task<ResponseModel> Search_HotelOffer(RequestModel request)
    {
        return await _Search.Search_HotelOffer(request);
    }
    #endregion Search_HotelOffer ends here

    #region Search_AgentInfo starts here
    //[Authorize]
    [HttpPost("AgentInfo")]
    public async Task<ResponseModel> Search_AgentInfo(RequestModel request)
    {
        return await _Search.Search_AgentInfo(request);
    }
    #endregion Search_AgentInfo ends here


    #region Search_Contact starts here
    //[Authorize]
    [HttpPost("Contact")]
    public async Task<ResponseModel> Search_Contact(RequestModel request)
    {
        return await _Search.Search_Contact(request);
    }
    #endregion Search_Contact ends here

    #region Search_HotelInfo starts here
    //[Authorize]
    [HttpPost("HotelInfo")]
    public async Task<ResponseModel> Search_HotelInfo(RequestModel request)
    {
        return await _Search.Search_HotelInfo(request);
    }
    #endregion Search_HotelInfo ends here

    #region HotelRoomInfo starts here
    //[Authorize]
    [HttpPost("HotelRoomInfo")]
    public async Task<ResponseModel> HotelRoomInfo(RequestModel request)
    {
        return await _Search.HotelRoomInfo(request);
    }
    #endregion HotelRoomInfo ends here

    #region Search_VendorInfo starts here
    //[Authorize]
    [HttpPost("VendorInfo")]
    public async Task<ResponseModel> Search_VendorInfo(RequestModel request)
    {
        return await _Search.Search_VendorInfo(request);
    }
    #endregion Search_VendorInfo ends here    

    #region Search_ContactInfo starts here
    //[Authorize]
    [HttpPost("ContactInfo")]
    public async Task<ResponseModel> Search_ContactInfo(RequestModel request)
    {
        return await _Search.Search_ContactInfo(request);
    }
    #endregion Search_ContactInfo ends here

    #region Search_HotelRoomOrAnnouncement starts here
    //[Authorize]
    [HttpPost("HotelRoomOrAnnouncement")]
    public async Task<ResponseModel> Search_HotelRoomOrAnnouncement(RequestModel request)
    {
        return await _Search.Search_HotelRoomOrAnnouncement(request);
    }
    #endregion Search_HotelRoomOrAnnouncement ends here

    #region Search_PrintInvoiceNew starts here
    //[Authorize]
    [HttpPost("PrintInvoiceNew")]
    public async Task<ResponseModel> Search_PrintInvoiceNew(RequestModel request)
    {
        return await _Search.Search_PrintInvoiceNew(request);
    }
    #endregion Search_PrintInvoiceNew ends here

    #region Search_PrintInvoice starts here
    //[Authorize]
    [HttpPost("PrintInvoice")]
    public async Task<ResponseModel> Search_PrintInvoice(RequestModel request)
    {
        return await _Search.Search_PrintInvoice(request);
    }
    #endregion Search_PrintInvoice ends here

    #region Search_GuideInfo starts here
    //[Authorize]
    [HttpPost("GuideInfo")]
    public async Task<ResponseModel> Search_GuideInfo(RequestModel request)
    {
        return await _Search.Search_GuideInfo(request);
    }
    #endregion Search_GuideInfo ends here

    #region Search_PrintCommInvoice starts here
    //[Authorize]
    [HttpPost("PrintCommInvoice")]
    public async Task<ResponseModel> Search_PrintCommInvoice(RequestModel request)
    {
        return await _Search.Search_PrintCommInvoice(request);
    }
    #endregion Search_PrintCommInvoice ends here

    #region Search_Manage_Contact starts here
    //[Authorize]
    [HttpPost("SearchManage_Contact")]
    public async Task<ResponseModel> SearchManage_Contact(RequestModel request)
    {
        return await _Search.SearchManage_Contact(request);
    }
    #endregion Search_Manage_Contact ends here

    #region SearchPrintWithTax starts here
    [HttpPost("SearchPrintWithTax")]
    public async Task<ResponseModel> SearchPrintWithTax(RequestModel request)
    {
        return await _Search.SearchPrintWithTax(request);
    }
    #endregion SearchPrintWithTax ends here
}

