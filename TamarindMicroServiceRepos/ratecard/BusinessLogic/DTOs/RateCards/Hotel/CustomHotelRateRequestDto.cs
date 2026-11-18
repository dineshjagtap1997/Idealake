using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class CustomHotelRateRequestDto : HotelRateDetail
    {
        public string CityID { get; set; }//City*
        public string CurrencyID { get; set; }//Currency*
        public long HotelID { get; set; }//Hotel*
        public long VendorID { get; set; }//Vendor*
        public int PaymentTypeID { get; set; }//Direct Commission/ BTC commission
        public bool IsCommission { get; set; }
        public bool IsTax { get; set; } //Including/ExcludingTax
        public string LanguageID { get; set; }//Language*
        public int VehicleCategoryID { get; set; }//Vehical Category*
        public int ServiceID { get; set; }//Service*
        public string ValueAddOn { get; set; }//Service Discription*
        public int NationalityID { get; set; }//Nationality*
        public long QuotationID { get; set; }
        public int RatePreferenceID { get; set; }

        public List<CustomRateCommission> Commissions { get; set; } = new();
        public List<HotelRateMealRequestDto> Meals { get; set; } = new();

        public DateTime? CheckIn { get; set; }
        public DateTime? CheckOut { get; set; }

        public string XORemark { get; set; }//Xo Remark*
        public string MOTNameORNumber { get; set; }//Xo Remark*
        public string Sector { get; set; }//Xo Remark*
        public int TravelModeTypeID { get; set; }//Xo Remark*
        public string Validfrom { get; set; }
        public string ValidTo { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }//Rate Type*
        public long BookingID { get; set; }
        public bool? TaxType { get; set; }

    }

}
