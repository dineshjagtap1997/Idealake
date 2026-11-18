using CommonClass;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TamarindAstraLoginDashboardReport.Interface
{
    public interface ILogin
    {
         Task<ResponseModel>Login(RequestModel request);
         //Task<ResponseModel> RefreshToken(RequestModel request);
    }
}