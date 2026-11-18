using MathNet.Numerics;
using MathNet.Numerics.Distributions;
using NPOI.SS.Formula.Functions;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using static NPOI.HSSF.Util.HSSFColor;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Transport
{
    public class TransportServiceRate : RateCardBase
    {
        public long TransportRateID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public int TransportServiceID { get; set; }
        public TransportModeType TransportModeTypeID { get; set; }
        public int HotelID { get; set; }
        public int VendorID { get; set; }
        public int HotelZone { get; set; }
        public string CityID { get; set; }
        public string CityID2 { get; set; }
        public string CurrencyID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }

        
        public string VendorName { get; set; }
        public string City1 { get; set; }
         public string TransportServiceName { get; set; }
        public string HotelZoneName { get; set; }
    }
}