using CommonClass;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.Interface
{
    public interface ICPP
    {
        Task<ResponseModel> AgewiseandHotelwiseRoomNights(RequestModel request);

        Task<ResponseModel> PLBMaster(RequestModel request);

        Task<ResponseModel> PackageCodeMaster(RequestModel request);


        //Task<string> CPPReports(RequestModel request);
    }
}
