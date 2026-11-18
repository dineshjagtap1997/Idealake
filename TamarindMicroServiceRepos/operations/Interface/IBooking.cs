using CommonClass;

namespace TamarindAstra_Operations.Interface
{
    public interface IBooking
    {
        public Task<ResponseModel> GetAllQuotations();
        public Task<ResponseModel> GetQuotationsbybookingId(RequestModel request);
        public Task<ResponseModel> Insert_Booking_PrimaryInfo(RequestModel request);
        public Task<ResponseModel> Update_Booking_PrimaryInfo(RequestModel request);
        public Task<ResponseModel> Get_Booking_PrimaryInfo(RequestModel request);
        public Task<ResponseModel> GetQuotationsBasedOnFilter(RequestModel request);
        public Task<ResponseModel> BookingMaster(RequestModel request);
        public Task<ResponseModel> GetBookingService(RequestModel request);
        public Task<ResponseModel> AddSubBooking(RequestModel request);
        public Task<ResponseModel> AddCopyBooking(RequestModel request);

        public Task<ResponseModel> UpdateBookingService(RequestModel request);
        public Task<ResponseModel> FetchBookings(RequestModel request);
        public Task<ResponseModel> ConvertQuotationToBooking(RequestModel request);
        public Task<ResponseModel> ConvertCommissionRateTonegotiateRate(RequestModel request);

        public Task<ResponseModel> Booking_GuidDayWiseService(RequestModel request);
        public Task<ResponseModel> Booking_TrasportDayWiseService(RequestModel request);
        public Task<ResponseModel> Booking_SpecialServiceDayWiseService(RequestModel request);
        public Task<ResponseModel> Booking_MOTDayWiseService(RequestModel request);
        public Task<ResponseModel> Booking_MonumentDayWiseService(RequestModel request);
        public Task<ResponseModel> Booking_HotelDayWiseService(RequestModel request);
        //public Task<ResponseModel> BookingMaster(RequestModel request);
        public Task<ResponseModel> GenerateFileCode(RequestModel request);

        public Task<ResponseModel> UpdateDayWiseBooking(RequestModel request);
        public Task<ResponseModel> DayWiseDataAsync(RequestModel request);
        public Task<ResponseModel> GetDayWiseServiceData(RequestModel request);
        public Task<ResponseModel> UpdateBookingFHE(RequestModel request);
        public Task<ResponseModel> GetNegotiateDetailForFileSumm(RequestModel request);
    }
}
