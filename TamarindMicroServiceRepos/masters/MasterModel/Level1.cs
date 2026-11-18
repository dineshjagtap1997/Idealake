using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace TamarindAstra.Model.DBModel
{
    public class CityMaster
    {
        public string IATACode { get; set; }
        public string Name { get; set; }
        public int StateIATACode { get; set; }
        public int STDCode { get; set; }
        public int? State_ID { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        //public string ErrMsg { get; set; } = string.Empty;
        public string Action { get; set; }
        public string CityName { get; set; }
        public string CountryName { get; set; }
        public string StateName { get; set; }
        public string Country_IATACode { get; set; }
        public string CityIATACode { get; set; }
        public int ID { get; set; }


    }

    public class CountryMaster
    {
        public string IATACode { get; set; }
        public string Name { get; set; }
        public int Nationality { get; set; }
        public string ISDCode { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public string PostalCode { get; set; }

        public string Action { get; set; }
        public string CountryName { get; set; }

        // Add the missing property to map NationalityName
        public string NationalityName { get; set; }
        public string Country_IATACode { get; set; }
        public int ID { get; set; }
    }

    public class StateMaster
    {
        public int State_ID { get; set; }
        public string Country_IATACode { get; set; } = string.Empty;
        public string? Name { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        //public string ErrMsg { get; set; } = string.Empty;
        public string? StateCode { get; set; }
        //public int? Compcode { get; set; }
        public string BranchCode { get; set; }
        public string CompanyName { get; set; }
        public string Action { get; set; } = string.Empty;
        public string? CountryName { get; set; } = string.Empty;
        public string? StateName { get; set; } = string.Empty;
        public int? CompanyID { get; set; }
        public string? State_Code_CM { get; set; }
        public string? Compcode { get; set; }
    }

    public class MarketMaster
    {

        public int ID { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public string ABRV { get; set; }
        public Guid OperationBy { get; set; }
        //public string ErrMsg { get; set; }
        public string Action { get; set; }


    }

    public class DepartmentMaster
    {

        public string Dept_Name { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        //public string ErrMsg { get; set; }
        public string Action { get; set; } = string.Empty;
        public int ID { get; set; }
    }


    public class DesignationMaster
    {
        public string Desg_Name { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        //public string ErrMsg { get; set; }
        public string Action { get; set; }
        public int ID { get; set; }


    }

    public class VehicleTypeMaster
    {
        public string VehicleType { get; set; }
        public int MISSequence { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        //public string ErrMsg { get; set; }
        public bool IsOnline { get; set; }
        public string DisplayName { get; set; }
        public string Action { get; set; }
        public int VehicleTypeID { get; set; }

    }


    public class VehicleMaster
    {
        public string VehicleBase { get; set; }
        public int VehicleName { get; set; }
        public int PassengerCapacity { get; set; }
        public int BaggageCapacity { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        //public string ErrMsg { get; set; }
        public string Action { get; set; }
        public int ID { get; set; }

    }


    public class GuideInfoMaster
    {

        public string Name { get; set; }
        public string Salutation { get; set; }
        public string Gender { get; set; }
        public int State_IATACode { get; set; }
        public string City_IATACode { get; set; }
        public string StarRating { get; set; }
        public string PhoneNo { get; set; }
        public string MobileNo { get; set; }
        public string Address { get; set; }
        public string Languages { get; set; }
        public bool? IsActive { get; set; }

        public Guid OperationBy { get; set; }
        public string Ranking { get; set; }
        public string CityName { get; set; }
        public string StateName { get; set; }
        public string IATACode { get; set; }

        public bool? IsDOT { get; set; }
        public bool? IsState { get; set; }
        public bool? IsASI { get; set; }
        //public string ErrMsg { get; set; }
        public string Action { get; set; }
        public string StateIATACode { get; set; }
        public int GuideID { get; set; }
        public bool? Active { get; set; }
        public string? LanguagesID { get; set; }

    }



    public class LanguageMaster
    {
        public string ID { get; set; }
        public string Language { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        //        public string ErrMsg { get; set; }
        public string Action { get; set; }
        public int IDS { get; set; }
    }


    public class NationalityMaster
    {
        public string? Nationality { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public string? HeaderInfo_Nationality { get; set; }
        //        public string ErrMsg { get; set; }
        public string Action { get; set; }
        //public string Operation { get; set; }
        public int ID { get; set; }

    }



    public class FacilityInformationMaster
    {
        public int FacilityInfoID { get; set; }
        public string InformationName { get; set; }
        public string ImageName { get; set; }
        public byte[] Image { get; set; }
        public int MISSequenceNo { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }

        public string Action { get; set; }
    }

    public class LocationMaster
    {
        public int LocationID { get; set; }              // Corresponds to LocationID (Primary Key)
        public string LocationCode { get; set; }         // Corresponds to LocationCode
        public string LocationValue { get; set; }        // Corresponds to LocationValue
        public int SequenceNo { get; set; }              // Corresponds to SequenceNo
        public bool IsActive { get; set; }               // Corresponds to IsActive (boolean)
        public string Operation { get; set; }            // Corresponds to Operation (e.g., 'Insert', 'Update', 'Delete')
        public Guid OperationBy { get; set; }            // Corresponds to OperationBy (User GUID)
        public DateTime OperationOn { get; set; }        // Corresponds to OperationOn (Date of the operation)
        public int? OldID { get; set; }  // Corresponds to OldID (nullable, for updating data)

        public string Action { get; set; }

        // Optional: Logic for validating location data before an insert/update operation
        public bool IsValid()
        {
            // Perform any necessary validation, e.g.:
            if (string.IsNullOrEmpty(LocationCode) || string.IsNullOrEmpty(LocationValue))
            {
                return false; // LocationCode and LocationValue must not be null or empty
            }

            if (SequenceNo <= 0)
            {
                return false; // SequenceNo should be positive
            }

            return true;
        }

        // Method to generate a new GUID for OperationBy if not provided
        public void GenerateOperationInfo()
        {
            if (OperationBy == Guid.Empty)
            {
                OperationBy = Guid.NewGuid(); // Set a new GUID for the user performing the operation
            }

            if (OperationOn == DateTime.MinValue)
            {
                OperationOn = DateTime.UtcNow; // Set the current time as OperationOn if not provided
            }
        }
    }

    public class ZoneMaster
    {
        public int ZoneID { get; set; } // IDENTITY column, will auto-generate
        public string ZoneName { get; set; }
        public string HeaderInfo_Zone { get; set; }
        public bool IsActive { get; set; }
        //   public string Operation { get; set; }
        public Guid OperationBy { get; set; }

        public string Action { get; set; }
        public string HotelName { get; set; }
        public string CityName { get; set; }
        public List<string> HotelNameList =>
        string.IsNullOrEmpty(HotelName)
        ? new List<string>()
            : HotelName.Split(',').Select(h => h.Trim()).Distinct().ToList();

        public List<string> CityNameList =>
            string.IsNullOrEmpty(CityName)
                ? new List<string>()
                : CityName.Split(',').Select(c => c.Trim()).Distinct().ToList();
    }

    public class HeaderMaster
    {
        public int HeaderID { get; set; }
        public string HeaderCode { get; set; }
        public string HeaderValue { get; set; }
        public int SequenceNo { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public int? OldID { get; set; }  // Nullable

        public string Action { get; set; }
    }


    public class LandMarksMaster
    {
        public int LandMarkID { get; set; }
        public string LandMarkName { get; set; }
        public bool IsActive { get; set; }
        // public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public int OldID { get; set; }  // Nullable field for OldID

        public string Action { get; set; }

        // You can add additional properties or methods for business logic if needed
    }

    public class TransferMaster
    {
        public int TransferID { get; set; }
        public string TransferCode { get; set; }
        public string TransferValue { get; set; }
        public int Sequence { get; set; }
        public bool IsActive { get; set; }
        //public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        //public DateTime OperationOn { get; set; }
        //public int? OldID { get; set; } // Nullable field as per table definition

        public string Action { get; set; }
    }


    public class AgentGroupMasterodel
    {
        public int AgentGroupID { get; set; }
        public string AgentGroupCode { get; set; }
        public string AgentGroupName { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationDate { get; set; }
        public int? OldID { get; set; }

        public string Action { get; set; }
    }



    public class HotelPreferredMaster
    {
        public int HotelID { get; set; }
        public DateTime? ValidFrom { get; set; }
        public DateTime? ValidTo { get; set; }
        public bool? IsPreferred { get; set; }
        public Guid? OperationBy { get; set; }
        public string Action { get; set; }
        public int? PreferredHotelID { get; set; }
        public string HotelName { get; set; }
        public string CityCode { get; set; }
        public string Rating { get; set; }
        public string CityName { get; set; }
    }




    public class CountryMarketMappingMaster
    {
        public string Country_IATACode { get; set; }
        public string CountryName { get; set; } = string.Empty;
        public string MarketName { get; set; } = string.Empty;
        public int Market_ID { get; set; }
        public bool IsActive { get; set; }
        //public string Operation { get; set; } = string.Empty;
        public Guid OperationBy { get; set; }
        //public DateTime OperationOn { get; set; }

        public string Action { get; set; }

        public int ID { get; set; }

        //[DefaultValue("")]
        //public string? returnCode { get; set; } = string.Empty;
        //[DefaultValue("")]
        //public string? returnMessage { get; set; } = string.Empty;

    }

    public class ModeOfTravelMaster
    {
        public string MOT { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public string Action { get; set; } = string.Empty;
        public int? ID { get; set; }
    }


    public class ClassTypeMaster
    {
        public int ID { get; set; }
        public int MotId { get; set; }
        public int MOT { get; set; }
        public string Class { get; set; }
        public string MOTNAME { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public string Action { get; set; }
    }

    //public class TransportServiceMaster
    //{
    //    [Key]
    //    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    //    public int Code { get; set; }

    //    [Required]
    //    [StringLength(500)]
    //    public string Name { get; set; }

    //    public byte? ModeOfTransport { get; set; }

    //    [StringLength(500)]
    //    public string ShortDescription { get; set; }

    //    public string DetailedDescription { get; set; }

    //    [Required]
    //    public bool IsActive { get; set; }

    //    //[Required]
    //    //[StringLength(10)]
    //    //public string Operation { get; set; }

    //    [Required]
    //    public Guid OperationBy { get; set; }

    //    //[Required]
    //    //public DateTime OperationOn { get; set; }

    //    [StringLength(10)]
    //    public string OldID { get; set; }

    //    [Required]
    //    public bool IsPreferred { get; set; }

    //    public int? Pickup { get; set; }

    //    public int? DropOff { get; set; }

    //    public bool? IsViceVersa { get; set; }

    //    public long? TotalDays { get; set; }

    //    public string Action { get; set; }
    //}


    public class TransportServiceMaster
    {

        public int Code { get; set; }

        public string Name { get; set; }

        public int ModeOfTransport { get; set; }

        public string MOT { get; set; }


        public string ShortDescription { get; set; }

        public string DetailedDescription { get; set; }

        public bool IsActive { get; set; }

        public Guid OperationBy { get; set; }

        public string OldID { get; set; }

        public bool IsPreferred { get; set; }
        public int? Pickup { get; set; }

        public int? DropOff { get; set; }

        public bool IsViceVersa { get; set; }

        public long? TotalDays { get; set; }

        public string Action { get; set; }
    }



    public class GuideServiceMaster
    {
        public int Code { get; set; }
        public string Name { get; set; }
        public string ShortDescription { get; set; }
        public string DetailedDescription { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public bool IsPreferred { get; set; } = false;
        //   public string ErrMsg { get; set; } = string.Empty;
        public string Action { get; set; } = string.Empty;
    }


    public class SpecialServiceMaster
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string ShortDescription { get; set; }
        public string DetailedDescription { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public bool IsPreferred { get; set; }
        public string Action { get; set; }
        public bool Active { get; set; }
    }



    public class MonumentMaster
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public int StateIATACode { get; set; }
        public string CityIATACode { get; set; }
        public string Timing { get; set; }
        public string ClosedOn { get; set; }
        public string Holidays { get; set; }
        public string Remarks { get; set; }
        public string ShortDescription { get; set; }
        public string DetailedDescription { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public bool IsPreferred { get; set; }
        //public string ErrMsg { get; set; }
        public string Action { get; set; }
        public string CityName { get; set; }
        public string StateName { get; set; }

    }

    public class MasterReq
    {
        public string requestText { get; set; }
    }


    public class BizPartnerGroupMaster
    {
        public int? HotelGroupID { get; set; }
        public string IATACode { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public string Action { get; set; } = string.Empty;
    }

    public class HotelRatingMaster
    {
        public int ID { get; set; }  // IDENTITY(1,1) - Primary key
        public int? Ratings { get; set; }  // Nullable int for ratings
        public string Code { get; set; }  // NOT NULL varchar(10)
        public string Description { get; set; }  // NOT NULL varchar(50)
        public int MISSequence { get; set; }  // NOT NULL int
        public bool IsActive { get; set; }  // NOT NULL bit (true/false)
        public string Operation { get; set; }  // NOT NULL varchar(10)
        public Guid OperationBy { get; set; }  // NOT NULL uniqueidentifier (Guid)
        public DateTime OperationOn { get; set; }  // NOT NULL datetime
        public int? OldID { get; set; }  // Nullable int for OldID
        public string Action { get; set; }
        public string HotelRatingValue { get; set; }
    }


    public class RoomCategoryMaster
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        //   public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public int? HotelID { get; set; }
        //  public DateTime OperationOn { get; set; }
        // public int? OldID { get; set; }

        public string Action { get; set; }
    }


    public class MealPlanMaster
    {
        public int ID { get; set; }

        public string Code { get; set; }

        public string Description { get; set; }

        public bool Breakfast { get; set; }

        public bool Lunch { get; set; }

        public bool Dinner { get; set; }

        public bool IsActive { get; set; }

        public string Operation { get; set; }

        public Guid OperationBy { get; set; }

        public DateTime OperationOn { get; set; }

        public int? OldID { get; set; } // Nullable to allow for NULL values

        public string Action { get; set; }
    }


    public class HotelRateTypeMaster
    {
        public int Rate_Type_ID { get; set; }
        public string Rate_Type_Name { get; set; }
        public string Rate_Type_Code { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public string Action { get; set; }
        public int OldID { get; set; }
    }



    public class RuleGroupMaster
    {
        public int ID { get; set; } // The unique identifier for the Rule Group
        public string Name { get; set; } // Name of the Rule Group
        public bool IsActive { get; set; } // Indicates if the Rule Group is active
                                           //  public string Operation { get; set; } // Operation (e.g., 'Create', 'Update', etc.)
        public Guid OperationBy { get; set; } // The User ID who performed the operation
                                              //   public DateTime OperationOn { get; set; } // The Date and Time when the operation was performed

        public string Action { get; set; }
        public string Rule { get; set; }
    }

    public class RuleHeadersMaster
    {
        public int RuleGroupID { get; set; }
        public string Header { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public bool IsMandatory { get; set; }
        public Guid OperationBy { get; set; }
        public int SequenceNo { get; set; } = 0;
        public int RuleHeaderType { get; set; } = 0;
        public string RuleHeaderTypeName { get; set; }
        public string Action { get; set; }
        public string RuleGroup { get; set; }
        public bool Active { get; set; }
        public int? ID { get; set; }
    }

    //public class RespModel<T>
    //{
    //    public string returnCode { get; set; } = string.Empty;
    //    public string returnMessage { get; set; } = string.Empty;
    //    public string token { get; set; } = string.Empty;
    //    public T data { get; set; }
    //    public List<T> dataList { get; set; }
    //}




    #region XORemarks starts here
    public class XORemarksMaster
    {
        public int XOID { get; set; }
        public string XoRemarks { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public string Action { get; set; }
    }
    #endregion XORemarks ends here

    #region Agent Markup starts here
    public class AgentMarkupMaster
    {
        public int AgentCategoryID { get; set; }
        public string CodeDescription { get; set; }
        public DateTime? ValidFrom { get; set; }
        public DateTime? ValidTo { get; set; }
        public decimal Hotel { get; set; }
        public decimal Transport { get; set; }
        public decimal Guide { get; set; }
        public decimal Monument { get; set; }
        public decimal FlightTrain { get; set; }
        public decimal SpecialService { get; set; }
        public decimal Package { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public int SupplierID { get; set; }
        public string Action { get; set; }
        public int AgentMarkupID { get; set; }
        public string CategoryValue { get; set; }
        public string VendorName { get; set; }
        public string AgentName { get; set; }
    }

    #endregion Agent Markup ends here

    #region Destination Header starts here
    public class DestinationHeaderMaster
    {
        public int DestinationHeaderID { get; set; }
        public string DestinationHeaderCode { get; set; }
        public string DestinationHeader { get; set; }
        public int MISSequenceNo { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public int OldID { get; set; }
        public string Action { get; set; }
    }
    #endregion Destination Header ends here 

    #region Destination Details starts here
    public class DestinationDetailsMaster
    {
        public int DestinationDetailID { get; set; }
        public string CityIATACode { get; set; }
        public int DestinationHeaderID { get; set; }
        public string Details { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public int OldID { get; set; }
        public string Action { get; set; }
    }
    #endregion Destination Details ends here

    #region Salutation starts here
    public class SalutationMaster
    {
        public int SalutationID { get; set; }
        public string Salutation { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public int OldID { get; set; }
        public string Action { get; set; }
    }
    #endregion Salutation ends here

    #region Year starts here
    public class YearMaster
    {
        public int YearID { get; set; }
        public string YearCode { get; set; }
        public int CompanyID { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public int OldID { get; set; }
        public int FiscalYear { get; set; }
        public bool IsLocked { get; set; }
        public int? EntityID { get; set; }
        public string Action { get; set; }
        public int Old_ID { get; set; }
        public string CompanyName { get; set; }
        public string LegalName { get; set; }
        public int VID { get; set; }
        public string Variant { get; set; }


        public string variantDuration { get; set; }
        public bool? IsActive { get; set; }
        public Guid OperationBy { get; set; }

    }
    #endregion Year ends here

    #region Currency starts here
    public class CurrencyMaster
    {
        public string Code { get; set; }
        public string Name { get; set; }
        public string Symbol { get; set; }
        public bool IsActive { get; set; }
        //public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        //public DateTime OperationOn { get; set; }
        public string OldID { get; set; }
        public string Action { get; set; }
    }
    #endregion Currency ends here

    #region Currency Conversion starts here
    public class CurrencyConversionMaster
    {
        public int ID { get; set; }
        public string FromCurrency { get; set; }
        public string ToCurrency { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public Decimal PurchaseRate { get; set; }
        public Decimal SalesRate { get; set; }
        public Decimal CostingRate { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public string Action { get; set; }
    }
    #endregion Currency Conversion ends here
    /*
        #region Export Hotel Info starts here
        public class ExportHotelInfoMaster
        {

        }
        #endregion Export Hotel Info ends here
    */
    #region Other Taxes starts here
    public class OtherTaxesMaster
    {
        public int Other_Tax_Id { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public DateTime Tax_From_Date { get; set; }
        public DateTime Tax_To_Date { get; set; }
        public string Action { get; set; }
        public string Tax_Type { get; set; }
        public string GSTType { get; set; }
        public string ServiceTaxDescription { get; set; }
        public int ST_Tax_ID { get; set; }
        public int GSTID { get; set; }
    }
    #endregion Other Taxes ends here

    #region SAC starts here
    public class SACMaster
    {
        public int ID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationDate { get; set; }
        public bool ForTkt { get; set; }
        public string Action { get; set; }
    }

    public class SACMasterExportModel
    {
        public int ID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public string EmpName { get; set; }
        public DateTime OperationDate { get; set; }
        public bool ForTkt { get; set; }
        public string Action { get; set; }
    }
    #endregion SAC ends here

    #region Service Tax New starts here
    public class ServiceTaxNewMaster
    {
        public int Tax_ID { get; set; }
        public string Tax_Desc { get; set; }
        public int GSTID { get; set; }
        public bool IsActive { get; set; }
        public DateTime? Tax_From_Date { get; set; }
        public DateTime? Tax_To_Date { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public string GSTType { get; set; }
        public decimal GSTPercentage { get; set; }
        public string State_Code { get; set; }
        public bool IsCommercial { get; set; }
        public string SAPCode { get; set; }
        public string Action { get; set; }
        public string GSTTypeName { get; set; }
        public decimal? Tax_Perc { get; set; }
        public string GSTPercentageText { get; set; }
    }


    #endregion Service Tax New ends here

    #region Other Service Tax New starts here
    public class OtherServiceTaxNewMaster
    {
        public int? Tax_ID { get; set; }
        public string Tax_Desc { get; set; }
        public decimal? Tax_Percentage { get; set; }
        public bool IsActive { get; set; }
        public int? Tax_Category { get; set; }
        public DateTime? Tax_From_Date { get; set; }
        public DateTime? Tax_To_Date { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public int? Other_Tax_Id { get; set; }
        public int? ST_Tax_ID { get; set; }
        public string Action { get; set; }
        public int? Tax_Type { get; set; }
        public string GSTType { get; set; }
        public string ServiceTaxDescription { get; set; }
        public int? GSTID { get; set; }
        public bool IsCommercial { get; set; }
        public string SAPCode { get; set; }
        public string OtherTax_Id { get; set; }

    }
    #endregion Other Service Tax New ends here

    #region BankMaster starts here
    public class BankMaster
    {
        public int AccountBankMasterID { get; set; }
        public int BankID { get; set; }
        public string BankName { get; set; }
        public string Name { get; set; }
        public string BnkDetails { get; set; }
        public string CompanyName { get; set; }
        public int CompanyID { get; set; }
        public string AccountName { get; set; }
        public string Details { get; set; }
        public bool isTTCBankDetails { get; set; }
        public bool isActive { get; set; }
        public bool IsVirtualAccount { get; set; }
        public string AccountPrefix { get; set; }
        public bool IsRedDotBankDetails { get; set; }
        public string RefID { get; set; }
        public string Currency { get; set; }
        //public string BankAccountDetails { get; set; }
        public bool IsTTCBank { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }

        public string AccountNo { get; set; }
        public bool IsVirtual { get; set; }

        public bool IsRedDot { get; set; }

        public string Action { get; set; }
        //public string Details { get; set; }

    }
    #endregion BankMaster ends here

    #region Business Type starts here
    public class BusinessTypeMaster
    {
        public int BussinessModuleID { get; set; }
        public string BusinessModuleName { get; set; }
        public bool IsActive { get; set; }
        public Guid OperationBy { get; set; }
        public bool IsTTCLogo { get; set; }
        public string Action { get; set; }

    }
    #endregion Business Type ends here

    #region Transport Service New starts here
    public class TransportServiceNewMaster
    {

    }
    #endregion Transport Service New ends here

    #region Bank Accounts starts here
    public class BankAccountsMaster
    {

        public int AccountBankMasterID { get; set; }
        public string BankAccountName { get; set; }
        public string BankAccountDetails { get; set; }
        public bool IsActive { get; set; } = true;
        public Guid OperationBy { get; set; }
        public string Action { get; set; } = string.Empty;
        public string Currency { get; set; }
        public int? LegalEntityId { get; set; }
        public string AccountName { get; set; }
        public string AccountNumber { get; set; }
        public string AccountPrefix { get; set; }
        public bool IsVirtualAccount { get; set; }
        public string LegalName { get; set; }

    }

    #endregion Bank Accounts ends here

    #region hoteltype starts here
    public class HotelTypeMaster
    {
        public int? HotelTypeID { get; set; }
        public string TypeValue { get; set; }
        public string Action { get; set; }
        public bool? IsActive { get; set; }
        public Guid? OperationBy { get; set; }

    }

    #endregion hoteltype ends here

    public class BankDetails
    {
        public string Action { get; set; }
        public int BankID { get; set; }
        public string BankName { get; set; }

    }
    #region AgentCategoryMaster starts here
    public class AgentCategoryMaster
    {
        public int CategoryID { get; set; }
        public string CategoryCode { get; set; }
        public string CategoryValue { get; set; }
        public bool IsActive { get; set; }
        public string Action { get; set; }
        public Guid OperationBy { get; set; }
    }
    #endregion AgentCategoryMaster ends here

    #region MSMEType starts here
    public class MSMEType
    {
        public int MSMETypeID { get; set; }
        public string MSMETypeName { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
    }
    #endregion MSMEType ends here

    #region VendorPreferred starts here
    public class VendorPreferred
    {
        public int VendorID { get; set; }
        public int PreferredVendorID { get; set; }
        public DateTime? ValidFrom { get; set; }
        public DateTime? ValidTo { get; set; }
        public bool IsActive { get; set; }
        public bool IsPreferred { get; set; }
        public Guid OperationBy { get; set; }
        public string VendorName { get; set; }
        public string Action { get; set; }
    }
    #endregion VendorPreferred ends here

    #region SelectFiscalVariant starts here
    public class SelectFiscalVariant
    {
        public string Action { get; set; }
        public int ID { get; set; }
        public string Variant { get; set; }
        public string variantDuration { get; set; }
    }
    #endregion SelectFiscalVariant starts here

    #region GetAgentCategoryMaster starts here
    public class GetAgentCategoryMaster
    {
        public string CategoryCode { get; set; }
        public int CategoryID { get; set; }
        public string CategoryValue { get; set; }
        public bool IsActive { get; set; }
    }
    #endregion GetAgentCategoryMaster starts here

    public class New_CurrencyMaster
    {
        public int? Id { get; set; }
        public string CurrencyCode { get; set; }
        public string Code { get; set; }
        public string Symbol { get; set; }
        public DateTime? Effective_Date { get; set; }
        public decimal? Hedge_Perc { get; set; }
        public bool IsActive { get; set; } = true;
        public string Action { get; set; }
        public string Name { get; set; }
        public Guid OperationBy { get; set; }

    }

    public class New_CurrencyConversion
    {
        public int FromCurrencyId { get; set; }
        public string FromCurrency { get; set; }
        public int ToCurrencyId { get; set; }
        public string ToCurrency { get; set; }
        public decimal Actual_Value { get; set; }
        public decimal? Hedge_Perc { get; set; }
        public DateTime? EffectiveDate { get; set; } = null;
        public decimal? Purchase_Value { get; set; }
        public decimal? Sales_Value { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public int? UpdatedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string Action { get; set; }
    }

    public class Destination_Master
    {
        public string ID { get; set; }
        public string SelectedValues { get; set; }
        public string Name { get; set; }
        public string Action { get; set; }
    }

    public class Customer_Master
    {
        public string Action { get; set; }
        public int? ID { get; set; }
        public string Name { get; set; }
        public string City { get; set; }
        public string Email { get; set; }
        public string MobileNumber { get; set; }
    }

    public class ItineraryNotes
    {
        public string ID { get; set; }
        public string Active { get; set; }
        public string City_IATACode1 { get; set; }
        public string City_IATACode2 { get; set; }
        public string Country_IATACode { get; set; }
        public string City_IATACode { get; set; }
        public string Type { get; set; }
        public string Header { get; set; }
        public string Description { get; set; }
        public bool IsDefault { get; set; }
        public int SeqNo { get; set; }
        public bool IsActive { get; set; }
    }

    public class ItineraryInclusions
    {
        public string ID { get; set; }
        public string Active { get; set; }
        public string City_IATACode1 { get; set; }
        public string City_IATACode2 { get; set; }
        public string Country_IATACode { get; set; }
        public string City_IATACode { get; set; }
        public string Type { get; set; }
        public string Header { get; set; }
        public string Description { get; set; }
        public bool IsDefault { get; set; }
        public int SeqNo { get; set; }
        public bool IsActive { get; set; }
    }

    public class ItineraryExclusions
    {
        public string ID { get; set; }
        public string Active { get; set; }
        public string City_IATACode1 { get; set; }
        public string City_IATACode2 { get; set; }
        public string Country_IATACode { get; set; }
        public string City_IATACode { get; set; }
        public string Type { get; set; }
        public string Header { get; set; }
        public string Description { get; set; }
        public bool IsDefault { get; set; }
        public int SeqNo { get; set; }
        public bool IsActive { get; set; }
    }

    public class SearchHotelCityModel
    {
        public string CityCode { get; set; }
        public int ID { get; set; }
        public string Name { get; set; }
        public string Action { get; set; }
        public string CityName { get; set; }
        public bool IsCityActive  { get; set; }
        public bool IsHotelActive { get; set; }

    }

    public class LockFileCodeXoRequestModel
    {
        public string XOID { get; set; }             // Maps to @XOID
        public long BookingID { get; set; }           // Maps to @BookingID
        public int YearID { get; set; }              // Maps to @YearID
        public string Action { get; set; } = "S";    // Maps to @Action, default is 'S'
    }
}
