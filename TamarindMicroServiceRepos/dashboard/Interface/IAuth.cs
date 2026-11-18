using CommonClass;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TamarindAstraLoginDashboardReport.Interface
{
    public interface IAuth
    {
        Task<ResponseModel> RefreshToken(RequestModel request);
        Task<ResponseModel> ExpiredToken(RequestModel request);
    }
}