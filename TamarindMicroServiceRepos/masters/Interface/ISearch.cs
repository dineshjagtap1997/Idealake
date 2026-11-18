
using CommonClass;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TamarindAstraMasters.Interface
{
    public interface ISearch
    {
        Task<ResponseModel> Search_HotelRate(RequestModel request);
        Task<ResponseModel> Search_HotelRate_Rule(RequestModel request);
        Task<ResponseModel> Search_Docs(RequestModel request);
        Task<ResponseModel> Hotel_FactSheet(RequestModel request);
        Task<ResponseModel> Search_HotelRate_CancellationData(RequestModel request);
        Task<ResponseModel> GetGuideRateCardOnSearch(RequestModel request);
        Task<ResponseModel> GetMonumentRateCardOnSearch(RequestModel request);
        Task<ResponseModel> GetTransportRateCardOnSearch(RequestModel request);
        Task<ResponseModel> GetSpecialServiceRateCardOnSearch(RequestModel request);
        Task<ResponseModel> Search_HotelOffer(RequestModel request);
        Task<ResponseModel> Search_AgentInfo(RequestModel request);
        Task<ResponseModel> Search_Contact(RequestModel request);
        Task<ResponseModel> Search_HotelInfo(RequestModel request);
        Task<ResponseModel> HotelRoomInfo(RequestModel request);
        Task<ResponseModel> Search_VendorInfo(RequestModel request);
        Task<ResponseModel> Search_ContactInfo(RequestModel request);
        Task<ResponseModel> Search_HotelRoomOrAnnouncement(RequestModel request);
        Task<ResponseModel> Search_PrintInvoiceNew(RequestModel request);
        Task<ResponseModel> Search_PrintInvoice(RequestModel request);
        Task<ResponseModel> Search_GuideInfo(RequestModel request);
        Task<ResponseModel> Search_PrintCommInvoice(RequestModel request);
        Task<ResponseModel> SearchManage_Contact(RequestModel request);
        Task<ResponseModel> SearchPrintWithTax(RequestModel request);

        /*Task<ResponseModel> Search_OtherRateCard(RequestModel request);*/
    }
}
