using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.
    l.DBModel
{
    public class AgewiseandHotelwiseRoomNights
    {
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string ReportType { get; set; }
        public int YearCode { get; set; }

        public string Action { get; set; }
    }

    public class PLBMaster
    {
        public string Action { get; set; }


        public int? PLBID { get; set; }


        public string CityCode { get; set; }


        public int? HotelID { get; set; }


        public DateTime? ValidFrom { get; set; }


        public DateTime? ValidTo { get; set; }


        public string Target { get; set; }


        public string ValidonRateType { get; set; }


        public string PLBClaim { get; set; }

        public string PLBType { get; set; }


        public string ClaimPeriod { get; set; }


    }

    public class PackageCodeMaster
    {
        public string Action { get; set; }
        public string PkgMktCode { get; set; }
        public int Nights { get; set; }
        public string StateRouteCode { get; set; }
        public string ExtnAssignedCode { get; set; }
        public string PackageName { get; set; }
        public string Remarks { get; set; }
        public string PackageCode { get; set; }
        public Guid OperationBy { get; set; }

    }
}
