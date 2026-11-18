using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra_Operations.Interface;

namespace TamarindAstra_Operations.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BookingsController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly IBooking _booking;
        private readonly ILogger<BookingsController> _logger;


        public BookingsController(IConfiguration config, IBooking booking, ILogger<BookingsController> logger)
        {
            _config = config;
            _booking = booking;
            _logger = logger;
        }


        [HttpGet("GetAllQuotation")]
        public async Task<ResponseModel> GetAllQuotation()
        {
            return await _booking.GetAllQuotations();
        }
        //get Quotattion based on Booking id
        [HttpPost("GetQuotationBasedBookingId")]
        public async Task<ResponseModel> GetQuotationBasedBookingId(RequestModel request)
        {
            return await _booking.GetQuotationsbybookingId(request);
        }
        //filter baesd on parameter on Quotations
        [HttpPost("GetQuotationBasedOnFilter")]
        public async Task<ResponseModel> GetQuotationBasedOnFilter(RequestModel request)
        {
            return await _booking.GetQuotationsBasedOnFilter(request);
        }

        #region
        [HttpPost("Get_Booking_PrimaryInfo")]
        public async Task<ResponseModel> Get_Booking_PrimaryInfo(RequestModel request)
        {
            return await _booking.Get_Booking_PrimaryInfo(request);
        }
        [HttpPost("Insert_Booking_PrimaryInfo")]
        public async Task<ResponseModel> Insert_Booking_PrimaryInfo(RequestModel request)
        {
            return await _booking.Insert_Booking_PrimaryInfo(request);
        }
        [HttpPost("Update_Booking_PrimaryInfo")]
        public async Task<ResponseModel> Update_Booking_PrimaryInfo(RequestModel request)
        {
            return await _booking.Update_Booking_PrimaryInfo(request);
        }
        #endregion
        //mudasir code 
        [HttpPost("BookingMaster")]
        public async Task<ResponseModel> BookingMaster(RequestModel request)
        {
            return await _booking.BookingMaster(request);
        }

        [HttpPost("FetchBooking")]
        public async Task<ResponseModel> FetchBooking(RequestModel request)
        {
            return await _booking.FetchBookings(request);
        }

        [HttpPost("GetBookingService")]
        public async Task<ResponseModel> GetBookingService(RequestModel request)
        {
            return await _booking.GetBookingService(request);
        }

        [HttpPost("UpdateBookingService")]
        public async Task<ResponseModel> UpdateBookingService(RequestModel request)
        {
            return await _booking.UpdateBookingService(request);
        }

        [HttpPost("ConvertQuotationToBooking")]
        public async Task<ResponseModel> ConvertQuotationToBooking(RequestModel request)
        {
            return await _booking.ConvertQuotationToBooking(request);
        }

        [HttpPost("ConvertCommissionRateTonegotiateRate")]
        public async Task<ResponseModel> ConvertCommissionRateTonegotiateRate(RequestModel request)
        {
            return await _booking.ConvertCommissionRateTonegotiateRate(request);
        }

        [HttpPost("Booking_GuidDayWiseService")]
        public async Task<ResponseModel> Booking_GuidDayWiseService(RequestModel request)
        {
            return await _booking.Booking_GuidDayWiseService(request);
        }

        [HttpPost("Booking_TrasportDayWiseService")]
        public async Task<ResponseModel> Booking_TrasportDayWiseService(RequestModel request)
        {
            return await _booking.Booking_TrasportDayWiseService(request);
        }

        [HttpPost("Booking_SpecialServiceDayWiseService")]
        public async Task<ResponseModel> Booking_SpecialServiceDayWiseService(RequestModel request)
        {
            return await _booking.Booking_SpecialServiceDayWiseService(request);
        }

        [HttpPost("Booking_MonumentDayWiseService")]
        public async Task<ResponseModel> Booking_MonumentDayWiseService(RequestModel request)
        {
            return await _booking.Booking_MonumentDayWiseService(request);
        }

        [HttpPost("Booking_MOTDayWiseService")]
        public async Task<ResponseModel> Booking_MOTDayWiseService(RequestModel request)
        {
            return await _booking.Booking_MOTDayWiseService(request);
        }

        [HttpPost("Booking_HotelDayWiseService")]
        public async Task<ResponseModel> Booking_HotelDayWiseService(RequestModel request)
        {
            return await _booking.Booking_HotelDayWiseService(request);
        }
        [HttpPost("GenerateFileCode")]
        public async Task<ResponseModel> GenerateFileCode(RequestModel request)
        {
            return await _booking.GenerateFileCode(request);
        }
        //

        [HttpPost("UpdateDayWiseBooking")]
        public async Task<ResponseModel> UpdateDayWiseBooking(RequestModel request)
        {
            return await _booking.UpdateDayWiseBooking(request);
        }

        [HttpPost("DayWiseBooking")]
        public async Task<ResponseModel> GenerateDayWiseBooking(RequestModel request)
        {
            return await _booking.DayWiseDataAsync(request);
        }

        [HttpPost("GetDayWiseServiceData")]
        public async Task<ResponseModel> GetDayWiseServiceData(RequestModel request)
        {
            return await _booking.GetDayWiseServiceData(request);
        }
        [HttpPost("UpdateBookingFHE")]
        public async Task<ResponseModel> UpdateBookingFHE(RequestModel request)
        {
            return await _booking.UpdateBookingFHE(request);
        }


        [HttpPost("AddSubBooking")]
        public async Task<ResponseModel> AddSubBooking(RequestModel request)
        {
            return await _booking.AddSubBooking(request);
        }


        [HttpPost("AddCopyBooking")]
        public async Task<ResponseModel> AddCopyBooking(RequestModel request)
        {
            return await _booking.AddCopyBooking(request);
        }


        [HttpPost("GetNegotiateDetailForFileSumm")]
        public async Task<ResponseModel> GetNegotiateDetailForFileSumm(RequestModel request)
        {
            return await _booking.GetNegotiateDetailForFileSumm(request);
        }
    }
}
